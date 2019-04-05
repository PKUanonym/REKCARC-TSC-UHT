
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 60 12 00 	lgdtl  0x126018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 60 12 c0       	mov    $0xc0126000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 2c 9c 12 c0       	mov    $0xc0129c2c,%edx
c0100035:	b8 b0 6a 12 c0       	mov    $0xc0126ab0,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 b0 6a 12 c0       	push   $0xc0126ab0
c0100049:	e8 18 96 00 00       	call   c0109666 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 9e 1d 00 00       	call   c0101df4 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 00 9f 10 c0 	movl   $0xc0109f00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 1c 9f 10 c0       	push   $0xc0109f1c
c0100068:	e8 11 02 00 00       	call   c010027e <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 93 08 00 00       	call   c0100908 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 8b 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 f1 3a 00 00       	call   c0103b70 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 e2 1e 00 00       	call   c0101f66 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 64 20 00 00       	call   c01020ed <idt_init>

    vmm_init();                 // init virtual memory management
c0100089:	e8 81 4e 00 00       	call   c0104f0f <vmm_init>
    proc_init();                // init process table
c010008e:	e8 a1 8f 00 00       	call   c0109034 <proc_init>
    
    ide_init();                 // init ide devices
c0100093:	e8 2b 0d 00 00       	call   c0100dc3 <ide_init>
    swap_init();                // init swap
c0100098:	e8 ee 56 00 00       	call   c010578b <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 f9 14 00 00       	call   c010159b <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 fc 1f 00 00       	call   c01020a3 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000a7:	e8 28 91 00 00       	call   c01091d4 <cpu_idle>

c01000ac <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ac:	55                   	push   %ebp
c01000ad:	89 e5                	mov    %esp,%ebp
c01000af:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000b2:	83 ec 04             	sub    $0x4,%esp
c01000b5:	6a 00                	push   $0x0
c01000b7:	6a 00                	push   $0x0
c01000b9:	6a 00                	push   $0x0
c01000bb:	e8 97 0c 00 00       	call   c0100d57 <mon_backtrace>
c01000c0:	83 c4 10             	add    $0x10,%esp
}
c01000c3:	90                   	nop
c01000c4:	c9                   	leave  
c01000c5:	c3                   	ret    

c01000c6 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c6:	55                   	push   %ebp
c01000c7:	89 e5                	mov    %esp,%ebp
c01000c9:	53                   	push   %ebx
c01000ca:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000cd:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d3:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d9:	51                   	push   %ecx
c01000da:	52                   	push   %edx
c01000db:	53                   	push   %ebx
c01000dc:	50                   	push   %eax
c01000dd:	e8 ca ff ff ff       	call   c01000ac <grade_backtrace2>
c01000e2:	83 c4 10             	add    $0x10,%esp
}
c01000e5:	90                   	nop
c01000e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000e9:	c9                   	leave  
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	83 ec 08             	sub    $0x8,%esp
c01000f4:	ff 75 10             	pushl  0x10(%ebp)
c01000f7:	ff 75 08             	pushl  0x8(%ebp)
c01000fa:	e8 c7 ff ff ff       	call   c01000c6 <grade_backtrace1>
c01000ff:	83 c4 10             	add    $0x10,%esp
}
c0100102:	90                   	nop
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	83 ec 04             	sub    $0x4,%esp
c0100113:	68 00 00 ff ff       	push   $0xffff0000
c0100118:	50                   	push   %eax
c0100119:	6a 00                	push   $0x0
c010011b:	e8 cb ff ff ff       	call   c01000eb <grade_backtrace0>
c0100120:	83 c4 10             	add    $0x10,%esp
}
c0100123:	90                   	nop
c0100124:	c9                   	leave  
c0100125:	c3                   	ret    

c0100126 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100126:	55                   	push   %ebp
c0100127:	89 e5                	mov    %esp,%ebp
c0100129:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010012c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010012f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100132:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100135:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100138:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010013c:	0f b7 c0             	movzwl %ax,%eax
c010013f:	83 e0 03             	and    $0x3,%eax
c0100142:	89 c2                	mov    %eax,%edx
c0100144:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0100149:	83 ec 04             	sub    $0x4,%esp
c010014c:	52                   	push   %edx
c010014d:	50                   	push   %eax
c010014e:	68 21 9f 10 c0       	push   $0xc0109f21
c0100153:	e8 26 01 00 00       	call   c010027e <cprintf>
c0100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010015b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015f:	0f b7 d0             	movzwl %ax,%edx
c0100162:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0100167:	83 ec 04             	sub    $0x4,%esp
c010016a:	52                   	push   %edx
c010016b:	50                   	push   %eax
c010016c:	68 2f 9f 10 c0       	push   $0xc0109f2f
c0100171:	e8 08 01 00 00       	call   c010027e <cprintf>
c0100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100179:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010017d:	0f b7 d0             	movzwl %ax,%edx
c0100180:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0100185:	83 ec 04             	sub    $0x4,%esp
c0100188:	52                   	push   %edx
c0100189:	50                   	push   %eax
c010018a:	68 3d 9f 10 c0       	push   $0xc0109f3d
c010018f:	e8 ea 00 00 00       	call   c010027e <cprintf>
c0100194:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100197:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010019b:	0f b7 d0             	movzwl %ax,%edx
c010019e:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c01001a3:	83 ec 04             	sub    $0x4,%esp
c01001a6:	52                   	push   %edx
c01001a7:	50                   	push   %eax
c01001a8:	68 4b 9f 10 c0       	push   $0xc0109f4b
c01001ad:	e8 cc 00 00 00       	call   c010027e <cprintf>
c01001b2:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001b5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001b9:	0f b7 d0             	movzwl %ax,%edx
c01001bc:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c01001c1:	83 ec 04             	sub    $0x4,%esp
c01001c4:	52                   	push   %edx
c01001c5:	50                   	push   %eax
c01001c6:	68 59 9f 10 c0       	push   $0xc0109f59
c01001cb:	e8 ae 00 00 00       	call   c010027e <cprintf>
c01001d0:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001d3:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c01001d8:	83 c0 01             	add    $0x1,%eax
c01001db:	a3 c0 6a 12 c0       	mov    %eax,0xc0126ac0
}
c01001e0:	90                   	nop
c01001e1:	c9                   	leave  
c01001e2:	c3                   	ret    

c01001e3 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001e3:	55                   	push   %ebp
c01001e4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001e6:	90                   	nop
c01001e7:	5d                   	pop    %ebp
c01001e8:	c3                   	ret    

c01001e9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001e9:	55                   	push   %ebp
c01001ea:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001ec:	90                   	nop
c01001ed:	5d                   	pop    %ebp
c01001ee:	c3                   	ret    

c01001ef <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001ef:	55                   	push   %ebp
c01001f0:	89 e5                	mov    %esp,%ebp
c01001f2:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001f5:	e8 2c ff ff ff       	call   c0100126 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001fa:	83 ec 0c             	sub    $0xc,%esp
c01001fd:	68 68 9f 10 c0       	push   $0xc0109f68
c0100202:	e8 77 00 00 00       	call   c010027e <cprintf>
c0100207:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010020a:	e8 d4 ff ff ff       	call   c01001e3 <lab1_switch_to_user>
    lab1_print_cur_status();
c010020f:	e8 12 ff ff ff       	call   c0100126 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100214:	83 ec 0c             	sub    $0xc,%esp
c0100217:	68 88 9f 10 c0       	push   $0xc0109f88
c010021c:	e8 5d 00 00 00       	call   c010027e <cprintf>
c0100221:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100224:	e8 c0 ff ff ff       	call   c01001e9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100229:	e8 f8 fe ff ff       	call   c0100126 <lab1_print_cur_status>
}
c010022e:	90                   	nop
c010022f:	c9                   	leave  
c0100230:	c3                   	ret    

c0100231 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100231:	55                   	push   %ebp
c0100232:	89 e5                	mov    %esp,%ebp
c0100234:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100237:	83 ec 0c             	sub    $0xc,%esp
c010023a:	ff 75 08             	pushl  0x8(%ebp)
c010023d:	e8 e3 1b 00 00       	call   c0101e25 <cons_putc>
c0100242:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100245:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100248:	8b 00                	mov    (%eax),%eax
c010024a:	8d 50 01             	lea    0x1(%eax),%edx
c010024d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100250:	89 10                	mov    %edx,(%eax)
}
c0100252:	90                   	nop
c0100253:	c9                   	leave  
c0100254:	c3                   	ret    

c0100255 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100255:	55                   	push   %ebp
c0100256:	89 e5                	mov    %esp,%ebp
c0100258:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010025b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100262:	ff 75 0c             	pushl  0xc(%ebp)
c0100265:	ff 75 08             	pushl  0x8(%ebp)
c0100268:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010026b:	50                   	push   %eax
c010026c:	68 31 02 10 c0       	push   $0xc0100231
c0100271:	e8 26 97 00 00       	call   c010999c <vprintfmt>
c0100276:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100279:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010027c:	c9                   	leave  
c010027d:	c3                   	ret    

c010027e <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010027e:	55                   	push   %ebp
c010027f:	89 e5                	mov    %esp,%ebp
c0100281:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100284:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100287:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010028a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028d:	83 ec 08             	sub    $0x8,%esp
c0100290:	50                   	push   %eax
c0100291:	ff 75 08             	pushl  0x8(%ebp)
c0100294:	e8 bc ff ff ff       	call   c0100255 <vcprintf>
c0100299:	83 c4 10             	add    $0x10,%esp
c010029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002a2:	c9                   	leave  
c01002a3:	c3                   	ret    

c01002a4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002a4:	55                   	push   %ebp
c01002a5:	89 e5                	mov    %esp,%ebp
c01002a7:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002aa:	83 ec 0c             	sub    $0xc,%esp
c01002ad:	ff 75 08             	pushl  0x8(%ebp)
c01002b0:	e8 70 1b 00 00       	call   c0101e25 <cons_putc>
c01002b5:	83 c4 10             	add    $0x10,%esp
}
c01002b8:	90                   	nop
c01002b9:	c9                   	leave  
c01002ba:	c3                   	ret    

c01002bb <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002bb:	55                   	push   %ebp
c01002bc:	89 e5                	mov    %esp,%ebp
c01002be:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002c8:	eb 14                	jmp    c01002de <cputs+0x23>
        cputch(c, &cnt);
c01002ca:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002ce:	83 ec 08             	sub    $0x8,%esp
c01002d1:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002d4:	52                   	push   %edx
c01002d5:	50                   	push   %eax
c01002d6:	e8 56 ff ff ff       	call   c0100231 <cputch>
c01002db:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002de:	8b 45 08             	mov    0x8(%ebp),%eax
c01002e1:	8d 50 01             	lea    0x1(%eax),%edx
c01002e4:	89 55 08             	mov    %edx,0x8(%ebp)
c01002e7:	0f b6 00             	movzbl (%eax),%eax
c01002ea:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002ed:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002f1:	75 d7                	jne    c01002ca <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002f3:	83 ec 08             	sub    $0x8,%esp
c01002f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002f9:	50                   	push   %eax
c01002fa:	6a 0a                	push   $0xa
c01002fc:	e8 30 ff ff ff       	call   c0100231 <cputch>
c0100301:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100304:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010030f:	e8 5a 1b 00 00       	call   c0101e6e <cons_getc>
c0100314:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010031b:	74 f2                	je     c010030f <getchar+0x6>
        /* do nothing */;
    return c;
c010031d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100320:	c9                   	leave  
c0100321:	c3                   	ret    

c0100322 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100322:	55                   	push   %ebp
c0100323:	89 e5                	mov    %esp,%ebp
c0100325:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100328:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010032c:	74 13                	je     c0100341 <readline+0x1f>
        cprintf("%s", prompt);
c010032e:	83 ec 08             	sub    $0x8,%esp
c0100331:	ff 75 08             	pushl  0x8(%ebp)
c0100334:	68 a7 9f 10 c0       	push   $0xc0109fa7
c0100339:	e8 40 ff ff ff       	call   c010027e <cprintf>
c010033e:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100341:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100348:	e8 bc ff ff ff       	call   c0100309 <getchar>
c010034d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100350:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100354:	79 0a                	jns    c0100360 <readline+0x3e>
            return NULL;
c0100356:	b8 00 00 00 00       	mov    $0x0,%eax
c010035b:	e9 82 00 00 00       	jmp    c01003e2 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100360:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100364:	7e 2b                	jle    c0100391 <readline+0x6f>
c0100366:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010036d:	7f 22                	jg     c0100391 <readline+0x6f>
            cputchar(c);
c010036f:	83 ec 0c             	sub    $0xc,%esp
c0100372:	ff 75 f0             	pushl  -0x10(%ebp)
c0100375:	e8 2a ff ff ff       	call   c01002a4 <cputchar>
c010037a:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010037d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100380:	8d 50 01             	lea    0x1(%eax),%edx
c0100383:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100386:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100389:	88 90 e0 6a 12 c0    	mov    %dl,-0x3fed9520(%eax)
c010038f:	eb 4c                	jmp    c01003dd <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c0100391:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100395:	75 1a                	jne    c01003b1 <readline+0x8f>
c0100397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010039b:	7e 14                	jle    c01003b1 <readline+0x8f>
            cputchar(c);
c010039d:	83 ec 0c             	sub    $0xc,%esp
c01003a0:	ff 75 f0             	pushl  -0x10(%ebp)
c01003a3:	e8 fc fe ff ff       	call   c01002a4 <cputchar>
c01003a8:	83 c4 10             	add    $0x10,%esp
            i --;
c01003ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003af:	eb 2c                	jmp    c01003dd <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01003b1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003b5:	74 06                	je     c01003bd <readline+0x9b>
c01003b7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003bb:	75 8b                	jne    c0100348 <readline+0x26>
            cputchar(c);
c01003bd:	83 ec 0c             	sub    $0xc,%esp
c01003c0:	ff 75 f0             	pushl  -0x10(%ebp)
c01003c3:	e8 dc fe ff ff       	call   c01002a4 <cputchar>
c01003c8:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ce:	05 e0 6a 12 c0       	add    $0xc0126ae0,%eax
c01003d3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003d6:	b8 e0 6a 12 c0       	mov    $0xc0126ae0,%eax
c01003db:	eb 05                	jmp    c01003e2 <readline+0xc0>
        }
    }
c01003dd:	e9 66 ff ff ff       	jmp    c0100348 <readline+0x26>
}
c01003e2:	c9                   	leave  
c01003e3:	c3                   	ret    

c01003e4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e4:	55                   	push   %ebp
c01003e5:	89 e5                	mov    %esp,%ebp
c01003e7:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003ea:	a1 e0 6e 12 c0       	mov    0xc0126ee0,%eax
c01003ef:	85 c0                	test   %eax,%eax
c01003f1:	75 4a                	jne    c010043d <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003f3:	c7 05 e0 6e 12 c0 01 	movl   $0x1,0xc0126ee0
c01003fa:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100403:	83 ec 04             	sub    $0x4,%esp
c0100406:	ff 75 0c             	pushl  0xc(%ebp)
c0100409:	ff 75 08             	pushl  0x8(%ebp)
c010040c:	68 aa 9f 10 c0       	push   $0xc0109faa
c0100411:	e8 68 fe ff ff       	call   c010027e <cprintf>
c0100416:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100419:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010041c:	83 ec 08             	sub    $0x8,%esp
c010041f:	50                   	push   %eax
c0100420:	ff 75 10             	pushl  0x10(%ebp)
c0100423:	e8 2d fe ff ff       	call   c0100255 <vcprintf>
c0100428:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010042b:	83 ec 0c             	sub    $0xc,%esp
c010042e:	68 c6 9f 10 c0       	push   $0xc0109fc6
c0100433:	e8 46 fe ff ff       	call   c010027e <cprintf>
c0100438:	83 c4 10             	add    $0x10,%esp
c010043b:	eb 01                	jmp    c010043e <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010043d:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c010043e:	e8 67 1c 00 00       	call   c01020aa <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100443:	83 ec 0c             	sub    $0xc,%esp
c0100446:	6a 00                	push   $0x0
c0100448:	e8 30 08 00 00       	call   c0100c7d <kmonitor>
c010044d:	83 c4 10             	add    $0x10,%esp
    }
c0100450:	eb f1                	jmp    c0100443 <__panic+0x5f>

c0100452 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100452:	55                   	push   %ebp
c0100453:	89 e5                	mov    %esp,%ebp
c0100455:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100458:	8d 45 14             	lea    0x14(%ebp),%eax
c010045b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010045e:	83 ec 04             	sub    $0x4,%esp
c0100461:	ff 75 0c             	pushl  0xc(%ebp)
c0100464:	ff 75 08             	pushl  0x8(%ebp)
c0100467:	68 c8 9f 10 c0       	push   $0xc0109fc8
c010046c:	e8 0d fe ff ff       	call   c010027e <cprintf>
c0100471:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100474:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100477:	83 ec 08             	sub    $0x8,%esp
c010047a:	50                   	push   %eax
c010047b:	ff 75 10             	pushl  0x10(%ebp)
c010047e:	e8 d2 fd ff ff       	call   c0100255 <vcprintf>
c0100483:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100486:	83 ec 0c             	sub    $0xc,%esp
c0100489:	68 c6 9f 10 c0       	push   $0xc0109fc6
c010048e:	e8 eb fd ff ff       	call   c010027e <cprintf>
c0100493:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100496:	90                   	nop
c0100497:	c9                   	leave  
c0100498:	c3                   	ret    

c0100499 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100499:	55                   	push   %ebp
c010049a:	89 e5                	mov    %esp,%ebp
    return is_panic;
c010049c:	a1 e0 6e 12 c0       	mov    0xc0126ee0,%eax
}
c01004a1:	5d                   	pop    %ebp
c01004a2:	c3                   	ret    

c01004a3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004a3:	55                   	push   %ebp
c01004a4:	89 e5                	mov    %esp,%ebp
c01004a6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ac:	8b 00                	mov    (%eax),%eax
c01004ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b4:	8b 00                	mov    (%eax),%eax
c01004b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004c0:	e9 d2 00 00 00       	jmp    c0100597 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004cb:	01 d0                	add    %edx,%eax
c01004cd:	89 c2                	mov    %eax,%edx
c01004cf:	c1 ea 1f             	shr    $0x1f,%edx
c01004d2:	01 d0                	add    %edx,%eax
c01004d4:	d1 f8                	sar    %eax
c01004d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004df:	eb 04                	jmp    c01004e5 <stab_binsearch+0x42>
            m --;
c01004e1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004eb:	7c 1f                	jl     c010050c <stab_binsearch+0x69>
c01004ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004f0:	89 d0                	mov    %edx,%eax
c01004f2:	01 c0                	add    %eax,%eax
c01004f4:	01 d0                	add    %edx,%eax
c01004f6:	c1 e0 02             	shl    $0x2,%eax
c01004f9:	89 c2                	mov    %eax,%edx
c01004fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01004fe:	01 d0                	add    %edx,%eax
c0100500:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100504:	0f b6 c0             	movzbl %al,%eax
c0100507:	3b 45 14             	cmp    0x14(%ebp),%eax
c010050a:	75 d5                	jne    c01004e1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010050c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010050f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100512:	7d 0b                	jge    c010051f <stab_binsearch+0x7c>
            l = true_m + 1;
c0100514:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100517:	83 c0 01             	add    $0x1,%eax
c010051a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010051d:	eb 78                	jmp    c0100597 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c010051f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100526:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100529:	89 d0                	mov    %edx,%eax
c010052b:	01 c0                	add    %eax,%eax
c010052d:	01 d0                	add    %edx,%eax
c010052f:	c1 e0 02             	shl    $0x2,%eax
c0100532:	89 c2                	mov    %eax,%edx
c0100534:	8b 45 08             	mov    0x8(%ebp),%eax
c0100537:	01 d0                	add    %edx,%eax
c0100539:	8b 40 08             	mov    0x8(%eax),%eax
c010053c:	3b 45 18             	cmp    0x18(%ebp),%eax
c010053f:	73 13                	jae    c0100554 <stab_binsearch+0xb1>
            *region_left = m;
c0100541:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100544:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100547:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100549:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010054c:	83 c0 01             	add    $0x1,%eax
c010054f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100552:	eb 43                	jmp    c0100597 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100554:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100557:	89 d0                	mov    %edx,%eax
c0100559:	01 c0                	add    %eax,%eax
c010055b:	01 d0                	add    %edx,%eax
c010055d:	c1 e0 02             	shl    $0x2,%eax
c0100560:	89 c2                	mov    %eax,%edx
c0100562:	8b 45 08             	mov    0x8(%ebp),%eax
c0100565:	01 d0                	add    %edx,%eax
c0100567:	8b 40 08             	mov    0x8(%eax),%eax
c010056a:	3b 45 18             	cmp    0x18(%ebp),%eax
c010056d:	76 16                	jbe    c0100585 <stab_binsearch+0xe2>
            *region_right = m - 1;
c010056f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100572:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100575:	8b 45 10             	mov    0x10(%ebp),%eax
c0100578:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057d:	83 e8 01             	sub    $0x1,%eax
c0100580:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100583:	eb 12                	jmp    c0100597 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100585:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100588:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010058b:	89 10                	mov    %edx,(%eax)
            l = m;
c010058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100590:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c0100593:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100597:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010059a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010059d:	0f 8e 22 ff ff ff    	jle    c01004c5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01005a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005a7:	75 0f                	jne    c01005b8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ac:	8b 00                	mov    (%eax),%eax
c01005ae:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005b4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005b6:	eb 3f                	jmp    c01005f7 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01005bb:	8b 00                	mov    (%eax),%eax
c01005bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005c0:	eb 04                	jmp    c01005c6 <stab_binsearch+0x123>
c01005c2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c9:	8b 00                	mov    (%eax),%eax
c01005cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005ce:	7d 1f                	jge    c01005ef <stab_binsearch+0x14c>
c01005d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005d3:	89 d0                	mov    %edx,%eax
c01005d5:	01 c0                	add    %eax,%eax
c01005d7:	01 d0                	add    %edx,%eax
c01005d9:	c1 e0 02             	shl    $0x2,%eax
c01005dc:	89 c2                	mov    %eax,%edx
c01005de:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e1:	01 d0                	add    %edx,%eax
c01005e3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005e7:	0f b6 c0             	movzbl %al,%eax
c01005ea:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005ed:	75 d3                	jne    c01005c2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f5:	89 10                	mov    %edx,(%eax)
    }
}
c01005f7:	90                   	nop
c01005f8:	c9                   	leave  
c01005f9:	c3                   	ret    

c01005fa <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005fa:	55                   	push   %ebp
c01005fb:	89 e5                	mov    %esp,%ebp
c01005fd:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100603:	c7 00 e8 9f 10 c0    	movl   $0xc0109fe8,(%eax)
    info->eip_line = 0;
c0100609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100616:	c7 40 08 e8 9f 10 c0 	movl   $0xc0109fe8,0x8(%eax)
    info->eip_fn_namelen = 9;
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062a:	8b 55 08             	mov    0x8(%ebp),%edx
c010062d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100633:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010063a:	c7 45 f4 c4 c3 10 c0 	movl   $0xc010c3c4,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100641:	c7 45 f0 44 eb 11 c0 	movl   $0xc011eb44,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100648:	c7 45 ec 45 eb 11 c0 	movl   $0xc011eb45,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010064f:	c7 45 e8 10 36 12 c0 	movl   $0xc0123610,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100656:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100659:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010065c:	76 0d                	jbe    c010066b <debuginfo_eip+0x71>
c010065e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100661:	83 e8 01             	sub    $0x1,%eax
c0100664:	0f b6 00             	movzbl (%eax),%eax
c0100667:	84 c0                	test   %al,%al
c0100669:	74 0a                	je     c0100675 <debuginfo_eip+0x7b>
        return -1;
c010066b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100670:	e9 91 02 00 00       	jmp    c0100906 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010067c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100682:	29 c2                	sub    %eax,%edx
c0100684:	89 d0                	mov    %edx,%eax
c0100686:	c1 f8 02             	sar    $0x2,%eax
c0100689:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010068f:	83 e8 01             	sub    $0x1,%eax
c0100692:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100695:	ff 75 08             	pushl  0x8(%ebp)
c0100698:	6a 64                	push   $0x64
c010069a:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010069d:	50                   	push   %eax
c010069e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006a1:	50                   	push   %eax
c01006a2:	ff 75 f4             	pushl  -0xc(%ebp)
c01006a5:	e8 f9 fd ff ff       	call   c01004a3 <stab_binsearch>
c01006aa:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01006ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006b0:	85 c0                	test   %eax,%eax
c01006b2:	75 0a                	jne    c01006be <debuginfo_eip+0xc4>
        return -1;
c01006b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b9:	e9 48 02 00 00       	jmp    c0100906 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006ca:	ff 75 08             	pushl  0x8(%ebp)
c01006cd:	6a 24                	push   $0x24
c01006cf:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006d2:	50                   	push   %eax
c01006d3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006d6:	50                   	push   %eax
c01006d7:	ff 75 f4             	pushl  -0xc(%ebp)
c01006da:	e8 c4 fd ff ff       	call   c01004a3 <stab_binsearch>
c01006df:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006e8:	39 c2                	cmp    %eax,%edx
c01006ea:	7f 7c                	jg     c0100768 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006ef:	89 c2                	mov    %eax,%edx
c01006f1:	89 d0                	mov    %edx,%eax
c01006f3:	01 c0                	add    %eax,%eax
c01006f5:	01 d0                	add    %edx,%eax
c01006f7:	c1 e0 02             	shl    $0x2,%eax
c01006fa:	89 c2                	mov    %eax,%edx
c01006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ff:	01 d0                	add    %edx,%eax
c0100701:	8b 00                	mov    (%eax),%eax
c0100703:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100706:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100709:	29 d1                	sub    %edx,%ecx
c010070b:	89 ca                	mov    %ecx,%edx
c010070d:	39 d0                	cmp    %edx,%eax
c010070f:	73 22                	jae    c0100733 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100711:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100714:	89 c2                	mov    %eax,%edx
c0100716:	89 d0                	mov    %edx,%eax
c0100718:	01 c0                	add    %eax,%eax
c010071a:	01 d0                	add    %edx,%eax
c010071c:	c1 e0 02             	shl    $0x2,%eax
c010071f:	89 c2                	mov    %eax,%edx
c0100721:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100724:	01 d0                	add    %edx,%eax
c0100726:	8b 10                	mov    (%eax),%edx
c0100728:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010072b:	01 c2                	add    %eax,%edx
c010072d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100730:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100733:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100736:	89 c2                	mov    %eax,%edx
c0100738:	89 d0                	mov    %edx,%eax
c010073a:	01 c0                	add    %eax,%eax
c010073c:	01 d0                	add    %edx,%eax
c010073e:	c1 e0 02             	shl    $0x2,%eax
c0100741:	89 c2                	mov    %eax,%edx
c0100743:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	8b 50 08             	mov    0x8(%eax),%edx
c010074b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8b 40 10             	mov    0x10(%eax),%eax
c0100757:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010075a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100760:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100766:	eb 15                	jmp    c010077d <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100768:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076b:	8b 55 08             	mov    0x8(%ebp),%edx
c010076e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100774:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100777:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010077a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010077d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100780:	8b 40 08             	mov    0x8(%eax),%eax
c0100783:	83 ec 08             	sub    $0x8,%esp
c0100786:	6a 3a                	push   $0x3a
c0100788:	50                   	push   %eax
c0100789:	e8 4c 8d 00 00       	call   c01094da <strfind>
c010078e:	83 c4 10             	add    $0x10,%esp
c0100791:	89 c2                	mov    %eax,%edx
c0100793:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100796:	8b 40 08             	mov    0x8(%eax),%eax
c0100799:	29 c2                	sub    %eax,%edx
c010079b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010079e:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007a1:	83 ec 0c             	sub    $0xc,%esp
c01007a4:	ff 75 08             	pushl  0x8(%ebp)
c01007a7:	6a 44                	push   $0x44
c01007a9:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007ac:	50                   	push   %eax
c01007ad:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007b0:	50                   	push   %eax
c01007b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01007b4:	e8 ea fc ff ff       	call   c01004a3 <stab_binsearch>
c01007b9:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007c2:	39 c2                	cmp    %eax,%edx
c01007c4:	7f 24                	jg     c01007ea <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007c9:	89 c2                	mov    %eax,%edx
c01007cb:	89 d0                	mov    %edx,%eax
c01007cd:	01 c0                	add    %eax,%eax
c01007cf:	01 d0                	add    %edx,%eax
c01007d1:	c1 e0 02             	shl    $0x2,%eax
c01007d4:	89 c2                	mov    %eax,%edx
c01007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d9:	01 d0                	add    %edx,%eax
c01007db:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007df:	0f b7 d0             	movzwl %ax,%edx
c01007e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e8:	eb 13                	jmp    c01007fd <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007ef:	e9 12 01 00 00       	jmp    c0100906 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	83 e8 01             	sub    $0x1,%eax
c01007fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100803:	39 c2                	cmp    %eax,%edx
c0100805:	7c 56                	jl     c010085d <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c0100807:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080a:	89 c2                	mov    %eax,%edx
c010080c:	89 d0                	mov    %edx,%eax
c010080e:	01 c0                	add    %eax,%eax
c0100810:	01 d0                	add    %edx,%eax
c0100812:	c1 e0 02             	shl    $0x2,%eax
c0100815:	89 c2                	mov    %eax,%edx
c0100817:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081a:	01 d0                	add    %edx,%eax
c010081c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100820:	3c 84                	cmp    $0x84,%al
c0100822:	74 39                	je     c010085d <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100824:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100827:	89 c2                	mov    %eax,%edx
c0100829:	89 d0                	mov    %edx,%eax
c010082b:	01 c0                	add    %eax,%eax
c010082d:	01 d0                	add    %edx,%eax
c010082f:	c1 e0 02             	shl    $0x2,%eax
c0100832:	89 c2                	mov    %eax,%edx
c0100834:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100837:	01 d0                	add    %edx,%eax
c0100839:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010083d:	3c 64                	cmp    $0x64,%al
c010083f:	75 b3                	jne    c01007f4 <debuginfo_eip+0x1fa>
c0100841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100844:	89 c2                	mov    %eax,%edx
c0100846:	89 d0                	mov    %edx,%eax
c0100848:	01 c0                	add    %eax,%eax
c010084a:	01 d0                	add    %edx,%eax
c010084c:	c1 e0 02             	shl    $0x2,%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100854:	01 d0                	add    %edx,%eax
c0100856:	8b 40 08             	mov    0x8(%eax),%eax
c0100859:	85 c0                	test   %eax,%eax
c010085b:	74 97                	je     c01007f4 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010085d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100863:	39 c2                	cmp    %eax,%edx
c0100865:	7c 46                	jl     c01008ad <debuginfo_eip+0x2b3>
c0100867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	89 d0                	mov    %edx,%eax
c010086e:	01 c0                	add    %eax,%eax
c0100870:	01 d0                	add    %edx,%eax
c0100872:	c1 e0 02             	shl    $0x2,%eax
c0100875:	89 c2                	mov    %eax,%edx
c0100877:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087a:	01 d0                	add    %edx,%eax
c010087c:	8b 00                	mov    (%eax),%eax
c010087e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100881:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100884:	29 d1                	sub    %edx,%ecx
c0100886:	89 ca                	mov    %ecx,%edx
c0100888:	39 d0                	cmp    %edx,%eax
c010088a:	73 21                	jae    c01008ad <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010088c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010088f:	89 c2                	mov    %eax,%edx
c0100891:	89 d0                	mov    %edx,%eax
c0100893:	01 c0                	add    %eax,%eax
c0100895:	01 d0                	add    %edx,%eax
c0100897:	c1 e0 02             	shl    $0x2,%eax
c010089a:	89 c2                	mov    %eax,%edx
c010089c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	8b 10                	mov    (%eax),%edx
c01008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008a6:	01 c2                	add    %eax,%edx
c01008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ab:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008b3:	39 c2                	cmp    %eax,%edx
c01008b5:	7d 4a                	jge    c0100901 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008ba:	83 c0 01             	add    $0x1,%eax
c01008bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008c0:	eb 18                	jmp    c01008da <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008c5:	8b 40 14             	mov    0x14(%eax),%eax
c01008c8:	8d 50 01             	lea    0x1(%eax),%edx
c01008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ce:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d4:	83 c0 01             	add    $0x1,%eax
c01008d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008e0:	39 c2                	cmp    %eax,%edx
c01008e2:	7d 1d                	jge    c0100901 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008e7:	89 c2                	mov    %eax,%edx
c01008e9:	89 d0                	mov    %edx,%eax
c01008eb:	01 c0                	add    %eax,%eax
c01008ed:	01 d0                	add    %edx,%eax
c01008ef:	c1 e0 02             	shl    $0x2,%eax
c01008f2:	89 c2                	mov    %eax,%edx
c01008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f7:	01 d0                	add    %edx,%eax
c01008f9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008fd:	3c a0                	cmp    $0xa0,%al
c01008ff:	74 c1                	je     c01008c2 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100901:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100906:	c9                   	leave  
c0100907:	c3                   	ret    

c0100908 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100908:	55                   	push   %ebp
c0100909:	89 e5                	mov    %esp,%ebp
c010090b:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010090e:	83 ec 0c             	sub    $0xc,%esp
c0100911:	68 f2 9f 10 c0       	push   $0xc0109ff2
c0100916:	e8 63 f9 ff ff       	call   c010027e <cprintf>
c010091b:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010091e:	83 ec 08             	sub    $0x8,%esp
c0100921:	68 2a 00 10 c0       	push   $0xc010002a
c0100926:	68 0b a0 10 c0       	push   $0xc010a00b
c010092b:	e8 4e f9 ff ff       	call   c010027e <cprintf>
c0100930:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100933:	83 ec 08             	sub    $0x8,%esp
c0100936:	68 fa 9e 10 c0       	push   $0xc0109efa
c010093b:	68 23 a0 10 c0       	push   $0xc010a023
c0100940:	e8 39 f9 ff ff       	call   c010027e <cprintf>
c0100945:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100948:	83 ec 08             	sub    $0x8,%esp
c010094b:	68 b0 6a 12 c0       	push   $0xc0126ab0
c0100950:	68 3b a0 10 c0       	push   $0xc010a03b
c0100955:	e8 24 f9 ff ff       	call   c010027e <cprintf>
c010095a:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010095d:	83 ec 08             	sub    $0x8,%esp
c0100960:	68 2c 9c 12 c0       	push   $0xc0129c2c
c0100965:	68 53 a0 10 c0       	push   $0xc010a053
c010096a:	e8 0f f9 ff ff       	call   c010027e <cprintf>
c010096f:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100972:	b8 2c 9c 12 c0       	mov    $0xc0129c2c,%eax
c0100977:	05 ff 03 00 00       	add    $0x3ff,%eax
c010097c:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c0100981:	29 d0                	sub    %edx,%eax
c0100983:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100989:	85 c0                	test   %eax,%eax
c010098b:	0f 48 c2             	cmovs  %edx,%eax
c010098e:	c1 f8 0a             	sar    $0xa,%eax
c0100991:	83 ec 08             	sub    $0x8,%esp
c0100994:	50                   	push   %eax
c0100995:	68 6c a0 10 c0       	push   $0xc010a06c
c010099a:	e8 df f8 ff ff       	call   c010027e <cprintf>
c010099f:	83 c4 10             	add    $0x10,%esp
}
c01009a2:	90                   	nop
c01009a3:	c9                   	leave  
c01009a4:	c3                   	ret    

c01009a5 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009a5:	55                   	push   %ebp
c01009a6:	89 e5                	mov    %esp,%ebp
c01009a8:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009ae:	83 ec 08             	sub    $0x8,%esp
c01009b1:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009b4:	50                   	push   %eax
c01009b5:	ff 75 08             	pushl  0x8(%ebp)
c01009b8:	e8 3d fc ff ff       	call   c01005fa <debuginfo_eip>
c01009bd:	83 c4 10             	add    $0x10,%esp
c01009c0:	85 c0                	test   %eax,%eax
c01009c2:	74 15                	je     c01009d9 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009c4:	83 ec 08             	sub    $0x8,%esp
c01009c7:	ff 75 08             	pushl  0x8(%ebp)
c01009ca:	68 96 a0 10 c0       	push   $0xc010a096
c01009cf:	e8 aa f8 ff ff       	call   c010027e <cprintf>
c01009d4:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009d7:	eb 65                	jmp    c0100a3e <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009e0:	eb 1c                	jmp    c01009fe <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e8:	01 d0                	add    %edx,%eax
c01009ea:	0f b6 00             	movzbl (%eax),%eax
c01009ed:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009f6:	01 ca                	add    %ecx,%edx
c01009f8:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a01:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a04:	7f dc                	jg     c01009e2 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a06:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0f:	01 d0                	add    %edx,%eax
c0100a11:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a17:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a1a:	89 d1                	mov    %edx,%ecx
c0100a1c:	29 c1                	sub    %eax,%ecx
c0100a1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a24:	83 ec 0c             	sub    $0xc,%esp
c0100a27:	51                   	push   %ecx
c0100a28:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a2e:	51                   	push   %ecx
c0100a2f:	52                   	push   %edx
c0100a30:	50                   	push   %eax
c0100a31:	68 b2 a0 10 c0       	push   $0xc010a0b2
c0100a36:	e8 43 f8 ff ff       	call   c010027e <cprintf>
c0100a3b:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a3e:	90                   	nop
c0100a3f:	c9                   	leave  
c0100a40:	c3                   	ret    

c0100a41 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a41:	55                   	push   %ebp
c0100a42:	89 e5                	mov    %esp,%ebp
c0100a44:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a47:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a50:	c9                   	leave  
c0100a51:	c3                   	ret    

c0100a52 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a52:	55                   	push   %ebp
c0100a53:	89 e5                	mov    %esp,%ebp
c0100a55:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a58:	89 e8                	mov    %ebp,%eax
c0100a5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
c0100a63:	e8 d9 ff ff ff       	call   c0100a41 <read_eip>
c0100a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
c0100a6b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a72:	e9 87 00 00 00       	jmp    c0100afe <print_stackframe+0xac>
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
c0100a77:	83 ec 04             	sub    $0x4,%esp
c0100a7a:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a7d:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a80:	68 c4 a0 10 c0       	push   $0xc010a0c4
c0100a85:	e8 f4 f7 ff ff       	call   c010027e <cprintf>
c0100a8a:	83 c4 10             	add    $0x10,%esp
		for (int argi = 0; argi < 4; ++ argi) {
c0100a8d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a94:	eb 29                	jmp    c0100abf <print_stackframe+0x6d>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
c0100a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aa3:	01 d0                	add    %edx,%eax
c0100aa5:	83 c0 08             	add    $0x8,%eax
c0100aa8:	8b 00                	mov    (%eax),%eax
c0100aaa:	83 ec 08             	sub    $0x8,%esp
c0100aad:	50                   	push   %eax
c0100aae:	68 e0 a0 10 c0       	push   $0xc010a0e0
c0100ab3:	e8 c6 f7 ff ff       	call   c010027e <cprintf>
c0100ab8:	83 c4 10             	add    $0x10,%esp
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
		for (int argi = 0; argi < 4; ++ argi) {
c0100abb:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100abf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ac3:	7e d1                	jle    c0100a96 <print_stackframe+0x44>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
		}
		cprintf("\n");
c0100ac5:	83 ec 0c             	sub    $0xc,%esp
c0100ac8:	68 e8 a0 10 c0       	push   $0xc010a0e8
c0100acd:	e8 ac f7 ff ff       	call   c010027e <cprintf>
c0100ad2:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(current_eip - 1);
c0100ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ad8:	83 e8 01             	sub    $0x1,%eax
c0100adb:	83 ec 0c             	sub    $0xc,%esp
c0100ade:	50                   	push   %eax
c0100adf:	e8 c1 fe ff ff       	call   c01009a5 <print_debuginfo>
c0100ae4:	83 c4 10             	add    $0x10,%esp
		current_eip = *((uint32_t*)current_ebp + 1);
c0100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aea:	83 c0 04             	add    $0x4,%eax
c0100aed:	8b 00                	mov    (%eax),%eax
c0100aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);
c0100af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af5:	8b 00                	mov    (%eax),%eax
c0100af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
c0100afa:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100afe:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b02:	7f 0a                	jg     c0100b0e <print_stackframe+0xbc>
c0100b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b08:	0f 85 69 ff ff ff    	jne    c0100a77 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(current_eip - 1);
		current_eip = *((uint32_t*)current_ebp + 1);
		current_ebp = *((uint32_t*)current_ebp);
	}
}
c0100b0e:	90                   	nop
c0100b0f:	c9                   	leave  
c0100b10:	c3                   	ret    

c0100b11 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b11:	55                   	push   %ebp
c0100b12:	89 e5                	mov    %esp,%ebp
c0100b14:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b1e:	eb 0c                	jmp    c0100b2c <parse+0x1b>
            *buf ++ = '\0';
c0100b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b23:	8d 50 01             	lea    0x1(%eax),%edx
c0100b26:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b29:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2f:	0f b6 00             	movzbl (%eax),%eax
c0100b32:	84 c0                	test   %al,%al
c0100b34:	74 1e                	je     c0100b54 <parse+0x43>
c0100b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b39:	0f b6 00             	movzbl (%eax),%eax
c0100b3c:	0f be c0             	movsbl %al,%eax
c0100b3f:	83 ec 08             	sub    $0x8,%esp
c0100b42:	50                   	push   %eax
c0100b43:	68 6c a1 10 c0       	push   $0xc010a16c
c0100b48:	e8 5a 89 00 00       	call   c01094a7 <strchr>
c0100b4d:	83 c4 10             	add    $0x10,%esp
c0100b50:	85 c0                	test   %eax,%eax
c0100b52:	75 cc                	jne    c0100b20 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b57:	0f b6 00             	movzbl (%eax),%eax
c0100b5a:	84 c0                	test   %al,%al
c0100b5c:	74 69                	je     c0100bc7 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b5e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b62:	75 12                	jne    c0100b76 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b64:	83 ec 08             	sub    $0x8,%esp
c0100b67:	6a 10                	push   $0x10
c0100b69:	68 71 a1 10 c0       	push   $0xc010a171
c0100b6e:	e8 0b f7 ff ff       	call   c010027e <cprintf>
c0100b73:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b79:	8d 50 01             	lea    0x1(%eax),%edx
c0100b7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b7f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b89:	01 c2                	add    %eax,%edx
c0100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b90:	eb 04                	jmp    c0100b96 <parse+0x85>
            buf ++;
c0100b92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b99:	0f b6 00             	movzbl (%eax),%eax
c0100b9c:	84 c0                	test   %al,%al
c0100b9e:	0f 84 7a ff ff ff    	je     c0100b1e <parse+0xd>
c0100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba7:	0f b6 00             	movzbl (%eax),%eax
c0100baa:	0f be c0             	movsbl %al,%eax
c0100bad:	83 ec 08             	sub    $0x8,%esp
c0100bb0:	50                   	push   %eax
c0100bb1:	68 6c a1 10 c0       	push   $0xc010a16c
c0100bb6:	e8 ec 88 00 00       	call   c01094a7 <strchr>
c0100bbb:	83 c4 10             	add    $0x10,%esp
c0100bbe:	85 c0                	test   %eax,%eax
c0100bc0:	74 d0                	je     c0100b92 <parse+0x81>
            buf ++;
        }
    }
c0100bc2:	e9 57 ff ff ff       	jmp    c0100b1e <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bc7:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bcb:	c9                   	leave  
c0100bcc:	c3                   	ret    

c0100bcd <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bcd:	55                   	push   %ebp
c0100bce:	89 e5                	mov    %esp,%ebp
c0100bd0:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bd3:	83 ec 08             	sub    $0x8,%esp
c0100bd6:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bd9:	50                   	push   %eax
c0100bda:	ff 75 08             	pushl  0x8(%ebp)
c0100bdd:	e8 2f ff ff ff       	call   c0100b11 <parse>
c0100be2:	83 c4 10             	add    $0x10,%esp
c0100be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bec:	75 0a                	jne    c0100bf8 <runcmd+0x2b>
        return 0;
c0100bee:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bf3:	e9 83 00 00 00       	jmp    c0100c7b <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bff:	eb 59                	jmp    c0100c5a <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c01:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c07:	89 d0                	mov    %edx,%eax
c0100c09:	01 c0                	add    %eax,%eax
c0100c0b:	01 d0                	add    %edx,%eax
c0100c0d:	c1 e0 02             	shl    $0x2,%eax
c0100c10:	05 20 60 12 c0       	add    $0xc0126020,%eax
c0100c15:	8b 00                	mov    (%eax),%eax
c0100c17:	83 ec 08             	sub    $0x8,%esp
c0100c1a:	51                   	push   %ecx
c0100c1b:	50                   	push   %eax
c0100c1c:	e8 e6 87 00 00       	call   c0109407 <strcmp>
c0100c21:	83 c4 10             	add    $0x10,%esp
c0100c24:	85 c0                	test   %eax,%eax
c0100c26:	75 2e                	jne    c0100c56 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c2b:	89 d0                	mov    %edx,%eax
c0100c2d:	01 c0                	add    %eax,%eax
c0100c2f:	01 d0                	add    %edx,%eax
c0100c31:	c1 e0 02             	shl    $0x2,%eax
c0100c34:	05 28 60 12 c0       	add    $0xc0126028,%eax
c0100c39:	8b 10                	mov    (%eax),%edx
c0100c3b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c3e:	83 c0 04             	add    $0x4,%eax
c0100c41:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c44:	83 e9 01             	sub    $0x1,%ecx
c0100c47:	83 ec 04             	sub    $0x4,%esp
c0100c4a:	ff 75 0c             	pushl  0xc(%ebp)
c0100c4d:	50                   	push   %eax
c0100c4e:	51                   	push   %ecx
c0100c4f:	ff d2                	call   *%edx
c0100c51:	83 c4 10             	add    $0x10,%esp
c0100c54:	eb 25                	jmp    c0100c7b <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5d:	83 f8 02             	cmp    $0x2,%eax
c0100c60:	76 9f                	jbe    c0100c01 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c62:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c65:	83 ec 08             	sub    $0x8,%esp
c0100c68:	50                   	push   %eax
c0100c69:	68 8f a1 10 c0       	push   $0xc010a18f
c0100c6e:	e8 0b f6 ff ff       	call   c010027e <cprintf>
c0100c73:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c7b:	c9                   	leave  
c0100c7c:	c3                   	ret    

c0100c7d <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c7d:	55                   	push   %ebp
c0100c7e:	89 e5                	mov    %esp,%ebp
c0100c80:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c83:	83 ec 0c             	sub    $0xc,%esp
c0100c86:	68 a8 a1 10 c0       	push   $0xc010a1a8
c0100c8b:	e8 ee f5 ff ff       	call   c010027e <cprintf>
c0100c90:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c93:	83 ec 0c             	sub    $0xc,%esp
c0100c96:	68 d0 a1 10 c0       	push   $0xc010a1d0
c0100c9b:	e8 de f5 ff ff       	call   c010027e <cprintf>
c0100ca0:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ca7:	74 0e                	je     c0100cb7 <kmonitor+0x3a>
        print_trapframe(tf);
c0100ca9:	83 ec 0c             	sub    $0xc,%esp
c0100cac:	ff 75 08             	pushl  0x8(%ebp)
c0100caf:	e8 46 16 00 00       	call   c01022fa <print_trapframe>
c0100cb4:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cb7:	83 ec 0c             	sub    $0xc,%esp
c0100cba:	68 f5 a1 10 c0       	push   $0xc010a1f5
c0100cbf:	e8 5e f6 ff ff       	call   c0100322 <readline>
c0100cc4:	83 c4 10             	add    $0x10,%esp
c0100cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cce:	74 e7                	je     c0100cb7 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cd0:	83 ec 08             	sub    $0x8,%esp
c0100cd3:	ff 75 08             	pushl  0x8(%ebp)
c0100cd6:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cd9:	e8 ef fe ff ff       	call   c0100bcd <runcmd>
c0100cde:	83 c4 10             	add    $0x10,%esp
c0100ce1:	85 c0                	test   %eax,%eax
c0100ce3:	78 02                	js     c0100ce7 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100ce5:	eb d0                	jmp    c0100cb7 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100ce7:	90                   	nop
            }
        }
    }
}
c0100ce8:	90                   	nop
c0100ce9:	c9                   	leave  
c0100cea:	c3                   	ret    

c0100ceb <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100ceb:	55                   	push   %ebp
c0100cec:	89 e5                	mov    %esp,%ebp
c0100cee:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cf1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cf8:	eb 3c                	jmp    c0100d36 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cfd:	89 d0                	mov    %edx,%eax
c0100cff:	01 c0                	add    %eax,%eax
c0100d01:	01 d0                	add    %edx,%eax
c0100d03:	c1 e0 02             	shl    $0x2,%eax
c0100d06:	05 24 60 12 c0       	add    $0xc0126024,%eax
c0100d0b:	8b 08                	mov    (%eax),%ecx
c0100d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d10:	89 d0                	mov    %edx,%eax
c0100d12:	01 c0                	add    %eax,%eax
c0100d14:	01 d0                	add    %edx,%eax
c0100d16:	c1 e0 02             	shl    $0x2,%eax
c0100d19:	05 20 60 12 c0       	add    $0xc0126020,%eax
c0100d1e:	8b 00                	mov    (%eax),%eax
c0100d20:	83 ec 04             	sub    $0x4,%esp
c0100d23:	51                   	push   %ecx
c0100d24:	50                   	push   %eax
c0100d25:	68 f9 a1 10 c0       	push   $0xc010a1f9
c0100d2a:	e8 4f f5 ff ff       	call   c010027e <cprintf>
c0100d2f:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d39:	83 f8 02             	cmp    $0x2,%eax
c0100d3c:	76 bc                	jbe    c0100cfa <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d43:	c9                   	leave  
c0100d44:	c3                   	ret    

c0100d45 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d45:	55                   	push   %ebp
c0100d46:	89 e5                	mov    %esp,%ebp
c0100d48:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d4b:	e8 b8 fb ff ff       	call   c0100908 <print_kerninfo>
    return 0;
c0100d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d55:	c9                   	leave  
c0100d56:	c3                   	ret    

c0100d57 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d57:	55                   	push   %ebp
c0100d58:	89 e5                	mov    %esp,%ebp
c0100d5a:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d5d:	e8 f0 fc ff ff       	call   c0100a52 <print_stackframe>
    return 0;
c0100d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d67:	c9                   	leave  
c0100d68:	c3                   	ret    

c0100d69 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100d69:	55                   	push   %ebp
c0100d6a:	89 e5                	mov    %esp,%ebp
c0100d6c:	83 ec 14             	sub    $0x14,%esp
c0100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d72:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100d76:	90                   	nop
c0100d77:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0100d7b:	83 c0 07             	add    $0x7,%eax
c0100d7e:	0f b7 c0             	movzwl %ax,%eax
c0100d81:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d85:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d89:	89 c2                	mov    %eax,%edx
c0100d8b:	ec                   	in     (%dx),%al
c0100d8c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100d8f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100d93:	0f b6 c0             	movzbl %al,%eax
c0100d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100d9c:	25 80 00 00 00       	and    $0x80,%eax
c0100da1:	85 c0                	test   %eax,%eax
c0100da3:	75 d2                	jne    c0100d77 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100da5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100da9:	74 11                	je     c0100dbc <ide_wait_ready+0x53>
c0100dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dae:	83 e0 21             	and    $0x21,%eax
c0100db1:	85 c0                	test   %eax,%eax
c0100db3:	74 07                	je     c0100dbc <ide_wait_ready+0x53>
        return -1;
c0100db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100dba:	eb 05                	jmp    c0100dc1 <ide_wait_ready+0x58>
    }
    return 0;
c0100dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc1:	c9                   	leave  
c0100dc2:	c3                   	ret    

c0100dc3 <ide_init>:

void
ide_init(void) {
c0100dc3:	55                   	push   %ebp
c0100dc4:	89 e5                	mov    %esp,%ebp
c0100dc6:	57                   	push   %edi
c0100dc7:	53                   	push   %ebx
c0100dc8:	81 ec 40 02 00 00    	sub    $0x240,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100dce:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100dd4:	e9 c1 02 00 00       	jmp    c010109a <ide_init+0x2d7>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100dd9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ddd:	c1 e0 03             	shl    $0x3,%eax
c0100de0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100de7:	29 c2                	sub    %eax,%edx
c0100de9:	89 d0                	mov    %edx,%eax
c0100deb:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c0100df0:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100df3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100df7:	66 d1 e8             	shr    %ax
c0100dfa:	0f b7 c0             	movzwl %ax,%eax
c0100dfd:	0f b7 04 85 04 a2 10 	movzwl -0x3fef5dfc(,%eax,4),%eax
c0100e04:	c0 
c0100e05:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e09:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e0d:	6a 00                	push   $0x0
c0100e0f:	50                   	push   %eax
c0100e10:	e8 54 ff ff ff       	call   c0100d69 <ide_wait_ready>
c0100e15:	83 c4 08             	add    $0x8,%esp

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e18:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e1c:	83 e0 01             	and    $0x1,%eax
c0100e1f:	c1 e0 04             	shl    $0x4,%eax
c0100e22:	83 c8 e0             	or     $0xffffffe0,%eax
c0100e25:	0f b6 c0             	movzbl %al,%eax
c0100e28:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e2c:	83 c2 06             	add    $0x6,%edx
c0100e2f:	0f b7 d2             	movzwl %dx,%edx
c0100e32:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0100e36:	88 45 c7             	mov    %al,-0x39(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e39:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
c0100e3d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100e41:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e42:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e46:	6a 00                	push   $0x0
c0100e48:	50                   	push   %eax
c0100e49:	e8 1b ff ff ff       	call   c0100d69 <ide_wait_ready>
c0100e4e:	83 c4 08             	add    $0x8,%esp

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100e51:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e55:	83 c0 07             	add    $0x7,%eax
c0100e58:	0f b7 c0             	movzwl %ax,%eax
c0100e5b:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
c0100e5f:	c6 45 c8 ec          	movb   $0xec,-0x38(%ebp)
c0100e63:	0f b6 45 c8          	movzbl -0x38(%ebp),%eax
c0100e67:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c0100e6b:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e6c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e70:	6a 00                	push   $0x0
c0100e72:	50                   	push   %eax
c0100e73:	e8 f1 fe ff ff       	call   c0100d69 <ide_wait_ready>
c0100e78:	83 c4 08             	add    $0x8,%esp

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100e7b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e7f:	83 c0 07             	add    $0x7,%eax
c0100e82:	0f b7 c0             	movzwl %ax,%eax
c0100e85:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e89:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100e8d:	89 c2                	mov    %eax,%edx
c0100e8f:	ec                   	in     (%dx),%al
c0100e90:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100e93:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100e97:	84 c0                	test   %al,%al
c0100e99:	0f 84 ef 01 00 00    	je     c010108e <ide_init+0x2cb>
c0100e9f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ea3:	6a 01                	push   $0x1
c0100ea5:	50                   	push   %eax
c0100ea6:	e8 be fe ff ff       	call   c0100d69 <ide_wait_ready>
c0100eab:	83 c4 08             	add    $0x8,%esp
c0100eae:	85 c0                	test   %eax,%eax
c0100eb0:	0f 85 d8 01 00 00    	jne    c010108e <ide_init+0x2cb>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100eb6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100eba:	c1 e0 03             	shl    $0x3,%eax
c0100ebd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100ec4:	29 c2                	sub    %eax,%edx
c0100ec6:	89 d0                	mov    %edx,%eax
c0100ec8:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c0100ecd:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100ed0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ed4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100ed7:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100edd:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100ee0:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0100ee7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100eea:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100eed:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100ef0:	89 cb                	mov    %ecx,%ebx
c0100ef2:	89 df                	mov    %ebx,%edi
c0100ef4:	89 c1                	mov    %eax,%ecx
c0100ef6:	fc                   	cld    
c0100ef7:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100ef9:	89 c8                	mov    %ecx,%eax
c0100efb:	89 fb                	mov    %edi,%ebx
c0100efd:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f00:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f03:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f0f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f15:	89 45 d8             	mov    %eax,-0x28(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f18:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f1b:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f20:	85 c0                	test   %eax,%eax
c0100f22:	74 0e                	je     c0100f32 <ide_init+0x16f>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f24:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f27:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100f30:	eb 09                	jmp    c0100f3b <ide_init+0x178>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f35:	8b 40 78             	mov    0x78(%eax),%eax
c0100f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100f3b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f3f:	c1 e0 03             	shl    $0x3,%eax
c0100f42:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f49:	29 c2                	sub    %eax,%edx
c0100f4b:	89 d0                	mov    %edx,%eax
c0100f4d:	8d 90 04 6f 12 c0    	lea    -0x3fed90fc(%eax),%edx
c0100f53:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f56:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100f58:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f5c:	c1 e0 03             	shl    $0x3,%eax
c0100f5f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f66:	29 c2                	sub    %eax,%edx
c0100f68:	89 d0                	mov    %edx,%eax
c0100f6a:	8d 90 08 6f 12 c0    	lea    -0x3fed90f8(%eax),%edx
c0100f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f73:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100f75:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f78:	83 c0 62             	add    $0x62,%eax
c0100f7b:	0f b7 00             	movzwl (%eax),%eax
c0100f7e:	0f b7 c0             	movzwl %ax,%eax
c0100f81:	25 00 02 00 00       	and    $0x200,%eax
c0100f86:	85 c0                	test   %eax,%eax
c0100f88:	75 16                	jne    c0100fa0 <ide_init+0x1dd>
c0100f8a:	68 0c a2 10 c0       	push   $0xc010a20c
c0100f8f:	68 4f a2 10 c0       	push   $0xc010a24f
c0100f94:	6a 7d                	push   $0x7d
c0100f96:	68 64 a2 10 c0       	push   $0xc010a264
c0100f9b:	e8 44 f4 ff ff       	call   c01003e4 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0100fa0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fa4:	89 c2                	mov    %eax,%edx
c0100fa6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fad:	89 c2                	mov    %eax,%edx
c0100faf:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fb6:	29 d0                	sub    %edx,%eax
c0100fb8:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c0100fbd:	83 c0 0c             	add    $0xc,%eax
c0100fc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100fc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100fc6:	83 c0 36             	add    $0x36,%eax
c0100fc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        unsigned int i, length = 40;
c0100fcc:	c7 45 cc 28 00 00 00 	movl   $0x28,-0x34(%ebp)
        for (i = 0; i < length; i += 2) {
c0100fd3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100fda:	eb 34                	jmp    c0101010 <ide_init+0x24d>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0100fdc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100fe2:	01 c2                	add    %eax,%edx
c0100fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100fe7:	8d 48 01             	lea    0x1(%eax),%ecx
c0100fea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100fed:	01 c8                	add    %ecx,%eax
c0100fef:	0f b6 00             	movzbl (%eax),%eax
c0100ff2:	88 02                	mov    %al,(%edx)
c0100ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100ff7:	8d 50 01             	lea    0x1(%eax),%edx
c0100ffa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100ffd:	01 c2                	add    %eax,%edx
c0100fff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101002:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101005:	01 c8                	add    %ecx,%eax
c0101007:	0f b6 00             	movzbl (%eax),%eax
c010100a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010100c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101010:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101013:	3b 45 cc             	cmp    -0x34(%ebp),%eax
c0101016:	72 c4                	jb     c0100fdc <ide_init+0x219>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101018:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010101b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010101e:	01 d0                	add    %edx,%eax
c0101020:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101023:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101026:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101029:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010102c:	85 c0                	test   %eax,%eax
c010102e:	74 0f                	je     c010103f <ide_init+0x27c>
c0101030:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101033:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101036:	01 d0                	add    %edx,%eax
c0101038:	0f b6 00             	movzbl (%eax),%eax
c010103b:	3c 20                	cmp    $0x20,%al
c010103d:	74 d9                	je     c0101018 <ide_init+0x255>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010103f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101043:	89 c2                	mov    %eax,%edx
c0101045:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c010104c:	89 c2                	mov    %eax,%edx
c010104e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0101055:	29 d0                	sub    %edx,%eax
c0101057:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c010105c:	8d 48 0c             	lea    0xc(%eax),%ecx
c010105f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101063:	c1 e0 03             	shl    $0x3,%eax
c0101066:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010106d:	29 c2                	sub    %eax,%edx
c010106f:	89 d0                	mov    %edx,%eax
c0101071:	05 08 6f 12 c0       	add    $0xc0126f08,%eax
c0101076:	8b 10                	mov    (%eax),%edx
c0101078:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010107c:	51                   	push   %ecx
c010107d:	52                   	push   %edx
c010107e:	50                   	push   %eax
c010107f:	68 76 a2 10 c0       	push   $0xc010a276
c0101084:	e8 f5 f1 ff ff       	call   c010027e <cprintf>
c0101089:	83 c4 10             	add    $0x10,%esp
c010108c:	eb 01                	jmp    c010108f <ide_init+0x2cc>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c010108e:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010108f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101093:	83 c0 01             	add    $0x1,%eax
c0101096:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c010109a:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c010109f:	0f 86 34 fd ff ff    	jbe    c0100dd9 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01010a5:	83 ec 0c             	sub    $0xc,%esp
c01010a8:	6a 0e                	push   $0xe
c01010aa:	e8 8a 0e 00 00       	call   c0101f39 <pic_enable>
c01010af:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_IDE2);
c01010b2:	83 ec 0c             	sub    $0xc,%esp
c01010b5:	6a 0f                	push   $0xf
c01010b7:	e8 7d 0e 00 00       	call   c0101f39 <pic_enable>
c01010bc:	83 c4 10             	add    $0x10,%esp
}
c01010bf:	90                   	nop
c01010c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01010c3:	5b                   	pop    %ebx
c01010c4:	5f                   	pop    %edi
c01010c5:	5d                   	pop    %ebp
c01010c6:	c3                   	ret    

c01010c7 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c01010c7:	55                   	push   %ebp
c01010c8:	89 e5                	mov    %esp,%ebp
c01010ca:	83 ec 04             	sub    $0x4,%esp
c01010cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c01010d4:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c01010d9:	77 25                	ja     c0101100 <ide_device_valid+0x39>
c01010db:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01010df:	c1 e0 03             	shl    $0x3,%eax
c01010e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010e9:	29 c2                	sub    %eax,%edx
c01010eb:	89 d0                	mov    %edx,%eax
c01010ed:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c01010f2:	0f b6 00             	movzbl (%eax),%eax
c01010f5:	84 c0                	test   %al,%al
c01010f7:	74 07                	je     c0101100 <ide_device_valid+0x39>
c01010f9:	b8 01 00 00 00       	mov    $0x1,%eax
c01010fe:	eb 05                	jmp    c0101105 <ide_device_valid+0x3e>
c0101100:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101105:	c9                   	leave  
c0101106:	c3                   	ret    

c0101107 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101107:	55                   	push   %ebp
c0101108:	89 e5                	mov    %esp,%ebp
c010110a:	83 ec 04             	sub    $0x4,%esp
c010110d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101110:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101114:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101118:	50                   	push   %eax
c0101119:	e8 a9 ff ff ff       	call   c01010c7 <ide_device_valid>
c010111e:	83 c4 04             	add    $0x4,%esp
c0101121:	85 c0                	test   %eax,%eax
c0101123:	74 1b                	je     c0101140 <ide_device_size+0x39>
        return ide_devices[ideno].size;
c0101125:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101129:	c1 e0 03             	shl    $0x3,%eax
c010112c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101133:	29 c2                	sub    %eax,%edx
c0101135:	89 d0                	mov    %edx,%eax
c0101137:	05 08 6f 12 c0       	add    $0xc0126f08,%eax
c010113c:	8b 00                	mov    (%eax),%eax
c010113e:	eb 05                	jmp    c0101145 <ide_device_size+0x3e>
    }
    return 0;
c0101140:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101145:	c9                   	leave  
c0101146:	c3                   	ret    

c0101147 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101147:	55                   	push   %ebp
c0101148:	89 e5                	mov    %esp,%ebp
c010114a:	57                   	push   %edi
c010114b:	53                   	push   %ebx
c010114c:	83 ec 40             	sub    $0x40,%esp
c010114f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101152:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101156:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c010115d:	77 25                	ja     c0101184 <ide_read_secs+0x3d>
c010115f:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101164:	77 1e                	ja     c0101184 <ide_read_secs+0x3d>
c0101166:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010116a:	c1 e0 03             	shl    $0x3,%eax
c010116d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101174:	29 c2                	sub    %eax,%edx
c0101176:	89 d0                	mov    %edx,%eax
c0101178:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c010117d:	0f b6 00             	movzbl (%eax),%eax
c0101180:	84 c0                	test   %al,%al
c0101182:	75 19                	jne    c010119d <ide_read_secs+0x56>
c0101184:	68 94 a2 10 c0       	push   $0xc010a294
c0101189:	68 4f a2 10 c0       	push   $0xc010a24f
c010118e:	68 9f 00 00 00       	push   $0x9f
c0101193:	68 64 a2 10 c0       	push   $0xc010a264
c0101198:	e8 47 f2 ff ff       	call   c01003e4 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c010119d:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011a4:	77 0f                	ja     c01011b5 <ide_read_secs+0x6e>
c01011a6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011a9:	8b 45 14             	mov    0x14(%ebp),%eax
c01011ac:	01 d0                	add    %edx,%eax
c01011ae:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011b3:	76 19                	jbe    c01011ce <ide_read_secs+0x87>
c01011b5:	68 bc a2 10 c0       	push   $0xc010a2bc
c01011ba:	68 4f a2 10 c0       	push   $0xc010a24f
c01011bf:	68 a0 00 00 00       	push   $0xa0
c01011c4:	68 64 a2 10 c0       	push   $0xc010a264
c01011c9:	e8 16 f2 ff ff       	call   c01003e4 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c01011ce:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011d2:	66 d1 e8             	shr    %ax
c01011d5:	0f b7 c0             	movzwl %ax,%eax
c01011d8:	0f b7 04 85 04 a2 10 	movzwl -0x3fef5dfc(,%eax,4),%eax
c01011df:	c0 
c01011e0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01011e4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011e8:	66 d1 e8             	shr    %ax
c01011eb:	0f b7 c0             	movzwl %ax,%eax
c01011ee:	0f b7 04 85 06 a2 10 	movzwl -0x3fef5dfa(,%eax,4),%eax
c01011f5:	c0 
c01011f6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c01011fa:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01011fe:	83 ec 08             	sub    $0x8,%esp
c0101201:	6a 00                	push   $0x0
c0101203:	50                   	push   %eax
c0101204:	e8 60 fb ff ff       	call   c0100d69 <ide_wait_ready>
c0101209:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c010120c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101210:	83 c0 02             	add    $0x2,%eax
c0101213:	0f b7 c0             	movzwl %ax,%eax
c0101216:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010121a:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010121e:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101222:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101226:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101227:	8b 45 14             	mov    0x14(%ebp),%eax
c010122a:	0f b6 c0             	movzbl %al,%eax
c010122d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101231:	83 c2 02             	add    $0x2,%edx
c0101234:	0f b7 d2             	movzwl %dx,%edx
c0101237:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c010123b:	88 45 d8             	mov    %al,-0x28(%ebp)
c010123e:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101242:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101246:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101247:	8b 45 0c             	mov    0xc(%ebp),%eax
c010124a:	0f b6 c0             	movzbl %al,%eax
c010124d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101251:	83 c2 03             	add    $0x3,%edx
c0101254:	0f b7 d2             	movzwl %dx,%edx
c0101257:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c010125b:	88 45 d9             	mov    %al,-0x27(%ebp)
c010125e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101262:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101266:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101267:	8b 45 0c             	mov    0xc(%ebp),%eax
c010126a:	c1 e8 08             	shr    $0x8,%eax
c010126d:	0f b6 c0             	movzbl %al,%eax
c0101270:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101274:	83 c2 04             	add    $0x4,%edx
c0101277:	0f b7 d2             	movzwl %dx,%edx
c010127a:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c010127e:	88 45 da             	mov    %al,-0x26(%ebp)
c0101281:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101285:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0101289:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c010128a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010128d:	c1 e8 10             	shr    $0x10,%eax
c0101290:	0f b6 c0             	movzbl %al,%eax
c0101293:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101297:	83 c2 05             	add    $0x5,%edx
c010129a:	0f b7 d2             	movzwl %dx,%edx
c010129d:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01012a1:	88 45 db             	mov    %al,-0x25(%ebp)
c01012a4:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01012a8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01012ac:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c01012ad:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01012b1:	83 e0 01             	and    $0x1,%eax
c01012b4:	c1 e0 04             	shl    $0x4,%eax
c01012b7:	89 c2                	mov    %eax,%edx
c01012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012bc:	c1 e8 18             	shr    $0x18,%eax
c01012bf:	83 e0 0f             	and    $0xf,%eax
c01012c2:	09 d0                	or     %edx,%eax
c01012c4:	83 c8 e0             	or     $0xffffffe0,%eax
c01012c7:	0f b6 c0             	movzbl %al,%eax
c01012ca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012ce:	83 c2 06             	add    $0x6,%edx
c01012d1:	0f b7 d2             	movzwl %dx,%edx
c01012d4:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c01012d8:	88 45 dc             	mov    %al,-0x24(%ebp)
c01012db:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01012df:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c01012e3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c01012e4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01012e8:	83 c0 07             	add    $0x7,%eax
c01012eb:	0f b7 c0             	movzwl %ax,%eax
c01012ee:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c01012f2:	c6 45 dd 20          	movb   $0x20,-0x23(%ebp)
c01012f6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01012fa:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01012fe:	ee                   	out    %al,(%dx)

    int ret = 0;
c01012ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101306:	eb 56                	jmp    c010135e <ide_read_secs+0x217>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101308:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010130c:	83 ec 08             	sub    $0x8,%esp
c010130f:	6a 01                	push   $0x1
c0101311:	50                   	push   %eax
c0101312:	e8 52 fa ff ff       	call   c0100d69 <ide_wait_ready>
c0101317:	83 c4 10             	add    $0x10,%esp
c010131a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010131d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101321:	75 43                	jne    c0101366 <ide_read_secs+0x21f>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101323:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101327:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010132a:	8b 45 10             	mov    0x10(%ebp),%eax
c010132d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101330:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101337:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010133a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010133d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0101340:	89 cb                	mov    %ecx,%ebx
c0101342:	89 df                	mov    %ebx,%edi
c0101344:	89 c1                	mov    %eax,%ecx
c0101346:	fc                   	cld    
c0101347:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101349:	89 c8                	mov    %ecx,%eax
c010134b:	89 fb                	mov    %edi,%ebx
c010134d:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c0101350:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101353:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101357:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c010135e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101362:	75 a4                	jne    c0101308 <ide_read_secs+0x1c1>
c0101364:	eb 01                	jmp    c0101367 <ide_read_secs+0x220>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101366:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101367:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010136a:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010136d:	5b                   	pop    %ebx
c010136e:	5f                   	pop    %edi
c010136f:	5d                   	pop    %ebp
c0101370:	c3                   	ret    

c0101371 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101371:	55                   	push   %ebp
c0101372:	89 e5                	mov    %esp,%ebp
c0101374:	56                   	push   %esi
c0101375:	53                   	push   %ebx
c0101376:	83 ec 40             	sub    $0x40,%esp
c0101379:	8b 45 08             	mov    0x8(%ebp),%eax
c010137c:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101380:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101387:	77 25                	ja     c01013ae <ide_write_secs+0x3d>
c0101389:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c010138e:	77 1e                	ja     c01013ae <ide_write_secs+0x3d>
c0101390:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101394:	c1 e0 03             	shl    $0x3,%eax
c0101397:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010139e:	29 c2                	sub    %eax,%edx
c01013a0:	89 d0                	mov    %edx,%eax
c01013a2:	05 00 6f 12 c0       	add    $0xc0126f00,%eax
c01013a7:	0f b6 00             	movzbl (%eax),%eax
c01013aa:	84 c0                	test   %al,%al
c01013ac:	75 19                	jne    c01013c7 <ide_write_secs+0x56>
c01013ae:	68 94 a2 10 c0       	push   $0xc010a294
c01013b3:	68 4f a2 10 c0       	push   $0xc010a24f
c01013b8:	68 bc 00 00 00       	push   $0xbc
c01013bd:	68 64 a2 10 c0       	push   $0xc010a264
c01013c2:	e8 1d f0 ff ff       	call   c01003e4 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013c7:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01013ce:	77 0f                	ja     c01013df <ide_write_secs+0x6e>
c01013d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013d3:	8b 45 14             	mov    0x14(%ebp),%eax
c01013d6:	01 d0                	add    %edx,%eax
c01013d8:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01013dd:	76 19                	jbe    c01013f8 <ide_write_secs+0x87>
c01013df:	68 bc a2 10 c0       	push   $0xc010a2bc
c01013e4:	68 4f a2 10 c0       	push   $0xc010a24f
c01013e9:	68 bd 00 00 00       	push   $0xbd
c01013ee:	68 64 a2 10 c0       	push   $0xc010a264
c01013f3:	e8 ec ef ff ff       	call   c01003e4 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c01013f8:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01013fc:	66 d1 e8             	shr    %ax
c01013ff:	0f b7 c0             	movzwl %ax,%eax
c0101402:	0f b7 04 85 04 a2 10 	movzwl -0x3fef5dfc(,%eax,4),%eax
c0101409:	c0 
c010140a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010140e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101412:	66 d1 e8             	shr    %ax
c0101415:	0f b7 c0             	movzwl %ax,%eax
c0101418:	0f b7 04 85 06 a2 10 	movzwl -0x3fef5dfa(,%eax,4),%eax
c010141f:	c0 
c0101420:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101424:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101428:	83 ec 08             	sub    $0x8,%esp
c010142b:	6a 00                	push   $0x0
c010142d:	50                   	push   %eax
c010142e:	e8 36 f9 ff ff       	call   c0100d69 <ide_wait_ready>
c0101433:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101436:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143a:	83 c0 02             	add    $0x2,%eax
c010143d:	0f b7 c0             	movzwl %ax,%eax
c0101440:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101444:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101448:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010144c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101450:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101451:	8b 45 14             	mov    0x14(%ebp),%eax
c0101454:	0f b6 c0             	movzbl %al,%eax
c0101457:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010145b:	83 c2 02             	add    $0x2,%edx
c010145e:	0f b7 d2             	movzwl %dx,%edx
c0101461:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c0101465:	88 45 d8             	mov    %al,-0x28(%ebp)
c0101468:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010146c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101470:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101471:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101474:	0f b6 c0             	movzbl %al,%eax
c0101477:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010147b:	83 c2 03             	add    $0x3,%edx
c010147e:	0f b7 d2             	movzwl %dx,%edx
c0101481:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101485:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101488:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010148c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101490:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101491:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101494:	c1 e8 08             	shr    $0x8,%eax
c0101497:	0f b6 c0             	movzbl %al,%eax
c010149a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010149e:	83 c2 04             	add    $0x4,%edx
c01014a1:	0f b7 d2             	movzwl %dx,%edx
c01014a4:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c01014a8:	88 45 da             	mov    %al,-0x26(%ebp)
c01014ab:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c01014af:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c01014b3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01014b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014b7:	c1 e8 10             	shr    $0x10,%eax
c01014ba:	0f b6 c0             	movzbl %al,%eax
c01014bd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014c1:	83 c2 05             	add    $0x5,%edx
c01014c4:	0f b7 d2             	movzwl %dx,%edx
c01014c7:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01014cb:	88 45 db             	mov    %al,-0x25(%ebp)
c01014ce:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01014d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01014d6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c01014d7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01014db:	83 e0 01             	and    $0x1,%eax
c01014de:	c1 e0 04             	shl    $0x4,%eax
c01014e1:	89 c2                	mov    %eax,%edx
c01014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014e6:	c1 e8 18             	shr    $0x18,%eax
c01014e9:	83 e0 0f             	and    $0xf,%eax
c01014ec:	09 d0                	or     %edx,%eax
c01014ee:	83 c8 e0             	or     $0xffffffe0,%eax
c01014f1:	0f b6 c0             	movzbl %al,%eax
c01014f4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014f8:	83 c2 06             	add    $0x6,%edx
c01014fb:	0f b7 d2             	movzwl %dx,%edx
c01014fe:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c0101502:	88 45 dc             	mov    %al,-0x24(%ebp)
c0101505:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0101509:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c010150d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c010150e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101512:	83 c0 07             	add    $0x7,%eax
c0101515:	0f b7 c0             	movzwl %ax,%eax
c0101518:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c010151c:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
c0101520:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101524:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101528:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101530:	eb 56                	jmp    c0101588 <ide_write_secs+0x217>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101532:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101536:	83 ec 08             	sub    $0x8,%esp
c0101539:	6a 01                	push   $0x1
c010153b:	50                   	push   %eax
c010153c:	e8 28 f8 ff ff       	call   c0100d69 <ide_wait_ready>
c0101541:	83 c4 10             	add    $0x10,%esp
c0101544:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010154b:	75 43                	jne    c0101590 <ide_write_secs+0x21f>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c010154d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101551:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0101554:	8b 45 10             	mov    0x10(%ebp),%eax
c0101557:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010155a:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101561:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101564:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101567:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010156a:	89 cb                	mov    %ecx,%ebx
c010156c:	89 de                	mov    %ebx,%esi
c010156e:	89 c1                	mov    %eax,%ecx
c0101570:	fc                   	cld    
c0101571:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101573:	89 c8                	mov    %ecx,%eax
c0101575:	89 f3                	mov    %esi,%ebx
c0101577:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c010157a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010157d:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101581:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101588:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010158c:	75 a4                	jne    c0101532 <ide_write_secs+0x1c1>
c010158e:	eb 01                	jmp    c0101591 <ide_write_secs+0x220>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101590:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101591:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101594:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101597:	5b                   	pop    %ebx
c0101598:	5e                   	pop    %esi
c0101599:	5d                   	pop    %ebp
c010159a:	c3                   	ret    

c010159b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c010159b:	55                   	push   %ebp
c010159c:	89 e5                	mov    %esp,%ebp
c010159e:	83 ec 18             	sub    $0x18,%esp
c01015a1:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c01015a7:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01015af:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01015b3:	ee                   	out    %al,(%dx)
c01015b4:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c01015ba:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c01015be:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c01015c2:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01015c6:	ee                   	out    %al,(%dx)
c01015c7:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c01015cd:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c01015d1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01015d5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01015d9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c01015da:	c7 05 14 9b 12 c0 00 	movl   $0x0,0xc0129b14
c01015e1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c01015e4:	83 ec 0c             	sub    $0xc,%esp
c01015e7:	68 f6 a2 10 c0       	push   $0xc010a2f6
c01015ec:	e8 8d ec ff ff       	call   c010027e <cprintf>
c01015f1:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c01015f4:	83 ec 0c             	sub    $0xc,%esp
c01015f7:	6a 00                	push   $0x0
c01015f9:	e8 3b 09 00 00       	call   c0101f39 <pic_enable>
c01015fe:	83 c4 10             	add    $0x10,%esp
}
c0101601:	90                   	nop
c0101602:	c9                   	leave  
c0101603:	c3                   	ret    

c0101604 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0101604:	55                   	push   %ebp
c0101605:	89 e5                	mov    %esp,%ebp
c0101607:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010160a:	9c                   	pushf  
c010160b:	58                   	pop    %eax
c010160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0101612:	25 00 02 00 00       	and    $0x200,%eax
c0101617:	85 c0                	test   %eax,%eax
c0101619:	74 0c                	je     c0101627 <__intr_save+0x23>
        intr_disable();
c010161b:	e8 8a 0a 00 00       	call   c01020aa <intr_disable>
        return 1;
c0101620:	b8 01 00 00 00       	mov    $0x1,%eax
c0101625:	eb 05                	jmp    c010162c <__intr_save+0x28>
    }
    return 0;
c0101627:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010162c:	c9                   	leave  
c010162d:	c3                   	ret    

c010162e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010162e:	55                   	push   %ebp
c010162f:	89 e5                	mov    %esp,%ebp
c0101631:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0101634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101638:	74 05                	je     c010163f <__intr_restore+0x11>
        intr_enable();
c010163a:	e8 64 0a 00 00       	call   c01020a3 <intr_enable>
    }
}
c010163f:	90                   	nop
c0101640:	c9                   	leave  
c0101641:	c3                   	ret    

c0101642 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0101642:	55                   	push   %ebp
c0101643:	89 e5                	mov    %esp,%ebp
c0101645:	83 ec 10             	sub    $0x10,%esp
c0101648:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010164e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0101652:	89 c2                	mov    %eax,%edx
c0101654:	ec                   	in     (%dx),%al
c0101655:	88 45 f4             	mov    %al,-0xc(%ebp)
c0101658:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c010165e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101662:	89 c2                	mov    %eax,%edx
c0101664:	ec                   	in     (%dx),%al
c0101665:	88 45 f5             	mov    %al,-0xb(%ebp)
c0101668:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c010166e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101672:	89 c2                	mov    %eax,%edx
c0101674:	ec                   	in     (%dx),%al
c0101675:	88 45 f6             	mov    %al,-0xa(%ebp)
c0101678:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c010167e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101682:	89 c2                	mov    %eax,%edx
c0101684:	ec                   	in     (%dx),%al
c0101685:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0101688:	90                   	nop
c0101689:	c9                   	leave  
c010168a:	c3                   	ret    

c010168b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c010168b:	55                   	push   %ebp
c010168c:	89 e5                	mov    %esp,%ebp
c010168e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0101691:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0101698:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010169b:	0f b7 00             	movzwl (%eax),%eax
c010169e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c01016a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016a5:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c01016aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ad:	0f b7 00             	movzwl (%eax),%eax
c01016b0:	66 3d 5a a5          	cmp    $0xa55a,%ax
c01016b4:	74 12                	je     c01016c8 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c01016b6:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c01016bd:	66 c7 05 e6 6f 12 c0 	movw   $0x3b4,0xc0126fe6
c01016c4:	b4 03 
c01016c6:	eb 13                	jmp    c01016db <cga_init+0x50>
    } else {
        *cp = was;
c01016c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016cb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016cf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c01016d2:	66 c7 05 e6 6f 12 c0 	movw   $0x3d4,0xc0126fe6
c01016d9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c01016db:	0f b7 05 e6 6f 12 c0 	movzwl 0xc0126fe6,%eax
c01016e2:	0f b7 c0             	movzwl %ax,%eax
c01016e5:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c01016e9:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016ed:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c01016f1:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c01016f5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c01016f6:	0f b7 05 e6 6f 12 c0 	movzwl 0xc0126fe6,%eax
c01016fd:	83 c0 01             	add    $0x1,%eax
c0101700:	0f b7 c0             	movzwl %ax,%eax
c0101703:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101707:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010170b:	89 c2                	mov    %eax,%edx
c010170d:	ec                   	in     (%dx),%al
c010170e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101711:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101715:	0f b6 c0             	movzbl %al,%eax
c0101718:	c1 e0 08             	shl    $0x8,%eax
c010171b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010171e:	0f b7 05 e6 6f 12 c0 	movzwl 0xc0126fe6,%eax
c0101725:	0f b7 c0             	movzwl %ax,%eax
c0101728:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c010172c:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101730:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101734:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101738:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101739:	0f b7 05 e6 6f 12 c0 	movzwl 0xc0126fe6,%eax
c0101740:	83 c0 01             	add    $0x1,%eax
c0101743:	0f b7 c0             	movzwl %ax,%eax
c0101746:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010174a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010174e:	89 c2                	mov    %eax,%edx
c0101750:	ec                   	in     (%dx),%al
c0101751:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101754:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101758:	0f b6 c0             	movzbl %al,%eax
c010175b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c010175e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101761:	a3 e0 6f 12 c0       	mov    %eax,0xc0126fe0
    crt_pos = pos;
c0101766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101769:	66 a3 e4 6f 12 c0    	mov    %ax,0xc0126fe4
}
c010176f:	90                   	nop
c0101770:	c9                   	leave  
c0101771:	c3                   	ret    

c0101772 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101772:	55                   	push   %ebp
c0101773:	89 e5                	mov    %esp,%ebp
c0101775:	83 ec 28             	sub    $0x28,%esp
c0101778:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c010177e:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101782:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101786:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010178a:	ee                   	out    %al,(%dx)
c010178b:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0101791:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0101795:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101799:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c010179d:	ee                   	out    %al,(%dx)
c010179e:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c01017a4:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c01017a8:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017ac:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017b0:	ee                   	out    %al,(%dx)
c01017b1:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c01017b7:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c01017bb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017bf:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017c3:	ee                   	out    %al,(%dx)
c01017c4:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c01017ca:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c01017ce:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017d2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017d6:	ee                   	out    %al,(%dx)
c01017d7:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c01017dd:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c01017e1:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017e5:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017e9:	ee                   	out    %al,(%dx)
c01017ea:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01017f0:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c01017f4:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01017f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fc:	ee                   	out    %al,(%dx)
c01017fd:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101803:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0101807:	89 c2                	mov    %eax,%edx
c0101809:	ec                   	in     (%dx),%al
c010180a:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c010180d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101811:	3c ff                	cmp    $0xff,%al
c0101813:	0f 95 c0             	setne  %al
c0101816:	0f b6 c0             	movzbl %al,%eax
c0101819:	a3 e8 6f 12 c0       	mov    %eax,0xc0126fe8
c010181e:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101824:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101828:	89 c2                	mov    %eax,%edx
c010182a:	ec                   	in     (%dx),%al
c010182b:	88 45 e2             	mov    %al,-0x1e(%ebp)
c010182e:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0101834:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0101838:	89 c2                	mov    %eax,%edx
c010183a:	ec                   	in     (%dx),%al
c010183b:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010183e:	a1 e8 6f 12 c0       	mov    0xc0126fe8,%eax
c0101843:	85 c0                	test   %eax,%eax
c0101845:	74 0d                	je     c0101854 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101847:	83 ec 0c             	sub    $0xc,%esp
c010184a:	6a 04                	push   $0x4
c010184c:	e8 e8 06 00 00       	call   c0101f39 <pic_enable>
c0101851:	83 c4 10             	add    $0x10,%esp
    }
}
c0101854:	90                   	nop
c0101855:	c9                   	leave  
c0101856:	c3                   	ret    

c0101857 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101857:	55                   	push   %ebp
c0101858:	89 e5                	mov    %esp,%ebp
c010185a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010185d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101864:	eb 09                	jmp    c010186f <lpt_putc_sub+0x18>
        delay();
c0101866:	e8 d7 fd ff ff       	call   c0101642 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010186b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010186f:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0101875:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101879:	89 c2                	mov    %eax,%edx
c010187b:	ec                   	in     (%dx),%al
c010187c:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c010187f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101883:	84 c0                	test   %al,%al
c0101885:	78 09                	js     c0101890 <lpt_putc_sub+0x39>
c0101887:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010188e:	7e d6                	jle    c0101866 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101890:	8b 45 08             	mov    0x8(%ebp),%eax
c0101893:	0f b6 c0             	movzbl %al,%eax
c0101896:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c010189c:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189f:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c01018a3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c01018a7:	ee                   	out    %al,(%dx)
c01018a8:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01018ae:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01018b2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018b6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018ba:	ee                   	out    %al,(%dx)
c01018bb:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c01018c1:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c01018c5:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c01018c9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018cd:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01018ce:	90                   	nop
c01018cf:	c9                   	leave  
c01018d0:	c3                   	ret    

c01018d1 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01018d1:	55                   	push   %ebp
c01018d2:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01018d4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01018d8:	74 0d                	je     c01018e7 <lpt_putc+0x16>
        lpt_putc_sub(c);
c01018da:	ff 75 08             	pushl  0x8(%ebp)
c01018dd:	e8 75 ff ff ff       	call   c0101857 <lpt_putc_sub>
c01018e2:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01018e5:	eb 1e                	jmp    c0101905 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c01018e7:	6a 08                	push   $0x8
c01018e9:	e8 69 ff ff ff       	call   c0101857 <lpt_putc_sub>
c01018ee:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01018f1:	6a 20                	push   $0x20
c01018f3:	e8 5f ff ff ff       	call   c0101857 <lpt_putc_sub>
c01018f8:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01018fb:	6a 08                	push   $0x8
c01018fd:	e8 55 ff ff ff       	call   c0101857 <lpt_putc_sub>
c0101902:	83 c4 04             	add    $0x4,%esp
    }
}
c0101905:	90                   	nop
c0101906:	c9                   	leave  
c0101907:	c3                   	ret    

c0101908 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101908:	55                   	push   %ebp
c0101909:	89 e5                	mov    %esp,%ebp
c010190b:	53                   	push   %ebx
c010190c:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010190f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101912:	b0 00                	mov    $0x0,%al
c0101914:	85 c0                	test   %eax,%eax
c0101916:	75 07                	jne    c010191f <cga_putc+0x17>
        c |= 0x0700;
c0101918:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010191f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101922:	0f b6 c0             	movzbl %al,%eax
c0101925:	83 f8 0a             	cmp    $0xa,%eax
c0101928:	74 4e                	je     c0101978 <cga_putc+0x70>
c010192a:	83 f8 0d             	cmp    $0xd,%eax
c010192d:	74 59                	je     c0101988 <cga_putc+0x80>
c010192f:	83 f8 08             	cmp    $0x8,%eax
c0101932:	0f 85 8a 00 00 00    	jne    c01019c2 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c0101938:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c010193f:	66 85 c0             	test   %ax,%ax
c0101942:	0f 84 a0 00 00 00    	je     c01019e8 <cga_putc+0xe0>
            crt_pos --;
c0101948:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c010194f:	83 e8 01             	sub    $0x1,%eax
c0101952:	66 a3 e4 6f 12 c0    	mov    %ax,0xc0126fe4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101958:	a1 e0 6f 12 c0       	mov    0xc0126fe0,%eax
c010195d:	0f b7 15 e4 6f 12 c0 	movzwl 0xc0126fe4,%edx
c0101964:	0f b7 d2             	movzwl %dx,%edx
c0101967:	01 d2                	add    %edx,%edx
c0101969:	01 d0                	add    %edx,%eax
c010196b:	8b 55 08             	mov    0x8(%ebp),%edx
c010196e:	b2 00                	mov    $0x0,%dl
c0101970:	83 ca 20             	or     $0x20,%edx
c0101973:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101976:	eb 70                	jmp    c01019e8 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c0101978:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c010197f:	83 c0 50             	add    $0x50,%eax
c0101982:	66 a3 e4 6f 12 c0    	mov    %ax,0xc0126fe4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101988:	0f b7 1d e4 6f 12 c0 	movzwl 0xc0126fe4,%ebx
c010198f:	0f b7 0d e4 6f 12 c0 	movzwl 0xc0126fe4,%ecx
c0101996:	0f b7 c1             	movzwl %cx,%eax
c0101999:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010199f:	c1 e8 10             	shr    $0x10,%eax
c01019a2:	89 c2                	mov    %eax,%edx
c01019a4:	66 c1 ea 06          	shr    $0x6,%dx
c01019a8:	89 d0                	mov    %edx,%eax
c01019aa:	c1 e0 02             	shl    $0x2,%eax
c01019ad:	01 d0                	add    %edx,%eax
c01019af:	c1 e0 04             	shl    $0x4,%eax
c01019b2:	29 c1                	sub    %eax,%ecx
c01019b4:	89 ca                	mov    %ecx,%edx
c01019b6:	89 d8                	mov    %ebx,%eax
c01019b8:	29 d0                	sub    %edx,%eax
c01019ba:	66 a3 e4 6f 12 c0    	mov    %ax,0xc0126fe4
        break;
c01019c0:	eb 27                	jmp    c01019e9 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01019c2:	8b 0d e0 6f 12 c0    	mov    0xc0126fe0,%ecx
c01019c8:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c01019cf:	8d 50 01             	lea    0x1(%eax),%edx
c01019d2:	66 89 15 e4 6f 12 c0 	mov    %dx,0xc0126fe4
c01019d9:	0f b7 c0             	movzwl %ax,%eax
c01019dc:	01 c0                	add    %eax,%eax
c01019de:	01 c8                	add    %ecx,%eax
c01019e0:	8b 55 08             	mov    0x8(%ebp),%edx
c01019e3:	66 89 10             	mov    %dx,(%eax)
        break;
c01019e6:	eb 01                	jmp    c01019e9 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c01019e8:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01019e9:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c01019f0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01019f4:	76 59                	jbe    c0101a4f <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01019f6:	a1 e0 6f 12 c0       	mov    0xc0126fe0,%eax
c01019fb:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a01:	a1 e0 6f 12 c0       	mov    0xc0126fe0,%eax
c0101a06:	83 ec 04             	sub    $0x4,%esp
c0101a09:	68 00 0f 00 00       	push   $0xf00
c0101a0e:	52                   	push   %edx
c0101a0f:	50                   	push   %eax
c0101a10:	e8 91 7c 00 00       	call   c01096a6 <memmove>
c0101a15:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a18:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101a1f:	eb 15                	jmp    c0101a36 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c0101a21:	a1 e0 6f 12 c0       	mov    0xc0126fe0,%eax
c0101a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101a29:	01 d2                	add    %edx,%edx
c0101a2b:	01 d0                	add    %edx,%eax
c0101a2d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101a36:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101a3d:	7e e2                	jle    c0101a21 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101a3f:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c0101a46:	83 e8 50             	sub    $0x50,%eax
c0101a49:	66 a3 e4 6f 12 c0    	mov    %ax,0xc0126fe4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101a4f:	0f b7 05 e6 6f 12 c0 	movzwl 0xc0126fe6,%eax
c0101a56:	0f b7 c0             	movzwl %ax,%eax
c0101a59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101a5d:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101a61:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101a65:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101a69:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101a6a:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c0101a71:	66 c1 e8 08          	shr    $0x8,%ax
c0101a75:	0f b6 c0             	movzbl %al,%eax
c0101a78:	0f b7 15 e6 6f 12 c0 	movzwl 0xc0126fe6,%edx
c0101a7f:	83 c2 01             	add    $0x1,%edx
c0101a82:	0f b7 d2             	movzwl %dx,%edx
c0101a85:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101a89:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101a8c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101a90:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101a94:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101a95:	0f b7 05 e6 6f 12 c0 	movzwl 0xc0126fe6,%eax
c0101a9c:	0f b7 c0             	movzwl %ax,%eax
c0101a9f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101aa3:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101aa7:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101aab:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101aaf:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101ab0:	0f b7 05 e4 6f 12 c0 	movzwl 0xc0126fe4,%eax
c0101ab7:	0f b6 c0             	movzbl %al,%eax
c0101aba:	0f b7 15 e6 6f 12 c0 	movzwl 0xc0126fe6,%edx
c0101ac1:	83 c2 01             	add    $0x1,%edx
c0101ac4:	0f b7 d2             	movzwl %dx,%edx
c0101ac7:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101acb:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101ace:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101ad2:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101ad6:	ee                   	out    %al,(%dx)
}
c0101ad7:	90                   	nop
c0101ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101adb:	c9                   	leave  
c0101adc:	c3                   	ret    

c0101add <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101add:	55                   	push   %ebp
c0101ade:	89 e5                	mov    %esp,%ebp
c0101ae0:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101aea:	eb 09                	jmp    c0101af5 <serial_putc_sub+0x18>
        delay();
c0101aec:	e8 51 fb ff ff       	call   c0101642 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101af1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101af5:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101afb:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101aff:	89 c2                	mov    %eax,%edx
c0101b01:	ec                   	in     (%dx),%al
c0101b02:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101b05:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101b09:	0f b6 c0             	movzbl %al,%eax
c0101b0c:	83 e0 20             	and    $0x20,%eax
c0101b0f:	85 c0                	test   %eax,%eax
c0101b11:	75 09                	jne    c0101b1c <serial_putc_sub+0x3f>
c0101b13:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101b1a:	7e d0                	jle    c0101aec <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1f:	0f b6 c0             	movzbl %al,%eax
c0101b22:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c0101b28:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b2b:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c0101b2f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101b33:	ee                   	out    %al,(%dx)
}
c0101b34:	90                   	nop
c0101b35:	c9                   	leave  
c0101b36:	c3                   	ret    

c0101b37 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101b37:	55                   	push   %ebp
c0101b38:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101b3a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101b3e:	74 0d                	je     c0101b4d <serial_putc+0x16>
        serial_putc_sub(c);
c0101b40:	ff 75 08             	pushl  0x8(%ebp)
c0101b43:	e8 95 ff ff ff       	call   c0101add <serial_putc_sub>
c0101b48:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101b4b:	eb 1e                	jmp    c0101b6b <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101b4d:	6a 08                	push   $0x8
c0101b4f:	e8 89 ff ff ff       	call   c0101add <serial_putc_sub>
c0101b54:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101b57:	6a 20                	push   $0x20
c0101b59:	e8 7f ff ff ff       	call   c0101add <serial_putc_sub>
c0101b5e:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101b61:	6a 08                	push   $0x8
c0101b63:	e8 75 ff ff ff       	call   c0101add <serial_putc_sub>
c0101b68:	83 c4 04             	add    $0x4,%esp
    }
}
c0101b6b:	90                   	nop
c0101b6c:	c9                   	leave  
c0101b6d:	c3                   	ret    

c0101b6e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101b6e:	55                   	push   %ebp
c0101b6f:	89 e5                	mov    %esp,%ebp
c0101b71:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101b74:	eb 33                	jmp    c0101ba9 <cons_intr+0x3b>
        if (c != 0) {
c0101b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101b7a:	74 2d                	je     c0101ba9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101b7c:	a1 04 72 12 c0       	mov    0xc0127204,%eax
c0101b81:	8d 50 01             	lea    0x1(%eax),%edx
c0101b84:	89 15 04 72 12 c0    	mov    %edx,0xc0127204
c0101b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b8d:	88 90 00 70 12 c0    	mov    %dl,-0x3fed9000(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101b93:	a1 04 72 12 c0       	mov    0xc0127204,%eax
c0101b98:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101b9d:	75 0a                	jne    c0101ba9 <cons_intr+0x3b>
                cons.wpos = 0;
c0101b9f:	c7 05 04 72 12 c0 00 	movl   $0x0,0xc0127204
c0101ba6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bac:	ff d0                	call   *%eax
c0101bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101bb1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101bb5:	75 bf                	jne    c0101b76 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101bb7:	90                   	nop
c0101bb8:	c9                   	leave  
c0101bb9:	c3                   	ret    

c0101bba <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101bba:	55                   	push   %ebp
c0101bbb:	89 e5                	mov    %esp,%ebp
c0101bbd:	83 ec 10             	sub    $0x10,%esp
c0101bc0:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101bc6:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101bca:	89 c2                	mov    %eax,%edx
c0101bcc:	ec                   	in     (%dx),%al
c0101bcd:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101bd0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101bd4:	0f b6 c0             	movzbl %al,%eax
c0101bd7:	83 e0 01             	and    $0x1,%eax
c0101bda:	85 c0                	test   %eax,%eax
c0101bdc:	75 07                	jne    c0101be5 <serial_proc_data+0x2b>
        return -1;
c0101bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101be3:	eb 2a                	jmp    c0101c0f <serial_proc_data+0x55>
c0101be5:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101beb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101bef:	89 c2                	mov    %eax,%edx
c0101bf1:	ec                   	in     (%dx),%al
c0101bf2:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c0101bf5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101bf9:	0f b6 c0             	movzbl %al,%eax
c0101bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101bff:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101c03:	75 07                	jne    c0101c0c <serial_proc_data+0x52>
        c = '\b';
c0101c05:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101c0f:	c9                   	leave  
c0101c10:	c3                   	ret    

c0101c11 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101c11:	55                   	push   %ebp
c0101c12:	89 e5                	mov    %esp,%ebp
c0101c14:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c0101c17:	a1 e8 6f 12 c0       	mov    0xc0126fe8,%eax
c0101c1c:	85 c0                	test   %eax,%eax
c0101c1e:	74 10                	je     c0101c30 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c0101c20:	83 ec 0c             	sub    $0xc,%esp
c0101c23:	68 ba 1b 10 c0       	push   $0xc0101bba
c0101c28:	e8 41 ff ff ff       	call   c0101b6e <cons_intr>
c0101c2d:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c30:	90                   	nop
c0101c31:	c9                   	leave  
c0101c32:	c3                   	ret    

c0101c33 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101c33:	55                   	push   %ebp
c0101c34:	89 e5                	mov    %esp,%ebp
c0101c36:	83 ec 18             	sub    $0x18,%esp
c0101c39:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c3f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101c43:	89 c2                	mov    %eax,%edx
c0101c45:	ec                   	in     (%dx),%al
c0101c46:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101c49:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101c4d:	0f b6 c0             	movzbl %al,%eax
c0101c50:	83 e0 01             	and    $0x1,%eax
c0101c53:	85 c0                	test   %eax,%eax
c0101c55:	75 0a                	jne    c0101c61 <kbd_proc_data+0x2e>
        return -1;
c0101c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c5c:	e9 5d 01 00 00       	jmp    c0101dbe <kbd_proc_data+0x18b>
c0101c61:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c67:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c6b:	89 c2                	mov    %eax,%edx
c0101c6d:	ec                   	in     (%dx),%al
c0101c6e:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101c71:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101c75:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101c78:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101c7c:	75 17                	jne    c0101c95 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101c7e:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101c83:	83 c8 40             	or     $0x40,%eax
c0101c86:	a3 08 72 12 c0       	mov    %eax,0xc0127208
        return 0;
c0101c8b:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c90:	e9 29 01 00 00       	jmp    c0101dbe <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101c95:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101c99:	84 c0                	test   %al,%al
c0101c9b:	79 47                	jns    c0101ce4 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101c9d:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101ca2:	83 e0 40             	and    $0x40,%eax
c0101ca5:	85 c0                	test   %eax,%eax
c0101ca7:	75 09                	jne    c0101cb2 <kbd_proc_data+0x7f>
c0101ca9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cad:	83 e0 7f             	and    $0x7f,%eax
c0101cb0:	eb 04                	jmp    c0101cb6 <kbd_proc_data+0x83>
c0101cb2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cb6:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101cb9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cbd:	0f b6 80 60 60 12 c0 	movzbl -0x3fed9fa0(%eax),%eax
c0101cc4:	83 c8 40             	or     $0x40,%eax
c0101cc7:	0f b6 c0             	movzbl %al,%eax
c0101cca:	f7 d0                	not    %eax
c0101ccc:	89 c2                	mov    %eax,%edx
c0101cce:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101cd3:	21 d0                	and    %edx,%eax
c0101cd5:	a3 08 72 12 c0       	mov    %eax,0xc0127208
        return 0;
c0101cda:	b8 00 00 00 00       	mov    $0x0,%eax
c0101cdf:	e9 da 00 00 00       	jmp    c0101dbe <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c0101ce4:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101ce9:	83 e0 40             	and    $0x40,%eax
c0101cec:	85 c0                	test   %eax,%eax
c0101cee:	74 11                	je     c0101d01 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101cf0:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101cf4:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101cf9:	83 e0 bf             	and    $0xffffffbf,%eax
c0101cfc:	a3 08 72 12 c0       	mov    %eax,0xc0127208
    }

    shift |= shiftcode[data];
c0101d01:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d05:	0f b6 80 60 60 12 c0 	movzbl -0x3fed9fa0(%eax),%eax
c0101d0c:	0f b6 d0             	movzbl %al,%edx
c0101d0f:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101d14:	09 d0                	or     %edx,%eax
c0101d16:	a3 08 72 12 c0       	mov    %eax,0xc0127208
    shift ^= togglecode[data];
c0101d1b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d1f:	0f b6 80 60 61 12 c0 	movzbl -0x3fed9ea0(%eax),%eax
c0101d26:	0f b6 d0             	movzbl %al,%edx
c0101d29:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101d2e:	31 d0                	xor    %edx,%eax
c0101d30:	a3 08 72 12 c0       	mov    %eax,0xc0127208

    c = charcode[shift & (CTL | SHIFT)][data];
c0101d35:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101d3a:	83 e0 03             	and    $0x3,%eax
c0101d3d:	8b 14 85 60 65 12 c0 	mov    -0x3fed9aa0(,%eax,4),%edx
c0101d44:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d48:	01 d0                	add    %edx,%eax
c0101d4a:	0f b6 00             	movzbl (%eax),%eax
c0101d4d:	0f b6 c0             	movzbl %al,%eax
c0101d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101d53:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101d58:	83 e0 08             	and    $0x8,%eax
c0101d5b:	85 c0                	test   %eax,%eax
c0101d5d:	74 22                	je     c0101d81 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101d5f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101d63:	7e 0c                	jle    c0101d71 <kbd_proc_data+0x13e>
c0101d65:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101d69:	7f 06                	jg     c0101d71 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101d6b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101d6f:	eb 10                	jmp    c0101d81 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101d71:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101d75:	7e 0a                	jle    c0101d81 <kbd_proc_data+0x14e>
c0101d77:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101d7b:	7f 04                	jg     c0101d81 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101d7d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101d81:	a1 08 72 12 c0       	mov    0xc0127208,%eax
c0101d86:	f7 d0                	not    %eax
c0101d88:	83 e0 06             	and    $0x6,%eax
c0101d8b:	85 c0                	test   %eax,%eax
c0101d8d:	75 2c                	jne    c0101dbb <kbd_proc_data+0x188>
c0101d8f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101d96:	75 23                	jne    c0101dbb <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101d98:	83 ec 0c             	sub    $0xc,%esp
c0101d9b:	68 11 a3 10 c0       	push   $0xc010a311
c0101da0:	e8 d9 e4 ff ff       	call   c010027e <cprintf>
c0101da5:	83 c4 10             	add    $0x10,%esp
c0101da8:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101dae:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101db2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101db6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101dba:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dbe:	c9                   	leave  
c0101dbf:	c3                   	ret    

c0101dc0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101dc0:	55                   	push   %ebp
c0101dc1:	89 e5                	mov    %esp,%ebp
c0101dc3:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101dc6:	83 ec 0c             	sub    $0xc,%esp
c0101dc9:	68 33 1c 10 c0       	push   $0xc0101c33
c0101dce:	e8 9b fd ff ff       	call   c0101b6e <cons_intr>
c0101dd3:	83 c4 10             	add    $0x10,%esp
}
c0101dd6:	90                   	nop
c0101dd7:	c9                   	leave  
c0101dd8:	c3                   	ret    

c0101dd9 <kbd_init>:

static void
kbd_init(void) {
c0101dd9:	55                   	push   %ebp
c0101dda:	89 e5                	mov    %esp,%ebp
c0101ddc:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101ddf:	e8 dc ff ff ff       	call   c0101dc0 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101de4:	83 ec 0c             	sub    $0xc,%esp
c0101de7:	6a 01                	push   $0x1
c0101de9:	e8 4b 01 00 00       	call   c0101f39 <pic_enable>
c0101dee:	83 c4 10             	add    $0x10,%esp
}
c0101df1:	90                   	nop
c0101df2:	c9                   	leave  
c0101df3:	c3                   	ret    

c0101df4 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101df4:	55                   	push   %ebp
c0101df5:	89 e5                	mov    %esp,%ebp
c0101df7:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c0101dfa:	e8 8c f8 ff ff       	call   c010168b <cga_init>
    serial_init();
c0101dff:	e8 6e f9 ff ff       	call   c0101772 <serial_init>
    kbd_init();
c0101e04:	e8 d0 ff ff ff       	call   c0101dd9 <kbd_init>
    if (!serial_exists) {
c0101e09:	a1 e8 6f 12 c0       	mov    0xc0126fe8,%eax
c0101e0e:	85 c0                	test   %eax,%eax
c0101e10:	75 10                	jne    c0101e22 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c0101e12:	83 ec 0c             	sub    $0xc,%esp
c0101e15:	68 1d a3 10 c0       	push   $0xc010a31d
c0101e1a:	e8 5f e4 ff ff       	call   c010027e <cprintf>
c0101e1f:	83 c4 10             	add    $0x10,%esp
    }
}
c0101e22:	90                   	nop
c0101e23:	c9                   	leave  
c0101e24:	c3                   	ret    

c0101e25 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101e25:	55                   	push   %ebp
c0101e26:	89 e5                	mov    %esp,%ebp
c0101e28:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e2b:	e8 d4 f7 ff ff       	call   c0101604 <__intr_save>
c0101e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101e33:	83 ec 0c             	sub    $0xc,%esp
c0101e36:	ff 75 08             	pushl  0x8(%ebp)
c0101e39:	e8 93 fa ff ff       	call   c01018d1 <lpt_putc>
c0101e3e:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c0101e41:	83 ec 0c             	sub    $0xc,%esp
c0101e44:	ff 75 08             	pushl  0x8(%ebp)
c0101e47:	e8 bc fa ff ff       	call   c0101908 <cga_putc>
c0101e4c:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101e4f:	83 ec 0c             	sub    $0xc,%esp
c0101e52:	ff 75 08             	pushl  0x8(%ebp)
c0101e55:	e8 dd fc ff ff       	call   c0101b37 <serial_putc>
c0101e5a:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101e5d:	83 ec 0c             	sub    $0xc,%esp
c0101e60:	ff 75 f4             	pushl  -0xc(%ebp)
c0101e63:	e8 c6 f7 ff ff       	call   c010162e <__intr_restore>
c0101e68:	83 c4 10             	add    $0x10,%esp
}
c0101e6b:	90                   	nop
c0101e6c:	c9                   	leave  
c0101e6d:	c3                   	ret    

c0101e6e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101e6e:	55                   	push   %ebp
c0101e6f:	89 e5                	mov    %esp,%ebp
c0101e71:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e7b:	e8 84 f7 ff ff       	call   c0101604 <__intr_save>
c0101e80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101e83:	e8 89 fd ff ff       	call   c0101c11 <serial_intr>
        kbd_intr();
c0101e88:	e8 33 ff ff ff       	call   c0101dc0 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101e8d:	8b 15 00 72 12 c0    	mov    0xc0127200,%edx
c0101e93:	a1 04 72 12 c0       	mov    0xc0127204,%eax
c0101e98:	39 c2                	cmp    %eax,%edx
c0101e9a:	74 31                	je     c0101ecd <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101e9c:	a1 00 72 12 c0       	mov    0xc0127200,%eax
c0101ea1:	8d 50 01             	lea    0x1(%eax),%edx
c0101ea4:	89 15 00 72 12 c0    	mov    %edx,0xc0127200
c0101eaa:	0f b6 80 00 70 12 c0 	movzbl -0x3fed9000(%eax),%eax
c0101eb1:	0f b6 c0             	movzbl %al,%eax
c0101eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101eb7:	a1 00 72 12 c0       	mov    0xc0127200,%eax
c0101ebc:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101ec1:	75 0a                	jne    c0101ecd <cons_getc+0x5f>
                cons.rpos = 0;
c0101ec3:	c7 05 00 72 12 c0 00 	movl   $0x0,0xc0127200
c0101eca:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101ecd:	83 ec 0c             	sub    $0xc,%esp
c0101ed0:	ff 75 f0             	pushl  -0x10(%ebp)
c0101ed3:	e8 56 f7 ff ff       	call   c010162e <__intr_restore>
c0101ed8:	83 c4 10             	add    $0x10,%esp
    return c;
c0101edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ede:	c9                   	leave  
c0101edf:	c3                   	ret    

c0101ee0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101ee0:	55                   	push   %ebp
c0101ee1:	89 e5                	mov    %esp,%ebp
c0101ee3:	83 ec 14             	sub    $0x14,%esp
c0101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101eed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101ef1:	66 a3 70 65 12 c0    	mov    %ax,0xc0126570
    if (did_init) {
c0101ef7:	a1 0c 72 12 c0       	mov    0xc012720c,%eax
c0101efc:	85 c0                	test   %eax,%eax
c0101efe:	74 36                	je     c0101f36 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f00:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f04:	0f b6 c0             	movzbl %al,%eax
c0101f07:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f0d:	88 45 fa             	mov    %al,-0x6(%ebp)
c0101f10:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c0101f14:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f18:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f19:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f1d:	66 c1 e8 08          	shr    $0x8,%ax
c0101f21:	0f b6 c0             	movzbl %al,%eax
c0101f24:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101f2a:	88 45 fb             	mov    %al,-0x5(%ebp)
c0101f2d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101f31:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101f35:	ee                   	out    %al,(%dx)
    }
}
c0101f36:	90                   	nop
c0101f37:	c9                   	leave  
c0101f38:	c3                   	ret    

c0101f39 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f39:	55                   	push   %ebp
c0101f3a:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3f:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f44:	89 c1                	mov    %eax,%ecx
c0101f46:	d3 e2                	shl    %cl,%edx
c0101f48:	89 d0                	mov    %edx,%eax
c0101f4a:	f7 d0                	not    %eax
c0101f4c:	89 c2                	mov    %eax,%edx
c0101f4e:	0f b7 05 70 65 12 c0 	movzwl 0xc0126570,%eax
c0101f55:	21 d0                	and    %edx,%eax
c0101f57:	0f b7 c0             	movzwl %ax,%eax
c0101f5a:	50                   	push   %eax
c0101f5b:	e8 80 ff ff ff       	call   c0101ee0 <pic_setmask>
c0101f60:	83 c4 04             	add    $0x4,%esp
}
c0101f63:	90                   	nop
c0101f64:	c9                   	leave  
c0101f65:	c3                   	ret    

c0101f66 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101f66:	55                   	push   %ebp
c0101f67:	89 e5                	mov    %esp,%ebp
c0101f69:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101f6c:	c7 05 0c 72 12 c0 01 	movl   $0x1,0xc012720c
c0101f73:	00 00 00 
c0101f76:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f7c:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101f80:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101f84:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f88:	ee                   	out    %al,(%dx)
c0101f89:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101f8f:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101f93:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101f97:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101f9b:	ee                   	out    %al,(%dx)
c0101f9c:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101fa2:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101fa6:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101faa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fae:	ee                   	out    %al,(%dx)
c0101faf:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101fb5:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101fb9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101fbd:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101fc1:	ee                   	out    %al,(%dx)
c0101fc2:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101fc8:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101fcc:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101fd0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101fd4:	ee                   	out    %al,(%dx)
c0101fd5:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101fdb:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101fdf:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101fe3:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0101fe7:	ee                   	out    %al,(%dx)
c0101fe8:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c0101fee:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c0101ff2:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0101ff6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ffa:	ee                   	out    %al,(%dx)
c0101ffb:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c0102001:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c0102005:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102009:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c010200d:	ee                   	out    %al,(%dx)
c010200e:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0102014:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c0102018:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c010201c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102020:	ee                   	out    %al,(%dx)
c0102021:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c0102027:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c010202b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c010202f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0102033:	ee                   	out    %al,(%dx)
c0102034:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c010203a:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c010203e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0102042:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102046:	ee                   	out    %al,(%dx)
c0102047:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c010204d:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c0102051:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102055:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0102059:	ee                   	out    %al,(%dx)
c010205a:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102060:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0102064:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0102068:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010206c:	ee                   	out    %al,(%dx)
c010206d:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c0102073:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0102077:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010207b:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c010207f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102080:	0f b7 05 70 65 12 c0 	movzwl 0xc0126570,%eax
c0102087:	66 83 f8 ff          	cmp    $0xffff,%ax
c010208b:	74 13                	je     c01020a0 <pic_init+0x13a>
        pic_setmask(irq_mask);
c010208d:	0f b7 05 70 65 12 c0 	movzwl 0xc0126570,%eax
c0102094:	0f b7 c0             	movzwl %ax,%eax
c0102097:	50                   	push   %eax
c0102098:	e8 43 fe ff ff       	call   c0101ee0 <pic_setmask>
c010209d:	83 c4 04             	add    $0x4,%esp
    }
}
c01020a0:	90                   	nop
c01020a1:	c9                   	leave  
c01020a2:	c3                   	ret    

c01020a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01020a3:	55                   	push   %ebp
c01020a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01020a6:	fb                   	sti    
    sti();
}
c01020a7:	90                   	nop
c01020a8:	5d                   	pop    %ebp
c01020a9:	c3                   	ret    

c01020aa <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01020aa:	55                   	push   %ebp
c01020ab:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01020ad:	fa                   	cli    
    cli();
}
c01020ae:	90                   	nop
c01020af:	5d                   	pop    %ebp
c01020b0:	c3                   	ret    

c01020b1 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020b1:	55                   	push   %ebp
c01020b2:	89 e5                	mov    %esp,%ebp
c01020b4:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020b7:	83 ec 08             	sub    $0x8,%esp
c01020ba:	6a 64                	push   $0x64
c01020bc:	68 40 a3 10 c0       	push   $0xc010a340
c01020c1:	e8 b8 e1 ff ff       	call   c010027e <cprintf>
c01020c6:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01020c9:	83 ec 0c             	sub    $0xc,%esp
c01020cc:	68 4a a3 10 c0       	push   $0xc010a34a
c01020d1:	e8 a8 e1 ff ff       	call   c010027e <cprintf>
c01020d6:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01020d9:	83 ec 04             	sub    $0x4,%esp
c01020dc:	68 58 a3 10 c0       	push   $0xc010a358
c01020e1:	6a 14                	push   $0x14
c01020e3:	68 6e a3 10 c0       	push   $0xc010a36e
c01020e8:	e8 f7 e2 ff ff       	call   c01003e4 <__panic>

c01020ed <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01020ed:	55                   	push   %ebp
c01020ee:	89 e5                	mov    %esp,%ebp
c01020f0:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
c01020f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01020fa:	e9 97 01 00 00       	jmp    c0102296 <idt_init+0x1a9>
//		cprintf("vectors %d: 0x%08x\n", i, __vectors[i]);
		if (i == T_SYSCALL || i == T_SWITCH_TOK) {
c01020ff:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c0102106:	74 0a                	je     c0102112 <idt_init+0x25>
c0102108:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
c010210c:	0f 85 c1 00 00 00    	jne    c01021d3 <idt_init+0xe6>
			SETGATE(idt[i], 1, KERNEL_CS, __vectors[i], DPL_USER);
c0102112:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102115:	8b 04 85 00 66 12 c0 	mov    -0x3fed9a00(,%eax,4),%eax
c010211c:	89 c2                	mov    %eax,%edx
c010211e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102121:	66 89 14 c5 20 72 12 	mov    %dx,-0x3fed8de0(,%eax,8)
c0102128:	c0 
c0102129:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212c:	66 c7 04 c5 22 72 12 	movw   $0x8,-0x3fed8dde(,%eax,8)
c0102133:	c0 08 00 
c0102136:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102139:	0f b6 14 c5 24 72 12 	movzbl -0x3fed8ddc(,%eax,8),%edx
c0102140:	c0 
c0102141:	83 e2 e0             	and    $0xffffffe0,%edx
c0102144:	88 14 c5 24 72 12 c0 	mov    %dl,-0x3fed8ddc(,%eax,8)
c010214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214e:	0f b6 14 c5 24 72 12 	movzbl -0x3fed8ddc(,%eax,8),%edx
c0102155:	c0 
c0102156:	83 e2 1f             	and    $0x1f,%edx
c0102159:	88 14 c5 24 72 12 c0 	mov    %dl,-0x3fed8ddc(,%eax,8)
c0102160:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102163:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c010216a:	c0 
c010216b:	83 ca 0f             	or     $0xf,%edx
c010216e:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c0102175:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102178:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c010217f:	c0 
c0102180:	83 e2 ef             	and    $0xffffffef,%edx
c0102183:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c010218a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218d:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c0102194:	c0 
c0102195:	83 ca 60             	or     $0x60,%edx
c0102198:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c010219f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a2:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c01021a9:	c0 
c01021aa:	83 ca 80             	or     $0xffffff80,%edx
c01021ad:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c01021b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b7:	8b 04 85 00 66 12 c0 	mov    -0x3fed9a00(,%eax,4),%eax
c01021be:	c1 e8 10             	shr    $0x10,%eax
c01021c1:	89 c2                	mov    %eax,%edx
c01021c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c6:	66 89 14 c5 26 72 12 	mov    %dx,-0x3fed8dda(,%eax,8)
c01021cd:	c0 
c01021ce:	e9 bf 00 00 00       	jmp    c0102292 <idt_init+0x1a5>
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
c01021d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d6:	8b 04 85 00 66 12 c0 	mov    -0x3fed9a00(,%eax,4),%eax
c01021dd:	89 c2                	mov    %eax,%edx
c01021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e2:	66 89 14 c5 20 72 12 	mov    %dx,-0x3fed8de0(,%eax,8)
c01021e9:	c0 
c01021ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ed:	66 c7 04 c5 22 72 12 	movw   $0x8,-0x3fed8dde(,%eax,8)
c01021f4:	c0 08 00 
c01021f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021fa:	0f b6 14 c5 24 72 12 	movzbl -0x3fed8ddc(,%eax,8),%edx
c0102201:	c0 
c0102202:	83 e2 e0             	and    $0xffffffe0,%edx
c0102205:	88 14 c5 24 72 12 c0 	mov    %dl,-0x3fed8ddc(,%eax,8)
c010220c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220f:	0f b6 14 c5 24 72 12 	movzbl -0x3fed8ddc(,%eax,8),%edx
c0102216:	c0 
c0102217:	83 e2 1f             	and    $0x1f,%edx
c010221a:	88 14 c5 24 72 12 c0 	mov    %dl,-0x3fed8ddc(,%eax,8)
c0102221:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102224:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c010222b:	c0 
c010222c:	83 e2 f0             	and    $0xfffffff0,%edx
c010222f:	83 ca 0e             	or     $0xe,%edx
c0102232:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c0102239:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223c:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c0102243:	c0 
c0102244:	83 e2 ef             	and    $0xffffffef,%edx
c0102247:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c010224e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102251:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c0102258:	c0 
c0102259:	83 e2 9f             	and    $0xffffff9f,%edx
c010225c:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c0102263:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102266:	0f b6 14 c5 25 72 12 	movzbl -0x3fed8ddb(,%eax,8),%edx
c010226d:	c0 
c010226e:	83 ca 80             	or     $0xffffff80,%edx
c0102271:	88 14 c5 25 72 12 c0 	mov    %dl,-0x3fed8ddb(,%eax,8)
c0102278:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010227b:	8b 04 85 00 66 12 c0 	mov    -0x3fed9a00(,%eax,4),%eax
c0102282:	c1 e8 10             	shr    $0x10,%eax
c0102285:	89 c2                	mov    %eax,%edx
c0102287:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010228a:	66 89 14 c5 26 72 12 	mov    %dx,-0x3fed8dda(,%eax,8)
c0102291:	c0 
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
c0102292:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102296:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010229d:	0f 8e 5c fe ff ff    	jle    c01020ff <idt_init+0x12>
c01022a3:	c7 45 f8 80 65 12 c0 	movl   $0xc0126580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022ad:	0f 01 18             	lidtl  (%eax)
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
		}
	}
	lidt(&idt_pd);
}
c01022b0:	90                   	nop
c01022b1:	c9                   	leave  
c01022b2:	c3                   	ret    

c01022b3 <trapname>:

static const char *
trapname(int trapno) {
c01022b3:	55                   	push   %ebp
c01022b4:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b9:	83 f8 13             	cmp    $0x13,%eax
c01022bc:	77 0c                	ja     c01022ca <trapname+0x17>
        return excnames[trapno];
c01022be:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c1:	8b 04 85 40 a7 10 c0 	mov    -0x3fef58c0(,%eax,4),%eax
c01022c8:	eb 18                	jmp    c01022e2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022ca:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022ce:	7e 0d                	jle    c01022dd <trapname+0x2a>
c01022d0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022d4:	7f 07                	jg     c01022dd <trapname+0x2a>
        return "Hardware Interrupt";
c01022d6:	b8 7f a3 10 c0       	mov    $0xc010a37f,%eax
c01022db:	eb 05                	jmp    c01022e2 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022dd:	b8 92 a3 10 c0       	mov    $0xc010a392,%eax
}
c01022e2:	5d                   	pop    %ebp
c01022e3:	c3                   	ret    

c01022e4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022e4:	55                   	push   %ebp
c01022e5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022ee:	66 83 f8 08          	cmp    $0x8,%ax
c01022f2:	0f 94 c0             	sete   %al
c01022f5:	0f b6 c0             	movzbl %al,%eax
}
c01022f8:	5d                   	pop    %ebp
c01022f9:	c3                   	ret    

c01022fa <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022fa:	55                   	push   %ebp
c01022fb:	89 e5                	mov    %esp,%ebp
c01022fd:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0102300:	83 ec 08             	sub    $0x8,%esp
c0102303:	ff 75 08             	pushl  0x8(%ebp)
c0102306:	68 d3 a3 10 c0       	push   $0xc010a3d3
c010230b:	e8 6e df ff ff       	call   c010027e <cprintf>
c0102310:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0102313:	8b 45 08             	mov    0x8(%ebp),%eax
c0102316:	83 ec 0c             	sub    $0xc,%esp
c0102319:	50                   	push   %eax
c010231a:	e8 b8 01 00 00       	call   c01024d7 <print_regs>
c010231f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102322:	8b 45 08             	mov    0x8(%ebp),%eax
c0102325:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102329:	0f b7 c0             	movzwl %ax,%eax
c010232c:	83 ec 08             	sub    $0x8,%esp
c010232f:	50                   	push   %eax
c0102330:	68 e4 a3 10 c0       	push   $0xc010a3e4
c0102335:	e8 44 df ff ff       	call   c010027e <cprintf>
c010233a:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010233d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102340:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102344:	0f b7 c0             	movzwl %ax,%eax
c0102347:	83 ec 08             	sub    $0x8,%esp
c010234a:	50                   	push   %eax
c010234b:	68 f7 a3 10 c0       	push   $0xc010a3f7
c0102350:	e8 29 df ff ff       	call   c010027e <cprintf>
c0102355:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102358:	8b 45 08             	mov    0x8(%ebp),%eax
c010235b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010235f:	0f b7 c0             	movzwl %ax,%eax
c0102362:	83 ec 08             	sub    $0x8,%esp
c0102365:	50                   	push   %eax
c0102366:	68 0a a4 10 c0       	push   $0xc010a40a
c010236b:	e8 0e df ff ff       	call   c010027e <cprintf>
c0102370:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102373:	8b 45 08             	mov    0x8(%ebp),%eax
c0102376:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010237a:	0f b7 c0             	movzwl %ax,%eax
c010237d:	83 ec 08             	sub    $0x8,%esp
c0102380:	50                   	push   %eax
c0102381:	68 1d a4 10 c0       	push   $0xc010a41d
c0102386:	e8 f3 de ff ff       	call   c010027e <cprintf>
c010238b:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010238e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102391:	8b 40 30             	mov    0x30(%eax),%eax
c0102394:	83 ec 0c             	sub    $0xc,%esp
c0102397:	50                   	push   %eax
c0102398:	e8 16 ff ff ff       	call   c01022b3 <trapname>
c010239d:	83 c4 10             	add    $0x10,%esp
c01023a0:	89 c2                	mov    %eax,%edx
c01023a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a5:	8b 40 30             	mov    0x30(%eax),%eax
c01023a8:	83 ec 04             	sub    $0x4,%esp
c01023ab:	52                   	push   %edx
c01023ac:	50                   	push   %eax
c01023ad:	68 30 a4 10 c0       	push   $0xc010a430
c01023b2:	e8 c7 de ff ff       	call   c010027e <cprintf>
c01023b7:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01023bd:	8b 40 34             	mov    0x34(%eax),%eax
c01023c0:	83 ec 08             	sub    $0x8,%esp
c01023c3:	50                   	push   %eax
c01023c4:	68 42 a4 10 c0       	push   $0xc010a442
c01023c9:	e8 b0 de ff ff       	call   c010027e <cprintf>
c01023ce:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d4:	8b 40 38             	mov    0x38(%eax),%eax
c01023d7:	83 ec 08             	sub    $0x8,%esp
c01023da:	50                   	push   %eax
c01023db:	68 51 a4 10 c0       	push   $0xc010a451
c01023e0:	e8 99 de ff ff       	call   c010027e <cprintf>
c01023e5:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023eb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023ef:	0f b7 c0             	movzwl %ax,%eax
c01023f2:	83 ec 08             	sub    $0x8,%esp
c01023f5:	50                   	push   %eax
c01023f6:	68 60 a4 10 c0       	push   $0xc010a460
c01023fb:	e8 7e de ff ff       	call   c010027e <cprintf>
c0102400:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102403:	8b 45 08             	mov    0x8(%ebp),%eax
c0102406:	8b 40 40             	mov    0x40(%eax),%eax
c0102409:	83 ec 08             	sub    $0x8,%esp
c010240c:	50                   	push   %eax
c010240d:	68 73 a4 10 c0       	push   $0xc010a473
c0102412:	e8 67 de ff ff       	call   c010027e <cprintf>
c0102417:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010241a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102421:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102428:	eb 3f                	jmp    c0102469 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010242a:	8b 45 08             	mov    0x8(%ebp),%eax
c010242d:	8b 50 40             	mov    0x40(%eax),%edx
c0102430:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102433:	21 d0                	and    %edx,%eax
c0102435:	85 c0                	test   %eax,%eax
c0102437:	74 29                	je     c0102462 <print_trapframe+0x168>
c0102439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010243c:	8b 04 85 a0 65 12 c0 	mov    -0x3fed9a60(,%eax,4),%eax
c0102443:	85 c0                	test   %eax,%eax
c0102445:	74 1b                	je     c0102462 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0102447:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010244a:	8b 04 85 a0 65 12 c0 	mov    -0x3fed9a60(,%eax,4),%eax
c0102451:	83 ec 08             	sub    $0x8,%esp
c0102454:	50                   	push   %eax
c0102455:	68 82 a4 10 c0       	push   $0xc010a482
c010245a:	e8 1f de ff ff       	call   c010027e <cprintf>
c010245f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102462:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102466:	d1 65 f0             	shll   -0x10(%ebp)
c0102469:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010246c:	83 f8 17             	cmp    $0x17,%eax
c010246f:	76 b9                	jbe    c010242a <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102471:	8b 45 08             	mov    0x8(%ebp),%eax
c0102474:	8b 40 40             	mov    0x40(%eax),%eax
c0102477:	25 00 30 00 00       	and    $0x3000,%eax
c010247c:	c1 e8 0c             	shr    $0xc,%eax
c010247f:	83 ec 08             	sub    $0x8,%esp
c0102482:	50                   	push   %eax
c0102483:	68 86 a4 10 c0       	push   $0xc010a486
c0102488:	e8 f1 dd ff ff       	call   c010027e <cprintf>
c010248d:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0102490:	83 ec 0c             	sub    $0xc,%esp
c0102493:	ff 75 08             	pushl  0x8(%ebp)
c0102496:	e8 49 fe ff ff       	call   c01022e4 <trap_in_kernel>
c010249b:	83 c4 10             	add    $0x10,%esp
c010249e:	85 c0                	test   %eax,%eax
c01024a0:	75 32                	jne    c01024d4 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01024a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a5:	8b 40 44             	mov    0x44(%eax),%eax
c01024a8:	83 ec 08             	sub    $0x8,%esp
c01024ab:	50                   	push   %eax
c01024ac:	68 8f a4 10 c0       	push   $0xc010a48f
c01024b1:	e8 c8 dd ff ff       	call   c010027e <cprintf>
c01024b6:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01024b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024bc:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024c0:	0f b7 c0             	movzwl %ax,%eax
c01024c3:	83 ec 08             	sub    $0x8,%esp
c01024c6:	50                   	push   %eax
c01024c7:	68 9e a4 10 c0       	push   $0xc010a49e
c01024cc:	e8 ad dd ff ff       	call   c010027e <cprintf>
c01024d1:	83 c4 10             	add    $0x10,%esp
    }
}
c01024d4:	90                   	nop
c01024d5:	c9                   	leave  
c01024d6:	c3                   	ret    

c01024d7 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024d7:	55                   	push   %ebp
c01024d8:	89 e5                	mov    %esp,%ebp
c01024da:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e0:	8b 00                	mov    (%eax),%eax
c01024e2:	83 ec 08             	sub    $0x8,%esp
c01024e5:	50                   	push   %eax
c01024e6:	68 b1 a4 10 c0       	push   $0xc010a4b1
c01024eb:	e8 8e dd ff ff       	call   c010027e <cprintf>
c01024f0:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f6:	8b 40 04             	mov    0x4(%eax),%eax
c01024f9:	83 ec 08             	sub    $0x8,%esp
c01024fc:	50                   	push   %eax
c01024fd:	68 c0 a4 10 c0       	push   $0xc010a4c0
c0102502:	e8 77 dd ff ff       	call   c010027e <cprintf>
c0102507:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010250a:	8b 45 08             	mov    0x8(%ebp),%eax
c010250d:	8b 40 08             	mov    0x8(%eax),%eax
c0102510:	83 ec 08             	sub    $0x8,%esp
c0102513:	50                   	push   %eax
c0102514:	68 cf a4 10 c0       	push   $0xc010a4cf
c0102519:	e8 60 dd ff ff       	call   c010027e <cprintf>
c010251e:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102521:	8b 45 08             	mov    0x8(%ebp),%eax
c0102524:	8b 40 0c             	mov    0xc(%eax),%eax
c0102527:	83 ec 08             	sub    $0x8,%esp
c010252a:	50                   	push   %eax
c010252b:	68 de a4 10 c0       	push   $0xc010a4de
c0102530:	e8 49 dd ff ff       	call   c010027e <cprintf>
c0102535:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102538:	8b 45 08             	mov    0x8(%ebp),%eax
c010253b:	8b 40 10             	mov    0x10(%eax),%eax
c010253e:	83 ec 08             	sub    $0x8,%esp
c0102541:	50                   	push   %eax
c0102542:	68 ed a4 10 c0       	push   $0xc010a4ed
c0102547:	e8 32 dd ff ff       	call   c010027e <cprintf>
c010254c:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010254f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102552:	8b 40 14             	mov    0x14(%eax),%eax
c0102555:	83 ec 08             	sub    $0x8,%esp
c0102558:	50                   	push   %eax
c0102559:	68 fc a4 10 c0       	push   $0xc010a4fc
c010255e:	e8 1b dd ff ff       	call   c010027e <cprintf>
c0102563:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102566:	8b 45 08             	mov    0x8(%ebp),%eax
c0102569:	8b 40 18             	mov    0x18(%eax),%eax
c010256c:	83 ec 08             	sub    $0x8,%esp
c010256f:	50                   	push   %eax
c0102570:	68 0b a5 10 c0       	push   $0xc010a50b
c0102575:	e8 04 dd ff ff       	call   c010027e <cprintf>
c010257a:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010257d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102580:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102583:	83 ec 08             	sub    $0x8,%esp
c0102586:	50                   	push   %eax
c0102587:	68 1a a5 10 c0       	push   $0xc010a51a
c010258c:	e8 ed dc ff ff       	call   c010027e <cprintf>
c0102591:	83 c4 10             	add    $0x10,%esp
}
c0102594:	90                   	nop
c0102595:	c9                   	leave  
c0102596:	c3                   	ret    

c0102597 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102597:	55                   	push   %ebp
c0102598:	89 e5                	mov    %esp,%ebp
c010259a:	53                   	push   %ebx
c010259b:	83 ec 14             	sub    $0x14,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010259e:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a1:	8b 40 34             	mov    0x34(%eax),%eax
c01025a4:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025a7:	85 c0                	test   %eax,%eax
c01025a9:	74 07                	je     c01025b2 <print_pgfault+0x1b>
c01025ab:	bb 29 a5 10 c0       	mov    $0xc010a529,%ebx
c01025b0:	eb 05                	jmp    c01025b7 <print_pgfault+0x20>
c01025b2:	bb 3a a5 10 c0       	mov    $0xc010a53a,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01025b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ba:	8b 40 34             	mov    0x34(%eax),%eax
c01025bd:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025c0:	85 c0                	test   %eax,%eax
c01025c2:	74 07                	je     c01025cb <print_pgfault+0x34>
c01025c4:	b9 57 00 00 00       	mov    $0x57,%ecx
c01025c9:	eb 05                	jmp    c01025d0 <print_pgfault+0x39>
c01025cb:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d3:	8b 40 34             	mov    0x34(%eax),%eax
c01025d6:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025d9:	85 c0                	test   %eax,%eax
c01025db:	74 07                	je     c01025e4 <print_pgfault+0x4d>
c01025dd:	ba 55 00 00 00       	mov    $0x55,%edx
c01025e2:	eb 05                	jmp    c01025e9 <print_pgfault+0x52>
c01025e4:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025e9:	0f 20 d0             	mov    %cr2,%eax
c01025ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025f2:	83 ec 0c             	sub    $0xc,%esp
c01025f5:	53                   	push   %ebx
c01025f6:	51                   	push   %ecx
c01025f7:	52                   	push   %edx
c01025f8:	50                   	push   %eax
c01025f9:	68 48 a5 10 c0       	push   $0xc010a548
c01025fe:	e8 7b dc ff ff       	call   c010027e <cprintf>
c0102603:	83 c4 20             	add    $0x20,%esp
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102606:	90                   	nop
c0102607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010260a:	c9                   	leave  
c010260b:	c3                   	ret    

c010260c <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010260c:	55                   	push   %ebp
c010260d:	89 e5                	mov    %esp,%ebp
c010260f:	83 ec 18             	sub    $0x18,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102612:	83 ec 0c             	sub    $0xc,%esp
c0102615:	ff 75 08             	pushl  0x8(%ebp)
c0102618:	e8 7a ff ff ff       	call   c0102597 <print_pgfault>
c010261d:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
c0102620:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c0102625:	85 c0                	test   %eax,%eax
c0102627:	74 24                	je     c010264d <pgfault_handler+0x41>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102629:	0f 20 d0             	mov    %cr2,%eax
c010262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010262f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102632:	8b 45 08             	mov    0x8(%ebp),%eax
c0102635:	8b 50 34             	mov    0x34(%eax),%edx
c0102638:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c010263d:	83 ec 04             	sub    $0x4,%esp
c0102640:	51                   	push   %ecx
c0102641:	52                   	push   %edx
c0102642:	50                   	push   %eax
c0102643:	e8 02 2f 00 00       	call   c010554a <do_pgfault>
c0102648:	83 c4 10             	add    $0x10,%esp
c010264b:	eb 17                	jmp    c0102664 <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c010264d:	83 ec 04             	sub    $0x4,%esp
c0102650:	68 6b a5 10 c0       	push   $0xc010a56b
c0102655:	68 a9 00 00 00       	push   $0xa9
c010265a:	68 6e a3 10 c0       	push   $0xc010a36e
c010265f:	e8 80 dd ff ff       	call   c01003e4 <__panic>
}
c0102664:	c9                   	leave  
c0102665:	c3                   	ret    

c0102666 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102666:	55                   	push   %ebp
c0102667:	89 e5                	mov    %esp,%ebp
c0102669:	83 ec 18             	sub    $0x18,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010266c:	8b 45 08             	mov    0x8(%ebp),%eax
c010266f:	8b 40 30             	mov    0x30(%eax),%eax
c0102672:	83 f8 24             	cmp    $0x24,%eax
c0102675:	0f 84 ba 00 00 00    	je     c0102735 <trap_dispatch+0xcf>
c010267b:	83 f8 24             	cmp    $0x24,%eax
c010267e:	77 18                	ja     c0102698 <trap_dispatch+0x32>
c0102680:	83 f8 20             	cmp    $0x20,%eax
c0102683:	74 76                	je     c01026fb <trap_dispatch+0x95>
c0102685:	83 f8 21             	cmp    $0x21,%eax
c0102688:	0f 84 cb 00 00 00    	je     c0102759 <trap_dispatch+0xf3>
c010268e:	83 f8 0e             	cmp    $0xe,%eax
c0102691:	74 28                	je     c01026bb <trap_dispatch+0x55>
c0102693:	e9 fc 00 00 00       	jmp    c0102794 <trap_dispatch+0x12e>
c0102698:	83 f8 2e             	cmp    $0x2e,%eax
c010269b:	0f 82 f3 00 00 00    	jb     c0102794 <trap_dispatch+0x12e>
c01026a1:	83 f8 2f             	cmp    $0x2f,%eax
c01026a4:	0f 86 20 01 00 00    	jbe    c01027ca <trap_dispatch+0x164>
c01026aa:	83 e8 78             	sub    $0x78,%eax
c01026ad:	83 f8 01             	cmp    $0x1,%eax
c01026b0:	0f 87 de 00 00 00    	ja     c0102794 <trap_dispatch+0x12e>
c01026b6:	e9 c2 00 00 00       	jmp    c010277d <trap_dispatch+0x117>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026bb:	83 ec 0c             	sub    $0xc,%esp
c01026be:	ff 75 08             	pushl  0x8(%ebp)
c01026c1:	e8 46 ff ff ff       	call   c010260c <pgfault_handler>
c01026c6:	83 c4 10             	add    $0x10,%esp
c01026c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026d0:	0f 84 f7 00 00 00    	je     c01027cd <trap_dispatch+0x167>
            print_trapframe(tf);
c01026d6:	83 ec 0c             	sub    $0xc,%esp
c01026d9:	ff 75 08             	pushl  0x8(%ebp)
c01026dc:	e8 19 fc ff ff       	call   c01022fa <print_trapframe>
c01026e1:	83 c4 10             	add    $0x10,%esp
            panic("handle pgfault failed. %e\n", ret);
c01026e4:	ff 75 f4             	pushl  -0xc(%ebp)
c01026e7:	68 82 a5 10 c0       	push   $0xc010a582
c01026ec:	68 b9 00 00 00       	push   $0xb9
c01026f1:	68 6e a3 10 c0       	push   $0xc010a36e
c01026f6:	e8 e9 dc ff ff       	call   c01003e4 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
c01026fb:	a1 14 9b 12 c0       	mov    0xc0129b14,%eax
c0102700:	83 c0 01             	add    $0x1,%eax
c0102703:	a3 14 9b 12 c0       	mov    %eax,0xc0129b14
		if (ticks % TICK_NUM == 0) {
c0102708:	8b 0d 14 9b 12 c0    	mov    0xc0129b14,%ecx
c010270e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102713:	89 c8                	mov    %ecx,%eax
c0102715:	f7 e2                	mul    %edx
c0102717:	89 d0                	mov    %edx,%eax
c0102719:	c1 e8 05             	shr    $0x5,%eax
c010271c:	6b c0 64             	imul   $0x64,%eax,%eax
c010271f:	29 c1                	sub    %eax,%ecx
c0102721:	89 c8                	mov    %ecx,%eax
c0102723:	85 c0                	test   %eax,%eax
c0102725:	0f 85 a5 00 00 00    	jne    c01027d0 <trap_dispatch+0x16a>
			print_ticks();
c010272b:	e8 81 f9 ff ff       	call   c01020b1 <print_ticks>
		}
        break;
c0102730:	e9 9b 00 00 00       	jmp    c01027d0 <trap_dispatch+0x16a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102735:	e8 34 f7 ff ff       	call   c0101e6e <cons_getc>
c010273a:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010273d:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102741:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102745:	83 ec 04             	sub    $0x4,%esp
c0102748:	52                   	push   %edx
c0102749:	50                   	push   %eax
c010274a:	68 9d a5 10 c0       	push   $0xc010a59d
c010274f:	e8 2a db ff ff       	call   c010027e <cprintf>
c0102754:	83 c4 10             	add    $0x10,%esp
        break;
c0102757:	eb 78                	jmp    c01027d1 <trap_dispatch+0x16b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102759:	e8 10 f7 ff ff       	call   c0101e6e <cons_getc>
c010275e:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102761:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102765:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102769:	83 ec 04             	sub    $0x4,%esp
c010276c:	52                   	push   %edx
c010276d:	50                   	push   %eax
c010276e:	68 af a5 10 c0       	push   $0xc010a5af
c0102773:	e8 06 db ff ff       	call   c010027e <cprintf>
c0102778:	83 c4 10             	add    $0x10,%esp
        break;
c010277b:	eb 54                	jmp    c01027d1 <trap_dispatch+0x16b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c010277d:	83 ec 04             	sub    $0x4,%esp
c0102780:	68 be a5 10 c0       	push   $0xc010a5be
c0102785:	68 d7 00 00 00       	push   $0xd7
c010278a:	68 6e a3 10 c0       	push   $0xc010a36e
c010278f:	e8 50 dc ff ff       	call   c01003e4 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102794:	8b 45 08             	mov    0x8(%ebp),%eax
c0102797:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010279b:	0f b7 c0             	movzwl %ax,%eax
c010279e:	83 e0 03             	and    $0x3,%eax
c01027a1:	85 c0                	test   %eax,%eax
c01027a3:	75 2c                	jne    c01027d1 <trap_dispatch+0x16b>
            print_trapframe(tf);
c01027a5:	83 ec 0c             	sub    $0xc,%esp
c01027a8:	ff 75 08             	pushl  0x8(%ebp)
c01027ab:	e8 4a fb ff ff       	call   c01022fa <print_trapframe>
c01027b0:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c01027b3:	83 ec 04             	sub    $0x4,%esp
c01027b6:	68 ce a5 10 c0       	push   $0xc010a5ce
c01027bb:	68 e1 00 00 00       	push   $0xe1
c01027c0:	68 6e a3 10 c0       	push   $0xc010a36e
c01027c5:	e8 1a dc ff ff       	call   c01003e4 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01027ca:	90                   	nop
c01027cb:	eb 04                	jmp    c01027d1 <trap_dispatch+0x16b>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c01027cd:	90                   	nop
c01027ce:	eb 01                	jmp    c01027d1 <trap_dispatch+0x16b>
         */
		ticks ++;
		if (ticks % TICK_NUM == 0) {
			print_ticks();
		}
        break;
c01027d0:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c01027d1:	90                   	nop
c01027d2:	c9                   	leave  
c01027d3:	c3                   	ret    

c01027d4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01027d4:	55                   	push   %ebp
c01027d5:	89 e5                	mov    %esp,%ebp
c01027d7:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027da:	83 ec 0c             	sub    $0xc,%esp
c01027dd:	ff 75 08             	pushl  0x8(%ebp)
c01027e0:	e8 81 fe ff ff       	call   c0102666 <trap_dispatch>
c01027e5:	83 c4 10             	add    $0x10,%esp
}
c01027e8:	90                   	nop
c01027e9:	c9                   	leave  
c01027ea:	c3                   	ret    

c01027eb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $0
c01027ed:	6a 00                	push   $0x0
  jmp __alltraps
c01027ef:	e9 67 0a 00 00       	jmp    c010325b <__alltraps>

c01027f4 <vector1>:
.globl vector1
vector1:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $1
c01027f6:	6a 01                	push   $0x1
  jmp __alltraps
c01027f8:	e9 5e 0a 00 00       	jmp    c010325b <__alltraps>

c01027fd <vector2>:
.globl vector2
vector2:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $2
c01027ff:	6a 02                	push   $0x2
  jmp __alltraps
c0102801:	e9 55 0a 00 00       	jmp    c010325b <__alltraps>

c0102806 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $3
c0102808:	6a 03                	push   $0x3
  jmp __alltraps
c010280a:	e9 4c 0a 00 00       	jmp    c010325b <__alltraps>

c010280f <vector4>:
.globl vector4
vector4:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $4
c0102811:	6a 04                	push   $0x4
  jmp __alltraps
c0102813:	e9 43 0a 00 00       	jmp    c010325b <__alltraps>

c0102818 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $5
c010281a:	6a 05                	push   $0x5
  jmp __alltraps
c010281c:	e9 3a 0a 00 00       	jmp    c010325b <__alltraps>

c0102821 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $6
c0102823:	6a 06                	push   $0x6
  jmp __alltraps
c0102825:	e9 31 0a 00 00       	jmp    c010325b <__alltraps>

c010282a <vector7>:
.globl vector7
vector7:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $7
c010282c:	6a 07                	push   $0x7
  jmp __alltraps
c010282e:	e9 28 0a 00 00       	jmp    c010325b <__alltraps>

c0102833 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102833:	6a 08                	push   $0x8
  jmp __alltraps
c0102835:	e9 21 0a 00 00       	jmp    c010325b <__alltraps>

c010283a <vector9>:
.globl vector9
vector9:
  pushl $9
c010283a:	6a 09                	push   $0x9
  jmp __alltraps
c010283c:	e9 1a 0a 00 00       	jmp    c010325b <__alltraps>

c0102841 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102841:	6a 0a                	push   $0xa
  jmp __alltraps
c0102843:	e9 13 0a 00 00       	jmp    c010325b <__alltraps>

c0102848 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102848:	6a 0b                	push   $0xb
  jmp __alltraps
c010284a:	e9 0c 0a 00 00       	jmp    c010325b <__alltraps>

c010284f <vector12>:
.globl vector12
vector12:
  pushl $12
c010284f:	6a 0c                	push   $0xc
  jmp __alltraps
c0102851:	e9 05 0a 00 00       	jmp    c010325b <__alltraps>

c0102856 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102856:	6a 0d                	push   $0xd
  jmp __alltraps
c0102858:	e9 fe 09 00 00       	jmp    c010325b <__alltraps>

c010285d <vector14>:
.globl vector14
vector14:
  pushl $14
c010285d:	6a 0e                	push   $0xe
  jmp __alltraps
c010285f:	e9 f7 09 00 00       	jmp    c010325b <__alltraps>

c0102864 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $15
c0102866:	6a 0f                	push   $0xf
  jmp __alltraps
c0102868:	e9 ee 09 00 00       	jmp    c010325b <__alltraps>

c010286d <vector16>:
.globl vector16
vector16:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $16
c010286f:	6a 10                	push   $0x10
  jmp __alltraps
c0102871:	e9 e5 09 00 00       	jmp    c010325b <__alltraps>

c0102876 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102876:	6a 11                	push   $0x11
  jmp __alltraps
c0102878:	e9 de 09 00 00       	jmp    c010325b <__alltraps>

c010287d <vector18>:
.globl vector18
vector18:
  pushl $0
c010287d:	6a 00                	push   $0x0
  pushl $18
c010287f:	6a 12                	push   $0x12
  jmp __alltraps
c0102881:	e9 d5 09 00 00       	jmp    c010325b <__alltraps>

c0102886 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $19
c0102888:	6a 13                	push   $0x13
  jmp __alltraps
c010288a:	e9 cc 09 00 00       	jmp    c010325b <__alltraps>

c010288f <vector20>:
.globl vector20
vector20:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $20
c0102891:	6a 14                	push   $0x14
  jmp __alltraps
c0102893:	e9 c3 09 00 00       	jmp    c010325b <__alltraps>

c0102898 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102898:	6a 00                	push   $0x0
  pushl $21
c010289a:	6a 15                	push   $0x15
  jmp __alltraps
c010289c:	e9 ba 09 00 00       	jmp    c010325b <__alltraps>

c01028a1 <vector22>:
.globl vector22
vector22:
  pushl $0
c01028a1:	6a 00                	push   $0x0
  pushl $22
c01028a3:	6a 16                	push   $0x16
  jmp __alltraps
c01028a5:	e9 b1 09 00 00       	jmp    c010325b <__alltraps>

c01028aa <vector23>:
.globl vector23
vector23:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $23
c01028ac:	6a 17                	push   $0x17
  jmp __alltraps
c01028ae:	e9 a8 09 00 00       	jmp    c010325b <__alltraps>

c01028b3 <vector24>:
.globl vector24
vector24:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $24
c01028b5:	6a 18                	push   $0x18
  jmp __alltraps
c01028b7:	e9 9f 09 00 00       	jmp    c010325b <__alltraps>

c01028bc <vector25>:
.globl vector25
vector25:
  pushl $0
c01028bc:	6a 00                	push   $0x0
  pushl $25
c01028be:	6a 19                	push   $0x19
  jmp __alltraps
c01028c0:	e9 96 09 00 00       	jmp    c010325b <__alltraps>

c01028c5 <vector26>:
.globl vector26
vector26:
  pushl $0
c01028c5:	6a 00                	push   $0x0
  pushl $26
c01028c7:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028c9:	e9 8d 09 00 00       	jmp    c010325b <__alltraps>

c01028ce <vector27>:
.globl vector27
vector27:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $27
c01028d0:	6a 1b                	push   $0x1b
  jmp __alltraps
c01028d2:	e9 84 09 00 00       	jmp    c010325b <__alltraps>

c01028d7 <vector28>:
.globl vector28
vector28:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $28
c01028d9:	6a 1c                	push   $0x1c
  jmp __alltraps
c01028db:	e9 7b 09 00 00       	jmp    c010325b <__alltraps>

c01028e0 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028e0:	6a 00                	push   $0x0
  pushl $29
c01028e2:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028e4:	e9 72 09 00 00       	jmp    c010325b <__alltraps>

c01028e9 <vector30>:
.globl vector30
vector30:
  pushl $0
c01028e9:	6a 00                	push   $0x0
  pushl $30
c01028eb:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028ed:	e9 69 09 00 00       	jmp    c010325b <__alltraps>

c01028f2 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $31
c01028f4:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028f6:	e9 60 09 00 00       	jmp    c010325b <__alltraps>

c01028fb <vector32>:
.globl vector32
vector32:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $32
c01028fd:	6a 20                	push   $0x20
  jmp __alltraps
c01028ff:	e9 57 09 00 00       	jmp    c010325b <__alltraps>

c0102904 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $33
c0102906:	6a 21                	push   $0x21
  jmp __alltraps
c0102908:	e9 4e 09 00 00       	jmp    c010325b <__alltraps>

c010290d <vector34>:
.globl vector34
vector34:
  pushl $0
c010290d:	6a 00                	push   $0x0
  pushl $34
c010290f:	6a 22                	push   $0x22
  jmp __alltraps
c0102911:	e9 45 09 00 00       	jmp    c010325b <__alltraps>

c0102916 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $35
c0102918:	6a 23                	push   $0x23
  jmp __alltraps
c010291a:	e9 3c 09 00 00       	jmp    c010325b <__alltraps>

c010291f <vector36>:
.globl vector36
vector36:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $36
c0102921:	6a 24                	push   $0x24
  jmp __alltraps
c0102923:	e9 33 09 00 00       	jmp    c010325b <__alltraps>

c0102928 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $37
c010292a:	6a 25                	push   $0x25
  jmp __alltraps
c010292c:	e9 2a 09 00 00       	jmp    c010325b <__alltraps>

c0102931 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102931:	6a 00                	push   $0x0
  pushl $38
c0102933:	6a 26                	push   $0x26
  jmp __alltraps
c0102935:	e9 21 09 00 00       	jmp    c010325b <__alltraps>

c010293a <vector39>:
.globl vector39
vector39:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $39
c010293c:	6a 27                	push   $0x27
  jmp __alltraps
c010293e:	e9 18 09 00 00       	jmp    c010325b <__alltraps>

c0102943 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $40
c0102945:	6a 28                	push   $0x28
  jmp __alltraps
c0102947:	e9 0f 09 00 00       	jmp    c010325b <__alltraps>

c010294c <vector41>:
.globl vector41
vector41:
  pushl $0
c010294c:	6a 00                	push   $0x0
  pushl $41
c010294e:	6a 29                	push   $0x29
  jmp __alltraps
c0102950:	e9 06 09 00 00       	jmp    c010325b <__alltraps>

c0102955 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102955:	6a 00                	push   $0x0
  pushl $42
c0102957:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102959:	e9 fd 08 00 00       	jmp    c010325b <__alltraps>

c010295e <vector43>:
.globl vector43
vector43:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $43
c0102960:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102962:	e9 f4 08 00 00       	jmp    c010325b <__alltraps>

c0102967 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $44
c0102969:	6a 2c                	push   $0x2c
  jmp __alltraps
c010296b:	e9 eb 08 00 00       	jmp    c010325b <__alltraps>

c0102970 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $45
c0102972:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102974:	e9 e2 08 00 00       	jmp    c010325b <__alltraps>

c0102979 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102979:	6a 00                	push   $0x0
  pushl $46
c010297b:	6a 2e                	push   $0x2e
  jmp __alltraps
c010297d:	e9 d9 08 00 00       	jmp    c010325b <__alltraps>

c0102982 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $47
c0102984:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102986:	e9 d0 08 00 00       	jmp    c010325b <__alltraps>

c010298b <vector48>:
.globl vector48
vector48:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $48
c010298d:	6a 30                	push   $0x30
  jmp __alltraps
c010298f:	e9 c7 08 00 00       	jmp    c010325b <__alltraps>

c0102994 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102994:	6a 00                	push   $0x0
  pushl $49
c0102996:	6a 31                	push   $0x31
  jmp __alltraps
c0102998:	e9 be 08 00 00       	jmp    c010325b <__alltraps>

c010299d <vector50>:
.globl vector50
vector50:
  pushl $0
c010299d:	6a 00                	push   $0x0
  pushl $50
c010299f:	6a 32                	push   $0x32
  jmp __alltraps
c01029a1:	e9 b5 08 00 00       	jmp    c010325b <__alltraps>

c01029a6 <vector51>:
.globl vector51
vector51:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $51
c01029a8:	6a 33                	push   $0x33
  jmp __alltraps
c01029aa:	e9 ac 08 00 00       	jmp    c010325b <__alltraps>

c01029af <vector52>:
.globl vector52
vector52:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $52
c01029b1:	6a 34                	push   $0x34
  jmp __alltraps
c01029b3:	e9 a3 08 00 00       	jmp    c010325b <__alltraps>

c01029b8 <vector53>:
.globl vector53
vector53:
  pushl $0
c01029b8:	6a 00                	push   $0x0
  pushl $53
c01029ba:	6a 35                	push   $0x35
  jmp __alltraps
c01029bc:	e9 9a 08 00 00       	jmp    c010325b <__alltraps>

c01029c1 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029c1:	6a 00                	push   $0x0
  pushl $54
c01029c3:	6a 36                	push   $0x36
  jmp __alltraps
c01029c5:	e9 91 08 00 00       	jmp    c010325b <__alltraps>

c01029ca <vector55>:
.globl vector55
vector55:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $55
c01029cc:	6a 37                	push   $0x37
  jmp __alltraps
c01029ce:	e9 88 08 00 00       	jmp    c010325b <__alltraps>

c01029d3 <vector56>:
.globl vector56
vector56:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $56
c01029d5:	6a 38                	push   $0x38
  jmp __alltraps
c01029d7:	e9 7f 08 00 00       	jmp    c010325b <__alltraps>

c01029dc <vector57>:
.globl vector57
vector57:
  pushl $0
c01029dc:	6a 00                	push   $0x0
  pushl $57
c01029de:	6a 39                	push   $0x39
  jmp __alltraps
c01029e0:	e9 76 08 00 00       	jmp    c010325b <__alltraps>

c01029e5 <vector58>:
.globl vector58
vector58:
  pushl $0
c01029e5:	6a 00                	push   $0x0
  pushl $58
c01029e7:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029e9:	e9 6d 08 00 00       	jmp    c010325b <__alltraps>

c01029ee <vector59>:
.globl vector59
vector59:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $59
c01029f0:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029f2:	e9 64 08 00 00       	jmp    c010325b <__alltraps>

c01029f7 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $60
c01029f9:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029fb:	e9 5b 08 00 00       	jmp    c010325b <__alltraps>

c0102a00 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a00:	6a 00                	push   $0x0
  pushl $61
c0102a02:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a04:	e9 52 08 00 00       	jmp    c010325b <__alltraps>

c0102a09 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a09:	6a 00                	push   $0x0
  pushl $62
c0102a0b:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a0d:	e9 49 08 00 00       	jmp    c010325b <__alltraps>

c0102a12 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $63
c0102a14:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a16:	e9 40 08 00 00       	jmp    c010325b <__alltraps>

c0102a1b <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $64
c0102a1d:	6a 40                	push   $0x40
  jmp __alltraps
c0102a1f:	e9 37 08 00 00       	jmp    c010325b <__alltraps>

c0102a24 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a24:	6a 00                	push   $0x0
  pushl $65
c0102a26:	6a 41                	push   $0x41
  jmp __alltraps
c0102a28:	e9 2e 08 00 00       	jmp    c010325b <__alltraps>

c0102a2d <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $66
c0102a2f:	6a 42                	push   $0x42
  jmp __alltraps
c0102a31:	e9 25 08 00 00       	jmp    c010325b <__alltraps>

c0102a36 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $67
c0102a38:	6a 43                	push   $0x43
  jmp __alltraps
c0102a3a:	e9 1c 08 00 00       	jmp    c010325b <__alltraps>

c0102a3f <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $68
c0102a41:	6a 44                	push   $0x44
  jmp __alltraps
c0102a43:	e9 13 08 00 00       	jmp    c010325b <__alltraps>

c0102a48 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a48:	6a 00                	push   $0x0
  pushl $69
c0102a4a:	6a 45                	push   $0x45
  jmp __alltraps
c0102a4c:	e9 0a 08 00 00       	jmp    c010325b <__alltraps>

c0102a51 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $70
c0102a53:	6a 46                	push   $0x46
  jmp __alltraps
c0102a55:	e9 01 08 00 00       	jmp    c010325b <__alltraps>

c0102a5a <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $71
c0102a5c:	6a 47                	push   $0x47
  jmp __alltraps
c0102a5e:	e9 f8 07 00 00       	jmp    c010325b <__alltraps>

c0102a63 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $72
c0102a65:	6a 48                	push   $0x48
  jmp __alltraps
c0102a67:	e9 ef 07 00 00       	jmp    c010325b <__alltraps>

c0102a6c <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a6c:	6a 00                	push   $0x0
  pushl $73
c0102a6e:	6a 49                	push   $0x49
  jmp __alltraps
c0102a70:	e9 e6 07 00 00       	jmp    c010325b <__alltraps>

c0102a75 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $74
c0102a77:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a79:	e9 dd 07 00 00       	jmp    c010325b <__alltraps>

c0102a7e <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $75
c0102a80:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a82:	e9 d4 07 00 00       	jmp    c010325b <__alltraps>

c0102a87 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $76
c0102a89:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a8b:	e9 cb 07 00 00       	jmp    c010325b <__alltraps>

c0102a90 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a90:	6a 00                	push   $0x0
  pushl $77
c0102a92:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a94:	e9 c2 07 00 00       	jmp    c010325b <__alltraps>

c0102a99 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $78
c0102a9b:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a9d:	e9 b9 07 00 00       	jmp    c010325b <__alltraps>

c0102aa2 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $79
c0102aa4:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102aa6:	e9 b0 07 00 00       	jmp    c010325b <__alltraps>

c0102aab <vector80>:
.globl vector80
vector80:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $80
c0102aad:	6a 50                	push   $0x50
  jmp __alltraps
c0102aaf:	e9 a7 07 00 00       	jmp    c010325b <__alltraps>

c0102ab4 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102ab4:	6a 00                	push   $0x0
  pushl $81
c0102ab6:	6a 51                	push   $0x51
  jmp __alltraps
c0102ab8:	e9 9e 07 00 00       	jmp    c010325b <__alltraps>

c0102abd <vector82>:
.globl vector82
vector82:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $82
c0102abf:	6a 52                	push   $0x52
  jmp __alltraps
c0102ac1:	e9 95 07 00 00       	jmp    c010325b <__alltraps>

c0102ac6 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $83
c0102ac8:	6a 53                	push   $0x53
  jmp __alltraps
c0102aca:	e9 8c 07 00 00       	jmp    c010325b <__alltraps>

c0102acf <vector84>:
.globl vector84
vector84:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $84
c0102ad1:	6a 54                	push   $0x54
  jmp __alltraps
c0102ad3:	e9 83 07 00 00       	jmp    c010325b <__alltraps>

c0102ad8 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102ad8:	6a 00                	push   $0x0
  pushl $85
c0102ada:	6a 55                	push   $0x55
  jmp __alltraps
c0102adc:	e9 7a 07 00 00       	jmp    c010325b <__alltraps>

c0102ae1 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $86
c0102ae3:	6a 56                	push   $0x56
  jmp __alltraps
c0102ae5:	e9 71 07 00 00       	jmp    c010325b <__alltraps>

c0102aea <vector87>:
.globl vector87
vector87:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $87
c0102aec:	6a 57                	push   $0x57
  jmp __alltraps
c0102aee:	e9 68 07 00 00       	jmp    c010325b <__alltraps>

c0102af3 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $88
c0102af5:	6a 58                	push   $0x58
  jmp __alltraps
c0102af7:	e9 5f 07 00 00       	jmp    c010325b <__alltraps>

c0102afc <vector89>:
.globl vector89
vector89:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $89
c0102afe:	6a 59                	push   $0x59
  jmp __alltraps
c0102b00:	e9 56 07 00 00       	jmp    c010325b <__alltraps>

c0102b05 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $90
c0102b07:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b09:	e9 4d 07 00 00       	jmp    c010325b <__alltraps>

c0102b0e <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $91
c0102b10:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b12:	e9 44 07 00 00       	jmp    c010325b <__alltraps>

c0102b17 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $92
c0102b19:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b1b:	e9 3b 07 00 00       	jmp    c010325b <__alltraps>

c0102b20 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $93
c0102b22:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b24:	e9 32 07 00 00       	jmp    c010325b <__alltraps>

c0102b29 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $94
c0102b2b:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b2d:	e9 29 07 00 00       	jmp    c010325b <__alltraps>

c0102b32 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $95
c0102b34:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b36:	e9 20 07 00 00       	jmp    c010325b <__alltraps>

c0102b3b <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $96
c0102b3d:	6a 60                	push   $0x60
  jmp __alltraps
c0102b3f:	e9 17 07 00 00       	jmp    c010325b <__alltraps>

c0102b44 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $97
c0102b46:	6a 61                	push   $0x61
  jmp __alltraps
c0102b48:	e9 0e 07 00 00       	jmp    c010325b <__alltraps>

c0102b4d <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $98
c0102b4f:	6a 62                	push   $0x62
  jmp __alltraps
c0102b51:	e9 05 07 00 00       	jmp    c010325b <__alltraps>

c0102b56 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $99
c0102b58:	6a 63                	push   $0x63
  jmp __alltraps
c0102b5a:	e9 fc 06 00 00       	jmp    c010325b <__alltraps>

c0102b5f <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $100
c0102b61:	6a 64                	push   $0x64
  jmp __alltraps
c0102b63:	e9 f3 06 00 00       	jmp    c010325b <__alltraps>

c0102b68 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $101
c0102b6a:	6a 65                	push   $0x65
  jmp __alltraps
c0102b6c:	e9 ea 06 00 00       	jmp    c010325b <__alltraps>

c0102b71 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $102
c0102b73:	6a 66                	push   $0x66
  jmp __alltraps
c0102b75:	e9 e1 06 00 00       	jmp    c010325b <__alltraps>

c0102b7a <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $103
c0102b7c:	6a 67                	push   $0x67
  jmp __alltraps
c0102b7e:	e9 d8 06 00 00       	jmp    c010325b <__alltraps>

c0102b83 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $104
c0102b85:	6a 68                	push   $0x68
  jmp __alltraps
c0102b87:	e9 cf 06 00 00       	jmp    c010325b <__alltraps>

c0102b8c <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $105
c0102b8e:	6a 69                	push   $0x69
  jmp __alltraps
c0102b90:	e9 c6 06 00 00       	jmp    c010325b <__alltraps>

c0102b95 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $106
c0102b97:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b99:	e9 bd 06 00 00       	jmp    c010325b <__alltraps>

c0102b9e <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $107
c0102ba0:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102ba2:	e9 b4 06 00 00       	jmp    c010325b <__alltraps>

c0102ba7 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $108
c0102ba9:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bab:	e9 ab 06 00 00       	jmp    c010325b <__alltraps>

c0102bb0 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $109
c0102bb2:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102bb4:	e9 a2 06 00 00       	jmp    c010325b <__alltraps>

c0102bb9 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $110
c0102bbb:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102bbd:	e9 99 06 00 00       	jmp    c010325b <__alltraps>

c0102bc2 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $111
c0102bc4:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102bc6:	e9 90 06 00 00       	jmp    c010325b <__alltraps>

c0102bcb <vector112>:
.globl vector112
vector112:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $112
c0102bcd:	6a 70                	push   $0x70
  jmp __alltraps
c0102bcf:	e9 87 06 00 00       	jmp    c010325b <__alltraps>

c0102bd4 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $113
c0102bd6:	6a 71                	push   $0x71
  jmp __alltraps
c0102bd8:	e9 7e 06 00 00       	jmp    c010325b <__alltraps>

c0102bdd <vector114>:
.globl vector114
vector114:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $114
c0102bdf:	6a 72                	push   $0x72
  jmp __alltraps
c0102be1:	e9 75 06 00 00       	jmp    c010325b <__alltraps>

c0102be6 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $115
c0102be8:	6a 73                	push   $0x73
  jmp __alltraps
c0102bea:	e9 6c 06 00 00       	jmp    c010325b <__alltraps>

c0102bef <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $116
c0102bf1:	6a 74                	push   $0x74
  jmp __alltraps
c0102bf3:	e9 63 06 00 00       	jmp    c010325b <__alltraps>

c0102bf8 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $117
c0102bfa:	6a 75                	push   $0x75
  jmp __alltraps
c0102bfc:	e9 5a 06 00 00       	jmp    c010325b <__alltraps>

c0102c01 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $118
c0102c03:	6a 76                	push   $0x76
  jmp __alltraps
c0102c05:	e9 51 06 00 00       	jmp    c010325b <__alltraps>

c0102c0a <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $119
c0102c0c:	6a 77                	push   $0x77
  jmp __alltraps
c0102c0e:	e9 48 06 00 00       	jmp    c010325b <__alltraps>

c0102c13 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $120
c0102c15:	6a 78                	push   $0x78
  jmp __alltraps
c0102c17:	e9 3f 06 00 00       	jmp    c010325b <__alltraps>

c0102c1c <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $121
c0102c1e:	6a 79                	push   $0x79
  jmp __alltraps
c0102c20:	e9 36 06 00 00       	jmp    c010325b <__alltraps>

c0102c25 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c25:	6a 00                	push   $0x0
  pushl $122
c0102c27:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c29:	e9 2d 06 00 00       	jmp    c010325b <__alltraps>

c0102c2e <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $123
c0102c30:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c32:	e9 24 06 00 00       	jmp    c010325b <__alltraps>

c0102c37 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $124
c0102c39:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c3b:	e9 1b 06 00 00       	jmp    c010325b <__alltraps>

c0102c40 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $125
c0102c42:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c44:	e9 12 06 00 00       	jmp    c010325b <__alltraps>

c0102c49 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c49:	6a 00                	push   $0x0
  pushl $126
c0102c4b:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c4d:	e9 09 06 00 00       	jmp    c010325b <__alltraps>

c0102c52 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c52:	6a 00                	push   $0x0
  pushl $127
c0102c54:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c56:	e9 00 06 00 00       	jmp    c010325b <__alltraps>

c0102c5b <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c5b:	6a 00                	push   $0x0
  pushl $128
c0102c5d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c62:	e9 f4 05 00 00       	jmp    c010325b <__alltraps>

c0102c67 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c67:	6a 00                	push   $0x0
  pushl $129
c0102c69:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c6e:	e9 e8 05 00 00       	jmp    c010325b <__alltraps>

c0102c73 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c73:	6a 00                	push   $0x0
  pushl $130
c0102c75:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c7a:	e9 dc 05 00 00       	jmp    c010325b <__alltraps>

c0102c7f <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c7f:	6a 00                	push   $0x0
  pushl $131
c0102c81:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c86:	e9 d0 05 00 00       	jmp    c010325b <__alltraps>

c0102c8b <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c8b:	6a 00                	push   $0x0
  pushl $132
c0102c8d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c92:	e9 c4 05 00 00       	jmp    c010325b <__alltraps>

c0102c97 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c97:	6a 00                	push   $0x0
  pushl $133
c0102c99:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c9e:	e9 b8 05 00 00       	jmp    c010325b <__alltraps>

c0102ca3 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102ca3:	6a 00                	push   $0x0
  pushl $134
c0102ca5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102caa:	e9 ac 05 00 00       	jmp    c010325b <__alltraps>

c0102caf <vector135>:
.globl vector135
vector135:
  pushl $0
c0102caf:	6a 00                	push   $0x0
  pushl $135
c0102cb1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102cb6:	e9 a0 05 00 00       	jmp    c010325b <__alltraps>

c0102cbb <vector136>:
.globl vector136
vector136:
  pushl $0
c0102cbb:	6a 00                	push   $0x0
  pushl $136
c0102cbd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102cc2:	e9 94 05 00 00       	jmp    c010325b <__alltraps>

c0102cc7 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102cc7:	6a 00                	push   $0x0
  pushl $137
c0102cc9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102cce:	e9 88 05 00 00       	jmp    c010325b <__alltraps>

c0102cd3 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102cd3:	6a 00                	push   $0x0
  pushl $138
c0102cd5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102cda:	e9 7c 05 00 00       	jmp    c010325b <__alltraps>

c0102cdf <vector139>:
.globl vector139
vector139:
  pushl $0
c0102cdf:	6a 00                	push   $0x0
  pushl $139
c0102ce1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102ce6:	e9 70 05 00 00       	jmp    c010325b <__alltraps>

c0102ceb <vector140>:
.globl vector140
vector140:
  pushl $0
c0102ceb:	6a 00                	push   $0x0
  pushl $140
c0102ced:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cf2:	e9 64 05 00 00       	jmp    c010325b <__alltraps>

c0102cf7 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cf7:	6a 00                	push   $0x0
  pushl $141
c0102cf9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102cfe:	e9 58 05 00 00       	jmp    c010325b <__alltraps>

c0102d03 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d03:	6a 00                	push   $0x0
  pushl $142
c0102d05:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d0a:	e9 4c 05 00 00       	jmp    c010325b <__alltraps>

c0102d0f <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d0f:	6a 00                	push   $0x0
  pushl $143
c0102d11:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d16:	e9 40 05 00 00       	jmp    c010325b <__alltraps>

c0102d1b <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d1b:	6a 00                	push   $0x0
  pushl $144
c0102d1d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d22:	e9 34 05 00 00       	jmp    c010325b <__alltraps>

c0102d27 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d27:	6a 00                	push   $0x0
  pushl $145
c0102d29:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d2e:	e9 28 05 00 00       	jmp    c010325b <__alltraps>

c0102d33 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d33:	6a 00                	push   $0x0
  pushl $146
c0102d35:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d3a:	e9 1c 05 00 00       	jmp    c010325b <__alltraps>

c0102d3f <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d3f:	6a 00                	push   $0x0
  pushl $147
c0102d41:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d46:	e9 10 05 00 00       	jmp    c010325b <__alltraps>

c0102d4b <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d4b:	6a 00                	push   $0x0
  pushl $148
c0102d4d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d52:	e9 04 05 00 00       	jmp    c010325b <__alltraps>

c0102d57 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d57:	6a 00                	push   $0x0
  pushl $149
c0102d59:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d5e:	e9 f8 04 00 00       	jmp    c010325b <__alltraps>

c0102d63 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d63:	6a 00                	push   $0x0
  pushl $150
c0102d65:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d6a:	e9 ec 04 00 00       	jmp    c010325b <__alltraps>

c0102d6f <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d6f:	6a 00                	push   $0x0
  pushl $151
c0102d71:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d76:	e9 e0 04 00 00       	jmp    c010325b <__alltraps>

c0102d7b <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d7b:	6a 00                	push   $0x0
  pushl $152
c0102d7d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d82:	e9 d4 04 00 00       	jmp    c010325b <__alltraps>

c0102d87 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d87:	6a 00                	push   $0x0
  pushl $153
c0102d89:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d8e:	e9 c8 04 00 00       	jmp    c010325b <__alltraps>

c0102d93 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d93:	6a 00                	push   $0x0
  pushl $154
c0102d95:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d9a:	e9 bc 04 00 00       	jmp    c010325b <__alltraps>

c0102d9f <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d9f:	6a 00                	push   $0x0
  pushl $155
c0102da1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102da6:	e9 b0 04 00 00       	jmp    c010325b <__alltraps>

c0102dab <vector156>:
.globl vector156
vector156:
  pushl $0
c0102dab:	6a 00                	push   $0x0
  pushl $156
c0102dad:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102db2:	e9 a4 04 00 00       	jmp    c010325b <__alltraps>

c0102db7 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102db7:	6a 00                	push   $0x0
  pushl $157
c0102db9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102dbe:	e9 98 04 00 00       	jmp    c010325b <__alltraps>

c0102dc3 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102dc3:	6a 00                	push   $0x0
  pushl $158
c0102dc5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102dca:	e9 8c 04 00 00       	jmp    c010325b <__alltraps>

c0102dcf <vector159>:
.globl vector159
vector159:
  pushl $0
c0102dcf:	6a 00                	push   $0x0
  pushl $159
c0102dd1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102dd6:	e9 80 04 00 00       	jmp    c010325b <__alltraps>

c0102ddb <vector160>:
.globl vector160
vector160:
  pushl $0
c0102ddb:	6a 00                	push   $0x0
  pushl $160
c0102ddd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102de2:	e9 74 04 00 00       	jmp    c010325b <__alltraps>

c0102de7 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102de7:	6a 00                	push   $0x0
  pushl $161
c0102de9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102dee:	e9 68 04 00 00       	jmp    c010325b <__alltraps>

c0102df3 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102df3:	6a 00                	push   $0x0
  pushl $162
c0102df5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102dfa:	e9 5c 04 00 00       	jmp    c010325b <__alltraps>

c0102dff <vector163>:
.globl vector163
vector163:
  pushl $0
c0102dff:	6a 00                	push   $0x0
  pushl $163
c0102e01:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e06:	e9 50 04 00 00       	jmp    c010325b <__alltraps>

c0102e0b <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e0b:	6a 00                	push   $0x0
  pushl $164
c0102e0d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e12:	e9 44 04 00 00       	jmp    c010325b <__alltraps>

c0102e17 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e17:	6a 00                	push   $0x0
  pushl $165
c0102e19:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e1e:	e9 38 04 00 00       	jmp    c010325b <__alltraps>

c0102e23 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e23:	6a 00                	push   $0x0
  pushl $166
c0102e25:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e2a:	e9 2c 04 00 00       	jmp    c010325b <__alltraps>

c0102e2f <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e2f:	6a 00                	push   $0x0
  pushl $167
c0102e31:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e36:	e9 20 04 00 00       	jmp    c010325b <__alltraps>

c0102e3b <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e3b:	6a 00                	push   $0x0
  pushl $168
c0102e3d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e42:	e9 14 04 00 00       	jmp    c010325b <__alltraps>

c0102e47 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e47:	6a 00                	push   $0x0
  pushl $169
c0102e49:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e4e:	e9 08 04 00 00       	jmp    c010325b <__alltraps>

c0102e53 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e53:	6a 00                	push   $0x0
  pushl $170
c0102e55:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e5a:	e9 fc 03 00 00       	jmp    c010325b <__alltraps>

c0102e5f <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e5f:	6a 00                	push   $0x0
  pushl $171
c0102e61:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e66:	e9 f0 03 00 00       	jmp    c010325b <__alltraps>

c0102e6b <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e6b:	6a 00                	push   $0x0
  pushl $172
c0102e6d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e72:	e9 e4 03 00 00       	jmp    c010325b <__alltraps>

c0102e77 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e77:	6a 00                	push   $0x0
  pushl $173
c0102e79:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e7e:	e9 d8 03 00 00       	jmp    c010325b <__alltraps>

c0102e83 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e83:	6a 00                	push   $0x0
  pushl $174
c0102e85:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e8a:	e9 cc 03 00 00       	jmp    c010325b <__alltraps>

c0102e8f <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e8f:	6a 00                	push   $0x0
  pushl $175
c0102e91:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e96:	e9 c0 03 00 00       	jmp    c010325b <__alltraps>

c0102e9b <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e9b:	6a 00                	push   $0x0
  pushl $176
c0102e9d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102ea2:	e9 b4 03 00 00       	jmp    c010325b <__alltraps>

c0102ea7 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102ea7:	6a 00                	push   $0x0
  pushl $177
c0102ea9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102eae:	e9 a8 03 00 00       	jmp    c010325b <__alltraps>

c0102eb3 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102eb3:	6a 00                	push   $0x0
  pushl $178
c0102eb5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102eba:	e9 9c 03 00 00       	jmp    c010325b <__alltraps>

c0102ebf <vector179>:
.globl vector179
vector179:
  pushl $0
c0102ebf:	6a 00                	push   $0x0
  pushl $179
c0102ec1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102ec6:	e9 90 03 00 00       	jmp    c010325b <__alltraps>

c0102ecb <vector180>:
.globl vector180
vector180:
  pushl $0
c0102ecb:	6a 00                	push   $0x0
  pushl $180
c0102ecd:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102ed2:	e9 84 03 00 00       	jmp    c010325b <__alltraps>

c0102ed7 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102ed7:	6a 00                	push   $0x0
  pushl $181
c0102ed9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ede:	e9 78 03 00 00       	jmp    c010325b <__alltraps>

c0102ee3 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ee3:	6a 00                	push   $0x0
  pushl $182
c0102ee5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102eea:	e9 6c 03 00 00       	jmp    c010325b <__alltraps>

c0102eef <vector183>:
.globl vector183
vector183:
  pushl $0
c0102eef:	6a 00                	push   $0x0
  pushl $183
c0102ef1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102ef6:	e9 60 03 00 00       	jmp    c010325b <__alltraps>

c0102efb <vector184>:
.globl vector184
vector184:
  pushl $0
c0102efb:	6a 00                	push   $0x0
  pushl $184
c0102efd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f02:	e9 54 03 00 00       	jmp    c010325b <__alltraps>

c0102f07 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f07:	6a 00                	push   $0x0
  pushl $185
c0102f09:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f0e:	e9 48 03 00 00       	jmp    c010325b <__alltraps>

c0102f13 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f13:	6a 00                	push   $0x0
  pushl $186
c0102f15:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f1a:	e9 3c 03 00 00       	jmp    c010325b <__alltraps>

c0102f1f <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f1f:	6a 00                	push   $0x0
  pushl $187
c0102f21:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f26:	e9 30 03 00 00       	jmp    c010325b <__alltraps>

c0102f2b <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f2b:	6a 00                	push   $0x0
  pushl $188
c0102f2d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f32:	e9 24 03 00 00       	jmp    c010325b <__alltraps>

c0102f37 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f37:	6a 00                	push   $0x0
  pushl $189
c0102f39:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f3e:	e9 18 03 00 00       	jmp    c010325b <__alltraps>

c0102f43 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f43:	6a 00                	push   $0x0
  pushl $190
c0102f45:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f4a:	e9 0c 03 00 00       	jmp    c010325b <__alltraps>

c0102f4f <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f4f:	6a 00                	push   $0x0
  pushl $191
c0102f51:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f56:	e9 00 03 00 00       	jmp    c010325b <__alltraps>

c0102f5b <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f5b:	6a 00                	push   $0x0
  pushl $192
c0102f5d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f62:	e9 f4 02 00 00       	jmp    c010325b <__alltraps>

c0102f67 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f67:	6a 00                	push   $0x0
  pushl $193
c0102f69:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f6e:	e9 e8 02 00 00       	jmp    c010325b <__alltraps>

c0102f73 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f73:	6a 00                	push   $0x0
  pushl $194
c0102f75:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f7a:	e9 dc 02 00 00       	jmp    c010325b <__alltraps>

c0102f7f <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f7f:	6a 00                	push   $0x0
  pushl $195
c0102f81:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f86:	e9 d0 02 00 00       	jmp    c010325b <__alltraps>

c0102f8b <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f8b:	6a 00                	push   $0x0
  pushl $196
c0102f8d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f92:	e9 c4 02 00 00       	jmp    c010325b <__alltraps>

c0102f97 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f97:	6a 00                	push   $0x0
  pushl $197
c0102f99:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f9e:	e9 b8 02 00 00       	jmp    c010325b <__alltraps>

c0102fa3 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fa3:	6a 00                	push   $0x0
  pushl $198
c0102fa5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102faa:	e9 ac 02 00 00       	jmp    c010325b <__alltraps>

c0102faf <vector199>:
.globl vector199
vector199:
  pushl $0
c0102faf:	6a 00                	push   $0x0
  pushl $199
c0102fb1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102fb6:	e9 a0 02 00 00       	jmp    c010325b <__alltraps>

c0102fbb <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fbb:	6a 00                	push   $0x0
  pushl $200
c0102fbd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102fc2:	e9 94 02 00 00       	jmp    c010325b <__alltraps>

c0102fc7 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102fc7:	6a 00                	push   $0x0
  pushl $201
c0102fc9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102fce:	e9 88 02 00 00       	jmp    c010325b <__alltraps>

c0102fd3 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102fd3:	6a 00                	push   $0x0
  pushl $202
c0102fd5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102fda:	e9 7c 02 00 00       	jmp    c010325b <__alltraps>

c0102fdf <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fdf:	6a 00                	push   $0x0
  pushl $203
c0102fe1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fe6:	e9 70 02 00 00       	jmp    c010325b <__alltraps>

c0102feb <vector204>:
.globl vector204
vector204:
  pushl $0
c0102feb:	6a 00                	push   $0x0
  pushl $204
c0102fed:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102ff2:	e9 64 02 00 00       	jmp    c010325b <__alltraps>

c0102ff7 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102ff7:	6a 00                	push   $0x0
  pushl $205
c0102ff9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102ffe:	e9 58 02 00 00       	jmp    c010325b <__alltraps>

c0103003 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103003:	6a 00                	push   $0x0
  pushl $206
c0103005:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010300a:	e9 4c 02 00 00       	jmp    c010325b <__alltraps>

c010300f <vector207>:
.globl vector207
vector207:
  pushl $0
c010300f:	6a 00                	push   $0x0
  pushl $207
c0103011:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103016:	e9 40 02 00 00       	jmp    c010325b <__alltraps>

c010301b <vector208>:
.globl vector208
vector208:
  pushl $0
c010301b:	6a 00                	push   $0x0
  pushl $208
c010301d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103022:	e9 34 02 00 00       	jmp    c010325b <__alltraps>

c0103027 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103027:	6a 00                	push   $0x0
  pushl $209
c0103029:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010302e:	e9 28 02 00 00       	jmp    c010325b <__alltraps>

c0103033 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103033:	6a 00                	push   $0x0
  pushl $210
c0103035:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010303a:	e9 1c 02 00 00       	jmp    c010325b <__alltraps>

c010303f <vector211>:
.globl vector211
vector211:
  pushl $0
c010303f:	6a 00                	push   $0x0
  pushl $211
c0103041:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103046:	e9 10 02 00 00       	jmp    c010325b <__alltraps>

c010304b <vector212>:
.globl vector212
vector212:
  pushl $0
c010304b:	6a 00                	push   $0x0
  pushl $212
c010304d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103052:	e9 04 02 00 00       	jmp    c010325b <__alltraps>

c0103057 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103057:	6a 00                	push   $0x0
  pushl $213
c0103059:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010305e:	e9 f8 01 00 00       	jmp    c010325b <__alltraps>

c0103063 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103063:	6a 00                	push   $0x0
  pushl $214
c0103065:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010306a:	e9 ec 01 00 00       	jmp    c010325b <__alltraps>

c010306f <vector215>:
.globl vector215
vector215:
  pushl $0
c010306f:	6a 00                	push   $0x0
  pushl $215
c0103071:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103076:	e9 e0 01 00 00       	jmp    c010325b <__alltraps>

c010307b <vector216>:
.globl vector216
vector216:
  pushl $0
c010307b:	6a 00                	push   $0x0
  pushl $216
c010307d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103082:	e9 d4 01 00 00       	jmp    c010325b <__alltraps>

c0103087 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103087:	6a 00                	push   $0x0
  pushl $217
c0103089:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010308e:	e9 c8 01 00 00       	jmp    c010325b <__alltraps>

c0103093 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103093:	6a 00                	push   $0x0
  pushl $218
c0103095:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010309a:	e9 bc 01 00 00       	jmp    c010325b <__alltraps>

c010309f <vector219>:
.globl vector219
vector219:
  pushl $0
c010309f:	6a 00                	push   $0x0
  pushl $219
c01030a1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030a6:	e9 b0 01 00 00       	jmp    c010325b <__alltraps>

c01030ab <vector220>:
.globl vector220
vector220:
  pushl $0
c01030ab:	6a 00                	push   $0x0
  pushl $220
c01030ad:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030b2:	e9 a4 01 00 00       	jmp    c010325b <__alltraps>

c01030b7 <vector221>:
.globl vector221
vector221:
  pushl $0
c01030b7:	6a 00                	push   $0x0
  pushl $221
c01030b9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030be:	e9 98 01 00 00       	jmp    c010325b <__alltraps>

c01030c3 <vector222>:
.globl vector222
vector222:
  pushl $0
c01030c3:	6a 00                	push   $0x0
  pushl $222
c01030c5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030ca:	e9 8c 01 00 00       	jmp    c010325b <__alltraps>

c01030cf <vector223>:
.globl vector223
vector223:
  pushl $0
c01030cf:	6a 00                	push   $0x0
  pushl $223
c01030d1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01030d6:	e9 80 01 00 00       	jmp    c010325b <__alltraps>

c01030db <vector224>:
.globl vector224
vector224:
  pushl $0
c01030db:	6a 00                	push   $0x0
  pushl $224
c01030dd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030e2:	e9 74 01 00 00       	jmp    c010325b <__alltraps>

c01030e7 <vector225>:
.globl vector225
vector225:
  pushl $0
c01030e7:	6a 00                	push   $0x0
  pushl $225
c01030e9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030ee:	e9 68 01 00 00       	jmp    c010325b <__alltraps>

c01030f3 <vector226>:
.globl vector226
vector226:
  pushl $0
c01030f3:	6a 00                	push   $0x0
  pushl $226
c01030f5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030fa:	e9 5c 01 00 00       	jmp    c010325b <__alltraps>

c01030ff <vector227>:
.globl vector227
vector227:
  pushl $0
c01030ff:	6a 00                	push   $0x0
  pushl $227
c0103101:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103106:	e9 50 01 00 00       	jmp    c010325b <__alltraps>

c010310b <vector228>:
.globl vector228
vector228:
  pushl $0
c010310b:	6a 00                	push   $0x0
  pushl $228
c010310d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103112:	e9 44 01 00 00       	jmp    c010325b <__alltraps>

c0103117 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103117:	6a 00                	push   $0x0
  pushl $229
c0103119:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010311e:	e9 38 01 00 00       	jmp    c010325b <__alltraps>

c0103123 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103123:	6a 00                	push   $0x0
  pushl $230
c0103125:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010312a:	e9 2c 01 00 00       	jmp    c010325b <__alltraps>

c010312f <vector231>:
.globl vector231
vector231:
  pushl $0
c010312f:	6a 00                	push   $0x0
  pushl $231
c0103131:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103136:	e9 20 01 00 00       	jmp    c010325b <__alltraps>

c010313b <vector232>:
.globl vector232
vector232:
  pushl $0
c010313b:	6a 00                	push   $0x0
  pushl $232
c010313d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103142:	e9 14 01 00 00       	jmp    c010325b <__alltraps>

c0103147 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103147:	6a 00                	push   $0x0
  pushl $233
c0103149:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010314e:	e9 08 01 00 00       	jmp    c010325b <__alltraps>

c0103153 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103153:	6a 00                	push   $0x0
  pushl $234
c0103155:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010315a:	e9 fc 00 00 00       	jmp    c010325b <__alltraps>

c010315f <vector235>:
.globl vector235
vector235:
  pushl $0
c010315f:	6a 00                	push   $0x0
  pushl $235
c0103161:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103166:	e9 f0 00 00 00       	jmp    c010325b <__alltraps>

c010316b <vector236>:
.globl vector236
vector236:
  pushl $0
c010316b:	6a 00                	push   $0x0
  pushl $236
c010316d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103172:	e9 e4 00 00 00       	jmp    c010325b <__alltraps>

c0103177 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103177:	6a 00                	push   $0x0
  pushl $237
c0103179:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010317e:	e9 d8 00 00 00       	jmp    c010325b <__alltraps>

c0103183 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103183:	6a 00                	push   $0x0
  pushl $238
c0103185:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010318a:	e9 cc 00 00 00       	jmp    c010325b <__alltraps>

c010318f <vector239>:
.globl vector239
vector239:
  pushl $0
c010318f:	6a 00                	push   $0x0
  pushl $239
c0103191:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103196:	e9 c0 00 00 00       	jmp    c010325b <__alltraps>

c010319b <vector240>:
.globl vector240
vector240:
  pushl $0
c010319b:	6a 00                	push   $0x0
  pushl $240
c010319d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031a2:	e9 b4 00 00 00       	jmp    c010325b <__alltraps>

c01031a7 <vector241>:
.globl vector241
vector241:
  pushl $0
c01031a7:	6a 00                	push   $0x0
  pushl $241
c01031a9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031ae:	e9 a8 00 00 00       	jmp    c010325b <__alltraps>

c01031b3 <vector242>:
.globl vector242
vector242:
  pushl $0
c01031b3:	6a 00                	push   $0x0
  pushl $242
c01031b5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031ba:	e9 9c 00 00 00       	jmp    c010325b <__alltraps>

c01031bf <vector243>:
.globl vector243
vector243:
  pushl $0
c01031bf:	6a 00                	push   $0x0
  pushl $243
c01031c1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031c6:	e9 90 00 00 00       	jmp    c010325b <__alltraps>

c01031cb <vector244>:
.globl vector244
vector244:
  pushl $0
c01031cb:	6a 00                	push   $0x0
  pushl $244
c01031cd:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01031d2:	e9 84 00 00 00       	jmp    c010325b <__alltraps>

c01031d7 <vector245>:
.globl vector245
vector245:
  pushl $0
c01031d7:	6a 00                	push   $0x0
  pushl $245
c01031d9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031de:	e9 78 00 00 00       	jmp    c010325b <__alltraps>

c01031e3 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031e3:	6a 00                	push   $0x0
  pushl $246
c01031e5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031ea:	e9 6c 00 00 00       	jmp    c010325b <__alltraps>

c01031ef <vector247>:
.globl vector247
vector247:
  pushl $0
c01031ef:	6a 00                	push   $0x0
  pushl $247
c01031f1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031f6:	e9 60 00 00 00       	jmp    c010325b <__alltraps>

c01031fb <vector248>:
.globl vector248
vector248:
  pushl $0
c01031fb:	6a 00                	push   $0x0
  pushl $248
c01031fd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103202:	e9 54 00 00 00       	jmp    c010325b <__alltraps>

c0103207 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103207:	6a 00                	push   $0x0
  pushl $249
c0103209:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010320e:	e9 48 00 00 00       	jmp    c010325b <__alltraps>

c0103213 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103213:	6a 00                	push   $0x0
  pushl $250
c0103215:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010321a:	e9 3c 00 00 00       	jmp    c010325b <__alltraps>

c010321f <vector251>:
.globl vector251
vector251:
  pushl $0
c010321f:	6a 00                	push   $0x0
  pushl $251
c0103221:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103226:	e9 30 00 00 00       	jmp    c010325b <__alltraps>

c010322b <vector252>:
.globl vector252
vector252:
  pushl $0
c010322b:	6a 00                	push   $0x0
  pushl $252
c010322d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103232:	e9 24 00 00 00       	jmp    c010325b <__alltraps>

c0103237 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103237:	6a 00                	push   $0x0
  pushl $253
c0103239:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010323e:	e9 18 00 00 00       	jmp    c010325b <__alltraps>

c0103243 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103243:	6a 00                	push   $0x0
  pushl $254
c0103245:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010324a:	e9 0c 00 00 00       	jmp    c010325b <__alltraps>

c010324f <vector255>:
.globl vector255
vector255:
  pushl $0
c010324f:	6a 00                	push   $0x0
  pushl $255
c0103251:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103256:	e9 00 00 00 00       	jmp    c010325b <__alltraps>

c010325b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010325b:	1e                   	push   %ds
    pushl %es
c010325c:	06                   	push   %es
    pushl %fs
c010325d:	0f a0                	push   %fs
    pushl %gs
c010325f:	0f a8                	push   %gs
    pushal
c0103261:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0103262:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0103267:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0103269:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010326b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010326c:	e8 63 f5 ff ff       	call   c01027d4 <trap>

    # pop the pushed stack pointer
    popl %esp
c0103271:	5c                   	pop    %esp

c0103272 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0103272:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0103273:	0f a9                	pop    %gs
    popl %fs
c0103275:	0f a1                	pop    %fs
    popl %es
c0103277:	07                   	pop    %es
    popl %ds
c0103278:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0103279:	83 c4 08             	add    $0x8,%esp
    iret
c010327c:	cf                   	iret   

c010327d <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c010327d:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0103281:	eb ef                	jmp    c0103272 <__trapret>

c0103283 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103283:	55                   	push   %ebp
c0103284:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103286:	8b 45 08             	mov    0x8(%ebp),%eax
c0103289:	8b 15 20 9b 12 c0    	mov    0xc0129b20,%edx
c010328f:	29 d0                	sub    %edx,%eax
c0103291:	c1 f8 05             	sar    $0x5,%eax
}
c0103294:	5d                   	pop    %ebp
c0103295:	c3                   	ret    

c0103296 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103296:	55                   	push   %ebp
c0103297:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0103299:	ff 75 08             	pushl  0x8(%ebp)
c010329c:	e8 e2 ff ff ff       	call   c0103283 <page2ppn>
c01032a1:	83 c4 04             	add    $0x4,%esp
c01032a4:	c1 e0 0c             	shl    $0xc,%eax
}
c01032a7:	c9                   	leave  
c01032a8:	c3                   	ret    

c01032a9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01032a9:	55                   	push   %ebp
c01032aa:	89 e5                	mov    %esp,%ebp
c01032ac:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01032af:	8b 45 08             	mov    0x8(%ebp),%eax
c01032b2:	c1 e8 0c             	shr    $0xc,%eax
c01032b5:	89 c2                	mov    %eax,%edx
c01032b7:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c01032bc:	39 c2                	cmp    %eax,%edx
c01032be:	72 14                	jb     c01032d4 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01032c0:	83 ec 04             	sub    $0x4,%esp
c01032c3:	68 90 a7 10 c0       	push   $0xc010a790
c01032c8:	6a 5f                	push   $0x5f
c01032ca:	68 af a7 10 c0       	push   $0xc010a7af
c01032cf:	e8 10 d1 ff ff       	call   c01003e4 <__panic>
    }
    return &pages[PPN(pa)];
c01032d4:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c01032d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01032dc:	c1 ea 0c             	shr    $0xc,%edx
c01032df:	c1 e2 05             	shl    $0x5,%edx
c01032e2:	01 d0                	add    %edx,%eax
}
c01032e4:	c9                   	leave  
c01032e5:	c3                   	ret    

c01032e6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01032e6:	55                   	push   %ebp
c01032e7:	89 e5                	mov    %esp,%ebp
c01032e9:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01032ec:	ff 75 08             	pushl  0x8(%ebp)
c01032ef:	e8 a2 ff ff ff       	call   c0103296 <page2pa>
c01032f4:	83 c4 04             	add    $0x4,%esp
c01032f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032fd:	c1 e8 0c             	shr    $0xc,%eax
c0103300:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103303:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0103308:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010330b:	72 14                	jb     c0103321 <page2kva+0x3b>
c010330d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103310:	68 c0 a7 10 c0       	push   $0xc010a7c0
c0103315:	6a 66                	push   $0x66
c0103317:	68 af a7 10 c0       	push   $0xc010a7af
c010331c:	e8 c3 d0 ff ff       	call   c01003e4 <__panic>
c0103321:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103324:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103329:	c9                   	leave  
c010332a:	c3                   	ret    

c010332b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010332b:	55                   	push   %ebp
c010332c:	89 e5                	mov    %esp,%ebp
c010332e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0103331:	8b 45 08             	mov    0x8(%ebp),%eax
c0103334:	83 e0 01             	and    $0x1,%eax
c0103337:	85 c0                	test   %eax,%eax
c0103339:	75 14                	jne    c010334f <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010333b:	83 ec 04             	sub    $0x4,%esp
c010333e:	68 e4 a7 10 c0       	push   $0xc010a7e4
c0103343:	6a 71                	push   $0x71
c0103345:	68 af a7 10 c0       	push   $0xc010a7af
c010334a:	e8 95 d0 ff ff       	call   c01003e4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010334f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103352:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103357:	83 ec 0c             	sub    $0xc,%esp
c010335a:	50                   	push   %eax
c010335b:	e8 49 ff ff ff       	call   c01032a9 <pa2page>
c0103360:	83 c4 10             	add    $0x10,%esp
}
c0103363:	c9                   	leave  
c0103364:	c3                   	ret    

c0103365 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103365:	55                   	push   %ebp
c0103366:	89 e5                	mov    %esp,%ebp
c0103368:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010336b:	8b 45 08             	mov    0x8(%ebp),%eax
c010336e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103373:	83 ec 0c             	sub    $0xc,%esp
c0103376:	50                   	push   %eax
c0103377:	e8 2d ff ff ff       	call   c01032a9 <pa2page>
c010337c:	83 c4 10             	add    $0x10,%esp
}
c010337f:	c9                   	leave  
c0103380:	c3                   	ret    

c0103381 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103381:	55                   	push   %ebp
c0103382:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103384:	8b 45 08             	mov    0x8(%ebp),%eax
c0103387:	8b 00                	mov    (%eax),%eax
}
c0103389:	5d                   	pop    %ebp
c010338a:	c3                   	ret    

c010338b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010338b:	55                   	push   %ebp
c010338c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010338e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103391:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103394:	89 10                	mov    %edx,(%eax)
}
c0103396:	90                   	nop
c0103397:	5d                   	pop    %ebp
c0103398:	c3                   	ret    

c0103399 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103399:	55                   	push   %ebp
c010339a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010339c:	8b 45 08             	mov    0x8(%ebp),%eax
c010339f:	8b 00                	mov    (%eax),%eax
c01033a1:	8d 50 01             	lea    0x1(%eax),%edx
c01033a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01033a7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01033a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01033ac:	8b 00                	mov    (%eax),%eax
}
c01033ae:	5d                   	pop    %ebp
c01033af:	c3                   	ret    

c01033b0 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01033b0:	55                   	push   %ebp
c01033b1:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01033b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b6:	8b 00                	mov    (%eax),%eax
c01033b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01033bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01033be:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01033c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01033c3:	8b 00                	mov    (%eax),%eax
}
c01033c5:	5d                   	pop    %ebp
c01033c6:	c3                   	ret    

c01033c7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01033c7:	55                   	push   %ebp
c01033c8:	89 e5                	mov    %esp,%ebp
c01033ca:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01033cd:	9c                   	pushf  
c01033ce:	58                   	pop    %eax
c01033cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01033d5:	25 00 02 00 00       	and    $0x200,%eax
c01033da:	85 c0                	test   %eax,%eax
c01033dc:	74 0c                	je     c01033ea <__intr_save+0x23>
        intr_disable();
c01033de:	e8 c7 ec ff ff       	call   c01020aa <intr_disable>
        return 1;
c01033e3:	b8 01 00 00 00       	mov    $0x1,%eax
c01033e8:	eb 05                	jmp    c01033ef <__intr_save+0x28>
    }
    return 0;
c01033ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01033ef:	c9                   	leave  
c01033f0:	c3                   	ret    

c01033f1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01033f1:	55                   	push   %ebp
c01033f2:	89 e5                	mov    %esp,%ebp
c01033f4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01033f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033fb:	74 05                	je     c0103402 <__intr_restore+0x11>
        intr_enable();
c01033fd:	e8 a1 ec ff ff       	call   c01020a3 <intr_enable>
    }
}
c0103402:	90                   	nop
c0103403:	c9                   	leave  
c0103404:	c3                   	ret    

c0103405 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103405:	55                   	push   %ebp
c0103406:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103408:	8b 45 08             	mov    0x8(%ebp),%eax
c010340b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010340e:	b8 23 00 00 00       	mov    $0x23,%eax
c0103413:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103415:	b8 23 00 00 00       	mov    $0x23,%eax
c010341a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c010341c:	b8 10 00 00 00       	mov    $0x10,%eax
c0103421:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103423:	b8 10 00 00 00       	mov    $0x10,%eax
c0103428:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c010342a:	b8 10 00 00 00       	mov    $0x10,%eax
c010342f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103431:	ea 38 34 10 c0 08 00 	ljmp   $0x8,$0xc0103438
}
c0103438:	90                   	nop
c0103439:	5d                   	pop    %ebp
c010343a:	c3                   	ret    

c010343b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c010343b:	55                   	push   %ebp
c010343c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c010343e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103441:	a3 64 7a 12 c0       	mov    %eax,0xc0127a64
}
c0103446:	90                   	nop
c0103447:	5d                   	pop    %ebp
c0103448:	c3                   	ret    

c0103449 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103449:	55                   	push   %ebp
c010344a:	89 e5                	mov    %esp,%ebp
c010344c:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010344f:	b8 00 60 12 c0       	mov    $0xc0126000,%eax
c0103454:	50                   	push   %eax
c0103455:	e8 e1 ff ff ff       	call   c010343b <load_esp0>
c010345a:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c010345d:	66 c7 05 68 7a 12 c0 	movw   $0x10,0xc0127a68
c0103464:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103466:	66 c7 05 28 6a 12 c0 	movw   $0x68,0xc0126a28
c010346d:	68 00 
c010346f:	b8 60 7a 12 c0       	mov    $0xc0127a60,%eax
c0103474:	66 a3 2a 6a 12 c0    	mov    %ax,0xc0126a2a
c010347a:	b8 60 7a 12 c0       	mov    $0xc0127a60,%eax
c010347f:	c1 e8 10             	shr    $0x10,%eax
c0103482:	a2 2c 6a 12 c0       	mov    %al,0xc0126a2c
c0103487:	0f b6 05 2d 6a 12 c0 	movzbl 0xc0126a2d,%eax
c010348e:	83 e0 f0             	and    $0xfffffff0,%eax
c0103491:	83 c8 09             	or     $0x9,%eax
c0103494:	a2 2d 6a 12 c0       	mov    %al,0xc0126a2d
c0103499:	0f b6 05 2d 6a 12 c0 	movzbl 0xc0126a2d,%eax
c01034a0:	83 e0 ef             	and    $0xffffffef,%eax
c01034a3:	a2 2d 6a 12 c0       	mov    %al,0xc0126a2d
c01034a8:	0f b6 05 2d 6a 12 c0 	movzbl 0xc0126a2d,%eax
c01034af:	83 e0 9f             	and    $0xffffff9f,%eax
c01034b2:	a2 2d 6a 12 c0       	mov    %al,0xc0126a2d
c01034b7:	0f b6 05 2d 6a 12 c0 	movzbl 0xc0126a2d,%eax
c01034be:	83 c8 80             	or     $0xffffff80,%eax
c01034c1:	a2 2d 6a 12 c0       	mov    %al,0xc0126a2d
c01034c6:	0f b6 05 2e 6a 12 c0 	movzbl 0xc0126a2e,%eax
c01034cd:	83 e0 f0             	and    $0xfffffff0,%eax
c01034d0:	a2 2e 6a 12 c0       	mov    %al,0xc0126a2e
c01034d5:	0f b6 05 2e 6a 12 c0 	movzbl 0xc0126a2e,%eax
c01034dc:	83 e0 ef             	and    $0xffffffef,%eax
c01034df:	a2 2e 6a 12 c0       	mov    %al,0xc0126a2e
c01034e4:	0f b6 05 2e 6a 12 c0 	movzbl 0xc0126a2e,%eax
c01034eb:	83 e0 df             	and    $0xffffffdf,%eax
c01034ee:	a2 2e 6a 12 c0       	mov    %al,0xc0126a2e
c01034f3:	0f b6 05 2e 6a 12 c0 	movzbl 0xc0126a2e,%eax
c01034fa:	83 c8 40             	or     $0x40,%eax
c01034fd:	a2 2e 6a 12 c0       	mov    %al,0xc0126a2e
c0103502:	0f b6 05 2e 6a 12 c0 	movzbl 0xc0126a2e,%eax
c0103509:	83 e0 7f             	and    $0x7f,%eax
c010350c:	a2 2e 6a 12 c0       	mov    %al,0xc0126a2e
c0103511:	b8 60 7a 12 c0       	mov    $0xc0127a60,%eax
c0103516:	c1 e8 18             	shr    $0x18,%eax
c0103519:	a2 2f 6a 12 c0       	mov    %al,0xc0126a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c010351e:	68 30 6a 12 c0       	push   $0xc0126a30
c0103523:	e8 dd fe ff ff       	call   c0103405 <lgdt>
c0103528:	83 c4 04             	add    $0x4,%esp
c010352b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103531:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103535:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103538:	90                   	nop
c0103539:	c9                   	leave  
c010353a:	c3                   	ret    

c010353b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010353b:	55                   	push   %ebp
c010353c:	89 e5                	mov    %esp,%ebp
c010353e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0103541:	c7 05 18 9b 12 c0 e4 	movl   $0xc010bce4,0xc0129b18
c0103548:	bc 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010354b:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c0103550:	8b 00                	mov    (%eax),%eax
c0103552:	83 ec 08             	sub    $0x8,%esp
c0103555:	50                   	push   %eax
c0103556:	68 10 a8 10 c0       	push   $0xc010a810
c010355b:	e8 1e cd ff ff       	call   c010027e <cprintf>
c0103560:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0103563:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c0103568:	8b 40 04             	mov    0x4(%eax),%eax
c010356b:	ff d0                	call   *%eax
}
c010356d:	90                   	nop
c010356e:	c9                   	leave  
c010356f:	c3                   	ret    

c0103570 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103570:	55                   	push   %ebp
c0103571:	89 e5                	mov    %esp,%ebp
c0103573:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0103576:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c010357b:	8b 40 08             	mov    0x8(%eax),%eax
c010357e:	83 ec 08             	sub    $0x8,%esp
c0103581:	ff 75 0c             	pushl  0xc(%ebp)
c0103584:	ff 75 08             	pushl  0x8(%ebp)
c0103587:	ff d0                	call   *%eax
c0103589:	83 c4 10             	add    $0x10,%esp
}
c010358c:	90                   	nop
c010358d:	c9                   	leave  
c010358e:	c3                   	ret    

c010358f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010358f:	55                   	push   %ebp
c0103590:	89 e5                	mov    %esp,%ebp
c0103592:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0103595:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010359c:	e8 26 fe ff ff       	call   c01033c7 <__intr_save>
c01035a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c01035a4:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c01035a9:	8b 40 0c             	mov    0xc(%eax),%eax
c01035ac:	83 ec 0c             	sub    $0xc,%esp
c01035af:	ff 75 08             	pushl  0x8(%ebp)
c01035b2:	ff d0                	call   *%eax
c01035b4:	83 c4 10             	add    $0x10,%esp
c01035b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01035ba:	83 ec 0c             	sub    $0xc,%esp
c01035bd:	ff 75 f0             	pushl  -0x10(%ebp)
c01035c0:	e8 2c fe ff ff       	call   c01033f1 <__intr_restore>
c01035c5:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01035c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035cc:	75 28                	jne    c01035f6 <alloc_pages+0x67>
c01035ce:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01035d2:	77 22                	ja     c01035f6 <alloc_pages+0x67>
c01035d4:	a1 d0 7a 12 c0       	mov    0xc0127ad0,%eax
c01035d9:	85 c0                	test   %eax,%eax
c01035db:	74 19                	je     c01035f6 <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01035dd:	8b 55 08             	mov    0x8(%ebp),%edx
c01035e0:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c01035e5:	83 ec 04             	sub    $0x4,%esp
c01035e8:	6a 00                	push   $0x0
c01035ea:	52                   	push   %edx
c01035eb:	50                   	push   %eax
c01035ec:	e8 92 22 00 00       	call   c0105883 <swap_out>
c01035f1:	83 c4 10             	add    $0x10,%esp
    }
c01035f4:	eb a6                	jmp    c010359c <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01035f9:	c9                   	leave  
c01035fa:	c3                   	ret    

c01035fb <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01035fb:	55                   	push   %ebp
c01035fc:	89 e5                	mov    %esp,%ebp
c01035fe:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103601:	e8 c1 fd ff ff       	call   c01033c7 <__intr_save>
c0103606:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103609:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c010360e:	8b 40 10             	mov    0x10(%eax),%eax
c0103611:	83 ec 08             	sub    $0x8,%esp
c0103614:	ff 75 0c             	pushl  0xc(%ebp)
c0103617:	ff 75 08             	pushl  0x8(%ebp)
c010361a:	ff d0                	call   *%eax
c010361c:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010361f:	83 ec 0c             	sub    $0xc,%esp
c0103622:	ff 75 f4             	pushl  -0xc(%ebp)
c0103625:	e8 c7 fd ff ff       	call   c01033f1 <__intr_restore>
c010362a:	83 c4 10             	add    $0x10,%esp
}
c010362d:	90                   	nop
c010362e:	c9                   	leave  
c010362f:	c3                   	ret    

c0103630 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103630:	55                   	push   %ebp
c0103631:	89 e5                	mov    %esp,%ebp
c0103633:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103636:	e8 8c fd ff ff       	call   c01033c7 <__intr_save>
c010363b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010363e:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c0103643:	8b 40 14             	mov    0x14(%eax),%eax
c0103646:	ff d0                	call   *%eax
c0103648:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010364b:	83 ec 0c             	sub    $0xc,%esp
c010364e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103651:	e8 9b fd ff ff       	call   c01033f1 <__intr_restore>
c0103656:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010365c:	c9                   	leave  
c010365d:	c3                   	ret    

c010365e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010365e:	55                   	push   %ebp
c010365f:	89 e5                	mov    %esp,%ebp
c0103661:	57                   	push   %edi
c0103662:	56                   	push   %esi
c0103663:	53                   	push   %ebx
c0103664:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103667:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010366e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010367c:	83 ec 0c             	sub    $0xc,%esp
c010367f:	68 27 a8 10 c0       	push   $0xc010a827
c0103684:	e8 f5 cb ff ff       	call   c010027e <cprintf>
c0103689:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010368c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103693:	e9 fc 00 00 00       	jmp    c0103794 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103698:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010369b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010369e:	89 d0                	mov    %edx,%eax
c01036a0:	c1 e0 02             	shl    $0x2,%eax
c01036a3:	01 d0                	add    %edx,%eax
c01036a5:	c1 e0 02             	shl    $0x2,%eax
c01036a8:	01 c8                	add    %ecx,%eax
c01036aa:	8b 50 08             	mov    0x8(%eax),%edx
c01036ad:	8b 40 04             	mov    0x4(%eax),%eax
c01036b0:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01036b3:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01036b6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01036b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01036bc:	89 d0                	mov    %edx,%eax
c01036be:	c1 e0 02             	shl    $0x2,%eax
c01036c1:	01 d0                	add    %edx,%eax
c01036c3:	c1 e0 02             	shl    $0x2,%eax
c01036c6:	01 c8                	add    %ecx,%eax
c01036c8:	8b 48 0c             	mov    0xc(%eax),%ecx
c01036cb:	8b 58 10             	mov    0x10(%eax),%ebx
c01036ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036d1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01036d4:	01 c8                	add    %ecx,%eax
c01036d6:	11 da                	adc    %ebx,%edx
c01036d8:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01036db:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01036de:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01036e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01036e4:	89 d0                	mov    %edx,%eax
c01036e6:	c1 e0 02             	shl    $0x2,%eax
c01036e9:	01 d0                	add    %edx,%eax
c01036eb:	c1 e0 02             	shl    $0x2,%eax
c01036ee:	01 c8                	add    %ecx,%eax
c01036f0:	83 c0 14             	add    $0x14,%eax
c01036f3:	8b 00                	mov    (%eax),%eax
c01036f5:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01036f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036fb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01036fe:	83 c0 ff             	add    $0xffffffff,%eax
c0103701:	83 d2 ff             	adc    $0xffffffff,%edx
c0103704:	89 c1                	mov    %eax,%ecx
c0103706:	89 d3                	mov    %edx,%ebx
c0103708:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010370b:	89 55 80             	mov    %edx,-0x80(%ebp)
c010370e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103711:	89 d0                	mov    %edx,%eax
c0103713:	c1 e0 02             	shl    $0x2,%eax
c0103716:	01 d0                	add    %edx,%eax
c0103718:	c1 e0 02             	shl    $0x2,%eax
c010371b:	03 45 80             	add    -0x80(%ebp),%eax
c010371e:	8b 50 10             	mov    0x10(%eax),%edx
c0103721:	8b 40 0c             	mov    0xc(%eax),%eax
c0103724:	ff 75 84             	pushl  -0x7c(%ebp)
c0103727:	53                   	push   %ebx
c0103728:	51                   	push   %ecx
c0103729:	ff 75 bc             	pushl  -0x44(%ebp)
c010372c:	ff 75 b8             	pushl  -0x48(%ebp)
c010372f:	52                   	push   %edx
c0103730:	50                   	push   %eax
c0103731:	68 34 a8 10 c0       	push   $0xc010a834
c0103736:	e8 43 cb ff ff       	call   c010027e <cprintf>
c010373b:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010373e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103741:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103744:	89 d0                	mov    %edx,%eax
c0103746:	c1 e0 02             	shl    $0x2,%eax
c0103749:	01 d0                	add    %edx,%eax
c010374b:	c1 e0 02             	shl    $0x2,%eax
c010374e:	01 c8                	add    %ecx,%eax
c0103750:	83 c0 14             	add    $0x14,%eax
c0103753:	8b 00                	mov    (%eax),%eax
c0103755:	83 f8 01             	cmp    $0x1,%eax
c0103758:	75 36                	jne    c0103790 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c010375a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010375d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103760:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103763:	77 2b                	ja     c0103790 <page_init+0x132>
c0103765:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103768:	72 05                	jb     c010376f <page_init+0x111>
c010376a:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010376d:	73 21                	jae    c0103790 <page_init+0x132>
c010376f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103773:	77 1b                	ja     c0103790 <page_init+0x132>
c0103775:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103779:	72 09                	jb     c0103784 <page_init+0x126>
c010377b:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103782:	77 0c                	ja     c0103790 <page_init+0x132>
                maxpa = end;
c0103784:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103787:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010378a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010378d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103790:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103794:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103797:	8b 00                	mov    (%eax),%eax
c0103799:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010379c:	0f 8f f6 fe ff ff    	jg     c0103698 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01037a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037a6:	72 1d                	jb     c01037c5 <page_init+0x167>
c01037a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037ac:	77 09                	ja     c01037b7 <page_init+0x159>
c01037ae:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01037b5:	76 0e                	jbe    c01037c5 <page_init+0x167>
        maxpa = KMEMSIZE;
c01037b7:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01037be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01037c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01037cb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01037cf:	c1 ea 0c             	shr    $0xc,%edx
c01037d2:	a3 40 7a 12 c0       	mov    %eax,0xc0127a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01037d7:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01037de:	b8 2c 9c 12 c0       	mov    $0xc0129c2c,%eax
c01037e3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01037e6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01037e9:	01 d0                	add    %edx,%eax
c01037eb:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01037ee:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037f1:	ba 00 00 00 00       	mov    $0x0,%edx
c01037f6:	f7 75 ac             	divl   -0x54(%ebp)
c01037f9:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037fc:	29 d0                	sub    %edx,%eax
c01037fe:	a3 20 9b 12 c0       	mov    %eax,0xc0129b20

    for (i = 0; i < npage; i ++) {
c0103803:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010380a:	eb 27                	jmp    c0103833 <page_init+0x1d5>
        SetPageReserved(pages + i);
c010380c:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c0103811:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103814:	c1 e2 05             	shl    $0x5,%edx
c0103817:	01 d0                	add    %edx,%eax
c0103819:	83 c0 04             	add    $0x4,%eax
c010381c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103823:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103826:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103829:	8b 55 90             	mov    -0x70(%ebp),%edx
c010382c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010382f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103833:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103836:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c010383b:	39 c2                	cmp    %eax,%edx
c010383d:	72 cd                	jb     c010380c <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010383f:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0103844:	c1 e0 05             	shl    $0x5,%eax
c0103847:	89 c2                	mov    %eax,%edx
c0103849:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c010384e:	01 d0                	add    %edx,%eax
c0103850:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103853:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010385a:	77 17                	ja     c0103873 <page_init+0x215>
c010385c:	ff 75 a4             	pushl  -0x5c(%ebp)
c010385f:	68 64 a8 10 c0       	push   $0xc010a864
c0103864:	68 e9 00 00 00       	push   $0xe9
c0103869:	68 88 a8 10 c0       	push   $0xc010a888
c010386e:	e8 71 cb ff ff       	call   c01003e4 <__panic>
c0103873:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103876:	05 00 00 00 40       	add    $0x40000000,%eax
c010387b:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010387e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103885:	e9 69 01 00 00       	jmp    c01039f3 <page_init+0x395>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010388a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010388d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103890:	89 d0                	mov    %edx,%eax
c0103892:	c1 e0 02             	shl    $0x2,%eax
c0103895:	01 d0                	add    %edx,%eax
c0103897:	c1 e0 02             	shl    $0x2,%eax
c010389a:	01 c8                	add    %ecx,%eax
c010389c:	8b 50 08             	mov    0x8(%eax),%edx
c010389f:	8b 40 04             	mov    0x4(%eax),%eax
c01038a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01038a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01038a8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01038ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01038ae:	89 d0                	mov    %edx,%eax
c01038b0:	c1 e0 02             	shl    $0x2,%eax
c01038b3:	01 d0                	add    %edx,%eax
c01038b5:	c1 e0 02             	shl    $0x2,%eax
c01038b8:	01 c8                	add    %ecx,%eax
c01038ba:	8b 48 0c             	mov    0xc(%eax),%ecx
c01038bd:	8b 58 10             	mov    0x10(%eax),%ebx
c01038c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01038c6:	01 c8                	add    %ecx,%eax
c01038c8:	11 da                	adc    %ebx,%edx
c01038ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01038cd:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01038d0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01038d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01038d6:	89 d0                	mov    %edx,%eax
c01038d8:	c1 e0 02             	shl    $0x2,%eax
c01038db:	01 d0                	add    %edx,%eax
c01038dd:	c1 e0 02             	shl    $0x2,%eax
c01038e0:	01 c8                	add    %ecx,%eax
c01038e2:	83 c0 14             	add    $0x14,%eax
c01038e5:	8b 00                	mov    (%eax),%eax
c01038e7:	83 f8 01             	cmp    $0x1,%eax
c01038ea:	0f 85 ff 00 00 00    	jne    c01039ef <page_init+0x391>
            if (begin < freemem) {
c01038f0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01038f3:	ba 00 00 00 00       	mov    $0x0,%edx
c01038f8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01038fb:	72 17                	jb     c0103914 <page_init+0x2b6>
c01038fd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103900:	77 05                	ja     c0103907 <page_init+0x2a9>
c0103902:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103905:	76 0d                	jbe    c0103914 <page_init+0x2b6>
                begin = freemem;
c0103907:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010390a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010390d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103914:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103918:	72 1d                	jb     c0103937 <page_init+0x2d9>
c010391a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010391e:	77 09                	ja     c0103929 <page_init+0x2cb>
c0103920:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103927:	76 0e                	jbe    c0103937 <page_init+0x2d9>
                end = KMEMSIZE;
c0103929:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103930:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103937:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010393a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010393d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103940:	0f 87 a9 00 00 00    	ja     c01039ef <page_init+0x391>
c0103946:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103949:	72 09                	jb     c0103954 <page_init+0x2f6>
c010394b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010394e:	0f 83 9b 00 00 00    	jae    c01039ef <page_init+0x391>
                begin = ROUNDUP(begin, PGSIZE);
c0103954:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010395b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010395e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103961:	01 d0                	add    %edx,%eax
c0103963:	83 e8 01             	sub    $0x1,%eax
c0103966:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103969:	8b 45 98             	mov    -0x68(%ebp),%eax
c010396c:	ba 00 00 00 00       	mov    $0x0,%edx
c0103971:	f7 75 9c             	divl   -0x64(%ebp)
c0103974:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103977:	29 d0                	sub    %edx,%eax
c0103979:	ba 00 00 00 00       	mov    $0x0,%edx
c010397e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103981:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103984:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103987:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010398a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010398d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103992:	89 c3                	mov    %eax,%ebx
c0103994:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010399a:	89 de                	mov    %ebx,%esi
c010399c:	89 d0                	mov    %edx,%eax
c010399e:	83 e0 00             	and    $0x0,%eax
c01039a1:	89 c7                	mov    %eax,%edi
c01039a3:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01039a6:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01039a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01039ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01039af:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01039b2:	77 3b                	ja     c01039ef <page_init+0x391>
c01039b4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01039b7:	72 05                	jb     c01039be <page_init+0x360>
c01039b9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01039bc:	73 31                	jae    c01039ef <page_init+0x391>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01039be:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01039c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01039c4:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01039c7:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01039ca:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01039ce:	c1 ea 0c             	shr    $0xc,%edx
c01039d1:	89 c3                	mov    %eax,%ebx
c01039d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01039d6:	83 ec 0c             	sub    $0xc,%esp
c01039d9:	50                   	push   %eax
c01039da:	e8 ca f8 ff ff       	call   c01032a9 <pa2page>
c01039df:	83 c4 10             	add    $0x10,%esp
c01039e2:	83 ec 08             	sub    $0x8,%esp
c01039e5:	53                   	push   %ebx
c01039e6:	50                   	push   %eax
c01039e7:	e8 84 fb ff ff       	call   c0103570 <init_memmap>
c01039ec:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01039ef:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01039f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01039f6:	8b 00                	mov    (%eax),%eax
c01039f8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01039fb:	0f 8f 89 fe ff ff    	jg     c010388a <page_init+0x22c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0103a01:	90                   	nop
c0103a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103a05:	5b                   	pop    %ebx
c0103a06:	5e                   	pop    %esi
c0103a07:	5f                   	pop    %edi
c0103a08:	5d                   	pop    %ebp
c0103a09:	c3                   	ret    

c0103a0a <enable_paging>:

static void
enable_paging(void) {
c0103a0a:	55                   	push   %ebp
c0103a0b:	89 e5                	mov    %esp,%ebp
c0103a0d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103a10:	a1 1c 9b 12 c0       	mov    0xc0129b1c,%eax
c0103a15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a1b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103a1e:	0f 20 c0             	mov    %cr0,%eax
c0103a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103a24:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103a27:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103a2a:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103a31:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0103a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a3e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103a41:	90                   	nop
c0103a42:	c9                   	leave  
c0103a43:	c3                   	ret    

c0103a44 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103a44:	55                   	push   %ebp
c0103a45:	89 e5                	mov    %esp,%ebp
c0103a47:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a4d:	33 45 14             	xor    0x14(%ebp),%eax
c0103a50:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103a55:	85 c0                	test   %eax,%eax
c0103a57:	74 19                	je     c0103a72 <boot_map_segment+0x2e>
c0103a59:	68 96 a8 10 c0       	push   $0xc010a896
c0103a5e:	68 ad a8 10 c0       	push   $0xc010a8ad
c0103a63:	68 12 01 00 00       	push   $0x112
c0103a68:	68 88 a8 10 c0       	push   $0xc010a888
c0103a6d:	e8 72 c9 ff ff       	call   c01003e4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103a72:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103a79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a7c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103a81:	89 c2                	mov    %eax,%edx
c0103a83:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a86:	01 c2                	add    %eax,%edx
c0103a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a8b:	01 d0                	add    %edx,%eax
c0103a8d:	83 e8 01             	sub    $0x1,%eax
c0103a90:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a96:	ba 00 00 00 00       	mov    $0x0,%edx
c0103a9b:	f7 75 f0             	divl   -0x10(%ebp)
c0103a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103aa1:	29 d0                	sub    %edx,%eax
c0103aa3:	c1 e8 0c             	shr    $0xc,%eax
c0103aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103aac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ab7:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103aba:	8b 45 14             	mov    0x14(%ebp),%eax
c0103abd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ac8:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103acb:	eb 57                	jmp    c0103b24 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103acd:	83 ec 04             	sub    $0x4,%esp
c0103ad0:	6a 01                	push   $0x1
c0103ad2:	ff 75 0c             	pushl  0xc(%ebp)
c0103ad5:	ff 75 08             	pushl  0x8(%ebp)
c0103ad8:	e8 9d 01 00 00       	call   c0103c7a <get_pte>
c0103add:	83 c4 10             	add    $0x10,%esp
c0103ae0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103ae3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103ae7:	75 19                	jne    c0103b02 <boot_map_segment+0xbe>
c0103ae9:	68 c2 a8 10 c0       	push   $0xc010a8c2
c0103aee:	68 ad a8 10 c0       	push   $0xc010a8ad
c0103af3:	68 18 01 00 00       	push   $0x118
c0103af8:	68 88 a8 10 c0       	push   $0xc010a888
c0103afd:	e8 e2 c8 ff ff       	call   c01003e4 <__panic>
        *ptep = pa | PTE_P | perm;
c0103b02:	8b 45 14             	mov    0x14(%ebp),%eax
c0103b05:	0b 45 18             	or     0x18(%ebp),%eax
c0103b08:	83 c8 01             	or     $0x1,%eax
c0103b0b:	89 c2                	mov    %eax,%edx
c0103b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b10:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103b12:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103b16:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103b1d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103b24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b28:	75 a3                	jne    c0103acd <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0103b2a:	90                   	nop
c0103b2b:	c9                   	leave  
c0103b2c:	c3                   	ret    

c0103b2d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103b2d:	55                   	push   %ebp
c0103b2e:	89 e5                	mov    %esp,%ebp
c0103b30:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0103b33:	83 ec 0c             	sub    $0xc,%esp
c0103b36:	6a 01                	push   $0x1
c0103b38:	e8 52 fa ff ff       	call   c010358f <alloc_pages>
c0103b3d:	83 c4 10             	add    $0x10,%esp
c0103b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b47:	75 17                	jne    c0103b60 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0103b49:	83 ec 04             	sub    $0x4,%esp
c0103b4c:	68 cf a8 10 c0       	push   $0xc010a8cf
c0103b51:	68 24 01 00 00       	push   $0x124
c0103b56:	68 88 a8 10 c0       	push   $0xc010a888
c0103b5b:	e8 84 c8 ff ff       	call   c01003e4 <__panic>
    }
    return page2kva(p);
c0103b60:	83 ec 0c             	sub    $0xc,%esp
c0103b63:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b66:	e8 7b f7 ff ff       	call   c01032e6 <page2kva>
c0103b6b:	83 c4 10             	add    $0x10,%esp
}
c0103b6e:	c9                   	leave  
c0103b6f:	c3                   	ret    

c0103b70 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103b70:	55                   	push   %ebp
c0103b71:	89 e5                	mov    %esp,%ebp
c0103b73:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103b76:	e8 c0 f9 ff ff       	call   c010353b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103b7b:	e8 de fa ff ff       	call   c010365e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103b80:	e8 da 04 00 00       	call   c010405f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0103b85:	e8 a3 ff ff ff       	call   c0103b2d <boot_alloc_page>
c0103b8a:	a3 44 7a 12 c0       	mov    %eax,0xc0127a44
    memset(boot_pgdir, 0, PGSIZE);
c0103b8f:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103b94:	83 ec 04             	sub    $0x4,%esp
c0103b97:	68 00 10 00 00       	push   $0x1000
c0103b9c:	6a 00                	push   $0x0
c0103b9e:	50                   	push   %eax
c0103b9f:	e8 c2 5a 00 00       	call   c0109666 <memset>
c0103ba4:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c0103ba7:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103baf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103bb6:	77 17                	ja     c0103bcf <pmm_init+0x5f>
c0103bb8:	ff 75 f4             	pushl  -0xc(%ebp)
c0103bbb:	68 64 a8 10 c0       	push   $0xc010a864
c0103bc0:	68 3e 01 00 00       	push   $0x13e
c0103bc5:	68 88 a8 10 c0       	push   $0xc010a888
c0103bca:	e8 15 c8 ff ff       	call   c01003e4 <__panic>
c0103bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bd2:	05 00 00 00 40       	add    $0x40000000,%eax
c0103bd7:	a3 1c 9b 12 c0       	mov    %eax,0xc0129b1c

    check_pgdir();
c0103bdc:	e8 a1 04 00 00       	call   c0104082 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103be1:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103be6:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0103bec:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bf4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103bfb:	77 17                	ja     c0103c14 <pmm_init+0xa4>
c0103bfd:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c00:	68 64 a8 10 c0       	push   $0xc010a864
c0103c05:	68 46 01 00 00       	push   $0x146
c0103c0a:	68 88 a8 10 c0       	push   $0xc010a888
c0103c0f:	e8 d0 c7 ff ff       	call   c01003e4 <__panic>
c0103c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c17:	05 00 00 00 40       	add    $0x40000000,%eax
c0103c1c:	83 c8 03             	or     $0x3,%eax
c0103c1f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103c21:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103c26:	83 ec 0c             	sub    $0xc,%esp
c0103c29:	6a 02                	push   $0x2
c0103c2b:	6a 00                	push   $0x0
c0103c2d:	68 00 00 00 38       	push   $0x38000000
c0103c32:	68 00 00 00 c0       	push   $0xc0000000
c0103c37:	50                   	push   %eax
c0103c38:	e8 07 fe ff ff       	call   c0103a44 <boot_map_segment>
c0103c3d:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103c40:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103c45:	8b 15 44 7a 12 c0    	mov    0xc0127a44,%edx
c0103c4b:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103c51:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103c53:	e8 b2 fd ff ff       	call   c0103a0a <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103c58:	e8 ec f7 ff ff       	call   c0103449 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103c5d:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0103c62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103c68:	e8 7b 09 00 00       	call   c01045e8 <check_boot_pgdir>

    print_pgdir();
c0103c6d:	e8 71 0d 00 00       	call   c01049e3 <print_pgdir>
    
    kmalloc_init();
c0103c72:	e8 d3 2b 00 00       	call   c010684a <kmalloc_init>

}
c0103c77:	90                   	nop
c0103c78:	c9                   	leave  
c0103c79:	c3                   	ret    

c0103c7a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103c7a:	55                   	push   %ebp
c0103c7b:	89 e5                	mov    %esp,%ebp
c0103c7d:	83 ec 28             	sub    $0x28,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    pde_t *pdep = pgdir + PDX(la);   // (1) find page directory entry
c0103c80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c83:	c1 e8 16             	shr    $0x16,%eax
c0103c86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c90:	01 d0                	add    %edx,%eax
c0103c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep) & PTE_P) != 1) {              // (2) check if entry is not present
c0103c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c98:	8b 00                	mov    (%eax),%eax
c0103c9a:	83 e0 01             	and    $0x1,%eax
c0103c9d:	85 c0                	test   %eax,%eax
c0103c9f:	0f 85 bd 00 00 00    	jne    c0103d62 <get_pte+0xe8>
        if (!create) return NULL;                  // (3) check if creating is needed, then alloc page for page table
c0103ca5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103ca9:	75 0a                	jne    c0103cb5 <get_pte+0x3b>
c0103cab:	b8 00 00 00 00       	mov    $0x0,%eax
c0103cb0:	e9 fe 00 00 00       	jmp    c0103db3 <get_pte+0x139>
        struct Page* ptPage;
        assert(ptPage = alloc_page());
c0103cb5:	83 ec 0c             	sub    $0xc,%esp
c0103cb8:	6a 01                	push   $0x1
c0103cba:	e8 d0 f8 ff ff       	call   c010358f <alloc_pages>
c0103cbf:	83 c4 10             	add    $0x10,%esp
c0103cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103cc9:	75 19                	jne    c0103ce4 <get_pte+0x6a>
c0103ccb:	68 e8 a8 10 c0       	push   $0xc010a8e8
c0103cd0:	68 ad a8 10 c0       	push   $0xc010a8ad
c0103cd5:	68 87 01 00 00       	push   $0x187
c0103cda:	68 88 a8 10 c0       	push   $0xc010a888
c0103cdf:	e8 00 c7 ff ff       	call   c01003e4 <__panic>
        set_page_ref(ptPage, 1);         // (4) set page reference
c0103ce4:	83 ec 08             	sub    $0x8,%esp
c0103ce7:	6a 01                	push   $0x1
c0103ce9:	ff 75 f0             	pushl  -0x10(%ebp)
c0103cec:	e8 9a f6 ff ff       	call   c010338b <set_page_ref>
c0103cf1:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(ptPage); // (5) get linear address of page
c0103cf4:	83 ec 0c             	sub    $0xc,%esp
c0103cf7:	ff 75 f0             	pushl  -0x10(%ebp)
c0103cfa:	e8 97 f5 ff ff       	call   c0103296 <page2pa>
c0103cff:	83 c4 10             	add    $0x10,%esp
c0103d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);   // (6) clear page content using memset
c0103d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d08:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d0e:	c1 e8 0c             	shr    $0xc,%eax
c0103d11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d14:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0103d19:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103d1c:	72 17                	jb     c0103d35 <get_pte+0xbb>
c0103d1e:	ff 75 e8             	pushl  -0x18(%ebp)
c0103d21:	68 c0 a7 10 c0       	push   $0xc010a7c0
c0103d26:	68 8a 01 00 00       	push   $0x18a
c0103d2b:	68 88 a8 10 c0       	push   $0xc010a888
c0103d30:	e8 af c6 ff ff       	call   c01003e4 <__panic>
c0103d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d38:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103d3d:	83 ec 04             	sub    $0x4,%esp
c0103d40:	68 00 10 00 00       	push   $0x1000
c0103d45:	6a 00                	push   $0x0
c0103d47:	50                   	push   %eax
c0103d48:	e8 19 59 00 00       	call   c0109666 <memset>
c0103d4d:	83 c4 10             	add    $0x10,%esp
        *pdep = ((pa & ~0x0FFF) | PTE_U | PTE_W | PTE_P);                  // (7) set page directory entry's permission
c0103d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d58:	83 c8 07             	or     $0x7,%eax
c0103d5b:	89 c2                	mov    %eax,%edx
c0103d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d60:	89 10                	mov    %edx,(%eax)
    }
    return ((pte_t*)KADDR((*pdep) & ~0xFFF)) + PTX(la);          // (8) return page table entry
c0103d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d65:	8b 00                	mov    (%eax),%eax
c0103d67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d72:	c1 e8 0c             	shr    $0xc,%eax
c0103d75:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103d78:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0103d7d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d80:	72 17                	jb     c0103d99 <get_pte+0x11f>
c0103d82:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d85:	68 c0 a7 10 c0       	push   $0xc010a7c0
c0103d8a:	68 8d 01 00 00       	push   $0x18d
c0103d8f:	68 88 a8 10 c0       	push   $0xc010a888
c0103d94:	e8 4b c6 ff ff       	call   c01003e4 <__panic>
c0103d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d9c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103da1:	89 c2                	mov    %eax,%edx
c0103da3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103da6:	c1 e8 0c             	shr    $0xc,%eax
c0103da9:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103dae:	c1 e0 02             	shl    $0x2,%eax
c0103db1:	01 d0                	add    %edx,%eax
}
c0103db3:	c9                   	leave  
c0103db4:	c3                   	ret    

c0103db5 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103db5:	55                   	push   %ebp
c0103db6:	89 e5                	mov    %esp,%ebp
c0103db8:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103dbb:	83 ec 04             	sub    $0x4,%esp
c0103dbe:	6a 00                	push   $0x0
c0103dc0:	ff 75 0c             	pushl  0xc(%ebp)
c0103dc3:	ff 75 08             	pushl  0x8(%ebp)
c0103dc6:	e8 af fe ff ff       	call   c0103c7a <get_pte>
c0103dcb:	83 c4 10             	add    $0x10,%esp
c0103dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103dd5:	74 08                	je     c0103ddf <get_page+0x2a>
        *ptep_store = ptep;
c0103dd7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ddd:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103ddf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103de3:	74 1f                	je     c0103e04 <get_page+0x4f>
c0103de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de8:	8b 00                	mov    (%eax),%eax
c0103dea:	83 e0 01             	and    $0x1,%eax
c0103ded:	85 c0                	test   %eax,%eax
c0103def:	74 13                	je     c0103e04 <get_page+0x4f>
        return pte2page(*ptep);
c0103df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103df4:	8b 00                	mov    (%eax),%eax
c0103df6:	83 ec 0c             	sub    $0xc,%esp
c0103df9:	50                   	push   %eax
c0103dfa:	e8 2c f5 ff ff       	call   c010332b <pte2page>
c0103dff:	83 c4 10             	add    $0x10,%esp
c0103e02:	eb 05                	jmp    c0103e09 <get_page+0x54>
    }
    return NULL;
c0103e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103e09:	c9                   	leave  
c0103e0a:	c3                   	ret    

c0103e0b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103e0b:	55                   	push   %ebp
c0103e0c:	89 e5                	mov    %esp,%ebp
c0103e0e:	83 ec 18             	sub    $0x18,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (((*ptep) & PTE_P) == 1) {                      //(1) check if this page table entry is present
c0103e11:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e14:	8b 00                	mov    (%eax),%eax
c0103e16:	83 e0 01             	and    $0x1,%eax
c0103e19:	85 c0                	test   %eax,%eax
c0103e1b:	74 55                	je     c0103e72 <page_remove_pte+0x67>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c0103e1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e20:	8b 00                	mov    (%eax),%eax
c0103e22:	83 ec 0c             	sub    $0xc,%esp
c0103e25:	50                   	push   %eax
c0103e26:	e8 00 f5 ff ff       	call   c010332b <pte2page>
c0103e2b:	83 c4 10             	add    $0x10,%esp
c0103e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
c0103e31:	83 ec 0c             	sub    $0xc,%esp
c0103e34:	ff 75 f4             	pushl  -0xc(%ebp)
c0103e37:	e8 74 f5 ff ff       	call   c01033b0 <page_ref_dec>
c0103e3c:	83 c4 10             	add    $0x10,%esp
        if (page->ref == 0) {
c0103e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e42:	8b 00                	mov    (%eax),%eax
c0103e44:	85 c0                	test   %eax,%eax
c0103e46:	75 10                	jne    c0103e58 <page_remove_pte+0x4d>
        	free_page(page);           //(4) and free this page when page reference reachs 0
c0103e48:	83 ec 08             	sub    $0x8,%esp
c0103e4b:	6a 01                	push   $0x1
c0103e4d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103e50:	e8 a6 f7 ff ff       	call   c01035fb <free_pages>
c0103e55:	83 c4 10             	add    $0x10,%esp
        }
        (*ptep) = 0;                          //(5) clear second page table entry
c0103e58:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
c0103e61:	83 ec 08             	sub    $0x8,%esp
c0103e64:	ff 75 0c             	pushl  0xc(%ebp)
c0103e67:	ff 75 08             	pushl  0x8(%ebp)
c0103e6a:	e8 f8 00 00 00       	call   c0103f67 <tlb_invalidate>
c0103e6f:	83 c4 10             	add    $0x10,%esp
    }
    // Should I check whether all entries in PT is not present and recycle the PT?
    // Then Maybe I should set the pde to be not present.
}
c0103e72:	90                   	nop
c0103e73:	c9                   	leave  
c0103e74:	c3                   	ret    

c0103e75 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103e75:	55                   	push   %ebp
c0103e76:	89 e5                	mov    %esp,%ebp
c0103e78:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103e7b:	83 ec 04             	sub    $0x4,%esp
c0103e7e:	6a 00                	push   $0x0
c0103e80:	ff 75 0c             	pushl  0xc(%ebp)
c0103e83:	ff 75 08             	pushl  0x8(%ebp)
c0103e86:	e8 ef fd ff ff       	call   c0103c7a <get_pte>
c0103e8b:	83 c4 10             	add    $0x10,%esp
c0103e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103e95:	74 14                	je     c0103eab <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c0103e97:	83 ec 04             	sub    $0x4,%esp
c0103e9a:	ff 75 f4             	pushl  -0xc(%ebp)
c0103e9d:	ff 75 0c             	pushl  0xc(%ebp)
c0103ea0:	ff 75 08             	pushl  0x8(%ebp)
c0103ea3:	e8 63 ff ff ff       	call   c0103e0b <page_remove_pte>
c0103ea8:	83 c4 10             	add    $0x10,%esp
    }
}
c0103eab:	90                   	nop
c0103eac:	c9                   	leave  
c0103ead:	c3                   	ret    

c0103eae <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103eae:	55                   	push   %ebp
c0103eaf:	89 e5                	mov    %esp,%ebp
c0103eb1:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103eb4:	83 ec 04             	sub    $0x4,%esp
c0103eb7:	6a 01                	push   $0x1
c0103eb9:	ff 75 10             	pushl  0x10(%ebp)
c0103ebc:	ff 75 08             	pushl  0x8(%ebp)
c0103ebf:	e8 b6 fd ff ff       	call   c0103c7a <get_pte>
c0103ec4:	83 c4 10             	add    $0x10,%esp
c0103ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ece:	75 0a                	jne    c0103eda <page_insert+0x2c>
        return -E_NO_MEM;
c0103ed0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103ed5:	e9 8b 00 00 00       	jmp    c0103f65 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103eda:	83 ec 0c             	sub    $0xc,%esp
c0103edd:	ff 75 0c             	pushl  0xc(%ebp)
c0103ee0:	e8 b4 f4 ff ff       	call   c0103399 <page_ref_inc>
c0103ee5:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0103ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eeb:	8b 00                	mov    (%eax),%eax
c0103eed:	83 e0 01             	and    $0x1,%eax
c0103ef0:	85 c0                	test   %eax,%eax
c0103ef2:	74 40                	je     c0103f34 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0103ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ef7:	8b 00                	mov    (%eax),%eax
c0103ef9:	83 ec 0c             	sub    $0xc,%esp
c0103efc:	50                   	push   %eax
c0103efd:	e8 29 f4 ff ff       	call   c010332b <pte2page>
c0103f02:	83 c4 10             	add    $0x10,%esp
c0103f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f0e:	75 10                	jne    c0103f20 <page_insert+0x72>
            page_ref_dec(page);
c0103f10:	83 ec 0c             	sub    $0xc,%esp
c0103f13:	ff 75 0c             	pushl  0xc(%ebp)
c0103f16:	e8 95 f4 ff ff       	call   c01033b0 <page_ref_dec>
c0103f1b:	83 c4 10             	add    $0x10,%esp
c0103f1e:	eb 14                	jmp    c0103f34 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103f20:	83 ec 04             	sub    $0x4,%esp
c0103f23:	ff 75 f4             	pushl  -0xc(%ebp)
c0103f26:	ff 75 10             	pushl  0x10(%ebp)
c0103f29:	ff 75 08             	pushl  0x8(%ebp)
c0103f2c:	e8 da fe ff ff       	call   c0103e0b <page_remove_pte>
c0103f31:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103f34:	83 ec 0c             	sub    $0xc,%esp
c0103f37:	ff 75 0c             	pushl  0xc(%ebp)
c0103f3a:	e8 57 f3 ff ff       	call   c0103296 <page2pa>
c0103f3f:	83 c4 10             	add    $0x10,%esp
c0103f42:	0b 45 14             	or     0x14(%ebp),%eax
c0103f45:	83 c8 01             	or     $0x1,%eax
c0103f48:	89 c2                	mov    %eax,%edx
c0103f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f4d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103f4f:	83 ec 08             	sub    $0x8,%esp
c0103f52:	ff 75 10             	pushl  0x10(%ebp)
c0103f55:	ff 75 08             	pushl  0x8(%ebp)
c0103f58:	e8 0a 00 00 00       	call   c0103f67 <tlb_invalidate>
c0103f5d:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f65:	c9                   	leave  
c0103f66:	c3                   	ret    

c0103f67 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103f67:	55                   	push   %ebp
c0103f68:	89 e5                	mov    %esp,%ebp
c0103f6a:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103f6d:	0f 20 d8             	mov    %cr3,%eax
c0103f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0103f73:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103f76:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f7c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103f83:	77 17                	ja     c0103f9c <tlb_invalidate+0x35>
c0103f85:	ff 75 f0             	pushl  -0x10(%ebp)
c0103f88:	68 64 a8 10 c0       	push   $0xc010a864
c0103f8d:	68 e9 01 00 00       	push   $0x1e9
c0103f92:	68 88 a8 10 c0       	push   $0xc010a888
c0103f97:	e8 48 c4 ff ff       	call   c01003e4 <__panic>
c0103f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f9f:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fa4:	39 c2                	cmp    %eax,%edx
c0103fa6:	75 0c                	jne    c0103fb4 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c0103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fb1:	0f 01 38             	invlpg (%eax)
    }
}
c0103fb4:	90                   	nop
c0103fb5:	c9                   	leave  
c0103fb6:	c3                   	ret    

c0103fb7 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0103fb7:	55                   	push   %ebp
c0103fb8:	89 e5                	mov    %esp,%ebp
c0103fba:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c0103fbd:	83 ec 0c             	sub    $0xc,%esp
c0103fc0:	6a 01                	push   $0x1
c0103fc2:	e8 c8 f5 ff ff       	call   c010358f <alloc_pages>
c0103fc7:	83 c4 10             	add    $0x10,%esp
c0103fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0103fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103fd1:	0f 84 83 00 00 00    	je     c010405a <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0103fd7:	ff 75 10             	pushl  0x10(%ebp)
c0103fda:	ff 75 0c             	pushl  0xc(%ebp)
c0103fdd:	ff 75 f4             	pushl  -0xc(%ebp)
c0103fe0:	ff 75 08             	pushl  0x8(%ebp)
c0103fe3:	e8 c6 fe ff ff       	call   c0103eae <page_insert>
c0103fe8:	83 c4 10             	add    $0x10,%esp
c0103feb:	85 c0                	test   %eax,%eax
c0103fed:	74 17                	je     c0104006 <pgdir_alloc_page+0x4f>
            free_page(page);
c0103fef:	83 ec 08             	sub    $0x8,%esp
c0103ff2:	6a 01                	push   $0x1
c0103ff4:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ff7:	e8 ff f5 ff ff       	call   c01035fb <free_pages>
c0103ffc:	83 c4 10             	add    $0x10,%esp
            return NULL;
c0103fff:	b8 00 00 00 00       	mov    $0x0,%eax
c0104004:	eb 57                	jmp    c010405d <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c0104006:	a1 d0 7a 12 c0       	mov    0xc0127ad0,%eax
c010400b:	85 c0                	test   %eax,%eax
c010400d:	74 4b                	je     c010405a <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c010400f:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c0104014:	6a 00                	push   $0x0
c0104016:	ff 75 f4             	pushl  -0xc(%ebp)
c0104019:	ff 75 0c             	pushl  0xc(%ebp)
c010401c:	50                   	push   %eax
c010401d:	e8 22 18 00 00       	call   c0105844 <swap_map_swappable>
c0104022:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c0104025:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104028:	8b 55 0c             	mov    0xc(%ebp),%edx
c010402b:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c010402e:	83 ec 0c             	sub    $0xc,%esp
c0104031:	ff 75 f4             	pushl  -0xc(%ebp)
c0104034:	e8 48 f3 ff ff       	call   c0103381 <page_ref>
c0104039:	83 c4 10             	add    $0x10,%esp
c010403c:	83 f8 01             	cmp    $0x1,%eax
c010403f:	74 19                	je     c010405a <pgdir_alloc_page+0xa3>
c0104041:	68 fe a8 10 c0       	push   $0xc010a8fe
c0104046:	68 ad a8 10 c0       	push   $0xc010a8ad
c010404b:	68 fc 01 00 00       	push   $0x1fc
c0104050:	68 88 a8 10 c0       	push   $0xc010a888
c0104055:	e8 8a c3 ff ff       	call   c01003e4 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010405a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010405d:	c9                   	leave  
c010405e:	c3                   	ret    

c010405f <check_alloc_page>:

static void
check_alloc_page(void) {
c010405f:	55                   	push   %ebp
c0104060:	89 e5                	mov    %esp,%ebp
c0104062:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0104065:	a1 18 9b 12 c0       	mov    0xc0129b18,%eax
c010406a:	8b 40 18             	mov    0x18(%eax),%eax
c010406d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010406f:	83 ec 0c             	sub    $0xc,%esp
c0104072:	68 14 a9 10 c0       	push   $0xc010a914
c0104077:	e8 02 c2 ff ff       	call   c010027e <cprintf>
c010407c:	83 c4 10             	add    $0x10,%esp
}
c010407f:	90                   	nop
c0104080:	c9                   	leave  
c0104081:	c3                   	ret    

c0104082 <check_pgdir>:

static void
check_pgdir(void) {
c0104082:	55                   	push   %ebp
c0104083:	89 e5                	mov    %esp,%ebp
c0104085:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104088:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c010408d:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104092:	76 19                	jbe    c01040ad <check_pgdir+0x2b>
c0104094:	68 33 a9 10 c0       	push   $0xc010a933
c0104099:	68 ad a8 10 c0       	push   $0xc010a8ad
c010409e:	68 0d 02 00 00       	push   $0x20d
c01040a3:	68 88 a8 10 c0       	push   $0xc010a888
c01040a8:	e8 37 c3 ff ff       	call   c01003e4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01040ad:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01040b2:	85 c0                	test   %eax,%eax
c01040b4:	74 0e                	je     c01040c4 <check_pgdir+0x42>
c01040b6:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01040bb:	25 ff 0f 00 00       	and    $0xfff,%eax
c01040c0:	85 c0                	test   %eax,%eax
c01040c2:	74 19                	je     c01040dd <check_pgdir+0x5b>
c01040c4:	68 50 a9 10 c0       	push   $0xc010a950
c01040c9:	68 ad a8 10 c0       	push   $0xc010a8ad
c01040ce:	68 0e 02 00 00       	push   $0x20e
c01040d3:	68 88 a8 10 c0       	push   $0xc010a888
c01040d8:	e8 07 c3 ff ff       	call   c01003e4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01040dd:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01040e2:	83 ec 04             	sub    $0x4,%esp
c01040e5:	6a 00                	push   $0x0
c01040e7:	6a 00                	push   $0x0
c01040e9:	50                   	push   %eax
c01040ea:	e8 c6 fc ff ff       	call   c0103db5 <get_page>
c01040ef:	83 c4 10             	add    $0x10,%esp
c01040f2:	85 c0                	test   %eax,%eax
c01040f4:	74 19                	je     c010410f <check_pgdir+0x8d>
c01040f6:	68 88 a9 10 c0       	push   $0xc010a988
c01040fb:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104100:	68 0f 02 00 00       	push   $0x20f
c0104105:	68 88 a8 10 c0       	push   $0xc010a888
c010410a:	e8 d5 c2 ff ff       	call   c01003e4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010410f:	83 ec 0c             	sub    $0xc,%esp
c0104112:	6a 01                	push   $0x1
c0104114:	e8 76 f4 ff ff       	call   c010358f <alloc_pages>
c0104119:	83 c4 10             	add    $0x10,%esp
c010411c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010411f:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104124:	6a 00                	push   $0x0
c0104126:	6a 00                	push   $0x0
c0104128:	ff 75 f4             	pushl  -0xc(%ebp)
c010412b:	50                   	push   %eax
c010412c:	e8 7d fd ff ff       	call   c0103eae <page_insert>
c0104131:	83 c4 10             	add    $0x10,%esp
c0104134:	85 c0                	test   %eax,%eax
c0104136:	74 19                	je     c0104151 <check_pgdir+0xcf>
c0104138:	68 b0 a9 10 c0       	push   $0xc010a9b0
c010413d:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104142:	68 13 02 00 00       	push   $0x213
c0104147:	68 88 a8 10 c0       	push   $0xc010a888
c010414c:	e8 93 c2 ff ff       	call   c01003e4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104151:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104156:	83 ec 04             	sub    $0x4,%esp
c0104159:	6a 00                	push   $0x0
c010415b:	6a 00                	push   $0x0
c010415d:	50                   	push   %eax
c010415e:	e8 17 fb ff ff       	call   c0103c7a <get_pte>
c0104163:	83 c4 10             	add    $0x10,%esp
c0104166:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010416d:	75 19                	jne    c0104188 <check_pgdir+0x106>
c010416f:	68 dc a9 10 c0       	push   $0xc010a9dc
c0104174:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104179:	68 16 02 00 00       	push   $0x216
c010417e:	68 88 a8 10 c0       	push   $0xc010a888
c0104183:	e8 5c c2 ff ff       	call   c01003e4 <__panic>
    assert(pte2page(*ptep) == p1);
c0104188:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010418b:	8b 00                	mov    (%eax),%eax
c010418d:	83 ec 0c             	sub    $0xc,%esp
c0104190:	50                   	push   %eax
c0104191:	e8 95 f1 ff ff       	call   c010332b <pte2page>
c0104196:	83 c4 10             	add    $0x10,%esp
c0104199:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010419c:	74 19                	je     c01041b7 <check_pgdir+0x135>
c010419e:	68 09 aa 10 c0       	push   $0xc010aa09
c01041a3:	68 ad a8 10 c0       	push   $0xc010a8ad
c01041a8:	68 17 02 00 00       	push   $0x217
c01041ad:	68 88 a8 10 c0       	push   $0xc010a888
c01041b2:	e8 2d c2 ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p1) == 1);
c01041b7:	83 ec 0c             	sub    $0xc,%esp
c01041ba:	ff 75 f4             	pushl  -0xc(%ebp)
c01041bd:	e8 bf f1 ff ff       	call   c0103381 <page_ref>
c01041c2:	83 c4 10             	add    $0x10,%esp
c01041c5:	83 f8 01             	cmp    $0x1,%eax
c01041c8:	74 19                	je     c01041e3 <check_pgdir+0x161>
c01041ca:	68 1f aa 10 c0       	push   $0xc010aa1f
c01041cf:	68 ad a8 10 c0       	push   $0xc010a8ad
c01041d4:	68 18 02 00 00       	push   $0x218
c01041d9:	68 88 a8 10 c0       	push   $0xc010a888
c01041de:	e8 01 c2 ff ff       	call   c01003e4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01041e3:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01041e8:	8b 00                	mov    (%eax),%eax
c01041ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041f5:	c1 e8 0c             	shr    $0xc,%eax
c01041f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041fb:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0104200:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104203:	72 17                	jb     c010421c <check_pgdir+0x19a>
c0104205:	ff 75 ec             	pushl  -0x14(%ebp)
c0104208:	68 c0 a7 10 c0       	push   $0xc010a7c0
c010420d:	68 1a 02 00 00       	push   $0x21a
c0104212:	68 88 a8 10 c0       	push   $0xc010a888
c0104217:	e8 c8 c1 ff ff       	call   c01003e4 <__panic>
c010421c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010421f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104224:	83 c0 04             	add    $0x4,%eax
c0104227:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010422a:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c010422f:	83 ec 04             	sub    $0x4,%esp
c0104232:	6a 00                	push   $0x0
c0104234:	68 00 10 00 00       	push   $0x1000
c0104239:	50                   	push   %eax
c010423a:	e8 3b fa ff ff       	call   c0103c7a <get_pte>
c010423f:	83 c4 10             	add    $0x10,%esp
c0104242:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104245:	74 19                	je     c0104260 <check_pgdir+0x1de>
c0104247:	68 34 aa 10 c0       	push   $0xc010aa34
c010424c:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104251:	68 1b 02 00 00       	push   $0x21b
c0104256:	68 88 a8 10 c0       	push   $0xc010a888
c010425b:	e8 84 c1 ff ff       	call   c01003e4 <__panic>

    p2 = alloc_page();
c0104260:	83 ec 0c             	sub    $0xc,%esp
c0104263:	6a 01                	push   $0x1
c0104265:	e8 25 f3 ff ff       	call   c010358f <alloc_pages>
c010426a:	83 c4 10             	add    $0x10,%esp
c010426d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104270:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104275:	6a 06                	push   $0x6
c0104277:	68 00 10 00 00       	push   $0x1000
c010427c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010427f:	50                   	push   %eax
c0104280:	e8 29 fc ff ff       	call   c0103eae <page_insert>
c0104285:	83 c4 10             	add    $0x10,%esp
c0104288:	85 c0                	test   %eax,%eax
c010428a:	74 19                	je     c01042a5 <check_pgdir+0x223>
c010428c:	68 5c aa 10 c0       	push   $0xc010aa5c
c0104291:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104296:	68 1e 02 00 00       	push   $0x21e
c010429b:	68 88 a8 10 c0       	push   $0xc010a888
c01042a0:	e8 3f c1 ff ff       	call   c01003e4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01042a5:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01042aa:	83 ec 04             	sub    $0x4,%esp
c01042ad:	6a 00                	push   $0x0
c01042af:	68 00 10 00 00       	push   $0x1000
c01042b4:	50                   	push   %eax
c01042b5:	e8 c0 f9 ff ff       	call   c0103c7a <get_pte>
c01042ba:	83 c4 10             	add    $0x10,%esp
c01042bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01042c4:	75 19                	jne    c01042df <check_pgdir+0x25d>
c01042c6:	68 94 aa 10 c0       	push   $0xc010aa94
c01042cb:	68 ad a8 10 c0       	push   $0xc010a8ad
c01042d0:	68 1f 02 00 00       	push   $0x21f
c01042d5:	68 88 a8 10 c0       	push   $0xc010a888
c01042da:	e8 05 c1 ff ff       	call   c01003e4 <__panic>
    assert(*ptep & PTE_U);
c01042df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042e2:	8b 00                	mov    (%eax),%eax
c01042e4:	83 e0 04             	and    $0x4,%eax
c01042e7:	85 c0                	test   %eax,%eax
c01042e9:	75 19                	jne    c0104304 <check_pgdir+0x282>
c01042eb:	68 c4 aa 10 c0       	push   $0xc010aac4
c01042f0:	68 ad a8 10 c0       	push   $0xc010a8ad
c01042f5:	68 20 02 00 00       	push   $0x220
c01042fa:	68 88 a8 10 c0       	push   $0xc010a888
c01042ff:	e8 e0 c0 ff ff       	call   c01003e4 <__panic>
    assert(*ptep & PTE_W);
c0104304:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104307:	8b 00                	mov    (%eax),%eax
c0104309:	83 e0 02             	and    $0x2,%eax
c010430c:	85 c0                	test   %eax,%eax
c010430e:	75 19                	jne    c0104329 <check_pgdir+0x2a7>
c0104310:	68 d2 aa 10 c0       	push   $0xc010aad2
c0104315:	68 ad a8 10 c0       	push   $0xc010a8ad
c010431a:	68 21 02 00 00       	push   $0x221
c010431f:	68 88 a8 10 c0       	push   $0xc010a888
c0104324:	e8 bb c0 ff ff       	call   c01003e4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104329:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c010432e:	8b 00                	mov    (%eax),%eax
c0104330:	83 e0 04             	and    $0x4,%eax
c0104333:	85 c0                	test   %eax,%eax
c0104335:	75 19                	jne    c0104350 <check_pgdir+0x2ce>
c0104337:	68 e0 aa 10 c0       	push   $0xc010aae0
c010433c:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104341:	68 22 02 00 00       	push   $0x222
c0104346:	68 88 a8 10 c0       	push   $0xc010a888
c010434b:	e8 94 c0 ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 1);
c0104350:	83 ec 0c             	sub    $0xc,%esp
c0104353:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104356:	e8 26 f0 ff ff       	call   c0103381 <page_ref>
c010435b:	83 c4 10             	add    $0x10,%esp
c010435e:	83 f8 01             	cmp    $0x1,%eax
c0104361:	74 19                	je     c010437c <check_pgdir+0x2fa>
c0104363:	68 f6 aa 10 c0       	push   $0xc010aaf6
c0104368:	68 ad a8 10 c0       	push   $0xc010a8ad
c010436d:	68 23 02 00 00       	push   $0x223
c0104372:	68 88 a8 10 c0       	push   $0xc010a888
c0104377:	e8 68 c0 ff ff       	call   c01003e4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010437c:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104381:	6a 00                	push   $0x0
c0104383:	68 00 10 00 00       	push   $0x1000
c0104388:	ff 75 f4             	pushl  -0xc(%ebp)
c010438b:	50                   	push   %eax
c010438c:	e8 1d fb ff ff       	call   c0103eae <page_insert>
c0104391:	83 c4 10             	add    $0x10,%esp
c0104394:	85 c0                	test   %eax,%eax
c0104396:	74 19                	je     c01043b1 <check_pgdir+0x32f>
c0104398:	68 08 ab 10 c0       	push   $0xc010ab08
c010439d:	68 ad a8 10 c0       	push   $0xc010a8ad
c01043a2:	68 25 02 00 00       	push   $0x225
c01043a7:	68 88 a8 10 c0       	push   $0xc010a888
c01043ac:	e8 33 c0 ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p1) == 2);
c01043b1:	83 ec 0c             	sub    $0xc,%esp
c01043b4:	ff 75 f4             	pushl  -0xc(%ebp)
c01043b7:	e8 c5 ef ff ff       	call   c0103381 <page_ref>
c01043bc:	83 c4 10             	add    $0x10,%esp
c01043bf:	83 f8 02             	cmp    $0x2,%eax
c01043c2:	74 19                	je     c01043dd <check_pgdir+0x35b>
c01043c4:	68 34 ab 10 c0       	push   $0xc010ab34
c01043c9:	68 ad a8 10 c0       	push   $0xc010a8ad
c01043ce:	68 26 02 00 00       	push   $0x226
c01043d3:	68 88 a8 10 c0       	push   $0xc010a888
c01043d8:	e8 07 c0 ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 0);
c01043dd:	83 ec 0c             	sub    $0xc,%esp
c01043e0:	ff 75 e4             	pushl  -0x1c(%ebp)
c01043e3:	e8 99 ef ff ff       	call   c0103381 <page_ref>
c01043e8:	83 c4 10             	add    $0x10,%esp
c01043eb:	85 c0                	test   %eax,%eax
c01043ed:	74 19                	je     c0104408 <check_pgdir+0x386>
c01043ef:	68 46 ab 10 c0       	push   $0xc010ab46
c01043f4:	68 ad a8 10 c0       	push   $0xc010a8ad
c01043f9:	68 27 02 00 00       	push   $0x227
c01043fe:	68 88 a8 10 c0       	push   $0xc010a888
c0104403:	e8 dc bf ff ff       	call   c01003e4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104408:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c010440d:	83 ec 04             	sub    $0x4,%esp
c0104410:	6a 00                	push   $0x0
c0104412:	68 00 10 00 00       	push   $0x1000
c0104417:	50                   	push   %eax
c0104418:	e8 5d f8 ff ff       	call   c0103c7a <get_pte>
c010441d:	83 c4 10             	add    $0x10,%esp
c0104420:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104427:	75 19                	jne    c0104442 <check_pgdir+0x3c0>
c0104429:	68 94 aa 10 c0       	push   $0xc010aa94
c010442e:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104433:	68 28 02 00 00       	push   $0x228
c0104438:	68 88 a8 10 c0       	push   $0xc010a888
c010443d:	e8 a2 bf ff ff       	call   c01003e4 <__panic>
    assert(pte2page(*ptep) == p1);
c0104442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104445:	8b 00                	mov    (%eax),%eax
c0104447:	83 ec 0c             	sub    $0xc,%esp
c010444a:	50                   	push   %eax
c010444b:	e8 db ee ff ff       	call   c010332b <pte2page>
c0104450:	83 c4 10             	add    $0x10,%esp
c0104453:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104456:	74 19                	je     c0104471 <check_pgdir+0x3ef>
c0104458:	68 09 aa 10 c0       	push   $0xc010aa09
c010445d:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104462:	68 29 02 00 00       	push   $0x229
c0104467:	68 88 a8 10 c0       	push   $0xc010a888
c010446c:	e8 73 bf ff ff       	call   c01003e4 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104471:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104474:	8b 00                	mov    (%eax),%eax
c0104476:	83 e0 04             	and    $0x4,%eax
c0104479:	85 c0                	test   %eax,%eax
c010447b:	74 19                	je     c0104496 <check_pgdir+0x414>
c010447d:	68 58 ab 10 c0       	push   $0xc010ab58
c0104482:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104487:	68 2a 02 00 00       	push   $0x22a
c010448c:	68 88 a8 10 c0       	push   $0xc010a888
c0104491:	e8 4e bf ff ff       	call   c01003e4 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104496:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c010449b:	83 ec 08             	sub    $0x8,%esp
c010449e:	6a 00                	push   $0x0
c01044a0:	50                   	push   %eax
c01044a1:	e8 cf f9 ff ff       	call   c0103e75 <page_remove>
c01044a6:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01044a9:	83 ec 0c             	sub    $0xc,%esp
c01044ac:	ff 75 f4             	pushl  -0xc(%ebp)
c01044af:	e8 cd ee ff ff       	call   c0103381 <page_ref>
c01044b4:	83 c4 10             	add    $0x10,%esp
c01044b7:	83 f8 01             	cmp    $0x1,%eax
c01044ba:	74 19                	je     c01044d5 <check_pgdir+0x453>
c01044bc:	68 1f aa 10 c0       	push   $0xc010aa1f
c01044c1:	68 ad a8 10 c0       	push   $0xc010a8ad
c01044c6:	68 2d 02 00 00       	push   $0x22d
c01044cb:	68 88 a8 10 c0       	push   $0xc010a888
c01044d0:	e8 0f bf ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 0);
c01044d5:	83 ec 0c             	sub    $0xc,%esp
c01044d8:	ff 75 e4             	pushl  -0x1c(%ebp)
c01044db:	e8 a1 ee ff ff       	call   c0103381 <page_ref>
c01044e0:	83 c4 10             	add    $0x10,%esp
c01044e3:	85 c0                	test   %eax,%eax
c01044e5:	74 19                	je     c0104500 <check_pgdir+0x47e>
c01044e7:	68 46 ab 10 c0       	push   $0xc010ab46
c01044ec:	68 ad a8 10 c0       	push   $0xc010a8ad
c01044f1:	68 2e 02 00 00       	push   $0x22e
c01044f6:	68 88 a8 10 c0       	push   $0xc010a888
c01044fb:	e8 e4 be ff ff       	call   c01003e4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104500:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104505:	83 ec 08             	sub    $0x8,%esp
c0104508:	68 00 10 00 00       	push   $0x1000
c010450d:	50                   	push   %eax
c010450e:	e8 62 f9 ff ff       	call   c0103e75 <page_remove>
c0104513:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0104516:	83 ec 0c             	sub    $0xc,%esp
c0104519:	ff 75 f4             	pushl  -0xc(%ebp)
c010451c:	e8 60 ee ff ff       	call   c0103381 <page_ref>
c0104521:	83 c4 10             	add    $0x10,%esp
c0104524:	85 c0                	test   %eax,%eax
c0104526:	74 19                	je     c0104541 <check_pgdir+0x4bf>
c0104528:	68 6d ab 10 c0       	push   $0xc010ab6d
c010452d:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104532:	68 31 02 00 00       	push   $0x231
c0104537:	68 88 a8 10 c0       	push   $0xc010a888
c010453c:	e8 a3 be ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 0);
c0104541:	83 ec 0c             	sub    $0xc,%esp
c0104544:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104547:	e8 35 ee ff ff       	call   c0103381 <page_ref>
c010454c:	83 c4 10             	add    $0x10,%esp
c010454f:	85 c0                	test   %eax,%eax
c0104551:	74 19                	je     c010456c <check_pgdir+0x4ea>
c0104553:	68 46 ab 10 c0       	push   $0xc010ab46
c0104558:	68 ad a8 10 c0       	push   $0xc010a8ad
c010455d:	68 32 02 00 00       	push   $0x232
c0104562:	68 88 a8 10 c0       	push   $0xc010a888
c0104567:	e8 78 be ff ff       	call   c01003e4 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c010456c:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104571:	8b 00                	mov    (%eax),%eax
c0104573:	83 ec 0c             	sub    $0xc,%esp
c0104576:	50                   	push   %eax
c0104577:	e8 e9 ed ff ff       	call   c0103365 <pde2page>
c010457c:	83 c4 10             	add    $0x10,%esp
c010457f:	83 ec 0c             	sub    $0xc,%esp
c0104582:	50                   	push   %eax
c0104583:	e8 f9 ed ff ff       	call   c0103381 <page_ref>
c0104588:	83 c4 10             	add    $0x10,%esp
c010458b:	83 f8 01             	cmp    $0x1,%eax
c010458e:	74 19                	je     c01045a9 <check_pgdir+0x527>
c0104590:	68 80 ab 10 c0       	push   $0xc010ab80
c0104595:	68 ad a8 10 c0       	push   $0xc010a8ad
c010459a:	68 34 02 00 00       	push   $0x234
c010459f:	68 88 a8 10 c0       	push   $0xc010a888
c01045a4:	e8 3b be ff ff       	call   c01003e4 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01045a9:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01045ae:	8b 00                	mov    (%eax),%eax
c01045b0:	83 ec 0c             	sub    $0xc,%esp
c01045b3:	50                   	push   %eax
c01045b4:	e8 ac ed ff ff       	call   c0103365 <pde2page>
c01045b9:	83 c4 10             	add    $0x10,%esp
c01045bc:	83 ec 08             	sub    $0x8,%esp
c01045bf:	6a 01                	push   $0x1
c01045c1:	50                   	push   %eax
c01045c2:	e8 34 f0 ff ff       	call   c01035fb <free_pages>
c01045c7:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01045ca:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01045cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01045d5:	83 ec 0c             	sub    $0xc,%esp
c01045d8:	68 a7 ab 10 c0       	push   $0xc010aba7
c01045dd:	e8 9c bc ff ff       	call   c010027e <cprintf>
c01045e2:	83 c4 10             	add    $0x10,%esp
}
c01045e5:	90                   	nop
c01045e6:	c9                   	leave  
c01045e7:	c3                   	ret    

c01045e8 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01045e8:	55                   	push   %ebp
c01045e9:	89 e5                	mov    %esp,%ebp
c01045eb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01045ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01045f5:	e9 a3 00 00 00       	jmp    c010469d <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104600:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104603:	c1 e8 0c             	shr    $0xc,%eax
c0104606:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104609:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c010460e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104611:	72 17                	jb     c010462a <check_boot_pgdir+0x42>
c0104613:	ff 75 f0             	pushl  -0x10(%ebp)
c0104616:	68 c0 a7 10 c0       	push   $0xc010a7c0
c010461b:	68 40 02 00 00       	push   $0x240
c0104620:	68 88 a8 10 c0       	push   $0xc010a888
c0104625:	e8 ba bd ff ff       	call   c01003e4 <__panic>
c010462a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010462d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104632:	89 c2                	mov    %eax,%edx
c0104634:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104639:	83 ec 04             	sub    $0x4,%esp
c010463c:	6a 00                	push   $0x0
c010463e:	52                   	push   %edx
c010463f:	50                   	push   %eax
c0104640:	e8 35 f6 ff ff       	call   c0103c7a <get_pte>
c0104645:	83 c4 10             	add    $0x10,%esp
c0104648:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010464b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010464f:	75 19                	jne    c010466a <check_boot_pgdir+0x82>
c0104651:	68 c4 ab 10 c0       	push   $0xc010abc4
c0104656:	68 ad a8 10 c0       	push   $0xc010a8ad
c010465b:	68 40 02 00 00       	push   $0x240
c0104660:	68 88 a8 10 c0       	push   $0xc010a888
c0104665:	e8 7a bd ff ff       	call   c01003e4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010466a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010466d:	8b 00                	mov    (%eax),%eax
c010466f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104674:	89 c2                	mov    %eax,%edx
c0104676:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104679:	39 c2                	cmp    %eax,%edx
c010467b:	74 19                	je     c0104696 <check_boot_pgdir+0xae>
c010467d:	68 01 ac 10 c0       	push   $0xc010ac01
c0104682:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104687:	68 41 02 00 00       	push   $0x241
c010468c:	68 88 a8 10 c0       	push   $0xc010a888
c0104691:	e8 4e bd ff ff       	call   c01003e4 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104696:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010469d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046a0:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c01046a5:	39 c2                	cmp    %eax,%edx
c01046a7:	0f 82 4d ff ff ff    	jb     c01045fa <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01046ad:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01046b2:	05 ac 0f 00 00       	add    $0xfac,%eax
c01046b7:	8b 00                	mov    (%eax),%eax
c01046b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046be:	89 c2                	mov    %eax,%edx
c01046c0:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01046c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046c8:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01046cf:	77 17                	ja     c01046e8 <check_boot_pgdir+0x100>
c01046d1:	ff 75 e4             	pushl  -0x1c(%ebp)
c01046d4:	68 64 a8 10 c0       	push   $0xc010a864
c01046d9:	68 44 02 00 00       	push   $0x244
c01046de:	68 88 a8 10 c0       	push   $0xc010a888
c01046e3:	e8 fc bc ff ff       	call   c01003e4 <__panic>
c01046e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046eb:	05 00 00 00 40       	add    $0x40000000,%eax
c01046f0:	39 c2                	cmp    %eax,%edx
c01046f2:	74 19                	je     c010470d <check_boot_pgdir+0x125>
c01046f4:	68 18 ac 10 c0       	push   $0xc010ac18
c01046f9:	68 ad a8 10 c0       	push   $0xc010a8ad
c01046fe:	68 44 02 00 00       	push   $0x244
c0104703:	68 88 a8 10 c0       	push   $0xc010a888
c0104708:	e8 d7 bc ff ff       	call   c01003e4 <__panic>

    assert(boot_pgdir[0] == 0);
c010470d:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104712:	8b 00                	mov    (%eax),%eax
c0104714:	85 c0                	test   %eax,%eax
c0104716:	74 19                	je     c0104731 <check_boot_pgdir+0x149>
c0104718:	68 4c ac 10 c0       	push   $0xc010ac4c
c010471d:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104722:	68 46 02 00 00       	push   $0x246
c0104727:	68 88 a8 10 c0       	push   $0xc010a888
c010472c:	e8 b3 bc ff ff       	call   c01003e4 <__panic>

    struct Page *p;
    p = alloc_page();
c0104731:	83 ec 0c             	sub    $0xc,%esp
c0104734:	6a 01                	push   $0x1
c0104736:	e8 54 ee ff ff       	call   c010358f <alloc_pages>
c010473b:	83 c4 10             	add    $0x10,%esp
c010473e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104741:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0104746:	6a 02                	push   $0x2
c0104748:	68 00 01 00 00       	push   $0x100
c010474d:	ff 75 e0             	pushl  -0x20(%ebp)
c0104750:	50                   	push   %eax
c0104751:	e8 58 f7 ff ff       	call   c0103eae <page_insert>
c0104756:	83 c4 10             	add    $0x10,%esp
c0104759:	85 c0                	test   %eax,%eax
c010475b:	74 19                	je     c0104776 <check_boot_pgdir+0x18e>
c010475d:	68 60 ac 10 c0       	push   $0xc010ac60
c0104762:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104767:	68 4a 02 00 00       	push   $0x24a
c010476c:	68 88 a8 10 c0       	push   $0xc010a888
c0104771:	e8 6e bc ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p) == 1);
c0104776:	83 ec 0c             	sub    $0xc,%esp
c0104779:	ff 75 e0             	pushl  -0x20(%ebp)
c010477c:	e8 00 ec ff ff       	call   c0103381 <page_ref>
c0104781:	83 c4 10             	add    $0x10,%esp
c0104784:	83 f8 01             	cmp    $0x1,%eax
c0104787:	74 19                	je     c01047a2 <check_boot_pgdir+0x1ba>
c0104789:	68 8e ac 10 c0       	push   $0xc010ac8e
c010478e:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104793:	68 4b 02 00 00       	push   $0x24b
c0104798:	68 88 a8 10 c0       	push   $0xc010a888
c010479d:	e8 42 bc ff ff       	call   c01003e4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01047a2:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01047a7:	6a 02                	push   $0x2
c01047a9:	68 00 11 00 00       	push   $0x1100
c01047ae:	ff 75 e0             	pushl  -0x20(%ebp)
c01047b1:	50                   	push   %eax
c01047b2:	e8 f7 f6 ff ff       	call   c0103eae <page_insert>
c01047b7:	83 c4 10             	add    $0x10,%esp
c01047ba:	85 c0                	test   %eax,%eax
c01047bc:	74 19                	je     c01047d7 <check_boot_pgdir+0x1ef>
c01047be:	68 a0 ac 10 c0       	push   $0xc010aca0
c01047c3:	68 ad a8 10 c0       	push   $0xc010a8ad
c01047c8:	68 4c 02 00 00       	push   $0x24c
c01047cd:	68 88 a8 10 c0       	push   $0xc010a888
c01047d2:	e8 0d bc ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p) == 2);
c01047d7:	83 ec 0c             	sub    $0xc,%esp
c01047da:	ff 75 e0             	pushl  -0x20(%ebp)
c01047dd:	e8 9f eb ff ff       	call   c0103381 <page_ref>
c01047e2:	83 c4 10             	add    $0x10,%esp
c01047e5:	83 f8 02             	cmp    $0x2,%eax
c01047e8:	74 19                	je     c0104803 <check_boot_pgdir+0x21b>
c01047ea:	68 d7 ac 10 c0       	push   $0xc010acd7
c01047ef:	68 ad a8 10 c0       	push   $0xc010a8ad
c01047f4:	68 4d 02 00 00       	push   $0x24d
c01047f9:	68 88 a8 10 c0       	push   $0xc010a888
c01047fe:	e8 e1 bb ff ff       	call   c01003e4 <__panic>

    const char *str = "ucore: Hello world!!";
c0104803:	c7 45 dc e8 ac 10 c0 	movl   $0xc010ace8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010480a:	83 ec 08             	sub    $0x8,%esp
c010480d:	ff 75 dc             	pushl  -0x24(%ebp)
c0104810:	68 00 01 00 00       	push   $0x100
c0104815:	e8 73 4b 00 00       	call   c010938d <strcpy>
c010481a:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010481d:	83 ec 08             	sub    $0x8,%esp
c0104820:	68 00 11 00 00       	push   $0x1100
c0104825:	68 00 01 00 00       	push   $0x100
c010482a:	e8 d8 4b 00 00       	call   c0109407 <strcmp>
c010482f:	83 c4 10             	add    $0x10,%esp
c0104832:	85 c0                	test   %eax,%eax
c0104834:	74 19                	je     c010484f <check_boot_pgdir+0x267>
c0104836:	68 00 ad 10 c0       	push   $0xc010ad00
c010483b:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104840:	68 51 02 00 00       	push   $0x251
c0104845:	68 88 a8 10 c0       	push   $0xc010a888
c010484a:	e8 95 bb ff ff       	call   c01003e4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010484f:	83 ec 0c             	sub    $0xc,%esp
c0104852:	ff 75 e0             	pushl  -0x20(%ebp)
c0104855:	e8 8c ea ff ff       	call   c01032e6 <page2kva>
c010485a:	83 c4 10             	add    $0x10,%esp
c010485d:	05 00 01 00 00       	add    $0x100,%eax
c0104862:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104865:	83 ec 0c             	sub    $0xc,%esp
c0104868:	68 00 01 00 00       	push   $0x100
c010486d:	e8 c3 4a 00 00       	call   c0109335 <strlen>
c0104872:	83 c4 10             	add    $0x10,%esp
c0104875:	85 c0                	test   %eax,%eax
c0104877:	74 19                	je     c0104892 <check_boot_pgdir+0x2aa>
c0104879:	68 38 ad 10 c0       	push   $0xc010ad38
c010487e:	68 ad a8 10 c0       	push   $0xc010a8ad
c0104883:	68 54 02 00 00       	push   $0x254
c0104888:	68 88 a8 10 c0       	push   $0xc010a888
c010488d:	e8 52 bb ff ff       	call   c01003e4 <__panic>

    free_page(p);
c0104892:	83 ec 08             	sub    $0x8,%esp
c0104895:	6a 01                	push   $0x1
c0104897:	ff 75 e0             	pushl  -0x20(%ebp)
c010489a:	e8 5c ed ff ff       	call   c01035fb <free_pages>
c010489f:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c01048a2:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01048a7:	8b 00                	mov    (%eax),%eax
c01048a9:	83 ec 0c             	sub    $0xc,%esp
c01048ac:	50                   	push   %eax
c01048ad:	e8 b3 ea ff ff       	call   c0103365 <pde2page>
c01048b2:	83 c4 10             	add    $0x10,%esp
c01048b5:	83 ec 08             	sub    $0x8,%esp
c01048b8:	6a 01                	push   $0x1
c01048ba:	50                   	push   %eax
c01048bb:	e8 3b ed ff ff       	call   c01035fb <free_pages>
c01048c0:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01048c3:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01048c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01048ce:	83 ec 0c             	sub    $0xc,%esp
c01048d1:	68 5c ad 10 c0       	push   $0xc010ad5c
c01048d6:	e8 a3 b9 ff ff       	call   c010027e <cprintf>
c01048db:	83 c4 10             	add    $0x10,%esp
}
c01048de:	90                   	nop
c01048df:	c9                   	leave  
c01048e0:	c3                   	ret    

c01048e1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01048e1:	55                   	push   %ebp
c01048e2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01048e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e7:	83 e0 04             	and    $0x4,%eax
c01048ea:	85 c0                	test   %eax,%eax
c01048ec:	74 07                	je     c01048f5 <perm2str+0x14>
c01048ee:	b8 75 00 00 00       	mov    $0x75,%eax
c01048f3:	eb 05                	jmp    c01048fa <perm2str+0x19>
c01048f5:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01048fa:	a2 c8 7a 12 c0       	mov    %al,0xc0127ac8
    str[1] = 'r';
c01048ff:	c6 05 c9 7a 12 c0 72 	movb   $0x72,0xc0127ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104906:	8b 45 08             	mov    0x8(%ebp),%eax
c0104909:	83 e0 02             	and    $0x2,%eax
c010490c:	85 c0                	test   %eax,%eax
c010490e:	74 07                	je     c0104917 <perm2str+0x36>
c0104910:	b8 77 00 00 00       	mov    $0x77,%eax
c0104915:	eb 05                	jmp    c010491c <perm2str+0x3b>
c0104917:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010491c:	a2 ca 7a 12 c0       	mov    %al,0xc0127aca
    str[3] = '\0';
c0104921:	c6 05 cb 7a 12 c0 00 	movb   $0x0,0xc0127acb
    return str;
c0104928:	b8 c8 7a 12 c0       	mov    $0xc0127ac8,%eax
}
c010492d:	5d                   	pop    %ebp
c010492e:	c3                   	ret    

c010492f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010492f:	55                   	push   %ebp
c0104930:	89 e5                	mov    %esp,%ebp
c0104932:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104935:	8b 45 10             	mov    0x10(%ebp),%eax
c0104938:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010493b:	72 0e                	jb     c010494b <get_pgtable_items+0x1c>
        return 0;
c010493d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104942:	e9 9a 00 00 00       	jmp    c01049e1 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104947:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010494b:	8b 45 10             	mov    0x10(%ebp),%eax
c010494e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104951:	73 18                	jae    c010496b <get_pgtable_items+0x3c>
c0104953:	8b 45 10             	mov    0x10(%ebp),%eax
c0104956:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010495d:	8b 45 14             	mov    0x14(%ebp),%eax
c0104960:	01 d0                	add    %edx,%eax
c0104962:	8b 00                	mov    (%eax),%eax
c0104964:	83 e0 01             	and    $0x1,%eax
c0104967:	85 c0                	test   %eax,%eax
c0104969:	74 dc                	je     c0104947 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c010496b:	8b 45 10             	mov    0x10(%ebp),%eax
c010496e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104971:	73 69                	jae    c01049dc <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0104973:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104977:	74 08                	je     c0104981 <get_pgtable_items+0x52>
            *left_store = start;
c0104979:	8b 45 18             	mov    0x18(%ebp),%eax
c010497c:	8b 55 10             	mov    0x10(%ebp),%edx
c010497f:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104981:	8b 45 10             	mov    0x10(%ebp),%eax
c0104984:	8d 50 01             	lea    0x1(%eax),%edx
c0104987:	89 55 10             	mov    %edx,0x10(%ebp)
c010498a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104991:	8b 45 14             	mov    0x14(%ebp),%eax
c0104994:	01 d0                	add    %edx,%eax
c0104996:	8b 00                	mov    (%eax),%eax
c0104998:	83 e0 07             	and    $0x7,%eax
c010499b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010499e:	eb 04                	jmp    c01049a4 <get_pgtable_items+0x75>
            start ++;
c01049a0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01049a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01049a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01049aa:	73 1d                	jae    c01049c9 <get_pgtable_items+0x9a>
c01049ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01049af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01049b6:	8b 45 14             	mov    0x14(%ebp),%eax
c01049b9:	01 d0                	add    %edx,%eax
c01049bb:	8b 00                	mov    (%eax),%eax
c01049bd:	83 e0 07             	and    $0x7,%eax
c01049c0:	89 c2                	mov    %eax,%edx
c01049c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01049c5:	39 c2                	cmp    %eax,%edx
c01049c7:	74 d7                	je     c01049a0 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c01049c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01049cd:	74 08                	je     c01049d7 <get_pgtable_items+0xa8>
            *right_store = start;
c01049cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01049d2:	8b 55 10             	mov    0x10(%ebp),%edx
c01049d5:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01049d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01049da:	eb 05                	jmp    c01049e1 <get_pgtable_items+0xb2>
    }
    return 0;
c01049dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01049e1:	c9                   	leave  
c01049e2:	c3                   	ret    

c01049e3 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01049e3:	55                   	push   %ebp
c01049e4:	89 e5                	mov    %esp,%ebp
c01049e6:	57                   	push   %edi
c01049e7:	56                   	push   %esi
c01049e8:	53                   	push   %ebx
c01049e9:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01049ec:	83 ec 0c             	sub    $0xc,%esp
c01049ef:	68 7c ad 10 c0       	push   $0xc010ad7c
c01049f4:	e8 85 b8 ff ff       	call   c010027e <cprintf>
c01049f9:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01049fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104a03:	e9 e5 00 00 00       	jmp    c0104aed <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a0b:	83 ec 0c             	sub    $0xc,%esp
c0104a0e:	50                   	push   %eax
c0104a0f:	e8 cd fe ff ff       	call   c01048e1 <perm2str>
c0104a14:	83 c4 10             	add    $0x10,%esp
c0104a17:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104a19:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a1f:	29 c2                	sub    %eax,%edx
c0104a21:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104a23:	c1 e0 16             	shl    $0x16,%eax
c0104a26:	89 c3                	mov    %eax,%ebx
c0104a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a2b:	c1 e0 16             	shl    $0x16,%eax
c0104a2e:	89 c1                	mov    %eax,%ecx
c0104a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a33:	c1 e0 16             	shl    $0x16,%eax
c0104a36:	89 c2                	mov    %eax,%edx
c0104a38:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0104a3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a3e:	29 c6                	sub    %eax,%esi
c0104a40:	89 f0                	mov    %esi,%eax
c0104a42:	83 ec 08             	sub    $0x8,%esp
c0104a45:	57                   	push   %edi
c0104a46:	53                   	push   %ebx
c0104a47:	51                   	push   %ecx
c0104a48:	52                   	push   %edx
c0104a49:	50                   	push   %eax
c0104a4a:	68 ad ad 10 c0       	push   $0xc010adad
c0104a4f:	e8 2a b8 ff ff       	call   c010027e <cprintf>
c0104a54:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a5a:	c1 e0 0a             	shl    $0xa,%eax
c0104a5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104a60:	eb 4f                	jmp    c0104ab1 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a65:	83 ec 0c             	sub    $0xc,%esp
c0104a68:	50                   	push   %eax
c0104a69:	e8 73 fe ff ff       	call   c01048e1 <perm2str>
c0104a6e:	83 c4 10             	add    $0x10,%esp
c0104a71:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104a73:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a76:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104a79:	29 c2                	sub    %eax,%edx
c0104a7b:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104a7d:	c1 e0 0c             	shl    $0xc,%eax
c0104a80:	89 c3                	mov    %eax,%ebx
c0104a82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104a85:	c1 e0 0c             	shl    $0xc,%eax
c0104a88:	89 c1                	mov    %eax,%ecx
c0104a8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104a8d:	c1 e0 0c             	shl    $0xc,%eax
c0104a90:	89 c2                	mov    %eax,%edx
c0104a92:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0104a95:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104a98:	29 c6                	sub    %eax,%esi
c0104a9a:	89 f0                	mov    %esi,%eax
c0104a9c:	83 ec 08             	sub    $0x8,%esp
c0104a9f:	57                   	push   %edi
c0104aa0:	53                   	push   %ebx
c0104aa1:	51                   	push   %ecx
c0104aa2:	52                   	push   %edx
c0104aa3:	50                   	push   %eax
c0104aa4:	68 cc ad 10 c0       	push   $0xc010adcc
c0104aa9:	e8 d0 b7 ff ff       	call   c010027e <cprintf>
c0104aae:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104ab1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104ab6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104ab9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104abc:	89 d3                	mov    %edx,%ebx
c0104abe:	c1 e3 0a             	shl    $0xa,%ebx
c0104ac1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ac4:	89 d1                	mov    %edx,%ecx
c0104ac6:	c1 e1 0a             	shl    $0xa,%ecx
c0104ac9:	83 ec 08             	sub    $0x8,%esp
c0104acc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104acf:	52                   	push   %edx
c0104ad0:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104ad3:	52                   	push   %edx
c0104ad4:	56                   	push   %esi
c0104ad5:	50                   	push   %eax
c0104ad6:	53                   	push   %ebx
c0104ad7:	51                   	push   %ecx
c0104ad8:	e8 52 fe ff ff       	call   c010492f <get_pgtable_items>
c0104add:	83 c4 20             	add    $0x20,%esp
c0104ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ae3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104ae7:	0f 85 75 ff ff ff    	jne    c0104a62 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104aed:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104af2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104af5:	83 ec 08             	sub    $0x8,%esp
c0104af8:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104afb:	52                   	push   %edx
c0104afc:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104aff:	52                   	push   %edx
c0104b00:	51                   	push   %ecx
c0104b01:	50                   	push   %eax
c0104b02:	68 00 04 00 00       	push   $0x400
c0104b07:	6a 00                	push   $0x0
c0104b09:	e8 21 fe ff ff       	call   c010492f <get_pgtable_items>
c0104b0e:	83 c4 20             	add    $0x20,%esp
c0104b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104b18:	0f 85 ea fe ff ff    	jne    c0104a08 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104b1e:	83 ec 0c             	sub    $0xc,%esp
c0104b21:	68 f0 ad 10 c0       	push   $0xc010adf0
c0104b26:	e8 53 b7 ff ff       	call   c010027e <cprintf>
c0104b2b:	83 c4 10             	add    $0x10,%esp
}
c0104b2e:	90                   	nop
c0104b2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104b32:	5b                   	pop    %ebx
c0104b33:	5e                   	pop    %esi
c0104b34:	5f                   	pop    %edi
c0104b35:	5d                   	pop    %ebp
c0104b36:	c3                   	ret    

c0104b37 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b37:	55                   	push   %ebp
c0104b38:	89 e5                	mov    %esp,%ebp
c0104b3a:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0104b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b40:	c1 e8 0c             	shr    $0xc,%eax
c0104b43:	89 c2                	mov    %eax,%edx
c0104b45:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0104b4a:	39 c2                	cmp    %eax,%edx
c0104b4c:	72 14                	jb     c0104b62 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0104b4e:	83 ec 04             	sub    $0x4,%esp
c0104b51:	68 24 ae 10 c0       	push   $0xc010ae24
c0104b56:	6a 5f                	push   $0x5f
c0104b58:	68 43 ae 10 c0       	push   $0xc010ae43
c0104b5d:	e8 82 b8 ff ff       	call   c01003e4 <__panic>
    }
    return &pages[PPN(pa)];
c0104b62:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c0104b67:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b6a:	c1 ea 0c             	shr    $0xc,%edx
c0104b6d:	c1 e2 05             	shl    $0x5,%edx
c0104b70:	01 d0                	add    %edx,%eax
}
c0104b72:	c9                   	leave  
c0104b73:	c3                   	ret    

c0104b74 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0104b74:	55                   	push   %ebp
c0104b75:	89 e5                	mov    %esp,%ebp
c0104b77:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0104b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b82:	83 ec 0c             	sub    $0xc,%esp
c0104b85:	50                   	push   %eax
c0104b86:	e8 ac ff ff ff       	call   c0104b37 <pa2page>
c0104b8b:	83 c4 10             	add    $0x10,%esp
}
c0104b8e:	c9                   	leave  
c0104b8f:	c3                   	ret    

c0104b90 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0104b90:	55                   	push   %ebp
c0104b91:	89 e5                	mov    %esp,%ebp
c0104b93:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0104b96:	83 ec 0c             	sub    $0xc,%esp
c0104b99:	6a 18                	push   $0x18
c0104b9b:	e8 ef 1d 00 00       	call   c010698f <kmalloc>
c0104ba0:	83 c4 10             	add    $0x10,%esp
c0104ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0104ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104baa:	74 5b                	je     c0104c07 <mm_create+0x77>
        list_init(&(mm->mmap_list));
c0104bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104bb8:	89 50 04             	mov    %edx,0x4(%eax)
c0104bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bbe:	8b 50 04             	mov    0x4(%eax),%edx
c0104bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bc4:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0104bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bd3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0104bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bdd:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0104be4:	a1 d0 7a 12 c0       	mov    0xc0127ad0,%eax
c0104be9:	85 c0                	test   %eax,%eax
c0104beb:	74 10                	je     c0104bfd <mm_create+0x6d>
c0104bed:	83 ec 0c             	sub    $0xc,%esp
c0104bf0:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bf3:	e8 16 0c 00 00       	call   c010580e <swap_init_mm>
c0104bf8:	83 c4 10             	add    $0x10,%esp
c0104bfb:	eb 0a                	jmp    c0104c07 <mm_create+0x77>
        else mm->sm_priv = NULL;
c0104bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c00:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0104c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104c0a:	c9                   	leave  
c0104c0b:	c3                   	ret    

c0104c0c <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0104c0c:	55                   	push   %ebp
c0104c0d:	89 e5                	mov    %esp,%ebp
c0104c0f:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0104c12:	83 ec 0c             	sub    $0xc,%esp
c0104c15:	6a 18                	push   $0x18
c0104c17:	e8 73 1d 00 00       	call   c010698f <kmalloc>
c0104c1c:	83 c4 10             	add    $0x10,%esp
c0104c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0104c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c26:	74 1b                	je     c0104c43 <vma_create+0x37>
        vma->vm_start = vm_start;
c0104c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c2b:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c2e:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0104c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c34:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c37:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0104c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c3d:	8b 55 10             	mov    0x10(%ebp),%edx
c0104c40:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0104c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104c46:	c9                   	leave  
c0104c47:	c3                   	ret    

c0104c48 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0104c48:	55                   	push   %ebp
c0104c49:	89 e5                	mov    %esp,%ebp
c0104c4b:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0104c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0104c55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104c59:	0f 84 95 00 00 00    	je     c0104cf4 <find_vma+0xac>
        vma = mm->mmap_cache;
c0104c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c62:	8b 40 08             	mov    0x8(%eax),%eax
c0104c65:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0104c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104c6c:	74 16                	je     c0104c84 <find_vma+0x3c>
c0104c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104c71:	8b 40 04             	mov    0x4(%eax),%eax
c0104c74:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c77:	77 0b                	ja     c0104c84 <find_vma+0x3c>
c0104c79:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104c7c:	8b 40 08             	mov    0x8(%eax),%eax
c0104c7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104c82:	77 61                	ja     c0104ce5 <find_vma+0x9d>
                bool found = 0;
c0104c84:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0104c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0104c97:	eb 28                	jmp    c0104cc1 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0104c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c9c:	83 e8 10             	sub    $0x10,%eax
c0104c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0104ca2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104ca5:	8b 40 04             	mov    0x4(%eax),%eax
c0104ca8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104cab:	77 14                	ja     c0104cc1 <find_vma+0x79>
c0104cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104cb0:	8b 40 08             	mov    0x8(%eax),%eax
c0104cb3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104cb6:	76 09                	jbe    c0104cc1 <find_vma+0x79>
                        found = 1;
c0104cb8:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0104cbf:	eb 17                	jmp    c0104cd8 <find_vma+0x90>
c0104cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cca:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0104ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104cd6:	75 c1                	jne    c0104c99 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0104cd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0104cdc:	75 07                	jne    c0104ce5 <find_vma+0x9d>
                    vma = NULL;
c0104cde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0104ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104ce9:	74 09                	je     c0104cf4 <find_vma+0xac>
            mm->mmap_cache = vma;
c0104ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cee:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104cf1:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0104cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104cf7:	c9                   	leave  
c0104cf8:	c3                   	ret    

c0104cf9 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0104cf9:	55                   	push   %ebp
c0104cfa:	89 e5                	mov    %esp,%ebp
c0104cfc:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c0104cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d02:	8b 50 04             	mov    0x4(%eax),%edx
c0104d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d08:	8b 40 08             	mov    0x8(%eax),%eax
c0104d0b:	39 c2                	cmp    %eax,%edx
c0104d0d:	72 16                	jb     c0104d25 <check_vma_overlap+0x2c>
c0104d0f:	68 51 ae 10 c0       	push   $0xc010ae51
c0104d14:	68 6f ae 10 c0       	push   $0xc010ae6f
c0104d19:	6a 68                	push   $0x68
c0104d1b:	68 84 ae 10 c0       	push   $0xc010ae84
c0104d20:	e8 bf b6 ff ff       	call   c01003e4 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0104d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d28:	8b 50 08             	mov    0x8(%eax),%edx
c0104d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d2e:	8b 40 04             	mov    0x4(%eax),%eax
c0104d31:	39 c2                	cmp    %eax,%edx
c0104d33:	76 16                	jbe    c0104d4b <check_vma_overlap+0x52>
c0104d35:	68 94 ae 10 c0       	push   $0xc010ae94
c0104d3a:	68 6f ae 10 c0       	push   $0xc010ae6f
c0104d3f:	6a 69                	push   $0x69
c0104d41:	68 84 ae 10 c0       	push   $0xc010ae84
c0104d46:	e8 99 b6 ff ff       	call   c01003e4 <__panic>
    assert(next->vm_start < next->vm_end);
c0104d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d4e:	8b 50 04             	mov    0x4(%eax),%edx
c0104d51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d54:	8b 40 08             	mov    0x8(%eax),%eax
c0104d57:	39 c2                	cmp    %eax,%edx
c0104d59:	72 16                	jb     c0104d71 <check_vma_overlap+0x78>
c0104d5b:	68 b3 ae 10 c0       	push   $0xc010aeb3
c0104d60:	68 6f ae 10 c0       	push   $0xc010ae6f
c0104d65:	6a 6a                	push   $0x6a
c0104d67:	68 84 ae 10 c0       	push   $0xc010ae84
c0104d6c:	e8 73 b6 ff ff       	call   c01003e4 <__panic>
}
c0104d71:	90                   	nop
c0104d72:	c9                   	leave  
c0104d73:	c3                   	ret    

c0104d74 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0104d74:	55                   	push   %ebp
c0104d75:	89 e5                	mov    %esp,%ebp
c0104d77:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c0104d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d7d:	8b 50 04             	mov    0x4(%eax),%edx
c0104d80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d83:	8b 40 08             	mov    0x8(%eax),%eax
c0104d86:	39 c2                	cmp    %eax,%edx
c0104d88:	72 16                	jb     c0104da0 <insert_vma_struct+0x2c>
c0104d8a:	68 d1 ae 10 c0       	push   $0xc010aed1
c0104d8f:	68 6f ae 10 c0       	push   $0xc010ae6f
c0104d94:	6a 71                	push   $0x71
c0104d96:	68 84 ae 10 c0       	push   $0xc010ae84
c0104d9b:	e8 44 b6 ff ff       	call   c01003e4 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0104da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104da3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0104da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104da9:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0104dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0104db2:	eb 1f                	jmp    c0104dd3 <insert_vma_struct+0x5f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0104db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104db7:	83 e8 10             	sub    $0x10,%eax
c0104dba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0104dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc0:	8b 50 04             	mov    0x4(%eax),%edx
c0104dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104dc6:	8b 40 04             	mov    0x4(%eax),%eax
c0104dc9:	39 c2                	cmp    %eax,%edx
c0104dcb:	77 1f                	ja     c0104dec <insert_vma_struct+0x78>
                break;
            }
            le_prev = le;
c0104dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104dd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ddc:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0104ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104de5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104de8:	75 ca                	jne    c0104db4 <insert_vma_struct+0x40>
c0104dea:	eb 01                	jmp    c0104ded <insert_vma_struct+0x79>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c0104dec:	90                   	nop
c0104ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104df6:	8b 40 04             	mov    0x4(%eax),%eax
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0104df9:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0104dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104e02:	74 15                	je     c0104e19 <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0104e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e07:	83 e8 10             	sub    $0x10,%eax
c0104e0a:	83 ec 08             	sub    $0x8,%esp
c0104e0d:	ff 75 0c             	pushl  0xc(%ebp)
c0104e10:	50                   	push   %eax
c0104e11:	e8 e3 fe ff ff       	call   c0104cf9 <check_vma_overlap>
c0104e16:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c0104e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e1c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104e1f:	74 15                	je     c0104e36 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0104e21:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e24:	83 e8 10             	sub    $0x10,%eax
c0104e27:	83 ec 08             	sub    $0x8,%esp
c0104e2a:	50                   	push   %eax
c0104e2b:	ff 75 0c             	pushl  0xc(%ebp)
c0104e2e:	e8 c6 fe ff ff       	call   c0104cf9 <check_vma_overlap>
c0104e33:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c0104e36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e39:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e3c:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0104e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e41:	8d 50 10             	lea    0x10(%eax),%edx
c0104e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e50:	8b 40 04             	mov    0x4(%eax),%eax
c0104e53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e56:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104e59:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e5c:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104e5f:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104e62:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104e65:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104e68:	89 10                	mov    %edx,(%eax)
c0104e6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104e6d:	8b 10                	mov    (%eax),%edx
c0104e6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104e72:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104e75:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e78:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104e7b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e81:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104e84:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0104e86:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e89:	8b 40 10             	mov    0x10(%eax),%eax
c0104e8c:	8d 50 01             	lea    0x1(%eax),%edx
c0104e8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e92:	89 50 10             	mov    %edx,0x10(%eax)
}
c0104e95:	90                   	nop
c0104e96:	c9                   	leave  
c0104e97:	c3                   	ret    

c0104e98 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0104e98:	55                   	push   %ebp
c0104e99:	89 e5                	mov    %esp,%ebp
c0104e9b:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0104e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0104ea4:	eb 3a                	jmp    c0104ee0 <mm_destroy+0x48>
c0104ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ea9:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eaf:	8b 40 04             	mov    0x4(%eax),%eax
c0104eb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104eb5:	8b 12                	mov    (%edx),%edx
c0104eb7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104eba:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ec0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ec3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ecc:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0104ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ed1:	83 e8 10             	sub    $0x10,%eax
c0104ed4:	83 ec 0c             	sub    $0xc,%esp
c0104ed7:	50                   	push   %eax
c0104ed8:	e8 ca 1a 00 00       	call   c01069a7 <kfree>
c0104edd:	83 c4 10             	add    $0x10,%esp
c0104ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ee3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ee9:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0104eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ef5:	75 af                	jne    c0104ea6 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0104ef7:	83 ec 0c             	sub    $0xc,%esp
c0104efa:	ff 75 08             	pushl  0x8(%ebp)
c0104efd:	e8 a5 1a 00 00       	call   c01069a7 <kfree>
c0104f02:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c0104f05:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0104f0c:	90                   	nop
c0104f0d:	c9                   	leave  
c0104f0e:	c3                   	ret    

c0104f0f <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0104f0f:	55                   	push   %ebp
c0104f10:	89 e5                	mov    %esp,%ebp
c0104f12:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0104f15:	e8 03 00 00 00       	call   c0104f1d <check_vmm>
}
c0104f1a:	90                   	nop
c0104f1b:	c9                   	leave  
c0104f1c:	c3                   	ret    

c0104f1d <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0104f1d:	55                   	push   %ebp
c0104f1e:	89 e5                	mov    %esp,%ebp
c0104f20:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0104f23:	e8 08 e7 ff ff       	call   c0103630 <nr_free_pages>
c0104f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0104f2b:	e8 18 00 00 00       	call   c0104f48 <check_vma_struct>
    check_pgfault();
c0104f30:	e8 10 04 00 00       	call   c0105345 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0104f35:	83 ec 0c             	sub    $0xc,%esp
c0104f38:	68 ed ae 10 c0       	push   $0xc010aeed
c0104f3d:	e8 3c b3 ff ff       	call   c010027e <cprintf>
c0104f42:	83 c4 10             	add    $0x10,%esp
}
c0104f45:	90                   	nop
c0104f46:	c9                   	leave  
c0104f47:	c3                   	ret    

c0104f48 <check_vma_struct>:

static void
check_vma_struct(void) {
c0104f48:	55                   	push   %ebp
c0104f49:	89 e5                	mov    %esp,%ebp
c0104f4b:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0104f4e:	e8 dd e6 ff ff       	call   c0103630 <nr_free_pages>
c0104f53:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0104f56:	e8 35 fc ff ff       	call   c0104b90 <mm_create>
c0104f5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0104f5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f62:	75 19                	jne    c0104f7d <check_vma_struct+0x35>
c0104f64:	68 05 af 10 c0       	push   $0xc010af05
c0104f69:	68 6f ae 10 c0       	push   $0xc010ae6f
c0104f6e:	68 b2 00 00 00       	push   $0xb2
c0104f73:	68 84 ae 10 c0       	push   $0xc010ae84
c0104f78:	e8 67 b4 ff ff       	call   c01003e4 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0104f7d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0104f84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f87:	89 d0                	mov    %edx,%eax
c0104f89:	c1 e0 02             	shl    $0x2,%eax
c0104f8c:	01 d0                	add    %edx,%eax
c0104f8e:	01 c0                	add    %eax,%eax
c0104f90:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0104f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f99:	eb 5f                	jmp    c0104ffa <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0104f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f9e:	89 d0                	mov    %edx,%eax
c0104fa0:	c1 e0 02             	shl    $0x2,%eax
c0104fa3:	01 d0                	add    %edx,%eax
c0104fa5:	83 c0 02             	add    $0x2,%eax
c0104fa8:	89 c1                	mov    %eax,%ecx
c0104faa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104fad:	89 d0                	mov    %edx,%eax
c0104faf:	c1 e0 02             	shl    $0x2,%eax
c0104fb2:	01 d0                	add    %edx,%eax
c0104fb4:	83 ec 04             	sub    $0x4,%esp
c0104fb7:	6a 00                	push   $0x0
c0104fb9:	51                   	push   %ecx
c0104fba:	50                   	push   %eax
c0104fbb:	e8 4c fc ff ff       	call   c0104c0c <vma_create>
c0104fc0:	83 c4 10             	add    $0x10,%esp
c0104fc3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0104fc6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104fca:	75 19                	jne    c0104fe5 <check_vma_struct+0x9d>
c0104fcc:	68 10 af 10 c0       	push   $0xc010af10
c0104fd1:	68 6f ae 10 c0       	push   $0xc010ae6f
c0104fd6:	68 b9 00 00 00       	push   $0xb9
c0104fdb:	68 84 ae 10 c0       	push   $0xc010ae84
c0104fe0:	e8 ff b3 ff ff       	call   c01003e4 <__panic>
        insert_vma_struct(mm, vma);
c0104fe5:	83 ec 08             	sub    $0x8,%esp
c0104fe8:	ff 75 dc             	pushl  -0x24(%ebp)
c0104feb:	ff 75 e8             	pushl  -0x18(%ebp)
c0104fee:	e8 81 fd ff ff       	call   c0104d74 <insert_vma_struct>
c0104ff3:	83 c4 10             	add    $0x10,%esp
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0104ff6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ffe:	7f 9b                	jg     c0104f9b <check_vma_struct+0x53>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0105000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105003:	83 c0 01             	add    $0x1,%eax
c0105006:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105009:	eb 5f                	jmp    c010506a <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010500b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010500e:	89 d0                	mov    %edx,%eax
c0105010:	c1 e0 02             	shl    $0x2,%eax
c0105013:	01 d0                	add    %edx,%eax
c0105015:	83 c0 02             	add    $0x2,%eax
c0105018:	89 c1                	mov    %eax,%ecx
c010501a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010501d:	89 d0                	mov    %edx,%eax
c010501f:	c1 e0 02             	shl    $0x2,%eax
c0105022:	01 d0                	add    %edx,%eax
c0105024:	83 ec 04             	sub    $0x4,%esp
c0105027:	6a 00                	push   $0x0
c0105029:	51                   	push   %ecx
c010502a:	50                   	push   %eax
c010502b:	e8 dc fb ff ff       	call   c0104c0c <vma_create>
c0105030:	83 c4 10             	add    $0x10,%esp
c0105033:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0105036:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010503a:	75 19                	jne    c0105055 <check_vma_struct+0x10d>
c010503c:	68 10 af 10 c0       	push   $0xc010af10
c0105041:	68 6f ae 10 c0       	push   $0xc010ae6f
c0105046:	68 bf 00 00 00       	push   $0xbf
c010504b:	68 84 ae 10 c0       	push   $0xc010ae84
c0105050:	e8 8f b3 ff ff       	call   c01003e4 <__panic>
        insert_vma_struct(mm, vma);
c0105055:	83 ec 08             	sub    $0x8,%esp
c0105058:	ff 75 d8             	pushl  -0x28(%ebp)
c010505b:	ff 75 e8             	pushl  -0x18(%ebp)
c010505e:	e8 11 fd ff ff       	call   c0104d74 <insert_vma_struct>
c0105063:	83 c4 10             	add    $0x10,%esp
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0105066:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010506a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010506d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0105070:	7e 99                	jle    c010500b <check_vma_struct+0xc3>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0105072:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105075:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0105078:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010507b:	8b 40 04             	mov    0x4(%eax),%eax
c010507e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0105081:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0105088:	e9 81 00 00 00       	jmp    c010510e <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c010508d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105090:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105093:	75 19                	jne    c01050ae <check_vma_struct+0x166>
c0105095:	68 1c af 10 c0       	push   $0xc010af1c
c010509a:	68 6f ae 10 c0       	push   $0xc010ae6f
c010509f:	68 c6 00 00 00       	push   $0xc6
c01050a4:	68 84 ae 10 c0       	push   $0xc010ae84
c01050a9:	e8 36 b3 ff ff       	call   c01003e4 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01050ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050b1:	83 e8 10             	sub    $0x10,%eax
c01050b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c01050b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01050ba:	8b 48 04             	mov    0x4(%eax),%ecx
c01050bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050c0:	89 d0                	mov    %edx,%eax
c01050c2:	c1 e0 02             	shl    $0x2,%eax
c01050c5:	01 d0                	add    %edx,%eax
c01050c7:	39 c1                	cmp    %eax,%ecx
c01050c9:	75 17                	jne    c01050e2 <check_vma_struct+0x19a>
c01050cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01050ce:	8b 48 08             	mov    0x8(%eax),%ecx
c01050d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050d4:	89 d0                	mov    %edx,%eax
c01050d6:	c1 e0 02             	shl    $0x2,%eax
c01050d9:	01 d0                	add    %edx,%eax
c01050db:	83 c0 02             	add    $0x2,%eax
c01050de:	39 c1                	cmp    %eax,%ecx
c01050e0:	74 19                	je     c01050fb <check_vma_struct+0x1b3>
c01050e2:	68 34 af 10 c0       	push   $0xc010af34
c01050e7:	68 6f ae 10 c0       	push   $0xc010ae6f
c01050ec:	68 c8 00 00 00       	push   $0xc8
c01050f1:	68 84 ae 10 c0       	push   $0xc010ae84
c01050f6:	e8 e9 b2 ff ff       	call   c01003e4 <__panic>
c01050fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0105101:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105104:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105107:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c010510a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010510e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105111:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0105114:	0f 8e 73 ff ff ff    	jle    c010508d <check_vma_struct+0x145>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010511a:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0105121:	e9 80 01 00 00       	jmp    c01052a6 <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c0105126:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105129:	83 ec 08             	sub    $0x8,%esp
c010512c:	50                   	push   %eax
c010512d:	ff 75 e8             	pushl  -0x18(%ebp)
c0105130:	e8 13 fb ff ff       	call   c0104c48 <find_vma>
c0105135:	83 c4 10             	add    $0x10,%esp
c0105138:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c010513b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010513f:	75 19                	jne    c010515a <check_vma_struct+0x212>
c0105141:	68 69 af 10 c0       	push   $0xc010af69
c0105146:	68 6f ae 10 c0       	push   $0xc010ae6f
c010514b:	68 ce 00 00 00       	push   $0xce
c0105150:	68 84 ae 10 c0       	push   $0xc010ae84
c0105155:	e8 8a b2 ff ff       	call   c01003e4 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c010515a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010515d:	83 c0 01             	add    $0x1,%eax
c0105160:	83 ec 08             	sub    $0x8,%esp
c0105163:	50                   	push   %eax
c0105164:	ff 75 e8             	pushl  -0x18(%ebp)
c0105167:	e8 dc fa ff ff       	call   c0104c48 <find_vma>
c010516c:	83 c4 10             	add    $0x10,%esp
c010516f:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0105172:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105176:	75 19                	jne    c0105191 <check_vma_struct+0x249>
c0105178:	68 76 af 10 c0       	push   $0xc010af76
c010517d:	68 6f ae 10 c0       	push   $0xc010ae6f
c0105182:	68 d0 00 00 00       	push   $0xd0
c0105187:	68 84 ae 10 c0       	push   $0xc010ae84
c010518c:	e8 53 b2 ff ff       	call   c01003e4 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0105191:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105194:	83 c0 02             	add    $0x2,%eax
c0105197:	83 ec 08             	sub    $0x8,%esp
c010519a:	50                   	push   %eax
c010519b:	ff 75 e8             	pushl  -0x18(%ebp)
c010519e:	e8 a5 fa ff ff       	call   c0104c48 <find_vma>
c01051a3:	83 c4 10             	add    $0x10,%esp
c01051a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c01051a9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01051ad:	74 19                	je     c01051c8 <check_vma_struct+0x280>
c01051af:	68 83 af 10 c0       	push   $0xc010af83
c01051b4:	68 6f ae 10 c0       	push   $0xc010ae6f
c01051b9:	68 d2 00 00 00       	push   $0xd2
c01051be:	68 84 ae 10 c0       	push   $0xc010ae84
c01051c3:	e8 1c b2 ff ff       	call   c01003e4 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01051c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051cb:	83 c0 03             	add    $0x3,%eax
c01051ce:	83 ec 08             	sub    $0x8,%esp
c01051d1:	50                   	push   %eax
c01051d2:	ff 75 e8             	pushl  -0x18(%ebp)
c01051d5:	e8 6e fa ff ff       	call   c0104c48 <find_vma>
c01051da:	83 c4 10             	add    $0x10,%esp
c01051dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c01051e0:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01051e4:	74 19                	je     c01051ff <check_vma_struct+0x2b7>
c01051e6:	68 90 af 10 c0       	push   $0xc010af90
c01051eb:	68 6f ae 10 c0       	push   $0xc010ae6f
c01051f0:	68 d4 00 00 00       	push   $0xd4
c01051f5:	68 84 ae 10 c0       	push   $0xc010ae84
c01051fa:	e8 e5 b1 ff ff       	call   c01003e4 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01051ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105202:	83 c0 04             	add    $0x4,%eax
c0105205:	83 ec 08             	sub    $0x8,%esp
c0105208:	50                   	push   %eax
c0105209:	ff 75 e8             	pushl  -0x18(%ebp)
c010520c:	e8 37 fa ff ff       	call   c0104c48 <find_vma>
c0105211:	83 c4 10             	add    $0x10,%esp
c0105214:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c0105217:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010521b:	74 19                	je     c0105236 <check_vma_struct+0x2ee>
c010521d:	68 9d af 10 c0       	push   $0xc010af9d
c0105222:	68 6f ae 10 c0       	push   $0xc010ae6f
c0105227:	68 d6 00 00 00       	push   $0xd6
c010522c:	68 84 ae 10 c0       	push   $0xc010ae84
c0105231:	e8 ae b1 ff ff       	call   c01003e4 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0105236:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105239:	8b 50 04             	mov    0x4(%eax),%edx
c010523c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010523f:	39 c2                	cmp    %eax,%edx
c0105241:	75 10                	jne    c0105253 <check_vma_struct+0x30b>
c0105243:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105246:	8b 40 08             	mov    0x8(%eax),%eax
c0105249:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010524c:	83 c2 02             	add    $0x2,%edx
c010524f:	39 d0                	cmp    %edx,%eax
c0105251:	74 19                	je     c010526c <check_vma_struct+0x324>
c0105253:	68 ac af 10 c0       	push   $0xc010afac
c0105258:	68 6f ae 10 c0       	push   $0xc010ae6f
c010525d:	68 d8 00 00 00       	push   $0xd8
c0105262:	68 84 ae 10 c0       	push   $0xc010ae84
c0105267:	e8 78 b1 ff ff       	call   c01003e4 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010526c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010526f:	8b 50 04             	mov    0x4(%eax),%edx
c0105272:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105275:	39 c2                	cmp    %eax,%edx
c0105277:	75 10                	jne    c0105289 <check_vma_struct+0x341>
c0105279:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010527c:	8b 40 08             	mov    0x8(%eax),%eax
c010527f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105282:	83 c2 02             	add    $0x2,%edx
c0105285:	39 d0                	cmp    %edx,%eax
c0105287:	74 19                	je     c01052a2 <check_vma_struct+0x35a>
c0105289:	68 dc af 10 c0       	push   $0xc010afdc
c010528e:	68 6f ae 10 c0       	push   $0xc010ae6f
c0105293:	68 d9 00 00 00       	push   $0xd9
c0105298:	68 84 ae 10 c0       	push   $0xc010ae84
c010529d:	e8 42 b1 ff ff       	call   c01003e4 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01052a2:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01052a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052a9:	89 d0                	mov    %edx,%eax
c01052ab:	c1 e0 02             	shl    $0x2,%eax
c01052ae:	01 d0                	add    %edx,%eax
c01052b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01052b3:	0f 8d 6d fe ff ff    	jge    c0105126 <check_vma_struct+0x1de>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01052b9:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01052c0:	eb 5c                	jmp    c010531e <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01052c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052c5:	83 ec 08             	sub    $0x8,%esp
c01052c8:	50                   	push   %eax
c01052c9:	ff 75 e8             	pushl  -0x18(%ebp)
c01052cc:	e8 77 f9 ff ff       	call   c0104c48 <find_vma>
c01052d1:	83 c4 10             	add    $0x10,%esp
c01052d4:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c01052d7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01052db:	74 1e                	je     c01052fb <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01052dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01052e0:	8b 50 08             	mov    0x8(%eax),%edx
c01052e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01052e6:	8b 40 04             	mov    0x4(%eax),%eax
c01052e9:	52                   	push   %edx
c01052ea:	50                   	push   %eax
c01052eb:	ff 75 f4             	pushl  -0xc(%ebp)
c01052ee:	68 0c b0 10 c0       	push   $0xc010b00c
c01052f3:	e8 86 af ff ff       	call   c010027e <cprintf>
c01052f8:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c01052fb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01052ff:	74 19                	je     c010531a <check_vma_struct+0x3d2>
c0105301:	68 31 b0 10 c0       	push   $0xc010b031
c0105306:	68 6f ae 10 c0       	push   $0xc010ae6f
c010530b:	68 e1 00 00 00       	push   $0xe1
c0105310:	68 84 ae 10 c0       	push   $0xc010ae84
c0105315:	e8 ca b0 ff ff       	call   c01003e4 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010531a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010531e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105322:	79 9e                	jns    c01052c2 <check_vma_struct+0x37a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0105324:	83 ec 0c             	sub    $0xc,%esp
c0105327:	ff 75 e8             	pushl  -0x18(%ebp)
c010532a:	e8 69 fb ff ff       	call   c0104e98 <mm_destroy>
c010532f:	83 c4 10             	add    $0x10,%esp

    cprintf("check_vma_struct() succeeded!\n");
c0105332:	83 ec 0c             	sub    $0xc,%esp
c0105335:	68 48 b0 10 c0       	push   $0xc010b048
c010533a:	e8 3f af ff ff       	call   c010027e <cprintf>
c010533f:	83 c4 10             	add    $0x10,%esp
}
c0105342:	90                   	nop
c0105343:	c9                   	leave  
c0105344:	c3                   	ret    

c0105345 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0105345:	55                   	push   %ebp
c0105346:	89 e5                	mov    %esp,%ebp
c0105348:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010534b:	e8 e0 e2 ff ff       	call   c0103630 <nr_free_pages>
c0105350:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0105353:	e8 38 f8 ff ff       	call   c0104b90 <mm_create>
c0105358:	a3 24 9b 12 c0       	mov    %eax,0xc0129b24
    assert(check_mm_struct != NULL);
c010535d:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c0105362:	85 c0                	test   %eax,%eax
c0105364:	75 19                	jne    c010537f <check_pgfault+0x3a>
c0105366:	68 67 b0 10 c0       	push   $0xc010b067
c010536b:	68 6f ae 10 c0       	push   $0xc010ae6f
c0105370:	68 f1 00 00 00       	push   $0xf1
c0105375:	68 84 ae 10 c0       	push   $0xc010ae84
c010537a:	e8 65 b0 ff ff       	call   c01003e4 <__panic>

    struct mm_struct *mm = check_mm_struct;
c010537f:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c0105384:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0105387:	8b 15 44 7a 12 c0    	mov    0xc0127a44,%edx
c010538d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105390:	89 50 0c             	mov    %edx,0xc(%eax)
c0105393:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105396:	8b 40 0c             	mov    0xc(%eax),%eax
c0105399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010539c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010539f:	8b 00                	mov    (%eax),%eax
c01053a1:	85 c0                	test   %eax,%eax
c01053a3:	74 19                	je     c01053be <check_pgfault+0x79>
c01053a5:	68 7f b0 10 c0       	push   $0xc010b07f
c01053aa:	68 6f ae 10 c0       	push   $0xc010ae6f
c01053af:	68 f5 00 00 00       	push   $0xf5
c01053b4:	68 84 ae 10 c0       	push   $0xc010ae84
c01053b9:	e8 26 b0 ff ff       	call   c01003e4 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01053be:	83 ec 04             	sub    $0x4,%esp
c01053c1:	6a 02                	push   $0x2
c01053c3:	68 00 00 40 00       	push   $0x400000
c01053c8:	6a 00                	push   $0x0
c01053ca:	e8 3d f8 ff ff       	call   c0104c0c <vma_create>
c01053cf:	83 c4 10             	add    $0x10,%esp
c01053d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01053d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01053d9:	75 19                	jne    c01053f4 <check_pgfault+0xaf>
c01053db:	68 10 af 10 c0       	push   $0xc010af10
c01053e0:	68 6f ae 10 c0       	push   $0xc010ae6f
c01053e5:	68 f8 00 00 00       	push   $0xf8
c01053ea:	68 84 ae 10 c0       	push   $0xc010ae84
c01053ef:	e8 f0 af ff ff       	call   c01003e4 <__panic>

    insert_vma_struct(mm, vma);
c01053f4:	83 ec 08             	sub    $0x8,%esp
c01053f7:	ff 75 e0             	pushl  -0x20(%ebp)
c01053fa:	ff 75 e8             	pushl  -0x18(%ebp)
c01053fd:	e8 72 f9 ff ff       	call   c0104d74 <insert_vma_struct>
c0105402:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c0105405:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010540c:	83 ec 08             	sub    $0x8,%esp
c010540f:	ff 75 dc             	pushl  -0x24(%ebp)
c0105412:	ff 75 e8             	pushl  -0x18(%ebp)
c0105415:	e8 2e f8 ff ff       	call   c0104c48 <find_vma>
c010541a:	83 c4 10             	add    $0x10,%esp
c010541d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0105420:	74 19                	je     c010543b <check_pgfault+0xf6>
c0105422:	68 8d b0 10 c0       	push   $0xc010b08d
c0105427:	68 6f ae 10 c0       	push   $0xc010ae6f
c010542c:	68 fd 00 00 00       	push   $0xfd
c0105431:	68 84 ae 10 c0       	push   $0xc010ae84
c0105436:	e8 a9 af ff ff       	call   c01003e4 <__panic>

    int i, sum = 0;
c010543b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0105442:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105449:	eb 19                	jmp    c0105464 <check_pgfault+0x11f>
        *(char *)(addr + i) = i;
c010544b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010544e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105451:	01 d0                	add    %edx,%eax
c0105453:	89 c2                	mov    %eax,%edx
c0105455:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105458:	88 02                	mov    %al,(%edx)
        sum += i;
c010545a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010545d:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0105460:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105464:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0105468:	7e e1                	jle    c010544b <check_pgfault+0x106>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010546a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105471:	eb 15                	jmp    c0105488 <check_pgfault+0x143>
        sum -= *(char *)(addr + i);
c0105473:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105476:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105479:	01 d0                	add    %edx,%eax
c010547b:	0f b6 00             	movzbl (%eax),%eax
c010547e:	0f be c0             	movsbl %al,%eax
c0105481:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0105484:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105488:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010548c:	7e e5                	jle    c0105473 <check_pgfault+0x12e>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c010548e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105492:	74 19                	je     c01054ad <check_pgfault+0x168>
c0105494:	68 a7 b0 10 c0       	push   $0xc010b0a7
c0105499:	68 6f ae 10 c0       	push   $0xc010ae6f
c010549e:	68 07 01 00 00       	push   $0x107
c01054a3:	68 84 ae 10 c0       	push   $0xc010ae84
c01054a8:	e8 37 af ff ff       	call   c01003e4 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01054ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01054b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054bb:	83 ec 08             	sub    $0x8,%esp
c01054be:	50                   	push   %eax
c01054bf:	ff 75 e4             	pushl  -0x1c(%ebp)
c01054c2:	e8 ae e9 ff ff       	call   c0103e75 <page_remove>
c01054c7:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c01054ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054cd:	8b 00                	mov    (%eax),%eax
c01054cf:	83 ec 0c             	sub    $0xc,%esp
c01054d2:	50                   	push   %eax
c01054d3:	e8 9c f6 ff ff       	call   c0104b74 <pde2page>
c01054d8:	83 c4 10             	add    $0x10,%esp
c01054db:	83 ec 08             	sub    $0x8,%esp
c01054de:	6a 01                	push   $0x1
c01054e0:	50                   	push   %eax
c01054e1:	e8 15 e1 ff ff       	call   c01035fb <free_pages>
c01054e6:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c01054e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01054f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01054fc:	83 ec 0c             	sub    $0xc,%esp
c01054ff:	ff 75 e8             	pushl  -0x18(%ebp)
c0105502:	e8 91 f9 ff ff       	call   c0104e98 <mm_destroy>
c0105507:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c010550a:	c7 05 24 9b 12 c0 00 	movl   $0x0,0xc0129b24
c0105511:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0105514:	e8 17 e1 ff ff       	call   c0103630 <nr_free_pages>
c0105519:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010551c:	74 19                	je     c0105537 <check_pgfault+0x1f2>
c010551e:	68 b0 b0 10 c0       	push   $0xc010b0b0
c0105523:	68 6f ae 10 c0       	push   $0xc010ae6f
c0105528:	68 11 01 00 00       	push   $0x111
c010552d:	68 84 ae 10 c0       	push   $0xc010ae84
c0105532:	e8 ad ae ff ff       	call   c01003e4 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0105537:	83 ec 0c             	sub    $0xc,%esp
c010553a:	68 d7 b0 10 c0       	push   $0xc010b0d7
c010553f:	e8 3a ad ff ff       	call   c010027e <cprintf>
c0105544:	83 c4 10             	add    $0x10,%esp
}
c0105547:	90                   	nop
c0105548:	c9                   	leave  
c0105549:	c3                   	ret    

c010554a <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c010554a:	55                   	push   %ebp
c010554b:	89 e5                	mov    %esp,%ebp
c010554d:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c0105550:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0105557:	ff 75 10             	pushl  0x10(%ebp)
c010555a:	ff 75 08             	pushl  0x8(%ebp)
c010555d:	e8 e6 f6 ff ff       	call   c0104c48 <find_vma>
c0105562:	83 c4 08             	add    $0x8,%esp
c0105565:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0105568:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c010556d:	83 c0 01             	add    $0x1,%eax
c0105570:	a3 cc 7a 12 c0       	mov    %eax,0xc0127acc
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0105575:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105579:	74 0b                	je     c0105586 <do_pgfault+0x3c>
c010557b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010557e:	8b 40 04             	mov    0x4(%eax),%eax
c0105581:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105584:	76 18                	jbe    c010559e <do_pgfault+0x54>
        cprintf("not valid addr %x, and can not find it in vma\n", addr);
c0105586:	83 ec 08             	sub    $0x8,%esp
c0105589:	ff 75 10             	pushl  0x10(%ebp)
c010558c:	68 f4 b0 10 c0       	push   $0xc010b0f4
c0105591:	e8 e8 ac ff ff       	call   c010027e <cprintf>
c0105596:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0105599:	e9 71 01 00 00       	jmp    c010570f <do_pgfault+0x1c5>
    }
    //check the error_code
    // If you want to add/mofify perm on pages -> change VMA instead of PTE!
    switch (error_code & 3) {
c010559e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a1:	83 e0 03             	and    $0x3,%eax
c01055a4:	85 c0                	test   %eax,%eax
c01055a6:	74 3c                	je     c01055e4 <do_pgfault+0x9a>
c01055a8:	83 f8 01             	cmp    $0x1,%eax
c01055ab:	74 22                	je     c01055cf <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01055ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055b0:	8b 40 0c             	mov    0xc(%eax),%eax
c01055b3:	83 e0 02             	and    $0x2,%eax
c01055b6:	85 c0                	test   %eax,%eax
c01055b8:	75 4c                	jne    c0105606 <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01055ba:	83 ec 0c             	sub    $0xc,%esp
c01055bd:	68 24 b1 10 c0       	push   $0xc010b124
c01055c2:	e8 b7 ac ff ff       	call   c010027e <cprintf>
c01055c7:	83 c4 10             	add    $0x10,%esp
            goto failed;
c01055ca:	e9 40 01 00 00       	jmp    c010570f <do_pgfault+0x1c5>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01055cf:	83 ec 0c             	sub    $0xc,%esp
c01055d2:	68 84 b1 10 c0       	push   $0xc010b184
c01055d7:	e8 a2 ac ff ff       	call   c010027e <cprintf>
c01055dc:	83 c4 10             	add    $0x10,%esp
        goto failed;
c01055df:	e9 2b 01 00 00       	jmp    c010570f <do_pgfault+0x1c5>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01055e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055e7:	8b 40 0c             	mov    0xc(%eax),%eax
c01055ea:	83 e0 05             	and    $0x5,%eax
c01055ed:	85 c0                	test   %eax,%eax
c01055ef:	75 16                	jne    c0105607 <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01055f1:	83 ec 0c             	sub    $0xc,%esp
c01055f4:	68 bc b1 10 c0       	push   $0xc010b1bc
c01055f9:	e8 80 ac ff ff       	call   c010027e <cprintf>
c01055fe:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0105601:	e9 09 01 00 00       	jmp    c010570f <do_pgfault+0x1c5>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0105606:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0105607:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c010560e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105611:	8b 40 0c             	mov    0xc(%eax),%eax
c0105614:	83 e0 02             	and    $0x2,%eax
c0105617:	85 c0                	test   %eax,%eax
c0105619:	74 04                	je     c010561f <do_pgfault+0xd5>
        perm |= PTE_W;
c010561b:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c010561f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105622:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105625:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105628:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010562d:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0105630:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0105637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: 2014011330*/
    //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    ptep = get_pte(mm->pgdir, addr, 1);
c010563e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105641:	8b 40 0c             	mov    0xc(%eax),%eax
c0105644:	83 ec 04             	sub    $0x4,%esp
c0105647:	6a 01                	push   $0x1
c0105649:	ff 75 10             	pushl  0x10(%ebp)
c010564c:	50                   	push   %eax
c010564d:	e8 28 e6 ff ff       	call   c0103c7a <get_pte>
c0105652:	83 c4 10             	add    $0x10,%esp
c0105655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) {
c0105658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010565b:	8b 00                	mov    (%eax),%eax
c010565d:	85 c0                	test   %eax,%eax
c010565f:	75 32                	jne    c0105693 <do_pgfault+0x149>
        //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0105661:	8b 45 08             	mov    0x8(%ebp),%eax
c0105664:	8b 40 0c             	mov    0xc(%eax),%eax
c0105667:	83 ec 04             	sub    $0x4,%esp
c010566a:	ff 75 f0             	pushl  -0x10(%ebp)
c010566d:	ff 75 10             	pushl  0x10(%ebp)
c0105670:	50                   	push   %eax
c0105671:	e8 41 e9 ff ff       	call   c0103fb7 <pgdir_alloc_page>
c0105676:	83 c4 10             	add    $0x10,%esp
c0105679:	85 c0                	test   %eax,%eax
c010567b:	0f 85 87 00 00 00    	jne    c0105708 <do_pgfault+0x1be>
        	// This should not happen unless bad implementation in malloc function.
        	cprintf("Cannot allocate physical pages for a valid VMA!");
c0105681:	83 ec 0c             	sub    $0xc,%esp
c0105684:	68 20 b2 10 c0       	push   $0xc010b220
c0105689:	e8 f0 ab ff ff       	call   c010027e <cprintf>
c010568e:	83 c4 10             	add    $0x10,%esp
        	goto failed;
c0105691:	eb 7c                	jmp    c010570f <do_pgfault+0x1c5>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert: build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable: set the page swappable
    */
        if(swap_init_ok) {
c0105693:	a1 d0 7a 12 c0       	mov    0xc0127ad0,%eax
c0105698:	85 c0                	test   %eax,%eax
c010569a:	74 54                	je     c01056f0 <do_pgfault+0x1a6>
            struct Page *page=NULL;
c010569c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1) According to the mm AND addr, try to load the content of right disk page
            //    into the memory which page managed.
            swap_in(mm, addr, &page);
c01056a3:	83 ec 04             	sub    $0x4,%esp
c01056a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01056a9:	50                   	push   %eax
c01056aa:	ff 75 10             	pushl  0x10(%ebp)
c01056ad:	ff 75 08             	pushl  0x8(%ebp)
c01056b0:	e8 1f 03 00 00       	call   c01059d4 <swap_in>
c01056b5:	83 c4 10             	add    $0x10,%esp
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            page_insert(mm->pgdir, page, addr, perm);
c01056b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01056bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01056be:	8b 40 0c             	mov    0xc(%eax),%eax
c01056c1:	ff 75 f0             	pushl  -0x10(%ebp)
c01056c4:	ff 75 10             	pushl  0x10(%ebp)
c01056c7:	52                   	push   %edx
c01056c8:	50                   	push   %eax
c01056c9:	e8 e0 e7 ff ff       	call   c0103eae <page_insert>
c01056ce:	83 c4 10             	add    $0x10,%esp
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c01056d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056d4:	6a 01                	push   $0x1
c01056d6:	50                   	push   %eax
c01056d7:	ff 75 10             	pushl  0x10(%ebp)
c01056da:	ff 75 08             	pushl  0x8(%ebp)
c01056dd:	e8 62 01 00 00       	call   c0105844 <swap_map_swappable>
c01056e2:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr = addr;
c01056e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056e8:	8b 55 10             	mov    0x10(%ebp),%edx
c01056eb:	89 50 1c             	mov    %edx,0x1c(%eax)
c01056ee:	eb 18                	jmp    c0105708 <do_pgfault+0x1be>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01056f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056f3:	8b 00                	mov    (%eax),%eax
c01056f5:	83 ec 08             	sub    $0x8,%esp
c01056f8:	50                   	push   %eax
c01056f9:	68 50 b2 10 c0       	push   $0xc010b250
c01056fe:	e8 7b ab ff ff       	call   c010027e <cprintf>
c0105703:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0105706:	eb 07                	jmp    c010570f <do_pgfault+0x1c5>
        }
   }

   ret = 0;
c0105708:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010570f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105712:	c9                   	leave  
c0105713:	c3                   	ret    

c0105714 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105714:	55                   	push   %ebp
c0105715:	89 e5                	mov    %esp,%ebp
c0105717:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010571a:	8b 45 08             	mov    0x8(%ebp),%eax
c010571d:	c1 e8 0c             	shr    $0xc,%eax
c0105720:	89 c2                	mov    %eax,%edx
c0105722:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0105727:	39 c2                	cmp    %eax,%edx
c0105729:	72 14                	jb     c010573f <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c010572b:	83 ec 04             	sub    $0x4,%esp
c010572e:	68 78 b2 10 c0       	push   $0xc010b278
c0105733:	6a 5f                	push   $0x5f
c0105735:	68 97 b2 10 c0       	push   $0xc010b297
c010573a:	e8 a5 ac ff ff       	call   c01003e4 <__panic>
    }
    return &pages[PPN(pa)];
c010573f:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c0105744:	8b 55 08             	mov    0x8(%ebp),%edx
c0105747:	c1 ea 0c             	shr    $0xc,%edx
c010574a:	c1 e2 05             	shl    $0x5,%edx
c010574d:	01 d0                	add    %edx,%eax
}
c010574f:	c9                   	leave  
c0105750:	c3                   	ret    

c0105751 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0105751:	55                   	push   %ebp
c0105752:	89 e5                	mov    %esp,%ebp
c0105754:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0105757:	8b 45 08             	mov    0x8(%ebp),%eax
c010575a:	83 e0 01             	and    $0x1,%eax
c010575d:	85 c0                	test   %eax,%eax
c010575f:	75 14                	jne    c0105775 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0105761:	83 ec 04             	sub    $0x4,%esp
c0105764:	68 a8 b2 10 c0       	push   $0xc010b2a8
c0105769:	6a 71                	push   $0x71
c010576b:	68 97 b2 10 c0       	push   $0xc010b297
c0105770:	e8 6f ac ff ff       	call   c01003e4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0105775:	8b 45 08             	mov    0x8(%ebp),%eax
c0105778:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010577d:	83 ec 0c             	sub    $0xc,%esp
c0105780:	50                   	push   %eax
c0105781:	e8 8e ff ff ff       	call   c0105714 <pa2page>
c0105786:	83 c4 10             	add    $0x10,%esp
}
c0105789:	c9                   	leave  
c010578a:	c3                   	ret    

c010578b <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010578b:	55                   	push   %ebp
c010578c:	89 e5                	mov    %esp,%ebp
c010578e:	83 ec 18             	sub    $0x18,%esp
     swapfs_init();
c0105791:	e8 33 2f 00 00       	call   c01086c9 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0105796:	a1 dc 9b 12 c0       	mov    0xc0129bdc,%eax
c010579b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01057a0:	76 0c                	jbe    c01057ae <swap_init+0x23>
c01057a2:	a1 dc 9b 12 c0       	mov    0xc0129bdc,%eax
c01057a7:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01057ac:	76 17                	jbe    c01057c5 <swap_init+0x3a>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01057ae:	a1 dc 9b 12 c0       	mov    0xc0129bdc,%eax
c01057b3:	50                   	push   %eax
c01057b4:	68 c9 b2 10 c0       	push   $0xc010b2c9
c01057b9:	6a 26                	push   $0x26
c01057bb:	68 e4 b2 10 c0       	push   $0xc010b2e4
c01057c0:	e8 1f ac ff ff       	call   c01003e4 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01057c5:	c7 05 d8 7a 12 c0 60 	movl   $0xc0126a60,0xc0127ad8
c01057cc:	6a 12 c0 
//     sm = &swap_manager_clock;
     int r = sm->init();
c01057cf:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c01057d4:	8b 40 04             	mov    0x4(%eax),%eax
c01057d7:	ff d0                	call   *%eax
c01057d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01057dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057e0:	75 27                	jne    c0105809 <swap_init+0x7e>
     {
          swap_init_ok = 1;
c01057e2:	c7 05 d0 7a 12 c0 01 	movl   $0x1,0xc0127ad0
c01057e9:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01057ec:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c01057f1:	8b 00                	mov    (%eax),%eax
c01057f3:	83 ec 08             	sub    $0x8,%esp
c01057f6:	50                   	push   %eax
c01057f7:	68 f3 b2 10 c0       	push   $0xc010b2f3
c01057fc:	e8 7d aa ff ff       	call   c010027e <cprintf>
c0105801:	83 c4 10             	add    $0x10,%esp
          check_swap();
c0105804:	e8 f7 03 00 00       	call   c0105c00 <check_swap>
     }

     return r;
c0105809:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010580c:	c9                   	leave  
c010580d:	c3                   	ret    

c010580e <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c010580e:	55                   	push   %ebp
c010580f:	89 e5                	mov    %esp,%ebp
c0105811:	83 ec 08             	sub    $0x8,%esp
     return sm->init_mm(mm);
c0105814:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c0105819:	8b 40 08             	mov    0x8(%eax),%eax
c010581c:	83 ec 0c             	sub    $0xc,%esp
c010581f:	ff 75 08             	pushl  0x8(%ebp)
c0105822:	ff d0                	call   *%eax
c0105824:	83 c4 10             	add    $0x10,%esp
}
c0105827:	c9                   	leave  
c0105828:	c3                   	ret    

c0105829 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0105829:	55                   	push   %ebp
c010582a:	89 e5                	mov    %esp,%ebp
c010582c:	83 ec 08             	sub    $0x8,%esp
     return sm->tick_event(mm);
c010582f:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c0105834:	8b 40 0c             	mov    0xc(%eax),%eax
c0105837:	83 ec 0c             	sub    $0xc,%esp
c010583a:	ff 75 08             	pushl  0x8(%ebp)
c010583d:	ff d0                	call   *%eax
c010583f:	83 c4 10             	add    $0x10,%esp
}
c0105842:	c9                   	leave  
c0105843:	c3                   	ret    

c0105844 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0105844:	55                   	push   %ebp
c0105845:	89 e5                	mov    %esp,%ebp
c0105847:	83 ec 08             	sub    $0x8,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010584a:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c010584f:	8b 40 10             	mov    0x10(%eax),%eax
c0105852:	ff 75 14             	pushl  0x14(%ebp)
c0105855:	ff 75 10             	pushl  0x10(%ebp)
c0105858:	ff 75 0c             	pushl  0xc(%ebp)
c010585b:	ff 75 08             	pushl  0x8(%ebp)
c010585e:	ff d0                	call   *%eax
c0105860:	83 c4 10             	add    $0x10,%esp
}
c0105863:	c9                   	leave  
c0105864:	c3                   	ret    

c0105865 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105865:	55                   	push   %ebp
c0105866:	89 e5                	mov    %esp,%ebp
c0105868:	83 ec 08             	sub    $0x8,%esp
     return sm->set_unswappable(mm, addr);
c010586b:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c0105870:	8b 40 14             	mov    0x14(%eax),%eax
c0105873:	83 ec 08             	sub    $0x8,%esp
c0105876:	ff 75 0c             	pushl  0xc(%ebp)
c0105879:	ff 75 08             	pushl  0x8(%ebp)
c010587c:	ff d0                	call   *%eax
c010587e:	83 c4 10             	add    $0x10,%esp
}
c0105881:	c9                   	leave  
c0105882:	c3                   	ret    

c0105883 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0105883:	55                   	push   %ebp
c0105884:	89 e5                	mov    %esp,%ebp
c0105886:	83 ec 28             	sub    $0x28,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0105889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105890:	e9 2e 01 00 00       	jmp    c01059c3 <swap_out+0x140>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0105895:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c010589a:	8b 40 18             	mov    0x18(%eax),%eax
c010589d:	83 ec 04             	sub    $0x4,%esp
c01058a0:	ff 75 10             	pushl  0x10(%ebp)
c01058a3:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01058a6:	52                   	push   %edx
c01058a7:	ff 75 08             	pushl  0x8(%ebp)
c01058aa:	ff d0                	call   *%eax
c01058ac:	83 c4 10             	add    $0x10,%esp
c01058af:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01058b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058b6:	74 18                	je     c01058d0 <swap_out+0x4d>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01058b8:	83 ec 08             	sub    $0x8,%esp
c01058bb:	ff 75 f4             	pushl  -0xc(%ebp)
c01058be:	68 08 b3 10 c0       	push   $0xc010b308
c01058c3:	e8 b6 a9 ff ff       	call   c010027e <cprintf>
c01058c8:	83 c4 10             	add    $0x10,%esp
c01058cb:	e9 ff 00 00 00       	jmp    c01059cf <swap_out+0x14c>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01058d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058d3:	8b 40 1c             	mov    0x1c(%eax),%eax
c01058d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01058d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01058dc:	8b 40 0c             	mov    0xc(%eax),%eax
c01058df:	83 ec 04             	sub    $0x4,%esp
c01058e2:	6a 00                	push   $0x0
c01058e4:	ff 75 ec             	pushl  -0x14(%ebp)
c01058e7:	50                   	push   %eax
c01058e8:	e8 8d e3 ff ff       	call   c0103c7a <get_pte>
c01058ed:	83 c4 10             	add    $0x10,%esp
c01058f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01058f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058f6:	8b 00                	mov    (%eax),%eax
c01058f8:	83 e0 01             	and    $0x1,%eax
c01058fb:	85 c0                	test   %eax,%eax
c01058fd:	75 16                	jne    c0105915 <swap_out+0x92>
c01058ff:	68 35 b3 10 c0       	push   $0xc010b335
c0105904:	68 4a b3 10 c0       	push   $0xc010b34a
c0105909:	6a 67                	push   $0x67
c010590b:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105910:	e8 cf aa ff ff       	call   c01003e4 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0105915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010591b:	8b 52 1c             	mov    0x1c(%edx),%edx
c010591e:	c1 ea 0c             	shr    $0xc,%edx
c0105921:	83 c2 01             	add    $0x1,%edx
c0105924:	c1 e2 08             	shl    $0x8,%edx
c0105927:	83 ec 08             	sub    $0x8,%esp
c010592a:	50                   	push   %eax
c010592b:	52                   	push   %edx
c010592c:	e8 34 2e 00 00       	call   c0108765 <swapfs_write>
c0105931:	83 c4 10             	add    $0x10,%esp
c0105934:	85 c0                	test   %eax,%eax
c0105936:	74 2b                	je     c0105963 <swap_out+0xe0>
                    cprintf("SWAP: failed to save\n");
c0105938:	83 ec 0c             	sub    $0xc,%esp
c010593b:	68 5f b3 10 c0       	push   $0xc010b35f
c0105940:	e8 39 a9 ff ff       	call   c010027e <cprintf>
c0105945:	83 c4 10             	add    $0x10,%esp
                    sm->map_swappable(mm, v, page, 0);
c0105948:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c010594d:	8b 40 10             	mov    0x10(%eax),%eax
c0105950:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105953:	6a 00                	push   $0x0
c0105955:	52                   	push   %edx
c0105956:	ff 75 ec             	pushl  -0x14(%ebp)
c0105959:	ff 75 08             	pushl  0x8(%ebp)
c010595c:	ff d0                	call   *%eax
c010595e:	83 c4 10             	add    $0x10,%esp
c0105961:	eb 5c                	jmp    c01059bf <swap_out+0x13c>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0105963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105966:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105969:	c1 e8 0c             	shr    $0xc,%eax
c010596c:	83 c0 01             	add    $0x1,%eax
c010596f:	50                   	push   %eax
c0105970:	ff 75 ec             	pushl  -0x14(%ebp)
c0105973:	ff 75 f4             	pushl  -0xc(%ebp)
c0105976:	68 78 b3 10 c0       	push   $0xc010b378
c010597b:	e8 fe a8 ff ff       	call   c010027e <cprintf>
c0105980:	83 c4 10             	add    $0x10,%esp
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0105983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105986:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105989:	c1 e8 0c             	shr    $0xc,%eax
c010598c:	83 c0 01             	add    $0x1,%eax
c010598f:	c1 e0 08             	shl    $0x8,%eax
c0105992:	89 c2                	mov    %eax,%edx
c0105994:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105997:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0105999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010599c:	83 ec 08             	sub    $0x8,%esp
c010599f:	6a 01                	push   $0x1
c01059a1:	50                   	push   %eax
c01059a2:	e8 54 dc ff ff       	call   c01035fb <free_pages>
c01059a7:	83 c4 10             	add    $0x10,%esp
          }
          
          tlb_invalidate(mm->pgdir, v);
c01059aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ad:	8b 40 0c             	mov    0xc(%eax),%eax
c01059b0:	83 ec 08             	sub    $0x8,%esp
c01059b3:	ff 75 ec             	pushl  -0x14(%ebp)
c01059b6:	50                   	push   %eax
c01059b7:	e8 ab e5 ff ff       	call   c0103f67 <tlb_invalidate>
c01059bc:	83 c4 10             	add    $0x10,%esp

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01059bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01059c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01059c9:	0f 85 c6 fe ff ff    	jne    c0105895 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01059cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059d2:	c9                   	leave  
c01059d3:	c3                   	ret    

c01059d4 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01059d4:	55                   	push   %ebp
c01059d5:	89 e5                	mov    %esp,%ebp
c01059d7:	83 ec 18             	sub    $0x18,%esp
     struct Page *result = alloc_page();
c01059da:	83 ec 0c             	sub    $0xc,%esp
c01059dd:	6a 01                	push   $0x1
c01059df:	e8 ab db ff ff       	call   c010358f <alloc_pages>
c01059e4:	83 c4 10             	add    $0x10,%esp
c01059e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01059ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01059ee:	75 16                	jne    c0105a06 <swap_in+0x32>
c01059f0:	68 b8 b3 10 c0       	push   $0xc010b3b8
c01059f5:	68 4a b3 10 c0       	push   $0xc010b34a
c01059fa:	6a 7d                	push   $0x7d
c01059fc:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105a01:	e8 de a9 ff ff       	call   c01003e4 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0105a06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a09:	8b 40 0c             	mov    0xc(%eax),%eax
c0105a0c:	83 ec 04             	sub    $0x4,%esp
c0105a0f:	6a 00                	push   $0x0
c0105a11:	ff 75 0c             	pushl  0xc(%ebp)
c0105a14:	50                   	push   %eax
c0105a15:	e8 60 e2 ff ff       	call   c0103c7a <get_pte>
c0105a1a:	83 c4 10             	add    $0x10,%esp
c0105a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0105a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a23:	8b 00                	mov    (%eax),%eax
c0105a25:	83 ec 08             	sub    $0x8,%esp
c0105a28:	ff 75 f4             	pushl  -0xc(%ebp)
c0105a2b:	50                   	push   %eax
c0105a2c:	e8 db 2c 00 00       	call   c010870c <swapfs_read>
c0105a31:	83 c4 10             	add    $0x10,%esp
c0105a34:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105a3b:	74 1f                	je     c0105a5c <swap_in+0x88>
     {
        assert(r!=0);
c0105a3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105a41:	75 19                	jne    c0105a5c <swap_in+0x88>
c0105a43:	68 c5 b3 10 c0       	push   $0xc010b3c5
c0105a48:	68 4a b3 10 c0       	push   $0xc010b34a
c0105a4d:	68 85 00 00 00       	push   $0x85
c0105a52:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105a57:	e8 88 a9 ff ff       	call   c01003e4 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0105a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a5f:	8b 00                	mov    (%eax),%eax
c0105a61:	c1 e8 08             	shr    $0x8,%eax
c0105a64:	83 ec 04             	sub    $0x4,%esp
c0105a67:	ff 75 0c             	pushl  0xc(%ebp)
c0105a6a:	50                   	push   %eax
c0105a6b:	68 cc b3 10 c0       	push   $0xc010b3cc
c0105a70:	e8 09 a8 ff ff       	call   c010027e <cprintf>
c0105a75:	83 c4 10             	add    $0x10,%esp
     *ptr_result=result;
c0105a78:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a7e:	89 10                	mov    %edx,(%eax)
     return 0;
c0105a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a85:	c9                   	leave  
c0105a86:	c3                   	ret    

c0105a87 <check_content_set>:



static inline void
check_content_set(void)
{
c0105a87:	55                   	push   %ebp
c0105a88:	89 e5                	mov    %esp,%ebp
c0105a8a:	83 ec 08             	sub    $0x8,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0105a8d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105a92:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0105a95:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105a9a:	83 f8 01             	cmp    $0x1,%eax
c0105a9d:	74 19                	je     c0105ab8 <check_content_set+0x31>
c0105a9f:	68 0a b4 10 c0       	push   $0xc010b40a
c0105aa4:	68 4a b3 10 c0       	push   $0xc010b34a
c0105aa9:	68 92 00 00 00       	push   $0x92
c0105aae:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105ab3:	e8 2c a9 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0105ab8:	b8 10 10 00 00       	mov    $0x1010,%eax
c0105abd:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0105ac0:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105ac5:	83 f8 01             	cmp    $0x1,%eax
c0105ac8:	74 19                	je     c0105ae3 <check_content_set+0x5c>
c0105aca:	68 0a b4 10 c0       	push   $0xc010b40a
c0105acf:	68 4a b3 10 c0       	push   $0xc010b34a
c0105ad4:	68 94 00 00 00       	push   $0x94
c0105ad9:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105ade:	e8 01 a9 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0105ae3:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105ae8:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0105aeb:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105af0:	83 f8 02             	cmp    $0x2,%eax
c0105af3:	74 19                	je     c0105b0e <check_content_set+0x87>
c0105af5:	68 19 b4 10 c0       	push   $0xc010b419
c0105afa:	68 4a b3 10 c0       	push   $0xc010b34a
c0105aff:	68 96 00 00 00       	push   $0x96
c0105b04:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105b09:	e8 d6 a8 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0105b0e:	b8 10 20 00 00       	mov    $0x2010,%eax
c0105b13:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0105b16:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105b1b:	83 f8 02             	cmp    $0x2,%eax
c0105b1e:	74 19                	je     c0105b39 <check_content_set+0xb2>
c0105b20:	68 19 b4 10 c0       	push   $0xc010b419
c0105b25:	68 4a b3 10 c0       	push   $0xc010b34a
c0105b2a:	68 98 00 00 00       	push   $0x98
c0105b2f:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105b34:	e8 ab a8 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0105b39:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105b3e:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0105b41:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105b46:	83 f8 03             	cmp    $0x3,%eax
c0105b49:	74 19                	je     c0105b64 <check_content_set+0xdd>
c0105b4b:	68 28 b4 10 c0       	push   $0xc010b428
c0105b50:	68 4a b3 10 c0       	push   $0xc010b34a
c0105b55:	68 9a 00 00 00       	push   $0x9a
c0105b5a:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105b5f:	e8 80 a8 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0105b64:	b8 10 30 00 00       	mov    $0x3010,%eax
c0105b69:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0105b6c:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105b71:	83 f8 03             	cmp    $0x3,%eax
c0105b74:	74 19                	je     c0105b8f <check_content_set+0x108>
c0105b76:	68 28 b4 10 c0       	push   $0xc010b428
c0105b7b:	68 4a b3 10 c0       	push   $0xc010b34a
c0105b80:	68 9c 00 00 00       	push   $0x9c
c0105b85:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105b8a:	e8 55 a8 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0105b8f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105b94:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0105b97:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105b9c:	83 f8 04             	cmp    $0x4,%eax
c0105b9f:	74 19                	je     c0105bba <check_content_set+0x133>
c0105ba1:	68 37 b4 10 c0       	push   $0xc010b437
c0105ba6:	68 4a b3 10 c0       	push   $0xc010b34a
c0105bab:	68 9e 00 00 00       	push   $0x9e
c0105bb0:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105bb5:	e8 2a a8 ff ff       	call   c01003e4 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0105bba:	b8 10 40 00 00       	mov    $0x4010,%eax
c0105bbf:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0105bc2:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0105bc7:	83 f8 04             	cmp    $0x4,%eax
c0105bca:	74 19                	je     c0105be5 <check_content_set+0x15e>
c0105bcc:	68 37 b4 10 c0       	push   $0xc010b437
c0105bd1:	68 4a b3 10 c0       	push   $0xc010b34a
c0105bd6:	68 a0 00 00 00       	push   $0xa0
c0105bdb:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105be0:	e8 ff a7 ff ff       	call   c01003e4 <__panic>
}
c0105be5:	90                   	nop
c0105be6:	c9                   	leave  
c0105be7:	c3                   	ret    

c0105be8 <check_content_access>:

static inline int
check_content_access(void)
{
c0105be8:	55                   	push   %ebp
c0105be9:	89 e5                	mov    %esp,%ebp
c0105beb:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0105bee:	a1 d8 7a 12 c0       	mov    0xc0127ad8,%eax
c0105bf3:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105bf6:	ff d0                	call   *%eax
c0105bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0105bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bfe:	c9                   	leave  
c0105bff:	c3                   	ret    

c0105c00 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0105c00:	55                   	push   %ebp
c0105c01:	89 e5                	mov    %esp,%ebp
c0105c03:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0105c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105c0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0105c14:	c7 45 e8 0c 9c 12 c0 	movl   $0xc0129c0c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105c1b:	eb 60                	jmp    c0105c7d <check_swap+0x7d>
        struct Page *p = le2page(le, page_link);
c0105c1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c20:	83 e8 0c             	sub    $0xc,%eax
c0105c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(PageProperty(p));
c0105c26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c29:	83 c0 04             	add    $0x4,%eax
c0105c2c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105c33:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105c36:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105c39:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105c3c:	0f a3 10             	bt     %edx,(%eax)
c0105c3f:	19 c0                	sbb    %eax,%eax
c0105c41:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0105c44:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0105c48:	0f 95 c0             	setne  %al
c0105c4b:	0f b6 c0             	movzbl %al,%eax
c0105c4e:	85 c0                	test   %eax,%eax
c0105c50:	75 19                	jne    c0105c6b <check_swap+0x6b>
c0105c52:	68 46 b4 10 c0       	push   $0xc010b446
c0105c57:	68 4a b3 10 c0       	push   $0xc010b34a
c0105c5c:	68 bb 00 00 00       	push   $0xbb
c0105c61:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105c66:	e8 79 a7 ff ff       	call   c01003e4 <__panic>
        count ++, total += p->property;
c0105c6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c72:	8b 50 08             	mov    0x8(%eax),%edx
c0105c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c78:	01 d0                	add    %edx,%eax
c0105c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c80:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105c83:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c86:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0105c89:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c8c:	81 7d e8 0c 9c 12 c0 	cmpl   $0xc0129c0c,-0x18(%ebp)
c0105c93:	75 88                	jne    c0105c1d <check_swap+0x1d>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0105c95:	e8 96 d9 ff ff       	call   c0103630 <nr_free_pages>
c0105c9a:	89 c2                	mov    %eax,%edx
c0105c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c9f:	39 c2                	cmp    %eax,%edx
c0105ca1:	74 19                	je     c0105cbc <check_swap+0xbc>
c0105ca3:	68 56 b4 10 c0       	push   $0xc010b456
c0105ca8:	68 4a b3 10 c0       	push   $0xc010b34a
c0105cad:	68 be 00 00 00       	push   $0xbe
c0105cb2:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105cb7:	e8 28 a7 ff ff       	call   c01003e4 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0105cbc:	83 ec 04             	sub    $0x4,%esp
c0105cbf:	ff 75 f0             	pushl  -0x10(%ebp)
c0105cc2:	ff 75 f4             	pushl  -0xc(%ebp)
c0105cc5:	68 70 b4 10 c0       	push   $0xc010b470
c0105cca:	e8 af a5 ff ff       	call   c010027e <cprintf>
c0105ccf:	83 c4 10             	add    $0x10,%esp
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0105cd2:	e8 b9 ee ff ff       	call   c0104b90 <mm_create>
c0105cd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(mm != NULL);
c0105cda:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105cde:	75 19                	jne    c0105cf9 <check_swap+0xf9>
c0105ce0:	68 96 b4 10 c0       	push   $0xc010b496
c0105ce5:	68 4a b3 10 c0       	push   $0xc010b34a
c0105cea:	68 c3 00 00 00       	push   $0xc3
c0105cef:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105cf4:	e8 eb a6 ff ff       	call   c01003e4 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0105cf9:	a1 24 9b 12 c0       	mov    0xc0129b24,%eax
c0105cfe:	85 c0                	test   %eax,%eax
c0105d00:	74 19                	je     c0105d1b <check_swap+0x11b>
c0105d02:	68 a1 b4 10 c0       	push   $0xc010b4a1
c0105d07:	68 4a b3 10 c0       	push   $0xc010b34a
c0105d0c:	68 c6 00 00 00       	push   $0xc6
c0105d11:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105d16:	e8 c9 a6 ff ff       	call   c01003e4 <__panic>

     check_mm_struct = mm;
c0105d1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d1e:	a3 24 9b 12 c0       	mov    %eax,0xc0129b24

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0105d23:	8b 15 44 7a 12 c0    	mov    0xc0127a44,%edx
c0105d29:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d2c:	89 50 0c             	mov    %edx,0xc(%eax)
c0105d2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d32:	8b 40 0c             	mov    0xc(%eax),%eax
c0105d35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(pgdir[0] == 0);
c0105d38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105d3b:	8b 00                	mov    (%eax),%eax
c0105d3d:	85 c0                	test   %eax,%eax
c0105d3f:	74 19                	je     c0105d5a <check_swap+0x15a>
c0105d41:	68 b9 b4 10 c0       	push   $0xc010b4b9
c0105d46:	68 4a b3 10 c0       	push   $0xc010b34a
c0105d4b:	68 cb 00 00 00       	push   $0xcb
c0105d50:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105d55:	e8 8a a6 ff ff       	call   c01003e4 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0105d5a:	83 ec 04             	sub    $0x4,%esp
c0105d5d:	6a 03                	push   $0x3
c0105d5f:	68 00 60 00 00       	push   $0x6000
c0105d64:	68 00 10 00 00       	push   $0x1000
c0105d69:	e8 9e ee ff ff       	call   c0104c0c <vma_create>
c0105d6e:	83 c4 10             	add    $0x10,%esp
c0105d71:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(vma != NULL);
c0105d74:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0105d78:	75 19                	jne    c0105d93 <check_swap+0x193>
c0105d7a:	68 c7 b4 10 c0       	push   $0xc010b4c7
c0105d7f:	68 4a b3 10 c0       	push   $0xc010b34a
c0105d84:	68 ce 00 00 00       	push   $0xce
c0105d89:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105d8e:	e8 51 a6 ff ff       	call   c01003e4 <__panic>

     insert_vma_struct(mm, vma);
c0105d93:	83 ec 08             	sub    $0x8,%esp
c0105d96:	ff 75 d0             	pushl  -0x30(%ebp)
c0105d99:	ff 75 d8             	pushl  -0x28(%ebp)
c0105d9c:	e8 d3 ef ff ff       	call   c0104d74 <insert_vma_struct>
c0105da1:	83 c4 10             	add    $0x10,%esp

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0105da4:	83 ec 0c             	sub    $0xc,%esp
c0105da7:	68 d4 b4 10 c0       	push   $0xc010b4d4
c0105dac:	e8 cd a4 ff ff       	call   c010027e <cprintf>
c0105db1:	83 c4 10             	add    $0x10,%esp
     pte_t *temp_ptep=NULL;
c0105db4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0105dbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105dbe:	8b 40 0c             	mov    0xc(%eax),%eax
c0105dc1:	83 ec 04             	sub    $0x4,%esp
c0105dc4:	6a 01                	push   $0x1
c0105dc6:	68 00 10 00 00       	push   $0x1000
c0105dcb:	50                   	push   %eax
c0105dcc:	e8 a9 de ff ff       	call   c0103c7a <get_pte>
c0105dd1:	83 c4 10             	add    $0x10,%esp
c0105dd4:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(temp_ptep!= NULL);
c0105dd7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105ddb:	75 19                	jne    c0105df6 <check_swap+0x1f6>
c0105ddd:	68 08 b5 10 c0       	push   $0xc010b508
c0105de2:	68 4a b3 10 c0       	push   $0xc010b34a
c0105de7:	68 d6 00 00 00       	push   $0xd6
c0105dec:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105df1:	e8 ee a5 ff ff       	call   c01003e4 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0105df6:	83 ec 0c             	sub    $0xc,%esp
c0105df9:	68 1c b5 10 c0       	push   $0xc010b51c
c0105dfe:	e8 7b a4 ff ff       	call   c010027e <cprintf>
c0105e03:	83 c4 10             	add    $0x10,%esp
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105e06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105e0d:	e9 90 00 00 00       	jmp    c0105ea2 <check_swap+0x2a2>
          check_rp[i] = alloc_page();
c0105e12:	83 ec 0c             	sub    $0xc,%esp
c0105e15:	6a 01                	push   $0x1
c0105e17:	e8 73 d7 ff ff       	call   c010358f <alloc_pages>
c0105e1c:	83 c4 10             	add    $0x10,%esp
c0105e1f:	89 c2                	mov    %eax,%edx
c0105e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e24:	89 14 85 40 9b 12 c0 	mov    %edx,-0x3fed64c0(,%eax,4)
          assert(check_rp[i] != NULL );
c0105e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e2e:	8b 04 85 40 9b 12 c0 	mov    -0x3fed64c0(,%eax,4),%eax
c0105e35:	85 c0                	test   %eax,%eax
c0105e37:	75 19                	jne    c0105e52 <check_swap+0x252>
c0105e39:	68 40 b5 10 c0       	push   $0xc010b540
c0105e3e:	68 4a b3 10 c0       	push   $0xc010b34a
c0105e43:	68 db 00 00 00       	push   $0xdb
c0105e48:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105e4d:	e8 92 a5 ff ff       	call   c01003e4 <__panic>
          assert(!PageProperty(check_rp[i]));
c0105e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e55:	8b 04 85 40 9b 12 c0 	mov    -0x3fed64c0(,%eax,4),%eax
c0105e5c:	83 c0 04             	add    $0x4,%eax
c0105e5f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0105e66:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105e69:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105e6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e6f:	0f a3 10             	bt     %edx,(%eax)
c0105e72:	19 c0                	sbb    %eax,%eax
c0105e74:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0105e77:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0105e7b:	0f 95 c0             	setne  %al
c0105e7e:	0f b6 c0             	movzbl %al,%eax
c0105e81:	85 c0                	test   %eax,%eax
c0105e83:	74 19                	je     c0105e9e <check_swap+0x29e>
c0105e85:	68 54 b5 10 c0       	push   $0xc010b554
c0105e8a:	68 4a b3 10 c0       	push   $0xc010b34a
c0105e8f:	68 dc 00 00 00       	push   $0xdc
c0105e94:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105e99:	e8 46 a5 ff ff       	call   c01003e4 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105e9e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105ea2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105ea6:	0f 8e 66 ff ff ff    	jle    c0105e12 <check_swap+0x212>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0105eac:	a1 0c 9c 12 c0       	mov    0xc0129c0c,%eax
c0105eb1:	8b 15 10 9c 12 c0    	mov    0xc0129c10,%edx
c0105eb7:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105eba:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105ebd:	c7 45 c0 0c 9c 12 c0 	movl   $0xc0129c0c,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105ec4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105ec7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105eca:	89 50 04             	mov    %edx,0x4(%eax)
c0105ecd:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105ed0:	8b 50 04             	mov    0x4(%eax),%edx
c0105ed3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105ed6:	89 10                	mov    %edx,(%eax)
c0105ed8:	c7 45 c8 0c 9c 12 c0 	movl   $0xc0129c0c,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0105edf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105ee2:	8b 40 04             	mov    0x4(%eax),%eax
c0105ee5:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0105ee8:	0f 94 c0             	sete   %al
c0105eeb:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0105eee:	85 c0                	test   %eax,%eax
c0105ef0:	75 19                	jne    c0105f0b <check_swap+0x30b>
c0105ef2:	68 6f b5 10 c0       	push   $0xc010b56f
c0105ef7:	68 4a b3 10 c0       	push   $0xc010b34a
c0105efc:	68 e0 00 00 00       	push   $0xe0
c0105f01:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105f06:	e8 d9 a4 ff ff       	call   c01003e4 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0105f0b:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0105f10:	89 45 bc             	mov    %eax,-0x44(%ebp)
     nr_free = 0;
c0105f13:	c7 05 14 9c 12 c0 00 	movl   $0x0,0xc0129c14
c0105f1a:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105f1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105f24:	eb 1c                	jmp    c0105f42 <check_swap+0x342>
        free_pages(check_rp[i],1);
c0105f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f29:	8b 04 85 40 9b 12 c0 	mov    -0x3fed64c0(,%eax,4),%eax
c0105f30:	83 ec 08             	sub    $0x8,%esp
c0105f33:	6a 01                	push   $0x1
c0105f35:	50                   	push   %eax
c0105f36:	e8 c0 d6 ff ff       	call   c01035fb <free_pages>
c0105f3b:	83 c4 10             	add    $0x10,%esp
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105f3e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105f42:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105f46:	7e de                	jle    c0105f26 <check_swap+0x326>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0105f48:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0105f4d:	83 f8 04             	cmp    $0x4,%eax
c0105f50:	74 19                	je     c0105f6b <check_swap+0x36b>
c0105f52:	68 88 b5 10 c0       	push   $0xc010b588
c0105f57:	68 4a b3 10 c0       	push   $0xc010b34a
c0105f5c:	68 e9 00 00 00       	push   $0xe9
c0105f61:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105f66:	e8 79 a4 ff ff       	call   c01003e4 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0105f6b:	83 ec 0c             	sub    $0xc,%esp
c0105f6e:	68 ac b5 10 c0       	push   $0xc010b5ac
c0105f73:	e8 06 a3 ff ff       	call   c010027e <cprintf>
c0105f78:	83 c4 10             	add    $0x10,%esp
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0105f7b:	c7 05 cc 7a 12 c0 00 	movl   $0x0,0xc0127acc
c0105f82:	00 00 00 
     
     check_content_set();
c0105f85:	e8 fd fa ff ff       	call   c0105a87 <check_content_set>
     assert( nr_free == 0);         
c0105f8a:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0105f8f:	85 c0                	test   %eax,%eax
c0105f91:	74 19                	je     c0105fac <check_swap+0x3ac>
c0105f93:	68 d3 b5 10 c0       	push   $0xc010b5d3
c0105f98:	68 4a b3 10 c0       	push   $0xc010b34a
c0105f9d:	68 f2 00 00 00       	push   $0xf2
c0105fa2:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0105fa7:	e8 38 a4 ff ff       	call   c01003e4 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105fac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105fb3:	eb 26                	jmp    c0105fdb <check_swap+0x3db>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0105fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fb8:	c7 04 85 60 9b 12 c0 	movl   $0xffffffff,-0x3fed64a0(,%eax,4)
c0105fbf:	ff ff ff ff 
c0105fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fc6:	8b 14 85 60 9b 12 c0 	mov    -0x3fed64a0(,%eax,4),%edx
c0105fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fd0:	89 14 85 a0 9b 12 c0 	mov    %edx,-0x3fed6460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105fd7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105fdb:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0105fdf:	7e d4                	jle    c0105fb5 <check_swap+0x3b5>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105fe1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105fe8:	e9 cc 00 00 00       	jmp    c01060b9 <check_swap+0x4b9>
         check_ptep[i]=0;
c0105fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ff0:	c7 04 85 f4 9b 12 c0 	movl   $0x0,-0x3fed640c(,%eax,4)
c0105ff7:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0105ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ffe:	83 c0 01             	add    $0x1,%eax
c0106001:	c1 e0 0c             	shl    $0xc,%eax
c0106004:	83 ec 04             	sub    $0x4,%esp
c0106007:	6a 00                	push   $0x0
c0106009:	50                   	push   %eax
c010600a:	ff 75 d4             	pushl  -0x2c(%ebp)
c010600d:	e8 68 dc ff ff       	call   c0103c7a <get_pte>
c0106012:	83 c4 10             	add    $0x10,%esp
c0106015:	89 c2                	mov    %eax,%edx
c0106017:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010601a:	89 14 85 f4 9b 12 c0 	mov    %edx,-0x3fed640c(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106021:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106024:	8b 04 85 f4 9b 12 c0 	mov    -0x3fed640c(,%eax,4),%eax
c010602b:	85 c0                	test   %eax,%eax
c010602d:	75 19                	jne    c0106048 <check_swap+0x448>
c010602f:	68 e0 b5 10 c0       	push   $0xc010b5e0
c0106034:	68 4a b3 10 c0       	push   $0xc010b34a
c0106039:	68 fa 00 00 00       	push   $0xfa
c010603e:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0106043:	e8 9c a3 ff ff       	call   c01003e4 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106048:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010604b:	8b 04 85 f4 9b 12 c0 	mov    -0x3fed640c(,%eax,4),%eax
c0106052:	8b 00                	mov    (%eax),%eax
c0106054:	83 ec 0c             	sub    $0xc,%esp
c0106057:	50                   	push   %eax
c0106058:	e8 f4 f6 ff ff       	call   c0105751 <pte2page>
c010605d:	83 c4 10             	add    $0x10,%esp
c0106060:	89 c2                	mov    %eax,%edx
c0106062:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106065:	8b 04 85 40 9b 12 c0 	mov    -0x3fed64c0(,%eax,4),%eax
c010606c:	39 c2                	cmp    %eax,%edx
c010606e:	74 19                	je     c0106089 <check_swap+0x489>
c0106070:	68 f8 b5 10 c0       	push   $0xc010b5f8
c0106075:	68 4a b3 10 c0       	push   $0xc010b34a
c010607a:	68 fb 00 00 00       	push   $0xfb
c010607f:	68 e4 b2 10 c0       	push   $0xc010b2e4
c0106084:	e8 5b a3 ff ff       	call   c01003e4 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106089:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010608c:	8b 04 85 f4 9b 12 c0 	mov    -0x3fed640c(,%eax,4),%eax
c0106093:	8b 00                	mov    (%eax),%eax
c0106095:	83 e0 01             	and    $0x1,%eax
c0106098:	85 c0                	test   %eax,%eax
c010609a:	75 19                	jne    c01060b5 <check_swap+0x4b5>
c010609c:	68 20 b6 10 c0       	push   $0xc010b620
c01060a1:	68 4a b3 10 c0       	push   $0xc010b34a
c01060a6:	68 fc 00 00 00       	push   $0xfc
c01060ab:	68 e4 b2 10 c0       	push   $0xc010b2e4
c01060b0:	e8 2f a3 ff ff       	call   c01003e4 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01060b5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01060b9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01060bd:	0f 8e 2a ff ff ff    	jle    c0105fed <check_swap+0x3ed>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01060c3:	83 ec 0c             	sub    $0xc,%esp
c01060c6:	68 3c b6 10 c0       	push   $0xc010b63c
c01060cb:	e8 ae a1 ff ff       	call   c010027e <cprintf>
c01060d0:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01060d3:	e8 10 fb ff ff       	call   c0105be8 <check_content_access>
c01060d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
     assert(ret==0);
c01060db:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01060df:	74 19                	je     c01060fa <check_swap+0x4fa>
c01060e1:	68 62 b6 10 c0       	push   $0xc010b662
c01060e6:	68 4a b3 10 c0       	push   $0xc010b34a
c01060eb:	68 01 01 00 00       	push   $0x101
c01060f0:	68 e4 b2 10 c0       	push   $0xc010b2e4
c01060f5:	e8 ea a2 ff ff       	call   c01003e4 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01060fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106101:	eb 1c                	jmp    c010611f <check_swap+0x51f>
         free_pages(check_rp[i],1);
c0106103:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106106:	8b 04 85 40 9b 12 c0 	mov    -0x3fed64c0(,%eax,4),%eax
c010610d:	83 ec 08             	sub    $0x8,%esp
c0106110:	6a 01                	push   $0x1
c0106112:	50                   	push   %eax
c0106113:	e8 e3 d4 ff ff       	call   c01035fb <free_pages>
c0106118:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010611b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010611f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106123:	7e de                	jle    c0106103 <check_swap+0x503>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106125:	83 ec 0c             	sub    $0xc,%esp
c0106128:	ff 75 d8             	pushl  -0x28(%ebp)
c010612b:	e8 68 ed ff ff       	call   c0104e98 <mm_destroy>
c0106130:	83 c4 10             	add    $0x10,%esp
         
     nr_free = nr_free_store;
c0106133:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106136:	a3 14 9c 12 c0       	mov    %eax,0xc0129c14
     free_list = free_list_store;
c010613b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010613e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106141:	a3 0c 9c 12 c0       	mov    %eax,0xc0129c0c
c0106146:	89 15 10 9c 12 c0    	mov    %edx,0xc0129c10

     
     le = &free_list;
c010614c:	c7 45 e8 0c 9c 12 c0 	movl   $0xc0129c0c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106153:	eb 1d                	jmp    c0106172 <check_swap+0x572>
         struct Page *p = le2page(le, page_link);
c0106155:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106158:	83 e8 0c             	sub    $0xc,%eax
c010615b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
         count --, total -= p->property;
c010615e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106162:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106165:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106168:	8b 40 08             	mov    0x8(%eax),%eax
c010616b:	29 c2                	sub    %eax,%edx
c010616d:	89 d0                	mov    %edx,%eax
c010616f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106172:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106175:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106178:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010617b:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010617e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106181:	81 7d e8 0c 9c 12 c0 	cmpl   $0xc0129c0c,-0x18(%ebp)
c0106188:	75 cb                	jne    c0106155 <check_swap+0x555>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c010618a:	83 ec 04             	sub    $0x4,%esp
c010618d:	ff 75 f0             	pushl  -0x10(%ebp)
c0106190:	ff 75 f4             	pushl  -0xc(%ebp)
c0106193:	68 69 b6 10 c0       	push   $0xc010b669
c0106198:	e8 e1 a0 ff ff       	call   c010027e <cprintf>
c010619d:	83 c4 10             	add    $0x10,%esp
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01061a0:	83 ec 0c             	sub    $0xc,%esp
c01061a3:	68 83 b6 10 c0       	push   $0xc010b683
c01061a8:	e8 d1 a0 ff ff       	call   c010027e <cprintf>
c01061ad:	83 c4 10             	add    $0x10,%esp
}
c01061b0:	90                   	nop
c01061b1:	c9                   	leave  
c01061b2:	c3                   	ret    

c01061b3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01061b3:	55                   	push   %ebp
c01061b4:	89 e5                	mov    %esp,%ebp
c01061b6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01061b9:	9c                   	pushf  
c01061ba:	58                   	pop    %eax
c01061bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01061be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01061c1:	25 00 02 00 00       	and    $0x200,%eax
c01061c6:	85 c0                	test   %eax,%eax
c01061c8:	74 0c                	je     c01061d6 <__intr_save+0x23>
        intr_disable();
c01061ca:	e8 db be ff ff       	call   c01020aa <intr_disable>
        return 1;
c01061cf:	b8 01 00 00 00       	mov    $0x1,%eax
c01061d4:	eb 05                	jmp    c01061db <__intr_save+0x28>
    }
    return 0;
c01061d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01061db:	c9                   	leave  
c01061dc:	c3                   	ret    

c01061dd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01061dd:	55                   	push   %ebp
c01061de:	89 e5                	mov    %esp,%ebp
c01061e0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01061e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01061e7:	74 05                	je     c01061ee <__intr_restore+0x11>
        intr_enable();
c01061e9:	e8 b5 be ff ff       	call   c01020a3 <intr_enable>
    }
}
c01061ee:	90                   	nop
c01061ef:	c9                   	leave  
c01061f0:	c3                   	ret    

c01061f1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01061f1:	55                   	push   %ebp
c01061f2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01061f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01061f7:	8b 15 20 9b 12 c0    	mov    0xc0129b20,%edx
c01061fd:	29 d0                	sub    %edx,%eax
c01061ff:	c1 f8 05             	sar    $0x5,%eax
}
c0106202:	5d                   	pop    %ebp
c0106203:	c3                   	ret    

c0106204 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0106204:	55                   	push   %ebp
c0106205:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0106207:	ff 75 08             	pushl  0x8(%ebp)
c010620a:	e8 e2 ff ff ff       	call   c01061f1 <page2ppn>
c010620f:	83 c4 04             	add    $0x4,%esp
c0106212:	c1 e0 0c             	shl    $0xc,%eax
}
c0106215:	c9                   	leave  
c0106216:	c3                   	ret    

c0106217 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0106217:	55                   	push   %ebp
c0106218:	89 e5                	mov    %esp,%ebp
c010621a:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010621d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106220:	c1 e8 0c             	shr    $0xc,%eax
c0106223:	89 c2                	mov    %eax,%edx
c0106225:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c010622a:	39 c2                	cmp    %eax,%edx
c010622c:	72 14                	jb     c0106242 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c010622e:	83 ec 04             	sub    $0x4,%esp
c0106231:	68 9c b6 10 c0       	push   $0xc010b69c
c0106236:	6a 5f                	push   $0x5f
c0106238:	68 bb b6 10 c0       	push   $0xc010b6bb
c010623d:	e8 a2 a1 ff ff       	call   c01003e4 <__panic>
    }
    return &pages[PPN(pa)];
c0106242:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c0106247:	8b 55 08             	mov    0x8(%ebp),%edx
c010624a:	c1 ea 0c             	shr    $0xc,%edx
c010624d:	c1 e2 05             	shl    $0x5,%edx
c0106250:	01 d0                	add    %edx,%eax
}
c0106252:	c9                   	leave  
c0106253:	c3                   	ret    

c0106254 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0106254:	55                   	push   %ebp
c0106255:	89 e5                	mov    %esp,%ebp
c0106257:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c010625a:	ff 75 08             	pushl  0x8(%ebp)
c010625d:	e8 a2 ff ff ff       	call   c0106204 <page2pa>
c0106262:	83 c4 04             	add    $0x4,%esp
c0106265:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106268:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010626b:	c1 e8 0c             	shr    $0xc,%eax
c010626e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106271:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0106276:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106279:	72 14                	jb     c010628f <page2kva+0x3b>
c010627b:	ff 75 f4             	pushl  -0xc(%ebp)
c010627e:	68 cc b6 10 c0       	push   $0xc010b6cc
c0106283:	6a 66                	push   $0x66
c0106285:	68 bb b6 10 c0       	push   $0xc010b6bb
c010628a:	e8 55 a1 ff ff       	call   c01003e4 <__panic>
c010628f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106292:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106297:	c9                   	leave  
c0106298:	c3                   	ret    

c0106299 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0106299:	55                   	push   %ebp
c010629a:	89 e5                	mov    %esp,%ebp
c010629c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c010629f:	8b 45 08             	mov    0x8(%ebp),%eax
c01062a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01062a5:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01062ac:	77 14                	ja     c01062c2 <kva2page+0x29>
c01062ae:	ff 75 f4             	pushl  -0xc(%ebp)
c01062b1:	68 f0 b6 10 c0       	push   $0xc010b6f0
c01062b6:	6a 6b                	push   $0x6b
c01062b8:	68 bb b6 10 c0       	push   $0xc010b6bb
c01062bd:	e8 22 a1 ff ff       	call   c01003e4 <__panic>
c01062c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062c5:	05 00 00 00 40       	add    $0x40000000,%eax
c01062ca:	83 ec 0c             	sub    $0xc,%esp
c01062cd:	50                   	push   %eax
c01062ce:	e8 44 ff ff ff       	call   c0106217 <pa2page>
c01062d3:	83 c4 10             	add    $0x10,%esp
}
c01062d6:	c9                   	leave  
c01062d7:	c3                   	ret    

c01062d8 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c01062d8:	55                   	push   %ebp
c01062d9:	89 e5                	mov    %esp,%ebp
c01062db:	83 ec 18             	sub    $0x18,%esp
  struct Page * page = alloc_pages(1 << order);
c01062de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062e1:	ba 01 00 00 00       	mov    $0x1,%edx
c01062e6:	89 c1                	mov    %eax,%ecx
c01062e8:	d3 e2                	shl    %cl,%edx
c01062ea:	89 d0                	mov    %edx,%eax
c01062ec:	83 ec 0c             	sub    $0xc,%esp
c01062ef:	50                   	push   %eax
c01062f0:	e8 9a d2 ff ff       	call   c010358f <alloc_pages>
c01062f5:	83 c4 10             	add    $0x10,%esp
c01062f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c01062fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01062ff:	75 07                	jne    c0106308 <__slob_get_free_pages+0x30>
    return NULL;
c0106301:	b8 00 00 00 00       	mov    $0x0,%eax
c0106306:	eb 0e                	jmp    c0106316 <__slob_get_free_pages+0x3e>
  return page2kva(page);
c0106308:	83 ec 0c             	sub    $0xc,%esp
c010630b:	ff 75 f4             	pushl  -0xc(%ebp)
c010630e:	e8 41 ff ff ff       	call   c0106254 <page2kva>
c0106313:	83 c4 10             	add    $0x10,%esp
}
c0106316:	c9                   	leave  
c0106317:	c3                   	ret    

c0106318 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0106318:	55                   	push   %ebp
c0106319:	89 e5                	mov    %esp,%ebp
c010631b:	53                   	push   %ebx
c010631c:	83 ec 04             	sub    $0x4,%esp
  free_pages(kva2page(kva), 1 << order);
c010631f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106322:	ba 01 00 00 00       	mov    $0x1,%edx
c0106327:	89 c1                	mov    %eax,%ecx
c0106329:	d3 e2                	shl    %cl,%edx
c010632b:	89 d0                	mov    %edx,%eax
c010632d:	89 c3                	mov    %eax,%ebx
c010632f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106332:	83 ec 0c             	sub    $0xc,%esp
c0106335:	50                   	push   %eax
c0106336:	e8 5e ff ff ff       	call   c0106299 <kva2page>
c010633b:	83 c4 10             	add    $0x10,%esp
c010633e:	83 ec 08             	sub    $0x8,%esp
c0106341:	53                   	push   %ebx
c0106342:	50                   	push   %eax
c0106343:	e8 b3 d2 ff ff       	call   c01035fb <free_pages>
c0106348:	83 c4 10             	add    $0x10,%esp
}
c010634b:	90                   	nop
c010634c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010634f:	c9                   	leave  
c0106350:	c3                   	ret    

c0106351 <first_fit_alloc>:

static void slob_free(void *b, int size);

static void *first_fit_alloc(size_t size, gfp_t gfp, int align)
{
c0106351:	55                   	push   %ebp
c0106352:	89 e5                	mov    %esp,%ebp
c0106354:	83 ec 28             	sub    $0x28,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0106357:	8b 45 08             	mov    0x8(%ebp),%eax
c010635a:	83 c0 08             	add    $0x8,%eax
c010635d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0106362:	76 16                	jbe    c010637a <first_fit_alloc+0x29>
c0106364:	68 14 b7 10 c0       	push   $0xc010b714
c0106369:	68 33 b7 10 c0       	push   $0xc010b733
c010636e:	6a 65                	push   $0x65
c0106370:	68 48 b7 10 c0       	push   $0xc010b748
c0106375:	e8 6a a0 ff ff       	call   c01003e4 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c010637a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0106381:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0106388:	8b 45 08             	mov    0x8(%ebp),%eax
c010638b:	83 c0 07             	add    $0x7,%eax
c010638e:	c1 e8 03             	shr    $0x3,%eax
c0106391:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0106394:	e8 1a fe ff ff       	call   c01061b3 <__intr_save>
c0106399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c010639c:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c01063a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01063a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063a7:	8b 40 04             	mov    0x4(%eax),%eax
c01063aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01063ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01063b1:	74 25                	je     c01063d8 <first_fit_alloc+0x87>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01063b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01063b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01063b9:	01 d0                	add    %edx,%eax
c01063bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01063be:	8b 45 10             	mov    0x10(%ebp),%eax
c01063c1:	f7 d8                	neg    %eax
c01063c3:	21 d0                	and    %edx,%eax
c01063c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c01063c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063ce:	29 c2                	sub    %eax,%edx
c01063d0:	89 d0                	mov    %edx,%eax
c01063d2:	c1 f8 03             	sar    $0x3,%eax
c01063d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c01063d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063db:	8b 00                	mov    (%eax),%eax
c01063dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01063e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01063e3:	01 ca                	add    %ecx,%edx
c01063e5:	39 d0                	cmp    %edx,%eax
c01063e7:	0f 8c b1 00 00 00    	jl     c010649e <first_fit_alloc+0x14d>
			if (delta) { /* need to fragment head to align? */
c01063ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01063f1:	74 38                	je     c010642b <first_fit_alloc+0xda>
				aligned->units = cur->units - delta;
c01063f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063f6:	8b 00                	mov    (%eax),%eax
c01063f8:	2b 45 e8             	sub    -0x18(%ebp),%eax
c01063fb:	89 c2                	mov    %eax,%edx
c01063fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106400:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0106402:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106405:	8b 50 04             	mov    0x4(%eax),%edx
c0106408:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010640b:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010640e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106411:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106414:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0106417:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010641a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010641d:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010641f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106422:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0106425:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106428:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c010642b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010642e:	8b 00                	mov    (%eax),%eax
c0106430:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0106433:	75 0e                	jne    c0106443 <first_fit_alloc+0xf2>
				prev->next = cur->next; /* unlink */
c0106435:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106438:	8b 50 04             	mov    0x4(%eax),%edx
c010643b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010643e:	89 50 04             	mov    %edx,0x4(%eax)
c0106441:	eb 3c                	jmp    c010647f <first_fit_alloc+0x12e>
			else { /* fragment */
				prev->next = cur + units;
c0106443:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106446:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010644d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106450:	01 c2                	add    %eax,%edx
c0106452:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106455:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0106458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010645b:	8b 40 04             	mov    0x4(%eax),%eax
c010645e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106461:	8b 12                	mov    (%edx),%edx
c0106463:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0106466:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0106468:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010646b:	8b 40 04             	mov    0x4(%eax),%eax
c010646e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106471:	8b 52 04             	mov    0x4(%edx),%edx
c0106474:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0106477:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010647a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010647d:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c010647f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106482:	a3 40 6a 12 c0       	mov    %eax,0xc0126a40
			spin_unlock_irqrestore(&slob_lock, flags);
c0106487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010648a:	83 ec 0c             	sub    $0xc,%esp
c010648d:	50                   	push   %eax
c010648e:	e8 4a fd ff ff       	call   c01061dd <__intr_restore>
c0106493:	83 c4 10             	add    $0x10,%esp
			return cur;
c0106496:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106499:	e9 80 00 00 00       	jmp    c010651e <first_fit_alloc+0x1cd>
		}
		if (cur == slobfree) {
c010649e:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c01064a3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01064a6:	75 62                	jne    c010650a <first_fit_alloc+0x1b9>
			spin_unlock_irqrestore(&slob_lock, flags);
c01064a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ab:	83 ec 0c             	sub    $0xc,%esp
c01064ae:	50                   	push   %eax
c01064af:	e8 29 fd ff ff       	call   c01061dd <__intr_restore>
c01064b4:	83 c4 10             	add    $0x10,%esp

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01064b7:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01064be:	75 07                	jne    c01064c7 <first_fit_alloc+0x176>
				return 0;
c01064c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01064c5:	eb 57                	jmp    c010651e <first_fit_alloc+0x1cd>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01064c7:	83 ec 08             	sub    $0x8,%esp
c01064ca:	6a 00                	push   $0x0
c01064cc:	ff 75 0c             	pushl  0xc(%ebp)
c01064cf:	e8 04 fe ff ff       	call   c01062d8 <__slob_get_free_pages>
c01064d4:	83 c4 10             	add    $0x10,%esp
c01064d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c01064da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01064de:	75 07                	jne    c01064e7 <first_fit_alloc+0x196>
				return 0;
c01064e0:	b8 00 00 00 00       	mov    $0x0,%eax
c01064e5:	eb 37                	jmp    c010651e <first_fit_alloc+0x1cd>

			slob_free(cur, PAGE_SIZE);
c01064e7:	83 ec 08             	sub    $0x8,%esp
c01064ea:	68 00 10 00 00       	push   $0x1000
c01064ef:	ff 75 f0             	pushl  -0x10(%ebp)
c01064f2:	e8 1c 02 00 00       	call   c0106713 <slob_free>
c01064f7:	83 c4 10             	add    $0x10,%esp
			spin_lock_irqsave(&slob_lock, flags);
c01064fa:	e8 b4 fc ff ff       	call   c01061b3 <__intr_save>
c01064ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0106502:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0106507:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c010650a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010650d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106510:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106513:	8b 40 04             	mov    0x4(%eax),%eax
c0106516:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0106519:	e9 8f fe ff ff       	jmp    c01063ad <first_fit_alloc+0x5c>
}
c010651e:	c9                   	leave  
c010651f:	c3                   	ret    

c0106520 <best_fit_alloc>:

static void *best_fit_alloc(size_t size, gfp_t gfp, int align)
{
c0106520:	55                   	push   %ebp
c0106521:	89 e5                	mov    %esp,%ebp
c0106523:	83 ec 28             	sub    $0x28,%esp
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0106526:	8b 45 08             	mov    0x8(%ebp),%eax
c0106529:	83 c0 08             	add    $0x8,%eax
c010652c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0106531:	76 19                	jbe    c010654c <best_fit_alloc+0x2c>
c0106533:	68 14 b7 10 c0       	push   $0xc010b714
c0106538:	68 33 b7 10 c0       	push   $0xc010b733
c010653d:	68 9c 00 00 00       	push   $0x9c
c0106542:	68 48 b7 10 c0       	push   $0xc010b748
c0106547:	e8 98 9e ff ff       	call   c01003e4 <__panic>
	// This best fit allocator does not consider situations where align != 0
	assert(align == 0);
c010654c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106550:	74 19                	je     c010656b <best_fit_alloc+0x4b>
c0106552:	68 5a b7 10 c0       	push   $0xc010b75a
c0106557:	68 33 b7 10 c0       	push   $0xc010b733
c010655c:	68 9e 00 00 00       	push   $0x9e
c0106561:	68 48 b7 10 c0       	push   $0xc010b748
c0106566:	e8 79 9e ff ff       	call   c01003e4 <__panic>
	int units = SLOB_UNITS(size);
c010656b:	8b 45 08             	mov    0x8(%ebp),%eax
c010656e:	83 c0 07             	add    $0x7,%eax
c0106571:	c1 e8 03             	shr    $0x3,%eax
c0106574:	89 45 d8             	mov    %eax,-0x28(%ebp)

	unsigned long flags;
	spin_lock_irqsave(&slob_lock, flags);
c0106577:	e8 37 fc ff ff       	call   c01061b3 <__intr_save>
c010657c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	slob_t *prev = slobfree, *cur = slobfree->next;
c010657f:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0106584:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106587:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c010658c:	8b 40 04             	mov    0x4(%eax),%eax
c010658f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int find_available = 0;
c0106592:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int best_frag_units = 100000;
c0106599:	c7 45 e4 a0 86 01 00 	movl   $0x186a0,-0x1c(%ebp)
	slob_t *best_slob = NULL;
c01065a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	slob_t *best_slob_prev = NULL;
c01065a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	for (; ; prev = cur, cur = cur->next) {
		if (cur->units >= units) {
c01065ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065b1:	8b 00                	mov    (%eax),%eax
c01065b3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
c01065b6:	7c 60                	jl     c0106618 <best_fit_alloc+0xf8>
			// Find available one.
			if (cur->units == units) {
c01065b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065bb:	8b 00                	mov    (%eax),%eax
c01065bd:	3b 45 d8             	cmp    -0x28(%ebp),%eax
c01065c0:	75 2b                	jne    c01065ed <best_fit_alloc+0xcd>
				// If found a perfect one...
				prev->next = cur->next;
c01065c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065c5:	8b 50 04             	mov    0x4(%eax),%edx
c01065c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065cb:	89 50 04             	mov    %edx,0x4(%eax)
				slobfree = prev;
c01065ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065d1:	a3 40 6a 12 c0       	mov    %eax,0xc0126a40
				spin_unlock_irqrestore(&slob_lock, flags);
c01065d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065d9:	83 ec 0c             	sub    $0xc,%esp
c01065dc:	50                   	push   %eax
c01065dd:	e8 fb fb ff ff       	call   c01061dd <__intr_restore>
c01065e2:	83 c4 10             	add    $0x10,%esp
				// That's it!
				return cur;
c01065e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065e8:	e9 08 01 00 00       	jmp    c01066f5 <best_fit_alloc+0x1d5>
			}
			else {
				// This is not a prefect one.
				if (cur->units - units < best_frag_units) {
c01065ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065f0:	8b 00                	mov    (%eax),%eax
c01065f2:	2b 45 d8             	sub    -0x28(%ebp),%eax
c01065f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c01065f8:	7d 1e                	jge    c0106618 <best_fit_alloc+0xf8>
					// This seems to be better than previous one.
					best_frag_units = cur->units - units;
c01065fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065fd:	8b 00                	mov    (%eax),%eax
c01065ff:	2b 45 d8             	sub    -0x28(%ebp),%eax
c0106602:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					best_slob = cur;
c0106605:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106608:	89 45 e0             	mov    %eax,-0x20(%ebp)
					best_slob_prev = prev;
c010660b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010660e:	89 45 dc             	mov    %eax,-0x24(%ebp)
					find_available = 1;
c0106611:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			}

		}

		// Get to the end of iteration.
		if (cur == slobfree) {
c0106618:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c010661d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106620:	0f 85 bb 00 00 00    	jne    c01066e1 <best_fit_alloc+0x1c1>
			if (find_available) {
c0106626:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010662a:	74 53                	je     c010667f <best_fit_alloc+0x15f>
				// use the found best fit.
				best_slob_prev->next = best_slob + units;
c010662c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010662f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0106636:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106639:	01 c2                	add    %eax,%edx
c010663b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010663e:	89 50 04             	mov    %edx,0x4(%eax)
				best_slob_prev->next->units = best_frag_units;
c0106641:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106644:	8b 40 04             	mov    0x4(%eax),%eax
c0106647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010664a:	89 10                	mov    %edx,(%eax)
				best_slob_prev->next->next = best_slob->next;
c010664c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010664f:	8b 40 04             	mov    0x4(%eax),%eax
c0106652:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106655:	8b 52 04             	mov    0x4(%edx),%edx
c0106658:	89 50 04             	mov    %edx,0x4(%eax)
				best_slob->units = units;
c010665b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010665e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106661:	89 10                	mov    %edx,(%eax)
				slobfree = best_slob_prev;
c0106663:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106666:	a3 40 6a 12 c0       	mov    %eax,0xc0126a40
				spin_unlock_irqrestore(&slob_lock, flags);
c010666b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010666e:	83 ec 0c             	sub    $0xc,%esp
c0106671:	50                   	push   %eax
c0106672:	e8 66 fb ff ff       	call   c01061dd <__intr_restore>
c0106677:	83 c4 10             	add    $0x10,%esp
				// That's it!
				return best_slob;
c010667a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010667d:	eb 76                	jmp    c01066f5 <best_fit_alloc+0x1d5>
			}
			// Initially, there's no available arena. So get some.
			spin_unlock_irqrestore(&slob_lock, flags);
c010667f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106682:	83 ec 0c             	sub    $0xc,%esp
c0106685:	50                   	push   %eax
c0106686:	e8 52 fb ff ff       	call   c01061dd <__intr_restore>
c010668b:	83 c4 10             	add    $0x10,%esp
			if (size == PAGE_SIZE) return 0;
c010668e:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0106695:	75 07                	jne    c010669e <best_fit_alloc+0x17e>
c0106697:	b8 00 00 00 00       	mov    $0x0,%eax
c010669c:	eb 57                	jmp    c01066f5 <best_fit_alloc+0x1d5>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010669e:	83 ec 08             	sub    $0x8,%esp
c01066a1:	6a 00                	push   $0x0
c01066a3:	ff 75 0c             	pushl  0xc(%ebp)
c01066a6:	e8 2d fc ff ff       	call   c01062d8 <__slob_get_free_pages>
c01066ab:	83 c4 10             	add    $0x10,%esp
c01066ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (!cur) return 0;
c01066b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01066b5:	75 07                	jne    c01066be <best_fit_alloc+0x19e>
c01066b7:	b8 00 00 00 00       	mov    $0x0,%eax
c01066bc:	eb 37                	jmp    c01066f5 <best_fit_alloc+0x1d5>

			slob_free(cur, PAGE_SIZE);
c01066be:	83 ec 08             	sub    $0x8,%esp
c01066c1:	68 00 10 00 00       	push   $0x1000
c01066c6:	ff 75 ec             	pushl  -0x14(%ebp)
c01066c9:	e8 45 00 00 00       	call   c0106713 <slob_free>
c01066ce:	83 c4 10             	add    $0x10,%esp
			spin_lock_irqsave(&slob_lock, flags);
c01066d1:	e8 dd fa ff ff       	call   c01061b3 <__intr_save>
c01066d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			cur = slobfree;
c01066d9:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c01066de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int find_available = 0;
	int best_frag_units = 100000;
	slob_t *best_slob = NULL;
	slob_t *best_slob_prev = NULL;

	for (; ; prev = cur, cur = cur->next) {
c01066e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066ea:	8b 40 04             	mov    0x4(%eax),%eax
c01066ed:	89 45 ec             	mov    %eax,-0x14(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c01066f0:	e9 b9 fe ff ff       	jmp    c01065ae <best_fit_alloc+0x8e>
}
c01066f5:	c9                   	leave  
c01066f6:	c3                   	ret    

c01066f7 <slob_alloc>:

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c01066f7:	55                   	push   %ebp
c01066f8:	89 e5                	mov    %esp,%ebp
c01066fa:	83 ec 08             	sub    $0x8,%esp
#ifdef USE_BEST_FIT
	return best_fit_alloc(size, gfp, align);
c01066fd:	83 ec 04             	sub    $0x4,%esp
c0106700:	ff 75 10             	pushl  0x10(%ebp)
c0106703:	ff 75 0c             	pushl  0xc(%ebp)
c0106706:	ff 75 08             	pushl  0x8(%ebp)
c0106709:	e8 12 fe ff ff       	call   c0106520 <best_fit_alloc>
c010670e:	83 c4 10             	add    $0x10,%esp
#else
	return first_fit_alloc(size, gfp, align);
#endif
}
c0106711:	c9                   	leave  
c0106712:	c3                   	ret    

c0106713 <slob_free>:

static void slob_free(void *block, int size)
{
c0106713:	55                   	push   %ebp
c0106714:	89 e5                	mov    %esp,%ebp
c0106716:	83 ec 18             	sub    $0x18,%esp
	slob_t *cur, *b = (slob_t *)block;
c0106719:	8b 45 08             	mov    0x8(%ebp),%eax
c010671c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c010671f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106723:	0f 84 05 01 00 00    	je     c010682e <slob_free+0x11b>
		return;

	if (size)
c0106729:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010672d:	74 10                	je     c010673f <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c010672f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106732:	83 c0 07             	add    $0x7,%eax
c0106735:	c1 e8 03             	shr    $0x3,%eax
c0106738:	89 c2                	mov    %eax,%edx
c010673a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010673d:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c010673f:	e8 6f fa ff ff       	call   c01061b3 <__intr_save>
c0106744:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0106747:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c010674c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010674f:	eb 27                	jmp    c0106778 <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0106751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106754:	8b 40 04             	mov    0x4(%eax),%eax
c0106757:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010675a:	77 13                	ja     c010676f <slob_free+0x5c>
c010675c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010675f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106762:	77 27                	ja     c010678b <slob_free+0x78>
c0106764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106767:	8b 40 04             	mov    0x4(%eax),%eax
c010676a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010676d:	77 1c                	ja     c010678b <slob_free+0x78>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c010676f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106772:	8b 40 04             	mov    0x4(%eax),%eax
c0106775:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106778:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010677b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010677e:	76 d1                	jbe    c0106751 <slob_free+0x3e>
c0106780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106783:	8b 40 04             	mov    0x4(%eax),%eax
c0106786:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106789:	76 c6                	jbe    c0106751 <slob_free+0x3e>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c010678b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010678e:	8b 00                	mov    (%eax),%eax
c0106790:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0106797:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010679a:	01 c2                	add    %eax,%edx
c010679c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010679f:	8b 40 04             	mov    0x4(%eax),%eax
c01067a2:	39 c2                	cmp    %eax,%edx
c01067a4:	75 25                	jne    c01067cb <slob_free+0xb8>
		b->units += cur->next->units;
c01067a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067a9:	8b 10                	mov    (%eax),%edx
c01067ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067ae:	8b 40 04             	mov    0x4(%eax),%eax
c01067b1:	8b 00                	mov    (%eax),%eax
c01067b3:	01 c2                	add    %eax,%edx
c01067b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067b8:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c01067ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067bd:	8b 40 04             	mov    0x4(%eax),%eax
c01067c0:	8b 50 04             	mov    0x4(%eax),%edx
c01067c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067c6:	89 50 04             	mov    %edx,0x4(%eax)
c01067c9:	eb 0c                	jmp    c01067d7 <slob_free+0xc4>
	} else
		b->next = cur->next;
c01067cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067ce:	8b 50 04             	mov    0x4(%eax),%edx
c01067d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067d4:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c01067d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067da:	8b 00                	mov    (%eax),%eax
c01067dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01067e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067e6:	01 d0                	add    %edx,%eax
c01067e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01067eb:	75 1f                	jne    c010680c <slob_free+0xf9>
		cur->units += b->units;
c01067ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067f0:	8b 10                	mov    (%eax),%edx
c01067f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067f5:	8b 00                	mov    (%eax),%eax
c01067f7:	01 c2                	add    %eax,%edx
c01067f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067fc:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c01067fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106801:	8b 50 04             	mov    0x4(%eax),%edx
c0106804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106807:	89 50 04             	mov    %edx,0x4(%eax)
c010680a:	eb 09                	jmp    c0106815 <slob_free+0x102>
	} else
		cur->next = b;
c010680c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010680f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106812:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0106815:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106818:	a3 40 6a 12 c0       	mov    %eax,0xc0126a40

	spin_unlock_irqrestore(&slob_lock, flags);
c010681d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106820:	83 ec 0c             	sub    $0xc,%esp
c0106823:	50                   	push   %eax
c0106824:	e8 b4 f9 ff ff       	call   c01061dd <__intr_restore>
c0106829:	83 c4 10             	add    $0x10,%esp
c010682c:	eb 01                	jmp    c010682f <slob_free+0x11c>
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
		return;
c010682e:	90                   	nop
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}
c010682f:	c9                   	leave  
c0106830:	c3                   	ret    

c0106831 <slob_init>:



void
slob_init(void) {
c0106831:	55                   	push   %ebp
c0106832:	89 e5                	mov    %esp,%ebp
c0106834:	83 ec 08             	sub    $0x8,%esp
  cprintf("use SLOB allocator\n");
c0106837:	83 ec 0c             	sub    $0xc,%esp
c010683a:	68 65 b7 10 c0       	push   $0xc010b765
c010683f:	e8 3a 9a ff ff       	call   c010027e <cprintf>
c0106844:	83 c4 10             	add    $0x10,%esp
}
c0106847:	90                   	nop
c0106848:	c9                   	leave  
c0106849:	c3                   	ret    

c010684a <kmalloc_init>:

inline void 
kmalloc_init(void) {
c010684a:	55                   	push   %ebp
c010684b:	89 e5                	mov    %esp,%ebp
c010684d:	83 ec 08             	sub    $0x8,%esp
    slob_init();
c0106850:	e8 dc ff ff ff       	call   c0106831 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0106855:	83 ec 0c             	sub    $0xc,%esp
c0106858:	68 79 b7 10 c0       	push   $0xc010b779
c010685d:	e8 1c 9a ff ff       	call   c010027e <cprintf>
c0106862:	83 c4 10             	add    $0x10,%esp
}
c0106865:	90                   	nop
c0106866:	c9                   	leave  
c0106867:	c3                   	ret    

c0106868 <slob_allocated>:

size_t
slob_allocated(void) {
c0106868:	55                   	push   %ebp
c0106869:	89 e5                	mov    %esp,%ebp
  return 0;
c010686b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106870:	5d                   	pop    %ebp
c0106871:	c3                   	ret    

c0106872 <kallocated>:

size_t
kallocated(void) {
c0106872:	55                   	push   %ebp
c0106873:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0106875:	e8 ee ff ff ff       	call   c0106868 <slob_allocated>
}
c010687a:	5d                   	pop    %ebp
c010687b:	c3                   	ret    

c010687c <find_order>:

static int find_order(int size)
{
c010687c:	55                   	push   %ebp
c010687d:	89 e5                	mov    %esp,%ebp
c010687f:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0106882:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0106889:	eb 07                	jmp    c0106892 <find_order+0x16>
		order++;
c010688b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c010688f:	d1 7d 08             	sarl   0x8(%ebp)
c0106892:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0106899:	7f f0                	jg     c010688b <find_order+0xf>
		order++;
	return order;
c010689b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010689e:	c9                   	leave  
c010689f:	c3                   	ret    

c01068a0 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c01068a0:	55                   	push   %ebp
c01068a1:	89 e5                	mov    %esp,%ebp
c01068a3:	83 ec 18             	sub    $0x18,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c01068a6:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c01068ad:	77 35                	ja     c01068e4 <__kmalloc+0x44>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c01068af:	8b 45 08             	mov    0x8(%ebp),%eax
c01068b2:	83 c0 08             	add    $0x8,%eax
c01068b5:	83 ec 04             	sub    $0x4,%esp
c01068b8:	6a 00                	push   $0x0
c01068ba:	ff 75 0c             	pushl  0xc(%ebp)
c01068bd:	50                   	push   %eax
c01068be:	e8 34 fe ff ff       	call   c01066f7 <slob_alloc>
c01068c3:	83 c4 10             	add    $0x10,%esp
c01068c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c01068c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068cd:	74 0b                	je     c01068da <__kmalloc+0x3a>
c01068cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068d2:	83 c0 08             	add    $0x8,%eax
c01068d5:	e9 b3 00 00 00       	jmp    c010698d <__kmalloc+0xed>
c01068da:	b8 00 00 00 00       	mov    $0x0,%eax
c01068df:	e9 a9 00 00 00       	jmp    c010698d <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c01068e4:	83 ec 04             	sub    $0x4,%esp
c01068e7:	6a 00                	push   $0x0
c01068e9:	ff 75 0c             	pushl  0xc(%ebp)
c01068ec:	6a 0c                	push   $0xc
c01068ee:	e8 04 fe ff ff       	call   c01066f7 <slob_alloc>
c01068f3:	83 c4 10             	add    $0x10,%esp
c01068f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c01068f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068fd:	75 0a                	jne    c0106909 <__kmalloc+0x69>
		return 0;
c01068ff:	b8 00 00 00 00       	mov    $0x0,%eax
c0106904:	e9 84 00 00 00       	jmp    c010698d <__kmalloc+0xed>

	bb->order = find_order(size);
c0106909:	8b 45 08             	mov    0x8(%ebp),%eax
c010690c:	83 ec 0c             	sub    $0xc,%esp
c010690f:	50                   	push   %eax
c0106910:	e8 67 ff ff ff       	call   c010687c <find_order>
c0106915:	83 c4 10             	add    $0x10,%esp
c0106918:	89 c2                	mov    %eax,%edx
c010691a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010691d:	89 10                	mov    %edx,(%eax)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c010691f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106922:	8b 00                	mov    (%eax),%eax
c0106924:	83 ec 08             	sub    $0x8,%esp
c0106927:	50                   	push   %eax
c0106928:	ff 75 0c             	pushl  0xc(%ebp)
c010692b:	e8 a8 f9 ff ff       	call   c01062d8 <__slob_get_free_pages>
c0106930:	83 c4 10             	add    $0x10,%esp
c0106933:	89 c2                	mov    %eax,%edx
c0106935:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106938:	89 50 04             	mov    %edx,0x4(%eax)

	if (bb->pages) {
c010693b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010693e:	8b 40 04             	mov    0x4(%eax),%eax
c0106941:	85 c0                	test   %eax,%eax
c0106943:	74 33                	je     c0106978 <__kmalloc+0xd8>
		spin_lock_irqsave(&block_lock, flags);
c0106945:	e8 69 f8 ff ff       	call   c01061b3 <__intr_save>
c010694a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c010694d:	8b 15 dc 7a 12 c0    	mov    0xc0127adc,%edx
c0106953:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106956:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0106959:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010695c:	a3 dc 7a 12 c0       	mov    %eax,0xc0127adc
		spin_unlock_irqrestore(&block_lock, flags);
c0106961:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106964:	83 ec 0c             	sub    $0xc,%esp
c0106967:	50                   	push   %eax
c0106968:	e8 70 f8 ff ff       	call   c01061dd <__intr_restore>
c010696d:	83 c4 10             	add    $0x10,%esp
		return bb->pages;
c0106970:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106973:	8b 40 04             	mov    0x4(%eax),%eax
c0106976:	eb 15                	jmp    c010698d <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0106978:	83 ec 08             	sub    $0x8,%esp
c010697b:	6a 0c                	push   $0xc
c010697d:	ff 75 f0             	pushl  -0x10(%ebp)
c0106980:	e8 8e fd ff ff       	call   c0106713 <slob_free>
c0106985:	83 c4 10             	add    $0x10,%esp
	return 0;
c0106988:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010698d:	c9                   	leave  
c010698e:	c3                   	ret    

c010698f <kmalloc>:

void *
kmalloc(size_t size)
{
c010698f:	55                   	push   %ebp
c0106990:	89 e5                	mov    %esp,%ebp
c0106992:	83 ec 08             	sub    $0x8,%esp
  return __kmalloc(size, 0);
c0106995:	83 ec 08             	sub    $0x8,%esp
c0106998:	6a 00                	push   $0x0
c010699a:	ff 75 08             	pushl  0x8(%ebp)
c010699d:	e8 fe fe ff ff       	call   c01068a0 <__kmalloc>
c01069a2:	83 c4 10             	add    $0x10,%esp
}
c01069a5:	c9                   	leave  
c01069a6:	c3                   	ret    

c01069a7 <kfree>:


void kfree(void *block)
{
c01069a7:	55                   	push   %ebp
c01069a8:	89 e5                	mov    %esp,%ebp
c01069aa:	83 ec 18             	sub    $0x18,%esp
	bigblock_t *bb, **last = &bigblocks;
c01069ad:	c7 45 f0 dc 7a 12 c0 	movl   $0xc0127adc,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01069b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01069b8:	0f 84 ac 00 00 00    	je     c0106a6a <kfree+0xc3>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01069be:	8b 45 08             	mov    0x8(%ebp),%eax
c01069c1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01069c6:	85 c0                	test   %eax,%eax
c01069c8:	0f 85 85 00 00 00    	jne    c0106a53 <kfree+0xac>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c01069ce:	e8 e0 f7 ff ff       	call   c01061b3 <__intr_save>
c01069d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01069d6:	a1 dc 7a 12 c0       	mov    0xc0127adc,%eax
c01069db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01069de:	eb 5e                	jmp    c0106a3e <kfree+0x97>
			if (bb->pages == block) {
c01069e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069e3:	8b 40 04             	mov    0x4(%eax),%eax
c01069e6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01069e9:	75 41                	jne    c0106a2c <kfree+0x85>
				*last = bb->next;
c01069eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069ee:	8b 50 08             	mov    0x8(%eax),%edx
c01069f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01069f4:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c01069f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069f9:	83 ec 0c             	sub    $0xc,%esp
c01069fc:	50                   	push   %eax
c01069fd:	e8 db f7 ff ff       	call   c01061dd <__intr_restore>
c0106a02:	83 c4 10             	add    $0x10,%esp
				__slob_free_pages((unsigned long)block, bb->order);
c0106a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a08:	8b 10                	mov    (%eax),%edx
c0106a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a0d:	83 ec 08             	sub    $0x8,%esp
c0106a10:	52                   	push   %edx
c0106a11:	50                   	push   %eax
c0106a12:	e8 01 f9 ff ff       	call   c0106318 <__slob_free_pages>
c0106a17:	83 c4 10             	add    $0x10,%esp
				slob_free(bb, sizeof(bigblock_t));
c0106a1a:	83 ec 08             	sub    $0x8,%esp
c0106a1d:	6a 0c                	push   $0xc
c0106a1f:	ff 75 f4             	pushl  -0xc(%ebp)
c0106a22:	e8 ec fc ff ff       	call   c0106713 <slob_free>
c0106a27:	83 c4 10             	add    $0x10,%esp
				return;
c0106a2a:	eb 3f                	jmp    c0106a6b <kfree+0xc4>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0106a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a2f:	83 c0 08             	add    $0x8,%eax
c0106a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a38:	8b 40 08             	mov    0x8(%eax),%eax
c0106a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106a42:	75 9c                	jne    c01069e0 <kfree+0x39>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0106a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a47:	83 ec 0c             	sub    $0xc,%esp
c0106a4a:	50                   	push   %eax
c0106a4b:	e8 8d f7 ff ff       	call   c01061dd <__intr_restore>
c0106a50:	83 c4 10             	add    $0x10,%esp
	}

	slob_free((slob_t *)block - 1, 0);
c0106a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a56:	83 e8 08             	sub    $0x8,%eax
c0106a59:	83 ec 08             	sub    $0x8,%esp
c0106a5c:	6a 00                	push   $0x0
c0106a5e:	50                   	push   %eax
c0106a5f:	e8 af fc ff ff       	call   c0106713 <slob_free>
c0106a64:	83 c4 10             	add    $0x10,%esp
	return;
c0106a67:	90                   	nop
c0106a68:	eb 01                	jmp    c0106a6b <kfree+0xc4>
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;
c0106a6a:	90                   	nop
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
c0106a6b:	c9                   	leave  
c0106a6c:	c3                   	ret    

c0106a6d <ksize>:


unsigned int ksize(const void *block)
{
c0106a6d:	55                   	push   %ebp
c0106a6e:	89 e5                	mov    %esp,%ebp
c0106a70:	83 ec 18             	sub    $0x18,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0106a73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106a77:	75 07                	jne    c0106a80 <ksize+0x13>
		return 0;
c0106a79:	b8 00 00 00 00       	mov    $0x0,%eax
c0106a7e:	eb 73                	jmp    c0106af3 <ksize+0x86>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0106a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a83:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106a88:	85 c0                	test   %eax,%eax
c0106a8a:	75 5c                	jne    c0106ae8 <ksize+0x7b>
		spin_lock_irqsave(&block_lock, flags);
c0106a8c:	e8 22 f7 ff ff       	call   c01061b3 <__intr_save>
c0106a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0106a94:	a1 dc 7a 12 c0       	mov    0xc0127adc,%eax
c0106a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106a9c:	eb 35                	jmp    c0106ad3 <ksize+0x66>
			if (bb->pages == block) {
c0106a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106aa1:	8b 40 04             	mov    0x4(%eax),%eax
c0106aa4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0106aa7:	75 21                	jne    c0106aca <ksize+0x5d>
				spin_unlock_irqrestore(&slob_lock, flags);
c0106aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106aac:	83 ec 0c             	sub    $0xc,%esp
c0106aaf:	50                   	push   %eax
c0106ab0:	e8 28 f7 ff ff       	call   c01061dd <__intr_restore>
c0106ab5:	83 c4 10             	add    $0x10,%esp
				return PAGE_SIZE << bb->order;
c0106ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106abb:	8b 00                	mov    (%eax),%eax
c0106abd:	ba 00 10 00 00       	mov    $0x1000,%edx
c0106ac2:	89 c1                	mov    %eax,%ecx
c0106ac4:	d3 e2                	shl    %cl,%edx
c0106ac6:	89 d0                	mov    %edx,%eax
c0106ac8:	eb 29                	jmp    c0106af3 <ksize+0x86>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0106aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106acd:	8b 40 08             	mov    0x8(%eax),%eax
c0106ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ad7:	75 c5                	jne    c0106a9e <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0106ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106adc:	83 ec 0c             	sub    $0xc,%esp
c0106adf:	50                   	push   %eax
c0106ae0:	e8 f8 f6 ff ff       	call   c01061dd <__intr_restore>
c0106ae5:	83 c4 10             	add    $0x10,%esp
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0106ae8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aeb:	83 e8 08             	sub    $0x8,%eax
c0106aee:	8b 00                	mov    (%eax),%eax
c0106af0:	c1 e0 03             	shl    $0x3,%eax
}
c0106af3:	c9                   	leave  
c0106af4:	c3                   	ret    

c0106af5 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106af5:	55                   	push   %ebp
c0106af6:	89 e5                	mov    %esp,%ebp
c0106af8:	83 ec 10             	sub    $0x10,%esp
c0106afb:	c7 45 fc 04 9c 12 c0 	movl   $0xc0129c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106b02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b05:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106b08:	89 50 04             	mov    %edx,0x4(%eax)
c0106b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b0e:	8b 50 04             	mov    0x4(%eax),%edx
c0106b11:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b14:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b19:	c7 40 14 04 9c 12 c0 	movl   $0xc0129c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b25:	c9                   	leave  
c0106b26:	c3                   	ret    

c0106b27 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106b27:	55                   	push   %ebp
c0106b28:	89 e5                	mov    %esp,%ebp
c0106b2a:	83 ec 28             	sub    $0x28,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b30:	8b 40 14             	mov    0x14(%eax),%eax
c0106b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106b36:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b39:	83 c0 14             	add    $0x14,%eax
c0106b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106b43:	74 06                	je     c0106b4b <_fifo_map_swappable+0x24>
c0106b45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106b49:	75 16                	jne    c0106b61 <_fifo_map_swappable+0x3a>
c0106b4b:	68 94 b7 10 c0       	push   $0xc010b794
c0106b50:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106b55:	6a 32                	push   $0x32
c0106b57:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106b5c:	e8 83 98 ff ff       	call   c01003e4 <__panic>
c0106b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0106b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b70:	8b 00                	mov    (%eax),%eax
c0106b72:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106b75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106b78:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106b81:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106b84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b87:	89 10                	mov    %edx,(%eax)
c0106b89:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106b8c:	8b 10                	mov    (%eax),%edx
c0106b8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b91:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106b94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b97:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106b9a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ba0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106ba3:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2014011330*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c0106ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106baa:	c9                   	leave  
c0106bab:	c3                   	ret    

c0106bac <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106bac:	55                   	push   %ebp
c0106bad:	89 e5                	mov    %esp,%ebp
c0106baf:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bb5:	8b 40 14             	mov    0x14(%eax),%eax
c0106bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106bbf:	75 16                	jne    c0106bd7 <_fifo_swap_out_victim+0x2b>
c0106bc1:	68 db b7 10 c0       	push   $0xc010b7db
c0106bc6:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106bcb:	6a 41                	push   $0x41
c0106bcd:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106bd2:	e8 0d 98 ff ff       	call   c01003e4 <__panic>
     assert(in_tick==0);
c0106bd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106bdb:	74 16                	je     c0106bf3 <_fifo_swap_out_victim+0x47>
c0106bdd:	68 e8 b7 10 c0       	push   $0xc010b7e8
c0106be2:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106be7:	6a 42                	push   $0x42
c0106be9:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106bee:	e8 f1 97 ff ff       	call   c01003e4 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2014011330*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *le = head->next;
c0106bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bf6:	8b 40 04             	mov    0x4(%eax),%eax
c0106bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* p = le2page(le, pra_page_link);
c0106bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bff:	83 e8 14             	sub    $0x14,%eax
c0106c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
     *ptr_page = p;
c0106c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106c0b:	89 10                	mov    %edx,(%eax)
c0106c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c16:	8b 40 04             	mov    0x4(%eax),%eax
c0106c19:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106c1c:	8b 12                	mov    (%edx),%edx
c0106c1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106c21:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c27:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c2a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c33:	89 10                	mov    %edx,(%eax)
     list_del(le);
     return 0;
c0106c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c3a:	c9                   	leave  
c0106c3b:	c3                   	ret    

c0106c3c <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106c3c:	55                   	push   %ebp
c0106c3d:	89 e5                	mov    %esp,%ebp
c0106c3f:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106c42:	83 ec 0c             	sub    $0xc,%esp
c0106c45:	68 f4 b7 10 c0       	push   $0xc010b7f4
c0106c4a:	e8 2f 96 ff ff       	call   c010027e <cprintf>
c0106c4f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0106c52:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106c57:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106c5a:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106c5f:	83 f8 04             	cmp    $0x4,%eax
c0106c62:	74 16                	je     c0106c7a <_fifo_check_swap+0x3e>
c0106c64:	68 1a b8 10 c0       	push   $0xc010b81a
c0106c69:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106c6e:	6a 52                	push   $0x52
c0106c70:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106c75:	e8 6a 97 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106c7a:	83 ec 0c             	sub    $0xc,%esp
c0106c7d:	68 2c b8 10 c0       	push   $0xc010b82c
c0106c82:	e8 f7 95 ff ff       	call   c010027e <cprintf>
c0106c87:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0106c8a:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106c8f:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106c92:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106c97:	83 f8 04             	cmp    $0x4,%eax
c0106c9a:	74 16                	je     c0106cb2 <_fifo_check_swap+0x76>
c0106c9c:	68 1a b8 10 c0       	push   $0xc010b81a
c0106ca1:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106ca6:	6a 55                	push   $0x55
c0106ca8:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106cad:	e8 32 97 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106cb2:	83 ec 0c             	sub    $0xc,%esp
c0106cb5:	68 54 b8 10 c0       	push   $0xc010b854
c0106cba:	e8 bf 95 ff ff       	call   c010027e <cprintf>
c0106cbf:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0106cc2:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106cc7:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106cca:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106ccf:	83 f8 04             	cmp    $0x4,%eax
c0106cd2:	74 16                	je     c0106cea <_fifo_check_swap+0xae>
c0106cd4:	68 1a b8 10 c0       	push   $0xc010b81a
c0106cd9:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106cde:	6a 58                	push   $0x58
c0106ce0:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106ce5:	e8 fa 96 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106cea:	83 ec 0c             	sub    $0xc,%esp
c0106ced:	68 7c b8 10 c0       	push   $0xc010b87c
c0106cf2:	e8 87 95 ff ff       	call   c010027e <cprintf>
c0106cf7:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0106cfa:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106cff:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106d02:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106d07:	83 f8 04             	cmp    $0x4,%eax
c0106d0a:	74 16                	je     c0106d22 <_fifo_check_swap+0xe6>
c0106d0c:	68 1a b8 10 c0       	push   $0xc010b81a
c0106d11:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106d16:	6a 5b                	push   $0x5b
c0106d18:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106d1d:	e8 c2 96 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106d22:	83 ec 0c             	sub    $0xc,%esp
c0106d25:	68 a4 b8 10 c0       	push   $0xc010b8a4
c0106d2a:	e8 4f 95 ff ff       	call   c010027e <cprintf>
c0106d2f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0106d32:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106d37:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106d3a:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106d3f:	83 f8 05             	cmp    $0x5,%eax
c0106d42:	74 16                	je     c0106d5a <_fifo_check_swap+0x11e>
c0106d44:	68 ca b8 10 c0       	push   $0xc010b8ca
c0106d49:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106d4e:	6a 5e                	push   $0x5e
c0106d50:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106d55:	e8 8a 96 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106d5a:	83 ec 0c             	sub    $0xc,%esp
c0106d5d:	68 7c b8 10 c0       	push   $0xc010b87c
c0106d62:	e8 17 95 ff ff       	call   c010027e <cprintf>
c0106d67:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0106d6a:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106d6f:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106d72:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106d77:	83 f8 05             	cmp    $0x5,%eax
c0106d7a:	74 16                	je     c0106d92 <_fifo_check_swap+0x156>
c0106d7c:	68 ca b8 10 c0       	push   $0xc010b8ca
c0106d81:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106d86:	6a 61                	push   $0x61
c0106d88:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106d8d:	e8 52 96 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106d92:	83 ec 0c             	sub    $0xc,%esp
c0106d95:	68 2c b8 10 c0       	push   $0xc010b82c
c0106d9a:	e8 df 94 ff ff       	call   c010027e <cprintf>
c0106d9f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0106da2:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106da7:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106daa:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106daf:	83 f8 06             	cmp    $0x6,%eax
c0106db2:	74 16                	je     c0106dca <_fifo_check_swap+0x18e>
c0106db4:	68 d9 b8 10 c0       	push   $0xc010b8d9
c0106db9:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106dbe:	6a 64                	push   $0x64
c0106dc0:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106dc5:	e8 1a 96 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106dca:	83 ec 0c             	sub    $0xc,%esp
c0106dcd:	68 7c b8 10 c0       	push   $0xc010b87c
c0106dd2:	e8 a7 94 ff ff       	call   c010027e <cprintf>
c0106dd7:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0106dda:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ddf:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106de2:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106de7:	83 f8 07             	cmp    $0x7,%eax
c0106dea:	74 16                	je     c0106e02 <_fifo_check_swap+0x1c6>
c0106dec:	68 e8 b8 10 c0       	push   $0xc010b8e8
c0106df1:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106df6:	6a 67                	push   $0x67
c0106df8:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106dfd:	e8 e2 95 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106e02:	83 ec 0c             	sub    $0xc,%esp
c0106e05:	68 f4 b7 10 c0       	push   $0xc010b7f4
c0106e0a:	e8 6f 94 ff ff       	call   c010027e <cprintf>
c0106e0f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0106e12:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106e17:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106e1a:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106e1f:	83 f8 08             	cmp    $0x8,%eax
c0106e22:	74 16                	je     c0106e3a <_fifo_check_swap+0x1fe>
c0106e24:	68 f7 b8 10 c0       	push   $0xc010b8f7
c0106e29:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106e2e:	6a 6a                	push   $0x6a
c0106e30:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106e35:	e8 aa 95 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106e3a:	83 ec 0c             	sub    $0xc,%esp
c0106e3d:	68 54 b8 10 c0       	push   $0xc010b854
c0106e42:	e8 37 94 ff ff       	call   c010027e <cprintf>
c0106e47:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0106e4a:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106e4f:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106e52:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106e57:	83 f8 09             	cmp    $0x9,%eax
c0106e5a:	74 16                	je     c0106e72 <_fifo_check_swap+0x236>
c0106e5c:	68 06 b9 10 c0       	push   $0xc010b906
c0106e61:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106e66:	6a 6d                	push   $0x6d
c0106e68:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106e6d:	e8 72 95 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106e72:	83 ec 0c             	sub    $0xc,%esp
c0106e75:	68 a4 b8 10 c0       	push   $0xc010b8a4
c0106e7a:	e8 ff 93 ff ff       	call   c010027e <cprintf>
c0106e7f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0106e82:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106e87:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0106e8a:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106e8f:	83 f8 0a             	cmp    $0xa,%eax
c0106e92:	74 16                	je     c0106eaa <_fifo_check_swap+0x26e>
c0106e94:	68 15 b9 10 c0       	push   $0xc010b915
c0106e99:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106e9e:	6a 70                	push   $0x70
c0106ea0:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106ea5:	e8 3a 95 ff ff       	call   c01003e4 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106eaa:	83 ec 0c             	sub    $0xc,%esp
c0106ead:	68 2c b8 10 c0       	push   $0xc010b82c
c0106eb2:	e8 c7 93 ff ff       	call   c010027e <cprintf>
c0106eb7:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c0106eba:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106ebf:	0f b6 00             	movzbl (%eax),%eax
c0106ec2:	3c 0a                	cmp    $0xa,%al
c0106ec4:	74 16                	je     c0106edc <_fifo_check_swap+0x2a0>
c0106ec6:	68 28 b9 10 c0       	push   $0xc010b928
c0106ecb:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106ed0:	6a 72                	push   $0x72
c0106ed2:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106ed7:	e8 08 95 ff ff       	call   c01003e4 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0106edc:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106ee1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0106ee4:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0106ee9:	83 f8 0b             	cmp    $0xb,%eax
c0106eec:	74 16                	je     c0106f04 <_fifo_check_swap+0x2c8>
c0106eee:	68 49 b9 10 c0       	push   $0xc010b949
c0106ef3:	68 b2 b7 10 c0       	push   $0xc010b7b2
c0106ef8:	6a 74                	push   $0x74
c0106efa:	68 c7 b7 10 c0       	push   $0xc010b7c7
c0106eff:	e8 e0 94 ff ff       	call   c01003e4 <__panic>
    return 0;
c0106f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f09:	c9                   	leave  
c0106f0a:	c3                   	ret    

c0106f0b <_fifo_init>:


static int
_fifo_init(void)
{
c0106f0b:	55                   	push   %ebp
c0106f0c:	89 e5                	mov    %esp,%ebp
    return 0;
c0106f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f13:	5d                   	pop    %ebp
c0106f14:	c3                   	ret    

c0106f15 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106f15:	55                   	push   %ebp
c0106f16:	89 e5                	mov    %esp,%ebp
    return 0;
c0106f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f1d:	5d                   	pop    %ebp
c0106f1e:	c3                   	ret    

c0106f1f <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0106f1f:	55                   	push   %ebp
c0106f20:	89 e5                	mov    %esp,%ebp
c0106f22:	b8 00 00 00 00       	mov    $0x0,%eax
c0106f27:	5d                   	pop    %ebp
c0106f28:	c3                   	ret    

c0106f29 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0106f29:	55                   	push   %ebp
c0106f2a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0106f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f2f:	8b 15 20 9b 12 c0    	mov    0xc0129b20,%edx
c0106f35:	29 d0                	sub    %edx,%eax
c0106f37:	c1 f8 05             	sar    $0x5,%eax
}
c0106f3a:	5d                   	pop    %ebp
c0106f3b:	c3                   	ret    

c0106f3c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0106f3c:	55                   	push   %ebp
c0106f3d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0106f3f:	ff 75 08             	pushl  0x8(%ebp)
c0106f42:	e8 e2 ff ff ff       	call   c0106f29 <page2ppn>
c0106f47:	83 c4 04             	add    $0x4,%esp
c0106f4a:	c1 e0 0c             	shl    $0xc,%eax
}
c0106f4d:	c9                   	leave  
c0106f4e:	c3                   	ret    

c0106f4f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0106f4f:	55                   	push   %ebp
c0106f50:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106f52:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f55:	8b 00                	mov    (%eax),%eax
}
c0106f57:	5d                   	pop    %ebp
c0106f58:	c3                   	ret    

c0106f59 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0106f59:	55                   	push   %ebp
c0106f5a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f62:	89 10                	mov    %edx,(%eax)
}
c0106f64:	90                   	nop
c0106f65:	5d                   	pop    %ebp
c0106f66:	c3                   	ret    

c0106f67 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0106f67:	55                   	push   %ebp
c0106f68:	89 e5                	mov    %esp,%ebp
c0106f6a:	83 ec 10             	sub    $0x10,%esp
c0106f6d:	c7 45 fc 0c 9c 12 c0 	movl   $0xc0129c0c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f77:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106f7a:	89 50 04             	mov    %edx,0x4(%eax)
c0106f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f80:	8b 50 04             	mov    0x4(%eax),%edx
c0106f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f86:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0106f88:	c7 05 14 9c 12 c0 00 	movl   $0x0,0xc0129c14
c0106f8f:	00 00 00 
}
c0106f92:	90                   	nop
c0106f93:	c9                   	leave  
c0106f94:	c3                   	ret    

c0106f95 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0106f95:	55                   	push   %ebp
c0106f96:	89 e5                	mov    %esp,%ebp
c0106f98:	83 ec 38             	sub    $0x38,%esp
	assert(n > 0);
c0106f9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106f9f:	75 16                	jne    c0106fb7 <default_init_memmap+0x22>
c0106fa1:	68 6c b9 10 c0       	push   $0xc010b96c
c0106fa6:	68 72 b9 10 c0       	push   $0xc010b972
c0106fab:	6a 46                	push   $0x46
c0106fad:	68 87 b9 10 c0       	push   $0xc010b987
c0106fb2:	e8 2d 94 ff ff       	call   c01003e4 <__panic>
	struct Page *p = base;
c0106fb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p ++) {
c0106fbd:	eb 6c                	jmp    c010702b <default_init_memmap+0x96>
		// Before: the page must have been set reserved in page_init.
		assert(PageReserved(p));
c0106fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106fc2:	83 c0 04             	add    $0x4,%eax
c0106fc5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0106fcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106fd5:	0f a3 10             	bt     %edx,(%eax)
c0106fd8:	19 c0                	sbb    %eax,%eax
c0106fda:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0106fdd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106fe1:	0f 95 c0             	setne  %al
c0106fe4:	0f b6 c0             	movzbl %al,%eax
c0106fe7:	85 c0                	test   %eax,%eax
c0106fe9:	75 16                	jne    c0107001 <default_init_memmap+0x6c>
c0106feb:	68 9d b9 10 c0       	push   $0xc010b99d
c0106ff0:	68 72 b9 10 c0       	push   $0xc010b972
c0106ff5:	6a 4a                	push   $0x4a
c0106ff7:	68 87 b9 10 c0       	push   $0xc010b987
c0106ffc:	e8 e3 93 ff ff       	call   c01003e4 <__panic>
		// Initialize flags, property and ref
		p->flags = p->property = 0;
c0107001:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107004:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010700b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010700e:	8b 50 08             	mov    0x8(%eax),%edx
c0107011:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107014:	89 50 04             	mov    %edx,0x4(%eax)
		set_page_ref(p, 0);
c0107017:	83 ec 08             	sub    $0x8,%esp
c010701a:	6a 00                	push   $0x0
c010701c:	ff 75 f4             	pushl  -0xc(%ebp)
c010701f:	e8 35 ff ff ff       	call   c0106f59 <set_page_ref>
c0107024:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page *p = base;
	for (; p != base + n; p ++) {
c0107027:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010702b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010702e:	c1 e0 05             	shl    $0x5,%eax
c0107031:	89 c2                	mov    %eax,%edx
c0107033:	8b 45 08             	mov    0x8(%ebp),%eax
c0107036:	01 d0                	add    %edx,%eax
c0107038:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010703b:	75 82                	jne    c0106fbf <default_init_memmap+0x2a>
		// Initialize flags, property and ref
		p->flags = p->property = 0;
		set_page_ref(p, 0);
	}
	// The base page is the start of continuous free pages.
	base->property = n;
c010703d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107040:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107043:	89 50 08             	mov    %edx,0x8(%eax)
	SetPageProperty(base);
c0107046:	8b 45 08             	mov    0x8(%ebp),%eax
c0107049:	83 c0 04             	add    $0x4,%eax
c010704c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0107053:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0107056:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107059:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010705c:	0f ab 10             	bts    %edx,(%eax)
	nr_free += n;
c010705f:	8b 15 14 9c 12 c0    	mov    0xc0129c14,%edx
c0107065:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107068:	01 d0                	add    %edx,%eax
c010706a:	a3 14 9c 12 c0       	mov    %eax,0xc0129c14
	list_add_before(&free_list, &(base->page_link));
c010706f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107072:	83 c0 0c             	add    $0xc,%eax
c0107075:	c7 45 f0 0c 9c 12 c0 	movl   $0xc0129c0c,-0x10(%ebp)
c010707c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010707f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107082:	8b 00                	mov    (%eax),%eax
c0107084:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107087:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010708a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010708d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107090:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107093:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107096:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107099:	89 10                	mov    %edx,(%eax)
c010709b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010709e:	8b 10                	mov    (%eax),%edx
c01070a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01070a3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01070a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01070a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01070ac:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01070af:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01070b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070b5:	89 10                	mov    %edx,(%eax)
}
c01070b7:	90                   	nop
c01070b8:	c9                   	leave  
c01070b9:	c3                   	ret    

c01070ba <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01070ba:	55                   	push   %ebp
c01070bb:	89 e5                	mov    %esp,%ebp
c01070bd:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01070c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01070c4:	75 16                	jne    c01070dc <default_alloc_pages+0x22>
c01070c6:	68 6c b9 10 c0       	push   $0xc010b96c
c01070cb:	68 72 b9 10 c0       	push   $0xc010b972
c01070d0:	6a 58                	push   $0x58
c01070d2:	68 87 b9 10 c0       	push   $0xc010b987
c01070d7:	e8 08 93 ff ff       	call   c01003e4 <__panic>
    if (n > nr_free) {
c01070dc:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c01070e1:	3b 45 08             	cmp    0x8(%ebp),%eax
c01070e4:	73 0a                	jae    c01070f0 <default_alloc_pages+0x36>
        return NULL;
c01070e6:	b8 00 00 00 00       	mov    $0x0,%eax
c01070eb:	e9 9a 01 00 00       	jmp    c010728a <default_alloc_pages+0x1d0>
    }
    struct Page *page = NULL;
c01070f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01070f7:	c7 45 f0 0c 9c 12 c0 	movl   $0xc0129c0c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01070fe:	eb 1c                	jmp    c010711c <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c0107100:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107103:	83 e8 0c             	sub    $0xc,%eax
c0107106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c0107109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010710c:	8b 40 08             	mov    0x8(%eax),%eax
c010710f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0107112:	72 08                	jb     c010711c <default_alloc_pages+0x62>
            page = p;
c0107114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107117:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010711a:	eb 18                	jmp    c0107134 <default_alloc_pages+0x7a>
c010711c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010711f:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107122:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107125:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0107128:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010712b:	81 7d f0 0c 9c 12 c0 	cmpl   $0xc0129c0c,-0x10(%ebp)
c0107132:	75 cc                	jne    c0107100 <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0107134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107138:	0f 84 49 01 00 00    	je     c0107287 <default_alloc_pages+0x1cd>
    	for (int i = 1; i < n; ++ i) {
c010713e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0107145:	eb 47                	jmp    c010718e <default_alloc_pages+0xd4>
    		struct Page *p = page + i;
c0107147:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010714a:	c1 e0 05             	shl    $0x5,%eax
c010714d:	89 c2                	mov    %eax,%edx
c010714f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107152:	01 d0                	add    %edx,%eax
c0107154:	89 45 e0             	mov    %eax,-0x20(%ebp)
    		// assert(!PageReserved(p));
    		ClearPageProperty(p);
c0107157:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010715a:	83 c0 04             	add    $0x4,%eax
c010715d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0107164:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0107167:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010716a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010716d:	0f b3 10             	btr    %edx,(%eax)
    		p->property = 0;
c0107170:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107173:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    		set_page_ref(p, 0);
c010717a:	83 ec 08             	sub    $0x8,%esp
c010717d:	6a 00                	push   $0x0
c010717f:	ff 75 e0             	pushl  -0x20(%ebp)
c0107182:	e8 d2 fd ff ff       	call   c0106f59 <set_page_ref>
c0107187:	83 c4 10             	add    $0x10,%esp
            page = p;
            break;
        }
    }
    if (page != NULL) {
    	for (int i = 1; i < n; ++ i) {
c010718a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010718e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107191:	3b 45 08             	cmp    0x8(%ebp),%eax
c0107194:	72 b1                	jb     c0107147 <default_alloc_pages+0x8d>
    		// assert(!PageReserved(p));
    		ClearPageProperty(p);
    		p->property = 0;
    		set_page_ref(p, 0);
    	}
        if (page->property > n) {
c0107196:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107199:	8b 40 08             	mov    0x8(%eax),%eax
c010719c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010719f:	0f 86 91 00 00 00    	jbe    c0107236 <default_alloc_pages+0x17c>
            struct Page *p = page + n;
c01071a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01071a8:	c1 e0 05             	shl    $0x5,%eax
c01071ab:	89 c2                	mov    %eax,%edx
c01071ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071b0:	01 d0                	add    %edx,%eax
c01071b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;
c01071b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071b8:	8b 40 08             	mov    0x8(%eax),%eax
c01071bb:	2b 45 08             	sub    0x8(%ebp),%eax
c01071be:	89 c2                	mov    %eax,%edx
c01071c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01071c3:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01071c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01071c9:	83 c0 04             	add    $0x4,%eax
c01071cc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01071d3:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01071d6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01071d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01071dc:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
c01071df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01071e2:	83 c0 0c             	add    $0xc,%eax
c01071e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01071e8:	83 c2 0c             	add    $0xc,%edx
c01071eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01071ee:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01071f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01071f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01071f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01071fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01071fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107200:	8b 40 04             	mov    0x4(%eax),%eax
c0107203:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0107206:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0107209:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010720c:	89 55 b0             	mov    %edx,-0x50(%ebp)
c010720f:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107212:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107215:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107218:	89 10                	mov    %edx,(%eax)
c010721a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010721d:	8b 10                	mov    (%eax),%edx
c010721f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107222:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107225:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107228:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010722b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010722e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107231:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0107234:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0107236:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107239:	83 c0 0c             	add    $0xc,%eax
c010723c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010723f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107242:	8b 40 04             	mov    0x4(%eax),%eax
c0107245:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107248:	8b 12                	mov    (%edx),%edx
c010724a:	89 55 a0             	mov    %edx,-0x60(%ebp)
c010724d:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107250:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107253:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107256:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107259:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010725c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010725f:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0107261:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0107266:	2b 45 08             	sub    0x8(%ebp),%eax
c0107269:	a3 14 9c 12 c0       	mov    %eax,0xc0129c14
        ClearPageProperty(page);
c010726e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107271:	83 c0 04             	add    $0x4,%eax
c0107274:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010727b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010727e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107281:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107284:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0107287:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010728a:	c9                   	leave  
c010728b:	c3                   	ret    

c010728c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010728c:	55                   	push   %ebp
c010728d:	89 e5                	mov    %esp,%ebp
c010728f:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0107295:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107299:	75 16                	jne    c01072b1 <default_free_pages+0x25>
c010729b:	68 6c b9 10 c0       	push   $0xc010b96c
c01072a0:	68 72 b9 10 c0       	push   $0xc010b972
c01072a5:	6a 7c                	push   $0x7c
c01072a7:	68 87 b9 10 c0       	push   $0xc010b987
c01072ac:	e8 33 91 ff ff       	call   c01003e4 <__panic>
    struct Page *p = base;
c01072b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01072b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01072b7:	e9 8c 00 00 00       	jmp    c0107348 <default_free_pages+0xbc>
        assert(!PageReserved(p) && !PageProperty(p));
c01072bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072bf:	83 c0 04             	add    $0x4,%eax
c01072c2:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c01072c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01072cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01072cf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01072d2:	0f a3 10             	bt     %edx,(%eax)
c01072d5:	19 c0                	sbb    %eax,%eax
c01072d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c01072da:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c01072de:	0f 95 c0             	setne  %al
c01072e1:	0f b6 c0             	movzbl %al,%eax
c01072e4:	85 c0                	test   %eax,%eax
c01072e6:	75 2c                	jne    c0107314 <default_free_pages+0x88>
c01072e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072eb:	83 c0 04             	add    $0x4,%eax
c01072ee:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01072f5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01072f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01072fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01072fe:	0f a3 10             	bt     %edx,(%eax)
c0107301:	19 c0                	sbb    %eax,%eax
c0107303:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0107306:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010730a:	0f 95 c0             	setne  %al
c010730d:	0f b6 c0             	movzbl %al,%eax
c0107310:	85 c0                	test   %eax,%eax
c0107312:	74 16                	je     c010732a <default_free_pages+0x9e>
c0107314:	68 b0 b9 10 c0       	push   $0xc010b9b0
c0107319:	68 72 b9 10 c0       	push   $0xc010b972
c010731e:	6a 7f                	push   $0x7f
c0107320:	68 87 b9 10 c0       	push   $0xc010b987
c0107325:	e8 ba 90 ff ff       	call   c01003e4 <__panic>
        p->flags = 0;
c010732a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010732d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0107334:	83 ec 08             	sub    $0x8,%esp
c0107337:	6a 00                	push   $0x0
c0107339:	ff 75 f4             	pushl  -0xc(%ebp)
c010733c:	e8 18 fc ff ff       	call   c0106f59 <set_page_ref>
c0107341:	83 c4 10             	add    $0x10,%esp

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0107344:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0107348:	8b 45 0c             	mov    0xc(%ebp),%eax
c010734b:	c1 e0 05             	shl    $0x5,%eax
c010734e:	89 c2                	mov    %eax,%edx
c0107350:	8b 45 08             	mov    0x8(%ebp),%eax
c0107353:	01 d0                	add    %edx,%eax
c0107355:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107358:	0f 85 5e ff ff ff    	jne    c01072bc <default_free_pages+0x30>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010735e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107361:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107364:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0107367:	8b 45 08             	mov    0x8(%ebp),%eax
c010736a:	83 c0 04             	add    $0x4,%eax
c010736d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0107374:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0107377:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010737a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010737d:	0f ab 10             	bts    %edx,(%eax)
c0107380:	c7 45 e0 0c 9c 12 c0 	movl   $0xc0129c0c,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107387:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010738a:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c010738d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *merge_previous = NULL;
c0107390:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    struct Page *merge_next = NULL;
c0107397:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while (le != &free_list) {
c010739e:	eb 58                	jmp    c01073f8 <default_free_pages+0x16c>
        p = le2page(le, page_link);
c01073a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073a3:	83 e8 0c             	sub    $0xc,%eax
c01073a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01073a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01073af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073b2:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01073b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01073b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01073bb:	8b 40 08             	mov    0x8(%eax),%eax
c01073be:	c1 e0 05             	shl    $0x5,%eax
c01073c1:	89 c2                	mov    %eax,%edx
c01073c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01073c6:	01 d0                	add    %edx,%eax
c01073c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01073cb:	75 08                	jne    c01073d5 <default_free_pages+0x149>
        	merge_next = p;
c01073cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        	break;
c01073d3:	eb 2f                	jmp    c0107404 <default_free_pages+0x178>
        }
        else if (p + p->property == base) {
c01073d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073d8:	8b 40 08             	mov    0x8(%eax),%eax
c01073db:	c1 e0 05             	shl    $0x5,%eax
c01073de:	89 c2                	mov    %eax,%edx
c01073e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073e3:	01 d0                	add    %edx,%eax
c01073e5:	3b 45 08             	cmp    0x8(%ebp),%eax
c01073e8:	75 06                	jne    c01073f0 <default_free_pages+0x164>
            merge_previous = p;
c01073ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
        }
        if (p > base) break;
c01073f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073f3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01073f6:	77 0b                	ja     c0107403 <default_free_pages+0x177>
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    struct Page *merge_previous = NULL;
    struct Page *merge_next = NULL;
    while (le != &free_list) {
c01073f8:	81 7d f0 0c 9c 12 c0 	cmpl   $0xc0129c0c,-0x10(%ebp)
c01073ff:	75 9f                	jne    c01073a0 <default_free_pages+0x114>
c0107401:	eb 01                	jmp    c0107404 <default_free_pages+0x178>
        	break;
        }
        else if (p + p->property == base) {
            merge_previous = p;
        }
        if (p > base) break;
c0107403:	90                   	nop
    }
    nr_free += n;
c0107404:	8b 15 14 9c 12 c0    	mov    0xc0129c14,%edx
c010740a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010740d:	01 d0                	add    %edx,%eax
c010740f:	a3 14 9c 12 c0       	mov    %eax,0xc0129c14
    // Try to merge base with merge_previous and merge_next.
    if (merge_previous != NULL) {
c0107414:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107418:	74 33                	je     c010744d <default_free_pages+0x1c1>
    	merge_previous->property += base->property;
c010741a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010741d:	8b 50 08             	mov    0x8(%eax),%edx
c0107420:	8b 45 08             	mov    0x8(%ebp),%eax
c0107423:	8b 40 08             	mov    0x8(%eax),%eax
c0107426:	01 c2                	add    %eax,%edx
c0107428:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010742b:	89 50 08             	mov    %edx,0x8(%eax)
    	ClearPageProperty(base);
c010742e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107431:	83 c0 04             	add    $0x4,%eax
c0107434:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010743b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010743e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107441:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107444:	0f b3 10             	btr    %edx,(%eax)
    	base = merge_previous;
c0107447:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010744a:	89 45 08             	mov    %eax,0x8(%ebp)
    }
    if (merge_next != NULL) {
c010744d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107451:	0f 84 a8 00 00 00    	je     c01074ff <default_free_pages+0x273>
    	base->property += merge_next->property;
c0107457:	8b 45 08             	mov    0x8(%ebp),%eax
c010745a:	8b 50 08             	mov    0x8(%eax),%edx
c010745d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107460:	8b 40 08             	mov    0x8(%eax),%eax
c0107463:	01 c2                	add    %eax,%edx
c0107465:	8b 45 08             	mov    0x8(%ebp),%eax
c0107468:	89 50 08             	mov    %edx,0x8(%eax)
    	ClearPageProperty(merge_next);
c010746b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010746e:	83 c0 04             	add    $0x4,%eax
c0107471:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0107478:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010747b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010747e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107481:	0f b3 10             	btr    %edx,(%eax)
    	if (merge_previous == NULL) {
c0107484:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107488:	75 4a                	jne    c01074d4 <default_free_pages+0x248>
    		list_add_before(&(merge_next->page_link), &(base->page_link));
c010748a:	8b 45 08             	mov    0x8(%ebp),%eax
c010748d:	83 c0 0c             	add    $0xc,%eax
c0107490:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107493:	83 c2 0c             	add    $0xc,%edx
c0107496:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107499:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010749c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010749f:	8b 00                	mov    (%eax),%eax
c01074a1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01074a4:	89 55 98             	mov    %edx,-0x68(%ebp)
c01074a7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01074aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01074ad:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01074b0:	8b 45 90             	mov    -0x70(%ebp),%eax
c01074b3:	8b 55 98             	mov    -0x68(%ebp),%edx
c01074b6:	89 10                	mov    %edx,(%eax)
c01074b8:	8b 45 90             	mov    -0x70(%ebp),%eax
c01074bb:	8b 10                	mov    (%eax),%edx
c01074bd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01074c0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01074c3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01074c6:	8b 55 90             	mov    -0x70(%ebp),%edx
c01074c9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01074cc:	8b 45 98             	mov    -0x68(%ebp),%eax
c01074cf:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01074d2:	89 10                	mov    %edx,(%eax)
    	}

    	list_del(&(merge_next->page_link));
c01074d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074d7:	83 c0 0c             	add    $0xc,%eax
c01074da:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01074dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01074e0:	8b 40 04             	mov    0x4(%eax),%eax
c01074e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01074e6:	8b 12                	mov    (%edx),%edx
c01074e8:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01074eb:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01074ee:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01074f1:	8b 55 88             	mov    -0x78(%ebp),%edx
c01074f4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01074f7:	8b 45 88             	mov    -0x78(%ebp),%eax
c01074fa:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01074fd:	89 10                	mov    %edx,(%eax)
    }
    if (merge_next == NULL && merge_previous == NULL) {
c01074ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107503:	0f 85 f5 00 00 00    	jne    c01075fe <default_free_pages+0x372>
c0107509:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010750d:	0f 85 eb 00 00 00    	jne    c01075fe <default_free_pages+0x372>
    	if (p > base && p != (base + n)) {
c0107513:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107516:	3b 45 08             	cmp    0x8(%ebp),%eax
c0107519:	76 74                	jbe    c010758f <default_free_pages+0x303>
c010751b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010751e:	c1 e0 05             	shl    $0x5,%eax
c0107521:	89 c2                	mov    %eax,%edx
c0107523:	8b 45 08             	mov    0x8(%ebp),%eax
c0107526:	01 d0                	add    %edx,%eax
c0107528:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010752b:	74 62                	je     c010758f <default_free_pages+0x303>
    		list_add_before(&(p->page_link), &(base->page_link));
c010752d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107530:	83 c0 0c             	add    $0xc,%eax
c0107533:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107536:	83 c2 0c             	add    $0xc,%edx
c0107539:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010753c:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010753f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107542:	8b 00                	mov    (%eax),%eax
c0107544:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0107547:	89 55 80             	mov    %edx,-0x80(%ebp)
c010754a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0107550:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107553:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107559:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010755f:	8b 55 80             	mov    -0x80(%ebp),%edx
c0107562:	89 10                	mov    %edx,(%eax)
c0107564:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010756a:	8b 10                	mov    (%eax),%edx
c010756c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0107572:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107575:	8b 45 80             	mov    -0x80(%ebp),%eax
c0107578:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c010757e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107581:	8b 45 80             	mov    -0x80(%ebp),%eax
c0107584:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010758a:	89 10                	mov    %edx,(%eax)
c010758c:	90                   	nop
    	} else {
    		list_add_before(&free_list, &(base->page_link));
    	}
    }
}
c010758d:	eb 6f                	jmp    c01075fe <default_free_pages+0x372>
    }
    if (merge_next == NULL && merge_previous == NULL) {
    	if (p > base && p != (base + n)) {
    		list_add_before(&(p->page_link), &(base->page_link));
    	} else {
    		list_add_before(&free_list, &(base->page_link));
c010758f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107592:	83 c0 0c             	add    $0xc,%eax
c0107595:	c7 45 c0 0c 9c 12 c0 	movl   $0xc0129c0c,-0x40(%ebp)
c010759c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01075a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01075a5:	8b 00                	mov    (%eax),%eax
c01075a7:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c01075ad:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c01075b3:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
c01075b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01075bc:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01075c2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c01075c8:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c01075ce:	89 10                	mov    %edx,(%eax)
c01075d0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c01075d6:	8b 10                	mov    (%eax),%edx
c01075d8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c01075de:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01075e1:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c01075e7:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c01075ed:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01075f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c01075f6:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c01075fc:	89 10                	mov    %edx,(%eax)
    	}
    }
}
c01075fe:	90                   	nop
c01075ff:	c9                   	leave  
c0107600:	c3                   	ret    

c0107601 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0107601:	55                   	push   %ebp
c0107602:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0107604:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
}
c0107609:	5d                   	pop    %ebp
c010760a:	c3                   	ret    

c010760b <basic_check>:

static void
basic_check(void) {
c010760b:	55                   	push   %ebp
c010760c:	89 e5                	mov    %esp,%ebp
c010760e:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0107611:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010761b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010761e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107621:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0107624:	83 ec 0c             	sub    $0xc,%esp
c0107627:	6a 01                	push   $0x1
c0107629:	e8 61 bf ff ff       	call   c010358f <alloc_pages>
c010762e:	83 c4 10             	add    $0x10,%esp
c0107631:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107634:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107638:	75 19                	jne    c0107653 <basic_check+0x48>
c010763a:	68 d5 b9 10 c0       	push   $0xc010b9d5
c010763f:	68 72 b9 10 c0       	push   $0xc010b972
c0107644:	68 b6 00 00 00       	push   $0xb6
c0107649:	68 87 b9 10 c0       	push   $0xc010b987
c010764e:	e8 91 8d ff ff       	call   c01003e4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0107653:	83 ec 0c             	sub    $0xc,%esp
c0107656:	6a 01                	push   $0x1
c0107658:	e8 32 bf ff ff       	call   c010358f <alloc_pages>
c010765d:	83 c4 10             	add    $0x10,%esp
c0107660:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107663:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107667:	75 19                	jne    c0107682 <basic_check+0x77>
c0107669:	68 f1 b9 10 c0       	push   $0xc010b9f1
c010766e:	68 72 b9 10 c0       	push   $0xc010b972
c0107673:	68 b7 00 00 00       	push   $0xb7
c0107678:	68 87 b9 10 c0       	push   $0xc010b987
c010767d:	e8 62 8d ff ff       	call   c01003e4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0107682:	83 ec 0c             	sub    $0xc,%esp
c0107685:	6a 01                	push   $0x1
c0107687:	e8 03 bf ff ff       	call   c010358f <alloc_pages>
c010768c:	83 c4 10             	add    $0x10,%esp
c010768f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107696:	75 19                	jne    c01076b1 <basic_check+0xa6>
c0107698:	68 0d ba 10 c0       	push   $0xc010ba0d
c010769d:	68 72 b9 10 c0       	push   $0xc010b972
c01076a2:	68 b8 00 00 00       	push   $0xb8
c01076a7:	68 87 b9 10 c0       	push   $0xc010b987
c01076ac:	e8 33 8d ff ff       	call   c01003e4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01076b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01076b7:	74 10                	je     c01076c9 <basic_check+0xbe>
c01076b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01076bf:	74 08                	je     c01076c9 <basic_check+0xbe>
c01076c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01076c7:	75 19                	jne    c01076e2 <basic_check+0xd7>
c01076c9:	68 2c ba 10 c0       	push   $0xc010ba2c
c01076ce:	68 72 b9 10 c0       	push   $0xc010b972
c01076d3:	68 ba 00 00 00       	push   $0xba
c01076d8:	68 87 b9 10 c0       	push   $0xc010b987
c01076dd:	e8 02 8d ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01076e2:	83 ec 0c             	sub    $0xc,%esp
c01076e5:	ff 75 ec             	pushl  -0x14(%ebp)
c01076e8:	e8 62 f8 ff ff       	call   c0106f4f <page_ref>
c01076ed:	83 c4 10             	add    $0x10,%esp
c01076f0:	85 c0                	test   %eax,%eax
c01076f2:	75 24                	jne    c0107718 <basic_check+0x10d>
c01076f4:	83 ec 0c             	sub    $0xc,%esp
c01076f7:	ff 75 f0             	pushl  -0x10(%ebp)
c01076fa:	e8 50 f8 ff ff       	call   c0106f4f <page_ref>
c01076ff:	83 c4 10             	add    $0x10,%esp
c0107702:	85 c0                	test   %eax,%eax
c0107704:	75 12                	jne    c0107718 <basic_check+0x10d>
c0107706:	83 ec 0c             	sub    $0xc,%esp
c0107709:	ff 75 f4             	pushl  -0xc(%ebp)
c010770c:	e8 3e f8 ff ff       	call   c0106f4f <page_ref>
c0107711:	83 c4 10             	add    $0x10,%esp
c0107714:	85 c0                	test   %eax,%eax
c0107716:	74 19                	je     c0107731 <basic_check+0x126>
c0107718:	68 50 ba 10 c0       	push   $0xc010ba50
c010771d:	68 72 b9 10 c0       	push   $0xc010b972
c0107722:	68 bb 00 00 00       	push   $0xbb
c0107727:	68 87 b9 10 c0       	push   $0xc010b987
c010772c:	e8 b3 8c ff ff       	call   c01003e4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0107731:	83 ec 0c             	sub    $0xc,%esp
c0107734:	ff 75 ec             	pushl  -0x14(%ebp)
c0107737:	e8 00 f8 ff ff       	call   c0106f3c <page2pa>
c010773c:	83 c4 10             	add    $0x10,%esp
c010773f:	89 c2                	mov    %eax,%edx
c0107741:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0107746:	c1 e0 0c             	shl    $0xc,%eax
c0107749:	39 c2                	cmp    %eax,%edx
c010774b:	72 19                	jb     c0107766 <basic_check+0x15b>
c010774d:	68 8c ba 10 c0       	push   $0xc010ba8c
c0107752:	68 72 b9 10 c0       	push   $0xc010b972
c0107757:	68 bd 00 00 00       	push   $0xbd
c010775c:	68 87 b9 10 c0       	push   $0xc010b987
c0107761:	e8 7e 8c ff ff       	call   c01003e4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0107766:	83 ec 0c             	sub    $0xc,%esp
c0107769:	ff 75 f0             	pushl  -0x10(%ebp)
c010776c:	e8 cb f7 ff ff       	call   c0106f3c <page2pa>
c0107771:	83 c4 10             	add    $0x10,%esp
c0107774:	89 c2                	mov    %eax,%edx
c0107776:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c010777b:	c1 e0 0c             	shl    $0xc,%eax
c010777e:	39 c2                	cmp    %eax,%edx
c0107780:	72 19                	jb     c010779b <basic_check+0x190>
c0107782:	68 a9 ba 10 c0       	push   $0xc010baa9
c0107787:	68 72 b9 10 c0       	push   $0xc010b972
c010778c:	68 be 00 00 00       	push   $0xbe
c0107791:	68 87 b9 10 c0       	push   $0xc010b987
c0107796:	e8 49 8c ff ff       	call   c01003e4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010779b:	83 ec 0c             	sub    $0xc,%esp
c010779e:	ff 75 f4             	pushl  -0xc(%ebp)
c01077a1:	e8 96 f7 ff ff       	call   c0106f3c <page2pa>
c01077a6:	83 c4 10             	add    $0x10,%esp
c01077a9:	89 c2                	mov    %eax,%edx
c01077ab:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c01077b0:	c1 e0 0c             	shl    $0xc,%eax
c01077b3:	39 c2                	cmp    %eax,%edx
c01077b5:	72 19                	jb     c01077d0 <basic_check+0x1c5>
c01077b7:	68 c6 ba 10 c0       	push   $0xc010bac6
c01077bc:	68 72 b9 10 c0       	push   $0xc010b972
c01077c1:	68 bf 00 00 00       	push   $0xbf
c01077c6:	68 87 b9 10 c0       	push   $0xc010b987
c01077cb:	e8 14 8c ff ff       	call   c01003e4 <__panic>

    list_entry_t free_list_store = free_list;
c01077d0:	a1 0c 9c 12 c0       	mov    0xc0129c0c,%eax
c01077d5:	8b 15 10 9c 12 c0    	mov    0xc0129c10,%edx
c01077db:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01077de:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01077e1:	c7 45 e4 0c 9c 12 c0 	movl   $0xc0129c0c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01077e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01077ee:	89 50 04             	mov    %edx,0x4(%eax)
c01077f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077f4:	8b 50 04             	mov    0x4(%eax),%edx
c01077f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077fa:	89 10                	mov    %edx,(%eax)
c01077fc:	c7 45 d8 0c 9c 12 c0 	movl   $0xc0129c0c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0107803:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107806:	8b 40 04             	mov    0x4(%eax),%eax
c0107809:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010780c:	0f 94 c0             	sete   %al
c010780f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0107812:	85 c0                	test   %eax,%eax
c0107814:	75 19                	jne    c010782f <basic_check+0x224>
c0107816:	68 e3 ba 10 c0       	push   $0xc010bae3
c010781b:	68 72 b9 10 c0       	push   $0xc010b972
c0107820:	68 c3 00 00 00       	push   $0xc3
c0107825:	68 87 b9 10 c0       	push   $0xc010b987
c010782a:	e8 b5 8b ff ff       	call   c01003e4 <__panic>

    unsigned int nr_free_store = nr_free;
c010782f:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0107834:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0107837:	c7 05 14 9c 12 c0 00 	movl   $0x0,0xc0129c14
c010783e:	00 00 00 

    assert(alloc_page() == NULL);
c0107841:	83 ec 0c             	sub    $0xc,%esp
c0107844:	6a 01                	push   $0x1
c0107846:	e8 44 bd ff ff       	call   c010358f <alloc_pages>
c010784b:	83 c4 10             	add    $0x10,%esp
c010784e:	85 c0                	test   %eax,%eax
c0107850:	74 19                	je     c010786b <basic_check+0x260>
c0107852:	68 fa ba 10 c0       	push   $0xc010bafa
c0107857:	68 72 b9 10 c0       	push   $0xc010b972
c010785c:	68 c8 00 00 00       	push   $0xc8
c0107861:	68 87 b9 10 c0       	push   $0xc010b987
c0107866:	e8 79 8b ff ff       	call   c01003e4 <__panic>

    free_page(p0);
c010786b:	83 ec 08             	sub    $0x8,%esp
c010786e:	6a 01                	push   $0x1
c0107870:	ff 75 ec             	pushl  -0x14(%ebp)
c0107873:	e8 83 bd ff ff       	call   c01035fb <free_pages>
c0107878:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010787b:	83 ec 08             	sub    $0x8,%esp
c010787e:	6a 01                	push   $0x1
c0107880:	ff 75 f0             	pushl  -0x10(%ebp)
c0107883:	e8 73 bd ff ff       	call   c01035fb <free_pages>
c0107888:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010788b:	83 ec 08             	sub    $0x8,%esp
c010788e:	6a 01                	push   $0x1
c0107890:	ff 75 f4             	pushl  -0xc(%ebp)
c0107893:	e8 63 bd ff ff       	call   c01035fb <free_pages>
c0107898:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010789b:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c01078a0:	83 f8 03             	cmp    $0x3,%eax
c01078a3:	74 19                	je     c01078be <basic_check+0x2b3>
c01078a5:	68 0f bb 10 c0       	push   $0xc010bb0f
c01078aa:	68 72 b9 10 c0       	push   $0xc010b972
c01078af:	68 cd 00 00 00       	push   $0xcd
c01078b4:	68 87 b9 10 c0       	push   $0xc010b987
c01078b9:	e8 26 8b ff ff       	call   c01003e4 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01078be:	83 ec 0c             	sub    $0xc,%esp
c01078c1:	6a 01                	push   $0x1
c01078c3:	e8 c7 bc ff ff       	call   c010358f <alloc_pages>
c01078c8:	83 c4 10             	add    $0x10,%esp
c01078cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01078ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01078d2:	75 19                	jne    c01078ed <basic_check+0x2e2>
c01078d4:	68 d5 b9 10 c0       	push   $0xc010b9d5
c01078d9:	68 72 b9 10 c0       	push   $0xc010b972
c01078de:	68 cf 00 00 00       	push   $0xcf
c01078e3:	68 87 b9 10 c0       	push   $0xc010b987
c01078e8:	e8 f7 8a ff ff       	call   c01003e4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01078ed:	83 ec 0c             	sub    $0xc,%esp
c01078f0:	6a 01                	push   $0x1
c01078f2:	e8 98 bc ff ff       	call   c010358f <alloc_pages>
c01078f7:	83 c4 10             	add    $0x10,%esp
c01078fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107901:	75 19                	jne    c010791c <basic_check+0x311>
c0107903:	68 f1 b9 10 c0       	push   $0xc010b9f1
c0107908:	68 72 b9 10 c0       	push   $0xc010b972
c010790d:	68 d0 00 00 00       	push   $0xd0
c0107912:	68 87 b9 10 c0       	push   $0xc010b987
c0107917:	e8 c8 8a ff ff       	call   c01003e4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010791c:	83 ec 0c             	sub    $0xc,%esp
c010791f:	6a 01                	push   $0x1
c0107921:	e8 69 bc ff ff       	call   c010358f <alloc_pages>
c0107926:	83 c4 10             	add    $0x10,%esp
c0107929:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010792c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107930:	75 19                	jne    c010794b <basic_check+0x340>
c0107932:	68 0d ba 10 c0       	push   $0xc010ba0d
c0107937:	68 72 b9 10 c0       	push   $0xc010b972
c010793c:	68 d1 00 00 00       	push   $0xd1
c0107941:	68 87 b9 10 c0       	push   $0xc010b987
c0107946:	e8 99 8a ff ff       	call   c01003e4 <__panic>

    assert(alloc_page() == NULL);
c010794b:	83 ec 0c             	sub    $0xc,%esp
c010794e:	6a 01                	push   $0x1
c0107950:	e8 3a bc ff ff       	call   c010358f <alloc_pages>
c0107955:	83 c4 10             	add    $0x10,%esp
c0107958:	85 c0                	test   %eax,%eax
c010795a:	74 19                	je     c0107975 <basic_check+0x36a>
c010795c:	68 fa ba 10 c0       	push   $0xc010bafa
c0107961:	68 72 b9 10 c0       	push   $0xc010b972
c0107966:	68 d3 00 00 00       	push   $0xd3
c010796b:	68 87 b9 10 c0       	push   $0xc010b987
c0107970:	e8 6f 8a ff ff       	call   c01003e4 <__panic>

    free_page(p0);
c0107975:	83 ec 08             	sub    $0x8,%esp
c0107978:	6a 01                	push   $0x1
c010797a:	ff 75 ec             	pushl  -0x14(%ebp)
c010797d:	e8 79 bc ff ff       	call   c01035fb <free_pages>
c0107982:	83 c4 10             	add    $0x10,%esp
c0107985:	c7 45 e8 0c 9c 12 c0 	movl   $0xc0129c0c,-0x18(%ebp)
c010798c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010798f:	8b 40 04             	mov    0x4(%eax),%eax
c0107992:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107995:	0f 94 c0             	sete   %al
c0107998:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010799b:	85 c0                	test   %eax,%eax
c010799d:	74 19                	je     c01079b8 <basic_check+0x3ad>
c010799f:	68 1c bb 10 c0       	push   $0xc010bb1c
c01079a4:	68 72 b9 10 c0       	push   $0xc010b972
c01079a9:	68 d6 00 00 00       	push   $0xd6
c01079ae:	68 87 b9 10 c0       	push   $0xc010b987
c01079b3:	e8 2c 8a ff ff       	call   c01003e4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01079b8:	83 ec 0c             	sub    $0xc,%esp
c01079bb:	6a 01                	push   $0x1
c01079bd:	e8 cd bb ff ff       	call   c010358f <alloc_pages>
c01079c2:	83 c4 10             	add    $0x10,%esp
c01079c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01079c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01079ce:	74 19                	je     c01079e9 <basic_check+0x3de>
c01079d0:	68 34 bb 10 c0       	push   $0xc010bb34
c01079d5:	68 72 b9 10 c0       	push   $0xc010b972
c01079da:	68 d9 00 00 00       	push   $0xd9
c01079df:	68 87 b9 10 c0       	push   $0xc010b987
c01079e4:	e8 fb 89 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c01079e9:	83 ec 0c             	sub    $0xc,%esp
c01079ec:	6a 01                	push   $0x1
c01079ee:	e8 9c bb ff ff       	call   c010358f <alloc_pages>
c01079f3:	83 c4 10             	add    $0x10,%esp
c01079f6:	85 c0                	test   %eax,%eax
c01079f8:	74 19                	je     c0107a13 <basic_check+0x408>
c01079fa:	68 fa ba 10 c0       	push   $0xc010bafa
c01079ff:	68 72 b9 10 c0       	push   $0xc010b972
c0107a04:	68 da 00 00 00       	push   $0xda
c0107a09:	68 87 b9 10 c0       	push   $0xc010b987
c0107a0e:	e8 d1 89 ff ff       	call   c01003e4 <__panic>

    assert(nr_free == 0);
c0107a13:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0107a18:	85 c0                	test   %eax,%eax
c0107a1a:	74 19                	je     c0107a35 <basic_check+0x42a>
c0107a1c:	68 4d bb 10 c0       	push   $0xc010bb4d
c0107a21:	68 72 b9 10 c0       	push   $0xc010b972
c0107a26:	68 dc 00 00 00       	push   $0xdc
c0107a2b:	68 87 b9 10 c0       	push   $0xc010b987
c0107a30:	e8 af 89 ff ff       	call   c01003e4 <__panic>
    free_list = free_list_store;
c0107a35:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a38:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107a3b:	a3 0c 9c 12 c0       	mov    %eax,0xc0129c0c
c0107a40:	89 15 10 9c 12 c0    	mov    %edx,0xc0129c10
    nr_free = nr_free_store;
c0107a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a49:	a3 14 9c 12 c0       	mov    %eax,0xc0129c14

    free_page(p);
c0107a4e:	83 ec 08             	sub    $0x8,%esp
c0107a51:	6a 01                	push   $0x1
c0107a53:	ff 75 dc             	pushl  -0x24(%ebp)
c0107a56:	e8 a0 bb ff ff       	call   c01035fb <free_pages>
c0107a5b:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0107a5e:	83 ec 08             	sub    $0x8,%esp
c0107a61:	6a 01                	push   $0x1
c0107a63:	ff 75 f0             	pushl  -0x10(%ebp)
c0107a66:	e8 90 bb ff ff       	call   c01035fb <free_pages>
c0107a6b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0107a6e:	83 ec 08             	sub    $0x8,%esp
c0107a71:	6a 01                	push   $0x1
c0107a73:	ff 75 f4             	pushl  -0xc(%ebp)
c0107a76:	e8 80 bb ff ff       	call   c01035fb <free_pages>
c0107a7b:	83 c4 10             	add    $0x10,%esp
}
c0107a7e:	90                   	nop
c0107a7f:	c9                   	leave  
c0107a80:	c3                   	ret    

c0107a81 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0107a81:	55                   	push   %ebp
c0107a82:	89 e5                	mov    %esp,%ebp
c0107a84:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0107a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107a91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0107a98:	c7 45 ec 0c 9c 12 c0 	movl   $0xc0129c0c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0107a9f:	eb 60                	jmp    c0107b01 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0107aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107aa4:	83 e8 0c             	sub    $0xc,%eax
c0107aa7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0107aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107aad:	83 c0 04             	add    $0x4,%eax
c0107ab0:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0107ab7:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107aba:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107abd:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0107ac0:	0f a3 10             	bt     %edx,(%eax)
c0107ac3:	19 c0                	sbb    %eax,%eax
c0107ac5:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0107ac8:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0107acc:	0f 95 c0             	setne  %al
c0107acf:	0f b6 c0             	movzbl %al,%eax
c0107ad2:	85 c0                	test   %eax,%eax
c0107ad4:	75 19                	jne    c0107aef <default_check+0x6e>
c0107ad6:	68 5a bb 10 c0       	push   $0xc010bb5a
c0107adb:	68 72 b9 10 c0       	push   $0xc010b972
c0107ae0:	68 ed 00 00 00       	push   $0xed
c0107ae5:	68 87 b9 10 c0       	push   $0xc010b987
c0107aea:	e8 f5 88 ff ff       	call   c01003e4 <__panic>
        count ++, total += p->property;
c0107aef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107af6:	8b 50 08             	mov    0x8(%eax),%edx
c0107af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107afc:	01 d0                	add    %edx,%eax
c0107afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b04:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b0a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0107b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107b10:	81 7d ec 0c 9c 12 c0 	cmpl   $0xc0129c0c,-0x14(%ebp)
c0107b17:	75 88                	jne    c0107aa1 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0107b19:	e8 12 bb ff ff       	call   c0103630 <nr_free_pages>
c0107b1e:	89 c2                	mov    %eax,%edx
c0107b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b23:	39 c2                	cmp    %eax,%edx
c0107b25:	74 19                	je     c0107b40 <default_check+0xbf>
c0107b27:	68 6a bb 10 c0       	push   $0xc010bb6a
c0107b2c:	68 72 b9 10 c0       	push   $0xc010b972
c0107b31:	68 f0 00 00 00       	push   $0xf0
c0107b36:	68 87 b9 10 c0       	push   $0xc010b987
c0107b3b:	e8 a4 88 ff ff       	call   c01003e4 <__panic>

    basic_check();
c0107b40:	e8 c6 fa ff ff       	call   c010760b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0107b45:	83 ec 0c             	sub    $0xc,%esp
c0107b48:	6a 05                	push   $0x5
c0107b4a:	e8 40 ba ff ff       	call   c010358f <alloc_pages>
c0107b4f:	83 c4 10             	add    $0x10,%esp
c0107b52:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0107b55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107b59:	75 19                	jne    c0107b74 <default_check+0xf3>
c0107b5b:	68 83 bb 10 c0       	push   $0xc010bb83
c0107b60:	68 72 b9 10 c0       	push   $0xc010b972
c0107b65:	68 f5 00 00 00       	push   $0xf5
c0107b6a:	68 87 b9 10 c0       	push   $0xc010b987
c0107b6f:	e8 70 88 ff ff       	call   c01003e4 <__panic>
    assert(!PageProperty(p0));
c0107b74:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b77:	83 c0 04             	add    $0x4,%eax
c0107b7a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0107b81:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107b84:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107b8a:	0f a3 10             	bt     %edx,(%eax)
c0107b8d:	19 c0                	sbb    %eax,%eax
c0107b8f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0107b92:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0107b96:	0f 95 c0             	setne  %al
c0107b99:	0f b6 c0             	movzbl %al,%eax
c0107b9c:	85 c0                	test   %eax,%eax
c0107b9e:	74 19                	je     c0107bb9 <default_check+0x138>
c0107ba0:	68 8e bb 10 c0       	push   $0xc010bb8e
c0107ba5:	68 72 b9 10 c0       	push   $0xc010b972
c0107baa:	68 f6 00 00 00       	push   $0xf6
c0107baf:	68 87 b9 10 c0       	push   $0xc010b987
c0107bb4:	e8 2b 88 ff ff       	call   c01003e4 <__panic>

    list_entry_t free_list_store = free_list;
c0107bb9:	a1 0c 9c 12 c0       	mov    0xc0129c0c,%eax
c0107bbe:	8b 15 10 9c 12 c0    	mov    0xc0129c10,%edx
c0107bc4:	89 45 80             	mov    %eax,-0x80(%ebp)
c0107bc7:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0107bca:	c7 45 d0 0c 9c 12 c0 	movl   $0xc0129c0c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107bd1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107bd4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107bd7:	89 50 04             	mov    %edx,0x4(%eax)
c0107bda:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107bdd:	8b 50 04             	mov    0x4(%eax),%edx
c0107be0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107be3:	89 10                	mov    %edx,(%eax)
c0107be5:	c7 45 d8 0c 9c 12 c0 	movl   $0xc0129c0c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0107bec:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107bef:	8b 40 04             	mov    0x4(%eax),%eax
c0107bf2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0107bf5:	0f 94 c0             	sete   %al
c0107bf8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0107bfb:	85 c0                	test   %eax,%eax
c0107bfd:	75 19                	jne    c0107c18 <default_check+0x197>
c0107bff:	68 e3 ba 10 c0       	push   $0xc010bae3
c0107c04:	68 72 b9 10 c0       	push   $0xc010b972
c0107c09:	68 fa 00 00 00       	push   $0xfa
c0107c0e:	68 87 b9 10 c0       	push   $0xc010b987
c0107c13:	e8 cc 87 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c0107c18:	83 ec 0c             	sub    $0xc,%esp
c0107c1b:	6a 01                	push   $0x1
c0107c1d:	e8 6d b9 ff ff       	call   c010358f <alloc_pages>
c0107c22:	83 c4 10             	add    $0x10,%esp
c0107c25:	85 c0                	test   %eax,%eax
c0107c27:	74 19                	je     c0107c42 <default_check+0x1c1>
c0107c29:	68 fa ba 10 c0       	push   $0xc010bafa
c0107c2e:	68 72 b9 10 c0       	push   $0xc010b972
c0107c33:	68 fb 00 00 00       	push   $0xfb
c0107c38:	68 87 b9 10 c0       	push   $0xc010b987
c0107c3d:	e8 a2 87 ff ff       	call   c01003e4 <__panic>

    unsigned int nr_free_store = nr_free;
c0107c42:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0107c47:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0107c4a:	c7 05 14 9c 12 c0 00 	movl   $0x0,0xc0129c14
c0107c51:	00 00 00 

    free_pages(p0 + 2, 3);
c0107c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c57:	83 c0 40             	add    $0x40,%eax
c0107c5a:	83 ec 08             	sub    $0x8,%esp
c0107c5d:	6a 03                	push   $0x3
c0107c5f:	50                   	push   %eax
c0107c60:	e8 96 b9 ff ff       	call   c01035fb <free_pages>
c0107c65:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0107c68:	83 ec 0c             	sub    $0xc,%esp
c0107c6b:	6a 04                	push   $0x4
c0107c6d:	e8 1d b9 ff ff       	call   c010358f <alloc_pages>
c0107c72:	83 c4 10             	add    $0x10,%esp
c0107c75:	85 c0                	test   %eax,%eax
c0107c77:	74 19                	je     c0107c92 <default_check+0x211>
c0107c79:	68 a0 bb 10 c0       	push   $0xc010bba0
c0107c7e:	68 72 b9 10 c0       	push   $0xc010b972
c0107c83:	68 01 01 00 00       	push   $0x101
c0107c88:	68 87 b9 10 c0       	push   $0xc010b987
c0107c8d:	e8 52 87 ff ff       	call   c01003e4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0107c92:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c95:	83 c0 40             	add    $0x40,%eax
c0107c98:	83 c0 04             	add    $0x4,%eax
c0107c9b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0107ca2:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107ca5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0107ca8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107cab:	0f a3 10             	bt     %edx,(%eax)
c0107cae:	19 c0                	sbb    %eax,%eax
c0107cb0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0107cb3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0107cb7:	0f 95 c0             	setne  %al
c0107cba:	0f b6 c0             	movzbl %al,%eax
c0107cbd:	85 c0                	test   %eax,%eax
c0107cbf:	74 0e                	je     c0107ccf <default_check+0x24e>
c0107cc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107cc4:	83 c0 40             	add    $0x40,%eax
c0107cc7:	8b 40 08             	mov    0x8(%eax),%eax
c0107cca:	83 f8 03             	cmp    $0x3,%eax
c0107ccd:	74 19                	je     c0107ce8 <default_check+0x267>
c0107ccf:	68 b8 bb 10 c0       	push   $0xc010bbb8
c0107cd4:	68 72 b9 10 c0       	push   $0xc010b972
c0107cd9:	68 02 01 00 00       	push   $0x102
c0107cde:	68 87 b9 10 c0       	push   $0xc010b987
c0107ce3:	e8 fc 86 ff ff       	call   c01003e4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0107ce8:	83 ec 0c             	sub    $0xc,%esp
c0107ceb:	6a 03                	push   $0x3
c0107ced:	e8 9d b8 ff ff       	call   c010358f <alloc_pages>
c0107cf2:	83 c4 10             	add    $0x10,%esp
c0107cf5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0107cf8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107cfc:	75 19                	jne    c0107d17 <default_check+0x296>
c0107cfe:	68 e4 bb 10 c0       	push   $0xc010bbe4
c0107d03:	68 72 b9 10 c0       	push   $0xc010b972
c0107d08:	68 03 01 00 00       	push   $0x103
c0107d0d:	68 87 b9 10 c0       	push   $0xc010b987
c0107d12:	e8 cd 86 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c0107d17:	83 ec 0c             	sub    $0xc,%esp
c0107d1a:	6a 01                	push   $0x1
c0107d1c:	e8 6e b8 ff ff       	call   c010358f <alloc_pages>
c0107d21:	83 c4 10             	add    $0x10,%esp
c0107d24:	85 c0                	test   %eax,%eax
c0107d26:	74 19                	je     c0107d41 <default_check+0x2c0>
c0107d28:	68 fa ba 10 c0       	push   $0xc010bafa
c0107d2d:	68 72 b9 10 c0       	push   $0xc010b972
c0107d32:	68 04 01 00 00       	push   $0x104
c0107d37:	68 87 b9 10 c0       	push   $0xc010b987
c0107d3c:	e8 a3 86 ff ff       	call   c01003e4 <__panic>
    assert(p0 + 2 == p1);
c0107d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d44:	83 c0 40             	add    $0x40,%eax
c0107d47:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0107d4a:	74 19                	je     c0107d65 <default_check+0x2e4>
c0107d4c:	68 02 bc 10 c0       	push   $0xc010bc02
c0107d51:	68 72 b9 10 c0       	push   $0xc010b972
c0107d56:	68 05 01 00 00       	push   $0x105
c0107d5b:	68 87 b9 10 c0       	push   $0xc010b987
c0107d60:	e8 7f 86 ff ff       	call   c01003e4 <__panic>

    p2 = p0 + 1;
c0107d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d68:	83 c0 20             	add    $0x20,%eax
c0107d6b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0107d6e:	83 ec 08             	sub    $0x8,%esp
c0107d71:	6a 01                	push   $0x1
c0107d73:	ff 75 dc             	pushl  -0x24(%ebp)
c0107d76:	e8 80 b8 ff ff       	call   c01035fb <free_pages>
c0107d7b:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0107d7e:	83 ec 08             	sub    $0x8,%esp
c0107d81:	6a 03                	push   $0x3
c0107d83:	ff 75 c4             	pushl  -0x3c(%ebp)
c0107d86:	e8 70 b8 ff ff       	call   c01035fb <free_pages>
c0107d8b:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0107d8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d91:	83 c0 04             	add    $0x4,%eax
c0107d94:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0107d9b:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107d9e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0107da1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107da4:	0f a3 10             	bt     %edx,(%eax)
c0107da7:	19 c0                	sbb    %eax,%eax
c0107da9:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0107dac:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0107db0:	0f 95 c0             	setne  %al
c0107db3:	0f b6 c0             	movzbl %al,%eax
c0107db6:	85 c0                	test   %eax,%eax
c0107db8:	74 0b                	je     c0107dc5 <default_check+0x344>
c0107dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107dbd:	8b 40 08             	mov    0x8(%eax),%eax
c0107dc0:	83 f8 01             	cmp    $0x1,%eax
c0107dc3:	74 19                	je     c0107dde <default_check+0x35d>
c0107dc5:	68 10 bc 10 c0       	push   $0xc010bc10
c0107dca:	68 72 b9 10 c0       	push   $0xc010b972
c0107dcf:	68 0a 01 00 00       	push   $0x10a
c0107dd4:	68 87 b9 10 c0       	push   $0xc010b987
c0107dd9:	e8 06 86 ff ff       	call   c01003e4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0107dde:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107de1:	83 c0 04             	add    $0x4,%eax
c0107de4:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0107deb:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107dee:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0107df1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0107df4:	0f a3 10             	bt     %edx,(%eax)
c0107df7:	19 c0                	sbb    %eax,%eax
c0107df9:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0107dfc:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0107e00:	0f 95 c0             	setne  %al
c0107e03:	0f b6 c0             	movzbl %al,%eax
c0107e06:	85 c0                	test   %eax,%eax
c0107e08:	74 0b                	je     c0107e15 <default_check+0x394>
c0107e0a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107e0d:	8b 40 08             	mov    0x8(%eax),%eax
c0107e10:	83 f8 03             	cmp    $0x3,%eax
c0107e13:	74 19                	je     c0107e2e <default_check+0x3ad>
c0107e15:	68 38 bc 10 c0       	push   $0xc010bc38
c0107e1a:	68 72 b9 10 c0       	push   $0xc010b972
c0107e1f:	68 0b 01 00 00       	push   $0x10b
c0107e24:	68 87 b9 10 c0       	push   $0xc010b987
c0107e29:	e8 b6 85 ff ff       	call   c01003e4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0107e2e:	83 ec 0c             	sub    $0xc,%esp
c0107e31:	6a 01                	push   $0x1
c0107e33:	e8 57 b7 ff ff       	call   c010358f <alloc_pages>
c0107e38:	83 c4 10             	add    $0x10,%esp
c0107e3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107e3e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0107e41:	83 e8 20             	sub    $0x20,%eax
c0107e44:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0107e47:	74 19                	je     c0107e62 <default_check+0x3e1>
c0107e49:	68 5e bc 10 c0       	push   $0xc010bc5e
c0107e4e:	68 72 b9 10 c0       	push   $0xc010b972
c0107e53:	68 0d 01 00 00       	push   $0x10d
c0107e58:	68 87 b9 10 c0       	push   $0xc010b987
c0107e5d:	e8 82 85 ff ff       	call   c01003e4 <__panic>
    free_page(p0);
c0107e62:	83 ec 08             	sub    $0x8,%esp
c0107e65:	6a 01                	push   $0x1
c0107e67:	ff 75 dc             	pushl  -0x24(%ebp)
c0107e6a:	e8 8c b7 ff ff       	call   c01035fb <free_pages>
c0107e6f:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0107e72:	83 ec 0c             	sub    $0xc,%esp
c0107e75:	6a 02                	push   $0x2
c0107e77:	e8 13 b7 ff ff       	call   c010358f <alloc_pages>
c0107e7c:	83 c4 10             	add    $0x10,%esp
c0107e7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107e82:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0107e85:	83 c0 20             	add    $0x20,%eax
c0107e88:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0107e8b:	74 19                	je     c0107ea6 <default_check+0x425>
c0107e8d:	68 7c bc 10 c0       	push   $0xc010bc7c
c0107e92:	68 72 b9 10 c0       	push   $0xc010b972
c0107e97:	68 0f 01 00 00       	push   $0x10f
c0107e9c:	68 87 b9 10 c0       	push   $0xc010b987
c0107ea1:	e8 3e 85 ff ff       	call   c01003e4 <__panic>

    free_pages(p0, 2);
c0107ea6:	83 ec 08             	sub    $0x8,%esp
c0107ea9:	6a 02                	push   $0x2
c0107eab:	ff 75 dc             	pushl  -0x24(%ebp)
c0107eae:	e8 48 b7 ff ff       	call   c01035fb <free_pages>
c0107eb3:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0107eb6:	83 ec 08             	sub    $0x8,%esp
c0107eb9:	6a 01                	push   $0x1
c0107ebb:	ff 75 c0             	pushl  -0x40(%ebp)
c0107ebe:	e8 38 b7 ff ff       	call   c01035fb <free_pages>
c0107ec3:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0107ec6:	83 ec 0c             	sub    $0xc,%esp
c0107ec9:	6a 05                	push   $0x5
c0107ecb:	e8 bf b6 ff ff       	call   c010358f <alloc_pages>
c0107ed0:	83 c4 10             	add    $0x10,%esp
c0107ed3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107ed6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107eda:	75 19                	jne    c0107ef5 <default_check+0x474>
c0107edc:	68 9c bc 10 c0       	push   $0xc010bc9c
c0107ee1:	68 72 b9 10 c0       	push   $0xc010b972
c0107ee6:	68 14 01 00 00       	push   $0x114
c0107eeb:	68 87 b9 10 c0       	push   $0xc010b987
c0107ef0:	e8 ef 84 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c0107ef5:	83 ec 0c             	sub    $0xc,%esp
c0107ef8:	6a 01                	push   $0x1
c0107efa:	e8 90 b6 ff ff       	call   c010358f <alloc_pages>
c0107eff:	83 c4 10             	add    $0x10,%esp
c0107f02:	85 c0                	test   %eax,%eax
c0107f04:	74 19                	je     c0107f1f <default_check+0x49e>
c0107f06:	68 fa ba 10 c0       	push   $0xc010bafa
c0107f0b:	68 72 b9 10 c0       	push   $0xc010b972
c0107f10:	68 15 01 00 00       	push   $0x115
c0107f15:	68 87 b9 10 c0       	push   $0xc010b987
c0107f1a:	e8 c5 84 ff ff       	call   c01003e4 <__panic>

    assert(nr_free == 0);
c0107f1f:	a1 14 9c 12 c0       	mov    0xc0129c14,%eax
c0107f24:	85 c0                	test   %eax,%eax
c0107f26:	74 19                	je     c0107f41 <default_check+0x4c0>
c0107f28:	68 4d bb 10 c0       	push   $0xc010bb4d
c0107f2d:	68 72 b9 10 c0       	push   $0xc010b972
c0107f32:	68 17 01 00 00       	push   $0x117
c0107f37:	68 87 b9 10 c0       	push   $0xc010b987
c0107f3c:	e8 a3 84 ff ff       	call   c01003e4 <__panic>
    nr_free = nr_free_store;
c0107f41:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f44:	a3 14 9c 12 c0       	mov    %eax,0xc0129c14

    free_list = free_list_store;
c0107f49:	8b 45 80             	mov    -0x80(%ebp),%eax
c0107f4c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0107f4f:	a3 0c 9c 12 c0       	mov    %eax,0xc0129c0c
c0107f54:	89 15 10 9c 12 c0    	mov    %edx,0xc0129c10
    free_pages(p0, 5);
c0107f5a:	83 ec 08             	sub    $0x8,%esp
c0107f5d:	6a 05                	push   $0x5
c0107f5f:	ff 75 dc             	pushl  -0x24(%ebp)
c0107f62:	e8 94 b6 ff ff       	call   c01035fb <free_pages>
c0107f67:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0107f6a:	c7 45 ec 0c 9c 12 c0 	movl   $0xc0129c0c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0107f71:	eb 1d                	jmp    c0107f90 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0107f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f76:	83 e8 0c             	sub    $0xc,%eax
c0107f79:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0107f7c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107f83:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107f86:	8b 40 08             	mov    0x8(%eax),%eax
c0107f89:	29 c2                	sub    %eax,%edx
c0107f8b:	89 d0                	mov    %edx,%eax
c0107f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f93:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107f96:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107f99:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0107f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107f9f:	81 7d ec 0c 9c 12 c0 	cmpl   $0xc0129c0c,-0x14(%ebp)
c0107fa6:	75 cb                	jne    c0107f73 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0107fa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107fac:	74 19                	je     c0107fc7 <default_check+0x546>
c0107fae:	68 ba bc 10 c0       	push   $0xc010bcba
c0107fb3:	68 72 b9 10 c0       	push   $0xc010b972
c0107fb8:	68 22 01 00 00       	push   $0x122
c0107fbd:	68 87 b9 10 c0       	push   $0xc010b987
c0107fc2:	e8 1d 84 ff ff       	call   c01003e4 <__panic>
    assert(total == 0);
c0107fc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107fcb:	74 19                	je     c0107fe6 <default_check+0x565>
c0107fcd:	68 c5 bc 10 c0       	push   $0xc010bcc5
c0107fd2:	68 72 b9 10 c0       	push   $0xc010b972
c0107fd7:	68 23 01 00 00       	push   $0x123
c0107fdc:	68 87 b9 10 c0       	push   $0xc010b987
c0107fe1:	e8 fe 83 ff ff       	call   c01003e4 <__panic>
}
c0107fe6:	90                   	nop
c0107fe7:	c9                   	leave  
c0107fe8:	c3                   	ret    

c0107fe9 <_clock_init_mm>:
 * (2) _clock_init_mm: Build list.
 * The sm_priv is used for circular clock pointer
 */
static int
_clock_init_mm(struct mm_struct *mm)
{     
c0107fe9:	55                   	push   %ebp
c0107fea:	89 e5                	mov    %esp,%ebp
c0107fec:	83 ec 10             	sub    $0x10,%esp
c0107fef:	c7 45 fc 1c 9c 12 c0 	movl   $0xc0129c1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ff9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107ffc:	89 50 04             	mov    %edx,0x4(%eax)
c0107fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108002:	8b 50 04             	mov    0x4(%eax),%edx
c0108005:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108008:	89 10                	mov    %edx,(%eax)
     list_init(&clock_list_head);
     mm->sm_priv = &clock_list_head;
c010800a:	8b 45 08             	mov    0x8(%ebp),%eax
c010800d:	c7 40 14 1c 9c 12 c0 	movl   $0xc0129c1c,0x14(%eax)
     current_clock_pointer = &clock_list_head;
c0108014:	c7 05 18 9c 12 c0 1c 	movl   $0xc0129c1c,0xc0129c18
c010801b:	9c 12 c0 
     return 0;
c010801e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108023:	c9                   	leave  
c0108024:	c3                   	ret    

c0108025 <_clock_map_swappable>:
 * (3)_clock_map_swappable: Just add the Page to the clock circle.
 * CPU will automatically update PTE based on memory access.
 */
static int
_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0108025:	55                   	push   %ebp
c0108026:	89 e5                	mov    %esp,%ebp
c0108028:	83 ec 28             	sub    $0x28,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010802b:	8b 45 08             	mov    0x8(%ebp),%eax
c010802e:	8b 40 14             	mov    0x14(%eax),%eax
c0108031:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0108034:	8b 45 10             	mov    0x10(%ebp),%eax
c0108037:	83 c0 14             	add    $0x14,%eax
c010803a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c010803d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108041:	74 06                	je     c0108049 <_clock_map_swappable+0x24>
c0108043:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108047:	75 16                	jne    c010805f <_clock_map_swappable+0x3a>
c0108049:	68 00 bd 10 c0       	push   $0xc010bd00
c010804e:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108053:	6a 29                	push   $0x29
c0108055:	68 33 bd 10 c0       	push   $0xc010bd33
c010805a:	e8 85 83 ff ff       	call   c01003e4 <__panic>
    list_add_before(current_clock_pointer, entry);
c010805f:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c0108064:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108067:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010806a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010806d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108070:	8b 00                	mov    (%eax),%eax
c0108072:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108075:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108078:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010807b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010807e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108081:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108084:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108087:	89 10                	mov    %edx,(%eax)
c0108089:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010808c:	8b 10                	mov    (%eax),%edx
c010808e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108091:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108097:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010809a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010809d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01080a3:	89 10                	mov    %edx,(%eax)
    // current_clock_pointer = entry;
    return 0;
c01080a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01080aa:	c9                   	leave  
c01080ab:	c3                   	ret    

c01080ac <_clock_swap_out_victim>:
 *  	Check the list circularly, get the pte of each Page and modify them,
 *  Loop until find a page whose bits are both 0. Then return the page.
 */
static int
_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01080ac:	55                   	push   %ebp
c01080ad:	89 e5                	mov    %esp,%ebp
c01080af:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head = (list_entry_t*) mm->sm_priv;
c01080b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01080b5:	8b 40 14             	mov    0x14(%eax),%eax
c01080b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(head->next != head);
c01080bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080be:	8b 40 04             	mov    0x4(%eax),%eax
c01080c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01080c4:	75 16                	jne    c01080dc <_clock_swap_out_victim+0x30>
c01080c6:	68 48 bd 10 c0       	push   $0xc010bd48
c01080cb:	68 1e bd 10 c0       	push   $0xc010bd1e
c01080d0:	6a 39                	push   $0x39
c01080d2:	68 33 bd 10 c0       	push   $0xc010bd33
c01080d7:	e8 08 83 ff ff       	call   c01003e4 <__panic>
     pte_t* current_pte = NULL;
c01080dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     struct Page* current_page = NULL;
c01080e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     if (current_clock_pointer == head) {
c01080ea:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c01080ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01080f2:	75 0d                	jne    c0108101 <_clock_swap_out_victim+0x55>
    	 current_clock_pointer = current_clock_pointer->next;
c01080f4:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c01080f9:	8b 40 04             	mov    0x4(%eax),%eax
c01080fc:	a3 18 9c 12 c0       	mov    %eax,0xc0129c18
     }
     while (1) {
    	 // Get current pointer's PTE.
    	 // If it is 00, then swap, else change and move next.
    	 current_page = le2page(current_clock_pointer, pra_page_link);
c0108101:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c0108106:	83 e8 14             	sub    $0x14,%eax
c0108109:	89 45 ec             	mov    %eax,-0x14(%ebp)
		 current_pte = get_pte(mm->pgdir, current_page->pra_vaddr, 0);
c010810c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010810f:	8b 50 1c             	mov    0x1c(%eax),%edx
c0108112:	8b 45 08             	mov    0x8(%ebp),%eax
c0108115:	8b 40 0c             	mov    0xc(%eax),%eax
c0108118:	83 ec 04             	sub    $0x4,%esp
c010811b:	6a 00                	push   $0x0
c010811d:	52                   	push   %edx
c010811e:	50                   	push   %eax
c010811f:	e8 56 bb ff ff       	call   c0103c7a <get_pte>
c0108124:	83 c4 10             	add    $0x10,%esp
c0108127:	89 45 f0             	mov    %eax,-0x10(%ebp)
		 assert(current_pte != NULL);
c010812a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010812e:	75 16                	jne    c0108146 <_clock_swap_out_victim+0x9a>
c0108130:	68 5b bd 10 c0       	push   $0xc010bd5b
c0108135:	68 1e bd 10 c0       	push   $0xc010bd1e
c010813a:	6a 44                	push   $0x44
c010813c:	68 33 bd 10 c0       	push   $0xc010bd33
c0108141:	e8 9e 82 ff ff       	call   c01003e4 <__panic>
		 int accessed = (((*current_pte) & PTE_A) != 0);
c0108146:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108149:	8b 00                	mov    (%eax),%eax
c010814b:	83 e0 20             	and    $0x20,%eax
c010814e:	85 c0                	test   %eax,%eax
c0108150:	0f 95 c0             	setne  %al
c0108153:	0f b6 c0             	movzbl %al,%eax
c0108156:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 int dirty = (((*current_pte) & PTE_D) != 0);
c0108159:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010815c:	8b 00                	mov    (%eax),%eax
c010815e:	83 e0 40             	and    $0x40,%eax
c0108161:	85 c0                	test   %eax,%eax
c0108163:	0f 95 c0             	setne  %al
c0108166:	0f b6 c0             	movzbl %al,%eax
c0108169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		 cprintf("A = %d, D = %d, %08x, %08x\n", accessed, dirty, current_pte, *(current_pte));
c010816c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010816f:	8b 00                	mov    (%eax),%eax
c0108171:	83 ec 0c             	sub    $0xc,%esp
c0108174:	50                   	push   %eax
c0108175:	ff 75 f0             	pushl  -0x10(%ebp)
c0108178:	ff 75 e4             	pushl  -0x1c(%ebp)
c010817b:	ff 75 e8             	pushl  -0x18(%ebp)
c010817e:	68 6f bd 10 c0       	push   $0xc010bd6f
c0108183:	e8 f6 80 ff ff       	call   c010027e <cprintf>
c0108188:	83 c4 20             	add    $0x20,%esp
		 if (!accessed && !dirty) {
c010818b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010818f:	75 06                	jne    c0108197 <_clock_swap_out_victim+0xeb>
c0108191:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108195:	74 47                	je     c01081de <_clock_swap_out_victim+0x132>
			 break;
		 }
		 // Modify bits.
		 (*current_pte) = (*current_pte) & (~PTE_A);
c0108197:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010819a:	8b 00                	mov    (%eax),%eax
c010819c:	83 e0 df             	and    $0xffffffdf,%eax
c010819f:	89 c2                	mov    %eax,%edx
c01081a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081a4:	89 10                	mov    %edx,(%eax)
		 if (accessed + dirty == 1) {
c01081a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01081a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081ac:	01 d0                	add    %edx,%eax
c01081ae:	83 f8 01             	cmp    $0x1,%eax
c01081b1:	75 0f                	jne    c01081c2 <_clock_swap_out_victim+0x116>
			 // all should be zero
			 (*current_pte) = (*current_pte) & (~PTE_D);
c01081b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081b6:	8b 00                	mov    (%eax),%eax
c01081b8:	83 e0 bf             	and    $0xffffffbf,%eax
c01081bb:	89 c2                	mov    %eax,%edx
c01081bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081c0:	89 10                	mov    %edx,(%eax)
		 }
    	 // Go to next list (remember to skip the head)
    	 do {
			 current_clock_pointer = current_clock_pointer->next;
c01081c2:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c01081c7:	8b 40 04             	mov    0x4(%eax),%eax
c01081ca:	a3 18 9c 12 c0       	mov    %eax,0xc0129c18
		 }
    	 while (current_clock_pointer == head);
c01081cf:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c01081d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01081d7:	74 e9                	je     c01081c2 <_clock_swap_out_victim+0x116>
     }
c01081d9:	e9 23 ff ff ff       	jmp    c0108101 <_clock_swap_out_victim+0x55>
		 assert(current_pte != NULL);
		 int accessed = (((*current_pte) & PTE_A) != 0);
		 int dirty = (((*current_pte) & PTE_D) != 0);
		 cprintf("A = %d, D = %d, %08x, %08x\n", accessed, dirty, current_pte, *(current_pte));
		 if (!accessed && !dirty) {
			 break;
c01081de:	90                   	nop
    	 do {
			 current_clock_pointer = current_clock_pointer->next;
		 }
    	 while (current_clock_pointer == head);
     }
     *ptr_page = current_page;
c01081df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01081e5:	89 10                	mov    %edx,(%eax)
     current_clock_pointer = current_clock_pointer->next;
c01081e7:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c01081ec:	8b 40 04             	mov    0x4(%eax),%eax
c01081ef:	a3 18 9c 12 c0       	mov    %eax,0xc0129c18
     list_del(current_clock_pointer->prev);
c01081f4:	a1 18 9c 12 c0       	mov    0xc0129c18,%eax
c01081f9:	8b 00                	mov    (%eax),%eax
c01081fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01081fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108201:	8b 40 04             	mov    0x4(%eax),%eax
c0108204:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108207:	8b 12                	mov    (%edx),%edx
c0108209:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010820c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010820f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108212:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108215:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0108218:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010821b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010821e:	89 10                	mov    %edx,(%eax)
     return 0;
c0108220:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108225:	c9                   	leave  
c0108226:	c3                   	ret    

c0108227 <mark_read>:

static void
mark_read(int page_id) {
c0108227:	55                   	push   %ebp
c0108228:	89 e5                	mov    %esp,%ebp
c010822a:	83 ec 18             	sub    $0x18,%esp
	uintptr_t la = (page_id << 12);
c010822d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108230:	c1 e0 0c             	shl    $0xc,%eax
c0108233:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
c0108236:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c010823b:	83 ec 04             	sub    $0x4,%esp
c010823e:	6a 00                	push   $0x0
c0108240:	ff 75 f4             	pushl  -0xc(%ebp)
c0108243:	50                   	push   %eax
c0108244:	e8 31 ba ff ff       	call   c0103c7a <get_pte>
c0108249:	83 c4 10             	add    $0x10,%esp
c010824c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert(pt_entry != NULL);
c010824f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108253:	75 16                	jne    c010826b <mark_read+0x44>
c0108255:	68 8b bd 10 c0       	push   $0xc010bd8b
c010825a:	68 1e bd 10 c0       	push   $0xc010bd1e
c010825f:	6a 61                	push   $0x61
c0108261:	68 33 bd 10 c0       	push   $0xc010bd33
c0108266:	e8 79 81 ff ff       	call   c01003e4 <__panic>
	(*pt_entry) = (*pt_entry) | (PTE_A);
c010826b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010826e:	8b 00                	mov    (%eax),%eax
c0108270:	83 c8 20             	or     $0x20,%eax
c0108273:	89 c2                	mov    %eax,%edx
c0108275:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108278:	89 10                	mov    %edx,(%eax)
}
c010827a:	90                   	nop
c010827b:	c9                   	leave  
c010827c:	c3                   	ret    

c010827d <mark_write>:

static void
mark_write(int page_id) {
c010827d:	55                   	push   %ebp
c010827e:	89 e5                	mov    %esp,%ebp
c0108280:	83 ec 18             	sub    $0x18,%esp
	uintptr_t la = (page_id << 12);
c0108283:	8b 45 08             	mov    0x8(%ebp),%eax
c0108286:	c1 e0 0c             	shl    $0xc,%eax
c0108289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
c010828c:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c0108291:	83 ec 04             	sub    $0x4,%esp
c0108294:	6a 00                	push   $0x0
c0108296:	ff 75 f4             	pushl  -0xc(%ebp)
c0108299:	50                   	push   %eax
c010829a:	e8 db b9 ff ff       	call   c0103c7a <get_pte>
c010829f:	83 c4 10             	add    $0x10,%esp
c01082a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert(pt_entry != NULL);
c01082a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01082a9:	75 16                	jne    c01082c1 <mark_write+0x44>
c01082ab:	68 8b bd 10 c0       	push   $0xc010bd8b
c01082b0:	68 1e bd 10 c0       	push   $0xc010bd1e
c01082b5:	6a 69                	push   $0x69
c01082b7:	68 33 bd 10 c0       	push   $0xc010bd33
c01082bc:	e8 23 81 ff ff       	call   c01003e4 <__panic>
	(*pt_entry) = (*pt_entry) | (PTE_A);
c01082c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082c4:	8b 00                	mov    (%eax),%eax
c01082c6:	83 c8 20             	or     $0x20,%eax
c01082c9:	89 c2                	mov    %eax,%edx
c01082cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082ce:	89 10                	mov    %edx,(%eax)
	(*pt_entry) = (*pt_entry) | (PTE_D);
c01082d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082d3:	8b 00                	mov    (%eax),%eax
c01082d5:	83 c8 40             	or     $0x40,%eax
c01082d8:	89 c2                	mov    %eax,%edx
c01082da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082dd:	89 10                	mov    %edx,(%eax)
}
c01082df:	90                   	nop
c01082e0:	c9                   	leave  
c01082e1:	c3                   	ret    

c01082e2 <_clock_check_swap>:

static int
_clock_check_swap(void) {
c01082e2:	55                   	push   %ebp
c01082e3:	89 e5                	mov    %esp,%ebp
c01082e5:	83 ec 18             	sub    $0x18,%esp
	// Clear all A/D bytes in Page a, b, c, d, e
	for (int i = 1; i < 6; ++ i) {
c01082e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01082ef:	eb 60                	jmp    c0108351 <_clock_check_swap+0x6f>
		uintptr_t la = (i << 12);
c01082f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082f4:	c1 e0 0c             	shl    $0xc,%eax
c01082f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
c01082fa:	a1 44 7a 12 c0       	mov    0xc0127a44,%eax
c01082ff:	83 ec 04             	sub    $0x4,%esp
c0108302:	6a 00                	push   $0x0
c0108304:	ff 75 f0             	pushl  -0x10(%ebp)
c0108307:	50                   	push   %eax
c0108308:	e8 6d b9 ff ff       	call   c0103c7a <get_pte>
c010830d:	83 c4 10             	add    $0x10,%esp
c0108310:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert(pt_entry != NULL);
c0108313:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108317:	75 16                	jne    c010832f <_clock_check_swap+0x4d>
c0108319:	68 8b bd 10 c0       	push   $0xc010bd8b
c010831e:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108323:	6a 74                	push   $0x74
c0108325:	68 33 bd 10 c0       	push   $0xc010bd33
c010832a:	e8 b5 80 ff ff       	call   c01003e4 <__panic>
		(*pt_entry) = (*pt_entry) & (~PTE_A);
c010832f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108332:	8b 00                	mov    (%eax),%eax
c0108334:	83 e0 df             	and    $0xffffffdf,%eax
c0108337:	89 c2                	mov    %eax,%edx
c0108339:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010833c:	89 10                	mov    %edx,(%eax)
		(*pt_entry) = (*pt_entry) & (~PTE_D);
c010833e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108341:	8b 00                	mov    (%eax),%eax
c0108343:	83 e0 bf             	and    $0xffffffbf,%eax
c0108346:	89 c2                	mov    %eax,%edx
c0108348:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010834b:	89 10                	mov    %edx,(%eax)
}

static int
_clock_check_swap(void) {
	// Clear all A/D bytes in Page a, b, c, d, e
	for (int i = 1; i < 6; ++ i) {
c010834d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108351:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
c0108355:	7e 9a                	jle    c01082f1 <_clock_check_swap+0xf>
		(*pt_entry) = (*pt_entry) & (~PTE_A);
		(*pt_entry) = (*pt_entry) & (~PTE_D);
	}
	unsigned char temp;

	cprintf("read Virt Page c in clock_check_swap\n");
c0108357:	83 ec 0c             	sub    $0xc,%esp
c010835a:	68 9c bd 10 c0       	push   $0xc010bd9c
c010835f:	e8 1a 7f ff ff       	call   c010027e <cprintf>
c0108364:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x3000;
c0108367:	b8 00 30 00 00       	mov    $0x3000,%eax
c010836c:	0f b6 00             	movzbl (%eax),%eax
c010836f:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(3);
c0108372:	83 ec 0c             	sub    $0xc,%esp
c0108375:	6a 03                	push   $0x3
c0108377:	e8 ab fe ff ff       	call   c0108227 <mark_read>
c010837c:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==4);
c010837f:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0108384:	83 f8 04             	cmp    $0x4,%eax
c0108387:	74 16                	je     c010839f <_clock_check_swap+0xbd>
c0108389:	68 c2 bd 10 c0       	push   $0xc010bdc2
c010838e:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108393:	6a 7d                	push   $0x7d
c0108395:	68 33 bd 10 c0       	push   $0xc010bd33
c010839a:	e8 45 80 ff ff       	call   c01003e4 <__panic>

    cprintf("write Virt Page a in clock_check_swap\n");
c010839f:	83 ec 0c             	sub    $0xc,%esp
c01083a2:	68 d4 bd 10 c0       	push   $0xc010bdd4
c01083a7:	e8 d2 7e ff ff       	call   c010027e <cprintf>
c01083ac:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01083af:	b8 00 10 00 00       	mov    $0x1000,%eax
c01083b4:	c6 00 0a             	movb   $0xa,(%eax)
    mark_write(1);
c01083b7:	83 ec 0c             	sub    $0xc,%esp
c01083ba:	6a 01                	push   $0x1
c01083bc:	e8 bc fe ff ff       	call   c010827d <mark_write>
c01083c1:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==4);
c01083c4:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c01083c9:	83 f8 04             	cmp    $0x4,%eax
c01083cc:	74 19                	je     c01083e7 <_clock_check_swap+0x105>
c01083ce:	68 c2 bd 10 c0       	push   $0xc010bdc2
c01083d3:	68 1e bd 10 c0       	push   $0xc010bd1e
c01083d8:	68 82 00 00 00       	push   $0x82
c01083dd:	68 33 bd 10 c0       	push   $0xc010bd33
c01083e2:	e8 fd 7f ff ff       	call   c01003e4 <__panic>

    cprintf("read Virt Page d in fifo_check_swap\n");
c01083e7:	83 ec 0c             	sub    $0xc,%esp
c01083ea:	68 fc bd 10 c0       	push   $0xc010bdfc
c01083ef:	e8 8a 7e ff ff       	call   c010027e <cprintf>
c01083f4:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x4000;
c01083f7:	b8 00 40 00 00       	mov    $0x4000,%eax
c01083fc:	0f b6 00             	movzbl (%eax),%eax
c01083ff:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(4);
c0108402:	83 ec 0c             	sub    $0xc,%esp
c0108405:	6a 04                	push   $0x4
c0108407:	e8 1b fe ff ff       	call   c0108227 <mark_read>
c010840c:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==4);
c010840f:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0108414:	83 f8 04             	cmp    $0x4,%eax
c0108417:	74 19                	je     c0108432 <_clock_check_swap+0x150>
c0108419:	68 c2 bd 10 c0       	push   $0xc010bdc2
c010841e:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108423:	68 87 00 00 00       	push   $0x87
c0108428:	68 33 bd 10 c0       	push   $0xc010bd33
c010842d:	e8 b2 7f ff ff       	call   c01003e4 <__panic>

    cprintf("write Virt Page b in fifo_check_swap\n");
c0108432:	83 ec 0c             	sub    $0xc,%esp
c0108435:	68 24 be 10 c0       	push   $0xc010be24
c010843a:	e8 3f 7e ff ff       	call   c010027e <cprintf>
c010843f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0108442:	b8 00 20 00 00       	mov    $0x2000,%eax
c0108447:	c6 00 0b             	movb   $0xb,(%eax)
    mark_write(2);
c010844a:	83 ec 0c             	sub    $0xc,%esp
c010844d:	6a 02                	push   $0x2
c010844f:	e8 29 fe ff ff       	call   c010827d <mark_write>
c0108454:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==4);
c0108457:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c010845c:	83 f8 04             	cmp    $0x4,%eax
c010845f:	74 19                	je     c010847a <_clock_check_swap+0x198>
c0108461:	68 c2 bd 10 c0       	push   $0xc010bdc2
c0108466:	68 1e bd 10 c0       	push   $0xc010bd1e
c010846b:	68 8c 00 00 00       	push   $0x8c
c0108470:	68 33 bd 10 c0       	push   $0xc010bd33
c0108475:	e8 6a 7f ff ff       	call   c01003e4 <__panic>

    cprintf("read Virt Page e in fifo_check_swap\n");
c010847a:	83 ec 0c             	sub    $0xc,%esp
c010847d:	68 4c be 10 c0       	push   $0xc010be4c
c0108482:	e8 f7 7d ff ff       	call   c010027e <cprintf>
c0108487:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x5000;
c010848a:	b8 00 50 00 00       	mov    $0x5000,%eax
c010848f:	0f b6 00             	movzbl (%eax),%eax
c0108492:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(5);
c0108495:	83 ec 0c             	sub    $0xc,%esp
c0108498:	6a 05                	push   $0x5
c010849a:	e8 88 fd ff ff       	call   c0108227 <mark_read>
c010849f:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==5);
c01084a2:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c01084a7:	83 f8 05             	cmp    $0x5,%eax
c01084aa:	74 19                	je     c01084c5 <_clock_check_swap+0x1e3>
c01084ac:	68 71 be 10 c0       	push   $0xc010be71
c01084b1:	68 1e bd 10 c0       	push   $0xc010bd1e
c01084b6:	68 91 00 00 00       	push   $0x91
c01084bb:	68 33 bd 10 c0       	push   $0xc010bd33
c01084c0:	e8 1f 7f ff ff       	call   c01003e4 <__panic>

    cprintf("read Virt Page b in fifo_check_swap\n");
c01084c5:	83 ec 0c             	sub    $0xc,%esp
c01084c8:	68 80 be 10 c0       	push   $0xc010be80
c01084cd:	e8 ac 7d ff ff       	call   c010027e <cprintf>
c01084d2:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x2000;
c01084d5:	b8 00 20 00 00       	mov    $0x2000,%eax
c01084da:	0f b6 00             	movzbl (%eax),%eax
c01084dd:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(2);
c01084e0:	83 ec 0c             	sub    $0xc,%esp
c01084e3:	6a 02                	push   $0x2
c01084e5:	e8 3d fd ff ff       	call   c0108227 <mark_read>
c01084ea:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==5);
c01084ed:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c01084f2:	83 f8 05             	cmp    $0x5,%eax
c01084f5:	74 19                	je     c0108510 <_clock_check_swap+0x22e>
c01084f7:	68 71 be 10 c0       	push   $0xc010be71
c01084fc:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108501:	68 96 00 00 00       	push   $0x96
c0108506:	68 33 bd 10 c0       	push   $0xc010bd33
c010850b:	e8 d4 7e ff ff       	call   c01003e4 <__panic>

    cprintf("write Virt Page a in fifo_check_swap\n");
c0108510:	83 ec 0c             	sub    $0xc,%esp
c0108513:	68 a8 be 10 c0       	push   $0xc010bea8
c0108518:	e8 61 7d ff ff       	call   c010027e <cprintf>
c010851d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0108520:	b8 00 10 00 00       	mov    $0x1000,%eax
c0108525:	c6 00 0a             	movb   $0xa,(%eax)
    mark_write(1);
c0108528:	83 ec 0c             	sub    $0xc,%esp
c010852b:	6a 01                	push   $0x1
c010852d:	e8 4b fd ff ff       	call   c010827d <mark_write>
c0108532:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==5);
c0108535:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c010853a:	83 f8 05             	cmp    $0x5,%eax
c010853d:	74 19                	je     c0108558 <_clock_check_swap+0x276>
c010853f:	68 71 be 10 c0       	push   $0xc010be71
c0108544:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108549:	68 9b 00 00 00       	push   $0x9b
c010854e:	68 33 bd 10 c0       	push   $0xc010bd33
c0108553:	e8 8c 7e ff ff       	call   c01003e4 <__panic>

    cprintf("read Virt Page b in fifo_check_swap\n");
c0108558:	83 ec 0c             	sub    $0xc,%esp
c010855b:	68 80 be 10 c0       	push   $0xc010be80
c0108560:	e8 19 7d ff ff       	call   c010027e <cprintf>
c0108565:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x2000;
c0108568:	b8 00 20 00 00       	mov    $0x2000,%eax
c010856d:	0f b6 00             	movzbl (%eax),%eax
c0108570:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(2);
c0108573:	83 ec 0c             	sub    $0xc,%esp
c0108576:	6a 02                	push   $0x2
c0108578:	e8 aa fc ff ff       	call   c0108227 <mark_read>
c010857d:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==5);
c0108580:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c0108585:	83 f8 05             	cmp    $0x5,%eax
c0108588:	74 19                	je     c01085a3 <_clock_check_swap+0x2c1>
c010858a:	68 71 be 10 c0       	push   $0xc010be71
c010858f:	68 1e bd 10 c0       	push   $0xc010bd1e
c0108594:	68 a0 00 00 00       	push   $0xa0
c0108599:	68 33 bd 10 c0       	push   $0xc010bd33
c010859e:	e8 41 7e ff ff       	call   c01003e4 <__panic>

    cprintf("read Virt Page c in fifo_check_swap\n");
c01085a3:	83 ec 0c             	sub    $0xc,%esp
c01085a6:	68 d0 be 10 c0       	push   $0xc010bed0
c01085ab:	e8 ce 7c ff ff       	call   c010027e <cprintf>
c01085b0:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x3000;
c01085b3:	b8 00 30 00 00       	mov    $0x3000,%eax
c01085b8:	0f b6 00             	movzbl (%eax),%eax
c01085bb:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(3);
c01085be:	83 ec 0c             	sub    $0xc,%esp
c01085c1:	6a 03                	push   $0x3
c01085c3:	e8 5f fc ff ff       	call   c0108227 <mark_read>
c01085c8:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==6);
c01085cb:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c01085d0:	83 f8 06             	cmp    $0x6,%eax
c01085d3:	74 19                	je     c01085ee <_clock_check_swap+0x30c>
c01085d5:	68 f5 be 10 c0       	push   $0xc010bef5
c01085da:	68 1e bd 10 c0       	push   $0xc010bd1e
c01085df:	68 a5 00 00 00       	push   $0xa5
c01085e4:	68 33 bd 10 c0       	push   $0xc010bd33
c01085e9:	e8 f6 7d ff ff       	call   c01003e4 <__panic>

    cprintf("read Virt Page d in fifo_check_swap\n");
c01085ee:	83 ec 0c             	sub    $0xc,%esp
c01085f1:	68 fc bd 10 c0       	push   $0xc010bdfc
c01085f6:	e8 83 7c ff ff       	call   c010027e <cprintf>
c01085fb:	83 c4 10             	add    $0x10,%esp
    temp += *(unsigned char *)0x4000;
c01085fe:	b8 00 40 00 00       	mov    $0x4000,%eax
c0108603:	0f b6 00             	movzbl (%eax),%eax
c0108606:	00 45 eb             	add    %al,-0x15(%ebp)
    mark_read(4);
c0108609:	83 ec 0c             	sub    $0xc,%esp
c010860c:	6a 04                	push   $0x4
c010860e:	e8 14 fc ff ff       	call   c0108227 <mark_read>
c0108613:	83 c4 10             	add    $0x10,%esp
    assert(pgfault_num==7);
c0108616:	a1 cc 7a 12 c0       	mov    0xc0127acc,%eax
c010861b:	83 f8 07             	cmp    $0x7,%eax
c010861e:	74 19                	je     c0108639 <_clock_check_swap+0x357>
c0108620:	68 04 bf 10 c0       	push   $0xc010bf04
c0108625:	68 1e bd 10 c0       	push   $0xc010bd1e
c010862a:	68 aa 00 00 00       	push   $0xaa
c010862f:	68 33 bd 10 c0       	push   $0xc010bd33
c0108634:	e8 ab 7d ff ff       	call   c01003e4 <__panic>

    return 0;
c0108639:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010863e:	c9                   	leave  
c010863f:	c3                   	ret    

c0108640 <_clock_init>:


static int
_clock_init(void)
{
c0108640:	55                   	push   %ebp
c0108641:	89 e5                	mov    %esp,%ebp
    return 0;
c0108643:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108648:	5d                   	pop    %ebp
c0108649:	c3                   	ret    

c010864a <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010864a:	55                   	push   %ebp
c010864b:	89 e5                	mov    %esp,%ebp
    return 0;
c010864d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108652:	5d                   	pop    %ebp
c0108653:	c3                   	ret    

c0108654 <_clock_tick_event>:

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }
c0108654:	55                   	push   %ebp
c0108655:	89 e5                	mov    %esp,%ebp
c0108657:	b8 00 00 00 00       	mov    $0x0,%eax
c010865c:	5d                   	pop    %ebp
c010865d:	c3                   	ret    

c010865e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010865e:	55                   	push   %ebp
c010865f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108661:	8b 45 08             	mov    0x8(%ebp),%eax
c0108664:	8b 15 20 9b 12 c0    	mov    0xc0129b20,%edx
c010866a:	29 d0                	sub    %edx,%eax
c010866c:	c1 f8 05             	sar    $0x5,%eax
}
c010866f:	5d                   	pop    %ebp
c0108670:	c3                   	ret    

c0108671 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108671:	55                   	push   %ebp
c0108672:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0108674:	ff 75 08             	pushl  0x8(%ebp)
c0108677:	e8 e2 ff ff ff       	call   c010865e <page2ppn>
c010867c:	83 c4 04             	add    $0x4,%esp
c010867f:	c1 e0 0c             	shl    $0xc,%eax
}
c0108682:	c9                   	leave  
c0108683:	c3                   	ret    

c0108684 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108684:	55                   	push   %ebp
c0108685:	89 e5                	mov    %esp,%ebp
c0108687:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c010868a:	ff 75 08             	pushl  0x8(%ebp)
c010868d:	e8 df ff ff ff       	call   c0108671 <page2pa>
c0108692:	83 c4 04             	add    $0x4,%esp
c0108695:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108698:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010869b:	c1 e8 0c             	shr    $0xc,%eax
c010869e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086a1:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c01086a6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01086a9:	72 14                	jb     c01086bf <page2kva+0x3b>
c01086ab:	ff 75 f4             	pushl  -0xc(%ebp)
c01086ae:	68 30 bf 10 c0       	push   $0xc010bf30
c01086b3:	6a 66                	push   $0x66
c01086b5:	68 53 bf 10 c0       	push   $0xc010bf53
c01086ba:	e8 25 7d ff ff       	call   c01003e4 <__panic>
c01086bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01086c7:	c9                   	leave  
c01086c8:	c3                   	ret    

c01086c9 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01086c9:	55                   	push   %ebp
c01086ca:	89 e5                	mov    %esp,%ebp
c01086cc:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01086cf:	83 ec 0c             	sub    $0xc,%esp
c01086d2:	6a 01                	push   $0x1
c01086d4:	e8 ee 89 ff ff       	call   c01010c7 <ide_device_valid>
c01086d9:	83 c4 10             	add    $0x10,%esp
c01086dc:	85 c0                	test   %eax,%eax
c01086de:	75 14                	jne    c01086f4 <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c01086e0:	83 ec 04             	sub    $0x4,%esp
c01086e3:	68 61 bf 10 c0       	push   $0xc010bf61
c01086e8:	6a 0d                	push   $0xd
c01086ea:	68 7b bf 10 c0       	push   $0xc010bf7b
c01086ef:	e8 f0 7c ff ff       	call   c01003e4 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01086f4:	83 ec 0c             	sub    $0xc,%esp
c01086f7:	6a 01                	push   $0x1
c01086f9:	e8 09 8a ff ff       	call   c0101107 <ide_device_size>
c01086fe:	83 c4 10             	add    $0x10,%esp
c0108701:	c1 e8 03             	shr    $0x3,%eax
c0108704:	a3 dc 9b 12 c0       	mov    %eax,0xc0129bdc
}
c0108709:	90                   	nop
c010870a:	c9                   	leave  
c010870b:	c3                   	ret    

c010870c <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c010870c:	55                   	push   %ebp
c010870d:	89 e5                	mov    %esp,%ebp
c010870f:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108712:	83 ec 0c             	sub    $0xc,%esp
c0108715:	ff 75 0c             	pushl  0xc(%ebp)
c0108718:	e8 67 ff ff ff       	call   c0108684 <page2kva>
c010871d:	83 c4 10             	add    $0x10,%esp
c0108720:	89 c2                	mov    %eax,%edx
c0108722:	8b 45 08             	mov    0x8(%ebp),%eax
c0108725:	c1 e8 08             	shr    $0x8,%eax
c0108728:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010872b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010872f:	74 0a                	je     c010873b <swapfs_read+0x2f>
c0108731:	a1 dc 9b 12 c0       	mov    0xc0129bdc,%eax
c0108736:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0108739:	72 14                	jb     c010874f <swapfs_read+0x43>
c010873b:	ff 75 08             	pushl  0x8(%ebp)
c010873e:	68 8c bf 10 c0       	push   $0xc010bf8c
c0108743:	6a 14                	push   $0x14
c0108745:	68 7b bf 10 c0       	push   $0xc010bf7b
c010874a:	e8 95 7c ff ff       	call   c01003e4 <__panic>
c010874f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108752:	c1 e0 03             	shl    $0x3,%eax
c0108755:	6a 08                	push   $0x8
c0108757:	52                   	push   %edx
c0108758:	50                   	push   %eax
c0108759:	6a 01                	push   $0x1
c010875b:	e8 e7 89 ff ff       	call   c0101147 <ide_read_secs>
c0108760:	83 c4 10             	add    $0x10,%esp
}
c0108763:	c9                   	leave  
c0108764:	c3                   	ret    

c0108765 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108765:	55                   	push   %ebp
c0108766:	89 e5                	mov    %esp,%ebp
c0108768:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010876b:	83 ec 0c             	sub    $0xc,%esp
c010876e:	ff 75 0c             	pushl  0xc(%ebp)
c0108771:	e8 0e ff ff ff       	call   c0108684 <page2kva>
c0108776:	83 c4 10             	add    $0x10,%esp
c0108779:	89 c2                	mov    %eax,%edx
c010877b:	8b 45 08             	mov    0x8(%ebp),%eax
c010877e:	c1 e8 08             	shr    $0x8,%eax
c0108781:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108788:	74 0a                	je     c0108794 <swapfs_write+0x2f>
c010878a:	a1 dc 9b 12 c0       	mov    0xc0129bdc,%eax
c010878f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0108792:	72 14                	jb     c01087a8 <swapfs_write+0x43>
c0108794:	ff 75 08             	pushl  0x8(%ebp)
c0108797:	68 8c bf 10 c0       	push   $0xc010bf8c
c010879c:	6a 19                	push   $0x19
c010879e:	68 7b bf 10 c0       	push   $0xc010bf7b
c01087a3:	e8 3c 7c ff ff       	call   c01003e4 <__panic>
c01087a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087ab:	c1 e0 03             	shl    $0x3,%eax
c01087ae:	6a 08                	push   $0x8
c01087b0:	52                   	push   %edx
c01087b1:	50                   	push   %eax
c01087b2:	6a 01                	push   $0x1
c01087b4:	e8 b8 8b ff ff       	call   c0101371 <ide_write_secs>
c01087b9:	83 c4 10             	add    $0x10,%esp
}
c01087bc:	c9                   	leave  
c01087bd:	c3                   	ret    

c01087be <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c01087be:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c01087c2:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c01087c4:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c01087c7:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c01087ca:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c01087cd:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c01087d0:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c01087d3:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c01087d6:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c01087d9:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c01087dd:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c01087e0:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c01087e3:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c01087e6:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c01087e9:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c01087ec:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c01087ef:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c01087f2:	ff 30                	pushl  (%eax)

    ret
c01087f4:	c3                   	ret    

c01087f5 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c01087f5:	52                   	push   %edx
    call *%ebx              # call fn
c01087f6:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c01087f8:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c01087f9:	e8 bc 07 00 00       	call   c0108fba <do_exit>

c01087fe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01087fe:	55                   	push   %ebp
c01087ff:	89 e5                	mov    %esp,%ebp
c0108801:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108804:	9c                   	pushf  
c0108805:	58                   	pop    %eax
c0108806:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108809:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010880c:	25 00 02 00 00       	and    $0x200,%eax
c0108811:	85 c0                	test   %eax,%eax
c0108813:	74 0c                	je     c0108821 <__intr_save+0x23>
        intr_disable();
c0108815:	e8 90 98 ff ff       	call   c01020aa <intr_disable>
        return 1;
c010881a:	b8 01 00 00 00       	mov    $0x1,%eax
c010881f:	eb 05                	jmp    c0108826 <__intr_save+0x28>
    }
    return 0;
c0108821:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108826:	c9                   	leave  
c0108827:	c3                   	ret    

c0108828 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108828:	55                   	push   %ebp
c0108829:	89 e5                	mov    %esp,%ebp
c010882b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010882e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108832:	74 05                	je     c0108839 <__intr_restore+0x11>
        intr_enable();
c0108834:	e8 6a 98 ff ff       	call   c01020a3 <intr_enable>
    }
}
c0108839:	90                   	nop
c010883a:	c9                   	leave  
c010883b:	c3                   	ret    

c010883c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010883c:	55                   	push   %ebp
c010883d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010883f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108842:	8b 15 20 9b 12 c0    	mov    0xc0129b20,%edx
c0108848:	29 d0                	sub    %edx,%eax
c010884a:	c1 f8 05             	sar    $0x5,%eax
}
c010884d:	5d                   	pop    %ebp
c010884e:	c3                   	ret    

c010884f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010884f:	55                   	push   %ebp
c0108850:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0108852:	ff 75 08             	pushl  0x8(%ebp)
c0108855:	e8 e2 ff ff ff       	call   c010883c <page2ppn>
c010885a:	83 c4 04             	add    $0x4,%esp
c010885d:	c1 e0 0c             	shl    $0xc,%eax
}
c0108860:	c9                   	leave  
c0108861:	c3                   	ret    

c0108862 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0108862:	55                   	push   %ebp
c0108863:	89 e5                	mov    %esp,%ebp
c0108865:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0108868:	8b 45 08             	mov    0x8(%ebp),%eax
c010886b:	c1 e8 0c             	shr    $0xc,%eax
c010886e:	89 c2                	mov    %eax,%edx
c0108870:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c0108875:	39 c2                	cmp    %eax,%edx
c0108877:	72 14                	jb     c010888d <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0108879:	83 ec 04             	sub    $0x4,%esp
c010887c:	68 ac bf 10 c0       	push   $0xc010bfac
c0108881:	6a 5f                	push   $0x5f
c0108883:	68 cb bf 10 c0       	push   $0xc010bfcb
c0108888:	e8 57 7b ff ff       	call   c01003e4 <__panic>
    }
    return &pages[PPN(pa)];
c010888d:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c0108892:	8b 55 08             	mov    0x8(%ebp),%edx
c0108895:	c1 ea 0c             	shr    $0xc,%edx
c0108898:	c1 e2 05             	shl    $0x5,%edx
c010889b:	01 d0                	add    %edx,%eax
}
c010889d:	c9                   	leave  
c010889e:	c3                   	ret    

c010889f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010889f:	55                   	push   %ebp
c01088a0:	89 e5                	mov    %esp,%ebp
c01088a2:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01088a5:	ff 75 08             	pushl  0x8(%ebp)
c01088a8:	e8 a2 ff ff ff       	call   c010884f <page2pa>
c01088ad:	83 c4 04             	add    $0x4,%esp
c01088b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088b6:	c1 e8 0c             	shr    $0xc,%eax
c01088b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01088bc:	a1 40 7a 12 c0       	mov    0xc0127a40,%eax
c01088c1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01088c4:	72 14                	jb     c01088da <page2kva+0x3b>
c01088c6:	ff 75 f4             	pushl  -0xc(%ebp)
c01088c9:	68 dc bf 10 c0       	push   $0xc010bfdc
c01088ce:	6a 66                	push   $0x66
c01088d0:	68 cb bf 10 c0       	push   $0xc010bfcb
c01088d5:	e8 0a 7b ff ff       	call   c01003e4 <__panic>
c01088da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088dd:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01088e2:	c9                   	leave  
c01088e3:	c3                   	ret    

c01088e4 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01088e4:	55                   	push   %ebp
c01088e5:	89 e5                	mov    %esp,%ebp
c01088e7:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c01088ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088f0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01088f7:	77 14                	ja     c010890d <kva2page+0x29>
c01088f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01088fc:	68 00 c0 10 c0       	push   $0xc010c000
c0108901:	6a 6b                	push   $0x6b
c0108903:	68 cb bf 10 c0       	push   $0xc010bfcb
c0108908:	e8 d7 7a ff ff       	call   c01003e4 <__panic>
c010890d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108910:	05 00 00 00 40       	add    $0x40000000,%eax
c0108915:	83 ec 0c             	sub    $0xc,%esp
c0108918:	50                   	push   %eax
c0108919:	e8 44 ff ff ff       	call   c0108862 <pa2page>
c010891e:	83 c4 10             	add    $0x10,%esp
}
c0108921:	c9                   	leave  
c0108922:	c3                   	ret    

c0108923 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c0108923:	55                   	push   %ebp
c0108924:	89 e5                	mov    %esp,%ebp
c0108926:	83 ec 18             	sub    $0x18,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0108929:	83 ec 0c             	sub    $0xc,%esp
c010892c:	6a 68                	push   $0x68
c010892e:	e8 5c e0 ff ff       	call   c010698f <kmalloc>
c0108933:	83 c4 10             	add    $0x10,%esp
c0108936:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0108939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010893d:	0f 84 91 00 00 00    	je     c01089d4 <alloc_proc+0xb1>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
    	proc->state = PROC_UNINIT;
c0108943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	proc->pid = -1;
c010894c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010894f:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    	proc->runs = 0;
c0108956:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108959:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    	proc->kstack = NULL;
c0108960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108963:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    	proc->need_resched = 0;
c010896a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010896d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = NULL;
c0108974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108977:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm = NULL;
c010897e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108981:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc->context), 0, sizeof(struct context));
c0108988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010898b:	83 c0 1c             	add    $0x1c,%eax
c010898e:	83 ec 04             	sub    $0x4,%esp
c0108991:	6a 20                	push   $0x20
c0108993:	6a 00                	push   $0x0
c0108995:	50                   	push   %eax
c0108996:	e8 cb 0c 00 00       	call   c0109666 <memset>
c010899b:	83 c4 10             	add    $0x10,%esp
        proc->tf = NULL;
c010899e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089a1:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = boot_cr3;
c01089a8:	8b 15 1c 9b 12 c0    	mov    0xc0129b1c,%edx
c01089ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089b1:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags = 0;
c01089b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089b7:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc->name, 0, PROC_NAME_LEN);
c01089be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089c1:	83 c0 48             	add    $0x48,%eax
c01089c4:	83 ec 04             	sub    $0x4,%esp
c01089c7:	6a 0f                	push   $0xf
c01089c9:	6a 00                	push   $0x0
c01089cb:	50                   	push   %eax
c01089cc:	e8 95 0c 00 00       	call   c0109666 <memset>
c01089d1:	83 c4 10             	add    $0x10,%esp
    }
    return proc;
c01089d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01089d7:	c9                   	leave  
c01089d8:	c3                   	ret    

c01089d9 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01089d9:	55                   	push   %ebp
c01089da:	89 e5                	mov    %esp,%ebp
c01089dc:	83 ec 08             	sub    $0x8,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01089df:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e2:	83 c0 48             	add    $0x48,%eax
c01089e5:	83 ec 04             	sub    $0x4,%esp
c01089e8:	6a 10                	push   $0x10
c01089ea:	6a 00                	push   $0x0
c01089ec:	50                   	push   %eax
c01089ed:	e8 74 0c 00 00       	call   c0109666 <memset>
c01089f2:	83 c4 10             	add    $0x10,%esp
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01089f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f8:	83 c0 48             	add    $0x48,%eax
c01089fb:	83 ec 04             	sub    $0x4,%esp
c01089fe:	6a 0f                	push   $0xf
c0108a00:	ff 75 0c             	pushl  0xc(%ebp)
c0108a03:	50                   	push   %eax
c0108a04:	e8 40 0d 00 00       	call   c0109749 <memcpy>
c0108a09:	83 c4 10             	add    $0x10,%esp
}
c0108a0c:	c9                   	leave  
c0108a0d:	c3                   	ret    

c0108a0e <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0108a0e:	55                   	push   %ebp
c0108a0f:	89 e5                	mov    %esp,%ebp
c0108a11:	83 ec 08             	sub    $0x8,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0108a14:	83 ec 04             	sub    $0x4,%esp
c0108a17:	6a 10                	push   $0x10
c0108a19:	6a 00                	push   $0x0
c0108a1b:	68 04 9b 12 c0       	push   $0xc0129b04
c0108a20:	e8 41 0c 00 00       	call   c0109666 <memset>
c0108a25:	83 c4 10             	add    $0x10,%esp
    return memcpy(name, proc->name, PROC_NAME_LEN);
c0108a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a2b:	83 c0 48             	add    $0x48,%eax
c0108a2e:	83 ec 04             	sub    $0x4,%esp
c0108a31:	6a 0f                	push   $0xf
c0108a33:	50                   	push   %eax
c0108a34:	68 04 9b 12 c0       	push   $0xc0129b04
c0108a39:	e8 0b 0d 00 00       	call   c0109749 <memcpy>
c0108a3e:	83 c4 10             	add    $0x10,%esp
}
c0108a41:	c9                   	leave  
c0108a42:	c3                   	ret    

c0108a43 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0108a43:	55                   	push   %ebp
c0108a44:	89 e5                	mov    %esp,%ebp
c0108a46:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108a49:	c7 45 f8 24 9c 12 c0 	movl   $0xc0129c24,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0108a50:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
c0108a55:	83 c0 01             	add    $0x1,%eax
c0108a58:	a3 a0 6a 12 c0       	mov    %eax,0xc0126aa0
c0108a5d:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
c0108a62:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108a67:	7e 0c                	jle    c0108a75 <get_pid+0x32>
        last_pid = 1;
c0108a69:	c7 05 a0 6a 12 c0 01 	movl   $0x1,0xc0126aa0
c0108a70:	00 00 00 
        goto inside;
c0108a73:	eb 13                	jmp    c0108a88 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c0108a75:	8b 15 a0 6a 12 c0    	mov    0xc0126aa0,%edx
c0108a7b:	a1 a4 6a 12 c0       	mov    0xc0126aa4,%eax
c0108a80:	39 c2                	cmp    %eax,%edx
c0108a82:	0f 8c ac 00 00 00    	jl     c0108b34 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108a88:	c7 05 a4 6a 12 c0 00 	movl   $0x2000,0xc0126aa4
c0108a8f:	20 00 00 
    repeat:
        le = list;
c0108a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108a98:	eb 7f                	jmp    c0108b19 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a9d:	83 e8 58             	sub    $0x58,%eax
c0108aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0108aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aa6:	8b 50 04             	mov    0x4(%eax),%edx
c0108aa9:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
c0108aae:	39 c2                	cmp    %eax,%edx
c0108ab0:	75 3e                	jne    c0108af0 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0108ab2:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
c0108ab7:	83 c0 01             	add    $0x1,%eax
c0108aba:	a3 a0 6a 12 c0       	mov    %eax,0xc0126aa0
c0108abf:	8b 15 a0 6a 12 c0    	mov    0xc0126aa0,%edx
c0108ac5:	a1 a4 6a 12 c0       	mov    0xc0126aa4,%eax
c0108aca:	39 c2                	cmp    %eax,%edx
c0108acc:	7c 4b                	jl     c0108b19 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0108ace:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
c0108ad3:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108ad8:	7e 0a                	jle    c0108ae4 <get_pid+0xa1>
                        last_pid = 1;
c0108ada:	c7 05 a0 6a 12 c0 01 	movl   $0x1,0xc0126aa0
c0108ae1:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0108ae4:	c7 05 a4 6a 12 c0 00 	movl   $0x2000,0xc0126aa4
c0108aeb:	20 00 00 
                    goto repeat;
c0108aee:	eb a2                	jmp    c0108a92 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108af3:	8b 50 04             	mov    0x4(%eax),%edx
c0108af6:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
c0108afb:	39 c2                	cmp    %eax,%edx
c0108afd:	7e 1a                	jle    c0108b19 <get_pid+0xd6>
c0108aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b02:	8b 50 04             	mov    0x4(%eax),%edx
c0108b05:	a1 a4 6a 12 c0       	mov    0xc0126aa4,%eax
c0108b0a:	39 c2                	cmp    %eax,%edx
c0108b0c:	7d 0b                	jge    c0108b19 <get_pid+0xd6>
                next_safe = proc->pid;
c0108b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b11:	8b 40 04             	mov    0x4(%eax),%eax
c0108b14:	a3 a4 6a 12 c0       	mov    %eax,0xc0126aa4
c0108b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b22:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0108b25:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b2b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108b2e:	0f 85 66 ff ff ff    	jne    c0108a9a <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0108b34:	a1 a0 6a 12 c0       	mov    0xc0126aa0,%eax
}
c0108b39:	c9                   	leave  
c0108b3a:	c3                   	ret    

c0108b3b <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108b3b:	55                   	push   %ebp
c0108b3c:	89 e5                	mov    %esp,%ebp
c0108b3e:	83 ec 18             	sub    $0x18,%esp
    if (proc != current) {
c0108b41:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0108b46:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108b49:	74 6b                	je     c0108bb6 <proc_run+0x7b>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108b4b:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0108b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b53:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108b59:	e8 a0 fc ff ff       	call   c01087fe <__intr_save>
c0108b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b64:	a3 e8 7a 12 c0       	mov    %eax,0xc0127ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b6c:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b6f:	05 00 20 00 00       	add    $0x2000,%eax
c0108b74:	83 ec 0c             	sub    $0xc,%esp
c0108b77:	50                   	push   %eax
c0108b78:	e8 be a8 ff ff       	call   c010343b <load_esp0>
c0108b7d:	83 c4 10             	add    $0x10,%esp
            lcr3(next->cr3);
c0108b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b83:	8b 40 40             	mov    0x40(%eax),%eax
c0108b86:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0108b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b8c:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b92:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b98:	83 c0 1c             	add    $0x1c,%eax
c0108b9b:	83 ec 08             	sub    $0x8,%esp
c0108b9e:	52                   	push   %edx
c0108b9f:	50                   	push   %eax
c0108ba0:	e8 19 fc ff ff       	call   c01087be <switch_to>
c0108ba5:	83 c4 10             	add    $0x10,%esp
        }
        local_intr_restore(intr_flag);
c0108ba8:	83 ec 0c             	sub    $0xc,%esp
c0108bab:	ff 75 ec             	pushl  -0x14(%ebp)
c0108bae:	e8 75 fc ff ff       	call   c0108828 <__intr_restore>
c0108bb3:	83 c4 10             	add    $0x10,%esp
    }
}
c0108bb6:	90                   	nop
c0108bb7:	c9                   	leave  
c0108bb8:	c3                   	ret    

c0108bb9 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108bb9:	55                   	push   %ebp
c0108bba:	89 e5                	mov    %esp,%ebp
c0108bbc:	83 ec 08             	sub    $0x8,%esp
    forkrets(current->tf);
c0108bbf:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0108bc4:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108bc7:	83 ec 0c             	sub    $0xc,%esp
c0108bca:	50                   	push   %eax
c0108bcb:	e8 ad a6 ff ff       	call   c010327d <forkrets>
c0108bd0:	83 c4 10             	add    $0x10,%esp
}
c0108bd3:	90                   	nop
c0108bd4:	c9                   	leave  
c0108bd5:	c3                   	ret    

c0108bd6 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108bd6:	55                   	push   %ebp
c0108bd7:	89 e5                	mov    %esp,%ebp
c0108bd9:	53                   	push   %ebx
c0108bda:	83 ec 24             	sub    $0x24,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108be0:	8d 58 60             	lea    0x60(%eax),%ebx
c0108be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108be6:	8b 40 04             	mov    0x4(%eax),%eax
c0108be9:	83 ec 08             	sub    $0x8,%esp
c0108bec:	6a 0a                	push   $0xa
c0108bee:	50                   	push   %eax
c0108bef:	e8 09 12 00 00       	call   c0109dfd <hash32>
c0108bf4:	83 c4 10             	add    $0x10,%esp
c0108bf7:	c1 e0 03             	shl    $0x3,%eax
c0108bfa:	05 00 7b 12 c0       	add    $0xc0127b00,%eax
c0108bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c02:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c14:	8b 40 04             	mov    0x4(%eax),%eax
c0108c17:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108c1a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c20:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108c23:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108c2c:	89 10                	mov    %edx,(%eax)
c0108c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c31:	8b 10                	mov    (%eax),%edx
c0108c33:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108c36:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c3f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c45:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108c48:	89 10                	mov    %edx,(%eax)
}
c0108c4a:	90                   	nop
c0108c4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108c4e:	c9                   	leave  
c0108c4f:	c3                   	ret    

c0108c50 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108c50:	55                   	push   %ebp
c0108c51:	89 e5                	mov    %esp,%ebp
c0108c53:	83 ec 18             	sub    $0x18,%esp
    if (0 < pid && pid < MAX_PID) {
c0108c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108c5a:	7e 5d                	jle    c0108cb9 <find_proc+0x69>
c0108c5c:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108c63:	7f 54                	jg     c0108cb9 <find_proc+0x69>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c68:	83 ec 08             	sub    $0x8,%esp
c0108c6b:	6a 0a                	push   $0xa
c0108c6d:	50                   	push   %eax
c0108c6e:	e8 8a 11 00 00       	call   c0109dfd <hash32>
c0108c73:	83 c4 10             	add    $0x10,%esp
c0108c76:	c1 e0 03             	shl    $0x3,%eax
c0108c79:	05 00 7b 12 c0       	add    $0xc0127b00,%eax
c0108c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108c87:	eb 19                	jmp    c0108ca2 <find_proc+0x52>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c8c:	83 e8 60             	sub    $0x60,%eax
c0108c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c95:	8b 40 04             	mov    0x4(%eax),%eax
c0108c98:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108c9b:	75 05                	jne    c0108ca2 <find_proc+0x52>
                return proc;
c0108c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ca0:	eb 1c                	jmp    c0108cbe <find_proc+0x6e>
c0108ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ca5:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cab:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108cb7:	75 d0                	jne    c0108c89 <find_proc+0x39>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108cbe:	c9                   	leave  
c0108cbf:	c3                   	ret    

c0108cc0 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108cc0:	55                   	push   %ebp
c0108cc1:	89 e5                	mov    %esp,%ebp
c0108cc3:	83 ec 58             	sub    $0x58,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108cc6:	83 ec 04             	sub    $0x4,%esp
c0108cc9:	6a 4c                	push   $0x4c
c0108ccb:	6a 00                	push   $0x0
c0108ccd:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108cd0:	50                   	push   %eax
c0108cd1:	e8 90 09 00 00       	call   c0109666 <memset>
c0108cd6:	83 c4 10             	add    $0x10,%esp
    tf.tf_cs = KERNEL_CS;
c0108cd9:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108cdf:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108ce5:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108ce9:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108ced:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108cf1:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cf8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108d01:	b8 f5 87 10 c0       	mov    $0xc01087f5,%eax
c0108d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108d09:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d0c:	80 cc 01             	or     $0x1,%ah
c0108d0f:	89 c2                	mov    %eax,%edx
c0108d11:	83 ec 04             	sub    $0x4,%esp
c0108d14:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108d17:	50                   	push   %eax
c0108d18:	6a 00                	push   $0x0
c0108d1a:	52                   	push   %edx
c0108d1b:	e8 3c 01 00 00       	call   c0108e5c <do_fork>
c0108d20:	83 c4 10             	add    $0x10,%esp
}
c0108d23:	c9                   	leave  
c0108d24:	c3                   	ret    

c0108d25 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108d25:	55                   	push   %ebp
c0108d26:	89 e5                	mov    %esp,%ebp
c0108d28:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108d2b:	83 ec 0c             	sub    $0xc,%esp
c0108d2e:	6a 02                	push   $0x2
c0108d30:	e8 5a a8 ff ff       	call   c010358f <alloc_pages>
c0108d35:	83 c4 10             	add    $0x10,%esp
c0108d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108d3f:	74 1d                	je     c0108d5e <setup_kstack+0x39>
        proc->kstack = (uintptr_t)page2kva(page);
c0108d41:	83 ec 0c             	sub    $0xc,%esp
c0108d44:	ff 75 f4             	pushl  -0xc(%ebp)
c0108d47:	e8 53 fb ff ff       	call   c010889f <page2kva>
c0108d4c:	83 c4 10             	add    $0x10,%esp
c0108d4f:	89 c2                	mov    %eax,%edx
c0108d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d54:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108d57:	b8 00 00 00 00       	mov    $0x0,%eax
c0108d5c:	eb 05                	jmp    c0108d63 <setup_kstack+0x3e>
    }
    return -E_NO_MEM;
c0108d5e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108d63:	c9                   	leave  
c0108d64:	c3                   	ret    

c0108d65 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108d65:	55                   	push   %ebp
c0108d66:	89 e5                	mov    %esp,%ebp
c0108d68:	83 ec 08             	sub    $0x8,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d6e:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d71:	83 ec 0c             	sub    $0xc,%esp
c0108d74:	50                   	push   %eax
c0108d75:	e8 6a fb ff ff       	call   c01088e4 <kva2page>
c0108d7a:	83 c4 10             	add    $0x10,%esp
c0108d7d:	83 ec 08             	sub    $0x8,%esp
c0108d80:	6a 02                	push   $0x2
c0108d82:	50                   	push   %eax
c0108d83:	e8 73 a8 ff ff       	call   c01035fb <free_pages>
c0108d88:	83 c4 10             	add    $0x10,%esp
}
c0108d8b:	90                   	nop
c0108d8c:	c9                   	leave  
c0108d8d:	c3                   	ret    

c0108d8e <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108d8e:	55                   	push   %ebp
c0108d8f:	89 e5                	mov    %esp,%ebp
c0108d91:	83 ec 08             	sub    $0x8,%esp
    assert(current->mm == NULL);
c0108d94:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0108d99:	8b 40 18             	mov    0x18(%eax),%eax
c0108d9c:	85 c0                	test   %eax,%eax
c0108d9e:	74 19                	je     c0108db9 <copy_mm+0x2b>
c0108da0:	68 24 c0 10 c0       	push   $0xc010c024
c0108da5:	68 38 c0 10 c0       	push   $0xc010c038
c0108daa:	68 fe 00 00 00       	push   $0xfe
c0108daf:	68 4d c0 10 c0       	push   $0xc010c04d
c0108db4:	e8 2b 76 ff ff       	call   c01003e4 <__panic>
    /* do nothing in this project */
    return 0;
c0108db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108dbe:	c9                   	leave  
c0108dbf:	c3                   	ret    

c0108dc0 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108dc0:	55                   	push   %ebp
c0108dc1:	89 e5                	mov    %esp,%ebp
c0108dc3:	57                   	push   %edi
c0108dc4:	56                   	push   %esi
c0108dc5:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108dc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dc9:	8b 40 0c             	mov    0xc(%eax),%eax
c0108dcc:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108dd1:	89 c2                	mov    %eax,%edx
c0108dd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dd6:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108dd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ddc:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108ddf:	8b 55 10             	mov    0x10(%ebp),%edx
c0108de2:	89 d3                	mov    %edx,%ebx
c0108de4:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0108de9:	8b 0b                	mov    (%ebx),%ecx
c0108deb:	89 08                	mov    %ecx,(%eax)
c0108ded:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c0108df1:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0108df5:	8d 78 04             	lea    0x4(%eax),%edi
c0108df8:	83 e7 fc             	and    $0xfffffffc,%edi
c0108dfb:	29 f8                	sub    %edi,%eax
c0108dfd:	29 c3                	sub    %eax,%ebx
c0108dff:	01 c2                	add    %eax,%edx
c0108e01:	83 e2 fc             	and    $0xfffffffc,%edx
c0108e04:	89 d0                	mov    %edx,%eax
c0108e06:	c1 e8 02             	shr    $0x2,%eax
c0108e09:	89 de                	mov    %ebx,%esi
c0108e0b:	89 c1                	mov    %eax,%ecx
c0108e0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    proc->tf->tf_regs.reg_eax = 0;
c0108e0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e12:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e15:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e1f:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108e25:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108e28:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e2b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e2e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e31:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108e34:	8b 52 40             	mov    0x40(%edx),%edx
c0108e37:	80 ce 02             	or     $0x2,%dh
c0108e3a:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108e3d:	ba b9 8b 10 c0       	mov    $0xc0108bb9,%edx
c0108e42:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e45:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e4b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e4e:	89 c2                	mov    %eax,%edx
c0108e50:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e53:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108e56:	90                   	nop
c0108e57:	5b                   	pop    %ebx
c0108e58:	5e                   	pop    %esi
c0108e59:	5f                   	pop    %edi
c0108e5a:	5d                   	pop    %ebp
c0108e5b:	c3                   	ret    

c0108e5c <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108e5c:	55                   	push   %ebp
c0108e5d:	89 e5                	mov    %esp,%ebp
c0108e5f:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_NO_FREE_PROC;
c0108e62:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108e69:	a1 00 9b 12 c0       	mov    0xc0129b00,%eax
c0108e6e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108e73:	0f 8f 14 01 00 00    	jg     c0108f8d <do_fork+0x131>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0108e79:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
    proc = alloc_proc();
c0108e80:	e8 9e fa ff ff       	call   c0108923 <alloc_proc>
c0108e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (proc == NULL) {
c0108e88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108e8c:	0f 84 fe 00 00 00    	je     c0108f90 <do_fork+0x134>
    	goto fork_out;
    }
    proc->parent = current;
c0108e92:	8b 15 e8 7a 12 c0    	mov    0xc0127ae8,%edx
c0108e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e9b:	89 50 14             	mov    %edx,0x14(%eax)
    if (setup_kstack(proc) != 0) {
c0108e9e:	83 ec 0c             	sub    $0xc,%esp
c0108ea1:	ff 75 f0             	pushl  -0x10(%ebp)
c0108ea4:	e8 7c fe ff ff       	call   c0108d25 <setup_kstack>
c0108ea9:	83 c4 10             	add    $0x10,%esp
c0108eac:	85 c0                	test   %eax,%eax
c0108eae:	0f 85 f3 00 00 00    	jne    c0108fa7 <do_fork+0x14b>
    	goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0) {
c0108eb4:	83 ec 08             	sub    $0x8,%esp
c0108eb7:	ff 75 f0             	pushl  -0x10(%ebp)
c0108eba:	ff 75 08             	pushl  0x8(%ebp)
c0108ebd:	e8 cc fe ff ff       	call   c0108d8e <copy_mm>
c0108ec2:	83 c4 10             	add    $0x10,%esp
c0108ec5:	85 c0                	test   %eax,%eax
c0108ec7:	0f 85 c9 00 00 00    	jne    c0108f96 <do_fork+0x13a>
    	goto bad_fork_cleanup_kstack;
    }

    // Copy parent's trapframe
    // Also set syscall (exec/fork) return value to be 0.
    copy_thread(proc, stack, tf);
c0108ecd:	83 ec 04             	sub    $0x4,%esp
c0108ed0:	ff 75 10             	pushl  0x10(%ebp)
c0108ed3:	ff 75 0c             	pushl  0xc(%ebp)
c0108ed6:	ff 75 f0             	pushl  -0x10(%ebp)
c0108ed9:	e8 e2 fe ff ff       	call   c0108dc0 <copy_thread>
c0108ede:	83 c4 10             	add    $0x10,%esp

    bool intr_flag;
    local_intr_save(intr_flag);
c0108ee1:	e8 18 f9 ff ff       	call   c01087fe <__intr_save>
c0108ee6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        proc->pid = get_pid();
c0108ee9:	e8 55 fb ff ff       	call   c0108a43 <get_pid>
c0108eee:	89 c2                	mov    %eax,%edx
c0108ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ef3:	89 50 04             	mov    %edx,0x4(%eax)
        hash_proc(proc);
c0108ef6:	83 ec 0c             	sub    $0xc,%esp
c0108ef9:	ff 75 f0             	pushl  -0x10(%ebp)
c0108efc:	e8 d5 fc ff ff       	call   c0108bd6 <hash_proc>
c0108f01:	83 c4 10             	add    $0x10,%esp
        list_add(&proc_list, &(proc->list_link));
c0108f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f07:	83 c0 58             	add    $0x58,%eax
c0108f0a:	c7 45 e8 24 9c 12 c0 	movl   $0xc0129c24,-0x18(%ebp)
c0108f11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f17:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108f1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108f23:	8b 40 04             	mov    0x4(%eax),%eax
c0108f26:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108f29:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108f2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108f2f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108f32:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108f35:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108f38:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108f3b:	89 10                	mov    %edx,(%eax)
c0108f3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108f40:	8b 10                	mov    (%eax),%edx
c0108f42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108f45:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108f48:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108f4b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108f4e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108f51:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108f54:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108f57:	89 10                	mov    %edx,(%eax)
        nr_process ++;
c0108f59:	a1 00 9b 12 c0       	mov    0xc0129b00,%eax
c0108f5e:	83 c0 01             	add    $0x1,%eax
c0108f61:	a3 00 9b 12 c0       	mov    %eax,0xc0129b00
    }
    local_intr_restore(intr_flag);
c0108f66:	83 ec 0c             	sub    $0xc,%esp
c0108f69:	ff 75 ec             	pushl  -0x14(%ebp)
c0108f6c:	e8 b7 f8 ff ff       	call   c0108828 <__intr_restore>
c0108f71:	83 c4 10             	add    $0x10,%esp

    wakeup_proc(proc);
c0108f74:	83 ec 0c             	sub    $0xc,%esp
c0108f77:	ff 75 f0             	pushl  -0x10(%ebp)
c0108f7a:	e8 ac 02 00 00       	call   c010922b <wakeup_proc>
c0108f7f:	83 c4 10             	add    $0x10,%esp

    ret = proc->pid;
c0108f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f85:	8b 40 04             	mov    0x4(%eax),%eax
c0108f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108f8b:	eb 04                	jmp    c0108f91 <do_fork+0x135>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
c0108f8d:	90                   	nop
c0108f8e:	eb 01                	jmp    c0108f91 <do_fork+0x135>
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
    proc = alloc_proc();
    if (proc == NULL) {
    	goto fork_out;
c0108f90:	90                   	nop

    wakeup_proc(proc);

    ret = proc->pid;
fork_out:
    return ret;
c0108f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f94:	eb 22                	jmp    c0108fb8 <do_fork+0x15c>
    proc->parent = current;
    if (setup_kstack(proc) != 0) {
    	goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0) {
    	goto bad_fork_cleanup_kstack;
c0108f96:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108f97:	83 ec 0c             	sub    $0xc,%esp
c0108f9a:	ff 75 f0             	pushl  -0x10(%ebp)
c0108f9d:	e8 c3 fd ff ff       	call   c0108d65 <put_kstack>
c0108fa2:	83 c4 10             	add    $0x10,%esp
c0108fa5:	eb 01                	jmp    c0108fa8 <do_fork+0x14c>
    if (proc == NULL) {
    	goto fork_out;
    }
    proc->parent = current;
    if (setup_kstack(proc) != 0) {
    	goto bad_fork_cleanup_proc;
c0108fa7:	90                   	nop
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108fa8:	83 ec 0c             	sub    $0xc,%esp
c0108fab:	ff 75 f0             	pushl  -0x10(%ebp)
c0108fae:	e8 f4 d9 ff ff       	call   c01069a7 <kfree>
c0108fb3:	83 c4 10             	add    $0x10,%esp
    goto fork_out;
c0108fb6:	eb d9                	jmp    c0108f91 <do_fork+0x135>
}
c0108fb8:	c9                   	leave  
c0108fb9:	c3                   	ret    

c0108fba <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108fba:	55                   	push   %ebp
c0108fbb:	89 e5                	mov    %esp,%ebp
c0108fbd:	83 ec 08             	sub    $0x8,%esp
    panic("process exit!!.\n");
c0108fc0:	83 ec 04             	sub    $0x4,%esp
c0108fc3:	68 61 c0 10 c0       	push   $0xc010c061
c0108fc8:	68 64 01 00 00       	push   $0x164
c0108fcd:	68 4d c0 10 c0       	push   $0xc010c04d
c0108fd2:	e8 0d 74 ff ff       	call   c01003e4 <__panic>

c0108fd7 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108fd7:	55                   	push   %ebp
c0108fd8:	89 e5                	mov    %esp,%ebp
c0108fda:	83 ec 08             	sub    $0x8,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108fdd:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0108fe2:	83 ec 0c             	sub    $0xc,%esp
c0108fe5:	50                   	push   %eax
c0108fe6:	e8 23 fa ff ff       	call   c0108a0e <get_proc_name>
c0108feb:	83 c4 10             	add    $0x10,%esp
c0108fee:	89 c2                	mov    %eax,%edx
c0108ff0:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0108ff5:	8b 40 04             	mov    0x4(%eax),%eax
c0108ff8:	83 ec 04             	sub    $0x4,%esp
c0108ffb:	52                   	push   %edx
c0108ffc:	50                   	push   %eax
c0108ffd:	68 74 c0 10 c0       	push   $0xc010c074
c0109002:	e8 77 72 ff ff       	call   c010027e <cprintf>
c0109007:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"%s\".\n", (const char *)arg);
c010900a:	83 ec 08             	sub    $0x8,%esp
c010900d:	ff 75 08             	pushl  0x8(%ebp)
c0109010:	68 9a c0 10 c0       	push   $0xc010c09a
c0109015:	e8 64 72 ff ff       	call   c010027e <cprintf>
c010901a:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c010901d:	83 ec 0c             	sub    $0xc,%esp
c0109020:	68 a7 c0 10 c0       	push   $0xc010c0a7
c0109025:	e8 54 72 ff ff       	call   c010027e <cprintf>
c010902a:	83 c4 10             	add    $0x10,%esp
    return 0;
c010902d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109032:	c9                   	leave  
c0109033:	c3                   	ret    

c0109034 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0109034:	55                   	push   %ebp
c0109035:	89 e5                	mov    %esp,%ebp
c0109037:	83 ec 18             	sub    $0x18,%esp
c010903a:	c7 45 e8 24 9c 12 c0 	movl   $0xc0129c24,-0x18(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0109041:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109044:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109047:	89 50 04             	mov    %edx,0x4(%eax)
c010904a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010904d:	8b 50 04             	mov    0x4(%eax),%edx
c0109050:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109053:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010905c:	eb 26                	jmp    c0109084 <proc_init+0x50>
        list_init(hash_list + i);
c010905e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109061:	c1 e0 03             	shl    $0x3,%eax
c0109064:	05 00 7b 12 c0       	add    $0xc0127b00,%eax
c0109069:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010906c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010906f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109072:	89 50 04             	mov    %edx,0x4(%eax)
c0109075:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109078:	8b 50 04             	mov    0x4(%eax),%edx
c010907b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010907e:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109080:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0109084:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010908b:	7e d1                	jle    c010905e <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010908d:	e8 91 f8 ff ff       	call   c0108923 <alloc_proc>
c0109092:	a3 e0 7a 12 c0       	mov    %eax,0xc0127ae0
c0109097:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c010909c:	85 c0                	test   %eax,%eax
c010909e:	75 17                	jne    c01090b7 <proc_init+0x83>
        panic("cannot alloc idleproc.\n");
c01090a0:	83 ec 04             	sub    $0x4,%esp
c01090a3:	68 c3 c0 10 c0       	push   $0xc010c0c3
c01090a8:	68 7c 01 00 00       	push   $0x17c
c01090ad:	68 4d c0 10 c0       	push   $0xc010c04d
c01090b2:	e8 2d 73 ff ff       	call   c01003e4 <__panic>
    }

    idleproc->pid = 0;
c01090b7:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c01090bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c01090c3:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c01090c8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c01090ce:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c01090d3:	ba 00 40 12 c0       	mov    $0xc0124000,%edx
c01090d8:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c01090db:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c01090e0:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c01090e7:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c01090ec:	83 ec 08             	sub    $0x8,%esp
c01090ef:	68 db c0 10 c0       	push   $0xc010c0db
c01090f4:	50                   	push   %eax
c01090f5:	e8 df f8 ff ff       	call   c01089d9 <set_proc_name>
c01090fa:	83 c4 10             	add    $0x10,%esp
    nr_process ++;
c01090fd:	a1 00 9b 12 c0       	mov    0xc0129b00,%eax
c0109102:	83 c0 01             	add    $0x1,%eax
c0109105:	a3 00 9b 12 c0       	mov    %eax,0xc0129b00

    current = idleproc;
c010910a:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c010910f:	a3 e8 7a 12 c0       	mov    %eax,0xc0127ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0109114:	83 ec 04             	sub    $0x4,%esp
c0109117:	6a 00                	push   $0x0
c0109119:	68 e0 c0 10 c0       	push   $0xc010c0e0
c010911e:	68 d7 8f 10 c0       	push   $0xc0108fd7
c0109123:	e8 98 fb ff ff       	call   c0108cc0 <kernel_thread>
c0109128:	83 c4 10             	add    $0x10,%esp
c010912b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010912e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109132:	7f 17                	jg     c010914b <proc_init+0x117>
        panic("create init_main failed.\n");
c0109134:	83 ec 04             	sub    $0x4,%esp
c0109137:	68 ee c0 10 c0       	push   $0xc010c0ee
c010913c:	68 8a 01 00 00       	push   $0x18a
c0109141:	68 4d c0 10 c0       	push   $0xc010c04d
c0109146:	e8 99 72 ff ff       	call   c01003e4 <__panic>
    }

    initproc = find_proc(pid);
c010914b:	83 ec 0c             	sub    $0xc,%esp
c010914e:	ff 75 ec             	pushl  -0x14(%ebp)
c0109151:	e8 fa fa ff ff       	call   c0108c50 <find_proc>
c0109156:	83 c4 10             	add    $0x10,%esp
c0109159:	a3 e4 7a 12 c0       	mov    %eax,0xc0127ae4
    set_proc_name(initproc, "init");
c010915e:	a1 e4 7a 12 c0       	mov    0xc0127ae4,%eax
c0109163:	83 ec 08             	sub    $0x8,%esp
c0109166:	68 08 c1 10 c0       	push   $0xc010c108
c010916b:	50                   	push   %eax
c010916c:	e8 68 f8 ff ff       	call   c01089d9 <set_proc_name>
c0109171:	83 c4 10             	add    $0x10,%esp

    assert(idleproc != NULL && idleproc->pid == 0);
c0109174:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c0109179:	85 c0                	test   %eax,%eax
c010917b:	74 0c                	je     c0109189 <proc_init+0x155>
c010917d:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c0109182:	8b 40 04             	mov    0x4(%eax),%eax
c0109185:	85 c0                	test   %eax,%eax
c0109187:	74 19                	je     c01091a2 <proc_init+0x16e>
c0109189:	68 10 c1 10 c0       	push   $0xc010c110
c010918e:	68 38 c0 10 c0       	push   $0xc010c038
c0109193:	68 90 01 00 00       	push   $0x190
c0109198:	68 4d c0 10 c0       	push   $0xc010c04d
c010919d:	e8 42 72 ff ff       	call   c01003e4 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c01091a2:	a1 e4 7a 12 c0       	mov    0xc0127ae4,%eax
c01091a7:	85 c0                	test   %eax,%eax
c01091a9:	74 0d                	je     c01091b8 <proc_init+0x184>
c01091ab:	a1 e4 7a 12 c0       	mov    0xc0127ae4,%eax
c01091b0:	8b 40 04             	mov    0x4(%eax),%eax
c01091b3:	83 f8 01             	cmp    $0x1,%eax
c01091b6:	74 19                	je     c01091d1 <proc_init+0x19d>
c01091b8:	68 38 c1 10 c0       	push   $0xc010c138
c01091bd:	68 38 c0 10 c0       	push   $0xc010c038
c01091c2:	68 91 01 00 00       	push   $0x191
c01091c7:	68 4d c0 10 c0       	push   $0xc010c04d
c01091cc:	e8 13 72 ff ff       	call   c01003e4 <__panic>
}
c01091d1:	90                   	nop
c01091d2:	c9                   	leave  
c01091d3:	c3                   	ret    

c01091d4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c01091d4:	55                   	push   %ebp
c01091d5:	89 e5                	mov    %esp,%ebp
c01091d7:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c01091da:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c01091df:	8b 40 10             	mov    0x10(%eax),%eax
c01091e2:	85 c0                	test   %eax,%eax
c01091e4:	74 f4                	je     c01091da <cpu_idle+0x6>
            schedule();
c01091e6:	e8 7c 00 00 00       	call   c0109267 <schedule>
        }
    }
c01091eb:	eb ed                	jmp    c01091da <cpu_idle+0x6>

c01091ed <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01091ed:	55                   	push   %ebp
c01091ee:	89 e5                	mov    %esp,%ebp
c01091f0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01091f3:	9c                   	pushf  
c01091f4:	58                   	pop    %eax
c01091f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01091f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01091fb:	25 00 02 00 00       	and    $0x200,%eax
c0109200:	85 c0                	test   %eax,%eax
c0109202:	74 0c                	je     c0109210 <__intr_save+0x23>
        intr_disable();
c0109204:	e8 a1 8e ff ff       	call   c01020aa <intr_disable>
        return 1;
c0109209:	b8 01 00 00 00       	mov    $0x1,%eax
c010920e:	eb 05                	jmp    c0109215 <__intr_save+0x28>
    }
    return 0;
c0109210:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109215:	c9                   	leave  
c0109216:	c3                   	ret    

c0109217 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0109217:	55                   	push   %ebp
c0109218:	89 e5                	mov    %esp,%ebp
c010921a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010921d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109221:	74 05                	je     c0109228 <__intr_restore+0x11>
        intr_enable();
c0109223:	e8 7b 8e ff ff       	call   c01020a3 <intr_enable>
    }
}
c0109228:	90                   	nop
c0109229:	c9                   	leave  
c010922a:	c3                   	ret    

c010922b <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010922b:	55                   	push   %ebp
c010922c:	89 e5                	mov    %esp,%ebp
c010922e:	83 ec 08             	sub    $0x8,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0109231:	8b 45 08             	mov    0x8(%ebp),%eax
c0109234:	8b 00                	mov    (%eax),%eax
c0109236:	83 f8 03             	cmp    $0x3,%eax
c0109239:	74 0a                	je     c0109245 <wakeup_proc+0x1a>
c010923b:	8b 45 08             	mov    0x8(%ebp),%eax
c010923e:	8b 00                	mov    (%eax),%eax
c0109240:	83 f8 02             	cmp    $0x2,%eax
c0109243:	75 16                	jne    c010925b <wakeup_proc+0x30>
c0109245:	68 60 c1 10 c0       	push   $0xc010c160
c010924a:	68 9b c1 10 c0       	push   $0xc010c19b
c010924f:	6a 09                	push   $0x9
c0109251:	68 b0 c1 10 c0       	push   $0xc010c1b0
c0109256:	e8 89 71 ff ff       	call   c01003e4 <__panic>
    proc->state = PROC_RUNNABLE;
c010925b:	8b 45 08             	mov    0x8(%ebp),%eax
c010925e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0109264:	90                   	nop
c0109265:	c9                   	leave  
c0109266:	c3                   	ret    

c0109267 <schedule>:

void
schedule(void) {
c0109267:	55                   	push   %ebp
c0109268:	89 e5                	mov    %esp,%ebp
c010926a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010926d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0109274:	e8 74 ff ff ff       	call   c01091ed <__intr_save>
c0109279:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010927c:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0109281:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0109288:	8b 15 e8 7a 12 c0    	mov    0xc0127ae8,%edx
c010928e:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c0109293:	39 c2                	cmp    %eax,%edx
c0109295:	74 0a                	je     c01092a1 <schedule+0x3a>
c0109297:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c010929c:	83 c0 58             	add    $0x58,%eax
c010929f:	eb 05                	jmp    c01092a6 <schedule+0x3f>
c01092a1:	b8 24 9c 12 c0       	mov    $0xc0129c24,%eax
c01092a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c01092a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01092b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092b8:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c01092bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092be:	81 7d f4 24 9c 12 c0 	cmpl   $0xc0129c24,-0xc(%ebp)
c01092c5:	74 13                	je     c01092da <schedule+0x73>
                next = le2proc(le, list_link);
c01092c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092ca:	83 e8 58             	sub    $0x58,%eax
c01092cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c01092d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01092d3:	8b 00                	mov    (%eax),%eax
c01092d5:	83 f8 02             	cmp    $0x2,%eax
c01092d8:	74 0a                	je     c01092e4 <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c01092da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092dd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01092e0:	75 cd                	jne    c01092af <schedule+0x48>
c01092e2:	eb 01                	jmp    c01092e5 <schedule+0x7e>
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
c01092e4:	90                   	nop
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
c01092e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01092e9:	74 0a                	je     c01092f5 <schedule+0x8e>
c01092eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01092ee:	8b 00                	mov    (%eax),%eax
c01092f0:	83 f8 02             	cmp    $0x2,%eax
c01092f3:	74 08                	je     c01092fd <schedule+0x96>
            next = idleproc;
c01092f5:	a1 e0 7a 12 c0       	mov    0xc0127ae0,%eax
c01092fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c01092fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109300:	8b 40 08             	mov    0x8(%eax),%eax
c0109303:	8d 50 01             	lea    0x1(%eax),%edx
c0109306:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109309:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010930c:	a1 e8 7a 12 c0       	mov    0xc0127ae8,%eax
c0109311:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109314:	74 0e                	je     c0109324 <schedule+0xbd>
            proc_run(next);
c0109316:	83 ec 0c             	sub    $0xc,%esp
c0109319:	ff 75 f0             	pushl  -0x10(%ebp)
c010931c:	e8 1a f8 ff ff       	call   c0108b3b <proc_run>
c0109321:	83 c4 10             	add    $0x10,%esp
        }
    }
    local_intr_restore(intr_flag);
c0109324:	83 ec 0c             	sub    $0xc,%esp
c0109327:	ff 75 ec             	pushl  -0x14(%ebp)
c010932a:	e8 e8 fe ff ff       	call   c0109217 <__intr_restore>
c010932f:	83 c4 10             	add    $0x10,%esp
}
c0109332:	90                   	nop
c0109333:	c9                   	leave  
c0109334:	c3                   	ret    

c0109335 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109335:	55                   	push   %ebp
c0109336:	89 e5                	mov    %esp,%ebp
c0109338:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010933b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109342:	eb 04                	jmp    c0109348 <strlen+0x13>
        cnt ++;
c0109344:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109348:	8b 45 08             	mov    0x8(%ebp),%eax
c010934b:	8d 50 01             	lea    0x1(%eax),%edx
c010934e:	89 55 08             	mov    %edx,0x8(%ebp)
c0109351:	0f b6 00             	movzbl (%eax),%eax
c0109354:	84 c0                	test   %al,%al
c0109356:	75 ec                	jne    c0109344 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010935b:	c9                   	leave  
c010935c:	c3                   	ret    

c010935d <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010935d:	55                   	push   %ebp
c010935e:	89 e5                	mov    %esp,%ebp
c0109360:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010936a:	eb 04                	jmp    c0109370 <strnlen+0x13>
        cnt ++;
c010936c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0109370:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109373:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109376:	73 10                	jae    c0109388 <strnlen+0x2b>
c0109378:	8b 45 08             	mov    0x8(%ebp),%eax
c010937b:	8d 50 01             	lea    0x1(%eax),%edx
c010937e:	89 55 08             	mov    %edx,0x8(%ebp)
c0109381:	0f b6 00             	movzbl (%eax),%eax
c0109384:	84 c0                	test   %al,%al
c0109386:	75 e4                	jne    c010936c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010938b:	c9                   	leave  
c010938c:	c3                   	ret    

c010938d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010938d:	55                   	push   %ebp
c010938e:	89 e5                	mov    %esp,%ebp
c0109390:	57                   	push   %edi
c0109391:	56                   	push   %esi
c0109392:	83 ec 20             	sub    $0x20,%esp
c0109395:	8b 45 08             	mov    0x8(%ebp),%eax
c0109398:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010939b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010939e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01093a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01093a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093a7:	89 d1                	mov    %edx,%ecx
c01093a9:	89 c2                	mov    %eax,%edx
c01093ab:	89 ce                	mov    %ecx,%esi
c01093ad:	89 d7                	mov    %edx,%edi
c01093af:	ac                   	lods   %ds:(%esi),%al
c01093b0:	aa                   	stos   %al,%es:(%edi)
c01093b1:	84 c0                	test   %al,%al
c01093b3:	75 fa                	jne    c01093af <strcpy+0x22>
c01093b5:	89 fa                	mov    %edi,%edx
c01093b7:	89 f1                	mov    %esi,%ecx
c01093b9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01093bc:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01093bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01093c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01093c5:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01093c6:	83 c4 20             	add    $0x20,%esp
c01093c9:	5e                   	pop    %esi
c01093ca:	5f                   	pop    %edi
c01093cb:	5d                   	pop    %ebp
c01093cc:	c3                   	ret    

c01093cd <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01093cd:	55                   	push   %ebp
c01093ce:	89 e5                	mov    %esp,%ebp
c01093d0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01093d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01093d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01093d9:	eb 21                	jmp    c01093fc <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01093db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093de:	0f b6 10             	movzbl (%eax),%edx
c01093e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01093e4:	88 10                	mov    %dl,(%eax)
c01093e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01093e9:	0f b6 00             	movzbl (%eax),%eax
c01093ec:	84 c0                	test   %al,%al
c01093ee:	74 04                	je     c01093f4 <strncpy+0x27>
            src ++;
c01093f0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01093f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01093f8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01093fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109400:	75 d9                	jne    c01093db <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109402:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109405:	c9                   	leave  
c0109406:	c3                   	ret    

c0109407 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109407:	55                   	push   %ebp
c0109408:	89 e5                	mov    %esp,%ebp
c010940a:	57                   	push   %edi
c010940b:	56                   	push   %esi
c010940c:	83 ec 20             	sub    $0x20,%esp
c010940f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109412:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109415:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109418:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010941b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010941e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109421:	89 d1                	mov    %edx,%ecx
c0109423:	89 c2                	mov    %eax,%edx
c0109425:	89 ce                	mov    %ecx,%esi
c0109427:	89 d7                	mov    %edx,%edi
c0109429:	ac                   	lods   %ds:(%esi),%al
c010942a:	ae                   	scas   %es:(%edi),%al
c010942b:	75 08                	jne    c0109435 <strcmp+0x2e>
c010942d:	84 c0                	test   %al,%al
c010942f:	75 f8                	jne    c0109429 <strcmp+0x22>
c0109431:	31 c0                	xor    %eax,%eax
c0109433:	eb 04                	jmp    c0109439 <strcmp+0x32>
c0109435:	19 c0                	sbb    %eax,%eax
c0109437:	0c 01                	or     $0x1,%al
c0109439:	89 fa                	mov    %edi,%edx
c010943b:	89 f1                	mov    %esi,%ecx
c010943d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109440:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109443:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109446:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0109449:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010944a:	83 c4 20             	add    $0x20,%esp
c010944d:	5e                   	pop    %esi
c010944e:	5f                   	pop    %edi
c010944f:	5d                   	pop    %ebp
c0109450:	c3                   	ret    

c0109451 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0109451:	55                   	push   %ebp
c0109452:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109454:	eb 0c                	jmp    c0109462 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109456:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010945a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010945e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109462:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109466:	74 1a                	je     c0109482 <strncmp+0x31>
c0109468:	8b 45 08             	mov    0x8(%ebp),%eax
c010946b:	0f b6 00             	movzbl (%eax),%eax
c010946e:	84 c0                	test   %al,%al
c0109470:	74 10                	je     c0109482 <strncmp+0x31>
c0109472:	8b 45 08             	mov    0x8(%ebp),%eax
c0109475:	0f b6 10             	movzbl (%eax),%edx
c0109478:	8b 45 0c             	mov    0xc(%ebp),%eax
c010947b:	0f b6 00             	movzbl (%eax),%eax
c010947e:	38 c2                	cmp    %al,%dl
c0109480:	74 d4                	je     c0109456 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109486:	74 18                	je     c01094a0 <strncmp+0x4f>
c0109488:	8b 45 08             	mov    0x8(%ebp),%eax
c010948b:	0f b6 00             	movzbl (%eax),%eax
c010948e:	0f b6 d0             	movzbl %al,%edx
c0109491:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109494:	0f b6 00             	movzbl (%eax),%eax
c0109497:	0f b6 c0             	movzbl %al,%eax
c010949a:	29 c2                	sub    %eax,%edx
c010949c:	89 d0                	mov    %edx,%eax
c010949e:	eb 05                	jmp    c01094a5 <strncmp+0x54>
c01094a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01094a5:	5d                   	pop    %ebp
c01094a6:	c3                   	ret    

c01094a7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01094a7:	55                   	push   %ebp
c01094a8:	89 e5                	mov    %esp,%ebp
c01094aa:	83 ec 04             	sub    $0x4,%esp
c01094ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094b0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01094b3:	eb 14                	jmp    c01094c9 <strchr+0x22>
        if (*s == c) {
c01094b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01094b8:	0f b6 00             	movzbl (%eax),%eax
c01094bb:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01094be:	75 05                	jne    c01094c5 <strchr+0x1e>
            return (char *)s;
c01094c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c3:	eb 13                	jmp    c01094d8 <strchr+0x31>
        }
        s ++;
c01094c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01094c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01094cc:	0f b6 00             	movzbl (%eax),%eax
c01094cf:	84 c0                	test   %al,%al
c01094d1:	75 e2                	jne    c01094b5 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01094d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01094d8:	c9                   	leave  
c01094d9:	c3                   	ret    

c01094da <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01094da:	55                   	push   %ebp
c01094db:	89 e5                	mov    %esp,%ebp
c01094dd:	83 ec 04             	sub    $0x4,%esp
c01094e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094e3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01094e6:	eb 0f                	jmp    c01094f7 <strfind+0x1d>
        if (*s == c) {
c01094e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01094eb:	0f b6 00             	movzbl (%eax),%eax
c01094ee:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01094f1:	74 10                	je     c0109503 <strfind+0x29>
            break;
        }
        s ++;
c01094f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01094f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01094fa:	0f b6 00             	movzbl (%eax),%eax
c01094fd:	84 c0                	test   %al,%al
c01094ff:	75 e7                	jne    c01094e8 <strfind+0xe>
c0109501:	eb 01                	jmp    c0109504 <strfind+0x2a>
        if (*s == c) {
            break;
c0109503:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0109504:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109507:	c9                   	leave  
c0109508:	c3                   	ret    

c0109509 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109509:	55                   	push   %ebp
c010950a:	89 e5                	mov    %esp,%ebp
c010950c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010950f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109516:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010951d:	eb 04                	jmp    c0109523 <strtol+0x1a>
        s ++;
c010951f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109523:	8b 45 08             	mov    0x8(%ebp),%eax
c0109526:	0f b6 00             	movzbl (%eax),%eax
c0109529:	3c 20                	cmp    $0x20,%al
c010952b:	74 f2                	je     c010951f <strtol+0x16>
c010952d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109530:	0f b6 00             	movzbl (%eax),%eax
c0109533:	3c 09                	cmp    $0x9,%al
c0109535:	74 e8                	je     c010951f <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109537:	8b 45 08             	mov    0x8(%ebp),%eax
c010953a:	0f b6 00             	movzbl (%eax),%eax
c010953d:	3c 2b                	cmp    $0x2b,%al
c010953f:	75 06                	jne    c0109547 <strtol+0x3e>
        s ++;
c0109541:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109545:	eb 15                	jmp    c010955c <strtol+0x53>
    }
    else if (*s == '-') {
c0109547:	8b 45 08             	mov    0x8(%ebp),%eax
c010954a:	0f b6 00             	movzbl (%eax),%eax
c010954d:	3c 2d                	cmp    $0x2d,%al
c010954f:	75 0b                	jne    c010955c <strtol+0x53>
        s ++, neg = 1;
c0109551:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109555:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010955c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109560:	74 06                	je     c0109568 <strtol+0x5f>
c0109562:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109566:	75 24                	jne    c010958c <strtol+0x83>
c0109568:	8b 45 08             	mov    0x8(%ebp),%eax
c010956b:	0f b6 00             	movzbl (%eax),%eax
c010956e:	3c 30                	cmp    $0x30,%al
c0109570:	75 1a                	jne    c010958c <strtol+0x83>
c0109572:	8b 45 08             	mov    0x8(%ebp),%eax
c0109575:	83 c0 01             	add    $0x1,%eax
c0109578:	0f b6 00             	movzbl (%eax),%eax
c010957b:	3c 78                	cmp    $0x78,%al
c010957d:	75 0d                	jne    c010958c <strtol+0x83>
        s += 2, base = 16;
c010957f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109583:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010958a:	eb 2a                	jmp    c01095b6 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010958c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109590:	75 17                	jne    c01095a9 <strtol+0xa0>
c0109592:	8b 45 08             	mov    0x8(%ebp),%eax
c0109595:	0f b6 00             	movzbl (%eax),%eax
c0109598:	3c 30                	cmp    $0x30,%al
c010959a:	75 0d                	jne    c01095a9 <strtol+0xa0>
        s ++, base = 8;
c010959c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01095a0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01095a7:	eb 0d                	jmp    c01095b6 <strtol+0xad>
    }
    else if (base == 0) {
c01095a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01095ad:	75 07                	jne    c01095b6 <strtol+0xad>
        base = 10;
c01095af:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01095b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b9:	0f b6 00             	movzbl (%eax),%eax
c01095bc:	3c 2f                	cmp    $0x2f,%al
c01095be:	7e 1b                	jle    c01095db <strtol+0xd2>
c01095c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c3:	0f b6 00             	movzbl (%eax),%eax
c01095c6:	3c 39                	cmp    $0x39,%al
c01095c8:	7f 11                	jg     c01095db <strtol+0xd2>
            dig = *s - '0';
c01095ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01095cd:	0f b6 00             	movzbl (%eax),%eax
c01095d0:	0f be c0             	movsbl %al,%eax
c01095d3:	83 e8 30             	sub    $0x30,%eax
c01095d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01095d9:	eb 48                	jmp    c0109623 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01095db:	8b 45 08             	mov    0x8(%ebp),%eax
c01095de:	0f b6 00             	movzbl (%eax),%eax
c01095e1:	3c 60                	cmp    $0x60,%al
c01095e3:	7e 1b                	jle    c0109600 <strtol+0xf7>
c01095e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e8:	0f b6 00             	movzbl (%eax),%eax
c01095eb:	3c 7a                	cmp    $0x7a,%al
c01095ed:	7f 11                	jg     c0109600 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01095ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f2:	0f b6 00             	movzbl (%eax),%eax
c01095f5:	0f be c0             	movsbl %al,%eax
c01095f8:	83 e8 57             	sub    $0x57,%eax
c01095fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01095fe:	eb 23                	jmp    c0109623 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109600:	8b 45 08             	mov    0x8(%ebp),%eax
c0109603:	0f b6 00             	movzbl (%eax),%eax
c0109606:	3c 40                	cmp    $0x40,%al
c0109608:	7e 3c                	jle    c0109646 <strtol+0x13d>
c010960a:	8b 45 08             	mov    0x8(%ebp),%eax
c010960d:	0f b6 00             	movzbl (%eax),%eax
c0109610:	3c 5a                	cmp    $0x5a,%al
c0109612:	7f 32                	jg     c0109646 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0109614:	8b 45 08             	mov    0x8(%ebp),%eax
c0109617:	0f b6 00             	movzbl (%eax),%eax
c010961a:	0f be c0             	movsbl %al,%eax
c010961d:	83 e8 37             	sub    $0x37,%eax
c0109620:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109626:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109629:	7d 1a                	jge    c0109645 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010962b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010962f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109632:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109636:	89 c2                	mov    %eax,%edx
c0109638:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010963b:	01 d0                	add    %edx,%eax
c010963d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109640:	e9 71 ff ff ff       	jmp    c01095b6 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0109645:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109646:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010964a:	74 08                	je     c0109654 <strtol+0x14b>
        *endptr = (char *) s;
c010964c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010964f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109652:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109654:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109658:	74 07                	je     c0109661 <strtol+0x158>
c010965a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010965d:	f7 d8                	neg    %eax
c010965f:	eb 03                	jmp    c0109664 <strtol+0x15b>
c0109661:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109664:	c9                   	leave  
c0109665:	c3                   	ret    

c0109666 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109666:	55                   	push   %ebp
c0109667:	89 e5                	mov    %esp,%ebp
c0109669:	57                   	push   %edi
c010966a:	83 ec 24             	sub    $0x24,%esp
c010966d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109670:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109673:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109677:	8b 55 08             	mov    0x8(%ebp),%edx
c010967a:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010967d:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109680:	8b 45 10             	mov    0x10(%ebp),%eax
c0109683:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109686:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109689:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010968d:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109690:	89 d7                	mov    %edx,%edi
c0109692:	f3 aa                	rep stos %al,%es:(%edi)
c0109694:	89 fa                	mov    %edi,%edx
c0109696:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109699:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010969c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010969f:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01096a0:	83 c4 24             	add    $0x24,%esp
c01096a3:	5f                   	pop    %edi
c01096a4:	5d                   	pop    %ebp
c01096a5:	c3                   	ret    

c01096a6 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01096a6:	55                   	push   %ebp
c01096a7:	89 e5                	mov    %esp,%ebp
c01096a9:	57                   	push   %edi
c01096aa:	56                   	push   %esi
c01096ab:	53                   	push   %ebx
c01096ac:	83 ec 30             	sub    $0x30,%esp
c01096af:	8b 45 08             	mov    0x8(%ebp),%eax
c01096b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01096bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01096be:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01096c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01096c7:	73 42                	jae    c010970b <memmove+0x65>
c01096c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01096cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01096d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01096d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01096db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01096de:	c1 e8 02             	shr    $0x2,%eax
c01096e1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01096e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01096e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01096e9:	89 d7                	mov    %edx,%edi
c01096eb:	89 c6                	mov    %eax,%esi
c01096ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01096ef:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01096f2:	83 e1 03             	and    $0x3,%ecx
c01096f5:	74 02                	je     c01096f9 <memmove+0x53>
c01096f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01096f9:	89 f0                	mov    %esi,%eax
c01096fb:	89 fa                	mov    %edi,%edx
c01096fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109700:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109703:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0109709:	eb 36                	jmp    c0109741 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010970b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010970e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109714:	01 c2                	add    %eax,%edx
c0109716:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109719:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010971c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010971f:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109722:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109725:	89 c1                	mov    %eax,%ecx
c0109727:	89 d8                	mov    %ebx,%eax
c0109729:	89 d6                	mov    %edx,%esi
c010972b:	89 c7                	mov    %eax,%edi
c010972d:	fd                   	std    
c010972e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109730:	fc                   	cld    
c0109731:	89 f8                	mov    %edi,%eax
c0109733:	89 f2                	mov    %esi,%edx
c0109735:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109738:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010973b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010973e:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109741:	83 c4 30             	add    $0x30,%esp
c0109744:	5b                   	pop    %ebx
c0109745:	5e                   	pop    %esi
c0109746:	5f                   	pop    %edi
c0109747:	5d                   	pop    %ebp
c0109748:	c3                   	ret    

c0109749 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109749:	55                   	push   %ebp
c010974a:	89 e5                	mov    %esp,%ebp
c010974c:	57                   	push   %edi
c010974d:	56                   	push   %esi
c010974e:	83 ec 20             	sub    $0x20,%esp
c0109751:	8b 45 08             	mov    0x8(%ebp),%eax
c0109754:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109757:	8b 45 0c             	mov    0xc(%ebp),%eax
c010975a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010975d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109760:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109763:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109766:	c1 e8 02             	shr    $0x2,%eax
c0109769:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010976b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010976e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109771:	89 d7                	mov    %edx,%edi
c0109773:	89 c6                	mov    %eax,%esi
c0109775:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109777:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010977a:	83 e1 03             	and    $0x3,%ecx
c010977d:	74 02                	je     c0109781 <memcpy+0x38>
c010977f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109781:	89 f0                	mov    %esi,%eax
c0109783:	89 fa                	mov    %edi,%edx
c0109785:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109788:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010978b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010978e:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0109791:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109792:	83 c4 20             	add    $0x20,%esp
c0109795:	5e                   	pop    %esi
c0109796:	5f                   	pop    %edi
c0109797:	5d                   	pop    %ebp
c0109798:	c3                   	ret    

c0109799 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109799:	55                   	push   %ebp
c010979a:	89 e5                	mov    %esp,%ebp
c010979c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010979f:	8b 45 08             	mov    0x8(%ebp),%eax
c01097a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01097a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01097ab:	eb 30                	jmp    c01097dd <memcmp+0x44>
        if (*s1 != *s2) {
c01097ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01097b0:	0f b6 10             	movzbl (%eax),%edx
c01097b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01097b6:	0f b6 00             	movzbl (%eax),%eax
c01097b9:	38 c2                	cmp    %al,%dl
c01097bb:	74 18                	je     c01097d5 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01097bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01097c0:	0f b6 00             	movzbl (%eax),%eax
c01097c3:	0f b6 d0             	movzbl %al,%edx
c01097c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01097c9:	0f b6 00             	movzbl (%eax),%eax
c01097cc:	0f b6 c0             	movzbl %al,%eax
c01097cf:	29 c2                	sub    %eax,%edx
c01097d1:	89 d0                	mov    %edx,%eax
c01097d3:	eb 1a                	jmp    c01097ef <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01097d5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01097d9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01097dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01097e0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01097e3:	89 55 10             	mov    %edx,0x10(%ebp)
c01097e6:	85 c0                	test   %eax,%eax
c01097e8:	75 c3                	jne    c01097ad <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01097ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01097ef:	c9                   	leave  
c01097f0:	c3                   	ret    

c01097f1 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01097f1:	55                   	push   %ebp
c01097f2:	89 e5                	mov    %esp,%ebp
c01097f4:	83 ec 38             	sub    $0x38,%esp
c01097f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01097fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01097fd:	8b 45 14             	mov    0x14(%ebp),%eax
c0109800:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0109803:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109806:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109809:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010980c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010980f:	8b 45 18             	mov    0x18(%ebp),%eax
c0109812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109815:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109818:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010981b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010981e:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109821:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109824:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109827:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010982b:	74 1c                	je     c0109849 <printnum+0x58>
c010982d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109830:	ba 00 00 00 00       	mov    $0x0,%edx
c0109835:	f7 75 e4             	divl   -0x1c(%ebp)
c0109838:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010983b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010983e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109843:	f7 75 e4             	divl   -0x1c(%ebp)
c0109846:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109849:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010984c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010984f:	f7 75 e4             	divl   -0x1c(%ebp)
c0109852:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109855:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109858:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010985b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010985e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109861:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109864:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109867:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010986a:	8b 45 18             	mov    0x18(%ebp),%eax
c010986d:	ba 00 00 00 00       	mov    $0x0,%edx
c0109872:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109875:	77 41                	ja     c01098b8 <printnum+0xc7>
c0109877:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010987a:	72 05                	jb     c0109881 <printnum+0x90>
c010987c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010987f:	77 37                	ja     c01098b8 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0109881:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0109884:	83 e8 01             	sub    $0x1,%eax
c0109887:	83 ec 04             	sub    $0x4,%esp
c010988a:	ff 75 20             	pushl  0x20(%ebp)
c010988d:	50                   	push   %eax
c010988e:	ff 75 18             	pushl  0x18(%ebp)
c0109891:	ff 75 ec             	pushl  -0x14(%ebp)
c0109894:	ff 75 e8             	pushl  -0x18(%ebp)
c0109897:	ff 75 0c             	pushl  0xc(%ebp)
c010989a:	ff 75 08             	pushl  0x8(%ebp)
c010989d:	e8 4f ff ff ff       	call   c01097f1 <printnum>
c01098a2:	83 c4 20             	add    $0x20,%esp
c01098a5:	eb 1b                	jmp    c01098c2 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01098a7:	83 ec 08             	sub    $0x8,%esp
c01098aa:	ff 75 0c             	pushl  0xc(%ebp)
c01098ad:	ff 75 20             	pushl  0x20(%ebp)
c01098b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01098b3:	ff d0                	call   *%eax
c01098b5:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01098b8:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01098bc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01098c0:	7f e5                	jg     c01098a7 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01098c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01098c5:	05 48 c2 10 c0       	add    $0xc010c248,%eax
c01098ca:	0f b6 00             	movzbl (%eax),%eax
c01098cd:	0f be c0             	movsbl %al,%eax
c01098d0:	83 ec 08             	sub    $0x8,%esp
c01098d3:	ff 75 0c             	pushl  0xc(%ebp)
c01098d6:	50                   	push   %eax
c01098d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01098da:	ff d0                	call   *%eax
c01098dc:	83 c4 10             	add    $0x10,%esp
}
c01098df:	90                   	nop
c01098e0:	c9                   	leave  
c01098e1:	c3                   	ret    

c01098e2 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01098e2:	55                   	push   %ebp
c01098e3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01098e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01098e9:	7e 14                	jle    c01098ff <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01098eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01098ee:	8b 00                	mov    (%eax),%eax
c01098f0:	8d 48 08             	lea    0x8(%eax),%ecx
c01098f3:	8b 55 08             	mov    0x8(%ebp),%edx
c01098f6:	89 0a                	mov    %ecx,(%edx)
c01098f8:	8b 50 04             	mov    0x4(%eax),%edx
c01098fb:	8b 00                	mov    (%eax),%eax
c01098fd:	eb 30                	jmp    c010992f <getuint+0x4d>
    }
    else if (lflag) {
c01098ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109903:	74 16                	je     c010991b <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109905:	8b 45 08             	mov    0x8(%ebp),%eax
c0109908:	8b 00                	mov    (%eax),%eax
c010990a:	8d 48 04             	lea    0x4(%eax),%ecx
c010990d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109910:	89 0a                	mov    %ecx,(%edx)
c0109912:	8b 00                	mov    (%eax),%eax
c0109914:	ba 00 00 00 00       	mov    $0x0,%edx
c0109919:	eb 14                	jmp    c010992f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010991b:	8b 45 08             	mov    0x8(%ebp),%eax
c010991e:	8b 00                	mov    (%eax),%eax
c0109920:	8d 48 04             	lea    0x4(%eax),%ecx
c0109923:	8b 55 08             	mov    0x8(%ebp),%edx
c0109926:	89 0a                	mov    %ecx,(%edx)
c0109928:	8b 00                	mov    (%eax),%eax
c010992a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010992f:	5d                   	pop    %ebp
c0109930:	c3                   	ret    

c0109931 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109931:	55                   	push   %ebp
c0109932:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109934:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109938:	7e 14                	jle    c010994e <getint+0x1d>
        return va_arg(*ap, long long);
c010993a:	8b 45 08             	mov    0x8(%ebp),%eax
c010993d:	8b 00                	mov    (%eax),%eax
c010993f:	8d 48 08             	lea    0x8(%eax),%ecx
c0109942:	8b 55 08             	mov    0x8(%ebp),%edx
c0109945:	89 0a                	mov    %ecx,(%edx)
c0109947:	8b 50 04             	mov    0x4(%eax),%edx
c010994a:	8b 00                	mov    (%eax),%eax
c010994c:	eb 28                	jmp    c0109976 <getint+0x45>
    }
    else if (lflag) {
c010994e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109952:	74 12                	je     c0109966 <getint+0x35>
        return va_arg(*ap, long);
c0109954:	8b 45 08             	mov    0x8(%ebp),%eax
c0109957:	8b 00                	mov    (%eax),%eax
c0109959:	8d 48 04             	lea    0x4(%eax),%ecx
c010995c:	8b 55 08             	mov    0x8(%ebp),%edx
c010995f:	89 0a                	mov    %ecx,(%edx)
c0109961:	8b 00                	mov    (%eax),%eax
c0109963:	99                   	cltd   
c0109964:	eb 10                	jmp    c0109976 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109966:	8b 45 08             	mov    0x8(%ebp),%eax
c0109969:	8b 00                	mov    (%eax),%eax
c010996b:	8d 48 04             	lea    0x4(%eax),%ecx
c010996e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109971:	89 0a                	mov    %ecx,(%edx)
c0109973:	8b 00                	mov    (%eax),%eax
c0109975:	99                   	cltd   
    }
}
c0109976:	5d                   	pop    %ebp
c0109977:	c3                   	ret    

c0109978 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109978:	55                   	push   %ebp
c0109979:	89 e5                	mov    %esp,%ebp
c010997b:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010997e:	8d 45 14             	lea    0x14(%ebp),%eax
c0109981:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109987:	50                   	push   %eax
c0109988:	ff 75 10             	pushl  0x10(%ebp)
c010998b:	ff 75 0c             	pushl  0xc(%ebp)
c010998e:	ff 75 08             	pushl  0x8(%ebp)
c0109991:	e8 06 00 00 00       	call   c010999c <vprintfmt>
c0109996:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0109999:	90                   	nop
c010999a:	c9                   	leave  
c010999b:	c3                   	ret    

c010999c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010999c:	55                   	push   %ebp
c010999d:	89 e5                	mov    %esp,%ebp
c010999f:	56                   	push   %esi
c01099a0:	53                   	push   %ebx
c01099a1:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01099a4:	eb 17                	jmp    c01099bd <vprintfmt+0x21>
            if (ch == '\0') {
c01099a6:	85 db                	test   %ebx,%ebx
c01099a8:	0f 84 8e 03 00 00    	je     c0109d3c <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01099ae:	83 ec 08             	sub    $0x8,%esp
c01099b1:	ff 75 0c             	pushl  0xc(%ebp)
c01099b4:	53                   	push   %ebx
c01099b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b8:	ff d0                	call   *%eax
c01099ba:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01099bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01099c0:	8d 50 01             	lea    0x1(%eax),%edx
c01099c3:	89 55 10             	mov    %edx,0x10(%ebp)
c01099c6:	0f b6 00             	movzbl (%eax),%eax
c01099c9:	0f b6 d8             	movzbl %al,%ebx
c01099cc:	83 fb 25             	cmp    $0x25,%ebx
c01099cf:	75 d5                	jne    c01099a6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01099d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01099d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01099dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01099df:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01099e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01099e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01099ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01099ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01099f2:	8d 50 01             	lea    0x1(%eax),%edx
c01099f5:	89 55 10             	mov    %edx,0x10(%ebp)
c01099f8:	0f b6 00             	movzbl (%eax),%eax
c01099fb:	0f b6 d8             	movzbl %al,%ebx
c01099fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0109a01:	83 f8 55             	cmp    $0x55,%eax
c0109a04:	0f 87 05 03 00 00    	ja     c0109d0f <vprintfmt+0x373>
c0109a0a:	8b 04 85 6c c2 10 c0 	mov    -0x3fef3d94(,%eax,4),%eax
c0109a11:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109a13:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109a17:	eb d6                	jmp    c01099ef <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109a19:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0109a1d:	eb d0                	jmp    c01099ef <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109a1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109a29:	89 d0                	mov    %edx,%eax
c0109a2b:	c1 e0 02             	shl    $0x2,%eax
c0109a2e:	01 d0                	add    %edx,%eax
c0109a30:	01 c0                	add    %eax,%eax
c0109a32:	01 d8                	add    %ebx,%eax
c0109a34:	83 e8 30             	sub    $0x30,%eax
c0109a37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109a3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0109a3d:	0f b6 00             	movzbl (%eax),%eax
c0109a40:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109a43:	83 fb 2f             	cmp    $0x2f,%ebx
c0109a46:	7e 39                	jle    c0109a81 <vprintfmt+0xe5>
c0109a48:	83 fb 39             	cmp    $0x39,%ebx
c0109a4b:	7f 34                	jg     c0109a81 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109a4d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0109a51:	eb d3                	jmp    c0109a26 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0109a53:	8b 45 14             	mov    0x14(%ebp),%eax
c0109a56:	8d 50 04             	lea    0x4(%eax),%edx
c0109a59:	89 55 14             	mov    %edx,0x14(%ebp)
c0109a5c:	8b 00                	mov    (%eax),%eax
c0109a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0109a61:	eb 1f                	jmp    c0109a82 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0109a63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a67:	79 86                	jns    c01099ef <vprintfmt+0x53>
                width = 0;
c0109a69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109a70:	e9 7a ff ff ff       	jmp    c01099ef <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0109a75:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109a7c:	e9 6e ff ff ff       	jmp    c01099ef <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0109a81:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0109a82:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a86:	0f 89 63 ff ff ff    	jns    c01099ef <vprintfmt+0x53>
                width = precision, precision = -1;
c0109a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109a8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109a92:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109a99:	e9 51 ff ff ff       	jmp    c01099ef <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0109a9e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109aa2:	e9 48 ff ff ff       	jmp    c01099ef <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109aa7:	8b 45 14             	mov    0x14(%ebp),%eax
c0109aaa:	8d 50 04             	lea    0x4(%eax),%edx
c0109aad:	89 55 14             	mov    %edx,0x14(%ebp)
c0109ab0:	8b 00                	mov    (%eax),%eax
c0109ab2:	83 ec 08             	sub    $0x8,%esp
c0109ab5:	ff 75 0c             	pushl  0xc(%ebp)
c0109ab8:	50                   	push   %eax
c0109ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109abc:	ff d0                	call   *%eax
c0109abe:	83 c4 10             	add    $0x10,%esp
            break;
c0109ac1:	e9 71 02 00 00       	jmp    c0109d37 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109ac6:	8b 45 14             	mov    0x14(%ebp),%eax
c0109ac9:	8d 50 04             	lea    0x4(%eax),%edx
c0109acc:	89 55 14             	mov    %edx,0x14(%ebp)
c0109acf:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109ad1:	85 db                	test   %ebx,%ebx
c0109ad3:	79 02                	jns    c0109ad7 <vprintfmt+0x13b>
                err = -err;
c0109ad5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109ad7:	83 fb 06             	cmp    $0x6,%ebx
c0109ada:	7f 0b                	jg     c0109ae7 <vprintfmt+0x14b>
c0109adc:	8b 34 9d 2c c2 10 c0 	mov    -0x3fef3dd4(,%ebx,4),%esi
c0109ae3:	85 f6                	test   %esi,%esi
c0109ae5:	75 19                	jne    c0109b00 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0109ae7:	53                   	push   %ebx
c0109ae8:	68 59 c2 10 c0       	push   $0xc010c259
c0109aed:	ff 75 0c             	pushl  0xc(%ebp)
c0109af0:	ff 75 08             	pushl  0x8(%ebp)
c0109af3:	e8 80 fe ff ff       	call   c0109978 <printfmt>
c0109af8:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109afb:	e9 37 02 00 00       	jmp    c0109d37 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0109b00:	56                   	push   %esi
c0109b01:	68 62 c2 10 c0       	push   $0xc010c262
c0109b06:	ff 75 0c             	pushl  0xc(%ebp)
c0109b09:	ff 75 08             	pushl  0x8(%ebp)
c0109b0c:	e8 67 fe ff ff       	call   c0109978 <printfmt>
c0109b11:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0109b14:	e9 1e 02 00 00       	jmp    c0109d37 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109b19:	8b 45 14             	mov    0x14(%ebp),%eax
c0109b1c:	8d 50 04             	lea    0x4(%eax),%edx
c0109b1f:	89 55 14             	mov    %edx,0x14(%ebp)
c0109b22:	8b 30                	mov    (%eax),%esi
c0109b24:	85 f6                	test   %esi,%esi
c0109b26:	75 05                	jne    c0109b2d <vprintfmt+0x191>
                p = "(null)";
c0109b28:	be 65 c2 10 c0       	mov    $0xc010c265,%esi
            }
            if (width > 0 && padc != '-') {
c0109b2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109b31:	7e 76                	jle    c0109ba9 <vprintfmt+0x20d>
c0109b33:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109b37:	74 70                	je     c0109ba9 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109b3c:	83 ec 08             	sub    $0x8,%esp
c0109b3f:	50                   	push   %eax
c0109b40:	56                   	push   %esi
c0109b41:	e8 17 f8 ff ff       	call   c010935d <strnlen>
c0109b46:	83 c4 10             	add    $0x10,%esp
c0109b49:	89 c2                	mov    %eax,%edx
c0109b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b4e:	29 d0                	sub    %edx,%eax
c0109b50:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b53:	eb 17                	jmp    c0109b6c <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0109b55:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109b59:	83 ec 08             	sub    $0x8,%esp
c0109b5c:	ff 75 0c             	pushl  0xc(%ebp)
c0109b5f:	50                   	push   %eax
c0109b60:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b63:	ff d0                	call   *%eax
c0109b65:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109b68:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109b6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109b70:	7f e3                	jg     c0109b55 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109b72:	eb 35                	jmp    c0109ba9 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109b74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109b78:	74 1c                	je     c0109b96 <vprintfmt+0x1fa>
c0109b7a:	83 fb 1f             	cmp    $0x1f,%ebx
c0109b7d:	7e 05                	jle    c0109b84 <vprintfmt+0x1e8>
c0109b7f:	83 fb 7e             	cmp    $0x7e,%ebx
c0109b82:	7e 12                	jle    c0109b96 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0109b84:	83 ec 08             	sub    $0x8,%esp
c0109b87:	ff 75 0c             	pushl  0xc(%ebp)
c0109b8a:	6a 3f                	push   $0x3f
c0109b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b8f:	ff d0                	call   *%eax
c0109b91:	83 c4 10             	add    $0x10,%esp
c0109b94:	eb 0f                	jmp    c0109ba5 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0109b96:	83 ec 08             	sub    $0x8,%esp
c0109b99:	ff 75 0c             	pushl  0xc(%ebp)
c0109b9c:	53                   	push   %ebx
c0109b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ba0:	ff d0                	call   *%eax
c0109ba2:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109ba5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109ba9:	89 f0                	mov    %esi,%eax
c0109bab:	8d 70 01             	lea    0x1(%eax),%esi
c0109bae:	0f b6 00             	movzbl (%eax),%eax
c0109bb1:	0f be d8             	movsbl %al,%ebx
c0109bb4:	85 db                	test   %ebx,%ebx
c0109bb6:	74 26                	je     c0109bde <vprintfmt+0x242>
c0109bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109bbc:	78 b6                	js     c0109b74 <vprintfmt+0x1d8>
c0109bbe:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109bc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109bc6:	79 ac                	jns    c0109b74 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109bc8:	eb 14                	jmp    c0109bde <vprintfmt+0x242>
                putch(' ', putdat);
c0109bca:	83 ec 08             	sub    $0x8,%esp
c0109bcd:	ff 75 0c             	pushl  0xc(%ebp)
c0109bd0:	6a 20                	push   $0x20
c0109bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bd5:	ff d0                	call   *%eax
c0109bd7:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109bda:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109bde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109be2:	7f e6                	jg     c0109bca <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0109be4:	e9 4e 01 00 00       	jmp    c0109d37 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109be9:	83 ec 08             	sub    $0x8,%esp
c0109bec:	ff 75 e0             	pushl  -0x20(%ebp)
c0109bef:	8d 45 14             	lea    0x14(%ebp),%eax
c0109bf2:	50                   	push   %eax
c0109bf3:	e8 39 fd ff ff       	call   c0109931 <getint>
c0109bf8:	83 c4 10             	add    $0x10,%esp
c0109bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109c07:	85 d2                	test   %edx,%edx
c0109c09:	79 23                	jns    c0109c2e <vprintfmt+0x292>
                putch('-', putdat);
c0109c0b:	83 ec 08             	sub    $0x8,%esp
c0109c0e:	ff 75 0c             	pushl  0xc(%ebp)
c0109c11:	6a 2d                	push   $0x2d
c0109c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c16:	ff d0                	call   *%eax
c0109c18:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0109c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109c21:	f7 d8                	neg    %eax
c0109c23:	83 d2 00             	adc    $0x0,%edx
c0109c26:	f7 da                	neg    %edx
c0109c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109c35:	e9 9f 00 00 00       	jmp    c0109cd9 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109c3a:	83 ec 08             	sub    $0x8,%esp
c0109c3d:	ff 75 e0             	pushl  -0x20(%ebp)
c0109c40:	8d 45 14             	lea    0x14(%ebp),%eax
c0109c43:	50                   	push   %eax
c0109c44:	e8 99 fc ff ff       	call   c01098e2 <getuint>
c0109c49:	83 c4 10             	add    $0x10,%esp
c0109c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109c52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109c59:	eb 7e                	jmp    c0109cd9 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109c5b:	83 ec 08             	sub    $0x8,%esp
c0109c5e:	ff 75 e0             	pushl  -0x20(%ebp)
c0109c61:	8d 45 14             	lea    0x14(%ebp),%eax
c0109c64:	50                   	push   %eax
c0109c65:	e8 78 fc ff ff       	call   c01098e2 <getuint>
c0109c6a:	83 c4 10             	add    $0x10,%esp
c0109c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109c73:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109c7a:	eb 5d                	jmp    c0109cd9 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0109c7c:	83 ec 08             	sub    $0x8,%esp
c0109c7f:	ff 75 0c             	pushl  0xc(%ebp)
c0109c82:	6a 30                	push   $0x30
c0109c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c87:	ff d0                	call   *%eax
c0109c89:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0109c8c:	83 ec 08             	sub    $0x8,%esp
c0109c8f:	ff 75 0c             	pushl  0xc(%ebp)
c0109c92:	6a 78                	push   $0x78
c0109c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c97:	ff d0                	call   *%eax
c0109c99:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109c9c:	8b 45 14             	mov    0x14(%ebp),%eax
c0109c9f:	8d 50 04             	lea    0x4(%eax),%edx
c0109ca2:	89 55 14             	mov    %edx,0x14(%ebp)
c0109ca5:	8b 00                	mov    (%eax),%eax
c0109ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109cb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109cb8:	eb 1f                	jmp    c0109cd9 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109cba:	83 ec 08             	sub    $0x8,%esp
c0109cbd:	ff 75 e0             	pushl  -0x20(%ebp)
c0109cc0:	8d 45 14             	lea    0x14(%ebp),%eax
c0109cc3:	50                   	push   %eax
c0109cc4:	e8 19 fc ff ff       	call   c01098e2 <getuint>
c0109cc9:	83 c4 10             	add    $0x10,%esp
c0109ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ccf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109cd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109cd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ce0:	83 ec 04             	sub    $0x4,%esp
c0109ce3:	52                   	push   %edx
c0109ce4:	ff 75 e8             	pushl  -0x18(%ebp)
c0109ce7:	50                   	push   %eax
c0109ce8:	ff 75 f4             	pushl  -0xc(%ebp)
c0109ceb:	ff 75 f0             	pushl  -0x10(%ebp)
c0109cee:	ff 75 0c             	pushl  0xc(%ebp)
c0109cf1:	ff 75 08             	pushl  0x8(%ebp)
c0109cf4:	e8 f8 fa ff ff       	call   c01097f1 <printnum>
c0109cf9:	83 c4 20             	add    $0x20,%esp
            break;
c0109cfc:	eb 39                	jmp    c0109d37 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109cfe:	83 ec 08             	sub    $0x8,%esp
c0109d01:	ff 75 0c             	pushl  0xc(%ebp)
c0109d04:	53                   	push   %ebx
c0109d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d08:	ff d0                	call   *%eax
c0109d0a:	83 c4 10             	add    $0x10,%esp
            break;
c0109d0d:	eb 28                	jmp    c0109d37 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109d0f:	83 ec 08             	sub    $0x8,%esp
c0109d12:	ff 75 0c             	pushl  0xc(%ebp)
c0109d15:	6a 25                	push   $0x25
c0109d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d1a:	ff d0                	call   *%eax
c0109d1c:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109d1f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109d23:	eb 04                	jmp    c0109d29 <vprintfmt+0x38d>
c0109d25:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109d29:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d2c:	83 e8 01             	sub    $0x1,%eax
c0109d2f:	0f b6 00             	movzbl (%eax),%eax
c0109d32:	3c 25                	cmp    $0x25,%al
c0109d34:	75 ef                	jne    c0109d25 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0109d36:	90                   	nop
        }
    }
c0109d37:	e9 68 fc ff ff       	jmp    c01099a4 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0109d3c:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0109d40:	5b                   	pop    %ebx
c0109d41:	5e                   	pop    %esi
c0109d42:	5d                   	pop    %ebp
c0109d43:	c3                   	ret    

c0109d44 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109d44:	55                   	push   %ebp
c0109d45:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109d47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d4a:	8b 40 08             	mov    0x8(%eax),%eax
c0109d4d:	8d 50 01             	lea    0x1(%eax),%edx
c0109d50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d53:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109d56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d59:	8b 10                	mov    (%eax),%edx
c0109d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d5e:	8b 40 04             	mov    0x4(%eax),%eax
c0109d61:	39 c2                	cmp    %eax,%edx
c0109d63:	73 12                	jae    c0109d77 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109d65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d68:	8b 00                	mov    (%eax),%eax
c0109d6a:	8d 48 01             	lea    0x1(%eax),%ecx
c0109d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109d70:	89 0a                	mov    %ecx,(%edx)
c0109d72:	8b 55 08             	mov    0x8(%ebp),%edx
c0109d75:	88 10                	mov    %dl,(%eax)
    }
}
c0109d77:	90                   	nop
c0109d78:	5d                   	pop    %ebp
c0109d79:	c3                   	ret    

c0109d7a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109d7a:	55                   	push   %ebp
c0109d7b:	89 e5                	mov    %esp,%ebp
c0109d7d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109d80:	8d 45 14             	lea    0x14(%ebp),%eax
c0109d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d89:	50                   	push   %eax
c0109d8a:	ff 75 10             	pushl  0x10(%ebp)
c0109d8d:	ff 75 0c             	pushl  0xc(%ebp)
c0109d90:	ff 75 08             	pushl  0x8(%ebp)
c0109d93:	e8 0b 00 00 00       	call   c0109da3 <vsnprintf>
c0109d98:	83 c4 10             	add    $0x10,%esp
c0109d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109da1:	c9                   	leave  
c0109da2:	c3                   	ret    

c0109da3 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109da3:	55                   	push   %ebp
c0109da4:	89 e5                	mov    %esp,%ebp
c0109da6:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109da9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109daf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109db2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109db8:	01 d0                	add    %edx,%eax
c0109dba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109dbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109dc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109dc8:	74 0a                	je     c0109dd4 <vsnprintf+0x31>
c0109dca:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dd0:	39 c2                	cmp    %eax,%edx
c0109dd2:	76 07                	jbe    c0109ddb <vsnprintf+0x38>
        return -E_INVAL;
c0109dd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109dd9:	eb 20                	jmp    c0109dfb <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109ddb:	ff 75 14             	pushl  0x14(%ebp)
c0109dde:	ff 75 10             	pushl  0x10(%ebp)
c0109de1:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109de4:	50                   	push   %eax
c0109de5:	68 44 9d 10 c0       	push   $0xc0109d44
c0109dea:	e8 ad fb ff ff       	call   c010999c <vprintfmt>
c0109def:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0109df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109df5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109dfb:	c9                   	leave  
c0109dfc:	c3                   	ret    

c0109dfd <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109dfd:	55                   	push   %ebp
c0109dfe:	89 e5                	mov    %esp,%ebp
c0109e00:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c0109e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e06:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109e0f:	b8 20 00 00 00       	mov    $0x20,%eax
c0109e14:	2b 45 0c             	sub    0xc(%ebp),%eax
c0109e17:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109e1a:	89 c1                	mov    %eax,%ecx
c0109e1c:	d3 ea                	shr    %cl,%edx
c0109e1e:	89 d0                	mov    %edx,%eax
}
c0109e20:	c9                   	leave  
c0109e21:	c3                   	ret    

c0109e22 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109e22:	55                   	push   %ebp
c0109e23:	89 e5                	mov    %esp,%ebp
c0109e25:	57                   	push   %edi
c0109e26:	56                   	push   %esi
c0109e27:	53                   	push   %ebx
c0109e28:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109e2b:	a1 a8 6a 12 c0       	mov    0xc0126aa8,%eax
c0109e30:	8b 15 ac 6a 12 c0    	mov    0xc0126aac,%edx
c0109e36:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109e3c:	6b f0 05             	imul   $0x5,%eax,%esi
c0109e3f:	01 fe                	add    %edi,%esi
c0109e41:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109e46:	f7 e7                	mul    %edi
c0109e48:	01 d6                	add    %edx,%esi
c0109e4a:	89 f2                	mov    %esi,%edx
c0109e4c:	83 c0 0b             	add    $0xb,%eax
c0109e4f:	83 d2 00             	adc    $0x0,%edx
c0109e52:	89 c7                	mov    %eax,%edi
c0109e54:	83 e7 ff             	and    $0xffffffff,%edi
c0109e57:	89 f9                	mov    %edi,%ecx
c0109e59:	0f b7 da             	movzwl %dx,%ebx
c0109e5c:	89 0d a8 6a 12 c0    	mov    %ecx,0xc0126aa8
c0109e62:	89 1d ac 6a 12 c0    	mov    %ebx,0xc0126aac
    unsigned long long result = (next >> 12);
c0109e68:	a1 a8 6a 12 c0       	mov    0xc0126aa8,%eax
c0109e6d:	8b 15 ac 6a 12 c0    	mov    0xc0126aac,%edx
c0109e73:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109e77:	c1 ea 0c             	shr    $0xc,%edx
c0109e7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109e7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109e80:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109e87:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109e8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109e8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109e90:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109e99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109e9d:	74 1c                	je     c0109ebb <rand+0x99>
c0109e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ea2:	ba 00 00 00 00       	mov    $0x0,%edx
c0109ea7:	f7 75 dc             	divl   -0x24(%ebp)
c0109eaa:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109eb0:	ba 00 00 00 00       	mov    $0x0,%edx
c0109eb5:	f7 75 dc             	divl   -0x24(%ebp)
c0109eb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109ebb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109ebe:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109ec1:	f7 75 dc             	divl   -0x24(%ebp)
c0109ec4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109ec7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109eca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109ecd:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109ed3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109ed6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109ed9:	83 c4 24             	add    $0x24,%esp
c0109edc:	5b                   	pop    %ebx
c0109edd:	5e                   	pop    %esi
c0109ede:	5f                   	pop    %edi
c0109edf:	5d                   	pop    %ebp
c0109ee0:	c3                   	ret    

c0109ee1 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109ee1:	55                   	push   %ebp
c0109ee2:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109ee4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ee7:	ba 00 00 00 00       	mov    $0x0,%edx
c0109eec:	a3 a8 6a 12 c0       	mov    %eax,0xc0126aa8
c0109ef1:	89 15 ac 6a 12 c0    	mov    %edx,0xc0126aac
}
c0109ef7:	90                   	nop
c0109ef8:	5d                   	pop    %ebp
c0109ef9:	c3                   	ret    
