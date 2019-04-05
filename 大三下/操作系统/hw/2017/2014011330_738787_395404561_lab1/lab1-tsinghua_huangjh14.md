# Lab1实验报告

## 练习1

### 操作系统镜像文件`ucore.img`是如何一步一步生成的？
通过运行`make "V="`打开啰嗦模式进行makefile运行过程的观察，编译过程如下：

- 运行编译器编译内核，包括kern/init, kern/libs, kern/debug, kern/driver, kern/trap, kern/mm, libs/下的C语言文件和S文件，生成可重定向执行文件*.o，使用的参数以及意义分别为：
  - `-nostdinc`：不要在标准系统目录中查找头文件。
  - `-fno-builtin`：不使用C语言的内建函数而使用自己定义的，例如`printf`。
  - `-IXXX`：以`<>`方式引用头文件时，设置首选查找头文件的目录。
  - `-Wall`：编译时显示所有的警告，由于检查程序错误。
  - `-ggdb`：专门为GDB生成更丰富的调试信息（其他调试器就不能用来调试了）。
  - `-gstabs`：以stab格式生成GDB调试信息。
  - `-m32`：交叉编译选项，生成32位（x86）代码。
  - `-fno-stack-protector`：不使用栈完整性确认（金丝雀）机制，在某些默认打开stack protector的编译器上必须使用，这是因为该机制会调用`__stack_chk_fail`标准库函数，而在编译操作系统内核时我们**不能**使用标准库。
- 运行链接器链接内核，将上述*.o文件链接为ELF可执行文件bin/kernel，参数意义如下：
  - `-m elf_i386`：交叉编译生成i386平台的代码。
  - `-T tools/kernel.ld`：使用自编的链接脚本进行代码段、数据段空间的分配，并把ELF可执行文件的入口点设置为函数`kern_init`。
  - `-nostdlib`：不链接C标准库，防止C标准库使用自带的`init`函数代替入口函数（应该还有其他功能，总之不能用标准库）。
- 运行编译器编译MBR下的Bootloader，即boot文件夹下的文件，使用的参数与编译内核时相同。
- 运行链接器链接Bootloader，使用的不同参数如下：
  - `-e start`：设置入口函数为`start`。
  - `-N`：将代码区和数据区设置为可读可写，不对数据区进行页对齐，不链接标准库。
  - `-Ttext 0x7C00`：设定代码段的虚拟内存地址为0x7C00，即主引导扇区被读取到内存的地址。这个地址实际是BIOS自动拷贝到的，这里再次进行设定应该是程序中直接寻址需要。
- 运行OBJDUMP和OBJCOPY实用工具，导出Bootloader的代码段。
- 编译链接`sign`程序，并使用这个程序处理Bootloader代码，生成512字节的MBR扇区镜像，在最后。
- 运行dd程序，创建`ucore.img`硬盘镜像，各个参数意义如下：
  - `if`：输入文件。
  - `of`：输出文件。
  - `count`：拷贝block的个数。
  - `seek`：数据拷贝起始block寻址。
  - `conv=notrunc`：当dd到一个比源文件大的目标文件时，不缩小目标文件。

其他的make命令有：
- qemu：运行qemu开始仿真操作系统，参数如下：
  - `-no-reboot`：操作系统重启时退出仿真。
  - `-parallel stdio`：并口重定向到实体机标准输入输出。
  - `-hda bin/ucore.img`：将ucore.img挂载为第一块默认启动的IDE硬盘。
  - `-serial null`：无串口设备。
- handin和packall：删除无用文件，并将相关文件打包用于上交。
- grade：运行grade脚本进行打分。

### 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

符合规范的主引导扇区是大小为512字节，且最后两个字节为`0x55`和`0xAA`。这一点从tools/sign.c中可以看出。

### 其他笔记

- 在Makefile中使用`$(shell XXX)`可以在shell中执行XXX指令并将输出返回到`$()`变量中；
- Shell中的重定向规则：0代表标准输入，1表示标准输出，2表示标准错误；重定向符号`>`与`1>`意义相同，`2>&1`表示把标准错误合并到标准输出，`2>/dev/null`表示把标准错误输出到/dev/null中，更快捷的方式是`&>/dev/null`可以把标准输出和错误都输出到/dev/null中。

---

## 练习2

### 从CPU加电后的第一条指令开始，单步跟踪BIOS的运行。
首先在Makefile文件中加入新的目标：

```makefile
debug-bios: $(UCOREIMG)
	$(V)$(TERMINAL) -e "$(QEMU) -S -s -d in_asm -D $(BINDIR)/q.log -monitor stdio -hda $< -serial null"
	$(V)sleep 2
	$(V)$(TERMINAL) -e "gdb -tui -q -x tools/gdbinit_bios"
```

