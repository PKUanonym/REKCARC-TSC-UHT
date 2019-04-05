# Lab2挑战：Buddy PMM设计文档

## 运行说明

我的buddy pmm相关实现在`kern/mm/buddy_pmm.c`和`kern/mm/buddy_pmm.h`文件中。如果需要进行相关的测试，则需要更改`kern/mm/pmm.c`中的

```c
pmm_manager = &default_pmm_manager;
```

为
```c
pmm_manager = &buddy_pmm_manager;
```

并加入相关的头文件即可。启动操作系统，可以看到如下字样：

```
memory management: buddy_pmm_manager
e820map:
 ...
Detected maxpa = 07fe0000
Kernel ends at (va): c011a974, Total pages = 32736, which takes up 654720.
Freemem = (pa) 001bad80
Detected one allocatable block (pa) start = 001bb000, end = 07fe0000
BUDDY: Maximum manageable pages = 16384, pages for storing longest = 33

check_alloc_page() succeeded!
```

最后一行显示了实际分配的页面情况。在上述例子中，物理页面数有32736个，但是考虑到buddy系统所能利用的内存大小必须为2的幂，所以实际能够分配的内存页面数为16384，剩下还需要使用33个页面专门存储辅助用`longest`数组。

## 实现思路

实现上buddy系统的相关资料主要参考在gitbook上提供的参考资料：[伙伴系统的极简实现](http://coolshell.cn/articles/10427.html)，并借用了其中`longest`数组的思想存储二叉树。首先复述一下该文章的思路：

将整个可管理的页面看做一个二叉树上的节点，根节点即代表整个内存空间。每个节点存储`longest`值，在本实现中存储在一个数组中。`longest`值只能是2的整数次幂，是整个buddy算法的核心所在，它存储了该节点最多能够分配空间大小。

当进行空间分配时，首先确定应该分配的节点（即二叉树的一个子树），将子树的根节点值置为0并向上更新，这是因为上方节点最多能分配的空间实际上取决于其左子树和右子树根节点最多能分配的空间。如果二者都能够分配所有的空间，则根节点就能分配左右子树空间之和大小的空间；否则，只要有一个子树不能分配其代表的所有空间，那么根节点最多就只能分配其左右子树根节点能分配空间的最大值。

空间释放的时候，除了将相应节点的值由0改回可分配值，也同样需要向上更新祖先节点，实际上执行的是分配的反过程。

由于整个空间已经被规律地组织成了二叉树的结构，所以即使是相邻的同大小空间也不会被错误地合并。

另外，`longest`数组需要占用内存空间，如果将这部分空间静态地分配在内核中是不明智的，不仅会增加内核镜像大小，还不能适应不同内存容量。因此在执行`init_memmap`函数的时候，首先为`longest`数组计算并适配相应的页面，每个元素占用4个字节，再以2的幂建立能够进行分配的页的数组。相应的计算最大可管理内存容量的代码如下所示：

```c
unsigned int max_pages = 1;
for (unsigned int i = 1; i < BUDDY_MAX_DEPTH; ++ i) {
	// Should consider the page for storing 'longest' array.
	if (max_pages + max_pages / 512 >= n) {
		max_pages /= 2;
		break;
	}
	max_pages *= 2;
}
```

## 相关测试

为了测试所实现的伙伴系统的正确性，我进行了如下的测试：

```c
static void
buddy_check(void) {
	int all_pages = nr_free_pages();
	struct Page* p0, *p1, *p2, *p3, *p4;
	assert(alloc_pages(all_pages + 1) == NULL);

	p0 = alloc_pages(1);
	assert(p0 != NULL);
	p1 = alloc_pages(2);
	assert(p1 == p0 + 2);
	assert(!PageReserved(p0) && !PageReserved(p1));
	assert(!PageProperty(p0) && !PageProperty(p1));

	p2 = alloc_pages(1);
	assert(p2 == p0 + 1);

	p3 = alloc_pages(2);
	assert(p3 == p0 + 4);
	assert(!PageProperty(p3) && !PageProperty(p3 + 1) && PageProperty(p3 + 2));

	free_pages(p1, 2);
	assert(PageProperty(p1) && PageProperty(p1 + 1));
	assert(p1->ref == 0);

	free_pages(p0, 1);
	free_pages(p2, 1);

	p4 = alloc_pages(2);
	assert(p4 == p0);
	free_pages(p4, 2);
	assert((*(p4 + 1)).ref == 0);

	assert(nr_free_pages() == all_pages / 2);

	free_pages(p3, 2);

	p1 = alloc_pages(33);
	free_pages(p1, 64);
}
```

该测试参考了伙伴系统维基百科的测试样例，并加入了可分配页的检查和页属性标记的相关检查，确保和内核其他代码能够正常交互。
