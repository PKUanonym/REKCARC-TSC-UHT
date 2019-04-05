# Lab5实验报告

## 练习1

### 实现过程

Trapframe为从内核态向用户态转换时需要向寄存器中填写的内容，对于新建的进程，需要填写的内容和意义如下：

- `tf_cs`: 用户态的代码段寄存器，需要设置为`USER_CS`
- `tf_ds, tf_es, tf_ss`: 用户态数据段寄存器，需要设置为`USER_DS`
- `tf_esp`: 用户态的栈指针，需要设置为`0xB0000000`
- `tf_eip`: 用户态的代码指针，需要设置为用户程序的起始地址（一般为`user.ld`指定的`0x00800020`）
- `tf_eflags`: 一些用户态的设置信息。

### 用户态进程被选中执行到第一条语句的过程

在`schedule`函数中，会调用函数`proc_run`，这个函数的核心语句为：

```c
current = proc;
load_esp0(next->kstack + KSTACKSIZE);
lcr3(next->cr3);
switch_to(&(prev->context), &(next->context));
```

其中最后一条语句最为关键，虽然`switch_to`使用汇编语言编写，但也可以理解成一个函数，但是这个函数内部在返回的时候就会使得程序指针、栈指针全部跳转到新进程。因此该函数需要存储`prev`进程的上下文，并通过一系列汇编语句将CPU的寄存器全部置为`next`进程执行的上下文。

这时，CPU处于`next`进程的内核态，程序指针在`forkrets`处，这个函数定义如下：

```c
// return falls through to trapret...
.globl __trapret
__trapret:
// restore registers from stack
popal

// restore %ds, %es, %fs and %gs
popl %gs
popl %fs
popl %es
popl %ds

// get rid of the trap number and error code
addl $0x8, %esp
iret

.globl forkrets
forkrets:
// set stack to this new process's trapframe
movl 4(%esp), %esp
jmp __trapret
```

回忆：uCore中一个进程的新建方式，第一种在用户态中使用`SYS_fork`__系统调用__，第二种在内核态__函数调用__`do_fork`，但无论是上述哪一种方式，为了建立一个新的进程，都需要使用`SYS_exec`__系统调用__。在`forkrets`执行完毕之后，会调用`iret`弹出之前设置好的`trapframe`切换到`fork()`之后的代码进行执行，参考：

```c
// 内核态调用fork，子进程会返回到的地址
tf.tf_eip = (uint32_t)kernel_thread_entry;

// 用户态调用fork，子进程会返回到的地址
struct trapframe *tf = current->tf;
```

按照精确定义上来讲，`fork`在`iret`语句执行完毕后，就跳转到了新进程的代码，第一条指令就对应上面相应的定义。但实际上，如果要执行新进程，往往在`fork`之后还要调用`exec`，来加载读取ELF文件，这就需要进一步分析。

调用了`SYS_exec`之后，又会回到新进程的内核态，在内核态读取加载程序，设置新的`mm_struct`，页表，分配各种空间并将ELF文件解析并读取拷贝到内存中，最终也是设立好了新的`trapframe`。那么究竟是如何跳转到新ELF文件用户态的代码的呢？其实，在`load_icode`中已经修改了本层的`trapframe`：

```c
tf->tf_eip = elf->e_entry;
```

与`fork`返回的过程如出一辙，`trap_return`的时候，也会执行`iret`，将`elf->e_entry`更新到`eip`寄存器中，这时，新ELF文件在用户态的第一条指令就会随后执行了。

## 练习2

### 实现过程

根据注释进行实现即可，代码和解释如下：

```c
// 获取源物理页的虚拟地址
uintptr_t src_kvaddr = page2kva(page);
// 获取目的物理页的虚拟地址
uintptr_t dst_kvaddr = page2kva(npage);
// 拷贝内容
memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
// 设置页表的映射关系
page_insert(to, npage, start, perm);
```

### 如何实现COW机制

已经在挑战练习中实现，具体请见`lab5-challenge-2014011330.md`，这个时候`copy_range`就不需要执行`alloc_page`和`memcpy`过程了，节省了时间，提高了内存利用率。

## 练习3

`do_fork`函数：创建进程并初始化的主要函数。主要负责：创建PCB、分配内核栈、拷贝虚拟内存映射关系、设置`trapframe`、维护进程块的相互关系。uCore中为了存储进程之间的关系，使用了兄弟式的指针连接法。父进程存储的子进程指针为最新创建的进程，而子进程拥有兄指针和弟指针，分别指向创建更早和创建更晚的进程。

`do_execve`函数：主要任务是调用`load_icode`函数读取新的ELF文件，设置新的进程入口点，执行新的进程。

`do_wait`函数：有两种模式，一种只等待一个特定的进程（`pid != 0`），另一种等待任意一个进程；如果进程不是僵尸状态，则父进程进入等待状态，请求重新调度，否则销毁处于僵尸状态的子进程PCB。

`do_exit`函数：基本与`do_fork`相反，销毁相应的内存空间、维护进程链表关系、并将进程转换成僵尸状态（但是不释放PCB），最后请求调度器重新调度。

### 上述四个函数如何影响进程执行状态？

本质上都是通过修改`proc->state`实现，最终体现到调度器的策略选择上。

### 用户态进程状态生命周期图

|进程状态         |     意义         | 转换到该状态的函数调用 |
| ---------------|-----------------|------------------|
|PROC_UNINIT     |   未初始化        | alloc_proc |
|PROC_SLEEPING   |   睡眠状态       | try_free_pages, do_wait, do_sleep |
|PROC_RUNNABLE   |   就绪或正在运行  | proc_init, wakeup_proc |
|PROC_ZOMBIE     |   僵尸状态       | do_exit |

转换图（摘自`proc.c`，请拉大窗口查看）：
```
  alloc_proc                                 RUNNING
      +                                   +--<----<--+
      +                                   + proc_run +
      V                                   +-->---->--+
PROC_UNINIT -- proc_init/wakeup_proc --> PROC_RUNNABLE -- try_free_pages/do_wait/do_sleep --> PROC_SLEEPING --
                                           A      +                                                           +
                                           |      +--- do_exit --> PROC_ZOMBIE                                +
                                           +                                                                  +
                                           -----------------------wakeup_proc----------------------------------
```


## 实现中与参考答案的区别

- 练习1：基本相同。
- 练习2：与答案不谋而合。

## 实验中的重要知识点

本次实验中重要的知识点有：

- 练习1：进程的创建和执行
- 练习2：进程/线程的创建和空间分配
- 练习3：进程状态模型和调度器设计

而OS原理中很重要，但在实验中没有对应上的知识点有：

- 用户线程和轻量级进程
