# Lab6挑战：实现CFS调度

在维基百科中，有下面的话：

> Originally invented for packet networks, fair queuing had been previously applied to CPU scheduling under the name stride scheduling. However, CFS uses terminology different from that normally applied to fair queuing. "Service error" (the amount by which a process's obtained CPU share differs from its expected CPU share) is called "wait_runtime" in Linux's implementation, and "queue virtual time" (QVT) is called "fair_clock".

而学习了CFS算法的思想之后，我认为可以做这样的转换：

```
lab6_run_pool -> rb_tree tasks_timeline
lab6_priority -> priority
lab6_stride -> vruntime
```

实际上之前实现的stride算法只要简单修改一下参数就变成了CFS最基础的算法，根据不同的优先级指定不同的stride变化，最终选择最小的stride进程进行调度。

具体的实现请参考`schedule/cfs_sched.[ch]`文件，如果需要运行，只需要将`schedule/sched.c`中的

```c
// sched_class = &default_sched_class;
sched_class = &stride_sched_class;
// sched_class = &cfs_sched_class;
```

改为

```c
// sched_class = &default_sched_class;
// sched_class = &stride_sched_class;
sched_class = &cfs_sched_class;
```

即可。

最终模拟输出如下：

```
entry  0xc010002a (phys)
...
sched class: cfs_scheduler
...
kernel panic at kern/process/proc.c:491:
  initproc exit.
```