其中修改的第一条指令含义为，新启动一个gnome终端并运行debug状态的qemu，并将打印的汇编代码输出到`q.log`文件中。文件`tools/gdbinit_bios`的内容为：

```
file bin/kernel
target remote :1234
set architecture i8086
```

该文件是gdb在初始化时执行的命令，首先加载`bin/kernel`的符号，再对qemu的1234端口进行连接，并设置模拟的CPU架构为`i8086`，便于进一步调试。

经过实验，gdb终端在访问`$pc`寄存器/变量时，并没有考虑段机制中`CS`寄存器的偏移，而qemu提供的终端考虑到了这一点，可以很方便地查看当前的运行状态。CPU初始时处于32位实模式，第一条运行的指令为：

    (qemu) x $pc
    0xfffffff0:  ljmp   $0xf000,$0xe05b

经过长跳转之后，CPU进入16位实模式，BIOS指令大致为：

```
(qemu) x /50i $pc
0x000fe05b:  cmpl   $0x0,%cs:0x6c48
0x000fe062:  jne    0xfd2e1
0x000fe066:  xor    %dx,%dx
0x000fe068:  mov    %dx,%ss
0x000fe06a:  mov    $0x7000,%esp
0x000fe070:  mov    $0xf3691,%edx
0x000fe076:  jmp    0xfd165
0x000fe079:  push   %ebp
...
```

### 在初始化位置0x7C00设置实地址断点

在运行GDB之后在GDB终端输入如下命令

```
break *0x7C00
continue
```

可以发现GDB终端成功停在了`0x00007c00`的地址，在QEMU中可以反编译当前pc附近的指令。

### 从0x7C00开始跟踪代码运行，并将单步跟踪的代码与源代码进行比较

经过观察`q.log`输出，可以发现二者的代码基本相同：虽然有部分指令经过了编译器的变形，但是整体执行的逻辑和顺序保持不变。

### 自己在内核或Bootloader中寻找代码位置，进行断点测试

我选择在内核态进行代码调试，由于已经加载了ELF文件的符号，所以可以在GDB中观察当前执行到代码的位置，在命令窗口中输入：

```
break print_kerninfo
continue
```

根据GDB的观察，pc停在了`0x1008cd`处，可以正常反编译、进行源码级别的调试，效果如下

```
(gdb) x /4i $pc
=> 0x1008c7 <print_kerninfo>:   push   %bp
   0x1008c8 <print_kerninfo+1>: mov    %sp,%bp
   0x1008ca <print_kerninfo+3>: sub    $0x8,%sp
   0x1008cd <print_kerninfo+6>: sub    $0xc,%sp
(gdb) s
(gdb) x $pc
=> 0x1008cd <print_kerninfo+6>: sub    $0xc,%sp
(gdb) si
cprintf (fmt=0x1032b2 "Special kernel symbols:\n") at kern/libs/stdio.c:40
(gdb) ni
0x001008da in print_kerninfo () at kern/debug/kdebug.c:220
(gdb) n
kern_init () at kern/init/init.c:28

```

---

## 练习3

### 分析Bootloader是如何进入保护模式的

进入Bootloader时，CPU处于16位的实模式，通过CS:IP寻址最多有20位，且为了向后兼容，A20线（对应由高到低第21根地址线）恒为低，会出现回卷现象，只能访问奇数兆内存。因此由实模式进入保护模式需要分如下几步：

- 取消A20机制，使得CPU在32位模式下能够寻址全部内存。
- 初始化GDT表，帮助CPU确认段机制映射的方法。
- 使能CR0寄存器PE位，跳转到32位地址，完成保护模式的转换。

具体来说，这种机制的转换在boot/bootasm.S中完成，该代码是Bootloader的起始代码，同时为C语言设置好栈空间，进而调用bootmain.c进行ELF文件检查和拷贝。

boot/bootasm.S的代码流程解释如下：

- `16-23`行：禁止中断，设置段寄存器。（经过测试貌似不设置段寄存器也能正常加载OS，不过考虑到BIOS中的操作不可预测，这里应该谨慎处理，防止之后访问8042时出错）
- `25-43`行：使能A20地址线，先等待8042输入缓存为空，然后发送P2命令，再等待输入缓存空，将P2得到字节的第二位置1并写会输入缓存。
- `49`行：读取GDT表。GDT表是静态设定好的，在汇编代码的最后先动过gdt标签定义了一个段描述符，之后通过gdtdesc定义了一个段表，数组的第0位存储段描述符。
- `50-56`行：使能CR0寄存器的PE位，跳转到32位地址，完成到保护模式的转换。
- `61+`行：设置保护模式的段寄存器，准备C程序栈，调用bootmain函数。

