
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 90 11 00 	lgdtl  0x119018
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
c010001e:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
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
c0100030:	ba 74 a9 11 c0       	mov    $0xc011a974,%edx
c0100035:	b8 36 9a 11 c0       	mov    $0xc0119a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 9a 11 c0       	push   $0xc0119a36
c0100049:	e8 19 61 00 00       	call   c0106167 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 55 15 00 00       	call   c01015ab <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 00 69 10 c0 	movl   $0xc0106900,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 1c 69 10 c0       	push   $0xc010691c
c0100068:	e8 fa 01 00 00       	call   c0100267 <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 7c 08 00 00       	call   c01008f1 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 24 33 00 00       	call   c01033a3 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 99 16 00 00       	call   c010171d <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 1b 18 00 00       	call   c01018a4 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 c4 0c 00 00       	call   c0100d52 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 c7 17 00 00       	call   c010185a <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 97 0c 00 00       	call   c0100d40 <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 40 9a 11 c0       	mov    0xc0119a40,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 21 69 10 c0       	push   $0xc0106921
c010013c:	e8 26 01 00 00       	call   c0100267 <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 9a 11 c0       	mov    0xc0119a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 2f 69 10 c0       	push   $0xc010692f
c010015a:	e8 08 01 00 00       	call   c0100267 <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 9a 11 c0       	mov    0xc0119a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 3d 69 10 c0       	push   $0xc010693d
c0100178:	e8 ea 00 00 00       	call   c0100267 <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 9a 11 c0       	mov    0xc0119a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 4b 69 10 c0       	push   $0xc010694b
c0100196:	e8 cc 00 00 00       	call   c0100267 <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 9a 11 c0       	mov    0xc0119a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 59 69 10 c0       	push   $0xc0106959
c01001b4:	e8 ae 00 00 00       	call   c0100267 <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 40 9a 11 c0       	mov    0xc0119a40,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 40 9a 11 c0       	mov    %eax,0xc0119a40
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001cf:	90                   	nop
c01001d0:	5d                   	pop    %ebp
c01001d1:	c3                   	ret    

c01001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d2:	55                   	push   %ebp
c01001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001d5:	90                   	nop
c01001d6:	5d                   	pop    %ebp
c01001d7:	c3                   	ret    

c01001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001d8:	55                   	push   %ebp
c01001d9:	89 e5                	mov    %esp,%ebp
c01001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001de:	e8 2c ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e3:	83 ec 0c             	sub    $0xc,%esp
c01001e6:	68 68 69 10 c0       	push   $0xc0106968
c01001eb:	e8 77 00 00 00       	call   c0100267 <cprintf>
c01001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f3:	e8 d4 ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c01001f8:	e8 12 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c01001fd:	83 ec 0c             	sub    $0xc,%esp
c0100200:	68 88 69 10 c0       	push   $0xc0106988
c0100205:	e8 5d 00 00 00       	call   c0100267 <cprintf>
c010020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010020d:	e8 c0 ff ff ff       	call   c01001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100212:	e8 f8 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c0100217:	90                   	nop
c0100218:	c9                   	leave  
c0100219:	c3                   	ret    

c010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	ff 75 08             	pushl  0x8(%ebp)
c0100226:	e8 b1 13 00 00       	call   c01015dc <cons_putc>
c010022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010022e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100231:	8b 00                	mov    (%eax),%eax
c0100233:	8d 50 01             	lea    0x1(%eax),%edx
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	89 10                	mov    %edx,(%eax)
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010024b:	ff 75 0c             	pushl  0xc(%ebp)
c010024e:	ff 75 08             	pushl  0x8(%ebp)
c0100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100254:	50                   	push   %eax
c0100255:	68 1a 02 10 c0       	push   $0xc010021a
c010025a:	e8 3e 62 00 00       	call   c010649d <vprintfmt>
c010025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100265:	c9                   	leave  
c0100266:	c3                   	ret    

c0100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100267:	55                   	push   %ebp
c0100268:	89 e5                	mov    %esp,%ebp
c010026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010026d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100276:	83 ec 08             	sub    $0x8,%esp
c0100279:	50                   	push   %eax
c010027a:	ff 75 08             	pushl  0x8(%ebp)
c010027d:	e8 bc ff ff ff       	call   c010023e <vcprintf>
c0100282:	83 c4 10             	add    $0x10,%esp
c0100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028b:	c9                   	leave  
c010028c:	c3                   	ret    

c010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010028d:	55                   	push   %ebp
c010028e:	89 e5                	mov    %esp,%ebp
c0100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100293:	83 ec 0c             	sub    $0xc,%esp
c0100296:	ff 75 08             	pushl  0x8(%ebp)
c0100299:	e8 3e 13 00 00       	call   c01015dc <cons_putc>
c010029e:	83 c4 10             	add    $0x10,%esp
}
c01002a1:	90                   	nop
c01002a2:	c9                   	leave  
c01002a3:	c3                   	ret    

c01002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a4:	55                   	push   %ebp
c01002a5:	89 e5                	mov    %esp,%ebp
c01002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b1:	eb 14                	jmp    c01002c7 <cputs+0x23>
        cputch(c, &cnt);
c01002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002b7:	83 ec 08             	sub    $0x8,%esp
c01002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002bd:	52                   	push   %edx
c01002be:	50                   	push   %eax
c01002bf:	e8 56 ff ff ff       	call   c010021a <cputch>
c01002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ca:	8d 50 01             	lea    0x1(%eax),%edx
c01002cd:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d0:	0f b6 00             	movzbl (%eax),%eax
c01002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002da:	75 d7                	jne    c01002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002dc:	83 ec 08             	sub    $0x8,%esp
c01002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e2:	50                   	push   %eax
c01002e3:	6a 0a                	push   $0xa
c01002e5:	e8 30 ff ff ff       	call   c010021a <cputch>
c01002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f0:	c9                   	leave  
c01002f1:	c3                   	ret    

c01002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f2:	55                   	push   %ebp
c01002f3:	89 e5                	mov    %esp,%ebp
c01002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002f8:	e8 28 13 00 00       	call   c0101625 <cons_getc>
c01002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100304:	74 f2                	je     c01002f8 <getchar+0x6>
        /* do nothing */;
    return c;
c0100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100309:	c9                   	leave  
c010030a:	c3                   	ret    

c010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100315:	74 13                	je     c010032a <readline+0x1f>
        cprintf("%s", prompt);
c0100317:	83 ec 08             	sub    $0x8,%esp
c010031a:	ff 75 08             	pushl  0x8(%ebp)
c010031d:	68 a7 69 10 c0       	push   $0xc01069a7
c0100322:	e8 40 ff ff ff       	call   c0100267 <cprintf>
c0100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100331:	e8 bc ff ff ff       	call   c01002f2 <getchar>
c0100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010033d:	79 0a                	jns    c0100349 <readline+0x3e>
            return NULL;
c010033f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100344:	e9 82 00 00 00       	jmp    c01003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010034d:	7e 2b                	jle    c010037a <readline+0x6f>
c010034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100356:	7f 22                	jg     c010037a <readline+0x6f>
            cputchar(c);
c0100358:	83 ec 0c             	sub    $0xc,%esp
c010035b:	ff 75 f0             	pushl  -0x10(%ebp)
c010035e:	e8 2a ff ff ff       	call   c010028d <cputchar>
c0100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100369:	8d 50 01             	lea    0x1(%eax),%edx
c010036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100372:	88 90 60 9a 11 c0    	mov    %dl,-0x3fee65a0(%eax)
c0100378:	eb 4c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010037e:	75 1a                	jne    c010039a <readline+0x8f>
c0100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100384:	7e 14                	jle    c010039a <readline+0x8f>
            cputchar(c);
c0100386:	83 ec 0c             	sub    $0xc,%esp
c0100389:	ff 75 f0             	pushl  -0x10(%ebp)
c010038c:	e8 fc fe ff ff       	call   c010028d <cputchar>
c0100391:	83 c4 10             	add    $0x10,%esp
            i --;
c0100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100398:	eb 2c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c010039e:	74 06                	je     c01003a6 <readline+0x9b>
c01003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a4:	75 8b                	jne    c0100331 <readline+0x26>
            cputchar(c);
c01003a6:	83 ec 0c             	sub    $0xc,%esp
c01003a9:	ff 75 f0             	pushl  -0x10(%ebp)
c01003ac:	e8 dc fe ff ff       	call   c010028d <cputchar>
c01003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b7:	05 60 9a 11 c0       	add    $0xc0119a60,%eax
c01003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003bf:	b8 60 9a 11 c0       	mov    $0xc0119a60,%eax
c01003c4:	eb 05                	jmp    c01003cb <readline+0xc0>
        }
    }
c01003c6:	e9 66 ff ff ff       	jmp    c0100331 <readline+0x26>
}
c01003cb:	c9                   	leave  
c01003cc:	c3                   	ret    

c01003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003cd:	55                   	push   %ebp
c01003ce:	89 e5                	mov    %esp,%ebp
c01003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d3:	a1 60 9e 11 c0       	mov    0xc0119e60,%eax
c01003d8:	85 c0                	test   %eax,%eax
c01003da:	75 4a                	jne    c0100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003dc:	c7 05 60 9e 11 c0 01 	movl   $0x1,0xc0119e60
c01003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003ec:	83 ec 04             	sub    $0x4,%esp
c01003ef:	ff 75 0c             	pushl  0xc(%ebp)
c01003f2:	ff 75 08             	pushl  0x8(%ebp)
c01003f5:	68 aa 69 10 c0       	push   $0xc01069aa
c01003fa:	e8 68 fe ff ff       	call   c0100267 <cprintf>
c01003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100405:	83 ec 08             	sub    $0x8,%esp
c0100408:	50                   	push   %eax
c0100409:	ff 75 10             	pushl  0x10(%ebp)
c010040c:	e8 2d fe ff ff       	call   c010023e <vcprintf>
c0100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100414:	83 ec 0c             	sub    $0xc,%esp
c0100417:	68 c6 69 10 c0       	push   $0xc01069c6
c010041c:	e8 46 fe ff ff       	call   c0100267 <cprintf>
c0100421:	83 c4 10             	add    $0x10,%esp
c0100424:	eb 01                	jmp    c0100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100427:	e8 35 14 00 00       	call   c0101861 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010042c:	83 ec 0c             	sub    $0xc,%esp
c010042f:	6a 00                	push   $0x0
c0100431:	e8 30 08 00 00       	call   c0100c66 <kmonitor>
c0100436:	83 c4 10             	add    $0x10,%esp
    }
c0100439:	eb f1                	jmp    c010042c <__panic+0x5f>

c010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010043b:	55                   	push   %ebp
c010043c:	89 e5                	mov    %esp,%ebp
c010043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100441:	8d 45 14             	lea    0x14(%ebp),%eax
c0100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100447:	83 ec 04             	sub    $0x4,%esp
c010044a:	ff 75 0c             	pushl  0xc(%ebp)
c010044d:	ff 75 08             	pushl  0x8(%ebp)
c0100450:	68 c8 69 10 c0       	push   $0xc01069c8
c0100455:	e8 0d fe ff ff       	call   c0100267 <cprintf>
c010045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100460:	83 ec 08             	sub    $0x8,%esp
c0100463:	50                   	push   %eax
c0100464:	ff 75 10             	pushl  0x10(%ebp)
c0100467:	e8 d2 fd ff ff       	call   c010023e <vcprintf>
c010046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010046f:	83 ec 0c             	sub    $0xc,%esp
c0100472:	68 c6 69 10 c0       	push   $0xc01069c6
c0100477:	e8 eb fd ff ff       	call   c0100267 <cprintf>
c010047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010047f:	90                   	nop
c0100480:	c9                   	leave  
c0100481:	c3                   	ret    

c0100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100482:	55                   	push   %ebp
c0100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100485:	a1 60 9e 11 c0       	mov    0xc0119e60,%eax
}
c010048a:	5d                   	pop    %ebp
c010048b:	c3                   	ret    

c010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010048c:	55                   	push   %ebp
c010048d:	89 e5                	mov    %esp,%ebp
c010048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 00                	mov    (%eax),%eax
c0100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049a:	8b 45 10             	mov    0x10(%ebp),%eax
c010049d:	8b 00                	mov    (%eax),%eax
c010049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004a9:	e9 d2 00 00 00       	jmp    c0100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	89 c2                	mov    %eax,%edx
c01004b8:	c1 ea 1f             	shr    $0x1f,%edx
c01004bb:	01 d0                	add    %edx,%eax
c01004bd:	d1 f8                	sar    %eax
c01004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004c8:	eb 04                	jmp    c01004ce <stab_binsearch+0x42>
            m --;
c01004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d4:	7c 1f                	jl     c01004f5 <stab_binsearch+0x69>
c01004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d9:	89 d0                	mov    %edx,%eax
c01004db:	01 c0                	add    %eax,%eax
c01004dd:	01 d0                	add    %edx,%eax
c01004df:	c1 e0 02             	shl    $0x2,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004ed:	0f b6 c0             	movzbl %al,%eax
c01004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f3:	75 d5                	jne    c01004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fb:	7d 0b                	jge    c0100508 <stab_binsearch+0x7c>
            l = true_m + 1;
c01004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100500:	83 c0 01             	add    $0x1,%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100506:	eb 78                	jmp    c0100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	8b 40 08             	mov    0x8(%eax),%eax
c0100525:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100528:	73 13                	jae    c010053d <stab_binsearch+0xb1>
            *region_left = m;
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100535:	83 c0 01             	add    $0x1,%eax
c0100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010053b:	eb 43                	jmp    c0100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100540:	89 d0                	mov    %edx,%eax
c0100542:	01 c0                	add    %eax,%eax
c0100544:	01 d0                	add    %edx,%eax
c0100546:	c1 e0 02             	shl    $0x2,%eax
c0100549:	89 c2                	mov    %eax,%edx
c010054b:	8b 45 08             	mov    0x8(%ebp),%eax
c010054e:	01 d0                	add    %edx,%eax
c0100550:	8b 40 08             	mov    0x8(%eax),%eax
c0100553:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100556:	76 16                	jbe    c010056e <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010055b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010055e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	83 e8 01             	sub    $0x1,%eax
c0100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010056c:	eb 12                	jmp    c0100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010056e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100574:	89 10                	mov    %edx,(%eax)
            l = m;
c0100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100586:	0f 8e 22 ff ff ff    	jle    c01004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c010058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100590:	75 0f                	jne    c01005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	8b 00                	mov    (%eax),%eax
c0100597:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059a:	8b 45 10             	mov    0x10(%ebp),%eax
c010059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010059f:	eb 3f                	jmp    c01005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a4:	8b 00                	mov    (%eax),%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005a9:	eb 04                	jmp    c01005af <stab_binsearch+0x123>
c01005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b2:	8b 00                	mov    (%eax),%eax
c01005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005b7:	7d 1f                	jge    c01005d8 <stab_binsearch+0x14c>
c01005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005bc:	89 d0                	mov    %edx,%eax
c01005be:	01 c0                	add    %eax,%eax
c01005c0:	01 d0                	add    %edx,%eax
c01005c2:	c1 e0 02             	shl    $0x2,%eax
c01005c5:	89 c2                	mov    %eax,%edx
c01005c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ca:	01 d0                	add    %edx,%eax
c01005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d0:	0f b6 c0             	movzbl %al,%eax
c01005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005d6:	75 d3                	jne    c01005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005de:	89 10                	mov    %edx,(%eax)
    }
}
c01005e0:	90                   	nop
c01005e1:	c9                   	leave  
c01005e2:	c3                   	ret    

c01005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e3:	55                   	push   %ebp
c01005e4:	89 e5                	mov    %esp,%ebp
c01005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	c7 00 e8 69 10 c0    	movl   $0xc01069e8,(%eax)
    info->eip_line = 0;
c01005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c01005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ff:	c7 40 08 e8 69 10 c0 	movl   $0xc01069e8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100606:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100613:	8b 55 08             	mov    0x8(%ebp),%edx
c0100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100623:	c7 45 f4 88 7f 10 c0 	movl   $0xc0107f88,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062a:	c7 45 f0 4c 42 11 c0 	movl   $0xc011424c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100631:	c7 45 ec 4d 42 11 c0 	movl   $0xc011424d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100638:	c7 45 e8 a9 6f 11 c0 	movl   $0xc0116fa9,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100645:	76 0d                	jbe    c0100654 <debuginfo_eip+0x71>
c0100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064a:	83 e8 01             	sub    $0x1,%eax
c010064d:	0f b6 00             	movzbl (%eax),%eax
c0100650:	84 c0                	test   %al,%al
c0100652:	74 0a                	je     c010065e <debuginfo_eip+0x7b>
        return -1;
c0100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100659:	e9 91 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066b:	29 c2                	sub    %eax,%edx
c010066d:	89 d0                	mov    %edx,%eax
c010066f:	c1 f8 02             	sar    $0x2,%eax
c0100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100678:	83 e8 01             	sub    $0x1,%eax
c010067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010067e:	ff 75 08             	pushl  0x8(%ebp)
c0100681:	6a 64                	push   $0x64
c0100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100686:	50                   	push   %eax
c0100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068a:	50                   	push   %eax
c010068b:	ff 75 f4             	pushl  -0xc(%ebp)
c010068e:	e8 f9 fd ff ff       	call   c010048c <stab_binsearch>
c0100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100699:	85 c0                	test   %eax,%eax
c010069b:	75 0a                	jne    c01006a7 <debuginfo_eip+0xc4>
        return -1;
c010069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a2:	e9 48 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b3:	ff 75 08             	pushl  0x8(%ebp)
c01006b6:	6a 24                	push   $0x24
c01006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006bb:	50                   	push   %eax
c01006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006bf:	50                   	push   %eax
c01006c0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c3:	e8 c4 fd ff ff       	call   c010048c <stab_binsearch>
c01006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d1:	39 c2                	cmp    %eax,%edx
c01006d3:	7f 7c                	jg     c0100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d8:	89 c2                	mov    %eax,%edx
c01006da:	89 d0                	mov    %edx,%eax
c01006dc:	01 c0                	add    %eax,%eax
c01006de:	01 d0                	add    %edx,%eax
c01006e0:	c1 e0 02             	shl    $0x2,%eax
c01006e3:	89 c2                	mov    %eax,%edx
c01006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e8:	01 d0                	add    %edx,%eax
c01006ea:	8b 00                	mov    (%eax),%eax
c01006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f2:	29 d1                	sub    %edx,%ecx
c01006f4:	89 ca                	mov    %ecx,%edx
c01006f6:	39 d0                	cmp    %edx,%eax
c01006f8:	73 22                	jae    c010071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006fd:	89 c2                	mov    %eax,%edx
c01006ff:	89 d0                	mov    %edx,%eax
c0100701:	01 c0                	add    %eax,%eax
c0100703:	01 d0                	add    %edx,%eax
c0100705:	c1 e0 02             	shl    $0x2,%eax
c0100708:	89 c2                	mov    %eax,%edx
c010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070d:	01 d0                	add    %edx,%eax
c010070f:	8b 10                	mov    (%eax),%edx
c0100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100714:	01 c2                	add    %eax,%edx
c0100716:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071f:	89 c2                	mov    %eax,%edx
c0100721:	89 d0                	mov    %edx,%eax
c0100723:	01 c0                	add    %eax,%eax
c0100725:	01 d0                	add    %edx,%eax
c0100727:	c1 e0 02             	shl    $0x2,%eax
c010072a:	89 c2                	mov    %eax,%edx
c010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072f:	01 d0                	add    %edx,%eax
c0100731:	8b 50 08             	mov    0x8(%eax),%edx
c0100734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073d:	8b 40 10             	mov    0x10(%eax),%eax
c0100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010074f:	eb 15                	jmp    c0100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8b 55 08             	mov    0x8(%ebp),%edx
c0100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8b 40 08             	mov    0x8(%eax),%eax
c010076c:	83 ec 08             	sub    $0x8,%esp
c010076f:	6a 3a                	push   $0x3a
c0100771:	50                   	push   %eax
c0100772:	e8 64 58 00 00       	call   c0105fdb <strfind>
c0100777:	83 c4 10             	add    $0x10,%esp
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077f:	8b 40 08             	mov    0x8(%eax),%eax
c0100782:	29 c2                	sub    %eax,%edx
c0100784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078a:	83 ec 0c             	sub    $0xc,%esp
c010078d:	ff 75 08             	pushl  0x8(%ebp)
c0100790:	6a 44                	push   $0x44
c0100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100795:	50                   	push   %eax
c0100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100799:	50                   	push   %eax
c010079a:	ff 75 f4             	pushl  -0xc(%ebp)
c010079d:	e8 ea fc ff ff       	call   c010048c <stab_binsearch>
c01007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ab:	39 c2                	cmp    %eax,%edx
c01007ad:	7f 24                	jg     c01007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007c8:	0f b7 d0             	movzwl %ax,%edx
c01007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d1:	eb 13                	jmp    c01007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007d8:	e9 12 01 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e0:	83 e8 01             	sub    $0x1,%eax
c01007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ec:	39 c2                	cmp    %eax,%edx
c01007ee:	7c 56                	jl     c0100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f3:	89 c2                	mov    %eax,%edx
c01007f5:	89 d0                	mov    %edx,%eax
c01007f7:	01 c0                	add    %eax,%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	c1 e0 02             	shl    $0x2,%eax
c01007fe:	89 c2                	mov    %eax,%edx
c0100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100803:	01 d0                	add    %edx,%eax
c0100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100809:	3c 84                	cmp    $0x84,%al
c010080b:	74 39                	je     c0100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100826:	3c 64                	cmp    $0x64,%al
c0100828:	75 b3                	jne    c01007dd <debuginfo_eip+0x1fa>
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	89 d0                	mov    %edx,%eax
c0100831:	01 c0                	add    %eax,%eax
c0100833:	01 d0                	add    %edx,%eax
c0100835:	c1 e0 02             	shl    $0x2,%eax
c0100838:	89 c2                	mov    %eax,%edx
c010083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083d:	01 d0                	add    %edx,%eax
c010083f:	8b 40 08             	mov    0x8(%eax),%eax
c0100842:	85 c0                	test   %eax,%eax
c0100844:	74 97                	je     c01007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084c:	39 c2                	cmp    %eax,%edx
c010084e:	7c 46                	jl     c0100896 <debuginfo_eip+0x2b3>
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	89 c2                	mov    %eax,%edx
c0100855:	89 d0                	mov    %edx,%eax
c0100857:	01 c0                	add    %eax,%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	c1 e0 02             	shl    $0x2,%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	8b 00                	mov    (%eax),%eax
c0100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010086d:	29 d1                	sub    %edx,%ecx
c010086f:	89 ca                	mov    %ecx,%edx
c0100871:	39 d0                	cmp    %edx,%eax
c0100873:	73 21                	jae    c0100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 10                	mov    (%eax),%edx
c010088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088f:	01 c2                	add    %eax,%edx
c0100891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010089c:	39 c2                	cmp    %eax,%edx
c010089e:	7d 4a                	jge    c01008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a3:	83 c0 01             	add    $0x1,%eax
c01008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008a9:	eb 18                	jmp    c01008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ae:	8b 40 14             	mov    0x14(%eax),%eax
c01008b1:	8d 50 01             	lea    0x1(%eax),%edx
c01008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	83 c0 01             	add    $0x1,%eax
c01008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008c9:	39 c2                	cmp    %eax,%edx
c01008cb:	7d 1d                	jge    c01008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008e6:	3c a0                	cmp    $0xa0,%al
c01008e8:	74 c1                	je     c01008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008ef:	c9                   	leave  
c01008f0:	c3                   	ret    

c01008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f1:	55                   	push   %ebp
c01008f2:	89 e5                	mov    %esp,%ebp
c01008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008f7:	83 ec 0c             	sub    $0xc,%esp
c01008fa:	68 f2 69 10 c0       	push   $0xc01069f2
c01008ff:	e8 63 f9 ff ff       	call   c0100267 <cprintf>
c0100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100907:	83 ec 08             	sub    $0x8,%esp
c010090a:	68 2a 00 10 c0       	push   $0xc010002a
c010090f:	68 0b 6a 10 c0       	push   $0xc0106a0b
c0100914:	e8 4e f9 ff ff       	call   c0100267 <cprintf>
c0100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010091c:	83 ec 08             	sub    $0x8,%esp
c010091f:	68 fe 68 10 c0       	push   $0xc01068fe
c0100924:	68 23 6a 10 c0       	push   $0xc0106a23
c0100929:	e8 39 f9 ff ff       	call   c0100267 <cprintf>
c010092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100931:	83 ec 08             	sub    $0x8,%esp
c0100934:	68 36 9a 11 c0       	push   $0xc0119a36
c0100939:	68 3b 6a 10 c0       	push   $0xc0106a3b
c010093e:	e8 24 f9 ff ff       	call   c0100267 <cprintf>
c0100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100946:	83 ec 08             	sub    $0x8,%esp
c0100949:	68 74 a9 11 c0       	push   $0xc011a974
c010094e:	68 53 6a 10 c0       	push   $0xc0106a53
c0100953:	e8 0f f9 ff ff       	call   c0100267 <cprintf>
c0100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010095b:	b8 74 a9 11 c0       	mov    $0xc011a974,%eax
c0100960:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100965:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096a:	29 d0                	sub    %edx,%eax
c010096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100972:	85 c0                	test   %eax,%eax
c0100974:	0f 48 c2             	cmovs  %edx,%eax
c0100977:	c1 f8 0a             	sar    $0xa,%eax
c010097a:	83 ec 08             	sub    $0x8,%esp
c010097d:	50                   	push   %eax
c010097e:	68 6c 6a 10 c0       	push   $0xc0106a6c
c0100983:	e8 df f8 ff ff       	call   c0100267 <cprintf>
c0100988:	83 c4 10             	add    $0x10,%esp
}
c010098b:	90                   	nop
c010098c:	c9                   	leave  
c010098d:	c3                   	ret    

c010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010098e:	55                   	push   %ebp
c010098f:	89 e5                	mov    %esp,%ebp
c0100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100997:	83 ec 08             	sub    $0x8,%esp
c010099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010099d:	50                   	push   %eax
c010099e:	ff 75 08             	pushl  0x8(%ebp)
c01009a1:	e8 3d fc ff ff       	call   c01005e3 <debuginfo_eip>
c01009a6:	83 c4 10             	add    $0x10,%esp
c01009a9:	85 c0                	test   %eax,%eax
c01009ab:	74 15                	je     c01009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ad:	83 ec 08             	sub    $0x8,%esp
c01009b0:	ff 75 08             	pushl  0x8(%ebp)
c01009b3:	68 96 6a 10 c0       	push   $0xc0106a96
c01009b8:	e8 aa f8 ff ff       	call   c0100267 <cprintf>
c01009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c0:	eb 65                	jmp    c0100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009c9:	eb 1c                	jmp    c01009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	0f b6 00             	movzbl (%eax),%eax
c01009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009df:	01 ca                	add    %ecx,%edx
c01009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009ed:	7f dc                	jg     c01009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	01 d0                	add    %edx,%eax
c01009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c01009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a00:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a03:	89 d1                	mov    %edx,%ecx
c0100a05:	29 c1                	sub    %eax,%ecx
c0100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a0d:	83 ec 0c             	sub    $0xc,%esp
c0100a10:	51                   	push   %ecx
c0100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a17:	51                   	push   %ecx
c0100a18:	52                   	push   %edx
c0100a19:	50                   	push   %eax
c0100a1a:	68 b2 6a 10 c0       	push   $0xc0106ab2
c0100a1f:	e8 43 f8 ff ff       	call   c0100267 <cprintf>
c0100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a27:	90                   	nop
c0100a28:	c9                   	leave  
c0100a29:	c3                   	ret    

c0100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2a:	55                   	push   %ebp
c0100a2b:	89 e5                	mov    %esp,%ebp
c0100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a30:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a39:	c9                   	leave  
c0100a3a:	c3                   	ret    

c0100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a3b:	55                   	push   %ebp
c0100a3c:	89 e5                	mov    %esp,%ebp
c0100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a41:	89 e8                	mov    %ebp,%eax
c0100a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
c0100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
c0100a4c:	e8 d9 ff ff ff       	call   c0100a2a <read_eip>
c0100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
c0100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a5b:	e9 87 00 00 00       	jmp    c0100ae7 <print_stackframe+0xac>
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
c0100a60:	83 ec 04             	sub    $0x4,%esp
c0100a63:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a66:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a69:	68 c4 6a 10 c0       	push   $0xc0106ac4
c0100a6e:	e8 f4 f7 ff ff       	call   c0100267 <cprintf>
c0100a73:	83 c4 10             	add    $0x10,%esp
		for (int argi = 0; argi < 4; ++ argi) {
c0100a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a7d:	eb 29                	jmp    c0100aa8 <print_stackframe+0x6d>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
c0100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8c:	01 d0                	add    %edx,%eax
c0100a8e:	83 c0 08             	add    $0x8,%eax
c0100a91:	8b 00                	mov    (%eax),%eax
c0100a93:	83 ec 08             	sub    $0x8,%esp
c0100a96:	50                   	push   %eax
c0100a97:	68 e0 6a 10 c0       	push   $0xc0106ae0
c0100a9c:	e8 c6 f7 ff ff       	call   c0100267 <cprintf>
c0100aa1:	83 c4 10             	add    $0x10,%esp
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
		for (int argi = 0; argi < 4; ++ argi) {
c0100aa4:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100aa8:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100aac:	7e d1                	jle    c0100a7f <print_stackframe+0x44>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
		}
		cprintf("\n");
c0100aae:	83 ec 0c             	sub    $0xc,%esp
c0100ab1:	68 e8 6a 10 c0       	push   $0xc0106ae8
c0100ab6:	e8 ac f7 ff ff       	call   c0100267 <cprintf>
c0100abb:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(current_eip - 1);
c0100abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ac1:	83 e8 01             	sub    $0x1,%eax
c0100ac4:	83 ec 0c             	sub    $0xc,%esp
c0100ac7:	50                   	push   %eax
c0100ac8:	e8 c1 fe ff ff       	call   c010098e <print_debuginfo>
c0100acd:	83 c4 10             	add    $0x10,%esp
		current_eip = *((uint32_t*)current_ebp + 1);
c0100ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad3:	83 c0 04             	add    $0x4,%eax
c0100ad6:	8b 00                	mov    (%eax),%eax
c0100ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);
c0100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ade:	8b 00                	mov    (%eax),%eax
c0100ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
c0100ae3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100ae7:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100aeb:	7f 0a                	jg     c0100af7 <print_stackframe+0xbc>
c0100aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100af1:	0f 85 69 ff ff ff    	jne    c0100a60 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(current_eip - 1);
		current_eip = *((uint32_t*)current_ebp + 1);
		current_ebp = *((uint32_t*)current_ebp);
	}
}
c0100af7:	90                   	nop
c0100af8:	c9                   	leave  
c0100af9:	c3                   	ret    

c0100afa <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100afa:	55                   	push   %ebp
c0100afb:	89 e5                	mov    %esp,%ebp
c0100afd:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b07:	eb 0c                	jmp    c0100b15 <parse+0x1b>
            *buf ++ = '\0';
c0100b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0c:	8d 50 01             	lea    0x1(%eax),%edx
c0100b0f:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b12:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b18:	0f b6 00             	movzbl (%eax),%eax
c0100b1b:	84 c0                	test   %al,%al
c0100b1d:	74 1e                	je     c0100b3d <parse+0x43>
c0100b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b22:	0f b6 00             	movzbl (%eax),%eax
c0100b25:	0f be c0             	movsbl %al,%eax
c0100b28:	83 ec 08             	sub    $0x8,%esp
c0100b2b:	50                   	push   %eax
c0100b2c:	68 6c 6b 10 c0       	push   $0xc0106b6c
c0100b31:	e8 72 54 00 00       	call   c0105fa8 <strchr>
c0100b36:	83 c4 10             	add    $0x10,%esp
c0100b39:	85 c0                	test   %eax,%eax
c0100b3b:	75 cc                	jne    c0100b09 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b40:	0f b6 00             	movzbl (%eax),%eax
c0100b43:	84 c0                	test   %al,%al
c0100b45:	74 69                	je     c0100bb0 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b47:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b4b:	75 12                	jne    c0100b5f <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b4d:	83 ec 08             	sub    $0x8,%esp
c0100b50:	6a 10                	push   $0x10
c0100b52:	68 71 6b 10 c0       	push   $0xc0106b71
c0100b57:	e8 0b f7 ff ff       	call   c0100267 <cprintf>
c0100b5c:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b62:	8d 50 01             	lea    0x1(%eax),%edx
c0100b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b72:	01 c2                	add    %eax,%edx
c0100b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b77:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b79:	eb 04                	jmp    c0100b7f <parse+0x85>
            buf ++;
c0100b7b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b82:	0f b6 00             	movzbl (%eax),%eax
c0100b85:	84 c0                	test   %al,%al
c0100b87:	0f 84 7a ff ff ff    	je     c0100b07 <parse+0xd>
c0100b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b90:	0f b6 00             	movzbl (%eax),%eax
c0100b93:	0f be c0             	movsbl %al,%eax
c0100b96:	83 ec 08             	sub    $0x8,%esp
c0100b99:	50                   	push   %eax
c0100b9a:	68 6c 6b 10 c0       	push   $0xc0106b6c
c0100b9f:	e8 04 54 00 00       	call   c0105fa8 <strchr>
c0100ba4:	83 c4 10             	add    $0x10,%esp
c0100ba7:	85 c0                	test   %eax,%eax
c0100ba9:	74 d0                	je     c0100b7b <parse+0x81>
            buf ++;
        }
    }
c0100bab:	e9 57 ff ff ff       	jmp    c0100b07 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bb0:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bb4:	c9                   	leave  
c0100bb5:	c3                   	ret    

c0100bb6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bb6:	55                   	push   %ebp
c0100bb7:	89 e5                	mov    %esp,%ebp
c0100bb9:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bbc:	83 ec 08             	sub    $0x8,%esp
c0100bbf:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc2:	50                   	push   %eax
c0100bc3:	ff 75 08             	pushl  0x8(%ebp)
c0100bc6:	e8 2f ff ff ff       	call   c0100afa <parse>
c0100bcb:	83 c4 10             	add    $0x10,%esp
c0100bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bd5:	75 0a                	jne    c0100be1 <runcmd+0x2b>
        return 0;
c0100bd7:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bdc:	e9 83 00 00 00       	jmp    c0100c64 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100be8:	eb 59                	jmp    c0100c43 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100bea:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bf0:	89 d0                	mov    %edx,%eax
c0100bf2:	01 c0                	add    %eax,%eax
c0100bf4:	01 d0                	add    %edx,%eax
c0100bf6:	c1 e0 02             	shl    $0x2,%eax
c0100bf9:	05 20 90 11 c0       	add    $0xc0119020,%eax
c0100bfe:	8b 00                	mov    (%eax),%eax
c0100c00:	83 ec 08             	sub    $0x8,%esp
c0100c03:	51                   	push   %ecx
c0100c04:	50                   	push   %eax
c0100c05:	e8 fe 52 00 00       	call   c0105f08 <strcmp>
c0100c0a:	83 c4 10             	add    $0x10,%esp
c0100c0d:	85 c0                	test   %eax,%eax
c0100c0f:	75 2e                	jne    c0100c3f <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c14:	89 d0                	mov    %edx,%eax
c0100c16:	01 c0                	add    %eax,%eax
c0100c18:	01 d0                	add    %edx,%eax
c0100c1a:	c1 e0 02             	shl    $0x2,%eax
c0100c1d:	05 28 90 11 c0       	add    $0xc0119028,%eax
c0100c22:	8b 10                	mov    (%eax),%edx
c0100c24:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c27:	83 c0 04             	add    $0x4,%eax
c0100c2a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c2d:	83 e9 01             	sub    $0x1,%ecx
c0100c30:	83 ec 04             	sub    $0x4,%esp
c0100c33:	ff 75 0c             	pushl  0xc(%ebp)
c0100c36:	50                   	push   %eax
c0100c37:	51                   	push   %ecx
c0100c38:	ff d2                	call   *%edx
c0100c3a:	83 c4 10             	add    $0x10,%esp
c0100c3d:	eb 25                	jmp    c0100c64 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c46:	83 f8 02             	cmp    $0x2,%eax
c0100c49:	76 9f                	jbe    c0100bea <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c4e:	83 ec 08             	sub    $0x8,%esp
c0100c51:	50                   	push   %eax
c0100c52:	68 8f 6b 10 c0       	push   $0xc0106b8f
c0100c57:	e8 0b f6 ff ff       	call   c0100267 <cprintf>
c0100c5c:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c64:	c9                   	leave  
c0100c65:	c3                   	ret    

c0100c66 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c66:	55                   	push   %ebp
c0100c67:	89 e5                	mov    %esp,%ebp
c0100c69:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c6c:	83 ec 0c             	sub    $0xc,%esp
c0100c6f:	68 a8 6b 10 c0       	push   $0xc0106ba8
c0100c74:	e8 ee f5 ff ff       	call   c0100267 <cprintf>
c0100c79:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c7c:	83 ec 0c             	sub    $0xc,%esp
c0100c7f:	68 d0 6b 10 c0       	push   $0xc0106bd0
c0100c84:	e8 de f5 ff ff       	call   c0100267 <cprintf>
c0100c89:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100c8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c90:	74 0e                	je     c0100ca0 <kmonitor+0x3a>
        print_trapframe(tf);
c0100c92:	83 ec 0c             	sub    $0xc,%esp
c0100c95:	ff 75 08             	pushl  0x8(%ebp)
c0100c98:	e8 14 0e 00 00       	call   c0101ab1 <print_trapframe>
c0100c9d:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ca0:	83 ec 0c             	sub    $0xc,%esp
c0100ca3:	68 f5 6b 10 c0       	push   $0xc0106bf5
c0100ca8:	e8 5e f6 ff ff       	call   c010030b <readline>
c0100cad:	83 c4 10             	add    $0x10,%esp
c0100cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cb7:	74 e7                	je     c0100ca0 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cb9:	83 ec 08             	sub    $0x8,%esp
c0100cbc:	ff 75 08             	pushl  0x8(%ebp)
c0100cbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cc2:	e8 ef fe ff ff       	call   c0100bb6 <runcmd>
c0100cc7:	83 c4 10             	add    $0x10,%esp
c0100cca:	85 c0                	test   %eax,%eax
c0100ccc:	78 02                	js     c0100cd0 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100cce:	eb d0                	jmp    c0100ca0 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100cd0:	90                   	nop
            }
        }
    }
}
c0100cd1:	90                   	nop
c0100cd2:	c9                   	leave  
c0100cd3:	c3                   	ret    

c0100cd4 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cd4:	55                   	push   %ebp
c0100cd5:	89 e5                	mov    %esp,%ebp
c0100cd7:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ce1:	eb 3c                	jmp    c0100d1f <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ce6:	89 d0                	mov    %edx,%eax
c0100ce8:	01 c0                	add    %eax,%eax
c0100cea:	01 d0                	add    %edx,%eax
c0100cec:	c1 e0 02             	shl    $0x2,%eax
c0100cef:	05 24 90 11 c0       	add    $0xc0119024,%eax
c0100cf4:	8b 08                	mov    (%eax),%ecx
c0100cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cf9:	89 d0                	mov    %edx,%eax
c0100cfb:	01 c0                	add    %eax,%eax
c0100cfd:	01 d0                	add    %edx,%eax
c0100cff:	c1 e0 02             	shl    $0x2,%eax
c0100d02:	05 20 90 11 c0       	add    $0xc0119020,%eax
c0100d07:	8b 00                	mov    (%eax),%eax
c0100d09:	83 ec 04             	sub    $0x4,%esp
c0100d0c:	51                   	push   %ecx
c0100d0d:	50                   	push   %eax
c0100d0e:	68 f9 6b 10 c0       	push   $0xc0106bf9
c0100d13:	e8 4f f5 ff ff       	call   c0100267 <cprintf>
c0100d18:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d22:	83 f8 02             	cmp    $0x2,%eax
c0100d25:	76 bc                	jbe    c0100ce3 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d2c:	c9                   	leave  
c0100d2d:	c3                   	ret    

c0100d2e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d2e:	55                   	push   %ebp
c0100d2f:	89 e5                	mov    %esp,%ebp
c0100d31:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d34:	e8 b8 fb ff ff       	call   c01008f1 <print_kerninfo>
    return 0;
c0100d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d3e:	c9                   	leave  
c0100d3f:	c3                   	ret    

c0100d40 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d40:	55                   	push   %ebp
c0100d41:	89 e5                	mov    %esp,%ebp
c0100d43:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d46:	e8 f0 fc ff ff       	call   c0100a3b <print_stackframe>
    return 0;
c0100d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d50:	c9                   	leave  
c0100d51:	c3                   	ret    

c0100d52 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d52:	55                   	push   %ebp
c0100d53:	89 e5                	mov    %esp,%ebp
c0100d55:	83 ec 18             	sub    $0x18,%esp
c0100d58:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d5e:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d62:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d66:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d6a:	ee                   	out    %al,(%dx)
c0100d6b:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d71:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d75:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d79:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d7d:	ee                   	out    %al,(%dx)
c0100d7e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d84:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d88:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d8c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d90:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d91:	c7 05 58 a9 11 c0 00 	movl   $0x0,0xc011a958
c0100d98:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d9b:	83 ec 0c             	sub    $0xc,%esp
c0100d9e:	68 02 6c 10 c0       	push   $0xc0106c02
c0100da3:	e8 bf f4 ff ff       	call   c0100267 <cprintf>
c0100da8:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dab:	83 ec 0c             	sub    $0xc,%esp
c0100dae:	6a 00                	push   $0x0
c0100db0:	e8 3b 09 00 00       	call   c01016f0 <pic_enable>
c0100db5:	83 c4 10             	add    $0x10,%esp
}
c0100db8:	90                   	nop
c0100db9:	c9                   	leave  
c0100dba:	c3                   	ret    

c0100dbb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dbb:	55                   	push   %ebp
c0100dbc:	89 e5                	mov    %esp,%ebp
c0100dbe:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dc1:	9c                   	pushf  
c0100dc2:	58                   	pop    %eax
c0100dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dc9:	25 00 02 00 00       	and    $0x200,%eax
c0100dce:	85 c0                	test   %eax,%eax
c0100dd0:	74 0c                	je     c0100dde <__intr_save+0x23>
        intr_disable();
c0100dd2:	e8 8a 0a 00 00       	call   c0101861 <intr_disable>
        return 1;
c0100dd7:	b8 01 00 00 00       	mov    $0x1,%eax
c0100ddc:	eb 05                	jmp    c0100de3 <__intr_save+0x28>
    }
    return 0;
c0100dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100def:	74 05                	je     c0100df6 <__intr_restore+0x11>
        intr_enable();
c0100df1:	e8 64 0a 00 00       	call   c010185a <intr_enable>
    }
}
c0100df6:	90                   	nop
c0100df7:	c9                   	leave  
c0100df8:	c3                   	ret    

c0100df9 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100df9:	55                   	push   %ebp
c0100dfa:	89 e5                	mov    %esp,%ebp
c0100dfc:	83 ec 10             	sub    $0x10,%esp
c0100dff:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e05:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e09:	89 c2                	mov    %eax,%edx
c0100e0b:	ec                   	in     (%dx),%al
c0100e0c:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e0f:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e15:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e19:	89 c2                	mov    %eax,%edx
c0100e1b:	ec                   	in     (%dx),%al
c0100e1c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e1f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e25:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e29:	89 c2                	mov    %eax,%edx
c0100e2b:	ec                   	in     (%dx),%al
c0100e2c:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e2f:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e35:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e39:	89 c2                	mov    %eax,%edx
c0100e3b:	ec                   	in     (%dx),%al
c0100e3c:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e3f:	90                   	nop
c0100e40:	c9                   	leave  
c0100e41:	c3                   	ret    

c0100e42 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e42:	55                   	push   %ebp
c0100e43:	89 e5                	mov    %esp,%ebp
c0100e45:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e48:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e52:	0f b7 00             	movzwl (%eax),%eax
c0100e55:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e5c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e64:	0f b7 00             	movzwl (%eax),%eax
c0100e67:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e6b:	74 12                	je     c0100e7f <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e6d:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e74:	66 c7 05 86 9e 11 c0 	movw   $0x3b4,0xc0119e86
c0100e7b:	b4 03 
c0100e7d:	eb 13                	jmp    c0100e92 <cga_init+0x50>
    } else {
        *cp = was;
c0100e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e82:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e86:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e89:	66 c7 05 86 9e 11 c0 	movw   $0x3d4,0xc0119e86
c0100e90:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e92:	0f b7 05 86 9e 11 c0 	movzwl 0xc0119e86,%eax
c0100e99:	0f b7 c0             	movzwl %ax,%eax
c0100e9c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100ea0:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea4:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100ea8:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100eac:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ead:	0f b7 05 86 9e 11 c0 	movzwl 0xc0119e86,%eax
c0100eb4:	83 c0 01             	add    $0x1,%eax
c0100eb7:	0f b7 c0             	movzwl %ax,%eax
c0100eba:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ebe:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ec2:	89 c2                	mov    %eax,%edx
c0100ec4:	ec                   	in     (%dx),%al
c0100ec5:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100ec8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100ecc:	0f b6 c0             	movzbl %al,%eax
c0100ecf:	c1 e0 08             	shl    $0x8,%eax
c0100ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ed5:	0f b7 05 86 9e 11 c0 	movzwl 0xc0119e86,%eax
c0100edc:	0f b7 c0             	movzwl %ax,%eax
c0100edf:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ee3:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100eeb:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100eef:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100ef0:	0f b7 05 86 9e 11 c0 	movzwl 0xc0119e86,%eax
c0100ef7:	83 c0 01             	add    $0x1,%eax
c0100efa:	0f b7 c0             	movzwl %ax,%eax
c0100efd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f01:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f05:	89 c2                	mov    %eax,%edx
c0100f07:	ec                   	in     (%dx),%al
c0100f08:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f0b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0f:	0f b6 c0             	movzbl %al,%eax
c0100f12:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f18:	a3 80 9e 11 c0       	mov    %eax,0xc0119e80
    crt_pos = pos;
c0100f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f20:	66 a3 84 9e 11 c0    	mov    %ax,0xc0119e84
}
c0100f26:	90                   	nop
c0100f27:	c9                   	leave  
c0100f28:	c3                   	ret    

c0100f29 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f29:	55                   	push   %ebp
c0100f2a:	89 e5                	mov    %esp,%ebp
c0100f2c:	83 ec 28             	sub    $0x28,%esp
c0100f2f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f35:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f39:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f3d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f41:	ee                   	out    %al,(%dx)
c0100f42:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f48:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f4c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f50:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f54:	ee                   	out    %al,(%dx)
c0100f55:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f5b:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f5f:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f67:	ee                   	out    %al,(%dx)
c0100f68:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f6e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f72:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f76:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f7a:	ee                   	out    %al,(%dx)
c0100f7b:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f81:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f85:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
c0100f8e:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f94:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100f98:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100f9c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100fa0:	ee                   	out    %al,(%dx)
c0100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa7:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fab:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb3:	ee                   	out    %al,(%dx)
c0100fb4:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fba:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fbe:	89 c2                	mov    %eax,%edx
c0100fc0:	ec                   	in     (%dx),%al
c0100fc1:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fc8:	3c ff                	cmp    $0xff,%al
c0100fca:	0f 95 c0             	setne  %al
c0100fcd:	0f b6 c0             	movzbl %al,%eax
c0100fd0:	a3 88 9e 11 c0       	mov    %eax,0xc0119e88
c0100fd5:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fdb:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100fdf:	89 c2                	mov    %eax,%edx
c0100fe1:	ec                   	in     (%dx),%al
c0100fe2:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100fe5:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100feb:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0100fef:	89 c2                	mov    %eax,%edx
c0100ff1:	ec                   	in     (%dx),%al
c0100ff2:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100ff5:	a1 88 9e 11 c0       	mov    0xc0119e88,%eax
c0100ffa:	85 c0                	test   %eax,%eax
c0100ffc:	74 0d                	je     c010100b <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0100ffe:	83 ec 0c             	sub    $0xc,%esp
c0101001:	6a 04                	push   $0x4
c0101003:	e8 e8 06 00 00       	call   c01016f0 <pic_enable>
c0101008:	83 c4 10             	add    $0x10,%esp
    }
}
c010100b:	90                   	nop
c010100c:	c9                   	leave  
c010100d:	c3                   	ret    

c010100e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010100e:	55                   	push   %ebp
c010100f:	89 e5                	mov    %esp,%ebp
c0101011:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010101b:	eb 09                	jmp    c0101026 <lpt_putc_sub+0x18>
        delay();
c010101d:	e8 d7 fd ff ff       	call   c0100df9 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101022:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101026:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c010102c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101030:	89 c2                	mov    %eax,%edx
c0101032:	ec                   	in     (%dx),%al
c0101033:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101036:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010103a:	84 c0                	test   %al,%al
c010103c:	78 09                	js     c0101047 <lpt_putc_sub+0x39>
c010103e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101045:	7e d6                	jle    c010101d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101047:	8b 45 08             	mov    0x8(%ebp),%eax
c010104a:	0f b6 c0             	movzbl %al,%eax
c010104d:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101053:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101056:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010105a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010105e:	ee                   	out    %al,(%dx)
c010105f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101065:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101069:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010106d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101071:	ee                   	out    %al,(%dx)
c0101072:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c0101078:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c010107c:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101080:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101084:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101085:	90                   	nop
c0101086:	c9                   	leave  
c0101087:	c3                   	ret    

c0101088 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101088:	55                   	push   %ebp
c0101089:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c010108b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010108f:	74 0d                	je     c010109e <lpt_putc+0x16>
        lpt_putc_sub(c);
c0101091:	ff 75 08             	pushl  0x8(%ebp)
c0101094:	e8 75 ff ff ff       	call   c010100e <lpt_putc_sub>
c0101099:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010109c:	eb 1e                	jmp    c01010bc <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c010109e:	6a 08                	push   $0x8
c01010a0:	e8 69 ff ff ff       	call   c010100e <lpt_putc_sub>
c01010a5:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010a8:	6a 20                	push   $0x20
c01010aa:	e8 5f ff ff ff       	call   c010100e <lpt_putc_sub>
c01010af:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010b2:	6a 08                	push   $0x8
c01010b4:	e8 55 ff ff ff       	call   c010100e <lpt_putc_sub>
c01010b9:	83 c4 04             	add    $0x4,%esp
    }
}
c01010bc:	90                   	nop
c01010bd:	c9                   	leave  
c01010be:	c3                   	ret    

c01010bf <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010bf:	55                   	push   %ebp
c01010c0:	89 e5                	mov    %esp,%ebp
c01010c2:	53                   	push   %ebx
c01010c3:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c9:	b0 00                	mov    $0x0,%al
c01010cb:	85 c0                	test   %eax,%eax
c01010cd:	75 07                	jne    c01010d6 <cga_putc+0x17>
        c |= 0x0700;
c01010cf:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d9:	0f b6 c0             	movzbl %al,%eax
c01010dc:	83 f8 0a             	cmp    $0xa,%eax
c01010df:	74 4e                	je     c010112f <cga_putc+0x70>
c01010e1:	83 f8 0d             	cmp    $0xd,%eax
c01010e4:	74 59                	je     c010113f <cga_putc+0x80>
c01010e6:	83 f8 08             	cmp    $0x8,%eax
c01010e9:	0f 85 8a 00 00 00    	jne    c0101179 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c01010ef:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c01010f6:	66 85 c0             	test   %ax,%ax
c01010f9:	0f 84 a0 00 00 00    	je     c010119f <cga_putc+0xe0>
            crt_pos --;
c01010ff:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c0101106:	83 e8 01             	sub    $0x1,%eax
c0101109:	66 a3 84 9e 11 c0    	mov    %ax,0xc0119e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010110f:	a1 80 9e 11 c0       	mov    0xc0119e80,%eax
c0101114:	0f b7 15 84 9e 11 c0 	movzwl 0xc0119e84,%edx
c010111b:	0f b7 d2             	movzwl %dx,%edx
c010111e:	01 d2                	add    %edx,%edx
c0101120:	01 d0                	add    %edx,%eax
c0101122:	8b 55 08             	mov    0x8(%ebp),%edx
c0101125:	b2 00                	mov    $0x0,%dl
c0101127:	83 ca 20             	or     $0x20,%edx
c010112a:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010112d:	eb 70                	jmp    c010119f <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c010112f:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c0101136:	83 c0 50             	add    $0x50,%eax
c0101139:	66 a3 84 9e 11 c0    	mov    %ax,0xc0119e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010113f:	0f b7 1d 84 9e 11 c0 	movzwl 0xc0119e84,%ebx
c0101146:	0f b7 0d 84 9e 11 c0 	movzwl 0xc0119e84,%ecx
c010114d:	0f b7 c1             	movzwl %cx,%eax
c0101150:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101156:	c1 e8 10             	shr    $0x10,%eax
c0101159:	89 c2                	mov    %eax,%edx
c010115b:	66 c1 ea 06          	shr    $0x6,%dx
c010115f:	89 d0                	mov    %edx,%eax
c0101161:	c1 e0 02             	shl    $0x2,%eax
c0101164:	01 d0                	add    %edx,%eax
c0101166:	c1 e0 04             	shl    $0x4,%eax
c0101169:	29 c1                	sub    %eax,%ecx
c010116b:	89 ca                	mov    %ecx,%edx
c010116d:	89 d8                	mov    %ebx,%eax
c010116f:	29 d0                	sub    %edx,%eax
c0101171:	66 a3 84 9e 11 c0    	mov    %ax,0xc0119e84
        break;
c0101177:	eb 27                	jmp    c01011a0 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101179:	8b 0d 80 9e 11 c0    	mov    0xc0119e80,%ecx
c010117f:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c0101186:	8d 50 01             	lea    0x1(%eax),%edx
c0101189:	66 89 15 84 9e 11 c0 	mov    %dx,0xc0119e84
c0101190:	0f b7 c0             	movzwl %ax,%eax
c0101193:	01 c0                	add    %eax,%eax
c0101195:	01 c8                	add    %ecx,%eax
c0101197:	8b 55 08             	mov    0x8(%ebp),%edx
c010119a:	66 89 10             	mov    %dx,(%eax)
        break;
c010119d:	eb 01                	jmp    c01011a0 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c010119f:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011a0:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c01011a7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ab:	76 59                	jbe    c0101206 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ad:	a1 80 9e 11 c0       	mov    0xc0119e80,%eax
c01011b2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011b8:	a1 80 9e 11 c0       	mov    0xc0119e80,%eax
c01011bd:	83 ec 04             	sub    $0x4,%esp
c01011c0:	68 00 0f 00 00       	push   $0xf00
c01011c5:	52                   	push   %edx
c01011c6:	50                   	push   %eax
c01011c7:	e8 db 4f 00 00       	call   c01061a7 <memmove>
c01011cc:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011cf:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011d6:	eb 15                	jmp    c01011ed <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011d8:	a1 80 9e 11 c0       	mov    0xc0119e80,%eax
c01011dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011e0:	01 d2                	add    %edx,%edx
c01011e2:	01 d0                	add    %edx,%eax
c01011e4:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011ed:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011f4:	7e e2                	jle    c01011d8 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c01011f6:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c01011fd:	83 e8 50             	sub    $0x50,%eax
c0101200:	66 a3 84 9e 11 c0    	mov    %ax,0xc0119e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101206:	0f b7 05 86 9e 11 c0 	movzwl 0xc0119e86,%eax
c010120d:	0f b7 c0             	movzwl %ax,%eax
c0101210:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101214:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101218:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c010121c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101220:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101221:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c0101228:	66 c1 e8 08          	shr    $0x8,%ax
c010122c:	0f b6 c0             	movzbl %al,%eax
c010122f:	0f b7 15 86 9e 11 c0 	movzwl 0xc0119e86,%edx
c0101236:	83 c2 01             	add    $0x1,%edx
c0101239:	0f b7 d2             	movzwl %dx,%edx
c010123c:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101240:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101243:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101247:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010124c:	0f b7 05 86 9e 11 c0 	movzwl 0xc0119e86,%eax
c0101253:	0f b7 c0             	movzwl %ax,%eax
c0101256:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010125a:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c010125e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101262:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101266:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101267:	0f b7 05 84 9e 11 c0 	movzwl 0xc0119e84,%eax
c010126e:	0f b6 c0             	movzbl %al,%eax
c0101271:	0f b7 15 86 9e 11 c0 	movzwl 0xc0119e86,%edx
c0101278:	83 c2 01             	add    $0x1,%edx
c010127b:	0f b7 d2             	movzwl %dx,%edx
c010127e:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101282:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101285:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101289:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
}
c010128e:	90                   	nop
c010128f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101292:	c9                   	leave  
c0101293:	c3                   	ret    

c0101294 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101294:	55                   	push   %ebp
c0101295:	89 e5                	mov    %esp,%ebp
c0101297:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012a1:	eb 09                	jmp    c01012ac <serial_putc_sub+0x18>
        delay();
c01012a3:	e8 51 fb ff ff       	call   c0100df9 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ac:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012b2:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012b6:	89 c2                	mov    %eax,%edx
c01012b8:	ec                   	in     (%dx),%al
c01012b9:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012c0:	0f b6 c0             	movzbl %al,%eax
c01012c3:	83 e0 20             	and    $0x20,%eax
c01012c6:	85 c0                	test   %eax,%eax
c01012c8:	75 09                	jne    c01012d3 <serial_putc_sub+0x3f>
c01012ca:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012d1:	7e d0                	jle    c01012a3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d6:	0f b6 c0             	movzbl %al,%eax
c01012d9:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012df:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012e2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012e6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012ea:	ee                   	out    %al,(%dx)
}
c01012eb:	90                   	nop
c01012ec:	c9                   	leave  
c01012ed:	c3                   	ret    

c01012ee <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012ee:	55                   	push   %ebp
c01012ef:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01012f1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01012f5:	74 0d                	je     c0101304 <serial_putc+0x16>
        serial_putc_sub(c);
c01012f7:	ff 75 08             	pushl  0x8(%ebp)
c01012fa:	e8 95 ff ff ff       	call   c0101294 <serial_putc_sub>
c01012ff:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101302:	eb 1e                	jmp    c0101322 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101304:	6a 08                	push   $0x8
c0101306:	e8 89 ff ff ff       	call   c0101294 <serial_putc_sub>
c010130b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c010130e:	6a 20                	push   $0x20
c0101310:	e8 7f ff ff ff       	call   c0101294 <serial_putc_sub>
c0101315:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101318:	6a 08                	push   $0x8
c010131a:	e8 75 ff ff ff       	call   c0101294 <serial_putc_sub>
c010131f:	83 c4 04             	add    $0x4,%esp
    }
}
c0101322:	90                   	nop
c0101323:	c9                   	leave  
c0101324:	c3                   	ret    

c0101325 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101325:	55                   	push   %ebp
c0101326:	89 e5                	mov    %esp,%ebp
c0101328:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010132b:	eb 33                	jmp    c0101360 <cons_intr+0x3b>
        if (c != 0) {
c010132d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101331:	74 2d                	je     c0101360 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101333:	a1 a4 a0 11 c0       	mov    0xc011a0a4,%eax
c0101338:	8d 50 01             	lea    0x1(%eax),%edx
c010133b:	89 15 a4 a0 11 c0    	mov    %edx,0xc011a0a4
c0101341:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101344:	88 90 a0 9e 11 c0    	mov    %dl,-0x3fee6160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010134a:	a1 a4 a0 11 c0       	mov    0xc011a0a4,%eax
c010134f:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101354:	75 0a                	jne    c0101360 <cons_intr+0x3b>
                cons.wpos = 0;
c0101356:	c7 05 a4 a0 11 c0 00 	movl   $0x0,0xc011a0a4
c010135d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101360:	8b 45 08             	mov    0x8(%ebp),%eax
c0101363:	ff d0                	call   *%eax
c0101365:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101368:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010136c:	75 bf                	jne    c010132d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010136e:	90                   	nop
c010136f:	c9                   	leave  
c0101370:	c3                   	ret    

c0101371 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101371:	55                   	push   %ebp
c0101372:	89 e5                	mov    %esp,%ebp
c0101374:	83 ec 10             	sub    $0x10,%esp
c0101377:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010137d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101381:	89 c2                	mov    %eax,%edx
c0101383:	ec                   	in     (%dx),%al
c0101384:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101387:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010138b:	0f b6 c0             	movzbl %al,%eax
c010138e:	83 e0 01             	and    $0x1,%eax
c0101391:	85 c0                	test   %eax,%eax
c0101393:	75 07                	jne    c010139c <serial_proc_data+0x2b>
        return -1;
c0101395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010139a:	eb 2a                	jmp    c01013c6 <serial_proc_data+0x55>
c010139c:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a6:	89 c2                	mov    %eax,%edx
c01013a8:	ec                   	in     (%dx),%al
c01013a9:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013ac:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013b0:	0f b6 c0             	movzbl %al,%eax
c01013b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013b6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ba:	75 07                	jne    c01013c3 <serial_proc_data+0x52>
        c = '\b';
c01013bc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013c6:	c9                   	leave  
c01013c7:	c3                   	ret    

c01013c8 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013c8:	55                   	push   %ebp
c01013c9:	89 e5                	mov    %esp,%ebp
c01013cb:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013ce:	a1 88 9e 11 c0       	mov    0xc0119e88,%eax
c01013d3:	85 c0                	test   %eax,%eax
c01013d5:	74 10                	je     c01013e7 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013d7:	83 ec 0c             	sub    $0xc,%esp
c01013da:	68 71 13 10 c0       	push   $0xc0101371
c01013df:	e8 41 ff ff ff       	call   c0101325 <cons_intr>
c01013e4:	83 c4 10             	add    $0x10,%esp
    }
}
c01013e7:	90                   	nop
c01013e8:	c9                   	leave  
c01013e9:	c3                   	ret    

c01013ea <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013ea:	55                   	push   %ebp
c01013eb:	89 e5                	mov    %esp,%ebp
c01013ed:	83 ec 18             	sub    $0x18,%esp
c01013f0:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01013fa:	89 c2                	mov    %eax,%edx
c01013fc:	ec                   	in     (%dx),%al
c01013fd:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101400:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101404:	0f b6 c0             	movzbl %al,%eax
c0101407:	83 e0 01             	and    $0x1,%eax
c010140a:	85 c0                	test   %eax,%eax
c010140c:	75 0a                	jne    c0101418 <kbd_proc_data+0x2e>
        return -1;
c010140e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101413:	e9 5d 01 00 00       	jmp    c0101575 <kbd_proc_data+0x18b>
c0101418:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010141e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101422:	89 c2                	mov    %eax,%edx
c0101424:	ec                   	in     (%dx),%al
c0101425:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101428:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c010142c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010142f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101433:	75 17                	jne    c010144c <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101435:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c010143a:	83 c8 40             	or     $0x40,%eax
c010143d:	a3 a8 a0 11 c0       	mov    %eax,0xc011a0a8
        return 0;
c0101442:	b8 00 00 00 00       	mov    $0x0,%eax
c0101447:	e9 29 01 00 00       	jmp    c0101575 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c010144c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101450:	84 c0                	test   %al,%al
c0101452:	79 47                	jns    c010149b <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101454:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c0101459:	83 e0 40             	and    $0x40,%eax
c010145c:	85 c0                	test   %eax,%eax
c010145e:	75 09                	jne    c0101469 <kbd_proc_data+0x7f>
c0101460:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101464:	83 e0 7f             	and    $0x7f,%eax
c0101467:	eb 04                	jmp    c010146d <kbd_proc_data+0x83>
c0101469:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010146d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101474:	0f b6 80 60 90 11 c0 	movzbl -0x3fee6fa0(%eax),%eax
c010147b:	83 c8 40             	or     $0x40,%eax
c010147e:	0f b6 c0             	movzbl %al,%eax
c0101481:	f7 d0                	not    %eax
c0101483:	89 c2                	mov    %eax,%edx
c0101485:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c010148a:	21 d0                	and    %edx,%eax
c010148c:	a3 a8 a0 11 c0       	mov    %eax,0xc011a0a8
        return 0;
c0101491:	b8 00 00 00 00       	mov    $0x0,%eax
c0101496:	e9 da 00 00 00       	jmp    c0101575 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c010149b:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c01014a0:	83 e0 40             	and    $0x40,%eax
c01014a3:	85 c0                	test   %eax,%eax
c01014a5:	74 11                	je     c01014b8 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014a7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ab:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c01014b0:	83 e0 bf             	and    $0xffffffbf,%eax
c01014b3:	a3 a8 a0 11 c0       	mov    %eax,0xc011a0a8
    }

    shift |= shiftcode[data];
c01014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bc:	0f b6 80 60 90 11 c0 	movzbl -0x3fee6fa0(%eax),%eax
c01014c3:	0f b6 d0             	movzbl %al,%edx
c01014c6:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c01014cb:	09 d0                	or     %edx,%eax
c01014cd:	a3 a8 a0 11 c0       	mov    %eax,0xc011a0a8
    shift ^= togglecode[data];
c01014d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d6:	0f b6 80 60 91 11 c0 	movzbl -0x3fee6ea0(%eax),%eax
c01014dd:	0f b6 d0             	movzbl %al,%edx
c01014e0:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c01014e5:	31 d0                	xor    %edx,%eax
c01014e7:	a3 a8 a0 11 c0       	mov    %eax,0xc011a0a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014ec:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c01014f1:	83 e0 03             	and    $0x3,%eax
c01014f4:	8b 14 85 60 95 11 c0 	mov    -0x3fee6aa0(,%eax,4),%edx
c01014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ff:	01 d0                	add    %edx,%eax
c0101501:	0f b6 00             	movzbl (%eax),%eax
c0101504:	0f b6 c0             	movzbl %al,%eax
c0101507:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010150a:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c010150f:	83 e0 08             	and    $0x8,%eax
c0101512:	85 c0                	test   %eax,%eax
c0101514:	74 22                	je     c0101538 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101516:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010151a:	7e 0c                	jle    c0101528 <kbd_proc_data+0x13e>
c010151c:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101520:	7f 06                	jg     c0101528 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101522:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101526:	eb 10                	jmp    c0101538 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101528:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010152c:	7e 0a                	jle    c0101538 <kbd_proc_data+0x14e>
c010152e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101532:	7f 04                	jg     c0101538 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101534:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101538:	a1 a8 a0 11 c0       	mov    0xc011a0a8,%eax
c010153d:	f7 d0                	not    %eax
c010153f:	83 e0 06             	and    $0x6,%eax
c0101542:	85 c0                	test   %eax,%eax
c0101544:	75 2c                	jne    c0101572 <kbd_proc_data+0x188>
c0101546:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010154d:	75 23                	jne    c0101572 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c010154f:	83 ec 0c             	sub    $0xc,%esp
c0101552:	68 1d 6c 10 c0       	push   $0xc0106c1d
c0101557:	e8 0b ed ff ff       	call   c0100267 <cprintf>
c010155c:	83 c4 10             	add    $0x10,%esp
c010155f:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101565:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101569:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010156d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101571:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101572:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101575:	c9                   	leave  
c0101576:	c3                   	ret    

c0101577 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101577:	55                   	push   %ebp
c0101578:	89 e5                	mov    %esp,%ebp
c010157a:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c010157d:	83 ec 0c             	sub    $0xc,%esp
c0101580:	68 ea 13 10 c0       	push   $0xc01013ea
c0101585:	e8 9b fd ff ff       	call   c0101325 <cons_intr>
c010158a:	83 c4 10             	add    $0x10,%esp
}
c010158d:	90                   	nop
c010158e:	c9                   	leave  
c010158f:	c3                   	ret    

c0101590 <kbd_init>:

static void
kbd_init(void) {
c0101590:	55                   	push   %ebp
c0101591:	89 e5                	mov    %esp,%ebp
c0101593:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101596:	e8 dc ff ff ff       	call   c0101577 <kbd_intr>
    pic_enable(IRQ_KBD);
c010159b:	83 ec 0c             	sub    $0xc,%esp
c010159e:	6a 01                	push   $0x1
c01015a0:	e8 4b 01 00 00       	call   c01016f0 <pic_enable>
c01015a5:	83 c4 10             	add    $0x10,%esp
}
c01015a8:	90                   	nop
c01015a9:	c9                   	leave  
c01015aa:	c3                   	ret    

c01015ab <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015ab:	55                   	push   %ebp
c01015ac:	89 e5                	mov    %esp,%ebp
c01015ae:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015b1:	e8 8c f8 ff ff       	call   c0100e42 <cga_init>
    serial_init();
c01015b6:	e8 6e f9 ff ff       	call   c0100f29 <serial_init>
    kbd_init();
c01015bb:	e8 d0 ff ff ff       	call   c0101590 <kbd_init>
    if (!serial_exists) {
c01015c0:	a1 88 9e 11 c0       	mov    0xc0119e88,%eax
c01015c5:	85 c0                	test   %eax,%eax
c01015c7:	75 10                	jne    c01015d9 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015c9:	83 ec 0c             	sub    $0xc,%esp
c01015cc:	68 29 6c 10 c0       	push   $0xc0106c29
c01015d1:	e8 91 ec ff ff       	call   c0100267 <cprintf>
c01015d6:	83 c4 10             	add    $0x10,%esp
    }
}
c01015d9:	90                   	nop
c01015da:	c9                   	leave  
c01015db:	c3                   	ret    

c01015dc <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015dc:	55                   	push   %ebp
c01015dd:	89 e5                	mov    %esp,%ebp
c01015df:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015e2:	e8 d4 f7 ff ff       	call   c0100dbb <__intr_save>
c01015e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015ea:	83 ec 0c             	sub    $0xc,%esp
c01015ed:	ff 75 08             	pushl  0x8(%ebp)
c01015f0:	e8 93 fa ff ff       	call   c0101088 <lpt_putc>
c01015f5:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01015f8:	83 ec 0c             	sub    $0xc,%esp
c01015fb:	ff 75 08             	pushl  0x8(%ebp)
c01015fe:	e8 bc fa ff ff       	call   c01010bf <cga_putc>
c0101603:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101606:	83 ec 0c             	sub    $0xc,%esp
c0101609:	ff 75 08             	pushl  0x8(%ebp)
c010160c:	e8 dd fc ff ff       	call   c01012ee <serial_putc>
c0101611:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101614:	83 ec 0c             	sub    $0xc,%esp
c0101617:	ff 75 f4             	pushl  -0xc(%ebp)
c010161a:	e8 c6 f7 ff ff       	call   c0100de5 <__intr_restore>
c010161f:	83 c4 10             	add    $0x10,%esp
}
c0101622:	90                   	nop
c0101623:	c9                   	leave  
c0101624:	c3                   	ret    

c0101625 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101625:	55                   	push   %ebp
c0101626:	89 e5                	mov    %esp,%ebp
c0101628:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c010162b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101632:	e8 84 f7 ff ff       	call   c0100dbb <__intr_save>
c0101637:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010163a:	e8 89 fd ff ff       	call   c01013c8 <serial_intr>
        kbd_intr();
c010163f:	e8 33 ff ff ff       	call   c0101577 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101644:	8b 15 a0 a0 11 c0    	mov    0xc011a0a0,%edx
c010164a:	a1 a4 a0 11 c0       	mov    0xc011a0a4,%eax
c010164f:	39 c2                	cmp    %eax,%edx
c0101651:	74 31                	je     c0101684 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101653:	a1 a0 a0 11 c0       	mov    0xc011a0a0,%eax
c0101658:	8d 50 01             	lea    0x1(%eax),%edx
c010165b:	89 15 a0 a0 11 c0    	mov    %edx,0xc011a0a0
c0101661:	0f b6 80 a0 9e 11 c0 	movzbl -0x3fee6160(%eax),%eax
c0101668:	0f b6 c0             	movzbl %al,%eax
c010166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010166e:	a1 a0 a0 11 c0       	mov    0xc011a0a0,%eax
c0101673:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101678:	75 0a                	jne    c0101684 <cons_getc+0x5f>
                cons.rpos = 0;
c010167a:	c7 05 a0 a0 11 c0 00 	movl   $0x0,0xc011a0a0
c0101681:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101684:	83 ec 0c             	sub    $0xc,%esp
c0101687:	ff 75 f0             	pushl  -0x10(%ebp)
c010168a:	e8 56 f7 ff ff       	call   c0100de5 <__intr_restore>
c010168f:	83 c4 10             	add    $0x10,%esp
    return c;
c0101692:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101695:	c9                   	leave  
c0101696:	c3                   	ret    

c0101697 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101697:	55                   	push   %ebp
c0101698:	89 e5                	mov    %esp,%ebp
c010169a:	83 ec 14             	sub    $0x14,%esp
c010169d:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016a4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016a8:	66 a3 70 95 11 c0    	mov    %ax,0xc0119570
    if (did_init) {
c01016ae:	a1 ac a0 11 c0       	mov    0xc011a0ac,%eax
c01016b3:	85 c0                	test   %eax,%eax
c01016b5:	74 36                	je     c01016ed <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016b7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016bb:	0f b6 c0             	movzbl %al,%eax
c01016be:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016c4:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016c7:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016cb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016cf:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016d0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d4:	66 c1 e8 08          	shr    $0x8,%ax
c01016d8:	0f b6 c0             	movzbl %al,%eax
c01016db:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016e1:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016e4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01016ec:	ee                   	out    %al,(%dx)
    }
}
c01016ed:	90                   	nop
c01016ee:	c9                   	leave  
c01016ef:	c3                   	ret    

c01016f0 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016f0:	55                   	push   %ebp
c01016f1:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01016f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f6:	ba 01 00 00 00       	mov    $0x1,%edx
c01016fb:	89 c1                	mov    %eax,%ecx
c01016fd:	d3 e2                	shl    %cl,%edx
c01016ff:	89 d0                	mov    %edx,%eax
c0101701:	f7 d0                	not    %eax
c0101703:	89 c2                	mov    %eax,%edx
c0101705:	0f b7 05 70 95 11 c0 	movzwl 0xc0119570,%eax
c010170c:	21 d0                	and    %edx,%eax
c010170e:	0f b7 c0             	movzwl %ax,%eax
c0101711:	50                   	push   %eax
c0101712:	e8 80 ff ff ff       	call   c0101697 <pic_setmask>
c0101717:	83 c4 04             	add    $0x4,%esp
}
c010171a:	90                   	nop
c010171b:	c9                   	leave  
c010171c:	c3                   	ret    

c010171d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010171d:	55                   	push   %ebp
c010171e:	89 e5                	mov    %esp,%ebp
c0101720:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101723:	c7 05 ac a0 11 c0 01 	movl   $0x1,0xc011a0ac
c010172a:	00 00 00 
c010172d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101733:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101737:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c010173b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010173f:	ee                   	out    %al,(%dx)
c0101740:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101746:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c010174a:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010174e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101752:	ee                   	out    %al,(%dx)
c0101753:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101759:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c010175d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101761:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101765:	ee                   	out    %al,(%dx)
c0101766:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c010176c:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101770:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101774:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101778:	ee                   	out    %al,(%dx)
c0101779:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c010177f:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101783:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101787:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010178b:	ee                   	out    %al,(%dx)
c010178c:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101792:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101796:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010179a:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c010179e:	ee                   	out    %al,(%dx)
c010179f:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017a5:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017a9:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017b1:	ee                   	out    %al,(%dx)
c01017b2:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017b8:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017bc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017c0:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
c01017c5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017cb:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017cf:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017d3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017d7:	ee                   	out    %al,(%dx)
c01017d8:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017de:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017e2:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017e6:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017ea:	ee                   	out    %al,(%dx)
c01017eb:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01017f1:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01017f5:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01017f9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fd:	ee                   	out    %al,(%dx)
c01017fe:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0101804:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c0101808:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010180c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101810:	ee                   	out    %al,(%dx)
c0101811:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101817:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c010181b:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c010181f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101823:	ee                   	out    %al,(%dx)
c0101824:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c010182a:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c010182e:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101832:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0101836:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101837:	0f b7 05 70 95 11 c0 	movzwl 0xc0119570,%eax
c010183e:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101842:	74 13                	je     c0101857 <pic_init+0x13a>
        pic_setmask(irq_mask);
c0101844:	0f b7 05 70 95 11 c0 	movzwl 0xc0119570,%eax
c010184b:	0f b7 c0             	movzwl %ax,%eax
c010184e:	50                   	push   %eax
c010184f:	e8 43 fe ff ff       	call   c0101697 <pic_setmask>
c0101854:	83 c4 04             	add    $0x4,%esp
    }
}
c0101857:	90                   	nop
c0101858:	c9                   	leave  
c0101859:	c3                   	ret    

c010185a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010185a:	55                   	push   %ebp
c010185b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010185d:	fb                   	sti    
    sti();
}
c010185e:	90                   	nop
c010185f:	5d                   	pop    %ebp
c0101860:	c3                   	ret    

c0101861 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101861:	55                   	push   %ebp
c0101862:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101864:	fa                   	cli    
    cli();
}
c0101865:	90                   	nop
c0101866:	5d                   	pop    %ebp
c0101867:	c3                   	ret    

c0101868 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101868:	55                   	push   %ebp
c0101869:	89 e5                	mov    %esp,%ebp
c010186b:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010186e:	83 ec 08             	sub    $0x8,%esp
c0101871:	6a 64                	push   $0x64
c0101873:	68 60 6c 10 c0       	push   $0xc0106c60
c0101878:	e8 ea e9 ff ff       	call   c0100267 <cprintf>
c010187d:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101880:	83 ec 0c             	sub    $0xc,%esp
c0101883:	68 6a 6c 10 c0       	push   $0xc0106c6a
c0101888:	e8 da e9 ff ff       	call   c0100267 <cprintf>
c010188d:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c0101890:	83 ec 04             	sub    $0x4,%esp
c0101893:	68 78 6c 10 c0       	push   $0xc0106c78
c0101898:	6a 12                	push   $0x12
c010189a:	68 8e 6c 10 c0       	push   $0xc0106c8e
c010189f:	e8 29 eb ff ff       	call   c01003cd <__panic>

c01018a4 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018a4:	55                   	push   %ebp
c01018a5:	89 e5                	mov    %esp,%ebp
c01018a7:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
c01018aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018b1:	e9 97 01 00 00       	jmp    c0101a4d <idt_init+0x1a9>
//		cprintf("vectors %d: 0x%08x\n", i, __vectors[i]);
		if (i == T_SYSCALL || i == T_SWITCH_TOK) {
c01018b6:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01018bd:	74 0a                	je     c01018c9 <idt_init+0x25>
c01018bf:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
c01018c3:	0f 85 c1 00 00 00    	jne    c010198a <idt_init+0xe6>
			SETGATE(idt[i], 1, KERNEL_CS, __vectors[i], DPL_USER);
c01018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cc:	8b 04 85 00 96 11 c0 	mov    -0x3fee6a00(,%eax,4),%eax
c01018d3:	89 c2                	mov    %eax,%edx
c01018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d8:	66 89 14 c5 c0 a0 11 	mov    %dx,-0x3fee5f40(,%eax,8)
c01018df:	c0 
c01018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e3:	66 c7 04 c5 c2 a0 11 	movw   $0x8,-0x3fee5f3e(,%eax,8)
c01018ea:	c0 08 00 
c01018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f0:	0f b6 14 c5 c4 a0 11 	movzbl -0x3fee5f3c(,%eax,8),%edx
c01018f7:	c0 
c01018f8:	83 e2 e0             	and    $0xffffffe0,%edx
c01018fb:	88 14 c5 c4 a0 11 c0 	mov    %dl,-0x3fee5f3c(,%eax,8)
c0101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101905:	0f b6 14 c5 c4 a0 11 	movzbl -0x3fee5f3c(,%eax,8),%edx
c010190c:	c0 
c010190d:	83 e2 1f             	and    $0x1f,%edx
c0101910:	88 14 c5 c4 a0 11 c0 	mov    %dl,-0x3fee5f3c(,%eax,8)
c0101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191a:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c0101921:	c0 
c0101922:	83 ca 0f             	or     $0xf,%edx
c0101925:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c010192c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192f:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c0101936:	c0 
c0101937:	83 e2 ef             	and    $0xffffffef,%edx
c010193a:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c0101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101944:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c010194b:	c0 
c010194c:	83 ca 60             	or     $0x60,%edx
c010194f:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c0101956:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101959:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c0101960:	c0 
c0101961:	83 ca 80             	or     $0xffffff80,%edx
c0101964:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c010196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196e:	8b 04 85 00 96 11 c0 	mov    -0x3fee6a00(,%eax,4),%eax
c0101975:	c1 e8 10             	shr    $0x10,%eax
c0101978:	89 c2                	mov    %eax,%edx
c010197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197d:	66 89 14 c5 c6 a0 11 	mov    %dx,-0x3fee5f3a(,%eax,8)
c0101984:	c0 
c0101985:	e9 bf 00 00 00       	jmp    c0101a49 <idt_init+0x1a5>
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
c010198a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198d:	8b 04 85 00 96 11 c0 	mov    -0x3fee6a00(,%eax,4),%eax
c0101994:	89 c2                	mov    %eax,%edx
c0101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101999:	66 89 14 c5 c0 a0 11 	mov    %dx,-0x3fee5f40(,%eax,8)
c01019a0:	c0 
c01019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a4:	66 c7 04 c5 c2 a0 11 	movw   $0x8,-0x3fee5f3e(,%eax,8)
c01019ab:	c0 08 00 
c01019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b1:	0f b6 14 c5 c4 a0 11 	movzbl -0x3fee5f3c(,%eax,8),%edx
c01019b8:	c0 
c01019b9:	83 e2 e0             	and    $0xffffffe0,%edx
c01019bc:	88 14 c5 c4 a0 11 c0 	mov    %dl,-0x3fee5f3c(,%eax,8)
c01019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c6:	0f b6 14 c5 c4 a0 11 	movzbl -0x3fee5f3c(,%eax,8),%edx
c01019cd:	c0 
c01019ce:	83 e2 1f             	and    $0x1f,%edx
c01019d1:	88 14 c5 c4 a0 11 c0 	mov    %dl,-0x3fee5f3c(,%eax,8)
c01019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019db:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c01019e2:	c0 
c01019e3:	83 e2 f0             	and    $0xfffffff0,%edx
c01019e6:	83 ca 0e             	or     $0xe,%edx
c01019e9:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c01019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f3:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c01019fa:	c0 
c01019fb:	83 e2 ef             	and    $0xffffffef,%edx
c01019fe:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c0101a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a08:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c0101a0f:	c0 
c0101a10:	83 e2 9f             	and    $0xffffff9f,%edx
c0101a13:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c0101a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1d:	0f b6 14 c5 c5 a0 11 	movzbl -0x3fee5f3b(,%eax,8),%edx
c0101a24:	c0 
c0101a25:	83 ca 80             	or     $0xffffff80,%edx
c0101a28:	88 14 c5 c5 a0 11 c0 	mov    %dl,-0x3fee5f3b(,%eax,8)
c0101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a32:	8b 04 85 00 96 11 c0 	mov    -0x3fee6a00(,%eax,4),%eax
c0101a39:	c1 e8 10             	shr    $0x10,%eax
c0101a3c:	89 c2                	mov    %eax,%edx
c0101a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a41:	66 89 14 c5 c6 a0 11 	mov    %dx,-0x3fee5f3a(,%eax,8)
c0101a48:	c0 
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
c0101a49:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a4d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a54:	0f 8e 5c fe ff ff    	jle    c01018b6 <idt_init+0x12>
c0101a5a:	c7 45 f8 80 95 11 c0 	movl   $0xc0119580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a61:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a64:	0f 01 18             	lidtl  (%eax)
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
		}
	}
	lidt(&idt_pd);
}
c0101a67:	90                   	nop
c0101a68:	c9                   	leave  
c0101a69:	c3                   	ret    

c0101a6a <trapname>:

static const char *
trapname(int trapno) {
c0101a6a:	55                   	push   %ebp
c0101a6b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a70:	83 f8 13             	cmp    $0x13,%eax
c0101a73:	77 0c                	ja     c0101a81 <trapname+0x17>
        return excnames[trapno];
c0101a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a78:	8b 04 85 00 70 10 c0 	mov    -0x3fef9000(,%eax,4),%eax
c0101a7f:	eb 18                	jmp    c0101a99 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a81:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a85:	7e 0d                	jle    c0101a94 <trapname+0x2a>
c0101a87:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a8b:	7f 07                	jg     c0101a94 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a8d:	b8 9f 6c 10 c0       	mov    $0xc0106c9f,%eax
c0101a92:	eb 05                	jmp    c0101a99 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a94:	b8 b2 6c 10 c0       	mov    $0xc0106cb2,%eax
}
c0101a99:	5d                   	pop    %ebp
c0101a9a:	c3                   	ret    

c0101a9b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a9b:	55                   	push   %ebp
c0101a9c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101aa5:	66 83 f8 08          	cmp    $0x8,%ax
c0101aa9:	0f 94 c0             	sete   %al
c0101aac:	0f b6 c0             	movzbl %al,%eax
}
c0101aaf:	5d                   	pop    %ebp
c0101ab0:	c3                   	ret    

c0101ab1 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101ab1:	55                   	push   %ebp
c0101ab2:	89 e5                	mov    %esp,%ebp
c0101ab4:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101ab7:	83 ec 08             	sub    $0x8,%esp
c0101aba:	ff 75 08             	pushl  0x8(%ebp)
c0101abd:	68 f3 6c 10 c0       	push   $0xc0106cf3
c0101ac2:	e8 a0 e7 ff ff       	call   c0100267 <cprintf>
c0101ac7:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acd:	83 ec 0c             	sub    $0xc,%esp
c0101ad0:	50                   	push   %eax
c0101ad1:	e8 b8 01 00 00       	call   c0101c8e <print_regs>
c0101ad6:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ae0:	0f b7 c0             	movzwl %ax,%eax
c0101ae3:	83 ec 08             	sub    $0x8,%esp
c0101ae6:	50                   	push   %eax
c0101ae7:	68 04 6d 10 c0       	push   $0xc0106d04
c0101aec:	e8 76 e7 ff ff       	call   c0100267 <cprintf>
c0101af1:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101afb:	0f b7 c0             	movzwl %ax,%eax
c0101afe:	83 ec 08             	sub    $0x8,%esp
c0101b01:	50                   	push   %eax
c0101b02:	68 17 6d 10 c0       	push   $0xc0106d17
c0101b07:	e8 5b e7 ff ff       	call   c0100267 <cprintf>
c0101b0c:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b12:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b16:	0f b7 c0             	movzwl %ax,%eax
c0101b19:	83 ec 08             	sub    $0x8,%esp
c0101b1c:	50                   	push   %eax
c0101b1d:	68 2a 6d 10 c0       	push   $0xc0106d2a
c0101b22:	e8 40 e7 ff ff       	call   c0100267 <cprintf>
c0101b27:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b31:	0f b7 c0             	movzwl %ax,%eax
c0101b34:	83 ec 08             	sub    $0x8,%esp
c0101b37:	50                   	push   %eax
c0101b38:	68 3d 6d 10 c0       	push   $0xc0106d3d
c0101b3d:	e8 25 e7 ff ff       	call   c0100267 <cprintf>
c0101b42:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b48:	8b 40 30             	mov    0x30(%eax),%eax
c0101b4b:	83 ec 0c             	sub    $0xc,%esp
c0101b4e:	50                   	push   %eax
c0101b4f:	e8 16 ff ff ff       	call   c0101a6a <trapname>
c0101b54:	83 c4 10             	add    $0x10,%esp
c0101b57:	89 c2                	mov    %eax,%edx
c0101b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5c:	8b 40 30             	mov    0x30(%eax),%eax
c0101b5f:	83 ec 04             	sub    $0x4,%esp
c0101b62:	52                   	push   %edx
c0101b63:	50                   	push   %eax
c0101b64:	68 50 6d 10 c0       	push   $0xc0106d50
c0101b69:	e8 f9 e6 ff ff       	call   c0100267 <cprintf>
c0101b6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b74:	8b 40 34             	mov    0x34(%eax),%eax
c0101b77:	83 ec 08             	sub    $0x8,%esp
c0101b7a:	50                   	push   %eax
c0101b7b:	68 62 6d 10 c0       	push   $0xc0106d62
c0101b80:	e8 e2 e6 ff ff       	call   c0100267 <cprintf>
c0101b85:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8b:	8b 40 38             	mov    0x38(%eax),%eax
c0101b8e:	83 ec 08             	sub    $0x8,%esp
c0101b91:	50                   	push   %eax
c0101b92:	68 71 6d 10 c0       	push   $0xc0106d71
c0101b97:	e8 cb e6 ff ff       	call   c0100267 <cprintf>
c0101b9c:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ba6:	0f b7 c0             	movzwl %ax,%eax
c0101ba9:	83 ec 08             	sub    $0x8,%esp
c0101bac:	50                   	push   %eax
c0101bad:	68 80 6d 10 c0       	push   $0xc0106d80
c0101bb2:	e8 b0 e6 ff ff       	call   c0100267 <cprintf>
c0101bb7:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbd:	8b 40 40             	mov    0x40(%eax),%eax
c0101bc0:	83 ec 08             	sub    $0x8,%esp
c0101bc3:	50                   	push   %eax
c0101bc4:	68 93 6d 10 c0       	push   $0xc0106d93
c0101bc9:	e8 99 e6 ff ff       	call   c0100267 <cprintf>
c0101bce:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bd8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bdf:	eb 3f                	jmp    c0101c20 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 50 40             	mov    0x40(%eax),%edx
c0101be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bea:	21 d0                	and    %edx,%eax
c0101bec:	85 c0                	test   %eax,%eax
c0101bee:	74 29                	je     c0101c19 <print_trapframe+0x168>
c0101bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf3:	8b 04 85 a0 95 11 c0 	mov    -0x3fee6a60(,%eax,4),%eax
c0101bfa:	85 c0                	test   %eax,%eax
c0101bfc:	74 1b                	je     c0101c19 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c01:	8b 04 85 a0 95 11 c0 	mov    -0x3fee6a60(,%eax,4),%eax
c0101c08:	83 ec 08             	sub    $0x8,%esp
c0101c0b:	50                   	push   %eax
c0101c0c:	68 a2 6d 10 c0       	push   $0xc0106da2
c0101c11:	e8 51 e6 ff ff       	call   c0100267 <cprintf>
c0101c16:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c1d:	d1 65 f0             	shll   -0x10(%ebp)
c0101c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c23:	83 f8 17             	cmp    $0x17,%eax
c0101c26:	76 b9                	jbe    c0101be1 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2b:	8b 40 40             	mov    0x40(%eax),%eax
c0101c2e:	25 00 30 00 00       	and    $0x3000,%eax
c0101c33:	c1 e8 0c             	shr    $0xc,%eax
c0101c36:	83 ec 08             	sub    $0x8,%esp
c0101c39:	50                   	push   %eax
c0101c3a:	68 a6 6d 10 c0       	push   $0xc0106da6
c0101c3f:	e8 23 e6 ff ff       	call   c0100267 <cprintf>
c0101c44:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101c47:	83 ec 0c             	sub    $0xc,%esp
c0101c4a:	ff 75 08             	pushl  0x8(%ebp)
c0101c4d:	e8 49 fe ff ff       	call   c0101a9b <trap_in_kernel>
c0101c52:	83 c4 10             	add    $0x10,%esp
c0101c55:	85 c0                	test   %eax,%eax
c0101c57:	75 32                	jne    c0101c8b <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5c:	8b 40 44             	mov    0x44(%eax),%eax
c0101c5f:	83 ec 08             	sub    $0x8,%esp
c0101c62:	50                   	push   %eax
c0101c63:	68 af 6d 10 c0       	push   $0xc0106daf
c0101c68:	e8 fa e5 ff ff       	call   c0100267 <cprintf>
c0101c6d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c73:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c77:	0f b7 c0             	movzwl %ax,%eax
c0101c7a:	83 ec 08             	sub    $0x8,%esp
c0101c7d:	50                   	push   %eax
c0101c7e:	68 be 6d 10 c0       	push   $0xc0106dbe
c0101c83:	e8 df e5 ff ff       	call   c0100267 <cprintf>
c0101c88:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c8b:	90                   	nop
c0101c8c:	c9                   	leave  
c0101c8d:	c3                   	ret    

c0101c8e <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c8e:	55                   	push   %ebp
c0101c8f:	89 e5                	mov    %esp,%ebp
c0101c91:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c97:	8b 00                	mov    (%eax),%eax
c0101c99:	83 ec 08             	sub    $0x8,%esp
c0101c9c:	50                   	push   %eax
c0101c9d:	68 d1 6d 10 c0       	push   $0xc0106dd1
c0101ca2:	e8 c0 e5 ff ff       	call   c0100267 <cprintf>
c0101ca7:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cad:	8b 40 04             	mov    0x4(%eax),%eax
c0101cb0:	83 ec 08             	sub    $0x8,%esp
c0101cb3:	50                   	push   %eax
c0101cb4:	68 e0 6d 10 c0       	push   $0xc0106de0
c0101cb9:	e8 a9 e5 ff ff       	call   c0100267 <cprintf>
c0101cbe:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc4:	8b 40 08             	mov    0x8(%eax),%eax
c0101cc7:	83 ec 08             	sub    $0x8,%esp
c0101cca:	50                   	push   %eax
c0101ccb:	68 ef 6d 10 c0       	push   $0xc0106def
c0101cd0:	e8 92 e5 ff ff       	call   c0100267 <cprintf>
c0101cd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdb:	8b 40 0c             	mov    0xc(%eax),%eax
c0101cde:	83 ec 08             	sub    $0x8,%esp
c0101ce1:	50                   	push   %eax
c0101ce2:	68 fe 6d 10 c0       	push   $0xc0106dfe
c0101ce7:	e8 7b e5 ff ff       	call   c0100267 <cprintf>
c0101cec:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf2:	8b 40 10             	mov    0x10(%eax),%eax
c0101cf5:	83 ec 08             	sub    $0x8,%esp
c0101cf8:	50                   	push   %eax
c0101cf9:	68 0d 6e 10 c0       	push   $0xc0106e0d
c0101cfe:	e8 64 e5 ff ff       	call   c0100267 <cprintf>
c0101d03:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d09:	8b 40 14             	mov    0x14(%eax),%eax
c0101d0c:	83 ec 08             	sub    $0x8,%esp
c0101d0f:	50                   	push   %eax
c0101d10:	68 1c 6e 10 c0       	push   $0xc0106e1c
c0101d15:	e8 4d e5 ff ff       	call   c0100267 <cprintf>
c0101d1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d20:	8b 40 18             	mov    0x18(%eax),%eax
c0101d23:	83 ec 08             	sub    $0x8,%esp
c0101d26:	50                   	push   %eax
c0101d27:	68 2b 6e 10 c0       	push   $0xc0106e2b
c0101d2c:	e8 36 e5 ff ff       	call   c0100267 <cprintf>
c0101d31:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d37:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d3a:	83 ec 08             	sub    $0x8,%esp
c0101d3d:	50                   	push   %eax
c0101d3e:	68 3a 6e 10 c0       	push   $0xc0106e3a
c0101d43:	e8 1f e5 ff ff       	call   c0100267 <cprintf>
c0101d48:	83 c4 10             	add    $0x10,%esp
}
c0101d4b:	90                   	nop
c0101d4c:	c9                   	leave  
c0101d4d:	c3                   	ret    

c0101d4e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d4e:	55                   	push   %ebp
c0101d4f:	89 e5                	mov    %esp,%ebp
c0101d51:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d57:	8b 40 30             	mov    0x30(%eax),%eax
c0101d5a:	83 f8 2f             	cmp    $0x2f,%eax
c0101d5d:	77 21                	ja     c0101d80 <trap_dispatch+0x32>
c0101d5f:	83 f8 2e             	cmp    $0x2e,%eax
c0101d62:	0f 83 32 02 00 00    	jae    c0101f9a <trap_dispatch+0x24c>
c0101d68:	83 f8 21             	cmp    $0x21,%eax
c0101d6b:	0f 84 87 00 00 00    	je     c0101df8 <trap_dispatch+0xaa>
c0101d71:	83 f8 24             	cmp    $0x24,%eax
c0101d74:	74 5b                	je     c0101dd1 <trap_dispatch+0x83>
c0101d76:	83 f8 20             	cmp    $0x20,%eax
c0101d79:	74 1c                	je     c0101d97 <trap_dispatch+0x49>
c0101d7b:	e9 e4 01 00 00       	jmp    c0101f64 <trap_dispatch+0x216>
c0101d80:	83 f8 78             	cmp    $0x78,%eax
c0101d83:	0f 84 4c 01 00 00    	je     c0101ed5 <trap_dispatch+0x187>
c0101d89:	83 f8 79             	cmp    $0x79,%eax
c0101d8c:	0f 84 95 01 00 00    	je     c0101f27 <trap_dispatch+0x1d9>
c0101d92:	e9 cd 01 00 00       	jmp    c0101f64 <trap_dispatch+0x216>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
c0101d97:	a1 58 a9 11 c0       	mov    0xc011a958,%eax
c0101d9c:	83 c0 01             	add    $0x1,%eax
c0101d9f:	a3 58 a9 11 c0       	mov    %eax,0xc011a958
		if (ticks % TICK_NUM == 0) {
c0101da4:	8b 0d 58 a9 11 c0    	mov    0xc011a958,%ecx
c0101daa:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101daf:	89 c8                	mov    %ecx,%eax
c0101db1:	f7 e2                	mul    %edx
c0101db3:	89 d0                	mov    %edx,%eax
c0101db5:	c1 e8 05             	shr    $0x5,%eax
c0101db8:	6b c0 64             	imul   $0x64,%eax,%eax
c0101dbb:	29 c1                	sub    %eax,%ecx
c0101dbd:	89 c8                	mov    %ecx,%eax
c0101dbf:	85 c0                	test   %eax,%eax
c0101dc1:	0f 85 d6 01 00 00    	jne    c0101f9d <trap_dispatch+0x24f>
			print_ticks();
c0101dc7:	e8 9c fa ff ff       	call   c0101868 <print_ticks>
		}
        break;
c0101dcc:	e9 cc 01 00 00       	jmp    c0101f9d <trap_dispatch+0x24f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101dd1:	e8 4f f8 ff ff       	call   c0101625 <cons_getc>
c0101dd6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101dd9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ddd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101de1:	83 ec 04             	sub    $0x4,%esp
c0101de4:	52                   	push   %edx
c0101de5:	50                   	push   %eax
c0101de6:	68 49 6e 10 c0       	push   $0xc0106e49
c0101deb:	e8 77 e4 ff ff       	call   c0100267 <cprintf>
c0101df0:	83 c4 10             	add    $0x10,%esp
        break;
c0101df3:	e9 af 01 00 00       	jmp    c0101fa7 <trap_dispatch+0x259>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101df8:	e8 28 f8 ff ff       	call   c0101625 <cons_getc>
c0101dfd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e00:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e04:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e08:	83 ec 04             	sub    $0x4,%esp
c0101e0b:	52                   	push   %edx
c0101e0c:	50                   	push   %eax
c0101e0d:	68 5b 6e 10 c0       	push   $0xc0106e5b
c0101e12:	e8 50 e4 ff ff       	call   c0100267 <cprintf>
c0101e17:	83 c4 10             	add    $0x10,%esp
        if (c == '0') {
c0101e1a:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
c0101e1e:	75 46                	jne    c0101e66 <trap_dispatch+0x118>
        	cprintf("Now switched to kernel mode");
c0101e20:	83 ec 0c             	sub    $0xc,%esp
c0101e23:	68 6a 6e 10 c0       	push   $0xc0106e6a
c0101e28:	e8 3a e4 ff ff       	call   c0100267 <cprintf>
c0101e2d:	83 c4 10             	add    $0x10,%esp
        	if (tf->tf_cs != KERNEL_CS) {
c0101e30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e33:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e37:	66 83 f8 08          	cmp    $0x8,%ax
c0101e3b:	0f 84 5f 01 00 00    	je     c0101fa0 <trap_dispatch+0x252>
				tf->tf_cs = KERNEL_CS;
c0101e41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e44:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
				tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4d:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101e53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e56:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_cs = USER_CS;
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
				tf->tf_eflags |= FL_IOPL_MASK;
			}
        }
        break;
c0101e61:	e9 3a 01 00 00       	jmp    c0101fa0 <trap_dispatch+0x252>
        	cprintf("Now switched to kernel mode");
        	if (tf->tf_cs != KERNEL_CS) {
				tf->tf_cs = KERNEL_CS;
				tf->tf_ds = tf->tf_es = KERNEL_DS;
			}
        } else if (c == '3') {
c0101e66:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
c0101e6a:	0f 85 30 01 00 00    	jne    c0101fa0 <trap_dispatch+0x252>
        	cprintf("Now switched to user mode");
c0101e70:	83 ec 0c             	sub    $0xc,%esp
c0101e73:	68 86 6e 10 c0       	push   $0xc0106e86
c0101e78:	e8 ea e3 ff ff       	call   c0100267 <cprintf>
c0101e7d:	83 c4 10             	add    $0x10,%esp
        	if (tf->tf_cs != USER_CS) {
c0101e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e83:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e87:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101e8b:	0f 84 0f 01 00 00    	je     c0101fa0 <trap_dispatch+0x252>
				tf->tf_cs = USER_CS;
c0101e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e94:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9d:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ead:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags |= FL_IOPL_MASK;
c0101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec2:	8b 40 40             	mov    0x40(%eax),%eax
c0101ec5:	80 cc 30             	or     $0x30,%ah
c0101ec8:	89 c2                	mov    %eax,%edx
c0101eca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecd:	89 50 40             	mov    %edx,0x40(%eax)
			}
        }
        break;
c0101ed0:	e9 cb 00 00 00       	jmp    c0101fa0 <trap_dispatch+0x252>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101edc:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101ee0:	0f 84 bd 00 00 00    	je     c0101fa3 <trap_dispatch+0x255>
            tf->tf_cs = USER_CS;
c0101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee9:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0101eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef2:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efb:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f02:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f09:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f10:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
c0101f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f17:	8b 40 40             	mov    0x40(%eax),%eax
c0101f1a:	80 cc 30             	or     $0x30,%ah
c0101f1d:	89 c2                	mov    %eax,%edx
c0101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f22:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101f25:	eb 7c                	jmp    c0101fa3 <trap_dispatch+0x255>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f2e:	66 83 f8 08          	cmp    $0x8,%ax
c0101f32:	74 72                	je     c0101fa6 <trap_dispatch+0x258>
            tf->tf_cs = KERNEL_CS;
c0101f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f37:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
c0101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f40:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f49:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f50:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f57:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        break;
c0101f62:	eb 42                	jmp    c0101fa6 <trap_dispatch+0x258>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f6b:	0f b7 c0             	movzwl %ax,%eax
c0101f6e:	83 e0 03             	and    $0x3,%eax
c0101f71:	85 c0                	test   %eax,%eax
c0101f73:	75 32                	jne    c0101fa7 <trap_dispatch+0x259>
            print_trapframe(tf);
c0101f75:	83 ec 0c             	sub    $0xc,%esp
c0101f78:	ff 75 08             	pushl  0x8(%ebp)
c0101f7b:	e8 31 fb ff ff       	call   c0101ab1 <print_trapframe>
c0101f80:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101f83:	83 ec 04             	sub    $0x4,%esp
c0101f86:	68 a0 6e 10 c0       	push   $0xc0106ea0
c0101f8b:	68 d1 00 00 00       	push   $0xd1
c0101f90:	68 8e 6c 10 c0       	push   $0xc0106c8e
c0101f95:	e8 33 e4 ff ff       	call   c01003cd <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101f9a:	90                   	nop
c0101f9b:	eb 0a                	jmp    c0101fa7 <trap_dispatch+0x259>
         */
		ticks ++;
		if (ticks % TICK_NUM == 0) {
			print_ticks();
		}
        break;
c0101f9d:	90                   	nop
c0101f9e:	eb 07                	jmp    c0101fa7 <trap_dispatch+0x259>
				tf->tf_cs = USER_CS;
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
				tf->tf_eflags |= FL_IOPL_MASK;
			}
        }
        break;
c0101fa0:	90                   	nop
c0101fa1:	eb 04                	jmp    c0101fa7 <trap_dispatch+0x259>
        if (tf->tf_cs != USER_CS) {
            tf->tf_cs = USER_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
            tf->tf_eflags |= FL_IOPL_MASK;
        }
        break;
c0101fa3:	90                   	nop
c0101fa4:	eb 01                	jmp    c0101fa7 <trap_dispatch+0x259>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
        }
        break;
c0101fa6:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101fa7:	90                   	nop
c0101fa8:	c9                   	leave  
c0101fa9:	c3                   	ret    

c0101faa <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101faa:	55                   	push   %ebp
c0101fab:	89 e5                	mov    %esp,%ebp
c0101fad:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101fb0:	83 ec 0c             	sub    $0xc,%esp
c0101fb3:	ff 75 08             	pushl  0x8(%ebp)
c0101fb6:	e8 93 fd ff ff       	call   c0101d4e <trap_dispatch>
c0101fbb:	83 c4 10             	add    $0x10,%esp
}
c0101fbe:	90                   	nop
c0101fbf:	c9                   	leave  
c0101fc0:	c3                   	ret    

c0101fc1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101fc1:	6a 00                	push   $0x0
  pushl $0
c0101fc3:	6a 00                	push   $0x0
  jmp __alltraps
c0101fc5:	e9 67 0a 00 00       	jmp    c0102a31 <__alltraps>

c0101fca <vector1>:
.globl vector1
vector1:
  pushl $0
c0101fca:	6a 00                	push   $0x0
  pushl $1
c0101fcc:	6a 01                	push   $0x1
  jmp __alltraps
c0101fce:	e9 5e 0a 00 00       	jmp    c0102a31 <__alltraps>

c0101fd3 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101fd3:	6a 00                	push   $0x0
  pushl $2
c0101fd5:	6a 02                	push   $0x2
  jmp __alltraps
c0101fd7:	e9 55 0a 00 00       	jmp    c0102a31 <__alltraps>

c0101fdc <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fdc:	6a 00                	push   $0x0
  pushl $3
c0101fde:	6a 03                	push   $0x3
  jmp __alltraps
c0101fe0:	e9 4c 0a 00 00       	jmp    c0102a31 <__alltraps>

c0101fe5 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fe5:	6a 00                	push   $0x0
  pushl $4
c0101fe7:	6a 04                	push   $0x4
  jmp __alltraps
c0101fe9:	e9 43 0a 00 00       	jmp    c0102a31 <__alltraps>

c0101fee <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fee:	6a 00                	push   $0x0
  pushl $5
c0101ff0:	6a 05                	push   $0x5
  jmp __alltraps
c0101ff2:	e9 3a 0a 00 00       	jmp    c0102a31 <__alltraps>

c0101ff7 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101ff7:	6a 00                	push   $0x0
  pushl $6
c0101ff9:	6a 06                	push   $0x6
  jmp __alltraps
c0101ffb:	e9 31 0a 00 00       	jmp    c0102a31 <__alltraps>

c0102000 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102000:	6a 00                	push   $0x0
  pushl $7
c0102002:	6a 07                	push   $0x7
  jmp __alltraps
c0102004:	e9 28 0a 00 00       	jmp    c0102a31 <__alltraps>

c0102009 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102009:	6a 08                	push   $0x8
  jmp __alltraps
c010200b:	e9 21 0a 00 00       	jmp    c0102a31 <__alltraps>

c0102010 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102010:	6a 09                	push   $0x9
  jmp __alltraps
c0102012:	e9 1a 0a 00 00       	jmp    c0102a31 <__alltraps>

c0102017 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102017:	6a 0a                	push   $0xa
  jmp __alltraps
c0102019:	e9 13 0a 00 00       	jmp    c0102a31 <__alltraps>

c010201e <vector11>:
.globl vector11
vector11:
  pushl $11
c010201e:	6a 0b                	push   $0xb
  jmp __alltraps
c0102020:	e9 0c 0a 00 00       	jmp    c0102a31 <__alltraps>

c0102025 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102025:	6a 0c                	push   $0xc
  jmp __alltraps
c0102027:	e9 05 0a 00 00       	jmp    c0102a31 <__alltraps>

c010202c <vector13>:
.globl vector13
vector13:
  pushl $13
c010202c:	6a 0d                	push   $0xd
  jmp __alltraps
c010202e:	e9 fe 09 00 00       	jmp    c0102a31 <__alltraps>

c0102033 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102033:	6a 0e                	push   $0xe
  jmp __alltraps
c0102035:	e9 f7 09 00 00       	jmp    c0102a31 <__alltraps>

c010203a <vector15>:
.globl vector15
vector15:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $15
c010203c:	6a 0f                	push   $0xf
  jmp __alltraps
c010203e:	e9 ee 09 00 00       	jmp    c0102a31 <__alltraps>

c0102043 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $16
c0102045:	6a 10                	push   $0x10
  jmp __alltraps
c0102047:	e9 e5 09 00 00       	jmp    c0102a31 <__alltraps>

c010204c <vector17>:
.globl vector17
vector17:
  pushl $17
c010204c:	6a 11                	push   $0x11
  jmp __alltraps
c010204e:	e9 de 09 00 00       	jmp    c0102a31 <__alltraps>

c0102053 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102053:	6a 00                	push   $0x0
  pushl $18
c0102055:	6a 12                	push   $0x12
  jmp __alltraps
c0102057:	e9 d5 09 00 00       	jmp    c0102a31 <__alltraps>

c010205c <vector19>:
.globl vector19
vector19:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $19
c010205e:	6a 13                	push   $0x13
  jmp __alltraps
c0102060:	e9 cc 09 00 00       	jmp    c0102a31 <__alltraps>

c0102065 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102065:	6a 00                	push   $0x0
  pushl $20
c0102067:	6a 14                	push   $0x14
  jmp __alltraps
c0102069:	e9 c3 09 00 00       	jmp    c0102a31 <__alltraps>

c010206e <vector21>:
.globl vector21
vector21:
  pushl $0
c010206e:	6a 00                	push   $0x0
  pushl $21
c0102070:	6a 15                	push   $0x15
  jmp __alltraps
c0102072:	e9 ba 09 00 00       	jmp    c0102a31 <__alltraps>

c0102077 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102077:	6a 00                	push   $0x0
  pushl $22
c0102079:	6a 16                	push   $0x16
  jmp __alltraps
c010207b:	e9 b1 09 00 00       	jmp    c0102a31 <__alltraps>

c0102080 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $23
c0102082:	6a 17                	push   $0x17
  jmp __alltraps
c0102084:	e9 a8 09 00 00       	jmp    c0102a31 <__alltraps>

c0102089 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102089:	6a 00                	push   $0x0
  pushl $24
c010208b:	6a 18                	push   $0x18
  jmp __alltraps
c010208d:	e9 9f 09 00 00       	jmp    c0102a31 <__alltraps>

c0102092 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102092:	6a 00                	push   $0x0
  pushl $25
c0102094:	6a 19                	push   $0x19
  jmp __alltraps
c0102096:	e9 96 09 00 00       	jmp    c0102a31 <__alltraps>

c010209b <vector26>:
.globl vector26
vector26:
  pushl $0
c010209b:	6a 00                	push   $0x0
  pushl $26
c010209d:	6a 1a                	push   $0x1a
  jmp __alltraps
c010209f:	e9 8d 09 00 00       	jmp    c0102a31 <__alltraps>

c01020a4 <vector27>:
.globl vector27
vector27:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $27
c01020a6:	6a 1b                	push   $0x1b
  jmp __alltraps
c01020a8:	e9 84 09 00 00       	jmp    c0102a31 <__alltraps>

c01020ad <vector28>:
.globl vector28
vector28:
  pushl $0
c01020ad:	6a 00                	push   $0x0
  pushl $28
c01020af:	6a 1c                	push   $0x1c
  jmp __alltraps
c01020b1:	e9 7b 09 00 00       	jmp    c0102a31 <__alltraps>

c01020b6 <vector29>:
.globl vector29
vector29:
  pushl $0
c01020b6:	6a 00                	push   $0x0
  pushl $29
c01020b8:	6a 1d                	push   $0x1d
  jmp __alltraps
c01020ba:	e9 72 09 00 00       	jmp    c0102a31 <__alltraps>

c01020bf <vector30>:
.globl vector30
vector30:
  pushl $0
c01020bf:	6a 00                	push   $0x0
  pushl $30
c01020c1:	6a 1e                	push   $0x1e
  jmp __alltraps
c01020c3:	e9 69 09 00 00       	jmp    c0102a31 <__alltraps>

c01020c8 <vector31>:
.globl vector31
vector31:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $31
c01020ca:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020cc:	e9 60 09 00 00       	jmp    c0102a31 <__alltraps>

c01020d1 <vector32>:
.globl vector32
vector32:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $32
c01020d3:	6a 20                	push   $0x20
  jmp __alltraps
c01020d5:	e9 57 09 00 00       	jmp    c0102a31 <__alltraps>

c01020da <vector33>:
.globl vector33
vector33:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $33
c01020dc:	6a 21                	push   $0x21
  jmp __alltraps
c01020de:	e9 4e 09 00 00       	jmp    c0102a31 <__alltraps>

c01020e3 <vector34>:
.globl vector34
vector34:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $34
c01020e5:	6a 22                	push   $0x22
  jmp __alltraps
c01020e7:	e9 45 09 00 00       	jmp    c0102a31 <__alltraps>

c01020ec <vector35>:
.globl vector35
vector35:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $35
c01020ee:	6a 23                	push   $0x23
  jmp __alltraps
c01020f0:	e9 3c 09 00 00       	jmp    c0102a31 <__alltraps>

c01020f5 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020f5:	6a 00                	push   $0x0
  pushl $36
c01020f7:	6a 24                	push   $0x24
  jmp __alltraps
c01020f9:	e9 33 09 00 00       	jmp    c0102a31 <__alltraps>

c01020fe <vector37>:
.globl vector37
vector37:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $37
c0102100:	6a 25                	push   $0x25
  jmp __alltraps
c0102102:	e9 2a 09 00 00       	jmp    c0102a31 <__alltraps>

c0102107 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102107:	6a 00                	push   $0x0
  pushl $38
c0102109:	6a 26                	push   $0x26
  jmp __alltraps
c010210b:	e9 21 09 00 00       	jmp    c0102a31 <__alltraps>

c0102110 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $39
c0102112:	6a 27                	push   $0x27
  jmp __alltraps
c0102114:	e9 18 09 00 00       	jmp    c0102a31 <__alltraps>

c0102119 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102119:	6a 00                	push   $0x0
  pushl $40
c010211b:	6a 28                	push   $0x28
  jmp __alltraps
c010211d:	e9 0f 09 00 00       	jmp    c0102a31 <__alltraps>

c0102122 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $41
c0102124:	6a 29                	push   $0x29
  jmp __alltraps
c0102126:	e9 06 09 00 00       	jmp    c0102a31 <__alltraps>

c010212b <vector42>:
.globl vector42
vector42:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $42
c010212d:	6a 2a                	push   $0x2a
  jmp __alltraps
c010212f:	e9 fd 08 00 00       	jmp    c0102a31 <__alltraps>

c0102134 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $43
c0102136:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102138:	e9 f4 08 00 00       	jmp    c0102a31 <__alltraps>

c010213d <vector44>:
.globl vector44
vector44:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $44
c010213f:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102141:	e9 eb 08 00 00       	jmp    c0102a31 <__alltraps>

c0102146 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $45
c0102148:	6a 2d                	push   $0x2d
  jmp __alltraps
c010214a:	e9 e2 08 00 00       	jmp    c0102a31 <__alltraps>

c010214f <vector46>:
.globl vector46
vector46:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $46
c0102151:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102153:	e9 d9 08 00 00       	jmp    c0102a31 <__alltraps>

c0102158 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $47
c010215a:	6a 2f                	push   $0x2f
  jmp __alltraps
c010215c:	e9 d0 08 00 00       	jmp    c0102a31 <__alltraps>

c0102161 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $48
c0102163:	6a 30                	push   $0x30
  jmp __alltraps
c0102165:	e9 c7 08 00 00       	jmp    c0102a31 <__alltraps>

c010216a <vector49>:
.globl vector49
vector49:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $49
c010216c:	6a 31                	push   $0x31
  jmp __alltraps
c010216e:	e9 be 08 00 00       	jmp    c0102a31 <__alltraps>

c0102173 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102173:	6a 00                	push   $0x0
  pushl $50
c0102175:	6a 32                	push   $0x32
  jmp __alltraps
c0102177:	e9 b5 08 00 00       	jmp    c0102a31 <__alltraps>

c010217c <vector51>:
.globl vector51
vector51:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $51
c010217e:	6a 33                	push   $0x33
  jmp __alltraps
c0102180:	e9 ac 08 00 00       	jmp    c0102a31 <__alltraps>

c0102185 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102185:	6a 00                	push   $0x0
  pushl $52
c0102187:	6a 34                	push   $0x34
  jmp __alltraps
c0102189:	e9 a3 08 00 00       	jmp    c0102a31 <__alltraps>

c010218e <vector53>:
.globl vector53
vector53:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $53
c0102190:	6a 35                	push   $0x35
  jmp __alltraps
c0102192:	e9 9a 08 00 00       	jmp    c0102a31 <__alltraps>

c0102197 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102197:	6a 00                	push   $0x0
  pushl $54
c0102199:	6a 36                	push   $0x36
  jmp __alltraps
c010219b:	e9 91 08 00 00       	jmp    c0102a31 <__alltraps>

c01021a0 <vector55>:
.globl vector55
vector55:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $55
c01021a2:	6a 37                	push   $0x37
  jmp __alltraps
c01021a4:	e9 88 08 00 00       	jmp    c0102a31 <__alltraps>

c01021a9 <vector56>:
.globl vector56
vector56:
  pushl $0
c01021a9:	6a 00                	push   $0x0
  pushl $56
c01021ab:	6a 38                	push   $0x38
  jmp __alltraps
c01021ad:	e9 7f 08 00 00       	jmp    c0102a31 <__alltraps>

c01021b2 <vector57>:
.globl vector57
vector57:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $57
c01021b4:	6a 39                	push   $0x39
  jmp __alltraps
c01021b6:	e9 76 08 00 00       	jmp    c0102a31 <__alltraps>

c01021bb <vector58>:
.globl vector58
vector58:
  pushl $0
c01021bb:	6a 00                	push   $0x0
  pushl $58
c01021bd:	6a 3a                	push   $0x3a
  jmp __alltraps
c01021bf:	e9 6d 08 00 00       	jmp    c0102a31 <__alltraps>

c01021c4 <vector59>:
.globl vector59
vector59:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $59
c01021c6:	6a 3b                	push   $0x3b
  jmp __alltraps
c01021c8:	e9 64 08 00 00       	jmp    c0102a31 <__alltraps>

c01021cd <vector60>:
.globl vector60
vector60:
  pushl $0
c01021cd:	6a 00                	push   $0x0
  pushl $60
c01021cf:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021d1:	e9 5b 08 00 00       	jmp    c0102a31 <__alltraps>

c01021d6 <vector61>:
.globl vector61
vector61:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $61
c01021d8:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021da:	e9 52 08 00 00       	jmp    c0102a31 <__alltraps>

c01021df <vector62>:
.globl vector62
vector62:
  pushl $0
c01021df:	6a 00                	push   $0x0
  pushl $62
c01021e1:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021e3:	e9 49 08 00 00       	jmp    c0102a31 <__alltraps>

c01021e8 <vector63>:
.globl vector63
vector63:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $63
c01021ea:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021ec:	e9 40 08 00 00       	jmp    c0102a31 <__alltraps>

c01021f1 <vector64>:
.globl vector64
vector64:
  pushl $0
c01021f1:	6a 00                	push   $0x0
  pushl $64
c01021f3:	6a 40                	push   $0x40
  jmp __alltraps
c01021f5:	e9 37 08 00 00       	jmp    c0102a31 <__alltraps>

c01021fa <vector65>:
.globl vector65
vector65:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $65
c01021fc:	6a 41                	push   $0x41
  jmp __alltraps
c01021fe:	e9 2e 08 00 00       	jmp    c0102a31 <__alltraps>

c0102203 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102203:	6a 00                	push   $0x0
  pushl $66
c0102205:	6a 42                	push   $0x42
  jmp __alltraps
c0102207:	e9 25 08 00 00       	jmp    c0102a31 <__alltraps>

c010220c <vector67>:
.globl vector67
vector67:
  pushl $0
c010220c:	6a 00                	push   $0x0
  pushl $67
c010220e:	6a 43                	push   $0x43
  jmp __alltraps
c0102210:	e9 1c 08 00 00       	jmp    c0102a31 <__alltraps>

c0102215 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102215:	6a 00                	push   $0x0
  pushl $68
c0102217:	6a 44                	push   $0x44
  jmp __alltraps
c0102219:	e9 13 08 00 00       	jmp    c0102a31 <__alltraps>

c010221e <vector69>:
.globl vector69
vector69:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $69
c0102220:	6a 45                	push   $0x45
  jmp __alltraps
c0102222:	e9 0a 08 00 00       	jmp    c0102a31 <__alltraps>

c0102227 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102227:	6a 00                	push   $0x0
  pushl $70
c0102229:	6a 46                	push   $0x46
  jmp __alltraps
c010222b:	e9 01 08 00 00       	jmp    c0102a31 <__alltraps>

c0102230 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $71
c0102232:	6a 47                	push   $0x47
  jmp __alltraps
c0102234:	e9 f8 07 00 00       	jmp    c0102a31 <__alltraps>

c0102239 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102239:	6a 00                	push   $0x0
  pushl $72
c010223b:	6a 48                	push   $0x48
  jmp __alltraps
c010223d:	e9 ef 07 00 00       	jmp    c0102a31 <__alltraps>

c0102242 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $73
c0102244:	6a 49                	push   $0x49
  jmp __alltraps
c0102246:	e9 e6 07 00 00       	jmp    c0102a31 <__alltraps>

c010224b <vector74>:
.globl vector74
vector74:
  pushl $0
c010224b:	6a 00                	push   $0x0
  pushl $74
c010224d:	6a 4a                	push   $0x4a
  jmp __alltraps
c010224f:	e9 dd 07 00 00       	jmp    c0102a31 <__alltraps>

c0102254 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $75
c0102256:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102258:	e9 d4 07 00 00       	jmp    c0102a31 <__alltraps>

c010225d <vector76>:
.globl vector76
vector76:
  pushl $0
c010225d:	6a 00                	push   $0x0
  pushl $76
c010225f:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102261:	e9 cb 07 00 00       	jmp    c0102a31 <__alltraps>

c0102266 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $77
c0102268:	6a 4d                	push   $0x4d
  jmp __alltraps
c010226a:	e9 c2 07 00 00       	jmp    c0102a31 <__alltraps>

c010226f <vector78>:
.globl vector78
vector78:
  pushl $0
c010226f:	6a 00                	push   $0x0
  pushl $78
c0102271:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102273:	e9 b9 07 00 00       	jmp    c0102a31 <__alltraps>

c0102278 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $79
c010227a:	6a 4f                	push   $0x4f
  jmp __alltraps
c010227c:	e9 b0 07 00 00       	jmp    c0102a31 <__alltraps>

c0102281 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102281:	6a 00                	push   $0x0
  pushl $80
c0102283:	6a 50                	push   $0x50
  jmp __alltraps
c0102285:	e9 a7 07 00 00       	jmp    c0102a31 <__alltraps>

c010228a <vector81>:
.globl vector81
vector81:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $81
c010228c:	6a 51                	push   $0x51
  jmp __alltraps
c010228e:	e9 9e 07 00 00       	jmp    c0102a31 <__alltraps>

c0102293 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102293:	6a 00                	push   $0x0
  pushl $82
c0102295:	6a 52                	push   $0x52
  jmp __alltraps
c0102297:	e9 95 07 00 00       	jmp    c0102a31 <__alltraps>

c010229c <vector83>:
.globl vector83
vector83:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $83
c010229e:	6a 53                	push   $0x53
  jmp __alltraps
c01022a0:	e9 8c 07 00 00       	jmp    c0102a31 <__alltraps>

c01022a5 <vector84>:
.globl vector84
vector84:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $84
c01022a7:	6a 54                	push   $0x54
  jmp __alltraps
c01022a9:	e9 83 07 00 00       	jmp    c0102a31 <__alltraps>

c01022ae <vector85>:
.globl vector85
vector85:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $85
c01022b0:	6a 55                	push   $0x55
  jmp __alltraps
c01022b2:	e9 7a 07 00 00       	jmp    c0102a31 <__alltraps>

c01022b7 <vector86>:
.globl vector86
vector86:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $86
c01022b9:	6a 56                	push   $0x56
  jmp __alltraps
c01022bb:	e9 71 07 00 00       	jmp    c0102a31 <__alltraps>

c01022c0 <vector87>:
.globl vector87
vector87:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $87
c01022c2:	6a 57                	push   $0x57
  jmp __alltraps
c01022c4:	e9 68 07 00 00       	jmp    c0102a31 <__alltraps>

c01022c9 <vector88>:
.globl vector88
vector88:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $88
c01022cb:	6a 58                	push   $0x58
  jmp __alltraps
c01022cd:	e9 5f 07 00 00       	jmp    c0102a31 <__alltraps>

c01022d2 <vector89>:
.globl vector89
vector89:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $89
c01022d4:	6a 59                	push   $0x59
  jmp __alltraps
c01022d6:	e9 56 07 00 00       	jmp    c0102a31 <__alltraps>

c01022db <vector90>:
.globl vector90
vector90:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $90
c01022dd:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022df:	e9 4d 07 00 00       	jmp    c0102a31 <__alltraps>

c01022e4 <vector91>:
.globl vector91
vector91:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $91
c01022e6:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022e8:	e9 44 07 00 00       	jmp    c0102a31 <__alltraps>

c01022ed <vector92>:
.globl vector92
vector92:
  pushl $0
c01022ed:	6a 00                	push   $0x0
  pushl $92
c01022ef:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022f1:	e9 3b 07 00 00       	jmp    c0102a31 <__alltraps>

c01022f6 <vector93>:
.globl vector93
vector93:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $93
c01022f8:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022fa:	e9 32 07 00 00       	jmp    c0102a31 <__alltraps>

c01022ff <vector94>:
.globl vector94
vector94:
  pushl $0
c01022ff:	6a 00                	push   $0x0
  pushl $94
c0102301:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102303:	e9 29 07 00 00       	jmp    c0102a31 <__alltraps>

c0102308 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $95
c010230a:	6a 5f                	push   $0x5f
  jmp __alltraps
c010230c:	e9 20 07 00 00       	jmp    c0102a31 <__alltraps>

c0102311 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102311:	6a 00                	push   $0x0
  pushl $96
c0102313:	6a 60                	push   $0x60
  jmp __alltraps
c0102315:	e9 17 07 00 00       	jmp    c0102a31 <__alltraps>

c010231a <vector97>:
.globl vector97
vector97:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $97
c010231c:	6a 61                	push   $0x61
  jmp __alltraps
c010231e:	e9 0e 07 00 00       	jmp    c0102a31 <__alltraps>

c0102323 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102323:	6a 00                	push   $0x0
  pushl $98
c0102325:	6a 62                	push   $0x62
  jmp __alltraps
c0102327:	e9 05 07 00 00       	jmp    c0102a31 <__alltraps>

c010232c <vector99>:
.globl vector99
vector99:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $99
c010232e:	6a 63                	push   $0x63
  jmp __alltraps
c0102330:	e9 fc 06 00 00       	jmp    c0102a31 <__alltraps>

c0102335 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102335:	6a 00                	push   $0x0
  pushl $100
c0102337:	6a 64                	push   $0x64
  jmp __alltraps
c0102339:	e9 f3 06 00 00       	jmp    c0102a31 <__alltraps>

c010233e <vector101>:
.globl vector101
vector101:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $101
c0102340:	6a 65                	push   $0x65
  jmp __alltraps
c0102342:	e9 ea 06 00 00       	jmp    c0102a31 <__alltraps>

c0102347 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $102
c0102349:	6a 66                	push   $0x66
  jmp __alltraps
c010234b:	e9 e1 06 00 00       	jmp    c0102a31 <__alltraps>

c0102350 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $103
c0102352:	6a 67                	push   $0x67
  jmp __alltraps
c0102354:	e9 d8 06 00 00       	jmp    c0102a31 <__alltraps>

c0102359 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $104
c010235b:	6a 68                	push   $0x68
  jmp __alltraps
c010235d:	e9 cf 06 00 00       	jmp    c0102a31 <__alltraps>

c0102362 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $105
c0102364:	6a 69                	push   $0x69
  jmp __alltraps
c0102366:	e9 c6 06 00 00       	jmp    c0102a31 <__alltraps>

c010236b <vector106>:
.globl vector106
vector106:
  pushl $0
c010236b:	6a 00                	push   $0x0
  pushl $106
c010236d:	6a 6a                	push   $0x6a
  jmp __alltraps
c010236f:	e9 bd 06 00 00       	jmp    c0102a31 <__alltraps>

c0102374 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $107
c0102376:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102378:	e9 b4 06 00 00       	jmp    c0102a31 <__alltraps>

c010237d <vector108>:
.globl vector108
vector108:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $108
c010237f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102381:	e9 ab 06 00 00       	jmp    c0102a31 <__alltraps>

c0102386 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $109
c0102388:	6a 6d                	push   $0x6d
  jmp __alltraps
c010238a:	e9 a2 06 00 00       	jmp    c0102a31 <__alltraps>

c010238f <vector110>:
.globl vector110
vector110:
  pushl $0
c010238f:	6a 00                	push   $0x0
  pushl $110
c0102391:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102393:	e9 99 06 00 00       	jmp    c0102a31 <__alltraps>

c0102398 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $111
c010239a:	6a 6f                	push   $0x6f
  jmp __alltraps
c010239c:	e9 90 06 00 00       	jmp    c0102a31 <__alltraps>

c01023a1 <vector112>:
.globl vector112
vector112:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $112
c01023a3:	6a 70                	push   $0x70
  jmp __alltraps
c01023a5:	e9 87 06 00 00       	jmp    c0102a31 <__alltraps>

c01023aa <vector113>:
.globl vector113
vector113:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $113
c01023ac:	6a 71                	push   $0x71
  jmp __alltraps
c01023ae:	e9 7e 06 00 00       	jmp    c0102a31 <__alltraps>

c01023b3 <vector114>:
.globl vector114
vector114:
  pushl $0
c01023b3:	6a 00                	push   $0x0
  pushl $114
c01023b5:	6a 72                	push   $0x72
  jmp __alltraps
c01023b7:	e9 75 06 00 00       	jmp    c0102a31 <__alltraps>

c01023bc <vector115>:
.globl vector115
vector115:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $115
c01023be:	6a 73                	push   $0x73
  jmp __alltraps
c01023c0:	e9 6c 06 00 00       	jmp    c0102a31 <__alltraps>

c01023c5 <vector116>:
.globl vector116
vector116:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $116
c01023c7:	6a 74                	push   $0x74
  jmp __alltraps
c01023c9:	e9 63 06 00 00       	jmp    c0102a31 <__alltraps>

c01023ce <vector117>:
.globl vector117
vector117:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $117
c01023d0:	6a 75                	push   $0x75
  jmp __alltraps
c01023d2:	e9 5a 06 00 00       	jmp    c0102a31 <__alltraps>

c01023d7 <vector118>:
.globl vector118
vector118:
  pushl $0
c01023d7:	6a 00                	push   $0x0
  pushl $118
c01023d9:	6a 76                	push   $0x76
  jmp __alltraps
c01023db:	e9 51 06 00 00       	jmp    c0102a31 <__alltraps>

c01023e0 <vector119>:
.globl vector119
vector119:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $119
c01023e2:	6a 77                	push   $0x77
  jmp __alltraps
c01023e4:	e9 48 06 00 00       	jmp    c0102a31 <__alltraps>

c01023e9 <vector120>:
.globl vector120
vector120:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $120
c01023eb:	6a 78                	push   $0x78
  jmp __alltraps
c01023ed:	e9 3f 06 00 00       	jmp    c0102a31 <__alltraps>

c01023f2 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $121
c01023f4:	6a 79                	push   $0x79
  jmp __alltraps
c01023f6:	e9 36 06 00 00       	jmp    c0102a31 <__alltraps>

c01023fb <vector122>:
.globl vector122
vector122:
  pushl $0
c01023fb:	6a 00                	push   $0x0
  pushl $122
c01023fd:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023ff:	e9 2d 06 00 00       	jmp    c0102a31 <__alltraps>

c0102404 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $123
c0102406:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102408:	e9 24 06 00 00       	jmp    c0102a31 <__alltraps>

c010240d <vector124>:
.globl vector124
vector124:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $124
c010240f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102411:	e9 1b 06 00 00       	jmp    c0102a31 <__alltraps>

c0102416 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $125
c0102418:	6a 7d                	push   $0x7d
  jmp __alltraps
c010241a:	e9 12 06 00 00       	jmp    c0102a31 <__alltraps>

c010241f <vector126>:
.globl vector126
vector126:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $126
c0102421:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102423:	e9 09 06 00 00       	jmp    c0102a31 <__alltraps>

c0102428 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $127
c010242a:	6a 7f                	push   $0x7f
  jmp __alltraps
c010242c:	e9 00 06 00 00       	jmp    c0102a31 <__alltraps>

c0102431 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $128
c0102433:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102438:	e9 f4 05 00 00       	jmp    c0102a31 <__alltraps>

c010243d <vector129>:
.globl vector129
vector129:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $129
c010243f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102444:	e9 e8 05 00 00       	jmp    c0102a31 <__alltraps>

c0102449 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $130
c010244b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102450:	e9 dc 05 00 00       	jmp    c0102a31 <__alltraps>

c0102455 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $131
c0102457:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010245c:	e9 d0 05 00 00       	jmp    c0102a31 <__alltraps>

c0102461 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $132
c0102463:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102468:	e9 c4 05 00 00       	jmp    c0102a31 <__alltraps>

c010246d <vector133>:
.globl vector133
vector133:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $133
c010246f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102474:	e9 b8 05 00 00       	jmp    c0102a31 <__alltraps>

c0102479 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $134
c010247b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102480:	e9 ac 05 00 00       	jmp    c0102a31 <__alltraps>

c0102485 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $135
c0102487:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010248c:	e9 a0 05 00 00       	jmp    c0102a31 <__alltraps>

c0102491 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $136
c0102493:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102498:	e9 94 05 00 00       	jmp    c0102a31 <__alltraps>

c010249d <vector137>:
.globl vector137
vector137:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $137
c010249f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01024a4:	e9 88 05 00 00       	jmp    c0102a31 <__alltraps>

c01024a9 <vector138>:
.globl vector138
vector138:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $138
c01024ab:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01024b0:	e9 7c 05 00 00       	jmp    c0102a31 <__alltraps>

c01024b5 <vector139>:
.globl vector139
vector139:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $139
c01024b7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01024bc:	e9 70 05 00 00       	jmp    c0102a31 <__alltraps>

c01024c1 <vector140>:
.globl vector140
vector140:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $140
c01024c3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01024c8:	e9 64 05 00 00       	jmp    c0102a31 <__alltraps>

c01024cd <vector141>:
.globl vector141
vector141:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $141
c01024cf:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024d4:	e9 58 05 00 00       	jmp    c0102a31 <__alltraps>

c01024d9 <vector142>:
.globl vector142
vector142:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $142
c01024db:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024e0:	e9 4c 05 00 00       	jmp    c0102a31 <__alltraps>

c01024e5 <vector143>:
.globl vector143
vector143:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $143
c01024e7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024ec:	e9 40 05 00 00       	jmp    c0102a31 <__alltraps>

c01024f1 <vector144>:
.globl vector144
vector144:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $144
c01024f3:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024f8:	e9 34 05 00 00       	jmp    c0102a31 <__alltraps>

c01024fd <vector145>:
.globl vector145
vector145:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $145
c01024ff:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102504:	e9 28 05 00 00       	jmp    c0102a31 <__alltraps>

c0102509 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $146
c010250b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102510:	e9 1c 05 00 00       	jmp    c0102a31 <__alltraps>

c0102515 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $147
c0102517:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010251c:	e9 10 05 00 00       	jmp    c0102a31 <__alltraps>

c0102521 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $148
c0102523:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102528:	e9 04 05 00 00       	jmp    c0102a31 <__alltraps>

c010252d <vector149>:
.globl vector149
vector149:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $149
c010252f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102534:	e9 f8 04 00 00       	jmp    c0102a31 <__alltraps>

c0102539 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $150
c010253b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102540:	e9 ec 04 00 00       	jmp    c0102a31 <__alltraps>

c0102545 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $151
c0102547:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010254c:	e9 e0 04 00 00       	jmp    c0102a31 <__alltraps>

c0102551 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $152
c0102553:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102558:	e9 d4 04 00 00       	jmp    c0102a31 <__alltraps>

c010255d <vector153>:
.globl vector153
vector153:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $153
c010255f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102564:	e9 c8 04 00 00       	jmp    c0102a31 <__alltraps>

c0102569 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $154
c010256b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102570:	e9 bc 04 00 00       	jmp    c0102a31 <__alltraps>

c0102575 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $155
c0102577:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010257c:	e9 b0 04 00 00       	jmp    c0102a31 <__alltraps>

c0102581 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $156
c0102583:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102588:	e9 a4 04 00 00       	jmp    c0102a31 <__alltraps>

c010258d <vector157>:
.globl vector157
vector157:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $157
c010258f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102594:	e9 98 04 00 00       	jmp    c0102a31 <__alltraps>

c0102599 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $158
c010259b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01025a0:	e9 8c 04 00 00       	jmp    c0102a31 <__alltraps>

c01025a5 <vector159>:
.globl vector159
vector159:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $159
c01025a7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01025ac:	e9 80 04 00 00       	jmp    c0102a31 <__alltraps>

c01025b1 <vector160>:
.globl vector160
vector160:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $160
c01025b3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01025b8:	e9 74 04 00 00       	jmp    c0102a31 <__alltraps>

c01025bd <vector161>:
.globl vector161
vector161:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $161
c01025bf:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01025c4:	e9 68 04 00 00       	jmp    c0102a31 <__alltraps>

c01025c9 <vector162>:
.globl vector162
vector162:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $162
c01025cb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025d0:	e9 5c 04 00 00       	jmp    c0102a31 <__alltraps>

c01025d5 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $163
c01025d7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025dc:	e9 50 04 00 00       	jmp    c0102a31 <__alltraps>

c01025e1 <vector164>:
.globl vector164
vector164:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $164
c01025e3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025e8:	e9 44 04 00 00       	jmp    c0102a31 <__alltraps>

c01025ed <vector165>:
.globl vector165
vector165:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $165
c01025ef:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025f4:	e9 38 04 00 00       	jmp    c0102a31 <__alltraps>

c01025f9 <vector166>:
.globl vector166
vector166:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $166
c01025fb:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102600:	e9 2c 04 00 00       	jmp    c0102a31 <__alltraps>

c0102605 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $167
c0102607:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010260c:	e9 20 04 00 00       	jmp    c0102a31 <__alltraps>

c0102611 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $168
c0102613:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102618:	e9 14 04 00 00       	jmp    c0102a31 <__alltraps>

c010261d <vector169>:
.globl vector169
vector169:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $169
c010261f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102624:	e9 08 04 00 00       	jmp    c0102a31 <__alltraps>

c0102629 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $170
c010262b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102630:	e9 fc 03 00 00       	jmp    c0102a31 <__alltraps>

c0102635 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $171
c0102637:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010263c:	e9 f0 03 00 00       	jmp    c0102a31 <__alltraps>

c0102641 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $172
c0102643:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102648:	e9 e4 03 00 00       	jmp    c0102a31 <__alltraps>

c010264d <vector173>:
.globl vector173
vector173:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $173
c010264f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102654:	e9 d8 03 00 00       	jmp    c0102a31 <__alltraps>

c0102659 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $174
c010265b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102660:	e9 cc 03 00 00       	jmp    c0102a31 <__alltraps>

c0102665 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $175
c0102667:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010266c:	e9 c0 03 00 00       	jmp    c0102a31 <__alltraps>

c0102671 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $176
c0102673:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102678:	e9 b4 03 00 00       	jmp    c0102a31 <__alltraps>

c010267d <vector177>:
.globl vector177
vector177:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $177
c010267f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102684:	e9 a8 03 00 00       	jmp    c0102a31 <__alltraps>

c0102689 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $178
c010268b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102690:	e9 9c 03 00 00       	jmp    c0102a31 <__alltraps>

c0102695 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $179
c0102697:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010269c:	e9 90 03 00 00       	jmp    c0102a31 <__alltraps>

c01026a1 <vector180>:
.globl vector180
vector180:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $180
c01026a3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01026a8:	e9 84 03 00 00       	jmp    c0102a31 <__alltraps>

c01026ad <vector181>:
.globl vector181
vector181:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $181
c01026af:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01026b4:	e9 78 03 00 00       	jmp    c0102a31 <__alltraps>

c01026b9 <vector182>:
.globl vector182
vector182:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $182
c01026bb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01026c0:	e9 6c 03 00 00       	jmp    c0102a31 <__alltraps>

c01026c5 <vector183>:
.globl vector183
vector183:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $183
c01026c7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026cc:	e9 60 03 00 00       	jmp    c0102a31 <__alltraps>

c01026d1 <vector184>:
.globl vector184
vector184:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $184
c01026d3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026d8:	e9 54 03 00 00       	jmp    c0102a31 <__alltraps>

c01026dd <vector185>:
.globl vector185
vector185:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $185
c01026df:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026e4:	e9 48 03 00 00       	jmp    c0102a31 <__alltraps>

c01026e9 <vector186>:
.globl vector186
vector186:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $186
c01026eb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026f0:	e9 3c 03 00 00       	jmp    c0102a31 <__alltraps>

c01026f5 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $187
c01026f7:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026fc:	e9 30 03 00 00       	jmp    c0102a31 <__alltraps>

c0102701 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $188
c0102703:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102708:	e9 24 03 00 00       	jmp    c0102a31 <__alltraps>

c010270d <vector189>:
.globl vector189
vector189:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $189
c010270f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102714:	e9 18 03 00 00       	jmp    c0102a31 <__alltraps>

c0102719 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $190
c010271b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102720:	e9 0c 03 00 00       	jmp    c0102a31 <__alltraps>

c0102725 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $191
c0102727:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010272c:	e9 00 03 00 00       	jmp    c0102a31 <__alltraps>

c0102731 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $192
c0102733:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102738:	e9 f4 02 00 00       	jmp    c0102a31 <__alltraps>

c010273d <vector193>:
.globl vector193
vector193:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $193
c010273f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102744:	e9 e8 02 00 00       	jmp    c0102a31 <__alltraps>

c0102749 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $194
c010274b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102750:	e9 dc 02 00 00       	jmp    c0102a31 <__alltraps>

c0102755 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $195
c0102757:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010275c:	e9 d0 02 00 00       	jmp    c0102a31 <__alltraps>

c0102761 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $196
c0102763:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102768:	e9 c4 02 00 00       	jmp    c0102a31 <__alltraps>

c010276d <vector197>:
.globl vector197
vector197:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $197
c010276f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102774:	e9 b8 02 00 00       	jmp    c0102a31 <__alltraps>

c0102779 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $198
c010277b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102780:	e9 ac 02 00 00       	jmp    c0102a31 <__alltraps>

c0102785 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $199
c0102787:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010278c:	e9 a0 02 00 00       	jmp    c0102a31 <__alltraps>

c0102791 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $200
c0102793:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102798:	e9 94 02 00 00       	jmp    c0102a31 <__alltraps>

c010279d <vector201>:
.globl vector201
vector201:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $201
c010279f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01027a4:	e9 88 02 00 00       	jmp    c0102a31 <__alltraps>

c01027a9 <vector202>:
.globl vector202
vector202:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $202
c01027ab:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01027b0:	e9 7c 02 00 00       	jmp    c0102a31 <__alltraps>

c01027b5 <vector203>:
.globl vector203
vector203:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $203
c01027b7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01027bc:	e9 70 02 00 00       	jmp    c0102a31 <__alltraps>

c01027c1 <vector204>:
.globl vector204
vector204:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $204
c01027c3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01027c8:	e9 64 02 00 00       	jmp    c0102a31 <__alltraps>

c01027cd <vector205>:
.globl vector205
vector205:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $205
c01027cf:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027d4:	e9 58 02 00 00       	jmp    c0102a31 <__alltraps>

c01027d9 <vector206>:
.globl vector206
vector206:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $206
c01027db:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027e0:	e9 4c 02 00 00       	jmp    c0102a31 <__alltraps>

c01027e5 <vector207>:
.globl vector207
vector207:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $207
c01027e7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027ec:	e9 40 02 00 00       	jmp    c0102a31 <__alltraps>

c01027f1 <vector208>:
.globl vector208
vector208:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $208
c01027f3:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027f8:	e9 34 02 00 00       	jmp    c0102a31 <__alltraps>

c01027fd <vector209>:
.globl vector209
vector209:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $209
c01027ff:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102804:	e9 28 02 00 00       	jmp    c0102a31 <__alltraps>

c0102809 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $210
c010280b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102810:	e9 1c 02 00 00       	jmp    c0102a31 <__alltraps>

c0102815 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $211
c0102817:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010281c:	e9 10 02 00 00       	jmp    c0102a31 <__alltraps>

c0102821 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $212
c0102823:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102828:	e9 04 02 00 00       	jmp    c0102a31 <__alltraps>

c010282d <vector213>:
.globl vector213
vector213:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $213
c010282f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102834:	e9 f8 01 00 00       	jmp    c0102a31 <__alltraps>

c0102839 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $214
c010283b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102840:	e9 ec 01 00 00       	jmp    c0102a31 <__alltraps>

c0102845 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $215
c0102847:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010284c:	e9 e0 01 00 00       	jmp    c0102a31 <__alltraps>

c0102851 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $216
c0102853:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102858:	e9 d4 01 00 00       	jmp    c0102a31 <__alltraps>

c010285d <vector217>:
.globl vector217
vector217:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $217
c010285f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102864:	e9 c8 01 00 00       	jmp    c0102a31 <__alltraps>

c0102869 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $218
c010286b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102870:	e9 bc 01 00 00       	jmp    c0102a31 <__alltraps>

c0102875 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $219
c0102877:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010287c:	e9 b0 01 00 00       	jmp    c0102a31 <__alltraps>

c0102881 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $220
c0102883:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102888:	e9 a4 01 00 00       	jmp    c0102a31 <__alltraps>

c010288d <vector221>:
.globl vector221
vector221:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $221
c010288f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102894:	e9 98 01 00 00       	jmp    c0102a31 <__alltraps>

c0102899 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $222
c010289b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01028a0:	e9 8c 01 00 00       	jmp    c0102a31 <__alltraps>

c01028a5 <vector223>:
.globl vector223
vector223:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $223
c01028a7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01028ac:	e9 80 01 00 00       	jmp    c0102a31 <__alltraps>

c01028b1 <vector224>:
.globl vector224
vector224:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $224
c01028b3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01028b8:	e9 74 01 00 00       	jmp    c0102a31 <__alltraps>

c01028bd <vector225>:
.globl vector225
vector225:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $225
c01028bf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01028c4:	e9 68 01 00 00       	jmp    c0102a31 <__alltraps>

c01028c9 <vector226>:
.globl vector226
vector226:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $226
c01028cb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028d0:	e9 5c 01 00 00       	jmp    c0102a31 <__alltraps>

c01028d5 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $227
c01028d7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028dc:	e9 50 01 00 00       	jmp    c0102a31 <__alltraps>

c01028e1 <vector228>:
.globl vector228
vector228:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $228
c01028e3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028e8:	e9 44 01 00 00       	jmp    c0102a31 <__alltraps>

c01028ed <vector229>:
.globl vector229
vector229:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $229
c01028ef:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028f4:	e9 38 01 00 00       	jmp    c0102a31 <__alltraps>

c01028f9 <vector230>:
.globl vector230
vector230:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $230
c01028fb:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102900:	e9 2c 01 00 00       	jmp    c0102a31 <__alltraps>

c0102905 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $231
c0102907:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010290c:	e9 20 01 00 00       	jmp    c0102a31 <__alltraps>

c0102911 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $232
c0102913:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102918:	e9 14 01 00 00       	jmp    c0102a31 <__alltraps>

c010291d <vector233>:
.globl vector233
vector233:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $233
c010291f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102924:	e9 08 01 00 00       	jmp    c0102a31 <__alltraps>

c0102929 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $234
c010292b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102930:	e9 fc 00 00 00       	jmp    c0102a31 <__alltraps>

c0102935 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $235
c0102937:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010293c:	e9 f0 00 00 00       	jmp    c0102a31 <__alltraps>

c0102941 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102941:	6a 00                	push   $0x0
  pushl $236
c0102943:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102948:	e9 e4 00 00 00       	jmp    c0102a31 <__alltraps>

c010294d <vector237>:
.globl vector237
vector237:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $237
c010294f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102954:	e9 d8 00 00 00       	jmp    c0102a31 <__alltraps>

c0102959 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102959:	6a 00                	push   $0x0
  pushl $238
c010295b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102960:	e9 cc 00 00 00       	jmp    c0102a31 <__alltraps>

c0102965 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102965:	6a 00                	push   $0x0
  pushl $239
c0102967:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010296c:	e9 c0 00 00 00       	jmp    c0102a31 <__alltraps>

c0102971 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102971:	6a 00                	push   $0x0
  pushl $240
c0102973:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102978:	e9 b4 00 00 00       	jmp    c0102a31 <__alltraps>

c010297d <vector241>:
.globl vector241
vector241:
  pushl $0
c010297d:	6a 00                	push   $0x0
  pushl $241
c010297f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102984:	e9 a8 00 00 00       	jmp    c0102a31 <__alltraps>

c0102989 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102989:	6a 00                	push   $0x0
  pushl $242
c010298b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102990:	e9 9c 00 00 00       	jmp    c0102a31 <__alltraps>

c0102995 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102995:	6a 00                	push   $0x0
  pushl $243
c0102997:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010299c:	e9 90 00 00 00       	jmp    c0102a31 <__alltraps>

c01029a1 <vector244>:
.globl vector244
vector244:
  pushl $0
c01029a1:	6a 00                	push   $0x0
  pushl $244
c01029a3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01029a8:	e9 84 00 00 00       	jmp    c0102a31 <__alltraps>

c01029ad <vector245>:
.globl vector245
vector245:
  pushl $0
c01029ad:	6a 00                	push   $0x0
  pushl $245
c01029af:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01029b4:	e9 78 00 00 00       	jmp    c0102a31 <__alltraps>

c01029b9 <vector246>:
.globl vector246
vector246:
  pushl $0
c01029b9:	6a 00                	push   $0x0
  pushl $246
c01029bb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01029c0:	e9 6c 00 00 00       	jmp    c0102a31 <__alltraps>

c01029c5 <vector247>:
.globl vector247
vector247:
  pushl $0
c01029c5:	6a 00                	push   $0x0
  pushl $247
c01029c7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029cc:	e9 60 00 00 00       	jmp    c0102a31 <__alltraps>

c01029d1 <vector248>:
.globl vector248
vector248:
  pushl $0
c01029d1:	6a 00                	push   $0x0
  pushl $248
c01029d3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029d8:	e9 54 00 00 00       	jmp    c0102a31 <__alltraps>

c01029dd <vector249>:
.globl vector249
vector249:
  pushl $0
c01029dd:	6a 00                	push   $0x0
  pushl $249
c01029df:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029e4:	e9 48 00 00 00       	jmp    c0102a31 <__alltraps>

c01029e9 <vector250>:
.globl vector250
vector250:
  pushl $0
c01029e9:	6a 00                	push   $0x0
  pushl $250
c01029eb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029f0:	e9 3c 00 00 00       	jmp    c0102a31 <__alltraps>

c01029f5 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029f5:	6a 00                	push   $0x0
  pushl $251
c01029f7:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029fc:	e9 30 00 00 00       	jmp    c0102a31 <__alltraps>

c0102a01 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102a01:	6a 00                	push   $0x0
  pushl $252
c0102a03:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102a08:	e9 24 00 00 00       	jmp    c0102a31 <__alltraps>

c0102a0d <vector253>:
.globl vector253
vector253:
  pushl $0
c0102a0d:	6a 00                	push   $0x0
  pushl $253
c0102a0f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102a14:	e9 18 00 00 00       	jmp    c0102a31 <__alltraps>

c0102a19 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102a19:	6a 00                	push   $0x0
  pushl $254
c0102a1b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102a20:	e9 0c 00 00 00       	jmp    c0102a31 <__alltraps>

c0102a25 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a25:	6a 00                	push   $0x0
  pushl $255
c0102a27:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a2c:	e9 00 00 00 00       	jmp    c0102a31 <__alltraps>

c0102a31 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a31:	1e                   	push   %ds
    pushl %es
c0102a32:	06                   	push   %es
    pushl %fs
c0102a33:	0f a0                	push   %fs
    pushl %gs
c0102a35:	0f a8                	push   %gs
    pushal
c0102a37:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a38:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a3d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a3f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a41:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a42:	e8 63 f5 ff ff       	call   c0101faa <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a47:	5c                   	pop    %esp

c0102a48 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a48:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a49:	0f a9                	pop    %gs
    popl %fs
c0102a4b:	0f a1                	pop    %fs
    popl %es
c0102a4d:	07                   	pop    %es
    popl %ds
c0102a4e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a4f:	83 c4 08             	add    $0x8,%esp
    iret
c0102a52:	cf                   	iret   

c0102a53 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a53:	55                   	push   %ebp
c0102a54:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a59:	8b 15 64 a9 11 c0    	mov    0xc011a964,%edx
c0102a5f:	29 d0                	sub    %edx,%eax
c0102a61:	c1 f8 02             	sar    $0x2,%eax
c0102a64:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a6a:	5d                   	pop    %ebp
c0102a6b:	c3                   	ret    

c0102a6c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a6c:	55                   	push   %ebp
c0102a6d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102a6f:	ff 75 08             	pushl  0x8(%ebp)
c0102a72:	e8 dc ff ff ff       	call   c0102a53 <page2ppn>
c0102a77:	83 c4 04             	add    $0x4,%esp
c0102a7a:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a7d:	c9                   	leave  
c0102a7e:	c3                   	ret    

c0102a7f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102a7f:	55                   	push   %ebp
c0102a80:	89 e5                	mov    %esp,%ebp
c0102a82:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a88:	c1 e8 0c             	shr    $0xc,%eax
c0102a8b:	89 c2                	mov    %eax,%edx
c0102a8d:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0102a92:	39 c2                	cmp    %eax,%edx
c0102a94:	72 14                	jb     c0102aaa <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0102a96:	83 ec 04             	sub    $0x4,%esp
c0102a99:	68 50 70 10 c0       	push   $0xc0107050
c0102a9e:	6a 5a                	push   $0x5a
c0102aa0:	68 6f 70 10 c0       	push   $0xc010706f
c0102aa5:	e8 23 d9 ff ff       	call   c01003cd <__panic>
    }
    return &pages[PPN(pa)];
c0102aaa:	8b 0d 64 a9 11 c0    	mov    0xc011a964,%ecx
c0102ab0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab3:	c1 e8 0c             	shr    $0xc,%eax
c0102ab6:	89 c2                	mov    %eax,%edx
c0102ab8:	89 d0                	mov    %edx,%eax
c0102aba:	c1 e0 02             	shl    $0x2,%eax
c0102abd:	01 d0                	add    %edx,%eax
c0102abf:	c1 e0 02             	shl    $0x2,%eax
c0102ac2:	01 c8                	add    %ecx,%eax
}
c0102ac4:	c9                   	leave  
c0102ac5:	c3                   	ret    

c0102ac6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102ac6:	55                   	push   %ebp
c0102ac7:	89 e5                	mov    %esp,%ebp
c0102ac9:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0102acc:	ff 75 08             	pushl  0x8(%ebp)
c0102acf:	e8 98 ff ff ff       	call   c0102a6c <page2pa>
c0102ad4:	83 c4 04             	add    $0x4,%esp
c0102ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102add:	c1 e8 0c             	shr    $0xc,%eax
c0102ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ae3:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0102ae8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102aeb:	72 14                	jb     c0102b01 <page2kva+0x3b>
c0102aed:	ff 75 f4             	pushl  -0xc(%ebp)
c0102af0:	68 80 70 10 c0       	push   $0xc0107080
c0102af5:	6a 61                	push   $0x61
c0102af7:	68 6f 70 10 c0       	push   $0xc010706f
c0102afc:	e8 cc d8 ff ff       	call   c01003cd <__panic>
c0102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b04:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102b09:	c9                   	leave  
c0102b0a:	c3                   	ret    

c0102b0b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102b0b:	55                   	push   %ebp
c0102b0c:	89 e5                	mov    %esp,%ebp
c0102b0e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b14:	83 e0 01             	and    $0x1,%eax
c0102b17:	85 c0                	test   %eax,%eax
c0102b19:	75 14                	jne    c0102b2f <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102b1b:	83 ec 04             	sub    $0x4,%esp
c0102b1e:	68 a4 70 10 c0       	push   $0xc01070a4
c0102b23:	6a 6c                	push   $0x6c
c0102b25:	68 6f 70 10 c0       	push   $0xc010706f
c0102b2a:	e8 9e d8 ff ff       	call   c01003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b37:	83 ec 0c             	sub    $0xc,%esp
c0102b3a:	50                   	push   %eax
c0102b3b:	e8 3f ff ff ff       	call   c0102a7f <pa2page>
c0102b40:	83 c4 10             	add    $0x10,%esp
}
c0102b43:	c9                   	leave  
c0102b44:	c3                   	ret    

c0102b45 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102b45:	55                   	push   %ebp
c0102b46:	89 e5                	mov    %esp,%ebp
c0102b48:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b53:	83 ec 0c             	sub    $0xc,%esp
c0102b56:	50                   	push   %eax
c0102b57:	e8 23 ff ff ff       	call   c0102a7f <pa2page>
c0102b5c:	83 c4 10             	add    $0x10,%esp
}
c0102b5f:	c9                   	leave  
c0102b60:	c3                   	ret    

c0102b61 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102b61:	55                   	push   %ebp
c0102b62:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b67:	8b 00                	mov    (%eax),%eax
}
c0102b69:	5d                   	pop    %ebp
c0102b6a:	c3                   	ret    

c0102b6b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102b6b:	55                   	push   %ebp
c0102b6c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b71:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b74:	89 10                	mov    %edx,(%eax)
}
c0102b76:	90                   	nop
c0102b77:	5d                   	pop    %ebp
c0102b78:	c3                   	ret    

c0102b79 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102b79:	55                   	push   %ebp
c0102b7a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b7f:	8b 00                	mov    (%eax),%eax
c0102b81:	8d 50 01             	lea    0x1(%eax),%edx
c0102b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b87:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b8c:	8b 00                	mov    (%eax),%eax
}
c0102b8e:	5d                   	pop    %ebp
c0102b8f:	c3                   	ret    

c0102b90 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102b90:	55                   	push   %ebp
c0102b91:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b96:	8b 00                	mov    (%eax),%eax
c0102b98:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b9e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba3:	8b 00                	mov    (%eax),%eax
}
c0102ba5:	5d                   	pop    %ebp
c0102ba6:	c3                   	ret    

c0102ba7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0102ba7:	55                   	push   %ebp
c0102ba8:	89 e5                	mov    %esp,%ebp
c0102baa:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102bad:	9c                   	pushf  
c0102bae:	58                   	pop    %eax
c0102baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102bb5:	25 00 02 00 00       	and    $0x200,%eax
c0102bba:	85 c0                	test   %eax,%eax
c0102bbc:	74 0c                	je     c0102bca <__intr_save+0x23>
        intr_disable();
c0102bbe:	e8 9e ec ff ff       	call   c0101861 <intr_disable>
        return 1;
c0102bc3:	b8 01 00 00 00       	mov    $0x1,%eax
c0102bc8:	eb 05                	jmp    c0102bcf <__intr_save+0x28>
    }
    return 0;
c0102bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102bcf:	c9                   	leave  
c0102bd0:	c3                   	ret    

c0102bd1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102bd1:	55                   	push   %ebp
c0102bd2:	89 e5                	mov    %esp,%ebp
c0102bd4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102bdb:	74 05                	je     c0102be2 <__intr_restore+0x11>
        intr_enable();
c0102bdd:	e8 78 ec ff ff       	call   c010185a <intr_enable>
    }
}
c0102be2:	90                   	nop
c0102be3:	c9                   	leave  
c0102be4:	c3                   	ret    

c0102be5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102be5:	55                   	push   %ebp
c0102be6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102beb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102bee:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bf3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102bf5:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bfa:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102bfc:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c01:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102c03:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c08:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102c0a:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c0f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102c11:	ea 18 2c 10 c0 08 00 	ljmp   $0x8,$0xc0102c18
}
c0102c18:	90                   	nop
c0102c19:	5d                   	pop    %ebp
c0102c1a:	c3                   	ret    

c0102c1b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102c1b:	55                   	push   %ebp
c0102c1c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c21:	a3 e4 a8 11 c0       	mov    %eax,0xc011a8e4
}
c0102c26:	90                   	nop
c0102c27:	5d                   	pop    %ebp
c0102c28:	c3                   	ret    

c0102c29 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102c29:	55                   	push   %ebp
c0102c2a:	89 e5                	mov    %esp,%ebp
c0102c2c:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102c2f:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102c34:	50                   	push   %eax
c0102c35:	e8 e1 ff ff ff       	call   c0102c1b <load_esp0>
c0102c3a:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102c3d:	66 c7 05 e8 a8 11 c0 	movw   $0x10,0xc011a8e8
c0102c44:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102c46:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102c4d:	68 00 
c0102c4f:	b8 e0 a8 11 c0       	mov    $0xc011a8e0,%eax
c0102c54:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102c5a:	b8 e0 a8 11 c0       	mov    $0xc011a8e0,%eax
c0102c5f:	c1 e8 10             	shr    $0x10,%eax
c0102c62:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102c67:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c6e:	83 e0 f0             	and    $0xfffffff0,%eax
c0102c71:	83 c8 09             	or     $0x9,%eax
c0102c74:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c79:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c80:	83 e0 ef             	and    $0xffffffef,%eax
c0102c83:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c88:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c8f:	83 e0 9f             	and    $0xffffff9f,%eax
c0102c92:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c97:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c9e:	83 c8 80             	or     $0xffffff80,%eax
c0102ca1:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102ca6:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102cad:	83 e0 f0             	and    $0xfffffff0,%eax
c0102cb0:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102cb5:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102cbc:	83 e0 ef             	and    $0xffffffef,%eax
c0102cbf:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102cc4:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102ccb:	83 e0 df             	and    $0xffffffdf,%eax
c0102cce:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102cd3:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102cda:	83 c8 40             	or     $0x40,%eax
c0102cdd:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102ce2:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102ce9:	83 e0 7f             	and    $0x7f,%eax
c0102cec:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102cf1:	b8 e0 a8 11 c0       	mov    $0xc011a8e0,%eax
c0102cf6:	c1 e8 18             	shr    $0x18,%eax
c0102cf9:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102cfe:	68 30 9a 11 c0       	push   $0xc0119a30
c0102d03:	e8 dd fe ff ff       	call   c0102be5 <lgdt>
c0102d08:	83 c4 04             	add    $0x4,%esp
c0102d0b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102d11:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102d15:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102d18:	90                   	nop
c0102d19:	c9                   	leave  
c0102d1a:	c3                   	ret    

c0102d1b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102d1b:	55                   	push   %ebp
c0102d1c:	89 e5                	mov    %esp,%ebp
c0102d1e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102d21:	c7 05 5c a9 11 c0 00 	movl   $0xc0107b00,0xc011a95c
c0102d28:	7b 10 c0 
	// pmm_manager = &buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
c0102d2b:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c0102d30:	8b 00                	mov    (%eax),%eax
c0102d32:	83 ec 08             	sub    $0x8,%esp
c0102d35:	50                   	push   %eax
c0102d36:	68 d0 70 10 c0       	push   $0xc01070d0
c0102d3b:	e8 27 d5 ff ff       	call   c0100267 <cprintf>
c0102d40:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102d43:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c0102d48:	8b 40 04             	mov    0x4(%eax),%eax
c0102d4b:	ff d0                	call   *%eax
}
c0102d4d:	90                   	nop
c0102d4e:	c9                   	leave  
c0102d4f:	c3                   	ret    

c0102d50 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102d50:	55                   	push   %ebp
c0102d51:	89 e5                	mov    %esp,%ebp
c0102d53:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102d56:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c0102d5b:	8b 40 08             	mov    0x8(%eax),%eax
c0102d5e:	83 ec 08             	sub    $0x8,%esp
c0102d61:	ff 75 0c             	pushl  0xc(%ebp)
c0102d64:	ff 75 08             	pushl  0x8(%ebp)
c0102d67:	ff d0                	call   *%eax
c0102d69:	83 c4 10             	add    $0x10,%esp
}
c0102d6c:	90                   	nop
c0102d6d:	c9                   	leave  
c0102d6e:	c3                   	ret    

c0102d6f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102d6f:	55                   	push   %ebp
c0102d70:	89 e5                	mov    %esp,%ebp
c0102d72:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d7c:	e8 26 fe ff ff       	call   c0102ba7 <__intr_save>
c0102d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102d84:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c0102d89:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d8c:	83 ec 0c             	sub    $0xc,%esp
c0102d8f:	ff 75 08             	pushl  0x8(%ebp)
c0102d92:	ff d0                	call   *%eax
c0102d94:	83 c4 10             	add    $0x10,%esp
c0102d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d9a:	83 ec 0c             	sub    $0xc,%esp
c0102d9d:	ff 75 f0             	pushl  -0x10(%ebp)
c0102da0:	e8 2c fe ff ff       	call   c0102bd1 <__intr_restore>
c0102da5:	83 c4 10             	add    $0x10,%esp
    return page;
c0102da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102dab:	c9                   	leave  
c0102dac:	c3                   	ret    

c0102dad <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102dad:	55                   	push   %ebp
c0102dae:	89 e5                	mov    %esp,%ebp
c0102db0:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102db3:	e8 ef fd ff ff       	call   c0102ba7 <__intr_save>
c0102db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102dbb:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c0102dc0:	8b 40 10             	mov    0x10(%eax),%eax
c0102dc3:	83 ec 08             	sub    $0x8,%esp
c0102dc6:	ff 75 0c             	pushl  0xc(%ebp)
c0102dc9:	ff 75 08             	pushl  0x8(%ebp)
c0102dcc:	ff d0                	call   *%eax
c0102dce:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102dd1:	83 ec 0c             	sub    $0xc,%esp
c0102dd4:	ff 75 f4             	pushl  -0xc(%ebp)
c0102dd7:	e8 f5 fd ff ff       	call   c0102bd1 <__intr_restore>
c0102ddc:	83 c4 10             	add    $0x10,%esp
}
c0102ddf:	90                   	nop
c0102de0:	c9                   	leave  
c0102de1:	c3                   	ret    

c0102de2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102de2:	55                   	push   %ebp
c0102de3:	89 e5                	mov    %esp,%ebp
c0102de5:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102de8:	e8 ba fd ff ff       	call   c0102ba7 <__intr_save>
c0102ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102df0:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c0102df5:	8b 40 14             	mov    0x14(%eax),%eax
c0102df8:	ff d0                	call   *%eax
c0102dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102dfd:	83 ec 0c             	sub    $0xc,%esp
c0102e00:	ff 75 f4             	pushl  -0xc(%ebp)
c0102e03:	e8 c9 fd ff ff       	call   c0102bd1 <__intr_restore>
c0102e08:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102e0e:	c9                   	leave  
c0102e0f:	c3                   	ret    

c0102e10 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102e10:	55                   	push   %ebp
c0102e11:	89 e5                	mov    %esp,%ebp
c0102e13:	57                   	push   %edi
c0102e14:	56                   	push   %esi
c0102e15:	53                   	push   %ebx
c0102e16:	83 ec 7c             	sub    $0x7c,%esp
	// e820map is at 0xC0008000 (PA) defined in bootloader.
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102e19:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102e20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102e27:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102e2e:	83 ec 0c             	sub    $0xc,%esp
c0102e31:	68 e7 70 10 c0       	push   $0xc01070e7
c0102e36:	e8 2c d4 ff ff       	call   c0100267 <cprintf>
c0102e3b:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e45:	e9 fc 00 00 00       	jmp    c0102f46 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e4a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e50:	89 d0                	mov    %edx,%eax
c0102e52:	c1 e0 02             	shl    $0x2,%eax
c0102e55:	01 d0                	add    %edx,%eax
c0102e57:	c1 e0 02             	shl    $0x2,%eax
c0102e5a:	01 c8                	add    %ecx,%eax
c0102e5c:	8b 50 08             	mov    0x8(%eax),%edx
c0102e5f:	8b 40 04             	mov    0x4(%eax),%eax
c0102e62:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102e65:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102e68:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e6e:	89 d0                	mov    %edx,%eax
c0102e70:	c1 e0 02             	shl    $0x2,%eax
c0102e73:	01 d0                	add    %edx,%eax
c0102e75:	c1 e0 02             	shl    $0x2,%eax
c0102e78:	01 c8                	add    %ecx,%eax
c0102e7a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e7d:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e80:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e83:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e86:	01 c8                	add    %ecx,%eax
c0102e88:	11 da                	adc    %ebx,%edx
c0102e8a:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102e8d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102e90:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e96:	89 d0                	mov    %edx,%eax
c0102e98:	c1 e0 02             	shl    $0x2,%eax
c0102e9b:	01 d0                	add    %edx,%eax
c0102e9d:	c1 e0 02             	shl    $0x2,%eax
c0102ea0:	01 c8                	add    %ecx,%eax
c0102ea2:	83 c0 14             	add    $0x14,%eax
c0102ea5:	8b 00                	mov    (%eax),%eax
c0102ea7:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102eaa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ead:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102eb0:	83 c0 ff             	add    $0xffffffff,%eax
c0102eb3:	83 d2 ff             	adc    $0xffffffff,%edx
c0102eb6:	89 c1                	mov    %eax,%ecx
c0102eb8:	89 d3                	mov    %edx,%ebx
c0102eba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ebd:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102ec0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ec3:	89 d0                	mov    %edx,%eax
c0102ec5:	c1 e0 02             	shl    $0x2,%eax
c0102ec8:	01 d0                	add    %edx,%eax
c0102eca:	c1 e0 02             	shl    $0x2,%eax
c0102ecd:	03 45 80             	add    -0x80(%ebp),%eax
c0102ed0:	8b 50 10             	mov    0x10(%eax),%edx
c0102ed3:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ed6:	ff 75 84             	pushl  -0x7c(%ebp)
c0102ed9:	53                   	push   %ebx
c0102eda:	51                   	push   %ecx
c0102edb:	ff 75 bc             	pushl  -0x44(%ebp)
c0102ede:	ff 75 b8             	pushl  -0x48(%ebp)
c0102ee1:	52                   	push   %edx
c0102ee2:	50                   	push   %eax
c0102ee3:	68 f4 70 10 c0       	push   $0xc01070f4
c0102ee8:	e8 7a d3 ff ff       	call   c0100267 <cprintf>
c0102eed:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102ef0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ef6:	89 d0                	mov    %edx,%eax
c0102ef8:	c1 e0 02             	shl    $0x2,%eax
c0102efb:	01 d0                	add    %edx,%eax
c0102efd:	c1 e0 02             	shl    $0x2,%eax
c0102f00:	01 c8                	add    %ecx,%eax
c0102f02:	83 c0 14             	add    $0x14,%eax
c0102f05:	8b 00                	mov    (%eax),%eax
c0102f07:	83 f8 01             	cmp    $0x1,%eax
c0102f0a:	75 36                	jne    c0102f42 <page_init+0x132>
        	// KMEMSIZE restricts the maximum detected physical address.
        	// Thus the block with starting address >= KMEMSIZE will not be recognized.
            if (maxpa < end && begin < KMEMSIZE) {
c0102f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f12:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102f15:	77 2b                	ja     c0102f42 <page_init+0x132>
c0102f17:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102f1a:	72 05                	jb     c0102f21 <page_init+0x111>
c0102f1c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102f1f:	73 21                	jae    c0102f42 <page_init+0x132>
c0102f21:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102f25:	77 1b                	ja     c0102f42 <page_init+0x132>
c0102f27:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102f2b:	72 09                	jb     c0102f36 <page_init+0x126>
c0102f2d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102f34:	77 0c                	ja     c0102f42 <page_init+0x132>
                maxpa = end;
c0102f36:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f39:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102f3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102f3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102f42:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102f49:	8b 00                	mov    (%eax),%eax
c0102f4b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102f4e:	0f 8f f6 fe ff ff    	jg     c0102e4a <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102f54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102f58:	72 1d                	jb     c0102f77 <page_init+0x167>
c0102f5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102f5e:	77 09                	ja     c0102f69 <page_init+0x159>
c0102f60:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102f67:	76 0e                	jbe    c0102f77 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102f69:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102f70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    // Provided in kernel.ld - End of kernel bss.
    extern char end[];
    cprintf("Detected maxpa = %08llx\n", maxpa);
c0102f77:	83 ec 04             	sub    $0x4,%esp
c0102f7a:	ff 75 e4             	pushl  -0x1c(%ebp)
c0102f7d:	ff 75 e0             	pushl  -0x20(%ebp)
c0102f80:	68 24 71 10 c0       	push   $0xc0107124
c0102f85:	e8 dd d2 ff ff       	call   c0100267 <cprintf>
c0102f8a:	83 c4 10             	add    $0x10,%esp
    // Here, npage is only used for an estimation of how many entries in the page table.
    npage = maxpa / PGSIZE;
c0102f8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f93:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f97:	c1 ea 0c             	shr    $0xc,%edx
c0102f9a:	a3 c0 a8 11 c0       	mov    %eax,0xc011a8c0
    // virtual address of physical pages descriptor array.
    // The array starts at the end of the kernel code.
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102f9f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102fa6:	b8 74 a9 11 c0       	mov    $0xc011a974,%eax
c0102fab:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102fae:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102fb1:	01 d0                	add    %edx,%eax
c0102fb3:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102fb6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102fb9:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fbe:	f7 75 ac             	divl   -0x54(%ebp)
c0102fc1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102fc4:	29 d0                	sub    %edx,%eax
c0102fc6:	a3 64 a9 11 c0       	mov    %eax,0xc011a964

    for (i = 0; i < npage; i ++) {
c0102fcb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fd2:	eb 2f                	jmp    c0103003 <page_init+0x1f3>
        SetPageReserved(pages + i);
c0102fd4:	8b 0d 64 a9 11 c0    	mov    0xc011a964,%ecx
c0102fda:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fdd:	89 d0                	mov    %edx,%eax
c0102fdf:	c1 e0 02             	shl    $0x2,%eax
c0102fe2:	01 d0                	add    %edx,%eax
c0102fe4:	c1 e0 02             	shl    $0x2,%eax
c0102fe7:	01 c8                	add    %ecx,%eax
c0102fe9:	83 c0 04             	add    $0x4,%eax
c0102fec:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102ff3:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ff6:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ff9:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102ffc:	0f ab 10             	bts    %edx,(%eax)
    npage = maxpa / PGSIZE;
    // virtual address of physical pages descriptor array.
    // The array starts at the end of the kernel code.
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102fff:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103003:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103006:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c010300b:	39 c2                	cmp    %eax,%edx
c010300d:	72 c5                	jb     c0102fd4 <page_init+0x1c4>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010300f:	8b 15 c0 a8 11 c0    	mov    0xc011a8c0,%edx
c0103015:	89 d0                	mov    %edx,%eax
c0103017:	c1 e0 02             	shl    $0x2,%eax
c010301a:	01 d0                	add    %edx,%eax
c010301c:	c1 e0 02             	shl    $0x2,%eax
c010301f:	89 c2                	mov    %eax,%edx
c0103021:	a1 64 a9 11 c0       	mov    0xc011a964,%eax
c0103026:	01 d0                	add    %edx,%eax
c0103028:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010302b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103032:	77 17                	ja     c010304b <page_init+0x23b>
c0103034:	ff 75 a4             	pushl  -0x5c(%ebp)
c0103037:	68 40 71 10 c0       	push   $0xc0107140
c010303c:	68 e4 00 00 00       	push   $0xe4
c0103041:	68 64 71 10 c0       	push   $0xc0107164
c0103046:	e8 82 d3 ff ff       	call   c01003cd <__panic>
c010304b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010304e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103053:	89 45 a0             	mov    %eax,-0x60(%ebp)

    cprintf("Kernel ends at (va): %08x, Total pages = %d, which takes up %d.\n",
c0103056:	8b 15 c0 a8 11 c0    	mov    0xc011a8c0,%edx
c010305c:	89 d0                	mov    %edx,%eax
c010305e:	c1 e0 02             	shl    $0x2,%eax
c0103061:	01 d0                	add    %edx,%eax
c0103063:	c1 e0 02             	shl    $0x2,%eax
c0103066:	89 c1                	mov    %eax,%ecx
c0103068:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c010306d:	ba 74 a9 11 c0       	mov    $0xc011a974,%edx
c0103072:	51                   	push   %ecx
c0103073:	50                   	push   %eax
c0103074:	52                   	push   %edx
c0103075:	68 74 71 10 c0       	push   $0xc0107174
c010307a:	e8 e8 d1 ff ff       	call   c0100267 <cprintf>
c010307f:	83 c4 10             	add    $0x10,%esp
    		(uintptr_t)end, npage, sizeof(struct Page) * npage);
    cprintf("Freemem = (pa) %08x\n", freemem);
c0103082:	83 ec 08             	sub    $0x8,%esp
c0103085:	ff 75 a0             	pushl  -0x60(%ebp)
c0103088:	68 b5 71 10 c0       	push   $0xc01071b5
c010308d:	e8 d5 d1 ff ff       	call   c0100267 <cprintf>
c0103092:	83 c4 10             	add    $0x10,%esp

    for (i = 0; i < memmap->nr_map; i ++) {
c0103095:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010309c:	e9 85 01 00 00       	jmp    c0103226 <page_init+0x416>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01030a1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030a7:	89 d0                	mov    %edx,%eax
c01030a9:	c1 e0 02             	shl    $0x2,%eax
c01030ac:	01 d0                	add    %edx,%eax
c01030ae:	c1 e0 02             	shl    $0x2,%eax
c01030b1:	01 c8                	add    %ecx,%eax
c01030b3:	8b 50 08             	mov    0x8(%eax),%edx
c01030b6:	8b 40 04             	mov    0x4(%eax),%eax
c01030b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030bc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030bf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030c5:	89 d0                	mov    %edx,%eax
c01030c7:	c1 e0 02             	shl    $0x2,%eax
c01030ca:	01 d0                	add    %edx,%eax
c01030cc:	c1 e0 02             	shl    $0x2,%eax
c01030cf:	01 c8                	add    %ecx,%eax
c01030d1:	8b 48 0c             	mov    0xc(%eax),%ecx
c01030d4:	8b 58 10             	mov    0x10(%eax),%ebx
c01030d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030dd:	01 c8                	add    %ecx,%eax
c01030df:	11 da                	adc    %ebx,%edx
c01030e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01030e4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01030e7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030ed:	89 d0                	mov    %edx,%eax
c01030ef:	c1 e0 02             	shl    $0x2,%eax
c01030f2:	01 d0                	add    %edx,%eax
c01030f4:	c1 e0 02             	shl    $0x2,%eax
c01030f7:	01 c8                	add    %ecx,%eax
c01030f9:	83 c0 14             	add    $0x14,%eax
c01030fc:	8b 00                	mov    (%eax),%eax
c01030fe:	83 f8 01             	cmp    $0x1,%eax
c0103101:	0f 85 1b 01 00 00    	jne    c0103222 <page_init+0x412>
            if (begin < freemem) {
c0103107:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010310a:	ba 00 00 00 00       	mov    $0x0,%edx
c010310f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103112:	72 17                	jb     c010312b <page_init+0x31b>
c0103114:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103117:	77 05                	ja     c010311e <page_init+0x30e>
c0103119:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010311c:	76 0d                	jbe    c010312b <page_init+0x31b>
                begin = freemem;
c010311e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103121:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103124:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010312b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010312f:	72 1d                	jb     c010314e <page_init+0x33e>
c0103131:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103135:	77 09                	ja     c0103140 <page_init+0x330>
c0103137:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010313e:	76 0e                	jbe    c010314e <page_init+0x33e>
                end = KMEMSIZE;
c0103140:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103147:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            // Gather all available blocks and build pages linked list.
            if (begin < end) {
c010314e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103151:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103154:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103157:	0f 87 c5 00 00 00    	ja     c0103222 <page_init+0x412>
c010315d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103160:	72 09                	jb     c010316b <page_init+0x35b>
c0103162:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103165:	0f 83 b7 00 00 00    	jae    c0103222 <page_init+0x412>
                begin = ROUNDUP(begin, PGSIZE);
c010316b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103172:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103175:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103178:	01 d0                	add    %edx,%eax
c010317a:	83 e8 01             	sub    $0x1,%eax
c010317d:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103180:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103183:	ba 00 00 00 00       	mov    $0x0,%edx
c0103188:	f7 75 9c             	divl   -0x64(%ebp)
c010318b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010318e:	29 d0                	sub    %edx,%eax
c0103190:	ba 00 00 00 00       	mov    $0x0,%edx
c0103195:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103198:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010319b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010319e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01031a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01031a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01031a9:	89 c3                	mov    %eax,%ebx
c01031ab:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01031b1:	89 de                	mov    %ebx,%esi
c01031b3:	89 d0                	mov    %edx,%eax
c01031b5:	83 e0 00             	and    $0x0,%eax
c01031b8:	89 c7                	mov    %eax,%edi
c01031ba:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01031bd:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01031c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031c6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01031c9:	77 57                	ja     c0103222 <page_init+0x412>
c01031cb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01031ce:	72 05                	jb     c01031d5 <page_init+0x3c5>
c01031d0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01031d3:	73 4d                	jae    c0103222 <page_init+0x412>
                	cprintf("Detected one allocatable block (pa) start = %08llx, end = %08llx\n", begin, end);
c01031d5:	83 ec 0c             	sub    $0xc,%esp
c01031d8:	ff 75 cc             	pushl  -0x34(%ebp)
c01031db:	ff 75 c8             	pushl  -0x38(%ebp)
c01031de:	ff 75 d4             	pushl  -0x2c(%ebp)
c01031e1:	ff 75 d0             	pushl  -0x30(%ebp)
c01031e4:	68 cc 71 10 c0       	push   $0xc01071cc
c01031e9:	e8 79 d0 ff ff       	call   c0100267 <cprintf>
c01031ee:	83 c4 20             	add    $0x20,%esp
                	// pa2page converts physical address into its page descriptor's virtual address.
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01031f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01031f4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01031f7:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01031fa:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01031fd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103201:	c1 ea 0c             	shr    $0xc,%edx
c0103204:	89 c3                	mov    %eax,%ebx
c0103206:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103209:	83 ec 0c             	sub    $0xc,%esp
c010320c:	50                   	push   %eax
c010320d:	e8 6d f8 ff ff       	call   c0102a7f <pa2page>
c0103212:	83 c4 10             	add    $0x10,%esp
c0103215:	83 ec 08             	sub    $0x8,%esp
c0103218:	53                   	push   %ebx
c0103219:	50                   	push   %eax
c010321a:	e8 31 fb ff ff       	call   c0102d50 <init_memmap>
c010321f:	83 c4 10             	add    $0x10,%esp

    cprintf("Kernel ends at (va): %08x, Total pages = %d, which takes up %d.\n",
    		(uintptr_t)end, npage, sizeof(struct Page) * npage);
    cprintf("Freemem = (pa) %08x\n", freemem);

    for (i = 0; i < memmap->nr_map; i ++) {
c0103222:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103226:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103229:	8b 00                	mov    (%eax),%eax
c010322b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010322e:	0f 8f 6d fe ff ff    	jg     c01030a1 <page_init+0x291>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0103234:	90                   	nop
c0103235:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103238:	5b                   	pop    %ebx
c0103239:	5e                   	pop    %esi
c010323a:	5f                   	pop    %edi
c010323b:	5d                   	pop    %ebp
c010323c:	c3                   	ret    

c010323d <enable_paging>:

static void
enable_paging(void) {
c010323d:	55                   	push   %ebp
c010323e:	89 e5                	mov    %esp,%ebp
c0103240:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103243:	a1 60 a9 11 c0       	mov    0xc011a960,%eax
c0103248:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010324b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010324e:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103251:	0f 20 c0             	mov    %cr0,%eax
c0103254:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103257:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c010325a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010325d:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103264:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0103268:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010326b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103271:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103274:	90                   	nop
c0103275:	c9                   	leave  
c0103276:	c3                   	ret    

c0103277 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103277:	55                   	push   %ebp
c0103278:	89 e5                	mov    %esp,%ebp
c010327a:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010327d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103280:	33 45 14             	xor    0x14(%ebp),%eax
c0103283:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103288:	85 c0                	test   %eax,%eax
c010328a:	74 19                	je     c01032a5 <boot_map_segment+0x2e>
c010328c:	68 0e 72 10 c0       	push   $0xc010720e
c0103291:	68 25 72 10 c0       	push   $0xc0107225
c0103296:	68 14 01 00 00       	push   $0x114
c010329b:	68 64 71 10 c0       	push   $0xc0107164
c01032a0:	e8 28 d1 ff ff       	call   c01003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01032a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01032ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032af:	25 ff 0f 00 00       	and    $0xfff,%eax
c01032b4:	89 c2                	mov    %eax,%edx
c01032b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01032b9:	01 c2                	add    %eax,%edx
c01032bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032be:	01 d0                	add    %edx,%eax
c01032c0:	83 e8 01             	sub    $0x1,%eax
c01032c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032c9:	ba 00 00 00 00       	mov    $0x0,%edx
c01032ce:	f7 75 f0             	divl   -0x10(%ebp)
c01032d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032d4:	29 d0                	sub    %edx,%eax
c01032d6:	c1 e8 0c             	shr    $0xc,%eax
c01032d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032df:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032ea:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01032ed:	8b 45 14             	mov    0x14(%ebp),%eax
c01032f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032fb:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01032fe:	eb 57                	jmp    c0103357 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103300:	83 ec 04             	sub    $0x4,%esp
c0103303:	6a 01                	push   $0x1
c0103305:	ff 75 0c             	pushl  0xc(%ebp)
c0103308:	ff 75 08             	pushl  0x8(%ebp)
c010330b:	e8 98 01 00 00       	call   c01034a8 <get_pte>
c0103310:	83 c4 10             	add    $0x10,%esp
c0103313:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103316:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010331a:	75 19                	jne    c0103335 <boot_map_segment+0xbe>
c010331c:	68 3a 72 10 c0       	push   $0xc010723a
c0103321:	68 25 72 10 c0       	push   $0xc0107225
c0103326:	68 1a 01 00 00       	push   $0x11a
c010332b:	68 64 71 10 c0       	push   $0xc0107164
c0103330:	e8 98 d0 ff ff       	call   c01003cd <__panic>
        *ptep = pa | PTE_P | perm;
c0103335:	8b 45 14             	mov    0x14(%ebp),%eax
c0103338:	0b 45 18             	or     0x18(%ebp),%eax
c010333b:	83 c8 01             	or     $0x1,%eax
c010333e:	89 c2                	mov    %eax,%edx
c0103340:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103343:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103345:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103349:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103350:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010335b:	75 a3                	jne    c0103300 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010335d:	90                   	nop
c010335e:	c9                   	leave  
c010335f:	c3                   	ret    

c0103360 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103360:	55                   	push   %ebp
c0103361:	89 e5                	mov    %esp,%ebp
c0103363:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0103366:	83 ec 0c             	sub    $0xc,%esp
c0103369:	6a 01                	push   $0x1
c010336b:	e8 ff f9 ff ff       	call   c0102d6f <alloc_pages>
c0103370:	83 c4 10             	add    $0x10,%esp
c0103373:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010337a:	75 17                	jne    c0103393 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c010337c:	83 ec 04             	sub    $0x4,%esp
c010337f:	68 47 72 10 c0       	push   $0xc0107247
c0103384:	68 26 01 00 00       	push   $0x126
c0103389:	68 64 71 10 c0       	push   $0xc0107164
c010338e:	e8 3a d0 ff ff       	call   c01003cd <__panic>
    }
    return page2kva(p);
c0103393:	83 ec 0c             	sub    $0xc,%esp
c0103396:	ff 75 f4             	pushl  -0xc(%ebp)
c0103399:	e8 28 f7 ff ff       	call   c0102ac6 <page2kva>
c010339e:	83 c4 10             	add    $0x10,%esp
}
c01033a1:	c9                   	leave  
c01033a2:	c3                   	ret    

c01033a3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01033a3:	55                   	push   %ebp
c01033a4:	89 e5                	mov    %esp,%ebp
c01033a6:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01033a9:	e8 6d f9 ff ff       	call   c0102d1b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01033ae:	e8 5d fa ff ff       	call   c0102e10 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01033b3:	e8 2d 04 00 00       	call   c01037e5 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01033b8:	e8 a3 ff ff ff       	call   c0103360 <boot_alloc_page>
c01033bd:	a3 c4 a8 11 c0       	mov    %eax,0xc011a8c4
    memset(boot_pgdir, 0, PGSIZE);
c01033c2:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c01033c7:	83 ec 04             	sub    $0x4,%esp
c01033ca:	68 00 10 00 00       	push   $0x1000
c01033cf:	6a 00                	push   $0x0
c01033d1:	50                   	push   %eax
c01033d2:	e8 90 2d 00 00       	call   c0106167 <memset>
c01033d7:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c01033da:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c01033df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033e2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01033e9:	77 17                	ja     c0103402 <pmm_init+0x5f>
c01033eb:	ff 75 f4             	pushl  -0xc(%ebp)
c01033ee:	68 40 71 10 c0       	push   $0xc0107140
c01033f3:	68 40 01 00 00       	push   $0x140
c01033f8:	68 64 71 10 c0       	push   $0xc0107164
c01033fd:	e8 cb cf ff ff       	call   c01003cd <__panic>
c0103402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103405:	05 00 00 00 40       	add    $0x40000000,%eax
c010340a:	a3 60 a9 11 c0       	mov    %eax,0xc011a960

    check_pgdir();
c010340f:	e8 f4 03 00 00       	call   c0103808 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103414:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103419:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010341f:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103424:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103427:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010342e:	77 17                	ja     c0103447 <pmm_init+0xa4>
c0103430:	ff 75 f0             	pushl  -0x10(%ebp)
c0103433:	68 40 71 10 c0       	push   $0xc0107140
c0103438:	68 48 01 00 00       	push   $0x148
c010343d:	68 64 71 10 c0       	push   $0xc0107164
c0103442:	e8 86 cf ff ff       	call   c01003cd <__panic>
c0103447:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010344a:	05 00 00 00 40       	add    $0x40000000,%eax
c010344f:	83 c8 03             	or     $0x3,%eax
c0103452:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103454:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103459:	83 ec 0c             	sub    $0xc,%esp
c010345c:	6a 02                	push   $0x2
c010345e:	6a 00                	push   $0x0
c0103460:	68 00 00 00 38       	push   $0x38000000
c0103465:	68 00 00 00 c0       	push   $0xc0000000
c010346a:	50                   	push   %eax
c010346b:	e8 07 fe ff ff       	call   c0103277 <boot_map_segment>
c0103470:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103473:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103478:	8b 15 c4 a8 11 c0    	mov    0xc011a8c4,%edx
c010347e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103484:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103486:	e8 b2 fd ff ff       	call   c010323d <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010348b:	e8 99 f7 ff ff       	call   c0102c29 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103490:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010349b:	e8 ce 08 00 00       	call   c0103d6e <check_boot_pgdir>

    print_pgdir();
c01034a0:	e8 c4 0c 00 00       	call   c0104169 <print_pgdir>

}
c01034a5:	90                   	nop
c01034a6:	c9                   	leave  
c01034a7:	c3                   	ret    

c01034a8 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01034a8:	55                   	push   %ebp
c01034a9:	89 e5                	mov    %esp,%ebp
c01034ab:	83 ec 28             	sub    $0x28,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    pde_t *pdep = pgdir + PDX(la);   // (1) find page directory entry
c01034ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034b1:	c1 e8 16             	shr    $0x16,%eax
c01034b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01034bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01034be:	01 d0                	add    %edx,%eax
c01034c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep) & PTE_P) != 1) {              // (2) check if entry is not present
c01034c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034c6:	8b 00                	mov    (%eax),%eax
c01034c8:	83 e0 01             	and    $0x1,%eax
c01034cb:	85 c0                	test   %eax,%eax
c01034cd:	0f 85 bd 00 00 00    	jne    c0103590 <get_pte+0xe8>
        if (!create) return NULL;                  // (3) check if creating is needed, then alloc page for page table
c01034d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01034d7:	75 0a                	jne    c01034e3 <get_pte+0x3b>
c01034d9:	b8 00 00 00 00       	mov    $0x0,%eax
c01034de:	e9 fe 00 00 00       	jmp    c01035e1 <get_pte+0x139>
        struct Page* ptPage;
        assert(ptPage = alloc_page());
c01034e3:	83 ec 0c             	sub    $0xc,%esp
c01034e6:	6a 01                	push   $0x1
c01034e8:	e8 82 f8 ff ff       	call   c0102d6f <alloc_pages>
c01034ed:	83 c4 10             	add    $0x10,%esp
c01034f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01034f7:	75 19                	jne    c0103512 <get_pte+0x6a>
c01034f9:	68 60 72 10 c0       	push   $0xc0107260
c01034fe:	68 25 72 10 c0       	push   $0xc0107225
c0103503:	68 87 01 00 00       	push   $0x187
c0103508:	68 64 71 10 c0       	push   $0xc0107164
c010350d:	e8 bb ce ff ff       	call   c01003cd <__panic>
        set_page_ref(ptPage, 1);         // (4) set page reference
c0103512:	83 ec 08             	sub    $0x8,%esp
c0103515:	6a 01                	push   $0x1
c0103517:	ff 75 f0             	pushl  -0x10(%ebp)
c010351a:	e8 4c f6 ff ff       	call   c0102b6b <set_page_ref>
c010351f:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(ptPage); // (5) get linear address of page
c0103522:	83 ec 0c             	sub    $0xc,%esp
c0103525:	ff 75 f0             	pushl  -0x10(%ebp)
c0103528:	e8 3f f5 ff ff       	call   c0102a6c <page2pa>
c010352d:	83 c4 10             	add    $0x10,%esp
c0103530:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);   // (6) clear page content using memset
c0103533:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103536:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103539:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010353c:	c1 e8 0c             	shr    $0xc,%eax
c010353f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103542:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0103547:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010354a:	72 17                	jb     c0103563 <get_pte+0xbb>
c010354c:	ff 75 e8             	pushl  -0x18(%ebp)
c010354f:	68 80 70 10 c0       	push   $0xc0107080
c0103554:	68 8a 01 00 00       	push   $0x18a
c0103559:	68 64 71 10 c0       	push   $0xc0107164
c010355e:	e8 6a ce ff ff       	call   c01003cd <__panic>
c0103563:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103566:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010356b:	83 ec 04             	sub    $0x4,%esp
c010356e:	68 00 10 00 00       	push   $0x1000
c0103573:	6a 00                	push   $0x0
c0103575:	50                   	push   %eax
c0103576:	e8 ec 2b 00 00       	call   c0106167 <memset>
c010357b:	83 c4 10             	add    $0x10,%esp
        *pdep = ((pa & ~0x0FFF) | PTE_U | PTE_W | PTE_P);                  // (7) set page directory entry's permission
c010357e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103581:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103586:	83 c8 07             	or     $0x7,%eax
c0103589:	89 c2                	mov    %eax,%edx
c010358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358e:	89 10                	mov    %edx,(%eax)
    }
    return ((pte_t*)KADDR((*pdep) & ~0xFFF)) + PTX(la);          // (8) return page table entry
c0103590:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103593:	8b 00                	mov    (%eax),%eax
c0103595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010359a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010359d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035a0:	c1 e8 0c             	shr    $0xc,%eax
c01035a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035a6:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c01035ab:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01035ae:	72 17                	jb     c01035c7 <get_pte+0x11f>
c01035b0:	ff 75 e0             	pushl  -0x20(%ebp)
c01035b3:	68 80 70 10 c0       	push   $0xc0107080
c01035b8:	68 8d 01 00 00       	push   $0x18d
c01035bd:	68 64 71 10 c0       	push   $0xc0107164
c01035c2:	e8 06 ce ff ff       	call   c01003cd <__panic>
c01035c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035ca:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01035cf:	89 c2                	mov    %eax,%edx
c01035d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035d4:	c1 e8 0c             	shr    $0xc,%eax
c01035d7:	25 ff 03 00 00       	and    $0x3ff,%eax
c01035dc:	c1 e0 02             	shl    $0x2,%eax
c01035df:	01 d0                	add    %edx,%eax
}
c01035e1:	c9                   	leave  
c01035e2:	c3                   	ret    

c01035e3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01035e3:	55                   	push   %ebp
c01035e4:	89 e5                	mov    %esp,%ebp
c01035e6:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01035e9:	83 ec 04             	sub    $0x4,%esp
c01035ec:	6a 00                	push   $0x0
c01035ee:	ff 75 0c             	pushl  0xc(%ebp)
c01035f1:	ff 75 08             	pushl  0x8(%ebp)
c01035f4:	e8 af fe ff ff       	call   c01034a8 <get_pte>
c01035f9:	83 c4 10             	add    $0x10,%esp
c01035fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01035ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103603:	74 08                	je     c010360d <get_page+0x2a>
        *ptep_store = ptep;
c0103605:	8b 45 10             	mov    0x10(%ebp),%eax
c0103608:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010360b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010360d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103611:	74 1f                	je     c0103632 <get_page+0x4f>
c0103613:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103616:	8b 00                	mov    (%eax),%eax
c0103618:	83 e0 01             	and    $0x1,%eax
c010361b:	85 c0                	test   %eax,%eax
c010361d:	74 13                	je     c0103632 <get_page+0x4f>
        return pte2page(*ptep);
c010361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103622:	8b 00                	mov    (%eax),%eax
c0103624:	83 ec 0c             	sub    $0xc,%esp
c0103627:	50                   	push   %eax
c0103628:	e8 de f4 ff ff       	call   c0102b0b <pte2page>
c010362d:	83 c4 10             	add    $0x10,%esp
c0103630:	eb 05                	jmp    c0103637 <get_page+0x54>
    }
    return NULL;
c0103632:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103637:	c9                   	leave  
c0103638:	c3                   	ret    

c0103639 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103639:	55                   	push   %ebp
c010363a:	89 e5                	mov    %esp,%ebp
c010363c:	83 ec 18             	sub    $0x18,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (((*ptep) & PTE_P) == 1) {                      //(1) check if this page table entry is present
c010363f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103642:	8b 00                	mov    (%eax),%eax
c0103644:	83 e0 01             	and    $0x1,%eax
c0103647:	85 c0                	test   %eax,%eax
c0103649:	74 55                	je     c01036a0 <page_remove_pte+0x67>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c010364b:	8b 45 10             	mov    0x10(%ebp),%eax
c010364e:	8b 00                	mov    (%eax),%eax
c0103650:	83 ec 0c             	sub    $0xc,%esp
c0103653:	50                   	push   %eax
c0103654:	e8 b2 f4 ff ff       	call   c0102b0b <pte2page>
c0103659:	83 c4 10             	add    $0x10,%esp
c010365c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
c010365f:	83 ec 0c             	sub    $0xc,%esp
c0103662:	ff 75 f4             	pushl  -0xc(%ebp)
c0103665:	e8 26 f5 ff ff       	call   c0102b90 <page_ref_dec>
c010366a:	83 c4 10             	add    $0x10,%esp
        if (page->ref == 0) {
c010366d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103670:	8b 00                	mov    (%eax),%eax
c0103672:	85 c0                	test   %eax,%eax
c0103674:	75 10                	jne    c0103686 <page_remove_pte+0x4d>
        	free_page(page);           //(4) and free this page when page reference reachs 0
c0103676:	83 ec 08             	sub    $0x8,%esp
c0103679:	6a 01                	push   $0x1
c010367b:	ff 75 f4             	pushl  -0xc(%ebp)
c010367e:	e8 2a f7 ff ff       	call   c0102dad <free_pages>
c0103683:	83 c4 10             	add    $0x10,%esp
        }
        (*ptep) = 0;                          //(5) clear second page table entry
c0103686:	8b 45 10             	mov    0x10(%ebp),%eax
c0103689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
c010368f:	83 ec 08             	sub    $0x8,%esp
c0103692:	ff 75 0c             	pushl  0xc(%ebp)
c0103695:	ff 75 08             	pushl  0x8(%ebp)
c0103698:	e8 f8 00 00 00       	call   c0103795 <tlb_invalidate>
c010369d:	83 c4 10             	add    $0x10,%esp
    }
    // Should I check whether all entries in PT is not present and recycle the PT?
    // Then Maybe I should set the pde to be not present.
}
c01036a0:	90                   	nop
c01036a1:	c9                   	leave  
c01036a2:	c3                   	ret    

c01036a3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01036a3:	55                   	push   %ebp
c01036a4:	89 e5                	mov    %esp,%ebp
c01036a6:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01036a9:	83 ec 04             	sub    $0x4,%esp
c01036ac:	6a 00                	push   $0x0
c01036ae:	ff 75 0c             	pushl  0xc(%ebp)
c01036b1:	ff 75 08             	pushl  0x8(%ebp)
c01036b4:	e8 ef fd ff ff       	call   c01034a8 <get_pte>
c01036b9:	83 c4 10             	add    $0x10,%esp
c01036bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01036bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036c3:	74 14                	je     c01036d9 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c01036c5:	83 ec 04             	sub    $0x4,%esp
c01036c8:	ff 75 f4             	pushl  -0xc(%ebp)
c01036cb:	ff 75 0c             	pushl  0xc(%ebp)
c01036ce:	ff 75 08             	pushl  0x8(%ebp)
c01036d1:	e8 63 ff ff ff       	call   c0103639 <page_remove_pte>
c01036d6:	83 c4 10             	add    $0x10,%esp
    }
}
c01036d9:	90                   	nop
c01036da:	c9                   	leave  
c01036db:	c3                   	ret    

c01036dc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01036dc:	55                   	push   %ebp
c01036dd:	89 e5                	mov    %esp,%ebp
c01036df:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01036e2:	83 ec 04             	sub    $0x4,%esp
c01036e5:	6a 01                	push   $0x1
c01036e7:	ff 75 10             	pushl  0x10(%ebp)
c01036ea:	ff 75 08             	pushl  0x8(%ebp)
c01036ed:	e8 b6 fd ff ff       	call   c01034a8 <get_pte>
c01036f2:	83 c4 10             	add    $0x10,%esp
c01036f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01036f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036fc:	75 0a                	jne    c0103708 <page_insert+0x2c>
        return -E_NO_MEM;
c01036fe:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103703:	e9 8b 00 00 00       	jmp    c0103793 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103708:	83 ec 0c             	sub    $0xc,%esp
c010370b:	ff 75 0c             	pushl  0xc(%ebp)
c010370e:	e8 66 f4 ff ff       	call   c0102b79 <page_ref_inc>
c0103713:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0103716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103719:	8b 00                	mov    (%eax),%eax
c010371b:	83 e0 01             	and    $0x1,%eax
c010371e:	85 c0                	test   %eax,%eax
c0103720:	74 40                	je     c0103762 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0103722:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103725:	8b 00                	mov    (%eax),%eax
c0103727:	83 ec 0c             	sub    $0xc,%esp
c010372a:	50                   	push   %eax
c010372b:	e8 db f3 ff ff       	call   c0102b0b <pte2page>
c0103730:	83 c4 10             	add    $0x10,%esp
c0103733:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103736:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103739:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010373c:	75 10                	jne    c010374e <page_insert+0x72>
            page_ref_dec(page);
c010373e:	83 ec 0c             	sub    $0xc,%esp
c0103741:	ff 75 0c             	pushl  0xc(%ebp)
c0103744:	e8 47 f4 ff ff       	call   c0102b90 <page_ref_dec>
c0103749:	83 c4 10             	add    $0x10,%esp
c010374c:	eb 14                	jmp    c0103762 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010374e:	83 ec 04             	sub    $0x4,%esp
c0103751:	ff 75 f4             	pushl  -0xc(%ebp)
c0103754:	ff 75 10             	pushl  0x10(%ebp)
c0103757:	ff 75 08             	pushl  0x8(%ebp)
c010375a:	e8 da fe ff ff       	call   c0103639 <page_remove_pte>
c010375f:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103762:	83 ec 0c             	sub    $0xc,%esp
c0103765:	ff 75 0c             	pushl  0xc(%ebp)
c0103768:	e8 ff f2 ff ff       	call   c0102a6c <page2pa>
c010376d:	83 c4 10             	add    $0x10,%esp
c0103770:	0b 45 14             	or     0x14(%ebp),%eax
c0103773:	83 c8 01             	or     $0x1,%eax
c0103776:	89 c2                	mov    %eax,%edx
c0103778:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010377d:	83 ec 08             	sub    $0x8,%esp
c0103780:	ff 75 10             	pushl  0x10(%ebp)
c0103783:	ff 75 08             	pushl  0x8(%ebp)
c0103786:	e8 0a 00 00 00       	call   c0103795 <tlb_invalidate>
c010378b:	83 c4 10             	add    $0x10,%esp
    return 0;
c010378e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103793:	c9                   	leave  
c0103794:	c3                   	ret    

c0103795 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103795:	55                   	push   %ebp
c0103796:	89 e5                	mov    %esp,%ebp
c0103798:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010379b:	0f 20 d8             	mov    %cr3,%eax
c010379e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c01037a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01037a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01037a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037aa:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01037b1:	77 17                	ja     c01037ca <tlb_invalidate+0x35>
c01037b3:	ff 75 f0             	pushl  -0x10(%ebp)
c01037b6:	68 40 71 10 c0       	push   $0xc0107140
c01037bb:	68 e9 01 00 00       	push   $0x1e9
c01037c0:	68 64 71 10 c0       	push   $0xc0107164
c01037c5:	e8 03 cc ff ff       	call   c01003cd <__panic>
c01037ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037cd:	05 00 00 00 40       	add    $0x40000000,%eax
c01037d2:	39 c2                	cmp    %eax,%edx
c01037d4:	75 0c                	jne    c01037e2 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01037d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01037dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037df:	0f 01 38             	invlpg (%eax)
    }
}
c01037e2:	90                   	nop
c01037e3:	c9                   	leave  
c01037e4:	c3                   	ret    

c01037e5 <check_alloc_page>:

static void
check_alloc_page(void) {
c01037e5:	55                   	push   %ebp
c01037e6:	89 e5                	mov    %esp,%ebp
c01037e8:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01037eb:	a1 5c a9 11 c0       	mov    0xc011a95c,%eax
c01037f0:	8b 40 18             	mov    0x18(%eax),%eax
c01037f3:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01037f5:	83 ec 0c             	sub    $0xc,%esp
c01037f8:	68 78 72 10 c0       	push   $0xc0107278
c01037fd:	e8 65 ca ff ff       	call   c0100267 <cprintf>
c0103802:	83 c4 10             	add    $0x10,%esp
}
c0103805:	90                   	nop
c0103806:	c9                   	leave  
c0103807:	c3                   	ret    

c0103808 <check_pgdir>:

static void
check_pgdir(void) {
c0103808:	55                   	push   %ebp
c0103809:	89 e5                	mov    %esp,%ebp
c010380b:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010380e:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0103813:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103818:	76 19                	jbe    c0103833 <check_pgdir+0x2b>
c010381a:	68 97 72 10 c0       	push   $0xc0107297
c010381f:	68 25 72 10 c0       	push   $0xc0107225
c0103824:	68 f6 01 00 00       	push   $0x1f6
c0103829:	68 64 71 10 c0       	push   $0xc0107164
c010382e:	e8 9a cb ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103833:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103838:	85 c0                	test   %eax,%eax
c010383a:	74 0e                	je     c010384a <check_pgdir+0x42>
c010383c:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103841:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103846:	85 c0                	test   %eax,%eax
c0103848:	74 19                	je     c0103863 <check_pgdir+0x5b>
c010384a:	68 b4 72 10 c0       	push   $0xc01072b4
c010384f:	68 25 72 10 c0       	push   $0xc0107225
c0103854:	68 f7 01 00 00       	push   $0x1f7
c0103859:	68 64 71 10 c0       	push   $0xc0107164
c010385e:	e8 6a cb ff ff       	call   c01003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103863:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103868:	83 ec 04             	sub    $0x4,%esp
c010386b:	6a 00                	push   $0x0
c010386d:	6a 00                	push   $0x0
c010386f:	50                   	push   %eax
c0103870:	e8 6e fd ff ff       	call   c01035e3 <get_page>
c0103875:	83 c4 10             	add    $0x10,%esp
c0103878:	85 c0                	test   %eax,%eax
c010387a:	74 19                	je     c0103895 <check_pgdir+0x8d>
c010387c:	68 ec 72 10 c0       	push   $0xc01072ec
c0103881:	68 25 72 10 c0       	push   $0xc0107225
c0103886:	68 f8 01 00 00       	push   $0x1f8
c010388b:	68 64 71 10 c0       	push   $0xc0107164
c0103890:	e8 38 cb ff ff       	call   c01003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103895:	83 ec 0c             	sub    $0xc,%esp
c0103898:	6a 01                	push   $0x1
c010389a:	e8 d0 f4 ff ff       	call   c0102d6f <alloc_pages>
c010389f:	83 c4 10             	add    $0x10,%esp
c01038a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01038a5:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c01038aa:	6a 00                	push   $0x0
c01038ac:	6a 00                	push   $0x0
c01038ae:	ff 75 f4             	pushl  -0xc(%ebp)
c01038b1:	50                   	push   %eax
c01038b2:	e8 25 fe ff ff       	call   c01036dc <page_insert>
c01038b7:	83 c4 10             	add    $0x10,%esp
c01038ba:	85 c0                	test   %eax,%eax
c01038bc:	74 19                	je     c01038d7 <check_pgdir+0xcf>
c01038be:	68 14 73 10 c0       	push   $0xc0107314
c01038c3:	68 25 72 10 c0       	push   $0xc0107225
c01038c8:	68 fc 01 00 00       	push   $0x1fc
c01038cd:	68 64 71 10 c0       	push   $0xc0107164
c01038d2:	e8 f6 ca ff ff       	call   c01003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01038d7:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c01038dc:	83 ec 04             	sub    $0x4,%esp
c01038df:	6a 00                	push   $0x0
c01038e1:	6a 00                	push   $0x0
c01038e3:	50                   	push   %eax
c01038e4:	e8 bf fb ff ff       	call   c01034a8 <get_pte>
c01038e9:	83 c4 10             	add    $0x10,%esp
c01038ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038f3:	75 19                	jne    c010390e <check_pgdir+0x106>
c01038f5:	68 40 73 10 c0       	push   $0xc0107340
c01038fa:	68 25 72 10 c0       	push   $0xc0107225
c01038ff:	68 ff 01 00 00       	push   $0x1ff
c0103904:	68 64 71 10 c0       	push   $0xc0107164
c0103909:	e8 bf ca ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c010390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103911:	8b 00                	mov    (%eax),%eax
c0103913:	83 ec 0c             	sub    $0xc,%esp
c0103916:	50                   	push   %eax
c0103917:	e8 ef f1 ff ff       	call   c0102b0b <pte2page>
c010391c:	83 c4 10             	add    $0x10,%esp
c010391f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103922:	74 19                	je     c010393d <check_pgdir+0x135>
c0103924:	68 6d 73 10 c0       	push   $0xc010736d
c0103929:	68 25 72 10 c0       	push   $0xc0107225
c010392e:	68 00 02 00 00       	push   $0x200
c0103933:	68 64 71 10 c0       	push   $0xc0107164
c0103938:	e8 90 ca ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 1);
c010393d:	83 ec 0c             	sub    $0xc,%esp
c0103940:	ff 75 f4             	pushl  -0xc(%ebp)
c0103943:	e8 19 f2 ff ff       	call   c0102b61 <page_ref>
c0103948:	83 c4 10             	add    $0x10,%esp
c010394b:	83 f8 01             	cmp    $0x1,%eax
c010394e:	74 19                	je     c0103969 <check_pgdir+0x161>
c0103950:	68 83 73 10 c0       	push   $0xc0107383
c0103955:	68 25 72 10 c0       	push   $0xc0107225
c010395a:	68 01 02 00 00       	push   $0x201
c010395f:	68 64 71 10 c0       	push   $0xc0107164
c0103964:	e8 64 ca ff ff       	call   c01003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103969:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c010396e:	8b 00                	mov    (%eax),%eax
c0103970:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103975:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010397b:	c1 e8 0c             	shr    $0xc,%eax
c010397e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103981:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0103986:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103989:	72 17                	jb     c01039a2 <check_pgdir+0x19a>
c010398b:	ff 75 ec             	pushl  -0x14(%ebp)
c010398e:	68 80 70 10 c0       	push   $0xc0107080
c0103993:	68 03 02 00 00       	push   $0x203
c0103998:	68 64 71 10 c0       	push   $0xc0107164
c010399d:	e8 2b ca ff ff       	call   c01003cd <__panic>
c01039a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01039aa:	83 c0 04             	add    $0x4,%eax
c01039ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01039b0:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c01039b5:	83 ec 04             	sub    $0x4,%esp
c01039b8:	6a 00                	push   $0x0
c01039ba:	68 00 10 00 00       	push   $0x1000
c01039bf:	50                   	push   %eax
c01039c0:	e8 e3 fa ff ff       	call   c01034a8 <get_pte>
c01039c5:	83 c4 10             	add    $0x10,%esp
c01039c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01039cb:	74 19                	je     c01039e6 <check_pgdir+0x1de>
c01039cd:	68 98 73 10 c0       	push   $0xc0107398
c01039d2:	68 25 72 10 c0       	push   $0xc0107225
c01039d7:	68 04 02 00 00       	push   $0x204
c01039dc:	68 64 71 10 c0       	push   $0xc0107164
c01039e1:	e8 e7 c9 ff ff       	call   c01003cd <__panic>

    p2 = alloc_page();
c01039e6:	83 ec 0c             	sub    $0xc,%esp
c01039e9:	6a 01                	push   $0x1
c01039eb:	e8 7f f3 ff ff       	call   c0102d6f <alloc_pages>
c01039f0:	83 c4 10             	add    $0x10,%esp
c01039f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01039f6:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c01039fb:	6a 06                	push   $0x6
c01039fd:	68 00 10 00 00       	push   $0x1000
c0103a02:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a05:	50                   	push   %eax
c0103a06:	e8 d1 fc ff ff       	call   c01036dc <page_insert>
c0103a0b:	83 c4 10             	add    $0x10,%esp
c0103a0e:	85 c0                	test   %eax,%eax
c0103a10:	74 19                	je     c0103a2b <check_pgdir+0x223>
c0103a12:	68 c0 73 10 c0       	push   $0xc01073c0
c0103a17:	68 25 72 10 c0       	push   $0xc0107225
c0103a1c:	68 07 02 00 00       	push   $0x207
c0103a21:	68 64 71 10 c0       	push   $0xc0107164
c0103a26:	e8 a2 c9 ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a2b:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103a30:	83 ec 04             	sub    $0x4,%esp
c0103a33:	6a 00                	push   $0x0
c0103a35:	68 00 10 00 00       	push   $0x1000
c0103a3a:	50                   	push   %eax
c0103a3b:	e8 68 fa ff ff       	call   c01034a8 <get_pte>
c0103a40:	83 c4 10             	add    $0x10,%esp
c0103a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a4a:	75 19                	jne    c0103a65 <check_pgdir+0x25d>
c0103a4c:	68 f8 73 10 c0       	push   $0xc01073f8
c0103a51:	68 25 72 10 c0       	push   $0xc0107225
c0103a56:	68 08 02 00 00       	push   $0x208
c0103a5b:	68 64 71 10 c0       	push   $0xc0107164
c0103a60:	e8 68 c9 ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_U);
c0103a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a68:	8b 00                	mov    (%eax),%eax
c0103a6a:	83 e0 04             	and    $0x4,%eax
c0103a6d:	85 c0                	test   %eax,%eax
c0103a6f:	75 19                	jne    c0103a8a <check_pgdir+0x282>
c0103a71:	68 28 74 10 c0       	push   $0xc0107428
c0103a76:	68 25 72 10 c0       	push   $0xc0107225
c0103a7b:	68 09 02 00 00       	push   $0x209
c0103a80:	68 64 71 10 c0       	push   $0xc0107164
c0103a85:	e8 43 c9 ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_W);
c0103a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a8d:	8b 00                	mov    (%eax),%eax
c0103a8f:	83 e0 02             	and    $0x2,%eax
c0103a92:	85 c0                	test   %eax,%eax
c0103a94:	75 19                	jne    c0103aaf <check_pgdir+0x2a7>
c0103a96:	68 36 74 10 c0       	push   $0xc0107436
c0103a9b:	68 25 72 10 c0       	push   $0xc0107225
c0103aa0:	68 0a 02 00 00       	push   $0x20a
c0103aa5:	68 64 71 10 c0       	push   $0xc0107164
c0103aaa:	e8 1e c9 ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103aaf:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103ab4:	8b 00                	mov    (%eax),%eax
c0103ab6:	83 e0 04             	and    $0x4,%eax
c0103ab9:	85 c0                	test   %eax,%eax
c0103abb:	75 19                	jne    c0103ad6 <check_pgdir+0x2ce>
c0103abd:	68 44 74 10 c0       	push   $0xc0107444
c0103ac2:	68 25 72 10 c0       	push   $0xc0107225
c0103ac7:	68 0b 02 00 00       	push   $0x20b
c0103acc:	68 64 71 10 c0       	push   $0xc0107164
c0103ad1:	e8 f7 c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 1);
c0103ad6:	83 ec 0c             	sub    $0xc,%esp
c0103ad9:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103adc:	e8 80 f0 ff ff       	call   c0102b61 <page_ref>
c0103ae1:	83 c4 10             	add    $0x10,%esp
c0103ae4:	83 f8 01             	cmp    $0x1,%eax
c0103ae7:	74 19                	je     c0103b02 <check_pgdir+0x2fa>
c0103ae9:	68 5a 74 10 c0       	push   $0xc010745a
c0103aee:	68 25 72 10 c0       	push   $0xc0107225
c0103af3:	68 0c 02 00 00       	push   $0x20c
c0103af8:	68 64 71 10 c0       	push   $0xc0107164
c0103afd:	e8 cb c8 ff ff       	call   c01003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103b02:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103b07:	6a 00                	push   $0x0
c0103b09:	68 00 10 00 00       	push   $0x1000
c0103b0e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b11:	50                   	push   %eax
c0103b12:	e8 c5 fb ff ff       	call   c01036dc <page_insert>
c0103b17:	83 c4 10             	add    $0x10,%esp
c0103b1a:	85 c0                	test   %eax,%eax
c0103b1c:	74 19                	je     c0103b37 <check_pgdir+0x32f>
c0103b1e:	68 6c 74 10 c0       	push   $0xc010746c
c0103b23:	68 25 72 10 c0       	push   $0xc0107225
c0103b28:	68 0e 02 00 00       	push   $0x20e
c0103b2d:	68 64 71 10 c0       	push   $0xc0107164
c0103b32:	e8 96 c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 2);
c0103b37:	83 ec 0c             	sub    $0xc,%esp
c0103b3a:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b3d:	e8 1f f0 ff ff       	call   c0102b61 <page_ref>
c0103b42:	83 c4 10             	add    $0x10,%esp
c0103b45:	83 f8 02             	cmp    $0x2,%eax
c0103b48:	74 19                	je     c0103b63 <check_pgdir+0x35b>
c0103b4a:	68 98 74 10 c0       	push   $0xc0107498
c0103b4f:	68 25 72 10 c0       	push   $0xc0107225
c0103b54:	68 0f 02 00 00       	push   $0x20f
c0103b59:	68 64 71 10 c0       	push   $0xc0107164
c0103b5e:	e8 6a c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103b63:	83 ec 0c             	sub    $0xc,%esp
c0103b66:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b69:	e8 f3 ef ff ff       	call   c0102b61 <page_ref>
c0103b6e:	83 c4 10             	add    $0x10,%esp
c0103b71:	85 c0                	test   %eax,%eax
c0103b73:	74 19                	je     c0103b8e <check_pgdir+0x386>
c0103b75:	68 aa 74 10 c0       	push   $0xc01074aa
c0103b7a:	68 25 72 10 c0       	push   $0xc0107225
c0103b7f:	68 10 02 00 00       	push   $0x210
c0103b84:	68 64 71 10 c0       	push   $0xc0107164
c0103b89:	e8 3f c8 ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103b8e:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103b93:	83 ec 04             	sub    $0x4,%esp
c0103b96:	6a 00                	push   $0x0
c0103b98:	68 00 10 00 00       	push   $0x1000
c0103b9d:	50                   	push   %eax
c0103b9e:	e8 05 f9 ff ff       	call   c01034a8 <get_pte>
c0103ba3:	83 c4 10             	add    $0x10,%esp
c0103ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bad:	75 19                	jne    c0103bc8 <check_pgdir+0x3c0>
c0103baf:	68 f8 73 10 c0       	push   $0xc01073f8
c0103bb4:	68 25 72 10 c0       	push   $0xc0107225
c0103bb9:	68 11 02 00 00       	push   $0x211
c0103bbe:	68 64 71 10 c0       	push   $0xc0107164
c0103bc3:	e8 05 c8 ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c0103bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bcb:	8b 00                	mov    (%eax),%eax
c0103bcd:	83 ec 0c             	sub    $0xc,%esp
c0103bd0:	50                   	push   %eax
c0103bd1:	e8 35 ef ff ff       	call   c0102b0b <pte2page>
c0103bd6:	83 c4 10             	add    $0x10,%esp
c0103bd9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103bdc:	74 19                	je     c0103bf7 <check_pgdir+0x3ef>
c0103bde:	68 6d 73 10 c0       	push   $0xc010736d
c0103be3:	68 25 72 10 c0       	push   $0xc0107225
c0103be8:	68 12 02 00 00       	push   $0x212
c0103bed:	68 64 71 10 c0       	push   $0xc0107164
c0103bf2:	e8 d6 c7 ff ff       	call   c01003cd <__panic>
    assert((*ptep & PTE_U) == 0);
c0103bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bfa:	8b 00                	mov    (%eax),%eax
c0103bfc:	83 e0 04             	and    $0x4,%eax
c0103bff:	85 c0                	test   %eax,%eax
c0103c01:	74 19                	je     c0103c1c <check_pgdir+0x414>
c0103c03:	68 bc 74 10 c0       	push   $0xc01074bc
c0103c08:	68 25 72 10 c0       	push   $0xc0107225
c0103c0d:	68 13 02 00 00       	push   $0x213
c0103c12:	68 64 71 10 c0       	push   $0xc0107164
c0103c17:	e8 b1 c7 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, 0x0);
c0103c1c:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103c21:	83 ec 08             	sub    $0x8,%esp
c0103c24:	6a 00                	push   $0x0
c0103c26:	50                   	push   %eax
c0103c27:	e8 77 fa ff ff       	call   c01036a3 <page_remove>
c0103c2c:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103c2f:	83 ec 0c             	sub    $0xc,%esp
c0103c32:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c35:	e8 27 ef ff ff       	call   c0102b61 <page_ref>
c0103c3a:	83 c4 10             	add    $0x10,%esp
c0103c3d:	83 f8 01             	cmp    $0x1,%eax
c0103c40:	74 19                	je     c0103c5b <check_pgdir+0x453>
c0103c42:	68 83 73 10 c0       	push   $0xc0107383
c0103c47:	68 25 72 10 c0       	push   $0xc0107225
c0103c4c:	68 16 02 00 00       	push   $0x216
c0103c51:	68 64 71 10 c0       	push   $0xc0107164
c0103c56:	e8 72 c7 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103c5b:	83 ec 0c             	sub    $0xc,%esp
c0103c5e:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103c61:	e8 fb ee ff ff       	call   c0102b61 <page_ref>
c0103c66:	83 c4 10             	add    $0x10,%esp
c0103c69:	85 c0                	test   %eax,%eax
c0103c6b:	74 19                	je     c0103c86 <check_pgdir+0x47e>
c0103c6d:	68 aa 74 10 c0       	push   $0xc01074aa
c0103c72:	68 25 72 10 c0       	push   $0xc0107225
c0103c77:	68 17 02 00 00       	push   $0x217
c0103c7c:	68 64 71 10 c0       	push   $0xc0107164
c0103c81:	e8 47 c7 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103c86:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103c8b:	83 ec 08             	sub    $0x8,%esp
c0103c8e:	68 00 10 00 00       	push   $0x1000
c0103c93:	50                   	push   %eax
c0103c94:	e8 0a fa ff ff       	call   c01036a3 <page_remove>
c0103c99:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103c9c:	83 ec 0c             	sub    $0xc,%esp
c0103c9f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ca2:	e8 ba ee ff ff       	call   c0102b61 <page_ref>
c0103ca7:	83 c4 10             	add    $0x10,%esp
c0103caa:	85 c0                	test   %eax,%eax
c0103cac:	74 19                	je     c0103cc7 <check_pgdir+0x4bf>
c0103cae:	68 d1 74 10 c0       	push   $0xc01074d1
c0103cb3:	68 25 72 10 c0       	push   $0xc0107225
c0103cb8:	68 1a 02 00 00       	push   $0x21a
c0103cbd:	68 64 71 10 c0       	push   $0xc0107164
c0103cc2:	e8 06 c7 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103cc7:	83 ec 0c             	sub    $0xc,%esp
c0103cca:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103ccd:	e8 8f ee ff ff       	call   c0102b61 <page_ref>
c0103cd2:	83 c4 10             	add    $0x10,%esp
c0103cd5:	85 c0                	test   %eax,%eax
c0103cd7:	74 19                	je     c0103cf2 <check_pgdir+0x4ea>
c0103cd9:	68 aa 74 10 c0       	push   $0xc01074aa
c0103cde:	68 25 72 10 c0       	push   $0xc0107225
c0103ce3:	68 1b 02 00 00       	push   $0x21b
c0103ce8:	68 64 71 10 c0       	push   $0xc0107164
c0103ced:	e8 db c6 ff ff       	call   c01003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103cf2:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103cf7:	8b 00                	mov    (%eax),%eax
c0103cf9:	83 ec 0c             	sub    $0xc,%esp
c0103cfc:	50                   	push   %eax
c0103cfd:	e8 43 ee ff ff       	call   c0102b45 <pde2page>
c0103d02:	83 c4 10             	add    $0x10,%esp
c0103d05:	83 ec 0c             	sub    $0xc,%esp
c0103d08:	50                   	push   %eax
c0103d09:	e8 53 ee ff ff       	call   c0102b61 <page_ref>
c0103d0e:	83 c4 10             	add    $0x10,%esp
c0103d11:	83 f8 01             	cmp    $0x1,%eax
c0103d14:	74 19                	je     c0103d2f <check_pgdir+0x527>
c0103d16:	68 e4 74 10 c0       	push   $0xc01074e4
c0103d1b:	68 25 72 10 c0       	push   $0xc0107225
c0103d20:	68 1d 02 00 00       	push   $0x21d
c0103d25:	68 64 71 10 c0       	push   $0xc0107164
c0103d2a:	e8 9e c6 ff ff       	call   c01003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103d2f:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103d34:	8b 00                	mov    (%eax),%eax
c0103d36:	83 ec 0c             	sub    $0xc,%esp
c0103d39:	50                   	push   %eax
c0103d3a:	e8 06 ee ff ff       	call   c0102b45 <pde2page>
c0103d3f:	83 c4 10             	add    $0x10,%esp
c0103d42:	83 ec 08             	sub    $0x8,%esp
c0103d45:	6a 01                	push   $0x1
c0103d47:	50                   	push   %eax
c0103d48:	e8 60 f0 ff ff       	call   c0102dad <free_pages>
c0103d4d:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103d50:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103d55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103d5b:	83 ec 0c             	sub    $0xc,%esp
c0103d5e:	68 0b 75 10 c0       	push   $0xc010750b
c0103d63:	e8 ff c4 ff ff       	call   c0100267 <cprintf>
c0103d68:	83 c4 10             	add    $0x10,%esp
}
c0103d6b:	90                   	nop
c0103d6c:	c9                   	leave  
c0103d6d:	c3                   	ret    

c0103d6e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103d6e:	55                   	push   %ebp
c0103d6f:	89 e5                	mov    %esp,%ebp
c0103d71:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103d74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d7b:	e9 a3 00 00 00       	jmp    c0103e23 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d89:	c1 e8 0c             	shr    $0xc,%eax
c0103d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d8f:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0103d94:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103d97:	72 17                	jb     c0103db0 <check_boot_pgdir+0x42>
c0103d99:	ff 75 f0             	pushl  -0x10(%ebp)
c0103d9c:	68 80 70 10 c0       	push   $0xc0107080
c0103da1:	68 29 02 00 00       	push   $0x229
c0103da6:	68 64 71 10 c0       	push   $0xc0107164
c0103dab:	e8 1d c6 ff ff       	call   c01003cd <__panic>
c0103db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103db8:	89 c2                	mov    %eax,%edx
c0103dba:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103dbf:	83 ec 04             	sub    $0x4,%esp
c0103dc2:	6a 00                	push   $0x0
c0103dc4:	52                   	push   %edx
c0103dc5:	50                   	push   %eax
c0103dc6:	e8 dd f6 ff ff       	call   c01034a8 <get_pte>
c0103dcb:	83 c4 10             	add    $0x10,%esp
c0103dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103dd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103dd5:	75 19                	jne    c0103df0 <check_boot_pgdir+0x82>
c0103dd7:	68 28 75 10 c0       	push   $0xc0107528
c0103ddc:	68 25 72 10 c0       	push   $0xc0107225
c0103de1:	68 29 02 00 00       	push   $0x229
c0103de6:	68 64 71 10 c0       	push   $0xc0107164
c0103deb:	e8 dd c5 ff ff       	call   c01003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103df0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103df3:	8b 00                	mov    (%eax),%eax
c0103df5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103dfa:	89 c2                	mov    %eax,%edx
c0103dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dff:	39 c2                	cmp    %eax,%edx
c0103e01:	74 19                	je     c0103e1c <check_boot_pgdir+0xae>
c0103e03:	68 65 75 10 c0       	push   $0xc0107565
c0103e08:	68 25 72 10 c0       	push   $0xc0107225
c0103e0d:	68 2a 02 00 00       	push   $0x22a
c0103e12:	68 64 71 10 c0       	push   $0xc0107164
c0103e17:	e8 b1 c5 ff ff       	call   c01003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103e1c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e26:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0103e2b:	39 c2                	cmp    %eax,%edx
c0103e2d:	0f 82 4d ff ff ff    	jb     c0103d80 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103e33:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103e38:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103e3d:	8b 00                	mov    (%eax),%eax
c0103e3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e44:	89 c2                	mov    %eax,%edx
c0103e46:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103e4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e4e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103e55:	77 17                	ja     c0103e6e <check_boot_pgdir+0x100>
c0103e57:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103e5a:	68 40 71 10 c0       	push   $0xc0107140
c0103e5f:	68 2d 02 00 00       	push   $0x22d
c0103e64:	68 64 71 10 c0       	push   $0xc0107164
c0103e69:	e8 5f c5 ff ff       	call   c01003cd <__panic>
c0103e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e71:	05 00 00 00 40       	add    $0x40000000,%eax
c0103e76:	39 c2                	cmp    %eax,%edx
c0103e78:	74 19                	je     c0103e93 <check_boot_pgdir+0x125>
c0103e7a:	68 7c 75 10 c0       	push   $0xc010757c
c0103e7f:	68 25 72 10 c0       	push   $0xc0107225
c0103e84:	68 2d 02 00 00       	push   $0x22d
c0103e89:	68 64 71 10 c0       	push   $0xc0107164
c0103e8e:	e8 3a c5 ff ff       	call   c01003cd <__panic>

    assert(boot_pgdir[0] == 0);
c0103e93:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103e98:	8b 00                	mov    (%eax),%eax
c0103e9a:	85 c0                	test   %eax,%eax
c0103e9c:	74 19                	je     c0103eb7 <check_boot_pgdir+0x149>
c0103e9e:	68 b0 75 10 c0       	push   $0xc01075b0
c0103ea3:	68 25 72 10 c0       	push   $0xc0107225
c0103ea8:	68 2f 02 00 00       	push   $0x22f
c0103ead:	68 64 71 10 c0       	push   $0xc0107164
c0103eb2:	e8 16 c5 ff ff       	call   c01003cd <__panic>

    struct Page *p;
    p = alloc_page();
c0103eb7:	83 ec 0c             	sub    $0xc,%esp
c0103eba:	6a 01                	push   $0x1
c0103ebc:	e8 ae ee ff ff       	call   c0102d6f <alloc_pages>
c0103ec1:	83 c4 10             	add    $0x10,%esp
c0103ec4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103ec7:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103ecc:	6a 02                	push   $0x2
c0103ece:	68 00 01 00 00       	push   $0x100
c0103ed3:	ff 75 e0             	pushl  -0x20(%ebp)
c0103ed6:	50                   	push   %eax
c0103ed7:	e8 00 f8 ff ff       	call   c01036dc <page_insert>
c0103edc:	83 c4 10             	add    $0x10,%esp
c0103edf:	85 c0                	test   %eax,%eax
c0103ee1:	74 19                	je     c0103efc <check_boot_pgdir+0x18e>
c0103ee3:	68 c4 75 10 c0       	push   $0xc01075c4
c0103ee8:	68 25 72 10 c0       	push   $0xc0107225
c0103eed:	68 33 02 00 00       	push   $0x233
c0103ef2:	68 64 71 10 c0       	push   $0xc0107164
c0103ef7:	e8 d1 c4 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 1);
c0103efc:	83 ec 0c             	sub    $0xc,%esp
c0103eff:	ff 75 e0             	pushl  -0x20(%ebp)
c0103f02:	e8 5a ec ff ff       	call   c0102b61 <page_ref>
c0103f07:	83 c4 10             	add    $0x10,%esp
c0103f0a:	83 f8 01             	cmp    $0x1,%eax
c0103f0d:	74 19                	je     c0103f28 <check_boot_pgdir+0x1ba>
c0103f0f:	68 f2 75 10 c0       	push   $0xc01075f2
c0103f14:	68 25 72 10 c0       	push   $0xc0107225
c0103f19:	68 34 02 00 00       	push   $0x234
c0103f1e:	68 64 71 10 c0       	push   $0xc0107164
c0103f23:	e8 a5 c4 ff ff       	call   c01003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103f28:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c0103f2d:	6a 02                	push   $0x2
c0103f2f:	68 00 11 00 00       	push   $0x1100
c0103f34:	ff 75 e0             	pushl  -0x20(%ebp)
c0103f37:	50                   	push   %eax
c0103f38:	e8 9f f7 ff ff       	call   c01036dc <page_insert>
c0103f3d:	83 c4 10             	add    $0x10,%esp
c0103f40:	85 c0                	test   %eax,%eax
c0103f42:	74 19                	je     c0103f5d <check_boot_pgdir+0x1ef>
c0103f44:	68 04 76 10 c0       	push   $0xc0107604
c0103f49:	68 25 72 10 c0       	push   $0xc0107225
c0103f4e:	68 35 02 00 00       	push   $0x235
c0103f53:	68 64 71 10 c0       	push   $0xc0107164
c0103f58:	e8 70 c4 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 2);
c0103f5d:	83 ec 0c             	sub    $0xc,%esp
c0103f60:	ff 75 e0             	pushl  -0x20(%ebp)
c0103f63:	e8 f9 eb ff ff       	call   c0102b61 <page_ref>
c0103f68:	83 c4 10             	add    $0x10,%esp
c0103f6b:	83 f8 02             	cmp    $0x2,%eax
c0103f6e:	74 19                	je     c0103f89 <check_boot_pgdir+0x21b>
c0103f70:	68 3b 76 10 c0       	push   $0xc010763b
c0103f75:	68 25 72 10 c0       	push   $0xc0107225
c0103f7a:	68 36 02 00 00       	push   $0x236
c0103f7f:	68 64 71 10 c0       	push   $0xc0107164
c0103f84:	e8 44 c4 ff ff       	call   c01003cd <__panic>

    const char *str = "ucore: Hello world!!";
c0103f89:	c7 45 dc 4c 76 10 c0 	movl   $0xc010764c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103f90:	83 ec 08             	sub    $0x8,%esp
c0103f93:	ff 75 dc             	pushl  -0x24(%ebp)
c0103f96:	68 00 01 00 00       	push   $0x100
c0103f9b:	e8 ee 1e 00 00       	call   c0105e8e <strcpy>
c0103fa0:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103fa3:	83 ec 08             	sub    $0x8,%esp
c0103fa6:	68 00 11 00 00       	push   $0x1100
c0103fab:	68 00 01 00 00       	push   $0x100
c0103fb0:	e8 53 1f 00 00       	call   c0105f08 <strcmp>
c0103fb5:	83 c4 10             	add    $0x10,%esp
c0103fb8:	85 c0                	test   %eax,%eax
c0103fba:	74 19                	je     c0103fd5 <check_boot_pgdir+0x267>
c0103fbc:	68 64 76 10 c0       	push   $0xc0107664
c0103fc1:	68 25 72 10 c0       	push   $0xc0107225
c0103fc6:	68 3a 02 00 00       	push   $0x23a
c0103fcb:	68 64 71 10 c0       	push   $0xc0107164
c0103fd0:	e8 f8 c3 ff ff       	call   c01003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103fd5:	83 ec 0c             	sub    $0xc,%esp
c0103fd8:	ff 75 e0             	pushl  -0x20(%ebp)
c0103fdb:	e8 e6 ea ff ff       	call   c0102ac6 <page2kva>
c0103fe0:	83 c4 10             	add    $0x10,%esp
c0103fe3:	05 00 01 00 00       	add    $0x100,%eax
c0103fe8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103feb:	83 ec 0c             	sub    $0xc,%esp
c0103fee:	68 00 01 00 00       	push   $0x100
c0103ff3:	e8 3e 1e 00 00       	call   c0105e36 <strlen>
c0103ff8:	83 c4 10             	add    $0x10,%esp
c0103ffb:	85 c0                	test   %eax,%eax
c0103ffd:	74 19                	je     c0104018 <check_boot_pgdir+0x2aa>
c0103fff:	68 9c 76 10 c0       	push   $0xc010769c
c0104004:	68 25 72 10 c0       	push   $0xc0107225
c0104009:	68 3d 02 00 00       	push   $0x23d
c010400e:	68 64 71 10 c0       	push   $0xc0107164
c0104013:	e8 b5 c3 ff ff       	call   c01003cd <__panic>

    free_page(p);
c0104018:	83 ec 08             	sub    $0x8,%esp
c010401b:	6a 01                	push   $0x1
c010401d:	ff 75 e0             	pushl  -0x20(%ebp)
c0104020:	e8 88 ed ff ff       	call   c0102dad <free_pages>
c0104025:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0104028:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c010402d:	8b 00                	mov    (%eax),%eax
c010402f:	83 ec 0c             	sub    $0xc,%esp
c0104032:	50                   	push   %eax
c0104033:	e8 0d eb ff ff       	call   c0102b45 <pde2page>
c0104038:	83 c4 10             	add    $0x10,%esp
c010403b:	83 ec 08             	sub    $0x8,%esp
c010403e:	6a 01                	push   $0x1
c0104040:	50                   	push   %eax
c0104041:	e8 67 ed ff ff       	call   c0102dad <free_pages>
c0104046:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104049:	a1 c4 a8 11 c0       	mov    0xc011a8c4,%eax
c010404e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104054:	83 ec 0c             	sub    $0xc,%esp
c0104057:	68 c0 76 10 c0       	push   $0xc01076c0
c010405c:	e8 06 c2 ff ff       	call   c0100267 <cprintf>
c0104061:	83 c4 10             	add    $0x10,%esp
}
c0104064:	90                   	nop
c0104065:	c9                   	leave  
c0104066:	c3                   	ret    

c0104067 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104067:	55                   	push   %ebp
c0104068:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010406a:	8b 45 08             	mov    0x8(%ebp),%eax
c010406d:	83 e0 04             	and    $0x4,%eax
c0104070:	85 c0                	test   %eax,%eax
c0104072:	74 07                	je     c010407b <perm2str+0x14>
c0104074:	b8 75 00 00 00       	mov    $0x75,%eax
c0104079:	eb 05                	jmp    c0104080 <perm2str+0x19>
c010407b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104080:	a2 48 a9 11 c0       	mov    %al,0xc011a948
    str[1] = 'r';
c0104085:	c6 05 49 a9 11 c0 72 	movb   $0x72,0xc011a949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010408c:	8b 45 08             	mov    0x8(%ebp),%eax
c010408f:	83 e0 02             	and    $0x2,%eax
c0104092:	85 c0                	test   %eax,%eax
c0104094:	74 07                	je     c010409d <perm2str+0x36>
c0104096:	b8 77 00 00 00       	mov    $0x77,%eax
c010409b:	eb 05                	jmp    c01040a2 <perm2str+0x3b>
c010409d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01040a2:	a2 4a a9 11 c0       	mov    %al,0xc011a94a
    str[3] = '\0';
c01040a7:	c6 05 4b a9 11 c0 00 	movb   $0x0,0xc011a94b
    return str;
c01040ae:	b8 48 a9 11 c0       	mov    $0xc011a948,%eax
}
c01040b3:	5d                   	pop    %ebp
c01040b4:	c3                   	ret    

c01040b5 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01040b5:	55                   	push   %ebp
c01040b6:	89 e5                	mov    %esp,%ebp
c01040b8:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01040bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01040be:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01040c1:	72 0e                	jb     c01040d1 <get_pgtable_items+0x1c>
        return 0;
c01040c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01040c8:	e9 9a 00 00 00       	jmp    c0104167 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01040cd:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01040d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01040d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01040d7:	73 18                	jae    c01040f1 <get_pgtable_items+0x3c>
c01040d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01040dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01040e3:	8b 45 14             	mov    0x14(%ebp),%eax
c01040e6:	01 d0                	add    %edx,%eax
c01040e8:	8b 00                	mov    (%eax),%eax
c01040ea:	83 e0 01             	and    $0x1,%eax
c01040ed:	85 c0                	test   %eax,%eax
c01040ef:	74 dc                	je     c01040cd <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c01040f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01040f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01040f7:	73 69                	jae    c0104162 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c01040f9:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01040fd:	74 08                	je     c0104107 <get_pgtable_items+0x52>
            *left_store = start;
c01040ff:	8b 45 18             	mov    0x18(%ebp),%eax
c0104102:	8b 55 10             	mov    0x10(%ebp),%edx
c0104105:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104107:	8b 45 10             	mov    0x10(%ebp),%eax
c010410a:	8d 50 01             	lea    0x1(%eax),%edx
c010410d:	89 55 10             	mov    %edx,0x10(%ebp)
c0104110:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104117:	8b 45 14             	mov    0x14(%ebp),%eax
c010411a:	01 d0                	add    %edx,%eax
c010411c:	8b 00                	mov    (%eax),%eax
c010411e:	83 e0 07             	and    $0x7,%eax
c0104121:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104124:	eb 04                	jmp    c010412a <get_pgtable_items+0x75>
            start ++;
c0104126:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010412a:	8b 45 10             	mov    0x10(%ebp),%eax
c010412d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104130:	73 1d                	jae    c010414f <get_pgtable_items+0x9a>
c0104132:	8b 45 10             	mov    0x10(%ebp),%eax
c0104135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010413c:	8b 45 14             	mov    0x14(%ebp),%eax
c010413f:	01 d0                	add    %edx,%eax
c0104141:	8b 00                	mov    (%eax),%eax
c0104143:	83 e0 07             	and    $0x7,%eax
c0104146:	89 c2                	mov    %eax,%edx
c0104148:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010414b:	39 c2                	cmp    %eax,%edx
c010414d:	74 d7                	je     c0104126 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c010414f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104153:	74 08                	je     c010415d <get_pgtable_items+0xa8>
            *right_store = start;
c0104155:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104158:	8b 55 10             	mov    0x10(%ebp),%edx
c010415b:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010415d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104160:	eb 05                	jmp    c0104167 <get_pgtable_items+0xb2>
    }
    return 0;
c0104162:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104167:	c9                   	leave  
c0104168:	c3                   	ret    

c0104169 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104169:	55                   	push   %ebp
c010416a:	89 e5                	mov    %esp,%ebp
c010416c:	57                   	push   %edi
c010416d:	56                   	push   %esi
c010416e:	53                   	push   %ebx
c010416f:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104172:	83 ec 0c             	sub    $0xc,%esp
c0104175:	68 e0 76 10 c0       	push   $0xc01076e0
c010417a:	e8 e8 c0 ff ff       	call   c0100267 <cprintf>
c010417f:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0104182:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104189:	e9 e5 00 00 00       	jmp    c0104273 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010418e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104191:	83 ec 0c             	sub    $0xc,%esp
c0104194:	50                   	push   %eax
c0104195:	e8 cd fe ff ff       	call   c0104067 <perm2str>
c010419a:	83 c4 10             	add    $0x10,%esp
c010419d:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010419f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041a5:	29 c2                	sub    %eax,%edx
c01041a7:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01041a9:	c1 e0 16             	shl    $0x16,%eax
c01041ac:	89 c3                	mov    %eax,%ebx
c01041ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041b1:	c1 e0 16             	shl    $0x16,%eax
c01041b4:	89 c1                	mov    %eax,%ecx
c01041b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041b9:	c1 e0 16             	shl    $0x16,%eax
c01041bc:	89 c2                	mov    %eax,%edx
c01041be:	8b 75 dc             	mov    -0x24(%ebp),%esi
c01041c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041c4:	29 c6                	sub    %eax,%esi
c01041c6:	89 f0                	mov    %esi,%eax
c01041c8:	83 ec 08             	sub    $0x8,%esp
c01041cb:	57                   	push   %edi
c01041cc:	53                   	push   %ebx
c01041cd:	51                   	push   %ecx
c01041ce:	52                   	push   %edx
c01041cf:	50                   	push   %eax
c01041d0:	68 11 77 10 c0       	push   $0xc0107711
c01041d5:	e8 8d c0 ff ff       	call   c0100267 <cprintf>
c01041da:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01041dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041e0:	c1 e0 0a             	shl    $0xa,%eax
c01041e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01041e6:	eb 4f                	jmp    c0104237 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01041e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041eb:	83 ec 0c             	sub    $0xc,%esp
c01041ee:	50                   	push   %eax
c01041ef:	e8 73 fe ff ff       	call   c0104067 <perm2str>
c01041f4:	83 c4 10             	add    $0x10,%esp
c01041f7:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01041f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041ff:	29 c2                	sub    %eax,%edx
c0104201:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104203:	c1 e0 0c             	shl    $0xc,%eax
c0104206:	89 c3                	mov    %eax,%ebx
c0104208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010420b:	c1 e0 0c             	shl    $0xc,%eax
c010420e:	89 c1                	mov    %eax,%ecx
c0104210:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104213:	c1 e0 0c             	shl    $0xc,%eax
c0104216:	89 c2                	mov    %eax,%edx
c0104218:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c010421b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010421e:	29 c6                	sub    %eax,%esi
c0104220:	89 f0                	mov    %esi,%eax
c0104222:	83 ec 08             	sub    $0x8,%esp
c0104225:	57                   	push   %edi
c0104226:	53                   	push   %ebx
c0104227:	51                   	push   %ecx
c0104228:	52                   	push   %edx
c0104229:	50                   	push   %eax
c010422a:	68 30 77 10 c0       	push   $0xc0107730
c010422f:	e8 33 c0 ff ff       	call   c0100267 <cprintf>
c0104234:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104237:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010423c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010423f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104242:	89 d3                	mov    %edx,%ebx
c0104244:	c1 e3 0a             	shl    $0xa,%ebx
c0104247:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010424a:	89 d1                	mov    %edx,%ecx
c010424c:	c1 e1 0a             	shl    $0xa,%ecx
c010424f:	83 ec 08             	sub    $0x8,%esp
c0104252:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104255:	52                   	push   %edx
c0104256:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104259:	52                   	push   %edx
c010425a:	56                   	push   %esi
c010425b:	50                   	push   %eax
c010425c:	53                   	push   %ebx
c010425d:	51                   	push   %ecx
c010425e:	e8 52 fe ff ff       	call   c01040b5 <get_pgtable_items>
c0104263:	83 c4 20             	add    $0x20,%esp
c0104266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104269:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010426d:	0f 85 75 ff ff ff    	jne    c01041e8 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104273:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104278:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010427b:	83 ec 08             	sub    $0x8,%esp
c010427e:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104281:	52                   	push   %edx
c0104282:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104285:	52                   	push   %edx
c0104286:	51                   	push   %ecx
c0104287:	50                   	push   %eax
c0104288:	68 00 04 00 00       	push   $0x400
c010428d:	6a 00                	push   $0x0
c010428f:	e8 21 fe ff ff       	call   c01040b5 <get_pgtable_items>
c0104294:	83 c4 20             	add    $0x20,%esp
c0104297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010429a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010429e:	0f 85 ea fe ff ff    	jne    c010418e <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01042a4:	83 ec 0c             	sub    $0xc,%esp
c01042a7:	68 54 77 10 c0       	push   $0xc0107754
c01042ac:	e8 b6 bf ff ff       	call   c0100267 <cprintf>
c01042b1:	83 c4 10             	add    $0x10,%esp
}
c01042b4:	90                   	nop
c01042b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01042b8:	5b                   	pop    %ebx
c01042b9:	5e                   	pop    %esi
c01042ba:	5f                   	pop    %edi
c01042bb:	5d                   	pop    %ebp
c01042bc:	c3                   	ret    

c01042bd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01042bd:	55                   	push   %ebp
c01042be:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01042c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01042c3:	8b 15 64 a9 11 c0    	mov    0xc011a964,%edx
c01042c9:	29 d0                	sub    %edx,%eax
c01042cb:	c1 f8 02             	sar    $0x2,%eax
c01042ce:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01042d4:	5d                   	pop    %ebp
c01042d5:	c3                   	ret    

c01042d6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01042d6:	55                   	push   %ebp
c01042d7:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01042d9:	ff 75 08             	pushl  0x8(%ebp)
c01042dc:	e8 dc ff ff ff       	call   c01042bd <page2ppn>
c01042e1:	83 c4 04             	add    $0x4,%esp
c01042e4:	c1 e0 0c             	shl    $0xc,%eax
}
c01042e7:	c9                   	leave  
c01042e8:	c3                   	ret    

c01042e9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01042e9:	55                   	push   %ebp
c01042ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01042ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ef:	8b 00                	mov    (%eax),%eax
}
c01042f1:	5d                   	pop    %ebp
c01042f2:	c3                   	ret    

c01042f3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01042f3:	55                   	push   %ebp
c01042f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01042f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01042f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042fc:	89 10                	mov    %edx,(%eax)
}
c01042fe:	90                   	nop
c01042ff:	5d                   	pop    %ebp
c0104300:	c3                   	ret    

c0104301 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104301:	55                   	push   %ebp
c0104302:	89 e5                	mov    %esp,%ebp
c0104304:	83 ec 10             	sub    $0x10,%esp
c0104307:	c7 45 fc 68 a9 11 c0 	movl   $0xc011a968,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010430e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104311:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104314:	89 50 04             	mov    %edx,0x4(%eax)
c0104317:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010431a:	8b 50 04             	mov    0x4(%eax),%edx
c010431d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104320:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104322:	c7 05 70 a9 11 c0 00 	movl   $0x0,0xc011a970
c0104329:	00 00 00 
}
c010432c:	90                   	nop
c010432d:	c9                   	leave  
c010432e:	c3                   	ret    

c010432f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010432f:	55                   	push   %ebp
c0104330:	89 e5                	mov    %esp,%ebp
c0104332:	83 ec 38             	sub    $0x38,%esp
	assert(n > 0);
c0104335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104339:	75 16                	jne    c0104351 <default_init_memmap+0x22>
c010433b:	68 88 77 10 c0       	push   $0xc0107788
c0104340:	68 8e 77 10 c0       	push   $0xc010778e
c0104345:	6a 46                	push   $0x46
c0104347:	68 a3 77 10 c0       	push   $0xc01077a3
c010434c:	e8 7c c0 ff ff       	call   c01003cd <__panic>
	struct Page *p = base;
c0104351:	8b 45 08             	mov    0x8(%ebp),%eax
c0104354:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p ++) {
c0104357:	eb 6c                	jmp    c01043c5 <default_init_memmap+0x96>
		// Before: the page must have been set reserved in page_init.
		assert(PageReserved(p));
c0104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010435c:	83 c0 04             	add    $0x4,%eax
c010435f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010436c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010436f:	0f a3 10             	bt     %edx,(%eax)
c0104372:	19 c0                	sbb    %eax,%eax
c0104374:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104377:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010437b:	0f 95 c0             	setne  %al
c010437e:	0f b6 c0             	movzbl %al,%eax
c0104381:	85 c0                	test   %eax,%eax
c0104383:	75 16                	jne    c010439b <default_init_memmap+0x6c>
c0104385:	68 b9 77 10 c0       	push   $0xc01077b9
c010438a:	68 8e 77 10 c0       	push   $0xc010778e
c010438f:	6a 4a                	push   $0x4a
c0104391:	68 a3 77 10 c0       	push   $0xc01077a3
c0104396:	e8 32 c0 ff ff       	call   c01003cd <__panic>
		// Initialize flags, property and ref
		p->flags = p->property = 0;
c010439b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01043a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a8:	8b 50 08             	mov    0x8(%eax),%edx
c01043ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ae:	89 50 04             	mov    %edx,0x4(%eax)
		set_page_ref(p, 0);
c01043b1:	83 ec 08             	sub    $0x8,%esp
c01043b4:	6a 00                	push   $0x0
c01043b6:	ff 75 f4             	pushl  -0xc(%ebp)
c01043b9:	e8 35 ff ff ff       	call   c01042f3 <set_page_ref>
c01043be:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page *p = base;
	for (; p != base + n; p ++) {
c01043c1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01043c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043c8:	89 d0                	mov    %edx,%eax
c01043ca:	c1 e0 02             	shl    $0x2,%eax
c01043cd:	01 d0                	add    %edx,%eax
c01043cf:	c1 e0 02             	shl    $0x2,%eax
c01043d2:	89 c2                	mov    %eax,%edx
c01043d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d7:	01 d0                	add    %edx,%eax
c01043d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01043dc:	0f 85 77 ff ff ff    	jne    c0104359 <default_init_memmap+0x2a>
		// Initialize flags, property and ref
		p->flags = p->property = 0;
		set_page_ref(p, 0);
	}
	// The base page is the start of continuous free pages.
	base->property = n;
c01043e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043e8:	89 50 08             	mov    %edx,0x8(%eax)
	SetPageProperty(base);
c01043eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ee:	83 c0 04             	add    $0x4,%eax
c01043f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c01043f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01043fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01043fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104401:	0f ab 10             	bts    %edx,(%eax)
	nr_free += n;
c0104404:	8b 15 70 a9 11 c0    	mov    0xc011a970,%edx
c010440a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010440d:	01 d0                	add    %edx,%eax
c010440f:	a3 70 a9 11 c0       	mov    %eax,0xc011a970
	list_add_before(&free_list, &(base->page_link));
c0104414:	8b 45 08             	mov    0x8(%ebp),%eax
c0104417:	83 c0 0c             	add    $0xc,%eax
c010441a:	c7 45 f0 68 a9 11 c0 	movl   $0xc011a968,-0x10(%ebp)
c0104421:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104424:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104427:	8b 00                	mov    (%eax),%eax
c0104429:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010442c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010442f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104432:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104435:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104438:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010443b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010443e:	89 10                	mov    %edx,(%eax)
c0104440:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104443:	8b 10                	mov    (%eax),%edx
c0104445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104448:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010444b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010444e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104451:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104454:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104457:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010445a:	89 10                	mov    %edx,(%eax)
}
c010445c:	90                   	nop
c010445d:	c9                   	leave  
c010445e:	c3                   	ret    

c010445f <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010445f:	55                   	push   %ebp
c0104460:	89 e5                	mov    %esp,%ebp
c0104462:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104465:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104469:	75 16                	jne    c0104481 <default_alloc_pages+0x22>
c010446b:	68 88 77 10 c0       	push   $0xc0107788
c0104470:	68 8e 77 10 c0       	push   $0xc010778e
c0104475:	6a 58                	push   $0x58
c0104477:	68 a3 77 10 c0       	push   $0xc01077a3
c010447c:	e8 4c bf ff ff       	call   c01003cd <__panic>
    if (n > nr_free) {
c0104481:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c0104486:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104489:	73 0a                	jae    c0104495 <default_alloc_pages+0x36>
        return NULL;
c010448b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104490:	e9 a8 01 00 00       	jmp    c010463d <default_alloc_pages+0x1de>
    }
    struct Page *page = NULL;
c0104495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010449c:	c7 45 f0 68 a9 11 c0 	movl   $0xc011a968,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01044a3:	eb 1c                	jmp    c01044c1 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c01044a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044a8:	83 e8 0c             	sub    $0xc,%eax
c01044ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c01044ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044b1:	8b 40 08             	mov    0x8(%eax),%eax
c01044b4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01044b7:	72 08                	jb     c01044c1 <default_alloc_pages+0x62>
            page = p;
c01044b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01044bf:	eb 18                	jmp    c01044d9 <default_alloc_pages+0x7a>
c01044c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01044c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01044ca:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01044cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044d0:	81 7d f0 68 a9 11 c0 	cmpl   $0xc011a968,-0x10(%ebp)
c01044d7:	75 cc                	jne    c01044a5 <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c01044d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044dd:	0f 84 57 01 00 00    	je     c010463a <default_alloc_pages+0x1db>
    	for (int i = 1; i < n; ++ i) {
c01044e3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c01044ea:	eb 4e                	jmp    c010453a <default_alloc_pages+0xdb>
    		struct Page *p = page + i;
c01044ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01044ef:	89 d0                	mov    %edx,%eax
c01044f1:	c1 e0 02             	shl    $0x2,%eax
c01044f4:	01 d0                	add    %edx,%eax
c01044f6:	c1 e0 02             	shl    $0x2,%eax
c01044f9:	89 c2                	mov    %eax,%edx
c01044fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fe:	01 d0                	add    %edx,%eax
c0104500:	89 45 e0             	mov    %eax,-0x20(%ebp)
    		// assert(!PageReserved(p));
    		ClearPageProperty(p);
c0104503:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104506:	83 c0 04             	add    $0x4,%eax
c0104509:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104510:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104513:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104516:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104519:	0f b3 10             	btr    %edx,(%eax)
    		p->property = 0;
c010451c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    		set_page_ref(p, 0);
c0104526:	83 ec 08             	sub    $0x8,%esp
c0104529:	6a 00                	push   $0x0
c010452b:	ff 75 e0             	pushl  -0x20(%ebp)
c010452e:	e8 c0 fd ff ff       	call   c01042f3 <set_page_ref>
c0104533:	83 c4 10             	add    $0x10,%esp
            page = p;
            break;
        }
    }
    if (page != NULL) {
    	for (int i = 1; i < n; ++ i) {
c0104536:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010453a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010453d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104540:	72 aa                	jb     c01044ec <default_alloc_pages+0x8d>
    		// assert(!PageReserved(p));
    		ClearPageProperty(p);
    		p->property = 0;
    		set_page_ref(p, 0);
    	}
        if (page->property > n) {
c0104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104545:	8b 40 08             	mov    0x8(%eax),%eax
c0104548:	3b 45 08             	cmp    0x8(%ebp),%eax
c010454b:	0f 86 98 00 00 00    	jbe    c01045e9 <default_alloc_pages+0x18a>
            struct Page *p = page + n;
c0104551:	8b 55 08             	mov    0x8(%ebp),%edx
c0104554:	89 d0                	mov    %edx,%eax
c0104556:	c1 e0 02             	shl    $0x2,%eax
c0104559:	01 d0                	add    %edx,%eax
c010455b:	c1 e0 02             	shl    $0x2,%eax
c010455e:	89 c2                	mov    %eax,%edx
c0104560:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104563:	01 d0                	add    %edx,%eax
c0104565:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;
c0104568:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010456b:	8b 40 08             	mov    0x8(%eax),%eax
c010456e:	2b 45 08             	sub    0x8(%ebp),%eax
c0104571:	89 c2                	mov    %eax,%edx
c0104573:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104576:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104579:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010457c:	83 c0 04             	add    $0x4,%eax
c010457f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104586:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104589:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010458c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010458f:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
c0104592:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104595:	83 c0 0c             	add    $0xc,%eax
c0104598:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010459b:	83 c2 0c             	add    $0xc,%edx
c010459e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01045a1:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01045a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045a7:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01045aa:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01045ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01045b0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01045b3:	8b 40 04             	mov    0x4(%eax),%eax
c01045b6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01045b9:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01045bc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01045bf:	89 55 b0             	mov    %edx,-0x50(%ebp)
c01045c2:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01045c5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01045c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01045cb:	89 10                	mov    %edx,(%eax)
c01045cd:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01045d0:	8b 10                	mov    (%eax),%edx
c01045d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01045d5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01045d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01045db:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01045de:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01045e1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01045e4:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01045e7:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01045e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ec:	83 c0 0c             	add    $0xc,%eax
c01045ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01045f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01045f5:	8b 40 04             	mov    0x4(%eax),%eax
c01045f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01045fb:	8b 12                	mov    (%edx),%edx
c01045fd:	89 55 a0             	mov    %edx,-0x60(%ebp)
c0104600:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104603:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104606:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104609:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010460c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010460f:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104612:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0104614:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c0104619:	2b 45 08             	sub    0x8(%ebp),%eax
c010461c:	a3 70 a9 11 c0       	mov    %eax,0xc011a970
        ClearPageProperty(page);
c0104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104624:	83 c0 04             	add    $0x4,%eax
c0104627:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010462e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104631:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104634:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104637:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010463d:	c9                   	leave  
c010463e:	c3                   	ret    

c010463f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010463f:	55                   	push   %ebp
c0104640:	89 e5                	mov    %esp,%ebp
c0104642:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010464c:	75 16                	jne    c0104664 <default_free_pages+0x25>
c010464e:	68 88 77 10 c0       	push   $0xc0107788
c0104653:	68 8e 77 10 c0       	push   $0xc010778e
c0104658:	6a 7c                	push   $0x7c
c010465a:	68 a3 77 10 c0       	push   $0xc01077a3
c010465f:	e8 69 bd ff ff       	call   c01003cd <__panic>
    struct Page *p = base;
c0104664:	8b 45 08             	mov    0x8(%ebp),%eax
c0104667:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010466a:	e9 8c 00 00 00       	jmp    c01046fb <default_free_pages+0xbc>
        assert(!PageReserved(p) && !PageProperty(p));
c010466f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104672:	83 c0 04             	add    $0x4,%eax
c0104675:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c010467c:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010467f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104682:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104685:	0f a3 10             	bt     %edx,(%eax)
c0104688:	19 c0                	sbb    %eax,%eax
c010468a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c010468d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0104691:	0f 95 c0             	setne  %al
c0104694:	0f b6 c0             	movzbl %al,%eax
c0104697:	85 c0                	test   %eax,%eax
c0104699:	75 2c                	jne    c01046c7 <default_free_pages+0x88>
c010469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469e:	83 c0 04             	add    $0x4,%eax
c01046a1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01046a8:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01046ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01046ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01046b1:	0f a3 10             	bt     %edx,(%eax)
c01046b4:	19 c0                	sbb    %eax,%eax
c01046b6:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c01046b9:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01046bd:	0f 95 c0             	setne  %al
c01046c0:	0f b6 c0             	movzbl %al,%eax
c01046c3:	85 c0                	test   %eax,%eax
c01046c5:	74 16                	je     c01046dd <default_free_pages+0x9e>
c01046c7:	68 cc 77 10 c0       	push   $0xc01077cc
c01046cc:	68 8e 77 10 c0       	push   $0xc010778e
c01046d1:	6a 7f                	push   $0x7f
c01046d3:	68 a3 77 10 c0       	push   $0xc01077a3
c01046d8:	e8 f0 bc ff ff       	call   c01003cd <__panic>
        p->flags = 0;
c01046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01046e7:	83 ec 08             	sub    $0x8,%esp
c01046ea:	6a 00                	push   $0x0
c01046ec:	ff 75 f4             	pushl  -0xc(%ebp)
c01046ef:	e8 ff fb ff ff       	call   c01042f3 <set_page_ref>
c01046f4:	83 c4 10             	add    $0x10,%esp

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01046f7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01046fb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046fe:	89 d0                	mov    %edx,%eax
c0104700:	c1 e0 02             	shl    $0x2,%eax
c0104703:	01 d0                	add    %edx,%eax
c0104705:	c1 e0 02             	shl    $0x2,%eax
c0104708:	89 c2                	mov    %eax,%edx
c010470a:	8b 45 08             	mov    0x8(%ebp),%eax
c010470d:	01 d0                	add    %edx,%eax
c010470f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104712:	0f 85 57 ff ff ff    	jne    c010466f <default_free_pages+0x30>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0104718:	8b 45 08             	mov    0x8(%ebp),%eax
c010471b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010471e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104721:	8b 45 08             	mov    0x8(%ebp),%eax
c0104724:	83 c0 04             	add    $0x4,%eax
c0104727:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c010472e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104731:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104734:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104737:	0f ab 10             	bts    %edx,(%eax)
c010473a:	c7 45 e0 68 a9 11 c0 	movl   $0xc011a968,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104741:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104744:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *merge_previous = NULL;
c010474a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    struct Page *merge_next = NULL;
c0104751:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while (le != &free_list) {
c0104758:	eb 66                	jmp    c01047c0 <default_free_pages+0x181>
        p = le2page(le, page_link);
c010475a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010475d:	83 e8 0c             	sub    $0xc,%eax
c0104760:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104763:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104766:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104769:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010476c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010476f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0104772:	8b 45 08             	mov    0x8(%ebp),%eax
c0104775:	8b 50 08             	mov    0x8(%eax),%edx
c0104778:	89 d0                	mov    %edx,%eax
c010477a:	c1 e0 02             	shl    $0x2,%eax
c010477d:	01 d0                	add    %edx,%eax
c010477f:	c1 e0 02             	shl    $0x2,%eax
c0104782:	89 c2                	mov    %eax,%edx
c0104784:	8b 45 08             	mov    0x8(%ebp),%eax
c0104787:	01 d0                	add    %edx,%eax
c0104789:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010478c:	75 08                	jne    c0104796 <default_free_pages+0x157>
        	merge_next = p;
c010478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104791:	89 45 e8             	mov    %eax,-0x18(%ebp)
        	break;
c0104794:	eb 36                	jmp    c01047cc <default_free_pages+0x18d>
        }
        else if (p + p->property == base) {
c0104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104799:	8b 50 08             	mov    0x8(%eax),%edx
c010479c:	89 d0                	mov    %edx,%eax
c010479e:	c1 e0 02             	shl    $0x2,%eax
c01047a1:	01 d0                	add    %edx,%eax
c01047a3:	c1 e0 02             	shl    $0x2,%eax
c01047a6:	89 c2                	mov    %eax,%edx
c01047a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ab:	01 d0                	add    %edx,%eax
c01047ad:	3b 45 08             	cmp    0x8(%ebp),%eax
c01047b0:	75 06                	jne    c01047b8 <default_free_pages+0x179>
            merge_previous = p;
c01047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        }
        if (p > base) break;
c01047b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047bb:	3b 45 08             	cmp    0x8(%ebp),%eax
c01047be:	77 0b                	ja     c01047cb <default_free_pages+0x18c>
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    struct Page *merge_previous = NULL;
    struct Page *merge_next = NULL;
    while (le != &free_list) {
c01047c0:	81 7d f0 68 a9 11 c0 	cmpl   $0xc011a968,-0x10(%ebp)
c01047c7:	75 91                	jne    c010475a <default_free_pages+0x11b>
c01047c9:	eb 01                	jmp    c01047cc <default_free_pages+0x18d>
        	break;
        }
        else if (p + p->property == base) {
            merge_previous = p;
        }
        if (p > base) break;
c01047cb:	90                   	nop
    }
    nr_free += n;
c01047cc:	8b 15 70 a9 11 c0    	mov    0xc011a970,%edx
c01047d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047d5:	01 d0                	add    %edx,%eax
c01047d7:	a3 70 a9 11 c0       	mov    %eax,0xc011a970
    // Try to merge base with merge_previous and merge_next.
    if (merge_previous != NULL) {
c01047dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01047e0:	74 33                	je     c0104815 <default_free_pages+0x1d6>
    	merge_previous->property += base->property;
c01047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e5:	8b 50 08             	mov    0x8(%eax),%edx
c01047e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047eb:	8b 40 08             	mov    0x8(%eax),%eax
c01047ee:	01 c2                	add    %eax,%edx
c01047f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047f3:	89 50 08             	mov    %edx,0x8(%eax)
    	ClearPageProperty(base);
c01047f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f9:	83 c0 04             	add    $0x4,%eax
c01047fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104803:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104806:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104809:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010480c:	0f b3 10             	btr    %edx,(%eax)
    	base = merge_previous;
c010480f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104812:	89 45 08             	mov    %eax,0x8(%ebp)
    }
    if (merge_next != NULL) {
c0104815:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104819:	0f 84 a8 00 00 00    	je     c01048c7 <default_free_pages+0x288>
    	base->property += merge_next->property;
c010481f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104822:	8b 50 08             	mov    0x8(%eax),%edx
c0104825:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104828:	8b 40 08             	mov    0x8(%eax),%eax
c010482b:	01 c2                	add    %eax,%edx
c010482d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104830:	89 50 08             	mov    %edx,0x8(%eax)
    	ClearPageProperty(merge_next);
c0104833:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104836:	83 c0 04             	add    $0x4,%eax
c0104839:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104840:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104843:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104846:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104849:	0f b3 10             	btr    %edx,(%eax)
    	if (merge_previous == NULL) {
c010484c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104850:	75 4a                	jne    c010489c <default_free_pages+0x25d>
    		list_add_before(&(merge_next->page_link), &(base->page_link));
c0104852:	8b 45 08             	mov    0x8(%ebp),%eax
c0104855:	83 c0 0c             	add    $0xc,%eax
c0104858:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010485b:	83 c2 0c             	add    $0xc,%edx
c010485e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104861:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104864:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104867:	8b 00                	mov    (%eax),%eax
c0104869:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010486c:	89 55 98             	mov    %edx,-0x68(%ebp)
c010486f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104872:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104875:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104878:	8b 45 90             	mov    -0x70(%ebp),%eax
c010487b:	8b 55 98             	mov    -0x68(%ebp),%edx
c010487e:	89 10                	mov    %edx,(%eax)
c0104880:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104883:	8b 10                	mov    (%eax),%edx
c0104885:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104888:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010488b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010488e:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104891:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104894:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104897:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010489a:	89 10                	mov    %edx,(%eax)
    	}

    	list_del(&(merge_next->page_link));
c010489c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010489f:	83 c0 0c             	add    $0xc,%eax
c01048a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01048a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048a8:	8b 40 04             	mov    0x4(%eax),%eax
c01048ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01048ae:	8b 12                	mov    (%edx),%edx
c01048b0:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01048b3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01048b6:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01048b9:	8b 55 88             	mov    -0x78(%ebp),%edx
c01048bc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01048bf:	8b 45 88             	mov    -0x78(%ebp),%eax
c01048c2:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01048c5:	89 10                	mov    %edx,(%eax)
    }
    if (merge_next == NULL && merge_previous == NULL) {
c01048c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01048cb:	0f 85 fc 00 00 00    	jne    c01049cd <default_free_pages+0x38e>
c01048d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01048d5:	0f 85 f2 00 00 00    	jne    c01049cd <default_free_pages+0x38e>
    	if (p > base && p != (base + n)) {
c01048db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048de:	3b 45 08             	cmp    0x8(%ebp),%eax
c01048e1:	76 7b                	jbe    c010495e <default_free_pages+0x31f>
c01048e3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048e6:	89 d0                	mov    %edx,%eax
c01048e8:	c1 e0 02             	shl    $0x2,%eax
c01048eb:	01 d0                	add    %edx,%eax
c01048ed:	c1 e0 02             	shl    $0x2,%eax
c01048f0:	89 c2                	mov    %eax,%edx
c01048f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f5:	01 d0                	add    %edx,%eax
c01048f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048fa:	74 62                	je     c010495e <default_free_pages+0x31f>
    		list_add_before(&(p->page_link), &(base->page_link));
c01048fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ff:	83 c0 0c             	add    $0xc,%eax
c0104902:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104905:	83 c2 0c             	add    $0xc,%edx
c0104908:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010490b:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010490e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104911:	8b 00                	mov    (%eax),%eax
c0104913:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104916:	89 55 80             	mov    %edx,-0x80(%ebp)
c0104919:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010491f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104922:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104928:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010492e:	8b 55 80             	mov    -0x80(%ebp),%edx
c0104931:	89 10                	mov    %edx,(%eax)
c0104933:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104939:	8b 10                	mov    (%eax),%edx
c010493b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104941:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104944:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104947:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c010494d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104950:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104953:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104959:	89 10                	mov    %edx,(%eax)
c010495b:	90                   	nop
    	} else {
    		list_add_before(&free_list, &(base->page_link));
    	}
    }
}
c010495c:	eb 6f                	jmp    c01049cd <default_free_pages+0x38e>
    }
    if (merge_next == NULL && merge_previous == NULL) {
    	if (p > base && p != (base + n)) {
    		list_add_before(&(p->page_link), &(base->page_link));
    	} else {
    		list_add_before(&free_list, &(base->page_link));
c010495e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104961:	83 c0 0c             	add    $0xc,%eax
c0104964:	c7 45 c0 68 a9 11 c0 	movl   $0xc011a968,-0x40(%ebp)
c010496b:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104971:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104974:	8b 00                	mov    (%eax),%eax
c0104976:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c010497c:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0104982:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
c0104988:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010498b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104991:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0104997:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c010499d:	89 10                	mov    %edx,(%eax)
c010499f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c01049a5:	8b 10                	mov    (%eax),%edx
c01049a7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c01049ad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01049b0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c01049b6:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c01049bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01049bf:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c01049c5:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c01049cb:	89 10                	mov    %edx,(%eax)
    	}
    }
}
c01049cd:	90                   	nop
c01049ce:	c9                   	leave  
c01049cf:	c3                   	ret    

c01049d0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01049d0:	55                   	push   %ebp
c01049d1:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01049d3:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
}
c01049d8:	5d                   	pop    %ebp
c01049d9:	c3                   	ret    

c01049da <basic_check>:
    cprintf("+ 1 = %x, 1.next = %x, prev = %x\n", &(p2->page_link), p2->page_link.next, p2->page_link.prev);
    cprintf("+ 2 = %x, 2.next = %x, prev = %x\n", &(p3->page_link), p3->page_link.next, p3->page_link.prev);
}
*/
static void
basic_check(void) {
c01049da:	55                   	push   %ebp
c01049db:	89 e5                	mov    %esp,%ebp
c01049dd:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01049e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01049e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01049f3:	83 ec 0c             	sub    $0xc,%esp
c01049f6:	6a 01                	push   $0x1
c01049f8:	e8 72 e3 ff ff       	call   c0102d6f <alloc_pages>
c01049fd:	83 c4 10             	add    $0x10,%esp
c0104a00:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a07:	75 19                	jne    c0104a22 <basic_check+0x48>
c0104a09:	68 f1 77 10 c0       	push   $0xc01077f1
c0104a0e:	68 8e 77 10 c0       	push   $0xc010778e
c0104a13:	68 be 00 00 00       	push   $0xbe
c0104a18:	68 a3 77 10 c0       	push   $0xc01077a3
c0104a1d:	e8 ab b9 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a22:	83 ec 0c             	sub    $0xc,%esp
c0104a25:	6a 01                	push   $0x1
c0104a27:	e8 43 e3 ff ff       	call   c0102d6f <alloc_pages>
c0104a2c:	83 c4 10             	add    $0x10,%esp
c0104a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a36:	75 19                	jne    c0104a51 <basic_check+0x77>
c0104a38:	68 0d 78 10 c0       	push   $0xc010780d
c0104a3d:	68 8e 77 10 c0       	push   $0xc010778e
c0104a42:	68 bf 00 00 00       	push   $0xbf
c0104a47:	68 a3 77 10 c0       	push   $0xc01077a3
c0104a4c:	e8 7c b9 ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104a51:	83 ec 0c             	sub    $0xc,%esp
c0104a54:	6a 01                	push   $0x1
c0104a56:	e8 14 e3 ff ff       	call   c0102d6f <alloc_pages>
c0104a5b:	83 c4 10             	add    $0x10,%esp
c0104a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a65:	75 19                	jne    c0104a80 <basic_check+0xa6>
c0104a67:	68 29 78 10 c0       	push   $0xc0107829
c0104a6c:	68 8e 77 10 c0       	push   $0xc010778e
c0104a71:	68 c0 00 00 00       	push   $0xc0
c0104a76:	68 a3 77 10 c0       	push   $0xc01077a3
c0104a7b:	e8 4d b9 ff ff       	call   c01003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a86:	74 10                	je     c0104a98 <basic_check+0xbe>
c0104a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a8e:	74 08                	je     c0104a98 <basic_check+0xbe>
c0104a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a96:	75 19                	jne    c0104ab1 <basic_check+0xd7>
c0104a98:	68 48 78 10 c0       	push   $0xc0107848
c0104a9d:	68 8e 77 10 c0       	push   $0xc010778e
c0104aa2:	68 c2 00 00 00       	push   $0xc2
c0104aa7:	68 a3 77 10 c0       	push   $0xc01077a3
c0104aac:	e8 1c b9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104ab1:	83 ec 0c             	sub    $0xc,%esp
c0104ab4:	ff 75 ec             	pushl  -0x14(%ebp)
c0104ab7:	e8 2d f8 ff ff       	call   c01042e9 <page_ref>
c0104abc:	83 c4 10             	add    $0x10,%esp
c0104abf:	85 c0                	test   %eax,%eax
c0104ac1:	75 24                	jne    c0104ae7 <basic_check+0x10d>
c0104ac3:	83 ec 0c             	sub    $0xc,%esp
c0104ac6:	ff 75 f0             	pushl  -0x10(%ebp)
c0104ac9:	e8 1b f8 ff ff       	call   c01042e9 <page_ref>
c0104ace:	83 c4 10             	add    $0x10,%esp
c0104ad1:	85 c0                	test   %eax,%eax
c0104ad3:	75 12                	jne    c0104ae7 <basic_check+0x10d>
c0104ad5:	83 ec 0c             	sub    $0xc,%esp
c0104ad8:	ff 75 f4             	pushl  -0xc(%ebp)
c0104adb:	e8 09 f8 ff ff       	call   c01042e9 <page_ref>
c0104ae0:	83 c4 10             	add    $0x10,%esp
c0104ae3:	85 c0                	test   %eax,%eax
c0104ae5:	74 19                	je     c0104b00 <basic_check+0x126>
c0104ae7:	68 6c 78 10 c0       	push   $0xc010786c
c0104aec:	68 8e 77 10 c0       	push   $0xc010778e
c0104af1:	68 c3 00 00 00       	push   $0xc3
c0104af6:	68 a3 77 10 c0       	push   $0xc01077a3
c0104afb:	e8 cd b8 ff ff       	call   c01003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104b00:	83 ec 0c             	sub    $0xc,%esp
c0104b03:	ff 75 ec             	pushl  -0x14(%ebp)
c0104b06:	e8 cb f7 ff ff       	call   c01042d6 <page2pa>
c0104b0b:	83 c4 10             	add    $0x10,%esp
c0104b0e:	89 c2                	mov    %eax,%edx
c0104b10:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0104b15:	c1 e0 0c             	shl    $0xc,%eax
c0104b18:	39 c2                	cmp    %eax,%edx
c0104b1a:	72 19                	jb     c0104b35 <basic_check+0x15b>
c0104b1c:	68 a8 78 10 c0       	push   $0xc01078a8
c0104b21:	68 8e 77 10 c0       	push   $0xc010778e
c0104b26:	68 c5 00 00 00       	push   $0xc5
c0104b2b:	68 a3 77 10 c0       	push   $0xc01077a3
c0104b30:	e8 98 b8 ff ff       	call   c01003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104b35:	83 ec 0c             	sub    $0xc,%esp
c0104b38:	ff 75 f0             	pushl  -0x10(%ebp)
c0104b3b:	e8 96 f7 ff ff       	call   c01042d6 <page2pa>
c0104b40:	83 c4 10             	add    $0x10,%esp
c0104b43:	89 c2                	mov    %eax,%edx
c0104b45:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0104b4a:	c1 e0 0c             	shl    $0xc,%eax
c0104b4d:	39 c2                	cmp    %eax,%edx
c0104b4f:	72 19                	jb     c0104b6a <basic_check+0x190>
c0104b51:	68 c5 78 10 c0       	push   $0xc01078c5
c0104b56:	68 8e 77 10 c0       	push   $0xc010778e
c0104b5b:	68 c6 00 00 00       	push   $0xc6
c0104b60:	68 a3 77 10 c0       	push   $0xc01077a3
c0104b65:	e8 63 b8 ff ff       	call   c01003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104b6a:	83 ec 0c             	sub    $0xc,%esp
c0104b6d:	ff 75 f4             	pushl  -0xc(%ebp)
c0104b70:	e8 61 f7 ff ff       	call   c01042d6 <page2pa>
c0104b75:	83 c4 10             	add    $0x10,%esp
c0104b78:	89 c2                	mov    %eax,%edx
c0104b7a:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c0104b7f:	c1 e0 0c             	shl    $0xc,%eax
c0104b82:	39 c2                	cmp    %eax,%edx
c0104b84:	72 19                	jb     c0104b9f <basic_check+0x1c5>
c0104b86:	68 e2 78 10 c0       	push   $0xc01078e2
c0104b8b:	68 8e 77 10 c0       	push   $0xc010778e
c0104b90:	68 c7 00 00 00       	push   $0xc7
c0104b95:	68 a3 77 10 c0       	push   $0xc01077a3
c0104b9a:	e8 2e b8 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104b9f:	a1 68 a9 11 c0       	mov    0xc011a968,%eax
c0104ba4:	8b 15 6c a9 11 c0    	mov    0xc011a96c,%edx
c0104baa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104bad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104bb0:	c7 45 e4 68 a9 11 c0 	movl   $0xc011a968,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bbd:	89 50 04             	mov    %edx,0x4(%eax)
c0104bc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bc3:	8b 50 04             	mov    0x4(%eax),%edx
c0104bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bc9:	89 10                	mov    %edx,(%eax)
c0104bcb:	c7 45 d8 68 a9 11 c0 	movl   $0xc011a968,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104bd2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104bd5:	8b 40 04             	mov    0x4(%eax),%eax
c0104bd8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104bdb:	0f 94 c0             	sete   %al
c0104bde:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104be1:	85 c0                	test   %eax,%eax
c0104be3:	75 19                	jne    c0104bfe <basic_check+0x224>
c0104be5:	68 ff 78 10 c0       	push   $0xc01078ff
c0104bea:	68 8e 77 10 c0       	push   $0xc010778e
c0104bef:	68 cb 00 00 00       	push   $0xcb
c0104bf4:	68 a3 77 10 c0       	push   $0xc01077a3
c0104bf9:	e8 cf b7 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104bfe:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c0104c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104c06:	c7 05 70 a9 11 c0 00 	movl   $0x0,0xc011a970
c0104c0d:	00 00 00 

    assert(alloc_page() == NULL);
c0104c10:	83 ec 0c             	sub    $0xc,%esp
c0104c13:	6a 01                	push   $0x1
c0104c15:	e8 55 e1 ff ff       	call   c0102d6f <alloc_pages>
c0104c1a:	83 c4 10             	add    $0x10,%esp
c0104c1d:	85 c0                	test   %eax,%eax
c0104c1f:	74 19                	je     c0104c3a <basic_check+0x260>
c0104c21:	68 16 79 10 c0       	push   $0xc0107916
c0104c26:	68 8e 77 10 c0       	push   $0xc010778e
c0104c2b:	68 d0 00 00 00       	push   $0xd0
c0104c30:	68 a3 77 10 c0       	push   $0xc01077a3
c0104c35:	e8 93 b7 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c0104c3a:	83 ec 08             	sub    $0x8,%esp
c0104c3d:	6a 01                	push   $0x1
c0104c3f:	ff 75 ec             	pushl  -0x14(%ebp)
c0104c42:	e8 66 e1 ff ff       	call   c0102dad <free_pages>
c0104c47:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104c4a:	83 ec 08             	sub    $0x8,%esp
c0104c4d:	6a 01                	push   $0x1
c0104c4f:	ff 75 f0             	pushl  -0x10(%ebp)
c0104c52:	e8 56 e1 ff ff       	call   c0102dad <free_pages>
c0104c57:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104c5a:	83 ec 08             	sub    $0x8,%esp
c0104c5d:	6a 01                	push   $0x1
c0104c5f:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c62:	e8 46 e1 ff ff       	call   c0102dad <free_pages>
c0104c67:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104c6a:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c0104c6f:	83 f8 03             	cmp    $0x3,%eax
c0104c72:	74 19                	je     c0104c8d <basic_check+0x2b3>
c0104c74:	68 2b 79 10 c0       	push   $0xc010792b
c0104c79:	68 8e 77 10 c0       	push   $0xc010778e
c0104c7e:	68 d4 00 00 00       	push   $0xd4
c0104c83:	68 a3 77 10 c0       	push   $0xc01077a3
c0104c88:	e8 40 b7 ff ff       	call   c01003cd <__panic>
    assert((p0 = alloc_page()) != NULL);
c0104c8d:	83 ec 0c             	sub    $0xc,%esp
c0104c90:	6a 01                	push   $0x1
c0104c92:	e8 d8 e0 ff ff       	call   c0102d6f <alloc_pages>
c0104c97:	83 c4 10             	add    $0x10,%esp
c0104c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104ca1:	75 19                	jne    c0104cbc <basic_check+0x2e2>
c0104ca3:	68 f1 77 10 c0       	push   $0xc01077f1
c0104ca8:	68 8e 77 10 c0       	push   $0xc010778e
c0104cad:	68 d5 00 00 00       	push   $0xd5
c0104cb2:	68 a3 77 10 c0       	push   $0xc01077a3
c0104cb7:	e8 11 b7 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104cbc:	83 ec 0c             	sub    $0xc,%esp
c0104cbf:	6a 01                	push   $0x1
c0104cc1:	e8 a9 e0 ff ff       	call   c0102d6f <alloc_pages>
c0104cc6:	83 c4 10             	add    $0x10,%esp
c0104cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ccc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cd0:	75 19                	jne    c0104ceb <basic_check+0x311>
c0104cd2:	68 0d 78 10 c0       	push   $0xc010780d
c0104cd7:	68 8e 77 10 c0       	push   $0xc010778e
c0104cdc:	68 d6 00 00 00       	push   $0xd6
c0104ce1:	68 a3 77 10 c0       	push   $0xc01077a3
c0104ce6:	e8 e2 b6 ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104ceb:	83 ec 0c             	sub    $0xc,%esp
c0104cee:	6a 01                	push   $0x1
c0104cf0:	e8 7a e0 ff ff       	call   c0102d6f <alloc_pages>
c0104cf5:	83 c4 10             	add    $0x10,%esp
c0104cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cff:	75 19                	jne    c0104d1a <basic_check+0x340>
c0104d01:	68 29 78 10 c0       	push   $0xc0107829
c0104d06:	68 8e 77 10 c0       	push   $0xc010778e
c0104d0b:	68 d7 00 00 00       	push   $0xd7
c0104d10:	68 a3 77 10 c0       	push   $0xc01077a3
c0104d15:	e8 b3 b6 ff ff       	call   c01003cd <__panic>

    assert(alloc_page() == NULL);
c0104d1a:	83 ec 0c             	sub    $0xc,%esp
c0104d1d:	6a 01                	push   $0x1
c0104d1f:	e8 4b e0 ff ff       	call   c0102d6f <alloc_pages>
c0104d24:	83 c4 10             	add    $0x10,%esp
c0104d27:	85 c0                	test   %eax,%eax
c0104d29:	74 19                	je     c0104d44 <basic_check+0x36a>
c0104d2b:	68 16 79 10 c0       	push   $0xc0107916
c0104d30:	68 8e 77 10 c0       	push   $0xc010778e
c0104d35:	68 d9 00 00 00       	push   $0xd9
c0104d3a:	68 a3 77 10 c0       	push   $0xc01077a3
c0104d3f:	e8 89 b6 ff ff       	call   c01003cd <__panic>

    free_page(p0);
c0104d44:	83 ec 08             	sub    $0x8,%esp
c0104d47:	6a 01                	push   $0x1
c0104d49:	ff 75 ec             	pushl  -0x14(%ebp)
c0104d4c:	e8 5c e0 ff ff       	call   c0102dad <free_pages>
c0104d51:	83 c4 10             	add    $0x10,%esp
c0104d54:	c7 45 e8 68 a9 11 c0 	movl   $0xc011a968,-0x18(%ebp)
c0104d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d5e:	8b 40 04             	mov    0x4(%eax),%eax
c0104d61:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104d64:	0f 94 c0             	sete   %al
c0104d67:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104d6a:	85 c0                	test   %eax,%eax
c0104d6c:	74 19                	je     c0104d87 <basic_check+0x3ad>
c0104d6e:	68 38 79 10 c0       	push   $0xc0107938
c0104d73:	68 8e 77 10 c0       	push   $0xc010778e
c0104d78:	68 dc 00 00 00       	push   $0xdc
c0104d7d:	68 a3 77 10 c0       	push   $0xc01077a3
c0104d82:	e8 46 b6 ff ff       	call   c01003cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104d87:	83 ec 0c             	sub    $0xc,%esp
c0104d8a:	6a 01                	push   $0x1
c0104d8c:	e8 de df ff ff       	call   c0102d6f <alloc_pages>
c0104d91:	83 c4 10             	add    $0x10,%esp
c0104d94:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d9a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104d9d:	74 19                	je     c0104db8 <basic_check+0x3de>
c0104d9f:	68 50 79 10 c0       	push   $0xc0107950
c0104da4:	68 8e 77 10 c0       	push   $0xc010778e
c0104da9:	68 df 00 00 00       	push   $0xdf
c0104dae:	68 a3 77 10 c0       	push   $0xc01077a3
c0104db3:	e8 15 b6 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104db8:	83 ec 0c             	sub    $0xc,%esp
c0104dbb:	6a 01                	push   $0x1
c0104dbd:	e8 ad df ff ff       	call   c0102d6f <alloc_pages>
c0104dc2:	83 c4 10             	add    $0x10,%esp
c0104dc5:	85 c0                	test   %eax,%eax
c0104dc7:	74 19                	je     c0104de2 <basic_check+0x408>
c0104dc9:	68 16 79 10 c0       	push   $0xc0107916
c0104dce:	68 8e 77 10 c0       	push   $0xc010778e
c0104dd3:	68 e0 00 00 00       	push   $0xe0
c0104dd8:	68 a3 77 10 c0       	push   $0xc01077a3
c0104ddd:	e8 eb b5 ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c0104de2:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c0104de7:	85 c0                	test   %eax,%eax
c0104de9:	74 19                	je     c0104e04 <basic_check+0x42a>
c0104deb:	68 69 79 10 c0       	push   $0xc0107969
c0104df0:	68 8e 77 10 c0       	push   $0xc010778e
c0104df5:	68 e2 00 00 00       	push   $0xe2
c0104dfa:	68 a3 77 10 c0       	push   $0xc01077a3
c0104dff:	e8 c9 b5 ff ff       	call   c01003cd <__panic>
    free_list = free_list_store;
c0104e04:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e0a:	a3 68 a9 11 c0       	mov    %eax,0xc011a968
c0104e0f:	89 15 6c a9 11 c0    	mov    %edx,0xc011a96c
    nr_free = nr_free_store;
c0104e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e18:	a3 70 a9 11 c0       	mov    %eax,0xc011a970

    free_page(p);
c0104e1d:	83 ec 08             	sub    $0x8,%esp
c0104e20:	6a 01                	push   $0x1
c0104e22:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e25:	e8 83 df ff ff       	call   c0102dad <free_pages>
c0104e2a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104e2d:	83 ec 08             	sub    $0x8,%esp
c0104e30:	6a 01                	push   $0x1
c0104e32:	ff 75 f0             	pushl  -0x10(%ebp)
c0104e35:	e8 73 df ff ff       	call   c0102dad <free_pages>
c0104e3a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104e3d:	83 ec 08             	sub    $0x8,%esp
c0104e40:	6a 01                	push   $0x1
c0104e42:	ff 75 f4             	pushl  -0xc(%ebp)
c0104e45:	e8 63 df ff ff       	call   c0102dad <free_pages>
c0104e4a:	83 c4 10             	add    $0x10,%esp
}
c0104e4d:	90                   	nop
c0104e4e:	c9                   	leave  
c0104e4f:	c3                   	ret    

c0104e50 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104e50:	55                   	push   %ebp
c0104e51:	89 e5                	mov    %esp,%ebp
c0104e53:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104e59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104e67:	c7 45 ec 68 a9 11 c0 	movl   $0xc011a968,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104e6e:	eb 60                	jmp    c0104ed0 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e73:	83 e8 0c             	sub    $0xc,%eax
c0104e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e7c:	83 c0 04             	add    $0x4,%eax
c0104e7f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104e86:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e89:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104e8c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104e8f:	0f a3 10             	bt     %edx,(%eax)
c0104e92:	19 c0                	sbb    %eax,%eax
c0104e94:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104e97:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104e9b:	0f 95 c0             	setne  %al
c0104e9e:	0f b6 c0             	movzbl %al,%eax
c0104ea1:	85 c0                	test   %eax,%eax
c0104ea3:	75 19                	jne    c0104ebe <default_check+0x6e>
c0104ea5:	68 76 79 10 c0       	push   $0xc0107976
c0104eaa:	68 8e 77 10 c0       	push   $0xc010778e
c0104eaf:	68 f3 00 00 00       	push   $0xf3
c0104eb4:	68 a3 77 10 c0       	push   $0xc01077a3
c0104eb9:	e8 0f b5 ff ff       	call   c01003cd <__panic>
        count ++, total += p->property;
c0104ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ec5:	8b 50 08             	mov    0x8(%eax),%edx
c0104ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ecb:	01 d0                	add    %edx,%eax
c0104ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ed9:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104edf:	81 7d ec 68 a9 11 c0 	cmpl   $0xc011a968,-0x14(%ebp)
c0104ee6:	75 88                	jne    c0104e70 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104ee8:	e8 f5 de ff ff       	call   c0102de2 <nr_free_pages>
c0104eed:	89 c2                	mov    %eax,%edx
c0104eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef2:	39 c2                	cmp    %eax,%edx
c0104ef4:	74 19                	je     c0104f0f <default_check+0xbf>
c0104ef6:	68 86 79 10 c0       	push   $0xc0107986
c0104efb:	68 8e 77 10 c0       	push   $0xc010778e
c0104f00:	68 f6 00 00 00       	push   $0xf6
c0104f05:	68 a3 77 10 c0       	push   $0xc01077a3
c0104f0a:	e8 be b4 ff ff       	call   c01003cd <__panic>

    basic_check();
c0104f0f:	e8 c6 fa ff ff       	call   c01049da <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104f14:	83 ec 0c             	sub    $0xc,%esp
c0104f17:	6a 05                	push   $0x5
c0104f19:	e8 51 de ff ff       	call   c0102d6f <alloc_pages>
c0104f1e:	83 c4 10             	add    $0x10,%esp
c0104f21:	89 45 dc             	mov    %eax,-0x24(%ebp)
    struct Page *p0_saved = p0;
c0104f24:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f27:	89 45 d8             	mov    %eax,-0x28(%ebp)

    assert(p0 != NULL);
c0104f2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104f2e:	75 19                	jne    c0104f49 <default_check+0xf9>
c0104f30:	68 9f 79 10 c0       	push   $0xc010799f
c0104f35:	68 8e 77 10 c0       	push   $0xc010778e
c0104f3a:	68 fd 00 00 00       	push   $0xfd
c0104f3f:	68 a3 77 10 c0       	push   $0xc01077a3
c0104f44:	e8 84 b4 ff ff       	call   c01003cd <__panic>
    assert(!PageProperty(p0));
c0104f49:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f4c:	83 c0 04             	add    $0x4,%eax
c0104f4f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104f56:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f59:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104f5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104f5f:	0f a3 10             	bt     %edx,(%eax)
c0104f62:	19 c0                	sbb    %eax,%eax
c0104f64:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
c0104f67:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
c0104f6b:	0f 95 c0             	setne  %al
c0104f6e:	0f b6 c0             	movzbl %al,%eax
c0104f71:	85 c0                	test   %eax,%eax
c0104f73:	74 19                	je     c0104f8e <default_check+0x13e>
c0104f75:	68 aa 79 10 c0       	push   $0xc01079aa
c0104f7a:	68 8e 77 10 c0       	push   $0xc010778e
c0104f7f:	68 fe 00 00 00       	push   $0xfe
c0104f84:	68 a3 77 10 c0       	push   $0xc01077a3
c0104f89:	e8 3f b4 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104f8e:	a1 68 a9 11 c0       	mov    0xc011a968,%eax
c0104f93:	8b 15 6c a9 11 c0    	mov    0xc011a96c,%edx
c0104f99:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104f9f:	89 55 80             	mov    %edx,-0x80(%ebp)
c0104fa2:	c7 45 cc 68 a9 11 c0 	movl   $0xc011a968,-0x34(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104fa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104fac:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104faf:	89 50 04             	mov    %edx,0x4(%eax)
c0104fb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104fb5:	8b 50 04             	mov    0x4(%eax),%edx
c0104fb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104fbb:	89 10                	mov    %edx,(%eax)
c0104fbd:	c7 45 d4 68 a9 11 c0 	movl   $0xc011a968,-0x2c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104fc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104fc7:	8b 40 04             	mov    0x4(%eax),%eax
c0104fca:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
c0104fcd:	0f 94 c0             	sete   %al
c0104fd0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104fd3:	85 c0                	test   %eax,%eax
c0104fd5:	75 19                	jne    c0104ff0 <default_check+0x1a0>
c0104fd7:	68 ff 78 10 c0       	push   $0xc01078ff
c0104fdc:	68 8e 77 10 c0       	push   $0xc010778e
c0104fe1:	68 02 01 00 00       	push   $0x102
c0104fe6:	68 a3 77 10 c0       	push   $0xc01077a3
c0104feb:	e8 dd b3 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104ff0:	83 ec 0c             	sub    $0xc,%esp
c0104ff3:	6a 01                	push   $0x1
c0104ff5:	e8 75 dd ff ff       	call   c0102d6f <alloc_pages>
c0104ffa:	83 c4 10             	add    $0x10,%esp
c0104ffd:	85 c0                	test   %eax,%eax
c0104fff:	74 19                	je     c010501a <default_check+0x1ca>
c0105001:	68 16 79 10 c0       	push   $0xc0107916
c0105006:	68 8e 77 10 c0       	push   $0xc010778e
c010500b:	68 03 01 00 00       	push   $0x103
c0105010:	68 a3 77 10 c0       	push   $0xc01077a3
c0105015:	e8 b3 b3 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c010501a:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c010501f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    nr_free = 0;
c0105022:	c7 05 70 a9 11 c0 00 	movl   $0x0,0xc011a970
c0105029:	00 00 00 

    free_pages(p0 + 2, 3);
c010502c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010502f:	83 c0 28             	add    $0x28,%eax
c0105032:	83 ec 08             	sub    $0x8,%esp
c0105035:	6a 03                	push   $0x3
c0105037:	50                   	push   %eax
c0105038:	e8 70 dd ff ff       	call   c0102dad <free_pages>
c010503d:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0105040:	83 ec 0c             	sub    $0xc,%esp
c0105043:	6a 04                	push   $0x4
c0105045:	e8 25 dd ff ff       	call   c0102d6f <alloc_pages>
c010504a:	83 c4 10             	add    $0x10,%esp
c010504d:	85 c0                	test   %eax,%eax
c010504f:	74 19                	je     c010506a <default_check+0x21a>
c0105051:	68 bc 79 10 c0       	push   $0xc01079bc
c0105056:	68 8e 77 10 c0       	push   $0xc010778e
c010505b:	68 09 01 00 00       	push   $0x109
c0105060:	68 a3 77 10 c0       	push   $0xc01077a3
c0105065:	e8 63 b3 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010506a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010506d:	83 c0 28             	add    $0x28,%eax
c0105070:	83 c0 04             	add    $0x4,%eax
c0105073:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010507a:	89 45 98             	mov    %eax,-0x68(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010507d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105080:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105083:	0f a3 10             	bt     %edx,(%eax)
c0105086:	19 c0                	sbb    %eax,%eax
c0105088:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return oldbit != 0;
c010508b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
c010508f:	0f 95 c0             	setne  %al
c0105092:	0f b6 c0             	movzbl %al,%eax
c0105095:	85 c0                	test   %eax,%eax
c0105097:	74 0e                	je     c01050a7 <default_check+0x257>
c0105099:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010509c:	83 c0 28             	add    $0x28,%eax
c010509f:	8b 40 08             	mov    0x8(%eax),%eax
c01050a2:	83 f8 03             	cmp    $0x3,%eax
c01050a5:	74 19                	je     c01050c0 <default_check+0x270>
c01050a7:	68 d4 79 10 c0       	push   $0xc01079d4
c01050ac:	68 8e 77 10 c0       	push   $0xc010778e
c01050b1:	68 0a 01 00 00       	push   $0x10a
c01050b6:	68 a3 77 10 c0       	push   $0xc01077a3
c01050bb:	e8 0d b3 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01050c0:	83 ec 0c             	sub    $0xc,%esp
c01050c3:	6a 03                	push   $0x3
c01050c5:	e8 a5 dc ff ff       	call   c0102d6f <alloc_pages>
c01050ca:	83 c4 10             	add    $0x10,%esp
c01050cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01050d0:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01050d4:	75 19                	jne    c01050ef <default_check+0x29f>
c01050d6:	68 00 7a 10 c0       	push   $0xc0107a00
c01050db:	68 8e 77 10 c0       	push   $0xc010778e
c01050e0:	68 0b 01 00 00       	push   $0x10b
c01050e5:	68 a3 77 10 c0       	push   $0xc01077a3
c01050ea:	e8 de b2 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c01050ef:	83 ec 0c             	sub    $0xc,%esp
c01050f2:	6a 01                	push   $0x1
c01050f4:	e8 76 dc ff ff       	call   c0102d6f <alloc_pages>
c01050f9:	83 c4 10             	add    $0x10,%esp
c01050fc:	85 c0                	test   %eax,%eax
c01050fe:	74 19                	je     c0105119 <default_check+0x2c9>
c0105100:	68 16 79 10 c0       	push   $0xc0107916
c0105105:	68 8e 77 10 c0       	push   $0xc010778e
c010510a:	68 0c 01 00 00       	push   $0x10c
c010510f:	68 a3 77 10 c0       	push   $0xc01077a3
c0105114:	e8 b4 b2 ff ff       	call   c01003cd <__panic>
    assert(p0 + 2 == p1);
c0105119:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010511c:	83 c0 28             	add    $0x28,%eax
c010511f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0105122:	74 19                	je     c010513d <default_check+0x2ed>
c0105124:	68 1e 7a 10 c0       	push   $0xc0107a1e
c0105129:	68 8e 77 10 c0       	push   $0xc010778e
c010512e:	68 0d 01 00 00       	push   $0x10d
c0105133:	68 a3 77 10 c0       	push   $0xc01077a3
c0105138:	e8 90 b2 ff ff       	call   c01003cd <__panic>

    p2 = p0 + 1;
c010513d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105140:	83 c0 14             	add    $0x14,%eax
c0105143:	89 45 bc             	mov    %eax,-0x44(%ebp)
    free_page(p0);
c0105146:	83 ec 08             	sub    $0x8,%esp
c0105149:	6a 01                	push   $0x1
c010514b:	ff 75 dc             	pushl  -0x24(%ebp)
c010514e:	e8 5a dc ff ff       	call   c0102dad <free_pages>
c0105153:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0105156:	83 ec 08             	sub    $0x8,%esp
c0105159:	6a 03                	push   $0x3
c010515b:	ff 75 c0             	pushl  -0x40(%ebp)
c010515e:	e8 4a dc ff ff       	call   c0102dad <free_pages>
c0105163:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0105166:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105169:	83 c0 04             	add    $0x4,%eax
c010516c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105173:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105176:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105179:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010517c:	0f a3 10             	bt     %edx,(%eax)
c010517f:	19 c0                	sbb    %eax,%eax
c0105181:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105184:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105188:	0f 95 c0             	setne  %al
c010518b:	0f b6 c0             	movzbl %al,%eax
c010518e:	85 c0                	test   %eax,%eax
c0105190:	74 0b                	je     c010519d <default_check+0x34d>
c0105192:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105195:	8b 40 08             	mov    0x8(%eax),%eax
c0105198:	83 f8 01             	cmp    $0x1,%eax
c010519b:	74 19                	je     c01051b6 <default_check+0x366>
c010519d:	68 2c 7a 10 c0       	push   $0xc0107a2c
c01051a2:	68 8e 77 10 c0       	push   $0xc010778e
c01051a7:	68 12 01 00 00       	push   $0x112
c01051ac:	68 a3 77 10 c0       	push   $0xc01077a3
c01051b1:	e8 17 b2 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01051b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01051b9:	83 c0 04             	add    $0x4,%eax
c01051bc:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01051c3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01051c6:	8b 45 88             	mov    -0x78(%ebp),%eax
c01051c9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01051cc:	0f a3 10             	bt     %edx,(%eax)
c01051cf:	19 c0                	sbb    %eax,%eax
c01051d1:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
c01051d4:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
c01051d8:	0f 95 c0             	setne  %al
c01051db:	0f b6 c0             	movzbl %al,%eax
c01051de:	85 c0                	test   %eax,%eax
c01051e0:	74 0b                	je     c01051ed <default_check+0x39d>
c01051e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01051e5:	8b 40 08             	mov    0x8(%eax),%eax
c01051e8:	83 f8 03             	cmp    $0x3,%eax
c01051eb:	74 19                	je     c0105206 <default_check+0x3b6>
c01051ed:	68 54 7a 10 c0       	push   $0xc0107a54
c01051f2:	68 8e 77 10 c0       	push   $0xc010778e
c01051f7:	68 13 01 00 00       	push   $0x113
c01051fc:	68 a3 77 10 c0       	push   $0xc01077a3
c0105201:	e8 c7 b1 ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105206:	83 ec 0c             	sub    $0xc,%esp
c0105209:	6a 01                	push   $0x1
c010520b:	e8 5f db ff ff       	call   c0102d6f <alloc_pages>
c0105210:	83 c4 10             	add    $0x10,%esp
c0105213:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105216:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105219:	83 e8 14             	sub    $0x14,%eax
c010521c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010521f:	74 19                	je     c010523a <default_check+0x3ea>
c0105221:	68 7a 7a 10 c0       	push   $0xc0107a7a
c0105226:	68 8e 77 10 c0       	push   $0xc010778e
c010522b:	68 15 01 00 00       	push   $0x115
c0105230:	68 a3 77 10 c0       	push   $0xc01077a3
c0105235:	e8 93 b1 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c010523a:	83 ec 08             	sub    $0x8,%esp
c010523d:	6a 01                	push   $0x1
c010523f:	ff 75 dc             	pushl  -0x24(%ebp)
c0105242:	e8 66 db ff ff       	call   c0102dad <free_pages>
c0105247:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010524a:	83 ec 0c             	sub    $0xc,%esp
c010524d:	6a 02                	push   $0x2
c010524f:	e8 1b db ff ff       	call   c0102d6f <alloc_pages>
c0105254:	83 c4 10             	add    $0x10,%esp
c0105257:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010525a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010525d:	83 c0 14             	add    $0x14,%eax
c0105260:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105263:	74 19                	je     c010527e <default_check+0x42e>
c0105265:	68 98 7a 10 c0       	push   $0xc0107a98
c010526a:	68 8e 77 10 c0       	push   $0xc010778e
c010526f:	68 17 01 00 00       	push   $0x117
c0105274:	68 a3 77 10 c0       	push   $0xc01077a3
c0105279:	e8 4f b1 ff ff       	call   c01003cd <__panic>

    free_pages(p0, 2);
c010527e:	83 ec 08             	sub    $0x8,%esp
c0105281:	6a 02                	push   $0x2
c0105283:	ff 75 dc             	pushl  -0x24(%ebp)
c0105286:	e8 22 db ff ff       	call   c0102dad <free_pages>
c010528b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010528e:	83 ec 08             	sub    $0x8,%esp
c0105291:	6a 01                	push   $0x1
c0105293:	ff 75 bc             	pushl  -0x44(%ebp)
c0105296:	e8 12 db ff ff       	call   c0102dad <free_pages>
c010529b:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c010529e:	83 ec 0c             	sub    $0xc,%esp
c01052a1:	6a 05                	push   $0x5
c01052a3:	e8 c7 da ff ff       	call   c0102d6f <alloc_pages>
c01052a8:	83 c4 10             	add    $0x10,%esp
c01052ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01052ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01052b2:	75 19                	jne    c01052cd <default_check+0x47d>
c01052b4:	68 b8 7a 10 c0       	push   $0xc0107ab8
c01052b9:	68 8e 77 10 c0       	push   $0xc010778e
c01052be:	68 1c 01 00 00       	push   $0x11c
c01052c3:	68 a3 77 10 c0       	push   $0xc01077a3
c01052c8:	e8 00 b1 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c01052cd:	83 ec 0c             	sub    $0xc,%esp
c01052d0:	6a 01                	push   $0x1
c01052d2:	e8 98 da ff ff       	call   c0102d6f <alloc_pages>
c01052d7:	83 c4 10             	add    $0x10,%esp
c01052da:	85 c0                	test   %eax,%eax
c01052dc:	74 19                	je     c01052f7 <default_check+0x4a7>
c01052de:	68 16 79 10 c0       	push   $0xc0107916
c01052e3:	68 8e 77 10 c0       	push   $0xc010778e
c01052e8:	68 1d 01 00 00       	push   $0x11d
c01052ed:	68 a3 77 10 c0       	push   $0xc01077a3
c01052f2:	e8 d6 b0 ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c01052f7:	a1 70 a9 11 c0       	mov    0xc011a970,%eax
c01052fc:	85 c0                	test   %eax,%eax
c01052fe:	74 19                	je     c0105319 <default_check+0x4c9>
c0105300:	68 69 79 10 c0       	push   $0xc0107969
c0105305:	68 8e 77 10 c0       	push   $0xc010778e
c010530a:	68 1f 01 00 00       	push   $0x11f
c010530f:	68 a3 77 10 c0       	push   $0xc01077a3
c0105314:	e8 b4 b0 ff ff       	call   c01003cd <__panic>
    nr_free = nr_free_store;
c0105319:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010531c:	a3 70 a9 11 c0       	mov    %eax,0xc011a970

    free_list = free_list_store;
c0105321:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105327:	8b 55 80             	mov    -0x80(%ebp),%edx
c010532a:	a3 68 a9 11 c0       	mov    %eax,0xc011a968
c010532f:	89 15 6c a9 11 c0    	mov    %edx,0xc011a96c
    free_pages(p0, 5);
c0105335:	83 ec 08             	sub    $0x8,%esp
c0105338:	6a 05                	push   $0x5
c010533a:	ff 75 dc             	pushl  -0x24(%ebp)
c010533d:	e8 6b da ff ff       	call   c0102dad <free_pages>
c0105342:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0105345:	c7 45 ec 68 a9 11 c0 	movl   $0xc011a968,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010534c:	eb 1d                	jmp    c010536b <default_check+0x51b>
        struct Page *p = le2page(le, page_link);
c010534e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105351:	83 e8 0c             	sub    $0xc,%eax
c0105354:	89 45 b0             	mov    %eax,-0x50(%ebp)
        count --, total -= p->property;
c0105357:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010535b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010535e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105361:	8b 40 08             	mov    0x8(%eax),%eax
c0105364:	29 c2                	sub    %eax,%edx
c0105366:	89 d0                	mov    %edx,%eax
c0105368:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010536b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010536e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105371:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105374:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105377:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010537a:	81 7d ec 68 a9 11 c0 	cmpl   $0xc011a968,-0x14(%ebp)
c0105381:	75 cb                	jne    c010534e <default_check+0x4fe>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105387:	74 19                	je     c01053a2 <default_check+0x552>
c0105389:	68 d6 7a 10 c0       	push   $0xc0107ad6
c010538e:	68 8e 77 10 c0       	push   $0xc010778e
c0105393:	68 2a 01 00 00       	push   $0x12a
c0105398:	68 a3 77 10 c0       	push   $0xc01077a3
c010539d:	e8 2b b0 ff ff       	call   c01003cd <__panic>
    assert(total == 0);
c01053a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053a6:	74 19                	je     c01053c1 <default_check+0x571>
c01053a8:	68 e1 7a 10 c0       	push   $0xc0107ae1
c01053ad:	68 8e 77 10 c0       	push   $0xc010778e
c01053b2:	68 2b 01 00 00       	push   $0x12b
c01053b7:	68 a3 77 10 c0       	push   $0xc01077a3
c01053bc:	e8 0c b0 ff ff       	call   c01003cd <__panic>
}
c01053c1:	90                   	nop
c01053c2:	c9                   	leave  
c01053c3:	c3                   	ret    

c01053c4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01053c4:	55                   	push   %ebp
c01053c5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01053c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ca:	8b 15 64 a9 11 c0    	mov    0xc011a964,%edx
c01053d0:	29 d0                	sub    %edx,%eax
c01053d2:	c1 f8 02             	sar    $0x2,%eax
c01053d5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01053db:	5d                   	pop    %ebp
c01053dc:	c3                   	ret    

c01053dd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01053dd:	55                   	push   %ebp
c01053de:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01053e0:	ff 75 08             	pushl  0x8(%ebp)
c01053e3:	e8 dc ff ff ff       	call   c01053c4 <page2ppn>
c01053e8:	83 c4 04             	add    $0x4,%esp
c01053eb:	c1 e0 0c             	shl    $0xc,%eax
}
c01053ee:	c9                   	leave  
c01053ef:	c3                   	ret    

c01053f0 <set_page_ref>:
page_ref(struct Page *page) {
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
c01053f0:	55                   	push   %ebp
c01053f1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01053f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053f9:	89 10                	mov    %edx,(%eax)
}
c01053fb:	90                   	nop
c01053fc:	5d                   	pop    %ebp
c01053fd:	c3                   	ret    

c01053fe <buddy_find_first_zero>:
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) ( ((index) + 1) / 2 - 1)
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static unsigned int
buddy_find_first_zero(unsigned int bit_array) {
c01053fe:	55                   	push   %ebp
c01053ff:	89 e5                	mov    %esp,%ebp
c0105401:	83 ec 10             	sub    $0x10,%esp
    unsigned pos = 0;
c0105404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (bit_array >>= 1) ++ pos;
c010540b:	eb 04                	jmp    c0105411 <buddy_find_first_zero+0x13>
c010540d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105411:	d1 6d 08             	shrl   0x8(%ebp)
c0105414:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105418:	75 f3                	jne    c010540d <buddy_find_first_zero+0xf>
    return pos;
c010541a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010541d:	c9                   	leave  
c010541e:	c3                   	ret    

c010541f <buddy_node_index_to_page>:

static struct Page*
buddy_node_index_to_page(unsigned int index, unsigned int node_size) {
c010541f:	55                   	push   %ebp
c0105420:	89 e5                	mov    %esp,%ebp
	return buddy_allocatable_base + ((index + 1) * node_size - buddy_max_pages);
c0105422:	8b 0d 54 a9 11 c0    	mov    0xc011a954,%ecx
c0105428:	8b 45 08             	mov    0x8(%ebp),%eax
c010542b:	83 c0 01             	add    $0x1,%eax
c010542e:	0f af 45 0c          	imul   0xc(%ebp),%eax
c0105432:	89 c2                	mov    %eax,%edx
c0105434:	a1 50 a9 11 c0       	mov    0xc011a950,%eax
c0105439:	29 c2                	sub    %eax,%edx
c010543b:	89 d0                	mov    %edx,%eax
c010543d:	c1 e0 02             	shl    $0x2,%eax
c0105440:	01 d0                	add    %edx,%eax
c0105442:	c1 e0 02             	shl    $0x2,%eax
c0105445:	01 c8                	add    %ecx,%eax
}
c0105447:	5d                   	pop    %ebp
c0105448:	c3                   	ret    

c0105449 <buddy_init>:

static void
buddy_init(void) {
c0105449:	55                   	push   %ebp
c010544a:	89 e5                	mov    %esp,%ebp
	// do nothing.
}
c010544c:	90                   	nop
c010544d:	5d                   	pop    %ebp
c010544e:	c3                   	ret    

c010544f <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
c010544f:	55                   	push   %ebp
c0105450:	89 e5                	mov    %esp,%ebp
c0105452:	83 ec 58             	sub    $0x58,%esp
	assert(n > 0);
c0105455:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105459:	75 16                	jne    c0105471 <buddy_init_memmap+0x22>
c010545b:	68 1c 7b 10 c0       	push   $0xc0107b1c
c0105460:	68 22 7b 10 c0       	push   $0xc0107b22
c0105465:	6a 28                	push   $0x28
c0105467:	68 37 7b 10 c0       	push   $0xc0107b37
c010546c:	e8 5c af ff ff       	call   c01003cd <__panic>
	// Calculate maximum manageable memory zone
	unsigned int max_pages = 1;
c0105471:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	for (unsigned int i = 1; i < BUDDY_MAX_DEPTH; ++ i) {
c0105478:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010547f:	eb 23                	jmp    c01054a4 <buddy_init_memmap+0x55>
		// Should consider the page for storing 'longest' array.
		if (max_pages + max_pages / 512 >= n) {
c0105481:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105484:	c1 e8 09             	shr    $0x9,%eax
c0105487:	89 c2                	mov    %eax,%edx
c0105489:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010548c:	01 d0                	add    %edx,%eax
c010548e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105491:	72 0a                	jb     c010549d <buddy_init_memmap+0x4e>
			max_pages /= 2;
c0105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105496:	d1 e8                	shr    %eax
c0105498:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
c010549b:	eb 0d                	jmp    c01054aa <buddy_init_memmap+0x5b>
		}
		max_pages *= 2;
c010549d:	d1 65 f4             	shll   -0xc(%ebp)
static void
buddy_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	// Calculate maximum manageable memory zone
	unsigned int max_pages = 1;
	for (unsigned int i = 1; i < BUDDY_MAX_DEPTH; ++ i) {
c01054a0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01054a4:	83 7d f0 1d          	cmpl   $0x1d,-0x10(%ebp)
c01054a8:	76 d7                	jbe    c0105481 <buddy_init_memmap+0x32>
			max_pages /= 2;
			break;
		}
		max_pages *= 2;
	}
	unsigned int longest_array_pages = max_pages / 512 + 1;
c01054aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054ad:	c1 e8 09             	shr    $0x9,%eax
c01054b0:	83 c0 01             	add    $0x1,%eax
c01054b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("BUDDY: Maximum manageable pages = %d, pages for storing longest = %d\n",
c01054b6:	83 ec 04             	sub    $0x4,%esp
c01054b9:	ff 75 dc             	pushl  -0x24(%ebp)
c01054bc:	ff 75 f4             	pushl  -0xc(%ebp)
c01054bf:	68 4c 7b 10 c0       	push   $0xc0107b4c
c01054c4:	e8 9e ad ff ff       	call   c0100267 <cprintf>
c01054c9:	83 c4 10             	add    $0x10,%esp
			max_pages, longest_array_pages);
	buddy_longest = (unsigned int*)KADDR(page2pa(base));
c01054cc:	83 ec 0c             	sub    $0xc,%esp
c01054cf:	ff 75 08             	pushl  0x8(%ebp)
c01054d2:	e8 06 ff ff ff       	call   c01053dd <page2pa>
c01054d7:	83 c4 10             	add    $0x10,%esp
c01054da:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01054dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054e0:	c1 e8 0c             	shr    $0xc,%eax
c01054e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01054e6:	a1 c0 a8 11 c0       	mov    0xc011a8c0,%eax
c01054eb:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
c01054ee:	72 14                	jb     c0105504 <buddy_init_memmap+0xb5>
c01054f0:	ff 75 d8             	pushl  -0x28(%ebp)
c01054f3:	68 94 7b 10 c0       	push   $0xc0107b94
c01054f8:	6a 36                	push   $0x36
c01054fa:	68 37 7b 10 c0       	push   $0xc0107b37
c01054ff:	e8 c9 ae ff ff       	call   c01003cd <__panic>
c0105504:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105507:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010550c:	a3 4c a9 11 c0       	mov    %eax,0xc011a94c
	buddy_max_pages = max_pages;
c0105511:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105514:	a3 50 a9 11 c0       	mov    %eax,0xc011a950

	unsigned int node_size = max_pages * 2;
c0105519:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010551c:	01 c0                	add    %eax,%eax
c010551e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
c0105521:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105528:	eb 2b                	jmp    c0105555 <buddy_init_memmap+0x106>
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
c010552a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010552d:	83 c0 01             	add    $0x1,%eax
c0105530:	23 45 e8             	and    -0x18(%ebp),%eax
c0105533:	85 c0                	test   %eax,%eax
c0105535:	75 08                	jne    c010553f <buddy_init_memmap+0xf0>
c0105537:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010553a:	d1 e8                	shr    %eax
c010553c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		buddy_longest[i] = node_size;
c010553f:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c0105544:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105547:	c1 e2 02             	shl    $0x2,%edx
c010554a:	01 c2                	add    %eax,%edx
c010554c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010554f:	89 02                	mov    %eax,(%edx)
			max_pages, longest_array_pages);
	buddy_longest = (unsigned int*)KADDR(page2pa(base));
	buddy_max_pages = max_pages;

	unsigned int node_size = max_pages * 2;
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
c0105551:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105558:	01 c0                	add    %eax,%eax
c010555a:	83 e8 01             	sub    $0x1,%eax
c010555d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105560:	77 c8                	ja     c010552a <buddy_init_memmap+0xdb>
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
		buddy_longest[i] = node_size;
	}

	for (int i = 0; i < longest_array_pages; ++ i) {
c0105562:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0105569:	eb 34                	jmp    c010559f <buddy_init_memmap+0x150>
		struct Page *p = base + i;
c010556b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010556e:	89 d0                	mov    %edx,%eax
c0105570:	c1 e0 02             	shl    $0x2,%eax
c0105573:	01 d0                	add    %edx,%eax
c0105575:	c1 e0 02             	shl    $0x2,%eax
c0105578:	89 c2                	mov    %eax,%edx
c010557a:	8b 45 08             	mov    0x8(%ebp),%eax
c010557d:	01 d0                	add    %edx,%eax
c010557f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		SetPageReserved(p);
c0105582:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105585:	83 c0 04             	add    $0x4,%eax
c0105588:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c010558f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105592:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105595:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105598:	0f ab 10             	bts    %edx,(%eax)
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
		buddy_longest[i] = node_size;
	}

	for (int i = 0; i < longest_array_pages; ++ i) {
c010559b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c010559f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055a2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01055a5:	72 c4                	jb     c010556b <buddy_init_memmap+0x11c>
		struct Page *p = base + i;
		SetPageReserved(p);
	}

	struct Page *p = base + longest_array_pages;
c01055a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01055aa:	89 d0                	mov    %edx,%eax
c01055ac:	c1 e0 02             	shl    $0x2,%eax
c01055af:	01 d0                	add    %edx,%eax
c01055b1:	c1 e0 02             	shl    $0x2,%eax
c01055b4:	89 c2                	mov    %eax,%edx
c01055b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b9:	01 d0                	add    %edx,%eax
c01055bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	buddy_allocatable_base = p;
c01055be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055c1:	a3 54 a9 11 c0       	mov    %eax,0xc011a954
	for (; p != base + n; p ++) {
c01055c6:	e9 88 00 00 00       	jmp    c0105653 <buddy_init_memmap+0x204>
		assert(PageReserved(p));
c01055cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055ce:	83 c0 04             	add    $0x4,%eax
c01055d1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c01055d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055db:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01055de:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01055e1:	0f a3 10             	bt     %edx,(%eax)
c01055e4:	19 c0                	sbb    %eax,%eax
c01055e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c01055e9:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c01055ed:	0f 95 c0             	setne  %al
c01055f0:	0f b6 c0             	movzbl %al,%eax
c01055f3:	85 c0                	test   %eax,%eax
c01055f5:	75 16                	jne    c010560d <buddy_init_memmap+0x1be>
c01055f7:	68 b7 7b 10 c0       	push   $0xc0107bb7
c01055fc:	68 22 7b 10 c0       	push   $0xc0107b22
c0105601:	6a 47                	push   $0x47
c0105603:	68 37 7b 10 c0       	push   $0xc0107b37
c0105608:	e8 c0 ad ff ff       	call   c01003cd <__panic>
		ClearPageReserved(p);
c010560d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105610:	83 c0 04             	add    $0x4,%eax
c0105613:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
c010561a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010561d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105620:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105623:	0f b3 10             	btr    %edx,(%eax)
		SetPageProperty(p);
c0105626:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105629:	83 c0 04             	add    $0x4,%eax
c010562c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0105633:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105636:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105639:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010563c:	0f ab 10             	bts    %edx,(%eax)
		set_page_ref(p, 0);
c010563f:	83 ec 08             	sub    $0x8,%esp
c0105642:	6a 00                	push   $0x0
c0105644:	ff 75 e0             	pushl  -0x20(%ebp)
c0105647:	e8 a4 fd ff ff       	call   c01053f0 <set_page_ref>
c010564c:	83 c4 10             	add    $0x10,%esp
		SetPageReserved(p);
	}

	struct Page *p = base + longest_array_pages;
	buddy_allocatable_base = p;
	for (; p != base + n; p ++) {
c010564f:	83 45 e0 14          	addl   $0x14,-0x20(%ebp)
c0105653:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105656:	89 d0                	mov    %edx,%eax
c0105658:	c1 e0 02             	shl    $0x2,%eax
c010565b:	01 d0                	add    %edx,%eax
c010565d:	c1 e0 02             	shl    $0x2,%eax
c0105660:	89 c2                	mov    %eax,%edx
c0105662:	8b 45 08             	mov    0x8(%ebp),%eax
c0105665:	01 d0                	add    %edx,%eax
c0105667:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010566a:	0f 85 5b ff ff ff    	jne    c01055cb <buddy_init_memmap+0x17c>
		assert(PageReserved(p));
		ClearPageReserved(p);
		SetPageProperty(p);
		set_page_ref(p, 0);
	}
}
c0105670:	90                   	nop
c0105671:	c9                   	leave  
c0105672:	c3                   	ret    

c0105673 <buddy_fix_size>:

static size_t
buddy_fix_size(size_t before) {
c0105673:	55                   	push   %ebp
c0105674:	89 e5                	mov    %esp,%ebp
c0105676:	83 ec 10             	sub    $0x10,%esp
	unsigned int ffz = buddy_find_first_zero(before) + 1;
c0105679:	ff 75 08             	pushl  0x8(%ebp)
c010567c:	e8 7d fd ff ff       	call   c01053fe <buddy_find_first_zero>
c0105681:	83 c4 04             	add    $0x4,%esp
c0105684:	83 c0 01             	add    $0x1,%eax
c0105687:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (1 << ffz);
c010568a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010568d:	ba 01 00 00 00       	mov    $0x1,%edx
c0105692:	89 c1                	mov    %eax,%ecx
c0105694:	d3 e2                	shl    %cl,%edx
c0105696:	89 d0                	mov    %edx,%eax
}
c0105698:	c9                   	leave  
c0105699:	c3                   	ret    

c010569a <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
c010569a:	55                   	push   %ebp
c010569b:	89 e5                	mov    %esp,%ebp
c010569d:	53                   	push   %ebx
c010569e:	83 ec 24             	sub    $0x24,%esp
	assert(n > 0);
c01056a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01056a5:	75 16                	jne    c01056bd <buddy_alloc_pages+0x23>
c01056a7:	68 1c 7b 10 c0       	push   $0xc0107b1c
c01056ac:	68 22 7b 10 c0       	push   $0xc0107b22
c01056b1:	6a 56                	push   $0x56
c01056b3:	68 37 7b 10 c0       	push   $0xc0107b37
c01056b8:	e8 10 ad ff ff       	call   c01003cd <__panic>
	if (!IS_POWER_OF_2(n)) {
c01056bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c0:	83 e8 01             	sub    $0x1,%eax
c01056c3:	23 45 08             	and    0x8(%ebp),%eax
c01056c6:	85 c0                	test   %eax,%eax
c01056c8:	74 11                	je     c01056db <buddy_alloc_pages+0x41>
		n = buddy_fix_size(n);
c01056ca:	83 ec 0c             	sub    $0xc,%esp
c01056cd:	ff 75 08             	pushl  0x8(%ebp)
c01056d0:	e8 9e ff ff ff       	call   c0105673 <buddy_fix_size>
c01056d5:	83 c4 10             	add    $0x10,%esp
c01056d8:	89 45 08             	mov    %eax,0x8(%ebp)
	}
	if (n > buddy_longest[0]) {
c01056db:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01056e0:	8b 00                	mov    (%eax),%eax
c01056e2:	3b 45 08             	cmp    0x8(%ebp),%eax
c01056e5:	73 0a                	jae    c01056f1 <buddy_alloc_pages+0x57>
		return NULL;
c01056e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01056ec:	e9 17 01 00 00       	jmp    c0105808 <buddy_alloc_pages+0x16e>
	}

	// Find the top node for allocation.
	// Starting from root
	unsigned int index = 0;
c01056f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	// The size of current node
	unsigned int node_size;

	// go from the root and find the most suitable position
	for (node_size = buddy_max_pages; node_size != n; node_size /= 2) {
c01056f8:	a1 50 a9 11 c0       	mov    0xc011a950,%eax
c01056fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105700:	eb 37                	jmp    c0105739 <buddy_alloc_pages+0x9f>
		if (buddy_longest[LEFT_LEAF(index)] >= n) {
c0105702:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c0105707:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010570a:	c1 e2 03             	shl    $0x3,%edx
c010570d:	83 c2 04             	add    $0x4,%edx
c0105710:	01 d0                	add    %edx,%eax
c0105712:	8b 00                	mov    (%eax),%eax
c0105714:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105717:	72 0d                	jb     c0105726 <buddy_alloc_pages+0x8c>
			index = LEFT_LEAF(index);
c0105719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010571c:	01 c0                	add    %eax,%eax
c010571e:	83 c0 01             	add    $0x1,%eax
c0105721:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105724:	eb 0b                	jmp    c0105731 <buddy_alloc_pages+0x97>
		} else {
			index = RIGHT_LEAF(index);
c0105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105729:	83 c0 01             	add    $0x1,%eax
c010572c:	01 c0                	add    %eax,%eax
c010572e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	unsigned int index = 0;
	// The size of current node
	unsigned int node_size;

	// go from the root and find the most suitable position
	for (node_size = buddy_max_pages; node_size != n; node_size /= 2) {
c0105731:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105734:	d1 e8                	shr    %eax
c0105736:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105739:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010573c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010573f:	75 c1                	jne    c0105702 <buddy_alloc_pages+0x68>
			index = RIGHT_LEAF(index);
		}
	}

	// Allocate all pages under this node.
	buddy_longest[index] = 0;
c0105741:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c0105746:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105749:	c1 e2 02             	shl    $0x2,%edx
c010574c:	01 d0                	add    %edx,%eax
c010574e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	struct Page* new_page = buddy_node_index_to_page(index, node_size);
c0105754:	83 ec 08             	sub    $0x8,%esp
c0105757:	ff 75 f0             	pushl  -0x10(%ebp)
c010575a:	ff 75 f4             	pushl  -0xc(%ebp)
c010575d:	e8 bd fc ff ff       	call   c010541f <buddy_node_index_to_page>
c0105762:	83 c4 10             	add    $0x10,%esp
c0105765:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (struct Page* p = new_page; p != (new_page + node_size); ++ p) {
c0105768:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010576b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010576e:	eb 2d                	jmp    c010579d <buddy_alloc_pages+0x103>
		// Set new allocated page ref = 0;
		set_page_ref(p, 0);
c0105770:	83 ec 08             	sub    $0x8,%esp
c0105773:	6a 00                	push   $0x0
c0105775:	ff 75 ec             	pushl  -0x14(%ebp)
c0105778:	e8 73 fc ff ff       	call   c01053f0 <set_page_ref>
c010577d:	83 c4 10             	add    $0x10,%esp
		// Set property = not free.
		ClearPageProperty(p);
c0105780:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105783:	83 c0 04             	add    $0x4,%eax
c0105786:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010578d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105790:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105796:	0f b3 10             	btr    %edx,(%eax)
	}

	// Allocate all pages under this node.
	buddy_longest[index] = 0;
	struct Page* new_page = buddy_node_index_to_page(index, node_size);
	for (struct Page* p = new_page; p != (new_page + node_size); ++ p) {
c0105799:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c010579d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01057a0:	89 d0                	mov    %edx,%eax
c01057a2:	c1 e0 02             	shl    $0x2,%eax
c01057a5:	01 d0                	add    %edx,%eax
c01057a7:	c1 e0 02             	shl    $0x2,%eax
c01057aa:	89 c2                	mov    %eax,%edx
c01057ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057af:	01 d0                	add    %edx,%eax
c01057b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01057b4:	75 ba                	jne    c0105770 <buddy_alloc_pages+0xd6>
		// Set property = not free.
		ClearPageProperty(p);
	}

	// Update parent longest value because this node is used.
	while (index) {
c01057b6:	eb 47                	jmp    c01057ff <buddy_alloc_pages+0x165>
		index = PARENT(index);
c01057b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057bb:	83 c0 01             	add    $0x1,%eax
c01057be:	d1 e8                	shr    %eax
c01057c0:	83 e8 01             	sub    $0x1,%eax
c01057c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		buddy_longest[index] =
c01057c6:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01057cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057ce:	c1 e2 02             	shl    $0x2,%edx
c01057d1:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
				MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
c01057d4:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01057d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057dc:	83 c2 01             	add    $0x1,%edx
c01057df:	c1 e2 03             	shl    $0x3,%edx
c01057e2:	01 d0                	add    %edx,%eax
c01057e4:	8b 10                	mov    (%eax),%edx
c01057e6:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01057eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01057ee:	c1 e3 03             	shl    $0x3,%ebx
c01057f1:	83 c3 04             	add    $0x4,%ebx
c01057f4:	01 d8                	add    %ebx,%eax
c01057f6:	8b 00                	mov    (%eax),%eax
c01057f8:	39 c2                	cmp    %eax,%edx
c01057fa:	0f 43 c2             	cmovae %edx,%eax
	}

	// Update parent longest value because this node is used.
	while (index) {
		index = PARENT(index);
		buddy_longest[index] =
c01057fd:	89 01                	mov    %eax,(%ecx)
		// Set property = not free.
		ClearPageProperty(p);
	}

	// Update parent longest value because this node is used.
	while (index) {
c01057ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105803:	75 b3                	jne    c01057b8 <buddy_alloc_pages+0x11e>
		index = PARENT(index);
		buddy_longest[index] =
				MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
	}
	return new_page;
c0105805:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
c0105808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010580b:	c9                   	leave  
c010580c:	c3                   	ret    

c010580d <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
c010580d:	55                   	push   %ebp
c010580e:	89 e5                	mov    %esp,%ebp
c0105810:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
c0105813:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105817:	75 19                	jne    c0105832 <buddy_free_pages+0x25>
c0105819:	68 1c 7b 10 c0       	push   $0xc0107b1c
c010581e:	68 22 7b 10 c0       	push   $0xc0107b22
c0105823:	68 82 00 00 00       	push   $0x82
c0105828:	68 37 7b 10 c0       	push   $0xc0107b37
c010582d:	e8 9b ab ff ff       	call   c01003cd <__panic>
	// Find the base-correponded node and its size;
	unsigned int index = (unsigned int)(base - buddy_allocatable_base) + buddy_max_pages - 1;
c0105832:	8b 45 08             	mov    0x8(%ebp),%eax
c0105835:	8b 15 54 a9 11 c0    	mov    0xc011a954,%edx
c010583b:	29 d0                	sub    %edx,%eax
c010583d:	c1 f8 02             	sar    $0x2,%eax
c0105840:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c0105846:	89 c2                	mov    %eax,%edx
c0105848:	a1 50 a9 11 c0       	mov    0xc011a950,%eax
c010584d:	01 d0                	add    %edx,%eax
c010584f:	83 e8 01             	sub    $0x1,%eax
c0105852:	89 45 f4             	mov    %eax,-0xc(%ebp)
	unsigned int node_size = 1;
c0105855:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// Starting from the leaf and find the first (lowest) node has longest = 0;
	while (buddy_longest[index] != 0) {
c010585c:	eb 30                	jmp    c010588e <buddy_free_pages+0x81>
		node_size *= 2;
c010585e:	d1 65 f0             	shll   -0x10(%ebp)
		// cannot find the corresponding node for the base.
		assert(index != 0);
c0105861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105865:	75 19                	jne    c0105880 <buddy_free_pages+0x73>
c0105867:	68 c7 7b 10 c0       	push   $0xc0107bc7
c010586c:	68 22 7b 10 c0       	push   $0xc0107b22
c0105871:	68 8b 00 00 00       	push   $0x8b
c0105876:	68 37 7b 10 c0       	push   $0xc0107b37
c010587b:	e8 4d ab ff ff       	call   c01003cd <__panic>
		index = PARENT(index);
c0105880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105883:	83 c0 01             	add    $0x1,%eax
c0105886:	d1 e8                	shr    %eax
c0105888:	83 e8 01             	sub    $0x1,%eax
c010588b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Find the base-correponded node and its size;
	unsigned int index = (unsigned int)(base - buddy_allocatable_base) + buddy_max_pages - 1;
	unsigned int node_size = 1;

	// Starting from the leaf and find the first (lowest) node has longest = 0;
	while (buddy_longest[index] != 0) {
c010588e:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c0105893:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105896:	c1 e2 02             	shl    $0x2,%edx
c0105899:	01 d0                	add    %edx,%eax
c010589b:	8b 00                	mov    (%eax),%eax
c010589d:	85 c0                	test   %eax,%eax
c010589f:	75 bd                	jne    c010585e <buddy_free_pages+0x51>

	// NOTICE: Be careful when releasing memory if the following line is commented.
	// assert(node_size == n);

	// Free the pages.
	struct Page *p = base;
c01058a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (; p != base + n; p ++) {
c01058a7:	e9 9e 00 00 00       	jmp    c010594a <buddy_free_pages+0x13d>
	    assert(!PageReserved(p) && !PageProperty(p));
c01058ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058af:	83 c0 04             	add    $0x4,%eax
c01058b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c01058b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01058bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01058c2:	0f a3 10             	bt     %edx,(%eax)
c01058c5:	19 c0                	sbb    %eax,%eax
c01058c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c01058ca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01058ce:	0f 95 c0             	setne  %al
c01058d1:	0f b6 c0             	movzbl %al,%eax
c01058d4:	85 c0                	test   %eax,%eax
c01058d6:	75 2c                	jne    c0105904 <buddy_free_pages+0xf7>
c01058d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058db:	83 c0 04             	add    $0x4,%eax
c01058de:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c01058e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01058e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01058eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058ee:	0f a3 10             	bt     %edx,(%eax)
c01058f1:	19 c0                	sbb    %eax,%eax
c01058f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01058f6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01058fa:	0f 95 c0             	setne  %al
c01058fd:	0f b6 c0             	movzbl %al,%eax
c0105900:	85 c0                	test   %eax,%eax
c0105902:	74 19                	je     c010591d <buddy_free_pages+0x110>
c0105904:	68 d4 7b 10 c0       	push   $0xc0107bd4
c0105909:	68 22 7b 10 c0       	push   $0xc0107b22
c010590e:	68 95 00 00 00       	push   $0x95
c0105913:	68 37 7b 10 c0       	push   $0xc0107b37
c0105918:	e8 b0 aa ff ff       	call   c01003cd <__panic>
	    SetPageProperty(p);
c010591d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105920:	83 c0 04             	add    $0x4,%eax
c0105923:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010592a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010592d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105933:	0f ab 10             	bts    %edx,(%eax)
	    set_page_ref(p, 0);
c0105936:	83 ec 08             	sub    $0x8,%esp
c0105939:	6a 00                	push   $0x0
c010593b:	ff 75 ec             	pushl  -0x14(%ebp)
c010593e:	e8 ad fa ff ff       	call   c01053f0 <set_page_ref>
c0105943:	83 c4 10             	add    $0x10,%esp
	// NOTICE: Be careful when releasing memory if the following line is commented.
	// assert(node_size == n);

	// Free the pages.
	struct Page *p = base;
	for (; p != base + n; p ++) {
c0105946:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c010594a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010594d:	89 d0                	mov    %edx,%eax
c010594f:	c1 e0 02             	shl    $0x2,%eax
c0105952:	01 d0                	add    %edx,%eax
c0105954:	c1 e0 02             	shl    $0x2,%eax
c0105957:	89 c2                	mov    %eax,%edx
c0105959:	8b 45 08             	mov    0x8(%ebp),%eax
c010595c:	01 d0                	add    %edx,%eax
c010595e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105961:	0f 85 45 ff ff ff    	jne    c01058ac <buddy_free_pages+0x9f>
	    SetPageProperty(p);
	    set_page_ref(p, 0);
	}

	// Update longest.
	buddy_longest[index] = node_size;
c0105967:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c010596c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010596f:	c1 e2 02             	shl    $0x2,%edx
c0105972:	01 c2                	add    %eax,%edx
c0105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105977:	89 02                	mov    %eax,(%edx)
	while (index != 0) {
c0105979:	eb 75                	jmp    c01059f0 <buddy_free_pages+0x1e3>
		// Starting from this node, try to merge all the way to parent.
		// The condition for merging is (left_child + right_child = node_size)
		index = PARENT(index);
c010597b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010597e:	83 c0 01             	add    $0x1,%eax
c0105981:	d1 e8                	shr    %eax
c0105983:	83 e8 01             	sub    $0x1,%eax
c0105986:	89 45 f4             	mov    %eax,-0xc(%ebp)
		node_size *= 2;
c0105989:	d1 65 f0             	shll   -0x10(%ebp)
		unsigned int left_longest = buddy_longest[LEFT_LEAF(index)];
c010598c:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c0105991:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105994:	c1 e2 03             	shl    $0x3,%edx
c0105997:	83 c2 04             	add    $0x4,%edx
c010599a:	01 d0                	add    %edx,%eax
c010599c:	8b 00                	mov    (%eax),%eax
c010599e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		unsigned int right_longest = buddy_longest[RIGHT_LEAF(index)];
c01059a1:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01059a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a9:	83 c2 01             	add    $0x1,%edx
c01059ac:	c1 e2 03             	shl    $0x3,%edx
c01059af:	01 d0                	add    %edx,%eax
c01059b1:	8b 00                	mov    (%eax),%eax
c01059b3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if (left_longest + right_longest == node_size) {
c01059b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01059b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01059bc:	01 d0                	add    %edx,%eax
c01059be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01059c1:	75 14                	jne    c01059d7 <buddy_free_pages+0x1ca>
			buddy_longest[index] = node_size;
c01059c3:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01059c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059cb:	c1 e2 02             	shl    $0x2,%edx
c01059ce:	01 c2                	add    %eax,%edx
c01059d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059d3:	89 02                	mov    %eax,(%edx)
c01059d5:	eb 19                	jmp    c01059f0 <buddy_free_pages+0x1e3>
		} else {
			// update because the child is updated.
			buddy_longest[index] = MAX(left_longest, right_longest);
c01059d7:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c01059dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059df:	c1 e2 02             	shl    $0x2,%edx
c01059e2:	01 c2                	add    %eax,%edx
c01059e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059e7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01059ea:	0f 43 45 dc          	cmovae -0x24(%ebp),%eax
c01059ee:	89 02                	mov    %eax,(%edx)
	    set_page_ref(p, 0);
	}

	// Update longest.
	buddy_longest[index] = node_size;
	while (index != 0) {
c01059f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01059f4:	75 85                	jne    c010597b <buddy_free_pages+0x16e>
		} else {
			// update because the child is updated.
			buddy_longest[index] = MAX(left_longest, right_longest);
		}
	}
}
c01059f6:	90                   	nop
c01059f7:	c9                   	leave  
c01059f8:	c3                   	ret    

c01059f9 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c01059f9:	55                   	push   %ebp
c01059fa:	89 e5                	mov    %esp,%ebp
    return buddy_longest[0];
c01059fc:	a1 4c a9 11 c0       	mov    0xc011a94c,%eax
c0105a01:	8b 00                	mov    (%eax),%eax
}
c0105a03:	5d                   	pop    %ebp
c0105a04:	c3                   	ret    

c0105a05 <buddy_check>:

static void
buddy_check(void) {
c0105a05:	55                   	push   %ebp
c0105a06:	89 e5                	mov    %esp,%ebp
c0105a08:	81 ec 98 00 00 00    	sub    $0x98,%esp
	int all_pages = nr_free_pages();
c0105a0e:	e8 cf d3 ff ff       	call   c0102de2 <nr_free_pages>
c0105a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct Page* p0, *p1, *p2, *p3, *p4;
	assert(alloc_pages(all_pages + 1) == NULL);
c0105a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a19:	83 c0 01             	add    $0x1,%eax
c0105a1c:	83 ec 0c             	sub    $0xc,%esp
c0105a1f:	50                   	push   %eax
c0105a20:	e8 4a d3 ff ff       	call   c0102d6f <alloc_pages>
c0105a25:	83 c4 10             	add    $0x10,%esp
c0105a28:	85 c0                	test   %eax,%eax
c0105a2a:	74 19                	je     c0105a45 <buddy_check+0x40>
c0105a2c:	68 fc 7b 10 c0       	push   $0xc0107bfc
c0105a31:	68 22 7b 10 c0       	push   $0xc0107b22
c0105a36:	68 b6 00 00 00       	push   $0xb6
c0105a3b:	68 37 7b 10 c0       	push   $0xc0107b37
c0105a40:	e8 88 a9 ff ff       	call   c01003cd <__panic>

	p0 = alloc_pages(1);
c0105a45:	83 ec 0c             	sub    $0xc,%esp
c0105a48:	6a 01                	push   $0x1
c0105a4a:	e8 20 d3 ff ff       	call   c0102d6f <alloc_pages>
c0105a4f:	83 c4 10             	add    $0x10,%esp
c0105a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert(p0 != NULL);
c0105a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a59:	75 19                	jne    c0105a74 <buddy_check+0x6f>
c0105a5b:	68 1f 7c 10 c0       	push   $0xc0107c1f
c0105a60:	68 22 7b 10 c0       	push   $0xc0107b22
c0105a65:	68 b9 00 00 00       	push   $0xb9
c0105a6a:	68 37 7b 10 c0       	push   $0xc0107b37
c0105a6f:	e8 59 a9 ff ff       	call   c01003cd <__panic>
	p1 = alloc_pages(2);
c0105a74:	83 ec 0c             	sub    $0xc,%esp
c0105a77:	6a 02                	push   $0x2
c0105a79:	e8 f1 d2 ff ff       	call   c0102d6f <alloc_pages>
c0105a7e:	83 c4 10             	add    $0x10,%esp
c0105a81:	89 45 ec             	mov    %eax,-0x14(%ebp)
	assert(p1 == p0 + 2);
c0105a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a87:	83 c0 28             	add    $0x28,%eax
c0105a8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105a8d:	74 19                	je     c0105aa8 <buddy_check+0xa3>
c0105a8f:	68 2a 7c 10 c0       	push   $0xc0107c2a
c0105a94:	68 22 7b 10 c0       	push   $0xc0107b22
c0105a99:	68 bb 00 00 00       	push   $0xbb
c0105a9e:	68 37 7b 10 c0       	push   $0xc0107b37
c0105aa3:	e8 25 a9 ff ff       	call   c01003cd <__panic>
	assert(!PageReserved(p0) && !PageReserved(p1));
c0105aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aab:	83 c0 04             	add    $0x4,%eax
c0105aae:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c0105ab5:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ab8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105abb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105abe:	0f a3 10             	bt     %edx,(%eax)
c0105ac1:	19 c0                	sbb    %eax,%eax
c0105ac3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c0105ac6:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0105aca:	0f 95 c0             	setne  %al
c0105acd:	0f b6 c0             	movzbl %al,%eax
c0105ad0:	85 c0                	test   %eax,%eax
c0105ad2:	75 2c                	jne    c0105b00 <buddy_check+0xfb>
c0105ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ad7:	83 c0 04             	add    $0x4,%eax
c0105ada:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105ae1:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ae4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105ae7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105aea:	0f a3 10             	bt     %edx,(%eax)
c0105aed:	19 c0                	sbb    %eax,%eax
c0105aef:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0105af2:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0105af6:	0f 95 c0             	setne  %al
c0105af9:	0f b6 c0             	movzbl %al,%eax
c0105afc:	85 c0                	test   %eax,%eax
c0105afe:	74 19                	je     c0105b19 <buddy_check+0x114>
c0105b00:	68 38 7c 10 c0       	push   $0xc0107c38
c0105b05:	68 22 7b 10 c0       	push   $0xc0107b22
c0105b0a:	68 bc 00 00 00       	push   $0xbc
c0105b0f:	68 37 7b 10 c0       	push   $0xc0107b37
c0105b14:	e8 b4 a8 ff ff       	call   c01003cd <__panic>
	assert(!PageProperty(p0) && !PageProperty(p1));
c0105b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b1c:	83 c0 04             	add    $0x4,%eax
c0105b1f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0105b26:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105b29:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b2f:	0f a3 10             	bt     %edx,(%eax)
c0105b32:	19 c0                	sbb    %eax,%eax
c0105b34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105b37:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105b3b:	0f 95 c0             	setne  %al
c0105b3e:	0f b6 c0             	movzbl %al,%eax
c0105b41:	85 c0                	test   %eax,%eax
c0105b43:	75 2c                	jne    c0105b71 <buddy_check+0x16c>
c0105b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b48:	83 c0 04             	add    $0x4,%eax
c0105b4b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105b52:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105b55:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b5b:	0f a3 10             	bt     %edx,(%eax)
c0105b5e:	19 c0                	sbb    %eax,%eax
c0105b60:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
c0105b63:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
c0105b67:	0f 95 c0             	setne  %al
c0105b6a:	0f b6 c0             	movzbl %al,%eax
c0105b6d:	85 c0                	test   %eax,%eax
c0105b6f:	74 19                	je     c0105b8a <buddy_check+0x185>
c0105b71:	68 60 7c 10 c0       	push   $0xc0107c60
c0105b76:	68 22 7b 10 c0       	push   $0xc0107b22
c0105b7b:	68 bd 00 00 00       	push   $0xbd
c0105b80:	68 37 7b 10 c0       	push   $0xc0107b37
c0105b85:	e8 43 a8 ff ff       	call   c01003cd <__panic>

	p2 = alloc_pages(1);
c0105b8a:	83 ec 0c             	sub    $0xc,%esp
c0105b8d:	6a 01                	push   $0x1
c0105b8f:	e8 db d1 ff ff       	call   c0102d6f <alloc_pages>
c0105b94:	83 c4 10             	add    $0x10,%esp
c0105b97:	89 45 d8             	mov    %eax,-0x28(%ebp)
	assert(p2 == p0 + 1);
c0105b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b9d:	83 c0 14             	add    $0x14,%eax
c0105ba0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
c0105ba3:	74 19                	je     c0105bbe <buddy_check+0x1b9>
c0105ba5:	68 87 7c 10 c0       	push   $0xc0107c87
c0105baa:	68 22 7b 10 c0       	push   $0xc0107b22
c0105baf:	68 c0 00 00 00       	push   $0xc0
c0105bb4:	68 37 7b 10 c0       	push   $0xc0107b37
c0105bb9:	e8 0f a8 ff ff       	call   c01003cd <__panic>

	p3 = alloc_pages(2);
c0105bbe:	83 ec 0c             	sub    $0xc,%esp
c0105bc1:	6a 02                	push   $0x2
c0105bc3:	e8 a7 d1 ff ff       	call   c0102d6f <alloc_pages>
c0105bc8:	83 c4 10             	add    $0x10,%esp
c0105bcb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	assert(p3 == p0 + 4);
c0105bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bd1:	83 c0 50             	add    $0x50,%eax
c0105bd4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0105bd7:	74 19                	je     c0105bf2 <buddy_check+0x1ed>
c0105bd9:	68 94 7c 10 c0       	push   $0xc0107c94
c0105bde:	68 22 7b 10 c0       	push   $0xc0107b22
c0105be3:	68 c3 00 00 00       	push   $0xc3
c0105be8:	68 37 7b 10 c0       	push   $0xc0107b37
c0105bed:	e8 db a7 ff ff       	call   c01003cd <__panic>
	assert(!PageProperty(p3) && !PageProperty(p3 + 1) && PageProperty(p3 + 2));
c0105bf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105bf5:	83 c0 04             	add    $0x4,%eax
c0105bf8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0105bff:	89 45 98             	mov    %eax,-0x68(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105c02:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105c05:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105c08:	0f a3 10             	bt     %edx,(%eax)
c0105c0b:	19 c0                	sbb    %eax,%eax
c0105c0d:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return oldbit != 0;
c0105c10:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
c0105c14:	0f 95 c0             	setne  %al
c0105c17:	0f b6 c0             	movzbl %al,%eax
c0105c1a:	85 c0                	test   %eax,%eax
c0105c1c:	75 5e                	jne    c0105c7c <buddy_check+0x277>
c0105c1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105c21:	83 c0 14             	add    $0x14,%eax
c0105c24:	83 c0 04             	add    $0x4,%eax
c0105c27:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105c2e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105c31:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105c34:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105c37:	0f a3 10             	bt     %edx,(%eax)
c0105c3a:	19 c0                	sbb    %eax,%eax
c0105c3c:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105c3f:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105c43:	0f 95 c0             	setne  %al
c0105c46:	0f b6 c0             	movzbl %al,%eax
c0105c49:	85 c0                	test   %eax,%eax
c0105c4b:	75 2f                	jne    c0105c7c <buddy_check+0x277>
c0105c4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105c50:	83 c0 28             	add    $0x28,%eax
c0105c53:	83 c0 04             	add    $0x4,%eax
c0105c56:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0105c5d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105c60:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105c63:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105c66:	0f a3 10             	bt     %edx,(%eax)
c0105c69:	19 c0                	sbb    %eax,%eax
c0105c6b:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
c0105c6e:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
c0105c72:	0f 95 c0             	setne  %al
c0105c75:	0f b6 c0             	movzbl %al,%eax
c0105c78:	85 c0                	test   %eax,%eax
c0105c7a:	75 19                	jne    c0105c95 <buddy_check+0x290>
c0105c7c:	68 a4 7c 10 c0       	push   $0xc0107ca4
c0105c81:	68 22 7b 10 c0       	push   $0xc0107b22
c0105c86:	68 c4 00 00 00       	push   $0xc4
c0105c8b:	68 37 7b 10 c0       	push   $0xc0107b37
c0105c90:	e8 38 a7 ff ff       	call   c01003cd <__panic>

	free_pages(p1, 2);
c0105c95:	83 ec 08             	sub    $0x8,%esp
c0105c98:	6a 02                	push   $0x2
c0105c9a:	ff 75 ec             	pushl  -0x14(%ebp)
c0105c9d:	e8 0b d1 ff ff       	call   c0102dad <free_pages>
c0105ca2:	83 c4 10             	add    $0x10,%esp
	assert(PageProperty(p1) && PageProperty(p1 + 1));
c0105ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ca8:	83 c0 04             	add    $0x4,%eax
c0105cab:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0105cb2:	89 45 80             	mov    %eax,-0x80(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105cb5:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105cb8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105cbb:	0f a3 10             	bt     %edx,(%eax)
c0105cbe:	19 c0                	sbb    %eax,%eax
c0105cc0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    return oldbit != 0;
c0105cc6:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
c0105ccd:	0f 95 c0             	setne  %al
c0105cd0:	0f b6 c0             	movzbl %al,%eax
c0105cd3:	85 c0                	test   %eax,%eax
c0105cd5:	74 3b                	je     c0105d12 <buddy_check+0x30d>
c0105cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cda:	83 c0 14             	add    $0x14,%eax
c0105cdd:	83 c0 04             	add    $0x4,%eax
c0105ce0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105ce7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ced:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0105cf3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105cf6:	0f a3 10             	bt     %edx,(%eax)
c0105cf9:	19 c0                	sbb    %eax,%eax
c0105cfb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return oldbit != 0;
c0105d01:	83 bd 74 ff ff ff 00 	cmpl   $0x0,-0x8c(%ebp)
c0105d08:	0f 95 c0             	setne  %al
c0105d0b:	0f b6 c0             	movzbl %al,%eax
c0105d0e:	85 c0                	test   %eax,%eax
c0105d10:	75 19                	jne    c0105d2b <buddy_check+0x326>
c0105d12:	68 e8 7c 10 c0       	push   $0xc0107ce8
c0105d17:	68 22 7b 10 c0       	push   $0xc0107b22
c0105d1c:	68 c7 00 00 00       	push   $0xc7
c0105d21:	68 37 7b 10 c0       	push   $0xc0107b37
c0105d26:	e8 a2 a6 ff ff       	call   c01003cd <__panic>
	assert(p1->ref == 0);
c0105d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d2e:	8b 00                	mov    (%eax),%eax
c0105d30:	85 c0                	test   %eax,%eax
c0105d32:	74 19                	je     c0105d4d <buddy_check+0x348>
c0105d34:	68 11 7d 10 c0       	push   $0xc0107d11
c0105d39:	68 22 7b 10 c0       	push   $0xc0107b22
c0105d3e:	68 c8 00 00 00       	push   $0xc8
c0105d43:	68 37 7b 10 c0       	push   $0xc0107b37
c0105d48:	e8 80 a6 ff ff       	call   c01003cd <__panic>

	free_pages(p0, 1);
c0105d4d:	83 ec 08             	sub    $0x8,%esp
c0105d50:	6a 01                	push   $0x1
c0105d52:	ff 75 f0             	pushl  -0x10(%ebp)
c0105d55:	e8 53 d0 ff ff       	call   c0102dad <free_pages>
c0105d5a:	83 c4 10             	add    $0x10,%esp
	free_pages(p2, 1);
c0105d5d:	83 ec 08             	sub    $0x8,%esp
c0105d60:	6a 01                	push   $0x1
c0105d62:	ff 75 d8             	pushl  -0x28(%ebp)
c0105d65:	e8 43 d0 ff ff       	call   c0102dad <free_pages>
c0105d6a:	83 c4 10             	add    $0x10,%esp

	p4 = alloc_pages(2);
c0105d6d:	83 ec 0c             	sub    $0xc,%esp
c0105d70:	6a 02                	push   $0x2
c0105d72:	e8 f8 cf ff ff       	call   c0102d6f <alloc_pages>
c0105d77:	83 c4 10             	add    $0x10,%esp
c0105d7a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	assert(p4 == p0);
c0105d7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105d80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105d83:	74 19                	je     c0105d9e <buddy_check+0x399>
c0105d85:	68 1e 7d 10 c0       	push   $0xc0107d1e
c0105d8a:	68 22 7b 10 c0       	push   $0xc0107b22
c0105d8f:	68 ce 00 00 00       	push   $0xce
c0105d94:	68 37 7b 10 c0       	push   $0xc0107b37
c0105d99:	e8 2f a6 ff ff       	call   c01003cd <__panic>
	free_pages(p4, 2);
c0105d9e:	83 ec 08             	sub    $0x8,%esp
c0105da1:	6a 02                	push   $0x2
c0105da3:	ff 75 c0             	pushl  -0x40(%ebp)
c0105da6:	e8 02 d0 ff ff       	call   c0102dad <free_pages>
c0105dab:	83 c4 10             	add    $0x10,%esp
	assert((*(p4 + 1)).ref == 0);
c0105dae:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105db1:	83 c0 14             	add    $0x14,%eax
c0105db4:	8b 00                	mov    (%eax),%eax
c0105db6:	85 c0                	test   %eax,%eax
c0105db8:	74 19                	je     c0105dd3 <buddy_check+0x3ce>
c0105dba:	68 27 7d 10 c0       	push   $0xc0107d27
c0105dbf:	68 22 7b 10 c0       	push   $0xc0107b22
c0105dc4:	68 d0 00 00 00       	push   $0xd0
c0105dc9:	68 37 7b 10 c0       	push   $0xc0107b37
c0105dce:	e8 fa a5 ff ff       	call   c01003cd <__panic>

	assert(nr_free_pages() == all_pages / 2);
c0105dd3:	e8 0a d0 ff ff       	call   c0102de2 <nr_free_pages>
c0105dd8:	89 c1                	mov    %eax,%ecx
c0105dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ddd:	89 c2                	mov    %eax,%edx
c0105ddf:	c1 ea 1f             	shr    $0x1f,%edx
c0105de2:	01 d0                	add    %edx,%eax
c0105de4:	d1 f8                	sar    %eax
c0105de6:	39 c1                	cmp    %eax,%ecx
c0105de8:	74 19                	je     c0105e03 <buddy_check+0x3fe>
c0105dea:	68 3c 7d 10 c0       	push   $0xc0107d3c
c0105def:	68 22 7b 10 c0       	push   $0xc0107b22
c0105df4:	68 d2 00 00 00       	push   $0xd2
c0105df9:	68 37 7b 10 c0       	push   $0xc0107b37
c0105dfe:	e8 ca a5 ff ff       	call   c01003cd <__panic>

	free_pages(p3, 2);
c0105e03:	83 ec 08             	sub    $0x8,%esp
c0105e06:	6a 02                	push   $0x2
c0105e08:	ff 75 d4             	pushl  -0x2c(%ebp)
c0105e0b:	e8 9d cf ff ff       	call   c0102dad <free_pages>
c0105e10:	83 c4 10             	add    $0x10,%esp

	p1 = alloc_pages(33);
c0105e13:	83 ec 0c             	sub    $0xc,%esp
c0105e16:	6a 21                	push   $0x21
c0105e18:	e8 52 cf ff ff       	call   c0102d6f <alloc_pages>
c0105e1d:	83 c4 10             	add    $0x10,%esp
c0105e20:	89 45 ec             	mov    %eax,-0x14(%ebp)
	free_pages(p1, 64);
c0105e23:	83 ec 08             	sub    $0x8,%esp
c0105e26:	6a 40                	push   $0x40
c0105e28:	ff 75 ec             	pushl  -0x14(%ebp)
c0105e2b:	e8 7d cf ff ff       	call   c0102dad <free_pages>
c0105e30:	83 c4 10             	add    $0x10,%esp
}
c0105e33:	90                   	nop
c0105e34:	c9                   	leave  
c0105e35:	c3                   	ret    

c0105e36 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105e36:	55                   	push   %ebp
c0105e37:	89 e5                	mov    %esp,%ebp
c0105e39:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105e3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105e43:	eb 04                	jmp    c0105e49 <strlen+0x13>
        cnt ++;
c0105e45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4c:	8d 50 01             	lea    0x1(%eax),%edx
c0105e4f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105e52:	0f b6 00             	movzbl (%eax),%eax
c0105e55:	84 c0                	test   %al,%al
c0105e57:	75 ec                	jne    c0105e45 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105e5c:	c9                   	leave  
c0105e5d:	c3                   	ret    

c0105e5e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105e5e:	55                   	push   %ebp
c0105e5f:	89 e5                	mov    %esp,%ebp
c0105e61:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105e64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105e6b:	eb 04                	jmp    c0105e71 <strnlen+0x13>
        cnt ++;
c0105e6d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e74:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e77:	73 10                	jae    c0105e89 <strnlen+0x2b>
c0105e79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e7c:	8d 50 01             	lea    0x1(%eax),%edx
c0105e7f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105e82:	0f b6 00             	movzbl (%eax),%eax
c0105e85:	84 c0                	test   %al,%al
c0105e87:	75 e4                	jne    c0105e6d <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105e8c:	c9                   	leave  
c0105e8d:	c3                   	ret    

c0105e8e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105e8e:	55                   	push   %ebp
c0105e8f:	89 e5                	mov    %esp,%ebp
c0105e91:	57                   	push   %edi
c0105e92:	56                   	push   %esi
c0105e93:	83 ec 20             	sub    $0x20,%esp
c0105e96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105ea2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ea8:	89 d1                	mov    %edx,%ecx
c0105eaa:	89 c2                	mov    %eax,%edx
c0105eac:	89 ce                	mov    %ecx,%esi
c0105eae:	89 d7                	mov    %edx,%edi
c0105eb0:	ac                   	lods   %ds:(%esi),%al
c0105eb1:	aa                   	stos   %al,%es:(%edi)
c0105eb2:	84 c0                	test   %al,%al
c0105eb4:	75 fa                	jne    c0105eb0 <strcpy+0x22>
c0105eb6:	89 fa                	mov    %edi,%edx
c0105eb8:	89 f1                	mov    %esi,%ecx
c0105eba:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ebd:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105ec6:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105ec7:	83 c4 20             	add    $0x20,%esp
c0105eca:	5e                   	pop    %esi
c0105ecb:	5f                   	pop    %edi
c0105ecc:	5d                   	pop    %ebp
c0105ecd:	c3                   	ret    

c0105ece <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105ece:	55                   	push   %ebp
c0105ecf:	89 e5                	mov    %esp,%ebp
c0105ed1:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105eda:	eb 21                	jmp    c0105efd <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105edc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105edf:	0f b6 10             	movzbl (%eax),%edx
c0105ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ee5:	88 10                	mov    %dl,(%eax)
c0105ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105eea:	0f b6 00             	movzbl (%eax),%eax
c0105eed:	84 c0                	test   %al,%al
c0105eef:	74 04                	je     c0105ef5 <strncpy+0x27>
            src ++;
c0105ef1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105ef5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ef9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105efd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f01:	75 d9                	jne    c0105edc <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105f06:	c9                   	leave  
c0105f07:	c3                   	ret    

c0105f08 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105f08:	55                   	push   %ebp
c0105f09:	89 e5                	mov    %esp,%ebp
c0105f0b:	57                   	push   %edi
c0105f0c:	56                   	push   %esi
c0105f0d:	83 ec 20             	sub    $0x20,%esp
c0105f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f22:	89 d1                	mov    %edx,%ecx
c0105f24:	89 c2                	mov    %eax,%edx
c0105f26:	89 ce                	mov    %ecx,%esi
c0105f28:	89 d7                	mov    %edx,%edi
c0105f2a:	ac                   	lods   %ds:(%esi),%al
c0105f2b:	ae                   	scas   %es:(%edi),%al
c0105f2c:	75 08                	jne    c0105f36 <strcmp+0x2e>
c0105f2e:	84 c0                	test   %al,%al
c0105f30:	75 f8                	jne    c0105f2a <strcmp+0x22>
c0105f32:	31 c0                	xor    %eax,%eax
c0105f34:	eb 04                	jmp    c0105f3a <strcmp+0x32>
c0105f36:	19 c0                	sbb    %eax,%eax
c0105f38:	0c 01                	or     $0x1,%al
c0105f3a:	89 fa                	mov    %edi,%edx
c0105f3c:	89 f1                	mov    %esi,%ecx
c0105f3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105f41:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105f4a:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105f4b:	83 c4 20             	add    $0x20,%esp
c0105f4e:	5e                   	pop    %esi
c0105f4f:	5f                   	pop    %edi
c0105f50:	5d                   	pop    %ebp
c0105f51:	c3                   	ret    

c0105f52 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105f52:	55                   	push   %ebp
c0105f53:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105f55:	eb 0c                	jmp    c0105f63 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105f57:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105f5b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f5f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f67:	74 1a                	je     c0105f83 <strncmp+0x31>
c0105f69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6c:	0f b6 00             	movzbl (%eax),%eax
c0105f6f:	84 c0                	test   %al,%al
c0105f71:	74 10                	je     c0105f83 <strncmp+0x31>
c0105f73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f76:	0f b6 10             	movzbl (%eax),%edx
c0105f79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f7c:	0f b6 00             	movzbl (%eax),%eax
c0105f7f:	38 c2                	cmp    %al,%dl
c0105f81:	74 d4                	je     c0105f57 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f87:	74 18                	je     c0105fa1 <strncmp+0x4f>
c0105f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8c:	0f b6 00             	movzbl (%eax),%eax
c0105f8f:	0f b6 d0             	movzbl %al,%edx
c0105f92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f95:	0f b6 00             	movzbl (%eax),%eax
c0105f98:	0f b6 c0             	movzbl %al,%eax
c0105f9b:	29 c2                	sub    %eax,%edx
c0105f9d:	89 d0                	mov    %edx,%eax
c0105f9f:	eb 05                	jmp    c0105fa6 <strncmp+0x54>
c0105fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fa6:	5d                   	pop    %ebp
c0105fa7:	c3                   	ret    

c0105fa8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105fa8:	55                   	push   %ebp
c0105fa9:	89 e5                	mov    %esp,%ebp
c0105fab:	83 ec 04             	sub    $0x4,%esp
c0105fae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fb1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105fb4:	eb 14                	jmp    c0105fca <strchr+0x22>
        if (*s == c) {
c0105fb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb9:	0f b6 00             	movzbl (%eax),%eax
c0105fbc:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105fbf:	75 05                	jne    c0105fc6 <strchr+0x1e>
            return (char *)s;
c0105fc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc4:	eb 13                	jmp    c0105fd9 <strchr+0x31>
        }
        s ++;
c0105fc6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fcd:	0f b6 00             	movzbl (%eax),%eax
c0105fd0:	84 c0                	test   %al,%al
c0105fd2:	75 e2                	jne    c0105fb6 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fd9:	c9                   	leave  
c0105fda:	c3                   	ret    

c0105fdb <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105fdb:	55                   	push   %ebp
c0105fdc:	89 e5                	mov    %esp,%ebp
c0105fde:	83 ec 04             	sub    $0x4,%esp
c0105fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fe4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105fe7:	eb 0f                	jmp    c0105ff8 <strfind+0x1d>
        if (*s == c) {
c0105fe9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fec:	0f b6 00             	movzbl (%eax),%eax
c0105fef:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ff2:	74 10                	je     c0106004 <strfind+0x29>
            break;
        }
        s ++;
c0105ff4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ffb:	0f b6 00             	movzbl (%eax),%eax
c0105ffe:	84 c0                	test   %al,%al
c0106000:	75 e7                	jne    c0105fe9 <strfind+0xe>
c0106002:	eb 01                	jmp    c0106005 <strfind+0x2a>
        if (*s == c) {
            break;
c0106004:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0106005:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106008:	c9                   	leave  
c0106009:	c3                   	ret    

c010600a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010600a:	55                   	push   %ebp
c010600b:	89 e5                	mov    %esp,%ebp
c010600d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0106010:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0106017:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010601e:	eb 04                	jmp    c0106024 <strtol+0x1a>
        s ++;
c0106020:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0106024:	8b 45 08             	mov    0x8(%ebp),%eax
c0106027:	0f b6 00             	movzbl (%eax),%eax
c010602a:	3c 20                	cmp    $0x20,%al
c010602c:	74 f2                	je     c0106020 <strtol+0x16>
c010602e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106031:	0f b6 00             	movzbl (%eax),%eax
c0106034:	3c 09                	cmp    $0x9,%al
c0106036:	74 e8                	je     c0106020 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0106038:	8b 45 08             	mov    0x8(%ebp),%eax
c010603b:	0f b6 00             	movzbl (%eax),%eax
c010603e:	3c 2b                	cmp    $0x2b,%al
c0106040:	75 06                	jne    c0106048 <strtol+0x3e>
        s ++;
c0106042:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106046:	eb 15                	jmp    c010605d <strtol+0x53>
    }
    else if (*s == '-') {
c0106048:	8b 45 08             	mov    0x8(%ebp),%eax
c010604b:	0f b6 00             	movzbl (%eax),%eax
c010604e:	3c 2d                	cmp    $0x2d,%al
c0106050:	75 0b                	jne    c010605d <strtol+0x53>
        s ++, neg = 1;
c0106052:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106056:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010605d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106061:	74 06                	je     c0106069 <strtol+0x5f>
c0106063:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0106067:	75 24                	jne    c010608d <strtol+0x83>
c0106069:	8b 45 08             	mov    0x8(%ebp),%eax
c010606c:	0f b6 00             	movzbl (%eax),%eax
c010606f:	3c 30                	cmp    $0x30,%al
c0106071:	75 1a                	jne    c010608d <strtol+0x83>
c0106073:	8b 45 08             	mov    0x8(%ebp),%eax
c0106076:	83 c0 01             	add    $0x1,%eax
c0106079:	0f b6 00             	movzbl (%eax),%eax
c010607c:	3c 78                	cmp    $0x78,%al
c010607e:	75 0d                	jne    c010608d <strtol+0x83>
        s += 2, base = 16;
c0106080:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0106084:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010608b:	eb 2a                	jmp    c01060b7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010608d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106091:	75 17                	jne    c01060aa <strtol+0xa0>
c0106093:	8b 45 08             	mov    0x8(%ebp),%eax
c0106096:	0f b6 00             	movzbl (%eax),%eax
c0106099:	3c 30                	cmp    $0x30,%al
c010609b:	75 0d                	jne    c01060aa <strtol+0xa0>
        s ++, base = 8;
c010609d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01060a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01060a8:	eb 0d                	jmp    c01060b7 <strtol+0xad>
    }
    else if (base == 0) {
c01060aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01060ae:	75 07                	jne    c01060b7 <strtol+0xad>
        base = 10;
c01060b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01060b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ba:	0f b6 00             	movzbl (%eax),%eax
c01060bd:	3c 2f                	cmp    $0x2f,%al
c01060bf:	7e 1b                	jle    c01060dc <strtol+0xd2>
c01060c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01060c4:	0f b6 00             	movzbl (%eax),%eax
c01060c7:	3c 39                	cmp    $0x39,%al
c01060c9:	7f 11                	jg     c01060dc <strtol+0xd2>
            dig = *s - '0';
c01060cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ce:	0f b6 00             	movzbl (%eax),%eax
c01060d1:	0f be c0             	movsbl %al,%eax
c01060d4:	83 e8 30             	sub    $0x30,%eax
c01060d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060da:	eb 48                	jmp    c0106124 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01060dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01060df:	0f b6 00             	movzbl (%eax),%eax
c01060e2:	3c 60                	cmp    $0x60,%al
c01060e4:	7e 1b                	jle    c0106101 <strtol+0xf7>
c01060e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e9:	0f b6 00             	movzbl (%eax),%eax
c01060ec:	3c 7a                	cmp    $0x7a,%al
c01060ee:	7f 11                	jg     c0106101 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01060f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01060f3:	0f b6 00             	movzbl (%eax),%eax
c01060f6:	0f be c0             	movsbl %al,%eax
c01060f9:	83 e8 57             	sub    $0x57,%eax
c01060fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060ff:	eb 23                	jmp    c0106124 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0106101:	8b 45 08             	mov    0x8(%ebp),%eax
c0106104:	0f b6 00             	movzbl (%eax),%eax
c0106107:	3c 40                	cmp    $0x40,%al
c0106109:	7e 3c                	jle    c0106147 <strtol+0x13d>
c010610b:	8b 45 08             	mov    0x8(%ebp),%eax
c010610e:	0f b6 00             	movzbl (%eax),%eax
c0106111:	3c 5a                	cmp    $0x5a,%al
c0106113:	7f 32                	jg     c0106147 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0106115:	8b 45 08             	mov    0x8(%ebp),%eax
c0106118:	0f b6 00             	movzbl (%eax),%eax
c010611b:	0f be c0             	movsbl %al,%eax
c010611e:	83 e8 37             	sub    $0x37,%eax
c0106121:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0106124:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106127:	3b 45 10             	cmp    0x10(%ebp),%eax
c010612a:	7d 1a                	jge    c0106146 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010612c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106130:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106133:	0f af 45 10          	imul   0x10(%ebp),%eax
c0106137:	89 c2                	mov    %eax,%edx
c0106139:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010613c:	01 d0                	add    %edx,%eax
c010613e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0106141:	e9 71 ff ff ff       	jmp    c01060b7 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0106146:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0106147:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010614b:	74 08                	je     c0106155 <strtol+0x14b>
        *endptr = (char *) s;
c010614d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106150:	8b 55 08             	mov    0x8(%ebp),%edx
c0106153:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0106155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106159:	74 07                	je     c0106162 <strtol+0x158>
c010615b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010615e:	f7 d8                	neg    %eax
c0106160:	eb 03                	jmp    c0106165 <strtol+0x15b>
c0106162:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106165:	c9                   	leave  
c0106166:	c3                   	ret    

c0106167 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0106167:	55                   	push   %ebp
c0106168:	89 e5                	mov    %esp,%ebp
c010616a:	57                   	push   %edi
c010616b:	83 ec 24             	sub    $0x24,%esp
c010616e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106171:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106174:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0106178:	8b 55 08             	mov    0x8(%ebp),%edx
c010617b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010617e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0106181:	8b 45 10             	mov    0x10(%ebp),%eax
c0106184:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0106187:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010618a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010618e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0106191:	89 d7                	mov    %edx,%edi
c0106193:	f3 aa                	rep stos %al,%es:(%edi)
c0106195:	89 fa                	mov    %edi,%edx
c0106197:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010619a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010619d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01061a0:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01061a1:	83 c4 24             	add    $0x24,%esp
c01061a4:	5f                   	pop    %edi
c01061a5:	5d                   	pop    %ebp
c01061a6:	c3                   	ret    

c01061a7 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01061a7:	55                   	push   %ebp
c01061a8:	89 e5                	mov    %esp,%ebp
c01061aa:	57                   	push   %edi
c01061ab:	56                   	push   %esi
c01061ac:	53                   	push   %ebx
c01061ad:	83 ec 30             	sub    $0x30,%esp
c01061b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01061b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01061bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01061bf:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01061c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01061c8:	73 42                	jae    c010620c <memmove+0x65>
c01061ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01061d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01061dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061df:	c1 e8 02             	shr    $0x2,%eax
c01061e2:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01061e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061ea:	89 d7                	mov    %edx,%edi
c01061ec:	89 c6                	mov    %eax,%esi
c01061ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01061f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01061f3:	83 e1 03             	and    $0x3,%ecx
c01061f6:	74 02                	je     c01061fa <memmove+0x53>
c01061f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01061fa:	89 f0                	mov    %esi,%eax
c01061fc:	89 fa                	mov    %edi,%edx
c01061fe:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106201:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106204:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0106207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010620a:	eb 36                	jmp    c0106242 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010620c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010620f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106212:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106215:	01 c2                	add    %eax,%edx
c0106217:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010621a:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010621d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106220:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0106223:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106226:	89 c1                	mov    %eax,%ecx
c0106228:	89 d8                	mov    %ebx,%eax
c010622a:	89 d6                	mov    %edx,%esi
c010622c:	89 c7                	mov    %eax,%edi
c010622e:	fd                   	std    
c010622f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106231:	fc                   	cld    
c0106232:	89 f8                	mov    %edi,%eax
c0106234:	89 f2                	mov    %esi,%edx
c0106236:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106239:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010623c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010623f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106242:	83 c4 30             	add    $0x30,%esp
c0106245:	5b                   	pop    %ebx
c0106246:	5e                   	pop    %esi
c0106247:	5f                   	pop    %edi
c0106248:	5d                   	pop    %ebp
c0106249:	c3                   	ret    

c010624a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010624a:	55                   	push   %ebp
c010624b:	89 e5                	mov    %esp,%ebp
c010624d:	57                   	push   %edi
c010624e:	56                   	push   %esi
c010624f:	83 ec 20             	sub    $0x20,%esp
c0106252:	8b 45 08             	mov    0x8(%ebp),%eax
c0106255:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106258:	8b 45 0c             	mov    0xc(%ebp),%eax
c010625b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010625e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106261:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106264:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106267:	c1 e8 02             	shr    $0x2,%eax
c010626a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010626c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010626f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106272:	89 d7                	mov    %edx,%edi
c0106274:	89 c6                	mov    %eax,%esi
c0106276:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106278:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010627b:	83 e1 03             	and    $0x3,%ecx
c010627e:	74 02                	je     c0106282 <memcpy+0x38>
c0106280:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106282:	89 f0                	mov    %esi,%eax
c0106284:	89 fa                	mov    %edi,%edx
c0106286:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106289:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010628c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010628f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0106292:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106293:	83 c4 20             	add    $0x20,%esp
c0106296:	5e                   	pop    %esi
c0106297:	5f                   	pop    %edi
c0106298:	5d                   	pop    %ebp
c0106299:	c3                   	ret    

c010629a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010629a:	55                   	push   %ebp
c010629b:	89 e5                	mov    %esp,%ebp
c010629d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01062a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01062a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01062a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01062ac:	eb 30                	jmp    c01062de <memcmp+0x44>
        if (*s1 != *s2) {
c01062ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01062b1:	0f b6 10             	movzbl (%eax),%edx
c01062b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01062b7:	0f b6 00             	movzbl (%eax),%eax
c01062ba:	38 c2                	cmp    %al,%dl
c01062bc:	74 18                	je     c01062d6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01062be:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01062c1:	0f b6 00             	movzbl (%eax),%eax
c01062c4:	0f b6 d0             	movzbl %al,%edx
c01062c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01062ca:	0f b6 00             	movzbl (%eax),%eax
c01062cd:	0f b6 c0             	movzbl %al,%eax
c01062d0:	29 c2                	sub    %eax,%edx
c01062d2:	89 d0                	mov    %edx,%eax
c01062d4:	eb 1a                	jmp    c01062f0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01062d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01062da:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01062de:	8b 45 10             	mov    0x10(%ebp),%eax
c01062e1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01062e4:	89 55 10             	mov    %edx,0x10(%ebp)
c01062e7:	85 c0                	test   %eax,%eax
c01062e9:	75 c3                	jne    c01062ae <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01062eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01062f0:	c9                   	leave  
c01062f1:	c3                   	ret    

c01062f2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01062f2:	55                   	push   %ebp
c01062f3:	89 e5                	mov    %esp,%ebp
c01062f5:	83 ec 38             	sub    $0x38,%esp
c01062f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01062fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01062fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0106301:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0106304:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106307:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010630a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010630d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0106310:	8b 45 18             	mov    0x18(%ebp),%eax
c0106313:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106316:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106319:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010631c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010631f:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0106322:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106325:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010632c:	74 1c                	je     c010634a <printnum+0x58>
c010632e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106331:	ba 00 00 00 00       	mov    $0x0,%edx
c0106336:	f7 75 e4             	divl   -0x1c(%ebp)
c0106339:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010633c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010633f:	ba 00 00 00 00       	mov    $0x0,%edx
c0106344:	f7 75 e4             	divl   -0x1c(%ebp)
c0106347:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010634a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010634d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106350:	f7 75 e4             	divl   -0x1c(%ebp)
c0106353:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106356:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106359:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010635c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010635f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106362:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0106365:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106368:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010636b:	8b 45 18             	mov    0x18(%ebp),%eax
c010636e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106373:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106376:	77 41                	ja     c01063b9 <printnum+0xc7>
c0106378:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010637b:	72 05                	jb     c0106382 <printnum+0x90>
c010637d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0106380:	77 37                	ja     c01063b9 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0106382:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106385:	83 e8 01             	sub    $0x1,%eax
c0106388:	83 ec 04             	sub    $0x4,%esp
c010638b:	ff 75 20             	pushl  0x20(%ebp)
c010638e:	50                   	push   %eax
c010638f:	ff 75 18             	pushl  0x18(%ebp)
c0106392:	ff 75 ec             	pushl  -0x14(%ebp)
c0106395:	ff 75 e8             	pushl  -0x18(%ebp)
c0106398:	ff 75 0c             	pushl  0xc(%ebp)
c010639b:	ff 75 08             	pushl  0x8(%ebp)
c010639e:	e8 4f ff ff ff       	call   c01062f2 <printnum>
c01063a3:	83 c4 20             	add    $0x20,%esp
c01063a6:	eb 1b                	jmp    c01063c3 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01063a8:	83 ec 08             	sub    $0x8,%esp
c01063ab:	ff 75 0c             	pushl  0xc(%ebp)
c01063ae:	ff 75 20             	pushl  0x20(%ebp)
c01063b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01063b4:	ff d0                	call   *%eax
c01063b6:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01063b9:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01063bd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01063c1:	7f e5                	jg     c01063a8 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01063c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01063c6:	05 0c 7e 10 c0       	add    $0xc0107e0c,%eax
c01063cb:	0f b6 00             	movzbl (%eax),%eax
c01063ce:	0f be c0             	movsbl %al,%eax
c01063d1:	83 ec 08             	sub    $0x8,%esp
c01063d4:	ff 75 0c             	pushl  0xc(%ebp)
c01063d7:	50                   	push   %eax
c01063d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01063db:	ff d0                	call   *%eax
c01063dd:	83 c4 10             	add    $0x10,%esp
}
c01063e0:	90                   	nop
c01063e1:	c9                   	leave  
c01063e2:	c3                   	ret    

c01063e3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01063e3:	55                   	push   %ebp
c01063e4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01063e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01063ea:	7e 14                	jle    c0106400 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01063ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ef:	8b 00                	mov    (%eax),%eax
c01063f1:	8d 48 08             	lea    0x8(%eax),%ecx
c01063f4:	8b 55 08             	mov    0x8(%ebp),%edx
c01063f7:	89 0a                	mov    %ecx,(%edx)
c01063f9:	8b 50 04             	mov    0x4(%eax),%edx
c01063fc:	8b 00                	mov    (%eax),%eax
c01063fe:	eb 30                	jmp    c0106430 <getuint+0x4d>
    }
    else if (lflag) {
c0106400:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106404:	74 16                	je     c010641c <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0106406:	8b 45 08             	mov    0x8(%ebp),%eax
c0106409:	8b 00                	mov    (%eax),%eax
c010640b:	8d 48 04             	lea    0x4(%eax),%ecx
c010640e:	8b 55 08             	mov    0x8(%ebp),%edx
c0106411:	89 0a                	mov    %ecx,(%edx)
c0106413:	8b 00                	mov    (%eax),%eax
c0106415:	ba 00 00 00 00       	mov    $0x0,%edx
c010641a:	eb 14                	jmp    c0106430 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010641c:	8b 45 08             	mov    0x8(%ebp),%eax
c010641f:	8b 00                	mov    (%eax),%eax
c0106421:	8d 48 04             	lea    0x4(%eax),%ecx
c0106424:	8b 55 08             	mov    0x8(%ebp),%edx
c0106427:	89 0a                	mov    %ecx,(%edx)
c0106429:	8b 00                	mov    (%eax),%eax
c010642b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0106430:	5d                   	pop    %ebp
c0106431:	c3                   	ret    

c0106432 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0106432:	55                   	push   %ebp
c0106433:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106435:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106439:	7e 14                	jle    c010644f <getint+0x1d>
        return va_arg(*ap, long long);
c010643b:	8b 45 08             	mov    0x8(%ebp),%eax
c010643e:	8b 00                	mov    (%eax),%eax
c0106440:	8d 48 08             	lea    0x8(%eax),%ecx
c0106443:	8b 55 08             	mov    0x8(%ebp),%edx
c0106446:	89 0a                	mov    %ecx,(%edx)
c0106448:	8b 50 04             	mov    0x4(%eax),%edx
c010644b:	8b 00                	mov    (%eax),%eax
c010644d:	eb 28                	jmp    c0106477 <getint+0x45>
    }
    else if (lflag) {
c010644f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106453:	74 12                	je     c0106467 <getint+0x35>
        return va_arg(*ap, long);
c0106455:	8b 45 08             	mov    0x8(%ebp),%eax
c0106458:	8b 00                	mov    (%eax),%eax
c010645a:	8d 48 04             	lea    0x4(%eax),%ecx
c010645d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106460:	89 0a                	mov    %ecx,(%edx)
c0106462:	8b 00                	mov    (%eax),%eax
c0106464:	99                   	cltd   
c0106465:	eb 10                	jmp    c0106477 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0106467:	8b 45 08             	mov    0x8(%ebp),%eax
c010646a:	8b 00                	mov    (%eax),%eax
c010646c:	8d 48 04             	lea    0x4(%eax),%ecx
c010646f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106472:	89 0a                	mov    %ecx,(%edx)
c0106474:	8b 00                	mov    (%eax),%eax
c0106476:	99                   	cltd   
    }
}
c0106477:	5d                   	pop    %ebp
c0106478:	c3                   	ret    

c0106479 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0106479:	55                   	push   %ebp
c010647a:	89 e5                	mov    %esp,%ebp
c010647c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010647f:	8d 45 14             	lea    0x14(%ebp),%eax
c0106482:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106485:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106488:	50                   	push   %eax
c0106489:	ff 75 10             	pushl  0x10(%ebp)
c010648c:	ff 75 0c             	pushl  0xc(%ebp)
c010648f:	ff 75 08             	pushl  0x8(%ebp)
c0106492:	e8 06 00 00 00       	call   c010649d <vprintfmt>
c0106497:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010649a:	90                   	nop
c010649b:	c9                   	leave  
c010649c:	c3                   	ret    

c010649d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010649d:	55                   	push   %ebp
c010649e:	89 e5                	mov    %esp,%ebp
c01064a0:	56                   	push   %esi
c01064a1:	53                   	push   %ebx
c01064a2:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01064a5:	eb 17                	jmp    c01064be <vprintfmt+0x21>
            if (ch == '\0') {
c01064a7:	85 db                	test   %ebx,%ebx
c01064a9:	0f 84 8e 03 00 00    	je     c010683d <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01064af:	83 ec 08             	sub    $0x8,%esp
c01064b2:	ff 75 0c             	pushl  0xc(%ebp)
c01064b5:	53                   	push   %ebx
c01064b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01064b9:	ff d0                	call   *%eax
c01064bb:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01064be:	8b 45 10             	mov    0x10(%ebp),%eax
c01064c1:	8d 50 01             	lea    0x1(%eax),%edx
c01064c4:	89 55 10             	mov    %edx,0x10(%ebp)
c01064c7:	0f b6 00             	movzbl (%eax),%eax
c01064ca:	0f b6 d8             	movzbl %al,%ebx
c01064cd:	83 fb 25             	cmp    $0x25,%ebx
c01064d0:	75 d5                	jne    c01064a7 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01064d2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01064d6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01064dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01064e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01064ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01064ed:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01064f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01064f3:	8d 50 01             	lea    0x1(%eax),%edx
c01064f6:	89 55 10             	mov    %edx,0x10(%ebp)
c01064f9:	0f b6 00             	movzbl (%eax),%eax
c01064fc:	0f b6 d8             	movzbl %al,%ebx
c01064ff:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106502:	83 f8 55             	cmp    $0x55,%eax
c0106505:	0f 87 05 03 00 00    	ja     c0106810 <vprintfmt+0x373>
c010650b:	8b 04 85 30 7e 10 c0 	mov    -0x3fef81d0(,%eax,4),%eax
c0106512:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106514:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106518:	eb d6                	jmp    c01064f0 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010651a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010651e:	eb d0                	jmp    c01064f0 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106527:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010652a:	89 d0                	mov    %edx,%eax
c010652c:	c1 e0 02             	shl    $0x2,%eax
c010652f:	01 d0                	add    %edx,%eax
c0106531:	01 c0                	add    %eax,%eax
c0106533:	01 d8                	add    %ebx,%eax
c0106535:	83 e8 30             	sub    $0x30,%eax
c0106538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010653b:	8b 45 10             	mov    0x10(%ebp),%eax
c010653e:	0f b6 00             	movzbl (%eax),%eax
c0106541:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106544:	83 fb 2f             	cmp    $0x2f,%ebx
c0106547:	7e 39                	jle    c0106582 <vprintfmt+0xe5>
c0106549:	83 fb 39             	cmp    $0x39,%ebx
c010654c:	7f 34                	jg     c0106582 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010654e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0106552:	eb d3                	jmp    c0106527 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0106554:	8b 45 14             	mov    0x14(%ebp),%eax
c0106557:	8d 50 04             	lea    0x4(%eax),%edx
c010655a:	89 55 14             	mov    %edx,0x14(%ebp)
c010655d:	8b 00                	mov    (%eax),%eax
c010655f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106562:	eb 1f                	jmp    c0106583 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0106564:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106568:	79 86                	jns    c01064f0 <vprintfmt+0x53>
                width = 0;
c010656a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106571:	e9 7a ff ff ff       	jmp    c01064f0 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0106576:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010657d:	e9 6e ff ff ff       	jmp    c01064f0 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0106582:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0106583:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106587:	0f 89 63 ff ff ff    	jns    c01064f0 <vprintfmt+0x53>
                width = precision, precision = -1;
c010658d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106590:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106593:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010659a:	e9 51 ff ff ff       	jmp    c01064f0 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010659f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01065a3:	e9 48 ff ff ff       	jmp    c01064f0 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01065a8:	8b 45 14             	mov    0x14(%ebp),%eax
c01065ab:	8d 50 04             	lea    0x4(%eax),%edx
c01065ae:	89 55 14             	mov    %edx,0x14(%ebp)
c01065b1:	8b 00                	mov    (%eax),%eax
c01065b3:	83 ec 08             	sub    $0x8,%esp
c01065b6:	ff 75 0c             	pushl  0xc(%ebp)
c01065b9:	50                   	push   %eax
c01065ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01065bd:	ff d0                	call   *%eax
c01065bf:	83 c4 10             	add    $0x10,%esp
            break;
c01065c2:	e9 71 02 00 00       	jmp    c0106838 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01065c7:	8b 45 14             	mov    0x14(%ebp),%eax
c01065ca:	8d 50 04             	lea    0x4(%eax),%edx
c01065cd:	89 55 14             	mov    %edx,0x14(%ebp)
c01065d0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01065d2:	85 db                	test   %ebx,%ebx
c01065d4:	79 02                	jns    c01065d8 <vprintfmt+0x13b>
                err = -err;
c01065d6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01065d8:	83 fb 06             	cmp    $0x6,%ebx
c01065db:	7f 0b                	jg     c01065e8 <vprintfmt+0x14b>
c01065dd:	8b 34 9d f0 7d 10 c0 	mov    -0x3fef8210(,%ebx,4),%esi
c01065e4:	85 f6                	test   %esi,%esi
c01065e6:	75 19                	jne    c0106601 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01065e8:	53                   	push   %ebx
c01065e9:	68 1d 7e 10 c0       	push   $0xc0107e1d
c01065ee:	ff 75 0c             	pushl  0xc(%ebp)
c01065f1:	ff 75 08             	pushl  0x8(%ebp)
c01065f4:	e8 80 fe ff ff       	call   c0106479 <printfmt>
c01065f9:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01065fc:	e9 37 02 00 00       	jmp    c0106838 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0106601:	56                   	push   %esi
c0106602:	68 26 7e 10 c0       	push   $0xc0107e26
c0106607:	ff 75 0c             	pushl  0xc(%ebp)
c010660a:	ff 75 08             	pushl  0x8(%ebp)
c010660d:	e8 67 fe ff ff       	call   c0106479 <printfmt>
c0106612:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0106615:	e9 1e 02 00 00       	jmp    c0106838 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010661a:	8b 45 14             	mov    0x14(%ebp),%eax
c010661d:	8d 50 04             	lea    0x4(%eax),%edx
c0106620:	89 55 14             	mov    %edx,0x14(%ebp)
c0106623:	8b 30                	mov    (%eax),%esi
c0106625:	85 f6                	test   %esi,%esi
c0106627:	75 05                	jne    c010662e <vprintfmt+0x191>
                p = "(null)";
c0106629:	be 29 7e 10 c0       	mov    $0xc0107e29,%esi
            }
            if (width > 0 && padc != '-') {
c010662e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106632:	7e 76                	jle    c01066aa <vprintfmt+0x20d>
c0106634:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0106638:	74 70                	je     c01066aa <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010663a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010663d:	83 ec 08             	sub    $0x8,%esp
c0106640:	50                   	push   %eax
c0106641:	56                   	push   %esi
c0106642:	e8 17 f8 ff ff       	call   c0105e5e <strnlen>
c0106647:	83 c4 10             	add    $0x10,%esp
c010664a:	89 c2                	mov    %eax,%edx
c010664c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010664f:	29 d0                	sub    %edx,%eax
c0106651:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106654:	eb 17                	jmp    c010666d <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0106656:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010665a:	83 ec 08             	sub    $0x8,%esp
c010665d:	ff 75 0c             	pushl  0xc(%ebp)
c0106660:	50                   	push   %eax
c0106661:	8b 45 08             	mov    0x8(%ebp),%eax
c0106664:	ff d0                	call   *%eax
c0106666:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106669:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010666d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106671:	7f e3                	jg     c0106656 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106673:	eb 35                	jmp    c01066aa <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106675:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106679:	74 1c                	je     c0106697 <vprintfmt+0x1fa>
c010667b:	83 fb 1f             	cmp    $0x1f,%ebx
c010667e:	7e 05                	jle    c0106685 <vprintfmt+0x1e8>
c0106680:	83 fb 7e             	cmp    $0x7e,%ebx
c0106683:	7e 12                	jle    c0106697 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0106685:	83 ec 08             	sub    $0x8,%esp
c0106688:	ff 75 0c             	pushl  0xc(%ebp)
c010668b:	6a 3f                	push   $0x3f
c010668d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106690:	ff d0                	call   *%eax
c0106692:	83 c4 10             	add    $0x10,%esp
c0106695:	eb 0f                	jmp    c01066a6 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0106697:	83 ec 08             	sub    $0x8,%esp
c010669a:	ff 75 0c             	pushl  0xc(%ebp)
c010669d:	53                   	push   %ebx
c010669e:	8b 45 08             	mov    0x8(%ebp),%eax
c01066a1:	ff d0                	call   *%eax
c01066a3:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01066a6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01066aa:	89 f0                	mov    %esi,%eax
c01066ac:	8d 70 01             	lea    0x1(%eax),%esi
c01066af:	0f b6 00             	movzbl (%eax),%eax
c01066b2:	0f be d8             	movsbl %al,%ebx
c01066b5:	85 db                	test   %ebx,%ebx
c01066b7:	74 26                	je     c01066df <vprintfmt+0x242>
c01066b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01066bd:	78 b6                	js     c0106675 <vprintfmt+0x1d8>
c01066bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01066c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01066c7:	79 ac                	jns    c0106675 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01066c9:	eb 14                	jmp    c01066df <vprintfmt+0x242>
                putch(' ', putdat);
c01066cb:	83 ec 08             	sub    $0x8,%esp
c01066ce:	ff 75 0c             	pushl  0xc(%ebp)
c01066d1:	6a 20                	push   $0x20
c01066d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01066d6:	ff d0                	call   *%eax
c01066d8:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01066db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01066df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01066e3:	7f e6                	jg     c01066cb <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c01066e5:	e9 4e 01 00 00       	jmp    c0106838 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01066ea:	83 ec 08             	sub    $0x8,%esp
c01066ed:	ff 75 e0             	pushl  -0x20(%ebp)
c01066f0:	8d 45 14             	lea    0x14(%ebp),%eax
c01066f3:	50                   	push   %eax
c01066f4:	e8 39 fd ff ff       	call   c0106432 <getint>
c01066f9:	83 c4 10             	add    $0x10,%esp
c01066fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106702:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106705:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106708:	85 d2                	test   %edx,%edx
c010670a:	79 23                	jns    c010672f <vprintfmt+0x292>
                putch('-', putdat);
c010670c:	83 ec 08             	sub    $0x8,%esp
c010670f:	ff 75 0c             	pushl  0xc(%ebp)
c0106712:	6a 2d                	push   $0x2d
c0106714:	8b 45 08             	mov    0x8(%ebp),%eax
c0106717:	ff d0                	call   *%eax
c0106719:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c010671c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010671f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106722:	f7 d8                	neg    %eax
c0106724:	83 d2 00             	adc    $0x0,%edx
c0106727:	f7 da                	neg    %edx
c0106729:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010672c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010672f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106736:	e9 9f 00 00 00       	jmp    c01067da <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010673b:	83 ec 08             	sub    $0x8,%esp
c010673e:	ff 75 e0             	pushl  -0x20(%ebp)
c0106741:	8d 45 14             	lea    0x14(%ebp),%eax
c0106744:	50                   	push   %eax
c0106745:	e8 99 fc ff ff       	call   c01063e3 <getuint>
c010674a:	83 c4 10             	add    $0x10,%esp
c010674d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106750:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106753:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010675a:	eb 7e                	jmp    c01067da <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010675c:	83 ec 08             	sub    $0x8,%esp
c010675f:	ff 75 e0             	pushl  -0x20(%ebp)
c0106762:	8d 45 14             	lea    0x14(%ebp),%eax
c0106765:	50                   	push   %eax
c0106766:	e8 78 fc ff ff       	call   c01063e3 <getuint>
c010676b:	83 c4 10             	add    $0x10,%esp
c010676e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106771:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106774:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010677b:	eb 5d                	jmp    c01067da <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c010677d:	83 ec 08             	sub    $0x8,%esp
c0106780:	ff 75 0c             	pushl  0xc(%ebp)
c0106783:	6a 30                	push   $0x30
c0106785:	8b 45 08             	mov    0x8(%ebp),%eax
c0106788:	ff d0                	call   *%eax
c010678a:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c010678d:	83 ec 08             	sub    $0x8,%esp
c0106790:	ff 75 0c             	pushl  0xc(%ebp)
c0106793:	6a 78                	push   $0x78
c0106795:	8b 45 08             	mov    0x8(%ebp),%eax
c0106798:	ff d0                	call   *%eax
c010679a:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010679d:	8b 45 14             	mov    0x14(%ebp),%eax
c01067a0:	8d 50 04             	lea    0x4(%eax),%edx
c01067a3:	89 55 14             	mov    %edx,0x14(%ebp)
c01067a6:	8b 00                	mov    (%eax),%eax
c01067a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01067ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01067b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01067b9:	eb 1f                	jmp    c01067da <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01067bb:	83 ec 08             	sub    $0x8,%esp
c01067be:	ff 75 e0             	pushl  -0x20(%ebp)
c01067c1:	8d 45 14             	lea    0x14(%ebp),%eax
c01067c4:	50                   	push   %eax
c01067c5:	e8 19 fc ff ff       	call   c01063e3 <getuint>
c01067ca:	83 c4 10             	add    $0x10,%esp
c01067cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01067d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01067d3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01067da:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01067de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067e1:	83 ec 04             	sub    $0x4,%esp
c01067e4:	52                   	push   %edx
c01067e5:	ff 75 e8             	pushl  -0x18(%ebp)
c01067e8:	50                   	push   %eax
c01067e9:	ff 75 f4             	pushl  -0xc(%ebp)
c01067ec:	ff 75 f0             	pushl  -0x10(%ebp)
c01067ef:	ff 75 0c             	pushl  0xc(%ebp)
c01067f2:	ff 75 08             	pushl  0x8(%ebp)
c01067f5:	e8 f8 fa ff ff       	call   c01062f2 <printnum>
c01067fa:	83 c4 20             	add    $0x20,%esp
            break;
c01067fd:	eb 39                	jmp    c0106838 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01067ff:	83 ec 08             	sub    $0x8,%esp
c0106802:	ff 75 0c             	pushl  0xc(%ebp)
c0106805:	53                   	push   %ebx
c0106806:	8b 45 08             	mov    0x8(%ebp),%eax
c0106809:	ff d0                	call   *%eax
c010680b:	83 c4 10             	add    $0x10,%esp
            break;
c010680e:	eb 28                	jmp    c0106838 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106810:	83 ec 08             	sub    $0x8,%esp
c0106813:	ff 75 0c             	pushl  0xc(%ebp)
c0106816:	6a 25                	push   $0x25
c0106818:	8b 45 08             	mov    0x8(%ebp),%eax
c010681b:	ff d0                	call   *%eax
c010681d:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106820:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106824:	eb 04                	jmp    c010682a <vprintfmt+0x38d>
c0106826:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010682a:	8b 45 10             	mov    0x10(%ebp),%eax
c010682d:	83 e8 01             	sub    $0x1,%eax
c0106830:	0f b6 00             	movzbl (%eax),%eax
c0106833:	3c 25                	cmp    $0x25,%al
c0106835:	75 ef                	jne    c0106826 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0106837:	90                   	nop
        }
    }
c0106838:	e9 68 fc ff ff       	jmp    c01064a5 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c010683d:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010683e:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0106841:	5b                   	pop    %ebx
c0106842:	5e                   	pop    %esi
c0106843:	5d                   	pop    %ebp
c0106844:	c3                   	ret    

c0106845 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106845:	55                   	push   %ebp
c0106846:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106848:	8b 45 0c             	mov    0xc(%ebp),%eax
c010684b:	8b 40 08             	mov    0x8(%eax),%eax
c010684e:	8d 50 01             	lea    0x1(%eax),%edx
c0106851:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106854:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106857:	8b 45 0c             	mov    0xc(%ebp),%eax
c010685a:	8b 10                	mov    (%eax),%edx
c010685c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010685f:	8b 40 04             	mov    0x4(%eax),%eax
c0106862:	39 c2                	cmp    %eax,%edx
c0106864:	73 12                	jae    c0106878 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106866:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106869:	8b 00                	mov    (%eax),%eax
c010686b:	8d 48 01             	lea    0x1(%eax),%ecx
c010686e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106871:	89 0a                	mov    %ecx,(%edx)
c0106873:	8b 55 08             	mov    0x8(%ebp),%edx
c0106876:	88 10                	mov    %dl,(%eax)
    }
}
c0106878:	90                   	nop
c0106879:	5d                   	pop    %ebp
c010687a:	c3                   	ret    

c010687b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010687b:	55                   	push   %ebp
c010687c:	89 e5                	mov    %esp,%ebp
c010687e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106881:	8d 45 14             	lea    0x14(%ebp),%eax
c0106884:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010688a:	50                   	push   %eax
c010688b:	ff 75 10             	pushl  0x10(%ebp)
c010688e:	ff 75 0c             	pushl  0xc(%ebp)
c0106891:	ff 75 08             	pushl  0x8(%ebp)
c0106894:	e8 0b 00 00 00       	call   c01068a4 <vsnprintf>
c0106899:	83 c4 10             	add    $0x10,%esp
c010689c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010689f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068a2:	c9                   	leave  
c01068a3:	c3                   	ret    

c01068a4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01068a4:	55                   	push   %ebp
c01068a5:	89 e5                	mov    %esp,%ebp
c01068a7:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01068aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01068ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01068b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01068b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01068b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01068b9:	01 d0                	add    %edx,%eax
c01068bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01068be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01068c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01068c9:	74 0a                	je     c01068d5 <vsnprintf+0x31>
c01068cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068d1:	39 c2                	cmp    %eax,%edx
c01068d3:	76 07                	jbe    c01068dc <vsnprintf+0x38>
        return -E_INVAL;
c01068d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01068da:	eb 20                	jmp    c01068fc <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01068dc:	ff 75 14             	pushl  0x14(%ebp)
c01068df:	ff 75 10             	pushl  0x10(%ebp)
c01068e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01068e5:	50                   	push   %eax
c01068e6:	68 45 68 10 c0       	push   $0xc0106845
c01068eb:	e8 ad fb ff ff       	call   c010649d <vprintfmt>
c01068f0:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c01068f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068f6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01068f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068fc:	c9                   	leave  
c01068fd:	c3                   	ret    
