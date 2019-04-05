# Lab7实验报告

## 练习1

### 内核级信号量设计描述

首先对Lab7进行内核级别信号量测试的流程进行简单分析。在`init`进程执行之后，会首先创建用户程序空间，随后执行函数`check_sync`直接开始进行哲学家就餐问题的测试。在`check_sync`函数中，使用`kernel_execve`函数生成了n个内核线程代表n个思考的哲学家。实际的用户程序会与这n个内核线程共同被调度，同时运行。

在Lab7给出的代码中，使用如下方式解决哲学家就餐问题的同步与互斥要求：所有哲学家共享临界区信号量`mutex`，这个信号量用于保证哲学家线程在操作`state_sema`数组时不产生冲突，因此在`take_forks`和`put_forks`函数里都需要加锁。另外，使用`s`信号量数组表示每个哲学家是否正在占用他盘子左面和右面的两个叉子的资源正在进餐，当尝试开始进餐的时候，哲学家会试图取得两个叉子：如果不能取得，则使用`s`信号量进入阻塞状态。而只有当其他的哲学家进餐完毕之后，才会去检查周围的哲学家是否能够进餐，如果可以进餐，则解除`s`信号量引起的阻塞。这种同步互斥的方式与原理课上所讲解的3种实现方式均不一样，但是同样具有正确性。

对于信号量的操作，这里的`up()`和`down()`对应原理课上的`V()`和`P()`函数，下面代码中的注释解释了`up`和`down`函数的实现方式以及与原理课程相应部分代码的对应：

```c
void up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    // 在进行up操作（即V操作）的时候，需要由操作系统保证其原子性
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        // 当没有进程希望占用该资源的时候，资源释放
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        else {
            // 有进程希望占用此资源，现在这个资源被释放了一份，所以应该唤醒下一个希望占用该资源的进程
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}

uint32_t down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    // 如果资源还有剩余，则信号量值减一，可以正常访问资源
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    // 资源没有剩余，需要将当前进程加入信号量的等待队列，并重新调度
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    // 阻塞完毕，该进程被重新唤醒调度，说明现在可以使用该资源了。
    // assert(sem->value == 0); // !IMPORTANT
    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
```

在Lab7代码的定义中，一个信号量的`value`值**始终**是大于等于0的。如果该值大于0，则表示该资源还有剩余，可以分配，而等于0则表示该资源已经被分配完，需要等待。而使用了`wait_queue`记录了当前希望访问该资源的进程之后，就可以通过判断该队列是否为空来确定是否已经没有进程需要此资源了，这个时候，`value`的值自然就可以自加了。

### 用户态进程/线程的信号量机制设计方案

我的想法是可以在`proc_struct`里面增加一个`semaphores`链表存储所有关联到这个进程的信号量。为用户态程序增加三个系统调用，他们的接口分别如下：

- CREATE_SEM: 参数为信号量的value值，返回一个信号量的id。这个系统调用为当前进程创建一个信号量结构体，并关联到PCB/TCB上。
- P: 输入参数为信号量的id。这个系统调用相当于信号量的P操作，由操作系统保证原子性。执行了这个系统调用之后应用程序可能会进入阻塞状态。
- V: 输入参数为信号量的id。相当于V操作，是原子操作。

但上述的接口定义在用户态**线程**的实现比较方便，因为获取到的信号量id可以被不同的线程共享，从而做到同步与互斥；但是对于**进程**来说，共享信号量id实现同步互斥可能较为困难，一个方法是在编程的时候提前由程序员指定一个信号量编号作为约定（这里类似于网络中的端口号，也是提前给定的）。

之所以采用系统调用的方式来实现信号量，是因为信号量原子性的要求以及进程切换的需要。由于操作系统需要保持PV操作的原子性，必须使用特权指令禁用中断，而这些指令在用户态是无法使用的；另外，如果设计进程切换，在内核态处理也更加方便。

另外，如果考虑到频繁的PV操作引起过多的系统调用降低效率，也可以考虑在用户态直接采用软件的方式或高级抽象方式实现同步与互斥，但是可能会加大程序设计的难度。

## 练习2

### 内核级条件变量设计描述

内核态的管程机制采用Hoare管程实现，每次进入管程和退出管程都需要执行：

```c
down(&(mtp->mutex));
```

和

```c
if(mtp->next_count>0)
   up(&(mtp->next));
else
   up(&(mtp->mutex));
```

才能使得管程机制正常工作。这两句实际上相当于原理课上所讲的`lock->Acquire()`和`lock->Release()`操作。使得进入管程取得共享资源的仅有一个进程。

