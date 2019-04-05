# Lab4实验报告

## 练习1

### 实现过程

需要初始化的变量作用和初始化方法如下：

- state: 进程状态，初始化为PROC_UNINIT；
- pid: 进程pid，初始化为-1，防止与idle混淆；
- runs: 进程调度运行次数，初始化为0；
- kstack: 内核栈的虚拟地址（`0xC`开头），初始化为NULL；
- need_resched: 是否需要调度，不需要；
- parent: 父进程，初始化为NULL；
- mm: 虚拟内存管理器，初始化为NULL；
- cr3: 页表起始地址（物理地址），初始化为启动时使用的页表物理地址；
- flags: 进程标志，本Lab无用；
- name: 进程名字，需要清空。

### `context`和`trapframe`的作用

`context`用于进程切换，存储了当前CPU的上下文（寄存器、程序指针等等），在进程切换的时候调用`switch_to`时用到；`trapframe`是当前内核栈内存储的，当进入中断处理历程时用户态的上下文，用于内核态和用户态的转换，在`iret`时有用，同时在设置系统调用返回值或返回地址时也可以通过更改`trapframe`的内容实现。

当然，由于进程切换的时候都需要先进入内核态，所以一般`trapframe`存储的是用户态信息，`context`存储的是关于内核态的信息。

## 练习2

### 实现过程

根据注释进行实现即可，代码和解释如下：

```c
// 分配进程控制块（此时PCB还没有初始化）
proc = alloc_proc();
if (proc == NULL) {
  goto fork_out;
}

// 为PCB指定父进程
proc->parent = current;

// 分配两个页的内核栈空间给这个新的进程控制块
if (setup_kstack(proc) != 0) {
  goto bad_fork_cleanup_proc;
}

// 拷贝mm_struct，建立新进程的地址映射关系
if (copy_mm(clone_flags, proc) != 0) {
  goto bad_fork_cleanup_kstack;
}

// 拷贝父进程的trapframe，并为子进程设置返回值为0
copy_thread(proc, stack, tf);

// 中断可能由时钟产生，会使得调度器工作，为了避免产生错误，需要屏蔽中断
bool intr_flag;
local_intr_save(intr_flag);
{
  // 建立新的哈希链表
    proc->pid = get_pid();
    hash_proc(proc);
    list_add(&proc_list, &(proc->list_link));
    nr_process ++;
}
local_intr_restore(intr_flag);

// 唤醒进程，转为PROC_RUNNABLE状态
wakeup_proc(proc);

// 父进程应该返回子进程的pid
ret = proc->pid;
```

### uCore是否为每个fork的进程生成唯一的pid？

是的。fork的时候，在分配pid的时，不允许中断，且在`get_pid`函数中进行了相应的处理，不会分配当前未被销毁且已经分配过进程的`pid`。

## 练习3

`proc_run`函数的最主要语句如下：

```c
current = proc;
load_esp0(next->kstack + KSTACKSIZE);
lcr3(next->cr3);
switch_to(&(prev->context), &(next->context));
```

功能层面上，这个函数将当前运行的进程切换到`proc`。

具体来说，该函数首先将全局`current`指针指向`proc`，代表当前执行的进程已经变成了`proc`，`load_esp0`函数将`proc`的内核栈顶指针读取到TSS段中的相应区域，这一步保证了`proc`在运行的时候，如果需要从用户态跳转到内核态，可以知道具体内核态的栈顶位置在哪里。`lcr3`函数将当前的页表切换为`proc`的。一且准备完毕之后，调用`switch_to`汇编函数，将`proc`的上下文读取到CPU中，执行完了这一条语句（具体是`Switch.s`中的`ret`语句）之后，进程正式切换完毕。而`proc_run`之后的语句，则要等到下次调度到执行这个函数的进程时才能继续执行、出栈。

### 在本实验的执行过程中，创建且运行了几个内核线程？

创建了`idle`和`init`两个内核线程，一开始是`idle`在运行，后来调度之后，变成了`init`在运行，结果`init`运行结束之后，就`panic`了。

### 语句local_intr_...在这里有何作用？

屏蔽中断，保证在进程切换的重要时刻不被打断。即保证__更换current__、__设置TSS__、__切换页表__、__切换上下文__是一个原子操作。

## 实现中与参考答案的区别

- 练习1：基本相同。
- 练习2：开始时忘记了需要加入屏蔽中断的相关代码，虽然uCore可以正常运行，但是存在潜在的风险，所以仿照参考答案进行了相应的修改。

## 实验中的重要知识点

本次实验中重要的知识点有：

- 练习1：进程的概念、进程/线程控制块、进程状态模型
- 练习2：内核线程、进程创建
- 练习3：进程切换

而OS原理中很重要，但在实验中没有对应上的知识点有：

- 进程加载
- 进程等待与退出（本Lab中直接输出panic）
