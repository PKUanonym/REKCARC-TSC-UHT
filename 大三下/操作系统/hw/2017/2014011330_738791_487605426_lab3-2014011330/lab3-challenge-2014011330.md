# Lab3挑战：Extended Clock设计文档

## 运行说明

我的Extended Clock相关实现在`kern/mm/swap_clock.c`和`kern/mm/swap_clock.h`文件中。如果需要进行相关的测试，则需要更改`kern/mm/swap.c`中的

```c
sm = &swap_manager_fifo;
```

为
```c
sm = &swap_manager_clock;
```

并加入相关的头文件即可。启动操作系统，可以看到如下字样：

```
SWAP: manager = extended clock swap manager
BEGIN check_swap: count 1, total 31964
setup Page Table for vaddr 0X1000, so alloc a page
setup Page Table vaddr 0~4MB OVER!
set up init env for check_swap begin!
page fault at 0x00001000: K/W [no page found].
page fault at 0x00002000: K/W [no page found].
page fault at 0x00003000: K/W [no page found].
page fault at 0x00004000: K/W [no page found].
set up init env for check_swap over!
read Virt Page c in clock_check_swap
write Virt Page a in clock_check_swap
read Virt Page d in fifo_check_swap
write Virt Page b in fifo_check_swap
read Virt Page e in fifo_check_swap
page fault at 0x00005000: K/R [no page found].
A = 1, D = 1, c0306004, 00307067
A = 1, D = 1, c0306008, 00308067
A = 1, D = 0, c030600c, 00309027
A = 1, D = 0, c0306010, 0030a027
A = 0, D = 1, c0306004, 00307047
A = 0, D = 1, c0306008, 00308047
A = 0, D = 0, c030600c, 00309007
...
Page Fault Num = 7
count is 0, total is 7
check_swap() succeeded!
```

说明扩展时钟系统可以正常工作。

## 实现思路

扩展时钟系统的实现需要相关硬件的支持，每次进行虚拟地址访问的时候，硬件需要将相应的`PTE`表项的Access位或Dirty位置1，才能保证扩展时钟的正确工作。另外，由于扩展时钟算法属于消极算法，所以没有必要在每个时钟中断处添加代码。

在具体实现上，我通过`current_clock_pointer`变量表示当前时钟所指向的`Page`结构，可以被换出的物理页组成一个环形链表，链表首为`clock_list_head`，每次缺页的时候，就开始查询可以被换出的物理页的`PTE`表项。具体方式为，先根据链表表项`list_entry`找到`Page`结构，再访问`Page`结构的`pra_vaddr`变量，那里存储了该结构对应的虚拟地址，最后通过`get_pte`函数获取`PTE`表项。

在进行`PTE`表项的修改时，如果`Access`和`Dirty`位都为0，则换出该页，结束循环；如果二者有一个不为0，则取消`Access`位或对应地取消`Dirty`位，相关的转换规则与上课所讲PPT描述相同。

## 相关测试

为了测试所实现的扩展时钟系统的正确性，我进行了如下的测试：

```c
static int
_clock_check_swap(void) {
	// Clear all A/D bytes in Page a, b, c, d, e
	for (int i = 1; i < 6; ++ i) {
		uintptr_t la = (i << 12);
		pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
		assert(pt_entry != NULL);
		(*pt_entry) = (*pt_entry) & (~PTE_A);
		(*pt_entry) = (*pt_entry) & (~PTE_D);
	}
	unsigned char temp;

	cprintf("read Virt Page c in clock_check_swap\n");
    temp += *(unsigned char *)0x3000;
    mark_read(3);
    assert(pgfault_num==4);

    cprintf("write Virt Page a in clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    mark_write(1);
    assert(pgfault_num==4);

    cprintf("read Virt Page d in fifo_check_swap\n");
    temp += *(unsigned char *)0x4000;
    mark_read(4);
    assert(pgfault_num==4);

    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    mark_write(2);
    assert(pgfault_num==4);

    cprintf("read Virt Page e in fifo_check_swap\n");
    temp += *(unsigned char *)0x5000;
    mark_read(5);
    assert(pgfault_num==5);

    cprintf("read Virt Page b in fifo_check_swap\n");
    temp += *(unsigned char *)0x2000;
    mark_read(2);
    assert(pgfault_num==5);

    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    cprintf("Page Fault Num = %d\n", pgfault_num);
    mark_write(1);
    assert(pgfault_num==5);

    cprintf("read Virt Page b in fifo_check_swap\n");
    temp += *(unsigned char *)0x2000;
    cprintf("Page Fault Num = %d\n", pgfault_num);
    mark_read(2);
    assert(pgfault_num==5);

    cprintf("read Virt Page c in fifo_check_swap\n");
    temp += *(unsigned char *)0x3000;
    cprintf("Page Fault Num = %d\n", pgfault_num);
    mark_read(3);
    assert(pgfault_num==6);

    cprintf("read Virt Page d in fifo_check_swap\n");
    temp += *(unsigned char *)0x4000;
    cprintf("Page Fault Num = %d\n", pgfault_num);
    mark_read(4);
    assert(pgfault_num==7);

    return 0;
}
```

上述测例摘自MOOC的PPT中扩展时钟举例一节，总共有`a,b,c,d,e`五个虚拟页帧和四个物理页，开始时物理内存中有`a,b,c,d`，访问次序依次为：

```
c, a_w, d, b_w, e, b, a_w, b, c, d
```

其中访存`e`, `c`, `d`的时候发生缺页，需要替换的页为`c`, `d`, `b`。总共缺页7次，最终程序的输出与PPT上的结果保持一致，说明扩展时钟系统实现正确：

```
read Virt Page c in clock_check_swap
write Virt Page a in clock_check_swap
read Virt Page d in fifo_check_swap
write Virt Page b in fifo_check_swap
read Virt Page e in fifo_check_swap
page fault at 0x00005000: K/R [no page found].
swap_out: i 0, store page in vaddr 0x3000 to disk swap entry 4
read Virt Page b in fifo_check_swap
write Virt Page a in fifo_check_swap
read Virt Page b in fifo_check_swap
read Virt Page c in fifo_check_swap
page fault at 0x00003000: K/R [no page found].
swap_out: i 0, store page in vaddr 0x4000 to disk swap entry 5
swap_in: load disk swap entry 4 with swap_page in vadr 0x3000
read Virt Page d in fifo_check_swap
page fault at 0x00004000: K/R [no page found].
swap_out: i 0, store page in vaddr 0x2000 to disk swap entry 3
swap_in: load disk swap entry 5 with swap_page in vadr 0x4000
```