### x86实模式和保护模式的CS:IP寻址方式概述

CS寄存器分为可见的`选择子selector`区域（__16位__）和不可见的`基址base address`区域（__32位__）。
实际上，不可见区域如果不存在，整个体系也能正常工作，不可见区域仅仅是一个缓存。

在16位实模式下，线性地址可寻址空间为1M，寻址方式为**base address + eip**，其中base address在一般情况下等于`selector << 4`，但是在刚刚开机上电的时候这种关系不成立，此时base address = `0xFFFF0000`，但是selector = `0xF000`，再加上eip = `0x0000FFF0`，最终形成了`0xFFFFFFF0`的最初地址。而之后进行了跳转指令之后，`base address`缓存得到更新，重新计算为`0x000F0000`，之后的寻址便从`0x000FXXXX`开始了。

在32位保护模式下，线性地址可寻址空间为4G，寻址方式为**base address + eip**，其中base address总是等于__selector中的index域指向的GDT表项的偏移基址__。

---

## 练习4

### Bootloader如何读取硬盘扇区的？

在完成了32位保护模式切换之后，Bootloader就开始在该模式的内核态读取和拷贝内核的ELF文件。
此时必须对硬盘进行访问，本实验中使用的是第1个IDE通道的主盘，访问的IO地址相应地为`0x1f0-0x1f7`，读取一个扇区的流程为：

- 循环访问`0x1f7`端口，查看磁盘是否正忙，直到不忙为止；
- 向`0x1f2`端口写入希望读取的扇区个数；
- 向`0x1f3-0x1f6`端口写入希望读取的扇区号；
- 向`0x1f7`端口写入`0x20`命令，为读取扇区；
- 同第一步，等待读取硬盘读取完成；
- 使用`insl`指令读取一个扇区的内容到指定虚拟内存中。

### Bootloader如何加载ELF格式的操作系统？

获得了读取磁盘扇区的能力之后，Bootloader就可以读取ELF格式的操作系统文件了，具体的步骤如下：

- 将ELF文件头的8个扇区读取到内存的`0x10000`区域，作为ELF头的临时存储便于后续的访问，这部分区域不会被之后的拷贝操作所覆盖。
- 判断ELF文件是否合法（即检测文件头部magic值）。
- 从ELF头部读取Program Header表的偏移和长度。
- 遍历所有的Program Header：拷贝其中定义的数据到虚拟内存地址中去。拷贝以扇区为单位。
- 跳转到ELF头定义的起始运行地址开始执行。操作系统内核的启动时栈是基于Bootloader设立的运行栈的。

### 补充：GDT表和保护模式下的段机制

该部分内容和练习3也有一定关系，但是放在这里主要是为了和操作系统的起始地址联系起来。
本节主要解释如下的代码段：

```c
/* global segment number */
#define SEG_KTEXT    1
#define SEG_KDATA    2
#define SEG_UTEXT    3
#define SEG_UDATA    4
#define SEG_TSS        5

/* global descriptor numbers */
#define GD_KTEXT    ((SEG_KTEXT) << 3)        // kernel text
#define GD_KDATA    ((SEG_KDATA) << 3)        // kernel data
#define GD_UTEXT    ((SEG_UTEXT) << 3)        // user text
#define GD_UDATA    ((SEG_UDATA) << 3)        // user data
#define GD_TSS        ((SEG_TSS) << 3)        // task segment selector

#define DPL_KERNEL    (0)
#define DPL_USER    (3)

#define KERNEL_CS    ((GD_KTEXT) | DPL_KERNEL)
#define KERNEL_DS    ((GD_KDATA) | DPL_KERNEL)
#define USER_CS        ((GD_UTEXT) | DPL_USER)
#define USER_DS        ((GD_UDATA) | DPL_USER)
/* *
 * Global Descriptor Table:
 *
 * The kernel and user segments are identical (except for the DPL). To load
 * the %ss register, the CPL must equal the DPL. Thus, we must duplicate the
 * segments for the user and the kernel. Defined as follows:
 *   - 0x0 :  unused (always faults -- for trapping NULL far pointers)
 *   - 0x8 :  kernel code segment
 *   - 0x10:  kernel data segment
 *   - 0x18:  user code segment
 *   - 0x20:  user data segment
 *   - 0x28:  defined for tss, initialized in gdt_init
 * */
static struct segdesc gdt[] = {
    SEG_NULL,
    [SEG_KTEXT] = SEG(STA_X | STA_R, 0x0, 0xFFFFFFFF, DPL_KERNEL),
    [SEG_KDATA] = SEG(STA_W, 0x0, 0xFFFFFFFF, DPL_KERNEL),
    [SEG_UTEXT] = SEG(STA_X | STA_R, 0x0, 0xFFFFFFFF, DPL_USER),
    [SEG_UDATA] = SEG(STA_W, 0x0, 0xFFFFFFFF, DPL_USER),
    [SEG_TSS]   = SEG_NULL,
};
```

