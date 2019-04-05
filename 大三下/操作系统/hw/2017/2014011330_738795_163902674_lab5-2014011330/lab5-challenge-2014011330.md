# Lab5挑战：实现Copy on Write机制

## 运行说明

为了测试代码实现的正确性，仅仅需要将`vmm.h`中第`10`行的：

```c
// #define COPY_ON_WRITE
```

解除注释即可。

重新编译运行uCore，可以看到uCore正常运行，使用`make grade`对各个应用程序进行测试也可以得到满分，说明COW机制实现基本正确。具体的输出及其解释请见最后一节。

## 实现思路

为了实现COW机制，需要在每次执行`fork`拷贝`mm_struct`的时候，将新进程的页表和旧进程的页表项同时指向相同的物理内存区域，并将页表项设为只读。这样以来，当其中**任何一个**进程修改了相应的内存时，就会触发`page_fault`异常，此时再将相应的页进行拷贝重写即可。需要注意的是，修改只读仅仅是修改页表项，并不修改`vma_struct`的相关记录，这用于判断`page_fault`究竟是由COW产生的，还是由真实的页访问异常产生的。

代码方面，主要修改了`pmm.c`中的`copy_range`函数，核心代码为：

```c
uint32_t perm = (*ptep & (PTE_U | PTE_P));
struct Page *page = pte2page(*ptep);
assert(page != NULL);
// Set the new mm to be readonly.
page_insert(to, page, start, perm);
// Set the old mm to be readonly
page_insert(from, page, start, perm);
```

可以看到`from`的页表和`to`的页表中，都指向了`ptep`对应的物理内存。使用`page_insert`进行页面权限的修改，是因为该函数能够自动处理物理页面引用和TLB刷新的事宜，比较方便。

另外，为了能够使`page_fault`函数能正确处理COW引发的错误，修改了`vmm.c`的`do_pgfault`函数，核心代码为：

```c
if (*ptep & PTE_P) {
	// Read-only possibly caused by COW.
	if (vma->vm_flags & VM_WRITE) {
		// If ref of pages == 1, it is not shared, just make pte writable.
		// else, alloc a new page, copy content and reset pte.
		// also, remember to decrease ref of that page!
		struct Page* p = pte2page(*ptep);
		assert(p != NULL);
		assert(p->ref > 0);
		if (p->ref > 1) {
			struct Page *npage = alloc_page();
			assert(npage != NULL);
			void * src_kvaddr = page2kva(p);
			void * dst_kvaddr = page2kva(npage);
			memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
			// addr already ROUND down.
			page_insert(mm->pgdir, npage, addr, ((*ptep) & PTE_USER) | PTE_W);
			// page_ref_dec(p);
			cprintf("Handled one COW fault at %x: copied\n", addr);
		} else {
			page_insert(mm->pgdir, p, addr, ((*ptep) & PTE_USER) | PTE_W);
			cprintf("Handled one COW fault: reused\n");
		}
	} else {
		cprintf("Not a COW read-only fault.\n");
		goto failed;
	}
} else {
	// 处理缺页
}
```

在实际的复杂页面引用关系中，很难确定是否应该拷贝物理内存页，还是应该直接将`pte`设为只读。假设进程A和进程B共享了同一块物理内存区域p，当进程A访问p触发`pgfault`的时候，应该拷贝p为p'，并将p'设置为可读可写，但是这里如果再画蛇添足，将p也设置成可读可写就大错特错了。首先在实现上就难以根据物理页找到引用它的`pte`，再者如果有多个进程（例如B,C,D,...）也在通过COW共享p的时候就会造成严重的错误。因此，在这里通过页面的`ref`字段进行判断，就能够避免上述错误的发生：如果`ref`是1，则说明COW机制造成的共享已经失效，直接将`pte`的权限恢复成可读可写即可；否则需要单独克隆一份p'。

另外，`Not a COW read-only fault.`分支实际上在前面的代码中处理过了，不可能执行到这里。

## 测试输出

运行`forktest`程序，输出如下（开启COW之后就会输出这些调试信息）：

```
++ setup timer interrupts
kernel_execve: pid = 2, name = "forktest".
Handled one COW fault at affff000: copied
Handled one COW fault at affff000: copied
Handled one COW fault at affff000: copied
...
Handled one COW fault at affff000: copied

Handled one COW fault: reused
I am child 31
Handled one COW fault: reused
I am child 30
Handled one COW fault: reused
I am child 29
...
Handled one COW fault: reused
I am child 0
forktest pass.
```

当主程序fork之后返回，即会对自己的栈进行修改，这时需要拷贝原始物理页到一个新的物理页。因此在fork的时候会有许多`copied`输出；而当主程序进入等待状态之后，子进程开始执行，由于之前父进程在修改栈的时候已经将共享关系破坏了，所以直接使用当前的物理页，简单该一下权限即可。

需要注意的是，主进程更改的仅仅是栈的内容，对于代码段等没有修改，因此只有虚拟地址为`0xAFFFF000`的物理页没有被共享，但其他代码段（例如`va 0x00800000`处）还是被共享的。因此这样做使得操作系统的效率和内存利用率有了一定的提高。
