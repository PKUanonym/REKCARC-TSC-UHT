# Lab4挑战：实现支持任意大小的内存分配算法

## 运行说明

在Lab4的源代码中给出的SLOB算法实际上是First-Fit算法，因此我此次实现的任意大小内存分配算法为Best-Fit算法，主要实现了`best_fit_alloc`函数。

为了测试代码实现的正确性，仅仅需要将`kmalloc.c`中第`58`行的：

```c
// #define USE_BEST_FIT
```

解除注释即可。

重新编译运行uCore，可以看到uCore正常运行，说明使用`kmalloc`分配的`vma_struct`和`proc_struct`可以正常获取到内存空间。

## 实现思路

首先确定所实现`kmalloc`在uCore内存管理中所处的地位，才能更好地理解函数调用关系。

在内核中，uCore的内存管理分为物理内存管理`pmm`和虚拟内存管理`vmm`。虚拟内存管理模块只负责管理页式地址映射关系，不负责具体的内存分配。而物理内存管理模块`pmm`不仅要管理连续的物理内存，还要能够向上提供分配内存的接口`alloc_pages`，分配出的物理内存区域可以转换为内核态可访问的区域（只要偏移`KERNBASE`）即可；也可以做地址映射转换给用户态程序使用。

但是，`alloc_pages`仅仅提供以页为粒度的物理内存分配，在uCore内核中，会频繁分配小型动态的数据结构（诸如`vma_struct`和`proc_struct`），这样以页为粒度进行分配既不节省空间，速度还慢，需要有一个接口能够提供更加细粒度的内存分配与释放工作，这就是slab和slob出现的原因：他们是一个中间件，底层调用`alloc_pages`接口，上层提供`kmalloc`接口，内部通过一系列机制管理页和内存小块的关系。需要注意的一点是：用户态的`libc`提供的`malloc`接口并不是利用了与`kmalloc`相同的机制，而是由`libc`自己管理的一套小型内存分配机制。（回忆汇编课程上讲过使用`brk`系统调用完成的内存申请实际上是以页为粒度的）

仔细阅读Lab4中原有的slob代码，在每个小块内存的头部都存放了该块的大小和下一个空闲块的地址。`kmalloc`函数会首先判断需要分配的空间是否跨页，如果是则直接调用`alloc_pages`进行分配，否则就调用`slob_alloc`进行分配。巧妙的一点是，为了管理所有申请的连续物理空间页，Lab4建立了`bigblock`这一数据结构，而这个数据结构自身所占的内存空间如何分配呢？结论是`slob_alloc`！Lab4就这样将二者耦合到了一起。

具体到`Best-Fit`算法的实现，实际很简单，仅仅需要在扫描空闲链表的时候动态记录与更新最好的块的地址即可，扫描完成之后，再选出刚刚找到的最合适的空间进行分配即可。无论是`First-Fit`、`Best-Fit`还是`Worst-Fit`，其释放的合并策略都是相同的，因此只需要修改`slob_alloc`函数即可。

## 实验代码

```c
static void *best_fit_alloc(size_t size, gfp_t gfp, int align)
{
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
	// This best fit allocator does not consider situations where align != 0
	assert(align == 0);
	int units = SLOB_UNITS(size);

	unsigned long flags;
	spin_lock_irqsave(&slob_lock, flags);

	slob_t *prev = slobfree, *cur = slobfree->next;
	int find_available = 0;
	int best_frag_units = 100000;
	slob_t *best_slob = NULL;
	slob_t *best_slob_prev = NULL;

	for (; ; prev = cur, cur = cur->next) {
		if (cur->units >= units) {
			// Find available one.
			if (cur->units == units) {
				// If found a perfect one...
				prev->next = cur->next;
				slobfree = prev;
				spin_unlock_irqrestore(&slob_lock, flags);
				// That's it!
				return cur;
			}
			else {
				// This is not a prefect one.
				if (cur->units - units < best_frag_units) {
					// This seems to be better than previous one.
					best_frag_units = cur->units - units;
					best_slob = cur;
					best_slob_prev = prev;
					find_available = 1;
				}
			}

		}

		// Get to the end of iteration.
		if (cur == slobfree) {
			if (find_available) {
				// use the found best fit.
				best_slob_prev->next = best_slob + units;
				best_slob_prev->next->units = best_frag_units;
				best_slob_prev->next->next = best_slob->next;
				best_slob->units = units;
				slobfree = best_slob_prev;
				spin_unlock_irqrestore(&slob_lock, flags);
				// That's it!
				return best_slob;
			}
			// Initially, there's no available arena. So get some.
			spin_unlock_irqrestore(&slob_lock, flags);
			if (size == PAGE_SIZE) return 0;

			cur = (slob_t *)__slob_get_free_page(gfp);
			if (!cur) return 0;

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
}
```