在uCore的实现中，所有**合法段**（包括SEG_KTEXT, SEG_KDATA, SEG_UTEXT, SEG_UDATA）的偏移值均为`0`，大小均为`4G`，
这就说明：**在给定eip的时候，只要此时DS.selector的index域合法，映射到的线性地址等于eip**。
那么为什么还需要分段机制呢？这里主要利用了段机制的权限控制功能。当eip固定的时候，CS的不同决定了eip指向区域的权限，
一旦eip指向了数据区域，
如果触发权限错误，CPU就会报异常，维护了系统的安全。使用CS也能够判断当前执行的是内核代码还是用户代码。（参见Lab1的gitbook：保护模式和分段机制）

---

## 练习5

### 完成实验，解释最后一行各个数值的含义

经过实验发现输出如下：

```
ebp:0x00007b38 eip:0x00100a2c args:0x00010094 0x00010094 0x00007b68 0x00100084
    kern/debug/kdebug.c:306: print_stackframe+21
ebp:0x00007b48 eip:0x00100d26 args:0x00000000 0x00000000 0x00000000 0x00007bb8
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b68 eip:0x00100084 args:0x00000000 0x00007b90 0xffff0000 0x00007b94
    kern/init/init.c:48: grade_backtrace2+19
ebp:0x00007b88 eip:0x001000a6 args:0x00000000 0xffff0000 0x00007bb4 0x00000029
    kern/init/init.c:53: grade_backtrace1+27
ebp:0x00007ba8 eip:0x001000c3 args:0x00000000 0x00100000 0xffff0000 0x00100043
    kern/init/init.c:58: grade_backtrace0+19
ebp:0x00007bc8 eip:0x001000e4 args:0x00000000 0x00000000 0x00000000 0x00103460
    kern/init/init.c:63: grade_backtrace+26
ebp:0x00007be8 eip:0x00100050 args:0x00000000 0x00000000 0x00000000 0x00007c4f
    kern/init/init.c:28: kern_init+79
ebp:0x00007bf8 eip:0x00007d6e args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d6d --
```

可见与标准解答几乎完全相同，最后两行数值的含义为：

- ebp: 栈帧基指针的值。
- eip：该帧中进行函数调用的PC位置的下一条指令地址。
- args：调用该函数时传入的参数值。
- 第二行：PC所在位置对应的源程序代码位置和行数（也可以认为是该帧进行函数调用时候的程序位置）。

经过查看`asm`文件，发现源代码和汇编语句地址是有一定的转换关系的，在这个文件中能够看出每一条高级语言程序对应哪一条汇编指令。

### 简述代码实现过程

我的代码基本和注释中提供的逻辑相同，我将以注释的形式对代码进行解释。

```c
// 获取当前的ebp
uint32_t current_ebp = read_ebp();
// 获取当前的eip
uint32_t current_eip = read_eip();
// 循环追踪栈的调用关系
for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
  cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
  // 打印参数，参数在ebp指针上方（返回地址）的上方依次排列。
  for (int argi = 0; argi < 4; ++ argi) {
    cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
  }
  cprintf("\n");
  // 打印当前的函数名称和行数
  print_debuginfo(current_eip - 1);
  // 追踪栈帧，eip用saved_pc代替，ebp用caller's ebp代替。
  current_eip = *((uint32_t*)current_ebp + 1);
  current_ebp = *((uint32_t*)current_ebp);
}
```

---

## 练习6

### 中断描述符表的一个表项占多少字节？哪几位代表中断处理代码的入口？

根据IDT门描述符的相关规定，一个表项占8个字节，`0-32`位代表了中断处理代码的入口，其中`0-15`位代表地址偏移，`16-31`位代表段号，需要经过GDT的进一步查询之后才能知道真正入口的线性地址。

### uCore中断的大致调用过程分析

