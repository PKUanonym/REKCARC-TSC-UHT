# Lab7挑战：在uCore中实现RCU

主要参考资料：[Here](http://blog.csdn.net/xabc3000/article/details/15335131)

## 设计思路

RCU的思想在于分离对数据进行读操作和写操作的进程，当读操作进行读取的时候无需上锁，而写操作在写入的时候先拷贝一份副本，并等待所有宽限期进程结束再进行写入。

我在本挑战中提供了一个RCU的简化实现，仅仅考虑数据删除的情况，具体情景是：有一个全局共享资源A，写进程希望改变资源A的值，于是写进程新开辟了一块内存区域，并试图将A的指针指向这个含有新资源值的内存区域，同时释放原有A的空间。但是这个时候如果同时有读进程在读取旧数据所在的内存空间，就会造成地址访问异常，使得操作系统崩溃。必须有一定的锁机制来避免这样的情况发生。

因此，根据参考资料上的实现思路，设立`宽限区 grace period`，资源A的替换分为`删除`和`销毁`两个阶段，在删除之后开始的进程，其读取到的A的值即为新值，无需考虑；而在删除之前开始的进程已经获取到了指向旧数据的指针，必须等待所有这样的进程结束之后才能进行`销毁`，这个等待区间就是宽限区。

在实现上，添加了`rcu_read_lock`，`rcu_read_unlock`和`resync_rcu_trial`函数，当read_lock函数执行的时候，如果判断当前还在读取老资源，就增大宽限区的长度，进程执行完毕之后再减回。当resync执行的时候会判断宽限区长度，只有当宽限区长度为0的时候才进行真正的销毁操作，保证资源访问不出错。

## 测试用例

测试的时候，为了避免的`check_sync`冲突，可以将`proc.c`中`init_main`函数的

```c
extern void check_sync(void);
check_sync();                // check philosopher sync problem
//extern void check_rcu(void);
//check_rcu();
```

改为

```c
//extern void check_sync(void);
//check_sync();                // check philosopher sync problem
extern void check_rcu(void);
check_rcu();
```

即可。

测试的时候，资源A的旧值为：`a = 5, b = 'O'`，新值为`a = 6, b = 'N'`，总共有4个读进程，中间穿插了一个更改资源值的写进程。这样一来，考虑到前两个执行的读进程还在读取数据，所以写进程不能释放内存空间，只有当前两个读进程结束之后，写进程才能释放内存结束运行。同时，后执行的两个读进程已经获取到了最新的资源值，操作系统输出如下：

```
...
Foo_read 4 starts.
Foo_read 3 starts.
Foo_update 1 starts.
Foo_update waiting for 2 graceful period to finish.
Foo_read 2 starts.
Foo_read 1 starts.
...
[SAFE] foo_read: gbl_foo.a = 6, gbl_foo.b = N
Foo_read 1 ends.
[SAFE] foo_read: gbl_foo.a = 6, gbl_foo.b = N
Foo_read 2 ends.
[SAFE] foo_read: gbl_foo.a = 5, gbl_foo.b = O
Foo_read 3 ends.
[SAFE] foo_read: gbl_foo.a = 5, gbl_foo.b = O
Foo_read 4 ends.
Foo_update 1 ends.
check_rcu() passed
...
    initproc exit.
```

`Foo_update 1 ends.`语句标志着`kfree`对旧资源所占用的空间进行了释放。