在成功进入管程之后，就需要条件变量来进行更细致的同步互斥控制了。条件变量的定义如下：

```c
typedef struct condvar{
    semaphore_t sem;
    int count;
    monitor_t * owner;
} condvar_t;
```

`sem`为条件变量提供了wait和signal的接口，其思想在下面会叙述。而`owner`则代表了该条件变量所处的管程，由于管程实现的是Hoare管程，这就要求T1和T2之间的切换不被T3打断，**且**在T2执行了signal操作之后应该立即切换到wait的T1继续执行。注意，这个时候等待的`T2`并没有像Mesa管程一样重新进入了相应条件变量的等待队列，而是优先地等在next变量上，等待如下的解锁时机继续运行：

> 变量名`next`存储在管程中，代表了由于执行signal操作而进入睡眠状态的锁，解锁时机为*另一个进程退出或另一个进程wait*。

uCore中实现的相关函数即注释如下：

```c
void cond_signal (condvar_t *cvp) {
  // 执行了signal操作，需要观察是否有进程等在该条件变量上
   if (cvp->count > 0) {
     // 如果有，则需要转而执行等待的进程
     // 将自己放在特殊的next里面，保证那个进程执行完毕或是wait的时候能切回自己。
	   cvp->owner->next_count ++;
     // 唤醒所有等待的进程，让他们执行。
	   up(&(cvp->sem));
     // 自己阻塞
	   down(&(cvp->owner->next));
	   cvp->owner->next_count --;
   }
   // 如果没有，什么也不做，忽略这条语句（与信号量不同）
}
```

```c
void cond_wait (condvar_t *cvp) {
  // 等待队列长度加1
    cvp->count ++;
    // 需要将自己换出，让出管程
    // 但是需要特别判断是否存在next优先进程。
    if (cvp->owner->next_count > 0) {
    	up(&(cvp->owner->next));
    } else {
    	up(&(cvp->owner->mutex));
    }
    // 自己阻塞
    down(&(cvp->sem));
    cvp->count --;
}
```

注意不能混淆上述两个操作的看似相似的阻塞操作，signal的阻塞是想让等待的进程快快执行，wait的阻塞是因为缺少资源而不得不阻塞。

在使用条件变量解决哲学家就餐问题的时候，需要等待在相关的条件变量上，基本思想和信号量相同。不过一个不太理解的地方是下列语句的实现：

```c
while (state_condvar[i] != EATING) {
  cond_wait(&(mtp->cv[i]));
}
```

既然使用了Hoare管程，为什么不用`if`语句呢？（经过测试if也能得出期望的结果）。

### 用户态条件变量机制设计方案

根据上一节的分析，`cond_signal`和`cond_wait`导致的进程阻塞与唤醒都可以由信号量的相关接口进行完成，因此可以考虑设计用户态的管程机制，由语言内部维护（例如JAVA）或是用户手动维护这两个必要函数的运作，通过系统调用完成对信号量的PV操作。

### 基于信号量完成条件变量

信号量和条件变量虽然在结构上均为一个整形变量加一个等待队列，但是其概念不一样，对于整形数的解释也不一样，不能一概而论。条件变量中，整形值`numWaiting`表示正在等待队列中等待该条件变量`signal`的进程个数；而信号量中，整形值`value`表示资源的剩余数目，不直接反映等待队列中的进程数目。如果一个进程执行了信号量的`V()`操作，下次执行`P()`操作的时候就能无阻塞执行；而条件变量在执行`signal()`操作之后，如果等待队列中没有等待项目，则这条语句实际上被忽略。

但是，在uCore中为了统一灵活实现，的确使用了信号量`semaphore_t`作为条件变量`condvar_t`的组成部分：

```c
typedef struct condvar{
    semaphore_t sem;        // 用于阻塞wait进程
    int count;              // 被阻塞进程的数目
    ...
} condvar_t;
```

在执行`signal`或是`wait`操作的时候，`sem`即用于唤醒和阻塞进程，可以直接通过调用其`up`和`down`接口来实现这些功能，使得程序设计更加灵活

## 实现中与参考答案的区别

- 练习2：由于给出了伪代码，基本实现与答案相同。

## 实验中的重要知识点

本次实验中重要的知识点有：

- 实现同步互斥的三种方法
- 信号量
- 管程和条件变量
- 哲学家就餐问题

而OS原理中很重要，但在实验中没有对应上的知识点有：

- 使用原子指令实现同步互斥
- 生产者-消费者问题