无论在应用程序运行时触发的自陷指令或是系统调用，亦或是硬件触发的中断，都会打断CPU的正常运行，这个时候（在保护模式下），x86系列CPU就会查找IDTR寄存器中的中断服务向量表确定如何分配中断服务例程。
在uCore的实现中，首先在kern/trap/Vector.S中静态定义了`__vectors`变量作为存储ISR的数组，启动操作系统的时候，通过`idt_init`函数在内存中动态建立IDT，并将IDT的ISR表项（共256个）依次填写为`__vectors`中相应ISR的地址。

需要注意的是，`__vectors`中定义的ISR仅仅是一条简单的跳转语句，真正处理中断的是之后的函数，这条跳转语句会跳转到kern/trap/trapentry.S中的`__alltraps`中，在这个函数中设置了trapframe并接着调用`kern/trap/trap.c`中的`trap(trapframe *tf)`函数，这时才开始正式进行C语言级别的异常处理。

## 扩展练习

先陈述一下大致的思路：对于lab1阶段来说，通过CS和DS等寄存器判断当前是否处于内核态或是用户态，切换的时候仅仅需要将这些寄存器的值进行相应的修改即可。
而在中断处理例程中，原程序运行时的所有段寄存器均被压入栈中，处理完毕之后再弹出，因此考虑直接在中断处理例程中修改这些段寄存器的值从而达到用户态和内核态转换的目的。

具体来说，在`lab1_switch_to_user`和`lab1_switch_to_kernel`中插入汇编代码，使用`int`的方式来启动系统调用，在调用之前需要对栈指针`esp`和`ebp`进行维护防止中断处理例程对栈的破坏。
需要特别注意的是，在IDT表的建立过程中，需要添加如下的代码：


```c
if (i == T_SYSCALL || i == T_SWITCH_TOK) {
    SETGATE(idt[i], 1, KERNEL_CS, __vectors[i], DPL_USER);
}
```

这行代码是经过了很长时间的调试才终于找到的，从内核态切换到用户态的时候，ISR刚刚运行时系统还处在内核态，可以正常地对段寄存器进行修改；而相反过程在执行的时候，执行到`int`指令的时候或者执行到ISR的`movw %ax, %ds`一步时，就会触发一般保护异常（13号），导致无法正常执行ISR。所以，需要提前在IDT表中做出约定，这个约定包括两条：

- KERNEL_CS：在执行ISR的时候CS段需要为内核态；
- DPL_USER：本中断可以在用户态进行调用。

最后，只需要在ISR中强行替换栈寄存器值即可，如下所示：

```c
if (tf->tf_cs != KERNEL_CS) {
    tf->tf_cs = KERNEL_CS;
    tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
}
if (tf->tf_cs != USER_CS) {
    tf->tf_cs = USER_CS;
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
    tf->tf_eflags |= FL_IOPL_MASK;
}
```

捕捉键盘事件时，只需要在键盘处理的例程中处理数字0和3即可。

> 注：本题在解答的时候与标准答案有偏差，可能对其他复杂的情况应对性比较差，但是考虑到之后的Lab中有更标准、更优雅的实现，所以这里仅仅是简单的功能实现。

---

## 本次实验各个练习对应OS原理的知识点

- 练习1：MBR扇区格式
- 练习2：x86的实模式与保护模式、内存布局、指令集
- 练习3：Bootloader的启动过程、GDT段机制访存和映射规则
- 练习4：ELF文件格式和硬盘访问
- 练习5：函数调用栈的结构
- 练习6：中断处理向量和中断描述符表的相关知识

另外，我认为在OS原理课程中比较重要，但是没有出现在编程中的知识点是段机制的建立。

---

## 与参考答案的实现区别

- 练习1：我不仅对生成的各个参数进行了功能说明、还对必要性进行了一定的说明，并给出了我从这个makefile文件中学到的脚本编写经验。但是相比答案我没有解释make命令中某些target的意义。
- 练习2：我比参考答案更加详细地叙述了使用调试器进行跟踪的过程。在makefile中的调试target中为gdb加入图形界面功能，使得调试更加方便。
- 练习3：由于分析启动过程需要对x86的寻址方式有深刻理解，我查阅各方资料对x86的寻址方式给出了详细的概述。但并没有像标准答案那样一行一行解释Bootloader的代码意义，我认为这样的必要性不大。
- 练习4：与参考答案相比，我补充了GDT表和保护模式下的段机制，并给出了uCore中GDT建立的细节分析。
- 练习5：代码的实现与标准答案基本相同。
- 练习6：根据gitbook上的提示，我将SYSCALL也加入了用户态可以调用的中断集合中。另外，参考答案有一个实现不标准的地方，即trap.c的`idt_init`函数中，原来填写的是`GD_KTEXT`，应该填写`KERNEL_CS`，才是选择子应该对应的值。

---
