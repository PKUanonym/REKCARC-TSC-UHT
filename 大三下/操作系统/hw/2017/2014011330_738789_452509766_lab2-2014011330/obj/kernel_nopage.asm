
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 90 11 40 	lgdtl  0x40119018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 74 a9 11 00       	mov    $0x11a974,%edx
  100035:	b8 36 9a 11 00       	mov    $0x119a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 9a 11 00       	push   $0x119a36
  100049:	e8 19 61 00 00       	call   106167 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 55 15 00 00       	call   1015ab <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 00 69 10 00 	movl   $0x106900,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 1c 69 10 00       	push   $0x10691c
  100068:	e8 fa 01 00 00       	call   100267 <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 7c 08 00 00       	call   1008f1 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 24 33 00 00       	call   1033a3 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 99 16 00 00       	call   10171d <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 1b 18 00 00       	call   1018a4 <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 c4 0c 00 00       	call   100d52 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 c7 17 00 00       	call   10185a <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100093:	eb fe                	jmp    100093 <kern_init+0x69>

00100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10009b:	83 ec 04             	sub    $0x4,%esp
  10009e:	6a 00                	push   $0x0
  1000a0:	6a 00                	push   $0x0
  1000a2:	6a 00                	push   $0x0
  1000a4:	e8 97 0c 00 00       	call   100d40 <mon_backtrace>
  1000a9:	83 c4 10             	add    $0x10,%esp
}
  1000ac:	90                   	nop
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	53                   	push   %ebx
  1000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c2:	51                   	push   %ecx
  1000c3:	52                   	push   %edx
  1000c4:	53                   	push   %ebx
  1000c5:	50                   	push   %eax
  1000c6:	e8 ca ff ff ff       	call   100095 <grade_backtrace2>
  1000cb:	83 c4 10             	add    $0x10,%esp
}
  1000ce:	90                   	nop
  1000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	83 ec 08             	sub    $0x8,%esp
  1000dd:	ff 75 10             	pushl  0x10(%ebp)
  1000e0:	ff 75 08             	pushl  0x8(%ebp)
  1000e3:	e8 c7 ff ff ff       	call   1000af <grade_backtrace1>
  1000e8:	83 c4 10             	add    $0x10,%esp
}
  1000eb:	90                   	nop
  1000ec:	c9                   	leave  
  1000ed:	c3                   	ret    

001000ee <grade_backtrace>:

void
grade_backtrace(void) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000f9:	83 ec 04             	sub    $0x4,%esp
  1000fc:	68 00 00 ff ff       	push   $0xffff0000
  100101:	50                   	push   %eax
  100102:	6a 00                	push   $0x0
  100104:	e8 cb ff ff ff       	call   1000d4 <grade_backtrace0>
  100109:	83 c4 10             	add    $0x10,%esp
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100125:	0f b7 c0             	movzwl %ax,%eax
  100128:	83 e0 03             	and    $0x3,%eax
  10012b:	89 c2                	mov    %eax,%edx
  10012d:	a1 40 9a 11 00       	mov    0x119a40,%eax
  100132:	83 ec 04             	sub    $0x4,%esp
  100135:	52                   	push   %edx
  100136:	50                   	push   %eax
  100137:	68 21 69 10 00       	push   $0x106921
  10013c:	e8 26 01 00 00       	call   100267 <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 40 9a 11 00       	mov    0x119a40,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 2f 69 10 00       	push   $0x10692f
  10015a:	e8 08 01 00 00       	call   100267 <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 40 9a 11 00       	mov    0x119a40,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 3d 69 10 00       	push   $0x10693d
  100178:	e8 ea 00 00 00       	call   100267 <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 40 9a 11 00       	mov    0x119a40,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 4b 69 10 00       	push   $0x10694b
  100196:	e8 cc 00 00 00       	call   100267 <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 40 9a 11 00       	mov    0x119a40,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 59 69 10 00       	push   $0x106959
  1001b4:	e8 ae 00 00 00       	call   100267 <cprintf>
  1001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001bc:	a1 40 9a 11 00       	mov    0x119a40,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 40 9a 11 00       	mov    %eax,0x119a40
}
  1001c9:	90                   	nop
  1001ca:	c9                   	leave  
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cf:	90                   	nop
  1001d0:	5d                   	pop    %ebp
  1001d1:	c3                   	ret    

001001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d2:	55                   	push   %ebp
  1001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d5:	90                   	nop
  1001d6:	5d                   	pop    %ebp
  1001d7:	c3                   	ret    

001001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d8:	55                   	push   %ebp
  1001d9:	89 e5                	mov    %esp,%ebp
  1001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001de:	e8 2c ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 68 69 10 00       	push   $0x106968
  1001eb:	e8 77 00 00 00       	call   100267 <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f3:	e8 d4 ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f8:	e8 12 ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001fd:	83 ec 0c             	sub    $0xc,%esp
  100200:	68 88 69 10 00       	push   $0x106988
  100205:	e8 5d 00 00 00       	call   100267 <cprintf>
  10020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10020d:	e8 c0 ff ff ff       	call   1001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 f8 fe ff ff       	call   10010f <lab1_print_cur_status>
}
  100217:	90                   	nop
  100218:	c9                   	leave  
  100219:	c3                   	ret    

0010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
  10021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100220:	83 ec 0c             	sub    $0xc,%esp
  100223:	ff 75 08             	pushl  0x8(%ebp)
  100226:	e8 b1 13 00 00       	call   1015dc <cons_putc>
  10022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100231:	8b 00                	mov    (%eax),%eax
  100233:	8d 50 01             	lea    0x1(%eax),%edx
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 10                	mov    %edx,(%eax)
}
  10023b:	90                   	nop
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10024b:	ff 75 0c             	pushl  0xc(%ebp)
  10024e:	ff 75 08             	pushl  0x8(%ebp)
  100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100254:	50                   	push   %eax
  100255:	68 1a 02 10 00       	push   $0x10021a
  10025a:	e8 3e 62 00 00       	call   10649d <vprintfmt>
  10025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100265:	c9                   	leave  
  100266:	c3                   	ret    

00100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100267:	55                   	push   %ebp
  100268:	89 e5                	mov    %esp,%ebp
  10026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10026d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100276:	83 ec 08             	sub    $0x8,%esp
  100279:	50                   	push   %eax
  10027a:	ff 75 08             	pushl  0x8(%ebp)
  10027d:	e8 bc ff ff ff       	call   10023e <vcprintf>
  100282:	83 c4 10             	add    $0x10,%esp
  100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028b:	c9                   	leave  
  10028c:	c3                   	ret    

0010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10028d:	55                   	push   %ebp
  10028e:	89 e5                	mov    %esp,%ebp
  100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100293:	83 ec 0c             	sub    $0xc,%esp
  100296:	ff 75 08             	pushl  0x8(%ebp)
  100299:	e8 3e 13 00 00       	call   1015dc <cons_putc>
  10029e:	83 c4 10             	add    $0x10,%esp
}
  1002a1:	90                   	nop
  1002a2:	c9                   	leave  
  1002a3:	c3                   	ret    

001002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a4:	55                   	push   %ebp
  1002a5:	89 e5                	mov    %esp,%ebp
  1002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b1:	eb 14                	jmp    1002c7 <cputs+0x23>
        cputch(c, &cnt);
  1002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b7:	83 ec 08             	sub    $0x8,%esp
  1002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bd:	52                   	push   %edx
  1002be:	50                   	push   %eax
  1002bf:	e8 56 ff ff ff       	call   10021a <cputch>
  1002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ca:	8d 50 01             	lea    0x1(%eax),%edx
  1002cd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d0:	0f b6 00             	movzbl (%eax),%eax
  1002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002da:	75 d7                	jne    1002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002dc:	83 ec 08             	sub    $0x8,%esp
  1002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e2:	50                   	push   %eax
  1002e3:	6a 0a                	push   $0xa
  1002e5:	e8 30 ff ff ff       	call   10021a <cputch>
  1002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f0:	c9                   	leave  
  1002f1:	c3                   	ret    

001002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f2:	55                   	push   %ebp
  1002f3:	89 e5                	mov    %esp,%ebp
  1002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002f8:	e8 28 13 00 00       	call   101625 <cons_getc>
  1002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100304:	74 f2                	je     1002f8 <getchar+0x6>
        /* do nothing */;
    return c;
  100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100315:	74 13                	je     10032a <readline+0x1f>
        cprintf("%s", prompt);
  100317:	83 ec 08             	sub    $0x8,%esp
  10031a:	ff 75 08             	pushl  0x8(%ebp)
  10031d:	68 a7 69 10 00       	push   $0x1069a7
  100322:	e8 40 ff ff ff       	call   100267 <cprintf>
  100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100331:	e8 bc ff ff ff       	call   1002f2 <getchar>
  100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10033d:	79 0a                	jns    100349 <readline+0x3e>
            return NULL;
  10033f:	b8 00 00 00 00       	mov    $0x0,%eax
  100344:	e9 82 00 00 00       	jmp    1003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 2b                	jle    10037a <readline+0x6f>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 22                	jg     10037a <readline+0x6f>
            cputchar(c);
  100358:	83 ec 0c             	sub    $0xc,%esp
  10035b:	ff 75 f0             	pushl  -0x10(%ebp)
  10035e:	e8 2a ff ff ff       	call   10028d <cputchar>
  100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100369:	8d 50 01             	lea    0x1(%eax),%edx
  10036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100372:	88 90 60 9a 11 00    	mov    %dl,0x119a60(%eax)
  100378:	eb 4c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037e:	75 1a                	jne    10039a <readline+0x8f>
  100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100384:	7e 14                	jle    10039a <readline+0x8f>
            cputchar(c);
  100386:	83 ec 0c             	sub    $0xc,%esp
  100389:	ff 75 f0             	pushl  -0x10(%ebp)
  10038c:	e8 fc fe ff ff       	call   10028d <cputchar>
  100391:	83 c4 10             	add    $0x10,%esp
            i --;
  100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100398:	eb 2c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10039e:	74 06                	je     1003a6 <readline+0x9b>
  1003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a4:	75 8b                	jne    100331 <readline+0x26>
            cputchar(c);
  1003a6:	83 ec 0c             	sub    $0xc,%esp
  1003a9:	ff 75 f0             	pushl  -0x10(%ebp)
  1003ac:	e8 dc fe ff ff       	call   10028d <cputchar>
  1003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b7:	05 60 9a 11 00       	add    $0x119a60,%eax
  1003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003bf:	b8 60 9a 11 00       	mov    $0x119a60,%eax
  1003c4:	eb 05                	jmp    1003cb <readline+0xc0>
        }
    }
  1003c6:	e9 66 ff ff ff       	jmp    100331 <readline+0x26>
}
  1003cb:	c9                   	leave  
  1003cc:	c3                   	ret    

001003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003cd:	55                   	push   %ebp
  1003ce:	89 e5                	mov    %esp,%ebp
  1003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d3:	a1 60 9e 11 00       	mov    0x119e60,%eax
  1003d8:	85 c0                	test   %eax,%eax
  1003da:	75 4a                	jne    100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003dc:	c7 05 60 9e 11 00 01 	movl   $0x1,0x119e60
  1003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ec:	83 ec 04             	sub    $0x4,%esp
  1003ef:	ff 75 0c             	pushl  0xc(%ebp)
  1003f2:	ff 75 08             	pushl  0x8(%ebp)
  1003f5:	68 aa 69 10 00       	push   $0x1069aa
  1003fa:	e8 68 fe ff ff       	call   100267 <cprintf>
  1003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100405:	83 ec 08             	sub    $0x8,%esp
  100408:	50                   	push   %eax
  100409:	ff 75 10             	pushl  0x10(%ebp)
  10040c:	e8 2d fe ff ff       	call   10023e <vcprintf>
  100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100414:	83 ec 0c             	sub    $0xc,%esp
  100417:	68 c6 69 10 00       	push   $0x1069c6
  10041c:	e8 46 fe ff ff       	call   100267 <cprintf>
  100421:	83 c4 10             	add    $0x10,%esp
  100424:	eb 01                	jmp    100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100427:	e8 35 14 00 00       	call   101861 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10042c:	83 ec 0c             	sub    $0xc,%esp
  10042f:	6a 00                	push   $0x0
  100431:	e8 30 08 00 00       	call   100c66 <kmonitor>
  100436:	83 c4 10             	add    $0x10,%esp
    }
  100439:	eb f1                	jmp    10042c <__panic+0x5f>

0010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10043b:	55                   	push   %ebp
  10043c:	89 e5                	mov    %esp,%ebp
  10043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100441:	8d 45 14             	lea    0x14(%ebp),%eax
  100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100447:	83 ec 04             	sub    $0x4,%esp
  10044a:	ff 75 0c             	pushl  0xc(%ebp)
  10044d:	ff 75 08             	pushl  0x8(%ebp)
  100450:	68 c8 69 10 00       	push   $0x1069c8
  100455:	e8 0d fe ff ff       	call   100267 <cprintf>
  10045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100460:	83 ec 08             	sub    $0x8,%esp
  100463:	50                   	push   %eax
  100464:	ff 75 10             	pushl  0x10(%ebp)
  100467:	e8 d2 fd ff ff       	call   10023e <vcprintf>
  10046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10046f:	83 ec 0c             	sub    $0xc,%esp
  100472:	68 c6 69 10 00       	push   $0x1069c6
  100477:	e8 eb fd ff ff       	call   100267 <cprintf>
  10047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10047f:	90                   	nop
  100480:	c9                   	leave  
  100481:	c3                   	ret    

00100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100482:	55                   	push   %ebp
  100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100485:	a1 60 9e 11 00       	mov    0x119e60,%eax
}
  10048a:	5d                   	pop    %ebp
  10048b:	c3                   	ret    

0010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10048c:	55                   	push   %ebp
  10048d:	89 e5                	mov    %esp,%ebp
  10048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	8b 00                	mov    (%eax),%eax
  100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049a:	8b 45 10             	mov    0x10(%ebp),%eax
  10049d:	8b 00                	mov    (%eax),%eax
  10049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004a9:	e9 d2 00 00 00       	jmp    100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	89 c2                	mov    %eax,%edx
  1004b8:	c1 ea 1f             	shr    $0x1f,%edx
  1004bb:	01 d0                	add    %edx,%eax
  1004bd:	d1 f8                	sar    %eax
  1004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c8:	eb 04                	jmp    1004ce <stab_binsearch+0x42>
            m --;
  1004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d4:	7c 1f                	jl     1004f5 <stab_binsearch+0x69>
  1004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d9:	89 d0                	mov    %edx,%eax
  1004db:	01 c0                	add    %eax,%eax
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	c1 e0 02             	shl    $0x2,%eax
  1004e2:	89 c2                	mov    %eax,%edx
  1004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004ed:	0f b6 c0             	movzbl %al,%eax
  1004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f3:	75 d5                	jne    1004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fb:	7d 0b                	jge    100508 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100500:	83 c0 01             	add    $0x1,%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100506:	eb 78                	jmp    100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100512:	89 d0                	mov    %edx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	01 d0                	add    %edx,%eax
  100518:	c1 e0 02             	shl    $0x2,%eax
  10051b:	89 c2                	mov    %eax,%edx
  10051d:	8b 45 08             	mov    0x8(%ebp),%eax
  100520:	01 d0                	add    %edx,%eax
  100522:	8b 40 08             	mov    0x8(%eax),%eax
  100525:	3b 45 18             	cmp    0x18(%ebp),%eax
  100528:	73 13                	jae    10053d <stab_binsearch+0xb1>
            *region_left = m;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100535:	83 c0 01             	add    $0x1,%eax
  100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053b:	eb 43                	jmp    100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100540:	89 d0                	mov    %edx,%eax
  100542:	01 c0                	add    %eax,%eax
  100544:	01 d0                	add    %edx,%eax
  100546:	c1 e0 02             	shl    $0x2,%eax
  100549:	89 c2                	mov    %eax,%edx
  10054b:	8b 45 08             	mov    0x8(%ebp),%eax
  10054e:	01 d0                	add    %edx,%eax
  100550:	8b 40 08             	mov    0x8(%eax),%eax
  100553:	3b 45 18             	cmp    0x18(%ebp),%eax
  100556:	76 16                	jbe    10056e <stab_binsearch+0xe2>
            *region_right = m - 1;
  100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055e:	8b 45 10             	mov    0x10(%ebp),%eax
  100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100566:	83 e8 01             	sub    $0x1,%eax
  100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056c:	eb 12                	jmp    100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100574:	89 10                	mov    %edx,(%eax)
            l = m;
  100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100586:	0f 8e 22 ff ff ff    	jle    1004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100590:	75 0f                	jne    1005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	8b 00                	mov    (%eax),%eax
  100597:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059a:	8b 45 10             	mov    0x10(%ebp),%eax
  10059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059f:	eb 3f                	jmp    1005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a4:	8b 00                	mov    (%eax),%eax
  1005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a9:	eb 04                	jmp    1005af <stab_binsearch+0x123>
  1005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b2:	8b 00                	mov    (%eax),%eax
  1005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005b7:	7d 1f                	jge    1005d8 <stab_binsearch+0x14c>
  1005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005bc:	89 d0                	mov    %edx,%eax
  1005be:	01 c0                	add    %eax,%eax
  1005c0:	01 d0                	add    %edx,%eax
  1005c2:	c1 e0 02             	shl    $0x2,%eax
  1005c5:	89 c2                	mov    %eax,%edx
  1005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ca:	01 d0                	add    %edx,%eax
  1005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d0:	0f b6 c0             	movzbl %al,%eax
  1005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005d6:	75 d3                	jne    1005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005de:	89 10                	mov    %edx,(%eax)
    }
}
  1005e0:	90                   	nop
  1005e1:	c9                   	leave  
  1005e2:	c3                   	ret    

001005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e3:	55                   	push   %ebp
  1005e4:	89 e5                	mov    %esp,%ebp
  1005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 00 e8 69 10 00    	movl   $0x1069e8,(%eax)
    info->eip_line = 0;
  1005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ff:	c7 40 08 e8 69 10 00 	movl   $0x1069e8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100606:	8b 45 0c             	mov    0xc(%ebp),%eax
  100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	8b 55 08             	mov    0x8(%ebp),%edx
  100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100619:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100623:	c7 45 f4 88 7f 10 00 	movl   $0x107f88,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062a:	c7 45 f0 4c 42 11 00 	movl   $0x11424c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100631:	c7 45 ec 4d 42 11 00 	movl   $0x11424d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100638:	c7 45 e8 a9 6f 11 00 	movl   $0x116fa9,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100645:	76 0d                	jbe    100654 <debuginfo_eip+0x71>
  100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064a:	83 e8 01             	sub    $0x1,%eax
  10064d:	0f b6 00             	movzbl (%eax),%eax
  100650:	84 c0                	test   %al,%al
  100652:	74 0a                	je     10065e <debuginfo_eip+0x7b>
        return -1;
  100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100659:	e9 91 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066b:	29 c2                	sub    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	c1 f8 02             	sar    $0x2,%eax
  100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100678:	83 e8 01             	sub    $0x1,%eax
  10067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10067e:	ff 75 08             	pushl  0x8(%ebp)
  100681:	6a 64                	push   $0x64
  100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100686:	50                   	push   %eax
  100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068a:	50                   	push   %eax
  10068b:	ff 75 f4             	pushl  -0xc(%ebp)
  10068e:	e8 f9 fd ff ff       	call   10048c <stab_binsearch>
  100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100699:	85 c0                	test   %eax,%eax
  10069b:	75 0a                	jne    1006a7 <debuginfo_eip+0xc4>
        return -1;
  10069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a2:	e9 48 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b3:	ff 75 08             	pushl  0x8(%ebp)
  1006b6:	6a 24                	push   $0x24
  1006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bb:	50                   	push   %eax
  1006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006bf:	50                   	push   %eax
  1006c0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c3:	e8 c4 fd ff ff       	call   10048c <stab_binsearch>
  1006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d1:	39 c2                	cmp    %eax,%edx
  1006d3:	7f 7c                	jg     100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d8:	89 c2                	mov    %eax,%edx
  1006da:	89 d0                	mov    %edx,%eax
  1006dc:	01 c0                	add    %eax,%eax
  1006de:	01 d0                	add    %edx,%eax
  1006e0:	c1 e0 02             	shl    $0x2,%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e8:	01 d0                	add    %edx,%eax
  1006ea:	8b 00                	mov    (%eax),%eax
  1006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f2:	29 d1                	sub    %edx,%ecx
  1006f4:	89 ca                	mov    %ecx,%edx
  1006f6:	39 d0                	cmp    %edx,%eax
  1006f8:	73 22                	jae    10071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006fd:	89 c2                	mov    %eax,%edx
  1006ff:	89 d0                	mov    %edx,%eax
  100701:	01 c0                	add    %eax,%eax
  100703:	01 d0                	add    %edx,%eax
  100705:	c1 e0 02             	shl    $0x2,%eax
  100708:	89 c2                	mov    %eax,%edx
  10070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	8b 10                	mov    (%eax),%edx
  100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100714:	01 c2                	add    %eax,%edx
  100716:	8b 45 0c             	mov    0xc(%ebp),%eax
  100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071f:	89 c2                	mov    %eax,%edx
  100721:	89 d0                	mov    %edx,%eax
  100723:	01 c0                	add    %eax,%eax
  100725:	01 d0                	add    %edx,%eax
  100727:	c1 e0 02             	shl    $0x2,%eax
  10072a:	89 c2                	mov    %eax,%edx
  10072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072f:	01 d0                	add    %edx,%eax
  100731:	8b 50 08             	mov    0x8(%eax),%edx
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073d:	8b 40 10             	mov    0x10(%eax),%eax
  100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10074f:	eb 15                	jmp    100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100751:	8b 45 0c             	mov    0xc(%ebp),%eax
  100754:	8b 55 08             	mov    0x8(%ebp),%edx
  100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	8b 40 08             	mov    0x8(%eax),%eax
  10076c:	83 ec 08             	sub    $0x8,%esp
  10076f:	6a 3a                	push   $0x3a
  100771:	50                   	push   %eax
  100772:	e8 64 58 00 00       	call   105fdb <strfind>
  100777:	83 c4 10             	add    $0x10,%esp
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077f:	8b 40 08             	mov    0x8(%eax),%eax
  100782:	29 c2                	sub    %eax,%edx
  100784:	8b 45 0c             	mov    0xc(%ebp),%eax
  100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078a:	83 ec 0c             	sub    $0xc,%esp
  10078d:	ff 75 08             	pushl  0x8(%ebp)
  100790:	6a 44                	push   $0x44
  100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100795:	50                   	push   %eax
  100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100799:	50                   	push   %eax
  10079a:	ff 75 f4             	pushl  -0xc(%ebp)
  10079d:	e8 ea fc ff ff       	call   10048c <stab_binsearch>
  1007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ab:	39 c2                	cmp    %eax,%edx
  1007ad:	7f 24                	jg     1007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c8:	0f b7 d0             	movzwl %ax,%edx
  1007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d1:	eb 13                	jmp    1007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d8:	e9 12 01 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e0:	83 e8 01             	sub    $0x1,%eax
  1007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ec:	39 c2                	cmp    %eax,%edx
  1007ee:	7c 56                	jl     100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	89 d0                	mov    %edx,%eax
  1007f7:	01 c0                	add    %eax,%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	c1 e0 02             	shl    $0x2,%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100803:	01 d0                	add    %edx,%eax
  100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100809:	3c 84                	cmp    $0x84,%al
  10080b:	74 39                	je     100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100826:	3c 64                	cmp    $0x64,%al
  100828:	75 b3                	jne    1007dd <debuginfo_eip+0x1fa>
  10082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082d:	89 c2                	mov    %eax,%edx
  10082f:	89 d0                	mov    %edx,%eax
  100831:	01 c0                	add    %eax,%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	c1 e0 02             	shl    $0x2,%eax
  100838:	89 c2                	mov    %eax,%edx
  10083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	8b 40 08             	mov    0x8(%eax),%eax
  100842:	85 c0                	test   %eax,%eax
  100844:	74 97                	je     1007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084c:	39 c2                	cmp    %eax,%edx
  10084e:	7c 46                	jl     100896 <debuginfo_eip+0x2b3>
  100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100853:	89 c2                	mov    %eax,%edx
  100855:	89 d0                	mov    %edx,%eax
  100857:	01 c0                	add    %eax,%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	c1 e0 02             	shl    $0x2,%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100863:	01 d0                	add    %edx,%eax
  100865:	8b 00                	mov    (%eax),%eax
  100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10086d:	29 d1                	sub    %edx,%ecx
  10086f:	89 ca                	mov    %ecx,%edx
  100871:	39 d0                	cmp    %edx,%eax
  100873:	73 21                	jae    100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 10                	mov    (%eax),%edx
  10088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088f:	01 c2                	add    %eax,%edx
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10089c:	39 c2                	cmp    %eax,%edx
  10089e:	7d 4a                	jge    1008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008a9:	eb 18                	jmp    1008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ae:	8b 40 14             	mov    0x14(%eax),%eax
  1008b1:	8d 50 01             	lea    0x1(%eax),%edx
  1008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008bd:	83 c0 01             	add    $0x1,%eax
  1008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008c9:	39 c2                	cmp    %eax,%edx
  1008cb:	7d 1d                	jge    1008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	89 c2                	mov    %eax,%edx
  1008d2:	89 d0                	mov    %edx,%eax
  1008d4:	01 c0                	add    %eax,%eax
  1008d6:	01 d0                	add    %edx,%eax
  1008d8:	c1 e0 02             	shl    $0x2,%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e0:	01 d0                	add    %edx,%eax
  1008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e6:	3c a0                	cmp    $0xa0,%al
  1008e8:	74 c1                	je     1008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ef:	c9                   	leave  
  1008f0:	c3                   	ret    

001008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f1:	55                   	push   %ebp
  1008f2:	89 e5                	mov    %esp,%ebp
  1008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f7:	83 ec 0c             	sub    $0xc,%esp
  1008fa:	68 f2 69 10 00       	push   $0x1069f2
  1008ff:	e8 63 f9 ff ff       	call   100267 <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 2a 00 10 00       	push   $0x10002a
  10090f:	68 0b 6a 10 00       	push   $0x106a0b
  100914:	e8 4e f9 ff ff       	call   100267 <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 fe 68 10 00       	push   $0x1068fe
  100924:	68 23 6a 10 00       	push   $0x106a23
  100929:	e8 39 f9 ff ff       	call   100267 <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100931:	83 ec 08             	sub    $0x8,%esp
  100934:	68 36 9a 11 00       	push   $0x119a36
  100939:	68 3b 6a 10 00       	push   $0x106a3b
  10093e:	e8 24 f9 ff ff       	call   100267 <cprintf>
  100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100946:	83 ec 08             	sub    $0x8,%esp
  100949:	68 74 a9 11 00       	push   $0x11a974
  10094e:	68 53 6a 10 00       	push   $0x106a53
  100953:	e8 0f f9 ff ff       	call   100267 <cprintf>
  100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10095b:	b8 74 a9 11 00       	mov    $0x11a974,%eax
  100960:	05 ff 03 00 00       	add    $0x3ff,%eax
  100965:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10096a:	29 d0                	sub    %edx,%eax
  10096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100972:	85 c0                	test   %eax,%eax
  100974:	0f 48 c2             	cmovs  %edx,%eax
  100977:	c1 f8 0a             	sar    $0xa,%eax
  10097a:	83 ec 08             	sub    $0x8,%esp
  10097d:	50                   	push   %eax
  10097e:	68 6c 6a 10 00       	push   $0x106a6c
  100983:	e8 df f8 ff ff       	call   100267 <cprintf>
  100988:	83 c4 10             	add    $0x10,%esp
}
  10098b:	90                   	nop
  10098c:	c9                   	leave  
  10098d:	c3                   	ret    

0010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10098e:	55                   	push   %ebp
  10098f:	89 e5                	mov    %esp,%ebp
  100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100997:	83 ec 08             	sub    $0x8,%esp
  10099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10099d:	50                   	push   %eax
  10099e:	ff 75 08             	pushl  0x8(%ebp)
  1009a1:	e8 3d fc ff ff       	call   1005e3 <debuginfo_eip>
  1009a6:	83 c4 10             	add    $0x10,%esp
  1009a9:	85 c0                	test   %eax,%eax
  1009ab:	74 15                	je     1009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ad:	83 ec 08             	sub    $0x8,%esp
  1009b0:	ff 75 08             	pushl  0x8(%ebp)
  1009b3:	68 96 6a 10 00       	push   $0x106a96
  1009b8:	e8 aa f8 ff ff       	call   100267 <cprintf>
  1009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c0:	eb 65                	jmp    100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009c9:	eb 1c                	jmp    1009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d1:	01 d0                	add    %edx,%eax
  1009d3:	0f b6 00             	movzbl (%eax),%eax
  1009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009df:	01 ca                	add    %ecx,%edx
  1009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009ed:	7f dc                	jg     1009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	01 d0                	add    %edx,%eax
  1009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a00:	8b 55 08             	mov    0x8(%ebp),%edx
  100a03:	89 d1                	mov    %edx,%ecx
  100a05:	29 c1                	sub    %eax,%ecx
  100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a0d:	83 ec 0c             	sub    $0xc,%esp
  100a10:	51                   	push   %ecx
  100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a17:	51                   	push   %ecx
  100a18:	52                   	push   %edx
  100a19:	50                   	push   %eax
  100a1a:	68 b2 6a 10 00       	push   $0x106ab2
  100a1f:	e8 43 f8 ff ff       	call   100267 <cprintf>
  100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a27:	90                   	nop
  100a28:	c9                   	leave  
  100a29:	c3                   	ret    

00100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2a:	55                   	push   %ebp
  100a2b:	89 e5                	mov    %esp,%ebp
  100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a30:	8b 45 04             	mov    0x4(%ebp),%eax
  100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a39:	c9                   	leave  
  100a3a:	c3                   	ret    

00100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a3b:	55                   	push   %ebp
  100a3c:	89 e5                	mov    %esp,%ebp
  100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a41:	89 e8                	mov    %ebp,%eax
  100a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
  100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
  100a4c:	e8 d9 ff ff ff       	call   100a2a <read_eip>
  100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
  100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a5b:	e9 87 00 00 00       	jmp    100ae7 <print_stackframe+0xac>
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
  100a60:	83 ec 04             	sub    $0x4,%esp
  100a63:	ff 75 f0             	pushl  -0x10(%ebp)
  100a66:	ff 75 f4             	pushl  -0xc(%ebp)
  100a69:	68 c4 6a 10 00       	push   $0x106ac4
  100a6e:	e8 f4 f7 ff ff       	call   100267 <cprintf>
  100a73:	83 c4 10             	add    $0x10,%esp
		for (int argi = 0; argi < 4; ++ argi) {
  100a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a7d:	eb 29                	jmp    100aa8 <print_stackframe+0x6d>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
  100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8c:	01 d0                	add    %edx,%eax
  100a8e:	83 c0 08             	add    $0x8,%eax
  100a91:	8b 00                	mov    (%eax),%eax
  100a93:	83 ec 08             	sub    $0x8,%esp
  100a96:	50                   	push   %eax
  100a97:	68 e0 6a 10 00       	push   $0x106ae0
  100a9c:	e8 c6 f7 ff ff       	call   100267 <cprintf>
  100aa1:	83 c4 10             	add    $0x10,%esp
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
		for (int argi = 0; argi < 4; ++ argi) {
  100aa4:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aa8:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aac:	7e d1                	jle    100a7f <print_stackframe+0x44>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
		}
		cprintf("\n");
  100aae:	83 ec 0c             	sub    $0xc,%esp
  100ab1:	68 e8 6a 10 00       	push   $0x106ae8
  100ab6:	e8 ac f7 ff ff       	call   100267 <cprintf>
  100abb:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(current_eip - 1);
  100abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac1:	83 e8 01             	sub    $0x1,%eax
  100ac4:	83 ec 0c             	sub    $0xc,%esp
  100ac7:	50                   	push   %eax
  100ac8:	e8 c1 fe ff ff       	call   10098e <print_debuginfo>
  100acd:	83 c4 10             	add    $0x10,%esp
		current_eip = *((uint32_t*)current_ebp + 1);
  100ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad3:	83 c0 04             	add    $0x4,%eax
  100ad6:	8b 00                	mov    (%eax),%eax
  100ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);
  100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ade:	8b 00                	mov    (%eax),%eax
  100ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
  100ae3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ae7:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100aeb:	7f 0a                	jg     100af7 <print_stackframe+0xbc>
  100aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af1:	0f 85 69 ff ff ff    	jne    100a60 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(current_eip - 1);
		current_eip = *((uint32_t*)current_ebp + 1);
		current_ebp = *((uint32_t*)current_ebp);
	}
}
  100af7:	90                   	nop
  100af8:	c9                   	leave  
  100af9:	c3                   	ret    

00100afa <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100afa:	55                   	push   %ebp
  100afb:	89 e5                	mov    %esp,%ebp
  100afd:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b07:	eb 0c                	jmp    100b15 <parse+0x1b>
            *buf ++ = '\0';
  100b09:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0c:	8d 50 01             	lea    0x1(%eax),%edx
  100b0f:	89 55 08             	mov    %edx,0x8(%ebp)
  100b12:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b15:	8b 45 08             	mov    0x8(%ebp),%eax
  100b18:	0f b6 00             	movzbl (%eax),%eax
  100b1b:	84 c0                	test   %al,%al
  100b1d:	74 1e                	je     100b3d <parse+0x43>
  100b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b22:	0f b6 00             	movzbl (%eax),%eax
  100b25:	0f be c0             	movsbl %al,%eax
  100b28:	83 ec 08             	sub    $0x8,%esp
  100b2b:	50                   	push   %eax
  100b2c:	68 6c 6b 10 00       	push   $0x106b6c
  100b31:	e8 72 54 00 00       	call   105fa8 <strchr>
  100b36:	83 c4 10             	add    $0x10,%esp
  100b39:	85 c0                	test   %eax,%eax
  100b3b:	75 cc                	jne    100b09 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b40:	0f b6 00             	movzbl (%eax),%eax
  100b43:	84 c0                	test   %al,%al
  100b45:	74 69                	je     100bb0 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b47:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b4b:	75 12                	jne    100b5f <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b4d:	83 ec 08             	sub    $0x8,%esp
  100b50:	6a 10                	push   $0x10
  100b52:	68 71 6b 10 00       	push   $0x106b71
  100b57:	e8 0b f7 ff ff       	call   100267 <cprintf>
  100b5c:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b62:	8d 50 01             	lea    0x1(%eax),%edx
  100b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b72:	01 c2                	add    %eax,%edx
  100b74:	8b 45 08             	mov    0x8(%ebp),%eax
  100b77:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b79:	eb 04                	jmp    100b7f <parse+0x85>
            buf ++;
  100b7b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b82:	0f b6 00             	movzbl (%eax),%eax
  100b85:	84 c0                	test   %al,%al
  100b87:	0f 84 7a ff ff ff    	je     100b07 <parse+0xd>
  100b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b90:	0f b6 00             	movzbl (%eax),%eax
  100b93:	0f be c0             	movsbl %al,%eax
  100b96:	83 ec 08             	sub    $0x8,%esp
  100b99:	50                   	push   %eax
  100b9a:	68 6c 6b 10 00       	push   $0x106b6c
  100b9f:	e8 04 54 00 00       	call   105fa8 <strchr>
  100ba4:	83 c4 10             	add    $0x10,%esp
  100ba7:	85 c0                	test   %eax,%eax
  100ba9:	74 d0                	je     100b7b <parse+0x81>
            buf ++;
        }
    }
  100bab:	e9 57 ff ff ff       	jmp    100b07 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bb0:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bb4:	c9                   	leave  
  100bb5:	c3                   	ret    

00100bb6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bb6:	55                   	push   %ebp
  100bb7:	89 e5                	mov    %esp,%ebp
  100bb9:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bbc:	83 ec 08             	sub    $0x8,%esp
  100bbf:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc2:	50                   	push   %eax
  100bc3:	ff 75 08             	pushl  0x8(%ebp)
  100bc6:	e8 2f ff ff ff       	call   100afa <parse>
  100bcb:	83 c4 10             	add    $0x10,%esp
  100bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd5:	75 0a                	jne    100be1 <runcmd+0x2b>
        return 0;
  100bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  100bdc:	e9 83 00 00 00       	jmp    100c64 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100be8:	eb 59                	jmp    100c43 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bea:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf0:	89 d0                	mov    %edx,%eax
  100bf2:	01 c0                	add    %eax,%eax
  100bf4:	01 d0                	add    %edx,%eax
  100bf6:	c1 e0 02             	shl    $0x2,%eax
  100bf9:	05 20 90 11 00       	add    $0x119020,%eax
  100bfe:	8b 00                	mov    (%eax),%eax
  100c00:	83 ec 08             	sub    $0x8,%esp
  100c03:	51                   	push   %ecx
  100c04:	50                   	push   %eax
  100c05:	e8 fe 52 00 00       	call   105f08 <strcmp>
  100c0a:	83 c4 10             	add    $0x10,%esp
  100c0d:	85 c0                	test   %eax,%eax
  100c0f:	75 2e                	jne    100c3f <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c14:	89 d0                	mov    %edx,%eax
  100c16:	01 c0                	add    %eax,%eax
  100c18:	01 d0                	add    %edx,%eax
  100c1a:	c1 e0 02             	shl    $0x2,%eax
  100c1d:	05 28 90 11 00       	add    $0x119028,%eax
  100c22:	8b 10                	mov    (%eax),%edx
  100c24:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c27:	83 c0 04             	add    $0x4,%eax
  100c2a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c2d:	83 e9 01             	sub    $0x1,%ecx
  100c30:	83 ec 04             	sub    $0x4,%esp
  100c33:	ff 75 0c             	pushl  0xc(%ebp)
  100c36:	50                   	push   %eax
  100c37:	51                   	push   %ecx
  100c38:	ff d2                	call   *%edx
  100c3a:	83 c4 10             	add    $0x10,%esp
  100c3d:	eb 25                	jmp    100c64 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c46:	83 f8 02             	cmp    $0x2,%eax
  100c49:	76 9f                	jbe    100bea <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c4e:	83 ec 08             	sub    $0x8,%esp
  100c51:	50                   	push   %eax
  100c52:	68 8f 6b 10 00       	push   $0x106b8f
  100c57:	e8 0b f6 ff ff       	call   100267 <cprintf>
  100c5c:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c64:	c9                   	leave  
  100c65:	c3                   	ret    

00100c66 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c66:	55                   	push   %ebp
  100c67:	89 e5                	mov    %esp,%ebp
  100c69:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c6c:	83 ec 0c             	sub    $0xc,%esp
  100c6f:	68 a8 6b 10 00       	push   $0x106ba8
  100c74:	e8 ee f5 ff ff       	call   100267 <cprintf>
  100c79:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c7c:	83 ec 0c             	sub    $0xc,%esp
  100c7f:	68 d0 6b 10 00       	push   $0x106bd0
  100c84:	e8 de f5 ff ff       	call   100267 <cprintf>
  100c89:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c90:	74 0e                	je     100ca0 <kmonitor+0x3a>
        print_trapframe(tf);
  100c92:	83 ec 0c             	sub    $0xc,%esp
  100c95:	ff 75 08             	pushl  0x8(%ebp)
  100c98:	e8 14 0e 00 00       	call   101ab1 <print_trapframe>
  100c9d:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ca0:	83 ec 0c             	sub    $0xc,%esp
  100ca3:	68 f5 6b 10 00       	push   $0x106bf5
  100ca8:	e8 5e f6 ff ff       	call   10030b <readline>
  100cad:	83 c4 10             	add    $0x10,%esp
  100cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb7:	74 e7                	je     100ca0 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cb9:	83 ec 08             	sub    $0x8,%esp
  100cbc:	ff 75 08             	pushl  0x8(%ebp)
  100cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  100cc2:	e8 ef fe ff ff       	call   100bb6 <runcmd>
  100cc7:	83 c4 10             	add    $0x10,%esp
  100cca:	85 c0                	test   %eax,%eax
  100ccc:	78 02                	js     100cd0 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cce:	eb d0                	jmp    100ca0 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cd0:	90                   	nop
            }
        }
    }
}
  100cd1:	90                   	nop
  100cd2:	c9                   	leave  
  100cd3:	c3                   	ret    

00100cd4 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd4:	55                   	push   %ebp
  100cd5:	89 e5                	mov    %esp,%ebp
  100cd7:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce1:	eb 3c                	jmp    100d1f <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce6:	89 d0                	mov    %edx,%eax
  100ce8:	01 c0                	add    %eax,%eax
  100cea:	01 d0                	add    %edx,%eax
  100cec:	c1 e0 02             	shl    $0x2,%eax
  100cef:	05 24 90 11 00       	add    $0x119024,%eax
  100cf4:	8b 08                	mov    (%eax),%ecx
  100cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf9:	89 d0                	mov    %edx,%eax
  100cfb:	01 c0                	add    %eax,%eax
  100cfd:	01 d0                	add    %edx,%eax
  100cff:	c1 e0 02             	shl    $0x2,%eax
  100d02:	05 20 90 11 00       	add    $0x119020,%eax
  100d07:	8b 00                	mov    (%eax),%eax
  100d09:	83 ec 04             	sub    $0x4,%esp
  100d0c:	51                   	push   %ecx
  100d0d:	50                   	push   %eax
  100d0e:	68 f9 6b 10 00       	push   $0x106bf9
  100d13:	e8 4f f5 ff ff       	call   100267 <cprintf>
  100d18:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d22:	83 f8 02             	cmp    $0x2,%eax
  100d25:	76 bc                	jbe    100ce3 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2c:	c9                   	leave  
  100d2d:	c3                   	ret    

00100d2e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d2e:	55                   	push   %ebp
  100d2f:	89 e5                	mov    %esp,%ebp
  100d31:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d34:	e8 b8 fb ff ff       	call   1008f1 <print_kerninfo>
    return 0;
  100d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3e:	c9                   	leave  
  100d3f:	c3                   	ret    

00100d40 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d40:	55                   	push   %ebp
  100d41:	89 e5                	mov    %esp,%ebp
  100d43:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d46:	e8 f0 fc ff ff       	call   100a3b <print_stackframe>
    return 0;
  100d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d50:	c9                   	leave  
  100d51:	c3                   	ret    

00100d52 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d52:	55                   	push   %ebp
  100d53:	89 e5                	mov    %esp,%ebp
  100d55:	83 ec 18             	sub    $0x18,%esp
  100d58:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d5e:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d62:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d66:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d6a:	ee                   	out    %al,(%dx)
  100d6b:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d71:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d75:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d79:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d7d:	ee                   	out    %al,(%dx)
  100d7e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d84:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d88:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d90:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d91:	c7 05 58 a9 11 00 00 	movl   $0x0,0x11a958
  100d98:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9b:	83 ec 0c             	sub    $0xc,%esp
  100d9e:	68 02 6c 10 00       	push   $0x106c02
  100da3:	e8 bf f4 ff ff       	call   100267 <cprintf>
  100da8:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100dab:	83 ec 0c             	sub    $0xc,%esp
  100dae:	6a 00                	push   $0x0
  100db0:	e8 3b 09 00 00       	call   1016f0 <pic_enable>
  100db5:	83 c4 10             	add    $0x10,%esp
}
  100db8:	90                   	nop
  100db9:	c9                   	leave  
  100dba:	c3                   	ret    

00100dbb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dbb:	55                   	push   %ebp
  100dbc:	89 e5                	mov    %esp,%ebp
  100dbe:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dc1:	9c                   	pushf  
  100dc2:	58                   	pop    %eax
  100dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dc9:	25 00 02 00 00       	and    $0x200,%eax
  100dce:	85 c0                	test   %eax,%eax
  100dd0:	74 0c                	je     100dde <__intr_save+0x23>
        intr_disable();
  100dd2:	e8 8a 0a 00 00       	call   101861 <intr_disable>
        return 1;
  100dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  100ddc:	eb 05                	jmp    100de3 <__intr_save+0x28>
    }
    return 0;
  100dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100def:	74 05                	je     100df6 <__intr_restore+0x11>
        intr_enable();
  100df1:	e8 64 0a 00 00       	call   10185a <intr_enable>
    }
}
  100df6:	90                   	nop
  100df7:	c9                   	leave  
  100df8:	c3                   	ret    

00100df9 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100df9:	55                   	push   %ebp
  100dfa:	89 e5                	mov    %esp,%ebp
  100dfc:	83 ec 10             	sub    $0x10,%esp
  100dff:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e05:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e09:	89 c2                	mov    %eax,%edx
  100e0b:	ec                   	in     (%dx),%al
  100e0c:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e0f:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e15:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e19:	89 c2                	mov    %eax,%edx
  100e1b:	ec                   	in     (%dx),%al
  100e1c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e1f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e25:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e29:	89 c2                	mov    %eax,%edx
  100e2b:	ec                   	in     (%dx),%al
  100e2c:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e2f:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e35:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e39:	89 c2                	mov    %eax,%edx
  100e3b:	ec                   	in     (%dx),%al
  100e3c:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e3f:	90                   	nop
  100e40:	c9                   	leave  
  100e41:	c3                   	ret    

00100e42 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e42:	55                   	push   %ebp
  100e43:	89 e5                	mov    %esp,%ebp
  100e45:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e48:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e52:	0f b7 00             	movzwl (%eax),%eax
  100e55:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e64:	0f b7 00             	movzwl (%eax),%eax
  100e67:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e6b:	74 12                	je     100e7f <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e6d:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e74:	66 c7 05 86 9e 11 00 	movw   $0x3b4,0x119e86
  100e7b:	b4 03 
  100e7d:	eb 13                	jmp    100e92 <cga_init+0x50>
    } else {
        *cp = was;
  100e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e82:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e86:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e89:	66 c7 05 86 9e 11 00 	movw   $0x3d4,0x119e86
  100e90:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e92:	0f b7 05 86 9e 11 00 	movzwl 0x119e86,%eax
  100e99:	0f b7 c0             	movzwl %ax,%eax
  100e9c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100ea0:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ea4:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100ea8:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100eac:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ead:	0f b7 05 86 9e 11 00 	movzwl 0x119e86,%eax
  100eb4:	83 c0 01             	add    $0x1,%eax
  100eb7:	0f b7 c0             	movzwl %ax,%eax
  100eba:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ebe:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ec2:	89 c2                	mov    %eax,%edx
  100ec4:	ec                   	in     (%dx),%al
  100ec5:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100ec8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ecc:	0f b6 c0             	movzbl %al,%eax
  100ecf:	c1 e0 08             	shl    $0x8,%eax
  100ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ed5:	0f b7 05 86 9e 11 00 	movzwl 0x119e86,%eax
  100edc:	0f b7 c0             	movzwl %ax,%eax
  100edf:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ee3:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100eeb:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100eef:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ef0:	0f b7 05 86 9e 11 00 	movzwl 0x119e86,%eax
  100ef7:	83 c0 01             	add    $0x1,%eax
  100efa:	0f b7 c0             	movzwl %ax,%eax
  100efd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f01:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f05:	89 c2                	mov    %eax,%edx
  100f07:	ec                   	in     (%dx),%al
  100f08:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f0b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f0f:	0f b6 c0             	movzbl %al,%eax
  100f12:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f18:	a3 80 9e 11 00       	mov    %eax,0x119e80
    crt_pos = pos;
  100f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f20:	66 a3 84 9e 11 00    	mov    %ax,0x119e84
}
  100f26:	90                   	nop
  100f27:	c9                   	leave  
  100f28:	c3                   	ret    

00100f29 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f29:	55                   	push   %ebp
  100f2a:	89 e5                	mov    %esp,%ebp
  100f2c:	83 ec 28             	sub    $0x28,%esp
  100f2f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f35:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f39:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f3d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f41:	ee                   	out    %al,(%dx)
  100f42:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f48:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f4c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f50:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f54:	ee                   	out    %al,(%dx)
  100f55:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f5b:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f5f:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f6e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f72:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f76:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f81:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f85:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f94:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f98:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f9c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa7:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fab:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fba:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fbe:	89 c2                	mov    %eax,%edx
  100fc0:	ec                   	in     (%dx),%al
  100fc1:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc8:	3c ff                	cmp    $0xff,%al
  100fca:	0f 95 c0             	setne  %al
  100fcd:	0f b6 c0             	movzbl %al,%eax
  100fd0:	a3 88 9e 11 00       	mov    %eax,0x119e88
  100fd5:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fdb:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100fe5:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100feb:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fef:	89 c2                	mov    %eax,%edx
  100ff1:	ec                   	in     (%dx),%al
  100ff2:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff5:	a1 88 9e 11 00       	mov    0x119e88,%eax
  100ffa:	85 c0                	test   %eax,%eax
  100ffc:	74 0d                	je     10100b <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100ffe:	83 ec 0c             	sub    $0xc,%esp
  101001:	6a 04                	push   $0x4
  101003:	e8 e8 06 00 00       	call   1016f0 <pic_enable>
  101008:	83 c4 10             	add    $0x10,%esp
    }
}
  10100b:	90                   	nop
  10100c:	c9                   	leave  
  10100d:	c3                   	ret    

0010100e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10100e:	55                   	push   %ebp
  10100f:	89 e5                	mov    %esp,%ebp
  101011:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10101b:	eb 09                	jmp    101026 <lpt_putc_sub+0x18>
        delay();
  10101d:	e8 d7 fd ff ff       	call   100df9 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101022:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101026:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  10102c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101030:	89 c2                	mov    %eax,%edx
  101032:	ec                   	in     (%dx),%al
  101033:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  101036:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10103a:	84 c0                	test   %al,%al
  10103c:	78 09                	js     101047 <lpt_putc_sub+0x39>
  10103e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101045:	7e d6                	jle    10101d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101047:	8b 45 08             	mov    0x8(%ebp),%eax
  10104a:	0f b6 c0             	movzbl %al,%eax
  10104d:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101053:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101056:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10105a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10105e:	ee                   	out    %al,(%dx)
  10105f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101065:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101069:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101071:	ee                   	out    %al,(%dx)
  101072:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101078:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10107c:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101080:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101084:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101085:	90                   	nop
  101086:	c9                   	leave  
  101087:	c3                   	ret    

00101088 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101088:	55                   	push   %ebp
  101089:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10108b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10108f:	74 0d                	je     10109e <lpt_putc+0x16>
        lpt_putc_sub(c);
  101091:	ff 75 08             	pushl  0x8(%ebp)
  101094:	e8 75 ff ff ff       	call   10100e <lpt_putc_sub>
  101099:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10109c:	eb 1e                	jmp    1010bc <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10109e:	6a 08                	push   $0x8
  1010a0:	e8 69 ff ff ff       	call   10100e <lpt_putc_sub>
  1010a5:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010a8:	6a 20                	push   $0x20
  1010aa:	e8 5f ff ff ff       	call   10100e <lpt_putc_sub>
  1010af:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010b2:	6a 08                	push   $0x8
  1010b4:	e8 55 ff ff ff       	call   10100e <lpt_putc_sub>
  1010b9:	83 c4 04             	add    $0x4,%esp
    }
}
  1010bc:	90                   	nop
  1010bd:	c9                   	leave  
  1010be:	c3                   	ret    

001010bf <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010bf:	55                   	push   %ebp
  1010c0:	89 e5                	mov    %esp,%ebp
  1010c2:	53                   	push   %ebx
  1010c3:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c9:	b0 00                	mov    $0x0,%al
  1010cb:	85 c0                	test   %eax,%eax
  1010cd:	75 07                	jne    1010d6 <cga_putc+0x17>
        c |= 0x0700;
  1010cf:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d9:	0f b6 c0             	movzbl %al,%eax
  1010dc:	83 f8 0a             	cmp    $0xa,%eax
  1010df:	74 4e                	je     10112f <cga_putc+0x70>
  1010e1:	83 f8 0d             	cmp    $0xd,%eax
  1010e4:	74 59                	je     10113f <cga_putc+0x80>
  1010e6:	83 f8 08             	cmp    $0x8,%eax
  1010e9:	0f 85 8a 00 00 00    	jne    101179 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010ef:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  1010f6:	66 85 c0             	test   %ax,%ax
  1010f9:	0f 84 a0 00 00 00    	je     10119f <cga_putc+0xe0>
            crt_pos --;
  1010ff:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  101106:	83 e8 01             	sub    $0x1,%eax
  101109:	66 a3 84 9e 11 00    	mov    %ax,0x119e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10110f:	a1 80 9e 11 00       	mov    0x119e80,%eax
  101114:	0f b7 15 84 9e 11 00 	movzwl 0x119e84,%edx
  10111b:	0f b7 d2             	movzwl %dx,%edx
  10111e:	01 d2                	add    %edx,%edx
  101120:	01 d0                	add    %edx,%eax
  101122:	8b 55 08             	mov    0x8(%ebp),%edx
  101125:	b2 00                	mov    $0x0,%dl
  101127:	83 ca 20             	or     $0x20,%edx
  10112a:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10112d:	eb 70                	jmp    10119f <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  10112f:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  101136:	83 c0 50             	add    $0x50,%eax
  101139:	66 a3 84 9e 11 00    	mov    %ax,0x119e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10113f:	0f b7 1d 84 9e 11 00 	movzwl 0x119e84,%ebx
  101146:	0f b7 0d 84 9e 11 00 	movzwl 0x119e84,%ecx
  10114d:	0f b7 c1             	movzwl %cx,%eax
  101150:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101156:	c1 e8 10             	shr    $0x10,%eax
  101159:	89 c2                	mov    %eax,%edx
  10115b:	66 c1 ea 06          	shr    $0x6,%dx
  10115f:	89 d0                	mov    %edx,%eax
  101161:	c1 e0 02             	shl    $0x2,%eax
  101164:	01 d0                	add    %edx,%eax
  101166:	c1 e0 04             	shl    $0x4,%eax
  101169:	29 c1                	sub    %eax,%ecx
  10116b:	89 ca                	mov    %ecx,%edx
  10116d:	89 d8                	mov    %ebx,%eax
  10116f:	29 d0                	sub    %edx,%eax
  101171:	66 a3 84 9e 11 00    	mov    %ax,0x119e84
        break;
  101177:	eb 27                	jmp    1011a0 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101179:	8b 0d 80 9e 11 00    	mov    0x119e80,%ecx
  10117f:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  101186:	8d 50 01             	lea    0x1(%eax),%edx
  101189:	66 89 15 84 9e 11 00 	mov    %dx,0x119e84
  101190:	0f b7 c0             	movzwl %ax,%eax
  101193:	01 c0                	add    %eax,%eax
  101195:	01 c8                	add    %ecx,%eax
  101197:	8b 55 08             	mov    0x8(%ebp),%edx
  10119a:	66 89 10             	mov    %dx,(%eax)
        break;
  10119d:	eb 01                	jmp    1011a0 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10119f:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011a0:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  1011a7:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011ab:	76 59                	jbe    101206 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011ad:	a1 80 9e 11 00       	mov    0x119e80,%eax
  1011b2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011b8:	a1 80 9e 11 00       	mov    0x119e80,%eax
  1011bd:	83 ec 04             	sub    $0x4,%esp
  1011c0:	68 00 0f 00 00       	push   $0xf00
  1011c5:	52                   	push   %edx
  1011c6:	50                   	push   %eax
  1011c7:	e8 db 4f 00 00       	call   1061a7 <memmove>
  1011cc:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011cf:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011d6:	eb 15                	jmp    1011ed <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011d8:	a1 80 9e 11 00       	mov    0x119e80,%eax
  1011dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011e0:	01 d2                	add    %edx,%edx
  1011e2:	01 d0                	add    %edx,%eax
  1011e4:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011ed:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011f4:	7e e2                	jle    1011d8 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011f6:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  1011fd:	83 e8 50             	sub    $0x50,%eax
  101200:	66 a3 84 9e 11 00    	mov    %ax,0x119e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101206:	0f b7 05 86 9e 11 00 	movzwl 0x119e86,%eax
  10120d:	0f b7 c0             	movzwl %ax,%eax
  101210:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101214:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  101218:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10121c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101220:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101221:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  101228:	66 c1 e8 08          	shr    $0x8,%ax
  10122c:	0f b6 c0             	movzbl %al,%eax
  10122f:	0f b7 15 86 9e 11 00 	movzwl 0x119e86,%edx
  101236:	83 c2 01             	add    $0x1,%edx
  101239:	0f b7 d2             	movzwl %dx,%edx
  10123c:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101240:	88 45 e9             	mov    %al,-0x17(%ebp)
  101243:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101247:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10124c:	0f b7 05 86 9e 11 00 	movzwl 0x119e86,%eax
  101253:	0f b7 c0             	movzwl %ax,%eax
  101256:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10125a:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10125e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101262:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101266:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101267:	0f b7 05 84 9e 11 00 	movzwl 0x119e84,%eax
  10126e:	0f b6 c0             	movzbl %al,%eax
  101271:	0f b7 15 86 9e 11 00 	movzwl 0x119e86,%edx
  101278:	83 c2 01             	add    $0x1,%edx
  10127b:	0f b7 d2             	movzwl %dx,%edx
  10127e:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101282:	88 45 eb             	mov    %al,-0x15(%ebp)
  101285:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101289:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10128d:	ee                   	out    %al,(%dx)
}
  10128e:	90                   	nop
  10128f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101292:	c9                   	leave  
  101293:	c3                   	ret    

00101294 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101294:	55                   	push   %ebp
  101295:	89 e5                	mov    %esp,%ebp
  101297:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012a1:	eb 09                	jmp    1012ac <serial_putc_sub+0x18>
        delay();
  1012a3:	e8 51 fb ff ff       	call   100df9 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012ac:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012b2:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012b6:	89 c2                	mov    %eax,%edx
  1012b8:	ec                   	in     (%dx),%al
  1012b9:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012c0:	0f b6 c0             	movzbl %al,%eax
  1012c3:	83 e0 20             	and    $0x20,%eax
  1012c6:	85 c0                	test   %eax,%eax
  1012c8:	75 09                	jne    1012d3 <serial_putc_sub+0x3f>
  1012ca:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012d1:	7e d0                	jle    1012a3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d6:	0f b6 c0             	movzbl %al,%eax
  1012d9:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012df:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012e2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012e6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012ea:	ee                   	out    %al,(%dx)
}
  1012eb:	90                   	nop
  1012ec:	c9                   	leave  
  1012ed:	c3                   	ret    

001012ee <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012ee:	55                   	push   %ebp
  1012ef:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012f1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012f5:	74 0d                	je     101304 <serial_putc+0x16>
        serial_putc_sub(c);
  1012f7:	ff 75 08             	pushl  0x8(%ebp)
  1012fa:	e8 95 ff ff ff       	call   101294 <serial_putc_sub>
  1012ff:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101302:	eb 1e                	jmp    101322 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  101304:	6a 08                	push   $0x8
  101306:	e8 89 ff ff ff       	call   101294 <serial_putc_sub>
  10130b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  10130e:	6a 20                	push   $0x20
  101310:	e8 7f ff ff ff       	call   101294 <serial_putc_sub>
  101315:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101318:	6a 08                	push   $0x8
  10131a:	e8 75 ff ff ff       	call   101294 <serial_putc_sub>
  10131f:	83 c4 04             	add    $0x4,%esp
    }
}
  101322:	90                   	nop
  101323:	c9                   	leave  
  101324:	c3                   	ret    

00101325 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101325:	55                   	push   %ebp
  101326:	89 e5                	mov    %esp,%ebp
  101328:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10132b:	eb 33                	jmp    101360 <cons_intr+0x3b>
        if (c != 0) {
  10132d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101331:	74 2d                	je     101360 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101333:	a1 a4 a0 11 00       	mov    0x11a0a4,%eax
  101338:	8d 50 01             	lea    0x1(%eax),%edx
  10133b:	89 15 a4 a0 11 00    	mov    %edx,0x11a0a4
  101341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101344:	88 90 a0 9e 11 00    	mov    %dl,0x119ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10134a:	a1 a4 a0 11 00       	mov    0x11a0a4,%eax
  10134f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101354:	75 0a                	jne    101360 <cons_intr+0x3b>
                cons.wpos = 0;
  101356:	c7 05 a4 a0 11 00 00 	movl   $0x0,0x11a0a4
  10135d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101360:	8b 45 08             	mov    0x8(%ebp),%eax
  101363:	ff d0                	call   *%eax
  101365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101368:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10136c:	75 bf                	jne    10132d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10136e:	90                   	nop
  10136f:	c9                   	leave  
  101370:	c3                   	ret    

00101371 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101371:	55                   	push   %ebp
  101372:	89 e5                	mov    %esp,%ebp
  101374:	83 ec 10             	sub    $0x10,%esp
  101377:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10137d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101381:	89 c2                	mov    %eax,%edx
  101383:	ec                   	in     (%dx),%al
  101384:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101387:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10138b:	0f b6 c0             	movzbl %al,%eax
  10138e:	83 e0 01             	and    $0x1,%eax
  101391:	85 c0                	test   %eax,%eax
  101393:	75 07                	jne    10139c <serial_proc_data+0x2b>
        return -1;
  101395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10139a:	eb 2a                	jmp    1013c6 <serial_proc_data+0x55>
  10139c:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a6:	89 c2                	mov    %eax,%edx
  1013a8:	ec                   	in     (%dx),%al
  1013a9:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013ac:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013b0:	0f b6 c0             	movzbl %al,%eax
  1013b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013b6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ba:	75 07                	jne    1013c3 <serial_proc_data+0x52>
        c = '\b';
  1013bc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013c6:	c9                   	leave  
  1013c7:	c3                   	ret    

001013c8 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013c8:	55                   	push   %ebp
  1013c9:	89 e5                	mov    %esp,%ebp
  1013cb:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013ce:	a1 88 9e 11 00       	mov    0x119e88,%eax
  1013d3:	85 c0                	test   %eax,%eax
  1013d5:	74 10                	je     1013e7 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013d7:	83 ec 0c             	sub    $0xc,%esp
  1013da:	68 71 13 10 00       	push   $0x101371
  1013df:	e8 41 ff ff ff       	call   101325 <cons_intr>
  1013e4:	83 c4 10             	add    $0x10,%esp
    }
}
  1013e7:	90                   	nop
  1013e8:	c9                   	leave  
  1013e9:	c3                   	ret    

001013ea <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ea:	55                   	push   %ebp
  1013eb:	89 e5                	mov    %esp,%ebp
  1013ed:	83 ec 18             	sub    $0x18,%esp
  1013f0:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013fa:	89 c2                	mov    %eax,%edx
  1013fc:	ec                   	in     (%dx),%al
  1013fd:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101400:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101404:	0f b6 c0             	movzbl %al,%eax
  101407:	83 e0 01             	and    $0x1,%eax
  10140a:	85 c0                	test   %eax,%eax
  10140c:	75 0a                	jne    101418 <kbd_proc_data+0x2e>
        return -1;
  10140e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101413:	e9 5d 01 00 00       	jmp    101575 <kbd_proc_data+0x18b>
  101418:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10141e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101422:	89 c2                	mov    %eax,%edx
  101424:	ec                   	in     (%dx),%al
  101425:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  101428:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  10142c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10142f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101433:	75 17                	jne    10144c <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101435:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  10143a:	83 c8 40             	or     $0x40,%eax
  10143d:	a3 a8 a0 11 00       	mov    %eax,0x11a0a8
        return 0;
  101442:	b8 00 00 00 00       	mov    $0x0,%eax
  101447:	e9 29 01 00 00       	jmp    101575 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10144c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101450:	84 c0                	test   %al,%al
  101452:	79 47                	jns    10149b <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101454:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  101459:	83 e0 40             	and    $0x40,%eax
  10145c:	85 c0                	test   %eax,%eax
  10145e:	75 09                	jne    101469 <kbd_proc_data+0x7f>
  101460:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101464:	83 e0 7f             	and    $0x7f,%eax
  101467:	eb 04                	jmp    10146d <kbd_proc_data+0x83>
  101469:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101474:	0f b6 80 60 90 11 00 	movzbl 0x119060(%eax),%eax
  10147b:	83 c8 40             	or     $0x40,%eax
  10147e:	0f b6 c0             	movzbl %al,%eax
  101481:	f7 d0                	not    %eax
  101483:	89 c2                	mov    %eax,%edx
  101485:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  10148a:	21 d0                	and    %edx,%eax
  10148c:	a3 a8 a0 11 00       	mov    %eax,0x11a0a8
        return 0;
  101491:	b8 00 00 00 00       	mov    $0x0,%eax
  101496:	e9 da 00 00 00       	jmp    101575 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10149b:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  1014a0:	83 e0 40             	and    $0x40,%eax
  1014a3:	85 c0                	test   %eax,%eax
  1014a5:	74 11                	je     1014b8 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014a7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014ab:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  1014b0:	83 e0 bf             	and    $0xffffffbf,%eax
  1014b3:	a3 a8 a0 11 00       	mov    %eax,0x11a0a8
    }

    shift |= shiftcode[data];
  1014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bc:	0f b6 80 60 90 11 00 	movzbl 0x119060(%eax),%eax
  1014c3:	0f b6 d0             	movzbl %al,%edx
  1014c6:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  1014cb:	09 d0                	or     %edx,%eax
  1014cd:	a3 a8 a0 11 00       	mov    %eax,0x11a0a8
    shift ^= togglecode[data];
  1014d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d6:	0f b6 80 60 91 11 00 	movzbl 0x119160(%eax),%eax
  1014dd:	0f b6 d0             	movzbl %al,%edx
  1014e0:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  1014e5:	31 d0                	xor    %edx,%eax
  1014e7:	a3 a8 a0 11 00       	mov    %eax,0x11a0a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ec:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  1014f1:	83 e0 03             	and    $0x3,%eax
  1014f4:	8b 14 85 60 95 11 00 	mov    0x119560(,%eax,4),%edx
  1014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ff:	01 d0                	add    %edx,%eax
  101501:	0f b6 00             	movzbl (%eax),%eax
  101504:	0f b6 c0             	movzbl %al,%eax
  101507:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10150a:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  10150f:	83 e0 08             	and    $0x8,%eax
  101512:	85 c0                	test   %eax,%eax
  101514:	74 22                	je     101538 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101516:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10151a:	7e 0c                	jle    101528 <kbd_proc_data+0x13e>
  10151c:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101520:	7f 06                	jg     101528 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101522:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101526:	eb 10                	jmp    101538 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101528:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10152c:	7e 0a                	jle    101538 <kbd_proc_data+0x14e>
  10152e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101532:	7f 04                	jg     101538 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101534:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101538:	a1 a8 a0 11 00       	mov    0x11a0a8,%eax
  10153d:	f7 d0                	not    %eax
  10153f:	83 e0 06             	and    $0x6,%eax
  101542:	85 c0                	test   %eax,%eax
  101544:	75 2c                	jne    101572 <kbd_proc_data+0x188>
  101546:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10154d:	75 23                	jne    101572 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  10154f:	83 ec 0c             	sub    $0xc,%esp
  101552:	68 1d 6c 10 00       	push   $0x106c1d
  101557:	e8 0b ed ff ff       	call   100267 <cprintf>
  10155c:	83 c4 10             	add    $0x10,%esp
  10155f:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101565:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101569:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10156d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101571:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101572:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101575:	c9                   	leave  
  101576:	c3                   	ret    

00101577 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101577:	55                   	push   %ebp
  101578:	89 e5                	mov    %esp,%ebp
  10157a:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10157d:	83 ec 0c             	sub    $0xc,%esp
  101580:	68 ea 13 10 00       	push   $0x1013ea
  101585:	e8 9b fd ff ff       	call   101325 <cons_intr>
  10158a:	83 c4 10             	add    $0x10,%esp
}
  10158d:	90                   	nop
  10158e:	c9                   	leave  
  10158f:	c3                   	ret    

00101590 <kbd_init>:

static void
kbd_init(void) {
  101590:	55                   	push   %ebp
  101591:	89 e5                	mov    %esp,%ebp
  101593:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101596:	e8 dc ff ff ff       	call   101577 <kbd_intr>
    pic_enable(IRQ_KBD);
  10159b:	83 ec 0c             	sub    $0xc,%esp
  10159e:	6a 01                	push   $0x1
  1015a0:	e8 4b 01 00 00       	call   1016f0 <pic_enable>
  1015a5:	83 c4 10             	add    $0x10,%esp
}
  1015a8:	90                   	nop
  1015a9:	c9                   	leave  
  1015aa:	c3                   	ret    

001015ab <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015ab:	55                   	push   %ebp
  1015ac:	89 e5                	mov    %esp,%ebp
  1015ae:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015b1:	e8 8c f8 ff ff       	call   100e42 <cga_init>
    serial_init();
  1015b6:	e8 6e f9 ff ff       	call   100f29 <serial_init>
    kbd_init();
  1015bb:	e8 d0 ff ff ff       	call   101590 <kbd_init>
    if (!serial_exists) {
  1015c0:	a1 88 9e 11 00       	mov    0x119e88,%eax
  1015c5:	85 c0                	test   %eax,%eax
  1015c7:	75 10                	jne    1015d9 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015c9:	83 ec 0c             	sub    $0xc,%esp
  1015cc:	68 29 6c 10 00       	push   $0x106c29
  1015d1:	e8 91 ec ff ff       	call   100267 <cprintf>
  1015d6:	83 c4 10             	add    $0x10,%esp
    }
}
  1015d9:	90                   	nop
  1015da:	c9                   	leave  
  1015db:	c3                   	ret    

001015dc <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015dc:	55                   	push   %ebp
  1015dd:	89 e5                	mov    %esp,%ebp
  1015df:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015e2:	e8 d4 f7 ff ff       	call   100dbb <__intr_save>
  1015e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015ea:	83 ec 0c             	sub    $0xc,%esp
  1015ed:	ff 75 08             	pushl  0x8(%ebp)
  1015f0:	e8 93 fa ff ff       	call   101088 <lpt_putc>
  1015f5:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  1015f8:	83 ec 0c             	sub    $0xc,%esp
  1015fb:	ff 75 08             	pushl  0x8(%ebp)
  1015fe:	e8 bc fa ff ff       	call   1010bf <cga_putc>
  101603:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  101606:	83 ec 0c             	sub    $0xc,%esp
  101609:	ff 75 08             	pushl  0x8(%ebp)
  10160c:	e8 dd fc ff ff       	call   1012ee <serial_putc>
  101611:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  101614:	83 ec 0c             	sub    $0xc,%esp
  101617:	ff 75 f4             	pushl  -0xc(%ebp)
  10161a:	e8 c6 f7 ff ff       	call   100de5 <__intr_restore>
  10161f:	83 c4 10             	add    $0x10,%esp
}
  101622:	90                   	nop
  101623:	c9                   	leave  
  101624:	c3                   	ret    

00101625 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101625:	55                   	push   %ebp
  101626:	89 e5                	mov    %esp,%ebp
  101628:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  10162b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101632:	e8 84 f7 ff ff       	call   100dbb <__intr_save>
  101637:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10163a:	e8 89 fd ff ff       	call   1013c8 <serial_intr>
        kbd_intr();
  10163f:	e8 33 ff ff ff       	call   101577 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101644:	8b 15 a0 a0 11 00    	mov    0x11a0a0,%edx
  10164a:	a1 a4 a0 11 00       	mov    0x11a0a4,%eax
  10164f:	39 c2                	cmp    %eax,%edx
  101651:	74 31                	je     101684 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101653:	a1 a0 a0 11 00       	mov    0x11a0a0,%eax
  101658:	8d 50 01             	lea    0x1(%eax),%edx
  10165b:	89 15 a0 a0 11 00    	mov    %edx,0x11a0a0
  101661:	0f b6 80 a0 9e 11 00 	movzbl 0x119ea0(%eax),%eax
  101668:	0f b6 c0             	movzbl %al,%eax
  10166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10166e:	a1 a0 a0 11 00       	mov    0x11a0a0,%eax
  101673:	3d 00 02 00 00       	cmp    $0x200,%eax
  101678:	75 0a                	jne    101684 <cons_getc+0x5f>
                cons.rpos = 0;
  10167a:	c7 05 a0 a0 11 00 00 	movl   $0x0,0x11a0a0
  101681:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101684:	83 ec 0c             	sub    $0xc,%esp
  101687:	ff 75 f0             	pushl  -0x10(%ebp)
  10168a:	e8 56 f7 ff ff       	call   100de5 <__intr_restore>
  10168f:	83 c4 10             	add    $0x10,%esp
    return c;
  101692:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101695:	c9                   	leave  
  101696:	c3                   	ret    

00101697 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101697:	55                   	push   %ebp
  101698:	89 e5                	mov    %esp,%ebp
  10169a:	83 ec 14             	sub    $0x14,%esp
  10169d:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016a4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016a8:	66 a3 70 95 11 00    	mov    %ax,0x119570
    if (did_init) {
  1016ae:	a1 ac a0 11 00       	mov    0x11a0ac,%eax
  1016b3:	85 c0                	test   %eax,%eax
  1016b5:	74 36                	je     1016ed <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016b7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016bb:	0f b6 c0             	movzbl %al,%eax
  1016be:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c4:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016c7:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016cb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016cf:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016d0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d4:	66 c1 e8 08          	shr    $0x8,%ax
  1016d8:	0f b6 c0             	movzbl %al,%eax
  1016db:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016e1:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016e4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016ec:	ee                   	out    %al,(%dx)
    }
}
  1016ed:	90                   	nop
  1016ee:	c9                   	leave  
  1016ef:	c3                   	ret    

001016f0 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016f0:	55                   	push   %ebp
  1016f1:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f6:	ba 01 00 00 00       	mov    $0x1,%edx
  1016fb:	89 c1                	mov    %eax,%ecx
  1016fd:	d3 e2                	shl    %cl,%edx
  1016ff:	89 d0                	mov    %edx,%eax
  101701:	f7 d0                	not    %eax
  101703:	89 c2                	mov    %eax,%edx
  101705:	0f b7 05 70 95 11 00 	movzwl 0x119570,%eax
  10170c:	21 d0                	and    %edx,%eax
  10170e:	0f b7 c0             	movzwl %ax,%eax
  101711:	50                   	push   %eax
  101712:	e8 80 ff ff ff       	call   101697 <pic_setmask>
  101717:	83 c4 04             	add    $0x4,%esp
}
  10171a:	90                   	nop
  10171b:	c9                   	leave  
  10171c:	c3                   	ret    

0010171d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10171d:	55                   	push   %ebp
  10171e:	89 e5                	mov    %esp,%ebp
  101720:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101723:	c7 05 ac a0 11 00 01 	movl   $0x1,0x11a0ac
  10172a:	00 00 00 
  10172d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101733:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  101737:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  10173b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10173f:	ee                   	out    %al,(%dx)
  101740:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101746:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  10174a:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  10174e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101752:	ee                   	out    %al,(%dx)
  101753:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  101759:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  10175d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101761:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101765:	ee                   	out    %al,(%dx)
  101766:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  10176c:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101770:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101774:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101778:	ee                   	out    %al,(%dx)
  101779:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  10177f:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101783:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101787:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10178b:	ee                   	out    %al,(%dx)
  10178c:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101792:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101796:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10179a:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
  10179f:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1017a5:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1017a9:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017b1:	ee                   	out    %al,(%dx)
  1017b2:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017b8:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017bc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017c0:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
  1017c5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017cb:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017cf:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017d3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
  1017d8:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017de:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017e2:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017e6:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
  1017eb:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1017f1:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1017f5:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1017f9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017fd:	ee                   	out    %al,(%dx)
  1017fe:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101804:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101808:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10180c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101810:	ee                   	out    %al,(%dx)
  101811:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101817:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10181b:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10181f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101823:	ee                   	out    %al,(%dx)
  101824:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  10182a:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  10182e:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101832:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  101836:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101837:	0f b7 05 70 95 11 00 	movzwl 0x119570,%eax
  10183e:	66 83 f8 ff          	cmp    $0xffff,%ax
  101842:	74 13                	je     101857 <pic_init+0x13a>
        pic_setmask(irq_mask);
  101844:	0f b7 05 70 95 11 00 	movzwl 0x119570,%eax
  10184b:	0f b7 c0             	movzwl %ax,%eax
  10184e:	50                   	push   %eax
  10184f:	e8 43 fe ff ff       	call   101697 <pic_setmask>
  101854:	83 c4 04             	add    $0x4,%esp
    }
}
  101857:	90                   	nop
  101858:	c9                   	leave  
  101859:	c3                   	ret    

0010185a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10185a:	55                   	push   %ebp
  10185b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  10185d:	fb                   	sti    
    sti();
}
  10185e:	90                   	nop
  10185f:	5d                   	pop    %ebp
  101860:	c3                   	ret    

00101861 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101861:	55                   	push   %ebp
  101862:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101864:	fa                   	cli    
    cli();
}
  101865:	90                   	nop
  101866:	5d                   	pop    %ebp
  101867:	c3                   	ret    

00101868 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101868:	55                   	push   %ebp
  101869:	89 e5                	mov    %esp,%ebp
  10186b:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10186e:	83 ec 08             	sub    $0x8,%esp
  101871:	6a 64                	push   $0x64
  101873:	68 60 6c 10 00       	push   $0x106c60
  101878:	e8 ea e9 ff ff       	call   100267 <cprintf>
  10187d:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101880:	83 ec 0c             	sub    $0xc,%esp
  101883:	68 6a 6c 10 00       	push   $0x106c6a
  101888:	e8 da e9 ff ff       	call   100267 <cprintf>
  10188d:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101890:	83 ec 04             	sub    $0x4,%esp
  101893:	68 78 6c 10 00       	push   $0x106c78
  101898:	6a 12                	push   $0x12
  10189a:	68 8e 6c 10 00       	push   $0x106c8e
  10189f:	e8 29 eb ff ff       	call   1003cd <__panic>

001018a4 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018a4:	55                   	push   %ebp
  1018a5:	89 e5                	mov    %esp,%ebp
  1018a7:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
  1018aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018b1:	e9 97 01 00 00       	jmp    101a4d <idt_init+0x1a9>
//		cprintf("vectors %d: 0x%08x\n", i, __vectors[i]);
		if (i == T_SYSCALL || i == T_SWITCH_TOK) {
  1018b6:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  1018bd:	74 0a                	je     1018c9 <idt_init+0x25>
  1018bf:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  1018c3:	0f 85 c1 00 00 00    	jne    10198a <idt_init+0xe6>
			SETGATE(idt[i], 1, KERNEL_CS, __vectors[i], DPL_USER);
  1018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cc:	8b 04 85 00 96 11 00 	mov    0x119600(,%eax,4),%eax
  1018d3:	89 c2                	mov    %eax,%edx
  1018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d8:	66 89 14 c5 c0 a0 11 	mov    %dx,0x11a0c0(,%eax,8)
  1018df:	00 
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	66 c7 04 c5 c2 a0 11 	movw   $0x8,0x11a0c2(,%eax,8)
  1018ea:	00 08 00 
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	0f b6 14 c5 c4 a0 11 	movzbl 0x11a0c4(,%eax,8),%edx
  1018f7:	00 
  1018f8:	83 e2 e0             	and    $0xffffffe0,%edx
  1018fb:	88 14 c5 c4 a0 11 00 	mov    %dl,0x11a0c4(,%eax,8)
  101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101905:	0f b6 14 c5 c4 a0 11 	movzbl 0x11a0c4(,%eax,8),%edx
  10190c:	00 
  10190d:	83 e2 1f             	and    $0x1f,%edx
  101910:	88 14 c5 c4 a0 11 00 	mov    %dl,0x11a0c4(,%eax,8)
  101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191a:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  101921:	00 
  101922:	83 ca 0f             	or     $0xf,%edx
  101925:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  10192c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192f:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  101936:	00 
  101937:	83 e2 ef             	and    $0xffffffef,%edx
  10193a:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101944:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  10194b:	00 
  10194c:	83 ca 60             	or     $0x60,%edx
  10194f:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  101956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101959:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  101960:	00 
  101961:	83 ca 80             	or     $0xffffff80,%edx
  101964:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  10196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196e:	8b 04 85 00 96 11 00 	mov    0x119600(,%eax,4),%eax
  101975:	c1 e8 10             	shr    $0x10,%eax
  101978:	89 c2                	mov    %eax,%edx
  10197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197d:	66 89 14 c5 c6 a0 11 	mov    %dx,0x11a0c6(,%eax,8)
  101984:	00 
  101985:	e9 bf 00 00 00       	jmp    101a49 <idt_init+0x1a5>
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
  10198a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198d:	8b 04 85 00 96 11 00 	mov    0x119600(,%eax,4),%eax
  101994:	89 c2                	mov    %eax,%edx
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	66 89 14 c5 c0 a0 11 	mov    %dx,0x11a0c0(,%eax,8)
  1019a0:	00 
  1019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a4:	66 c7 04 c5 c2 a0 11 	movw   $0x8,0x11a0c2(,%eax,8)
  1019ab:	00 08 00 
  1019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b1:	0f b6 14 c5 c4 a0 11 	movzbl 0x11a0c4(,%eax,8),%edx
  1019b8:	00 
  1019b9:	83 e2 e0             	and    $0xffffffe0,%edx
  1019bc:	88 14 c5 c4 a0 11 00 	mov    %dl,0x11a0c4(,%eax,8)
  1019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c6:	0f b6 14 c5 c4 a0 11 	movzbl 0x11a0c4(,%eax,8),%edx
  1019cd:	00 
  1019ce:	83 e2 1f             	and    $0x1f,%edx
  1019d1:	88 14 c5 c4 a0 11 00 	mov    %dl,0x11a0c4(,%eax,8)
  1019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019db:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  1019e2:	00 
  1019e3:	83 e2 f0             	and    $0xfffffff0,%edx
  1019e6:	83 ca 0e             	or     $0xe,%edx
  1019e9:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  1019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f3:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  1019fa:	00 
  1019fb:	83 e2 ef             	and    $0xffffffef,%edx
  1019fe:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  101a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a08:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  101a0f:	00 
  101a10:	83 e2 9f             	and    $0xffffff9f,%edx
  101a13:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  101a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1d:	0f b6 14 c5 c5 a0 11 	movzbl 0x11a0c5(,%eax,8),%edx
  101a24:	00 
  101a25:	83 ca 80             	or     $0xffffff80,%edx
  101a28:	88 14 c5 c5 a0 11 00 	mov    %dl,0x11a0c5(,%eax,8)
  101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a32:	8b 04 85 00 96 11 00 	mov    0x119600(,%eax,4),%eax
  101a39:	c1 e8 10             	shr    $0x10,%eax
  101a3c:	89 c2                	mov    %eax,%edx
  101a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a41:	66 89 14 c5 c6 a0 11 	mov    %dx,0x11a0c6(,%eax,8)
  101a48:	00 
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
  101a49:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101a4d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a54:	0f 8e 5c fe ff ff    	jle    1018b6 <idt_init+0x12>
  101a5a:	c7 45 f8 80 95 11 00 	movl   $0x119580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a64:	0f 01 18             	lidtl  (%eax)
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
		}
	}
	lidt(&idt_pd);
}
  101a67:	90                   	nop
  101a68:	c9                   	leave  
  101a69:	c3                   	ret    

00101a6a <trapname>:

static const char *
trapname(int trapno) {
  101a6a:	55                   	push   %ebp
  101a6b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a70:	83 f8 13             	cmp    $0x13,%eax
  101a73:	77 0c                	ja     101a81 <trapname+0x17>
        return excnames[trapno];
  101a75:	8b 45 08             	mov    0x8(%ebp),%eax
  101a78:	8b 04 85 00 70 10 00 	mov    0x107000(,%eax,4),%eax
  101a7f:	eb 18                	jmp    101a99 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a81:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a85:	7e 0d                	jle    101a94 <trapname+0x2a>
  101a87:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a8b:	7f 07                	jg     101a94 <trapname+0x2a>
        return "Hardware Interrupt";
  101a8d:	b8 9f 6c 10 00       	mov    $0x106c9f,%eax
  101a92:	eb 05                	jmp    101a99 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a94:	b8 b2 6c 10 00       	mov    $0x106cb2,%eax
}
  101a99:	5d                   	pop    %ebp
  101a9a:	c3                   	ret    

00101a9b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a9b:	55                   	push   %ebp
  101a9c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aa5:	66 83 f8 08          	cmp    $0x8,%ax
  101aa9:	0f 94 c0             	sete   %al
  101aac:	0f b6 c0             	movzbl %al,%eax
}
  101aaf:	5d                   	pop    %ebp
  101ab0:	c3                   	ret    

00101ab1 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101ab1:	55                   	push   %ebp
  101ab2:	89 e5                	mov    %esp,%ebp
  101ab4:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101ab7:	83 ec 08             	sub    $0x8,%esp
  101aba:	ff 75 08             	pushl  0x8(%ebp)
  101abd:	68 f3 6c 10 00       	push   $0x106cf3
  101ac2:	e8 a0 e7 ff ff       	call   100267 <cprintf>
  101ac7:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101aca:	8b 45 08             	mov    0x8(%ebp),%eax
  101acd:	83 ec 0c             	sub    $0xc,%esp
  101ad0:	50                   	push   %eax
  101ad1:	e8 b8 01 00 00       	call   101c8e <print_regs>
  101ad6:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ae0:	0f b7 c0             	movzwl %ax,%eax
  101ae3:	83 ec 08             	sub    $0x8,%esp
  101ae6:	50                   	push   %eax
  101ae7:	68 04 6d 10 00       	push   $0x106d04
  101aec:	e8 76 e7 ff ff       	call   100267 <cprintf>
  101af1:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101afb:	0f b7 c0             	movzwl %ax,%eax
  101afe:	83 ec 08             	sub    $0x8,%esp
  101b01:	50                   	push   %eax
  101b02:	68 17 6d 10 00       	push   $0x106d17
  101b07:	e8 5b e7 ff ff       	call   100267 <cprintf>
  101b0c:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b16:	0f b7 c0             	movzwl %ax,%eax
  101b19:	83 ec 08             	sub    $0x8,%esp
  101b1c:	50                   	push   %eax
  101b1d:	68 2a 6d 10 00       	push   $0x106d2a
  101b22:	e8 40 e7 ff ff       	call   100267 <cprintf>
  101b27:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b31:	0f b7 c0             	movzwl %ax,%eax
  101b34:	83 ec 08             	sub    $0x8,%esp
  101b37:	50                   	push   %eax
  101b38:	68 3d 6d 10 00       	push   $0x106d3d
  101b3d:	e8 25 e7 ff ff       	call   100267 <cprintf>
  101b42:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b45:	8b 45 08             	mov    0x8(%ebp),%eax
  101b48:	8b 40 30             	mov    0x30(%eax),%eax
  101b4b:	83 ec 0c             	sub    $0xc,%esp
  101b4e:	50                   	push   %eax
  101b4f:	e8 16 ff ff ff       	call   101a6a <trapname>
  101b54:	83 c4 10             	add    $0x10,%esp
  101b57:	89 c2                	mov    %eax,%edx
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	8b 40 30             	mov    0x30(%eax),%eax
  101b5f:	83 ec 04             	sub    $0x4,%esp
  101b62:	52                   	push   %edx
  101b63:	50                   	push   %eax
  101b64:	68 50 6d 10 00       	push   $0x106d50
  101b69:	e8 f9 e6 ff ff       	call   100267 <cprintf>
  101b6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b71:	8b 45 08             	mov    0x8(%ebp),%eax
  101b74:	8b 40 34             	mov    0x34(%eax),%eax
  101b77:	83 ec 08             	sub    $0x8,%esp
  101b7a:	50                   	push   %eax
  101b7b:	68 62 6d 10 00       	push   $0x106d62
  101b80:	e8 e2 e6 ff ff       	call   100267 <cprintf>
  101b85:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b88:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8b:	8b 40 38             	mov    0x38(%eax),%eax
  101b8e:	83 ec 08             	sub    $0x8,%esp
  101b91:	50                   	push   %eax
  101b92:	68 71 6d 10 00       	push   $0x106d71
  101b97:	e8 cb e6 ff ff       	call   100267 <cprintf>
  101b9c:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ba6:	0f b7 c0             	movzwl %ax,%eax
  101ba9:	83 ec 08             	sub    $0x8,%esp
  101bac:	50                   	push   %eax
  101bad:	68 80 6d 10 00       	push   $0x106d80
  101bb2:	e8 b0 e6 ff ff       	call   100267 <cprintf>
  101bb7:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bba:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbd:	8b 40 40             	mov    0x40(%eax),%eax
  101bc0:	83 ec 08             	sub    $0x8,%esp
  101bc3:	50                   	push   %eax
  101bc4:	68 93 6d 10 00       	push   $0x106d93
  101bc9:	e8 99 e6 ff ff       	call   100267 <cprintf>
  101bce:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bd8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bdf:	eb 3f                	jmp    101c20 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 50 40             	mov    0x40(%eax),%edx
  101be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bea:	21 d0                	and    %edx,%eax
  101bec:	85 c0                	test   %eax,%eax
  101bee:	74 29                	je     101c19 <print_trapframe+0x168>
  101bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bf3:	8b 04 85 a0 95 11 00 	mov    0x1195a0(,%eax,4),%eax
  101bfa:	85 c0                	test   %eax,%eax
  101bfc:	74 1b                	je     101c19 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c01:	8b 04 85 a0 95 11 00 	mov    0x1195a0(,%eax,4),%eax
  101c08:	83 ec 08             	sub    $0x8,%esp
  101c0b:	50                   	push   %eax
  101c0c:	68 a2 6d 10 00       	push   $0x106da2
  101c11:	e8 51 e6 ff ff       	call   100267 <cprintf>
  101c16:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c1d:	d1 65 f0             	shll   -0x10(%ebp)
  101c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c23:	83 f8 17             	cmp    $0x17,%eax
  101c26:	76 b9                	jbe    101be1 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 40 40             	mov    0x40(%eax),%eax
  101c2e:	25 00 30 00 00       	and    $0x3000,%eax
  101c33:	c1 e8 0c             	shr    $0xc,%eax
  101c36:	83 ec 08             	sub    $0x8,%esp
  101c39:	50                   	push   %eax
  101c3a:	68 a6 6d 10 00       	push   $0x106da6
  101c3f:	e8 23 e6 ff ff       	call   100267 <cprintf>
  101c44:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101c47:	83 ec 0c             	sub    $0xc,%esp
  101c4a:	ff 75 08             	pushl  0x8(%ebp)
  101c4d:	e8 49 fe ff ff       	call   101a9b <trap_in_kernel>
  101c52:	83 c4 10             	add    $0x10,%esp
  101c55:	85 c0                	test   %eax,%eax
  101c57:	75 32                	jne    101c8b <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c59:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5c:	8b 40 44             	mov    0x44(%eax),%eax
  101c5f:	83 ec 08             	sub    $0x8,%esp
  101c62:	50                   	push   %eax
  101c63:	68 af 6d 10 00       	push   $0x106daf
  101c68:	e8 fa e5 ff ff       	call   100267 <cprintf>
  101c6d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c70:	8b 45 08             	mov    0x8(%ebp),%eax
  101c73:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c77:	0f b7 c0             	movzwl %ax,%eax
  101c7a:	83 ec 08             	sub    $0x8,%esp
  101c7d:	50                   	push   %eax
  101c7e:	68 be 6d 10 00       	push   $0x106dbe
  101c83:	e8 df e5 ff ff       	call   100267 <cprintf>
  101c88:	83 c4 10             	add    $0x10,%esp
    }
}
  101c8b:	90                   	nop
  101c8c:	c9                   	leave  
  101c8d:	c3                   	ret    

00101c8e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c8e:	55                   	push   %ebp
  101c8f:	89 e5                	mov    %esp,%ebp
  101c91:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	8b 00                	mov    (%eax),%eax
  101c99:	83 ec 08             	sub    $0x8,%esp
  101c9c:	50                   	push   %eax
  101c9d:	68 d1 6d 10 00       	push   $0x106dd1
  101ca2:	e8 c0 e5 ff ff       	call   100267 <cprintf>
  101ca7:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101caa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cad:	8b 40 04             	mov    0x4(%eax),%eax
  101cb0:	83 ec 08             	sub    $0x8,%esp
  101cb3:	50                   	push   %eax
  101cb4:	68 e0 6d 10 00       	push   $0x106de0
  101cb9:	e8 a9 e5 ff ff       	call   100267 <cprintf>
  101cbe:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc4:	8b 40 08             	mov    0x8(%eax),%eax
  101cc7:	83 ec 08             	sub    $0x8,%esp
  101cca:	50                   	push   %eax
  101ccb:	68 ef 6d 10 00       	push   $0x106def
  101cd0:	e8 92 e5 ff ff       	call   100267 <cprintf>
  101cd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  101cde:	83 ec 08             	sub    $0x8,%esp
  101ce1:	50                   	push   %eax
  101ce2:	68 fe 6d 10 00       	push   $0x106dfe
  101ce7:	e8 7b e5 ff ff       	call   100267 <cprintf>
  101cec:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cef:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf2:	8b 40 10             	mov    0x10(%eax),%eax
  101cf5:	83 ec 08             	sub    $0x8,%esp
  101cf8:	50                   	push   %eax
  101cf9:	68 0d 6e 10 00       	push   $0x106e0d
  101cfe:	e8 64 e5 ff ff       	call   100267 <cprintf>
  101d03:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d06:	8b 45 08             	mov    0x8(%ebp),%eax
  101d09:	8b 40 14             	mov    0x14(%eax),%eax
  101d0c:	83 ec 08             	sub    $0x8,%esp
  101d0f:	50                   	push   %eax
  101d10:	68 1c 6e 10 00       	push   $0x106e1c
  101d15:	e8 4d e5 ff ff       	call   100267 <cprintf>
  101d1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d20:	8b 40 18             	mov    0x18(%eax),%eax
  101d23:	83 ec 08             	sub    $0x8,%esp
  101d26:	50                   	push   %eax
  101d27:	68 2b 6e 10 00       	push   $0x106e2b
  101d2c:	e8 36 e5 ff ff       	call   100267 <cprintf>
  101d31:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d34:	8b 45 08             	mov    0x8(%ebp),%eax
  101d37:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d3a:	83 ec 08             	sub    $0x8,%esp
  101d3d:	50                   	push   %eax
  101d3e:	68 3a 6e 10 00       	push   $0x106e3a
  101d43:	e8 1f e5 ff ff       	call   100267 <cprintf>
  101d48:	83 c4 10             	add    $0x10,%esp
}
  101d4b:	90                   	nop
  101d4c:	c9                   	leave  
  101d4d:	c3                   	ret    

00101d4e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d4e:	55                   	push   %ebp
  101d4f:	89 e5                	mov    %esp,%ebp
  101d51:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101d54:	8b 45 08             	mov    0x8(%ebp),%eax
  101d57:	8b 40 30             	mov    0x30(%eax),%eax
  101d5a:	83 f8 2f             	cmp    $0x2f,%eax
  101d5d:	77 21                	ja     101d80 <trap_dispatch+0x32>
  101d5f:	83 f8 2e             	cmp    $0x2e,%eax
  101d62:	0f 83 32 02 00 00    	jae    101f9a <trap_dispatch+0x24c>
  101d68:	83 f8 21             	cmp    $0x21,%eax
  101d6b:	0f 84 87 00 00 00    	je     101df8 <trap_dispatch+0xaa>
  101d71:	83 f8 24             	cmp    $0x24,%eax
  101d74:	74 5b                	je     101dd1 <trap_dispatch+0x83>
  101d76:	83 f8 20             	cmp    $0x20,%eax
  101d79:	74 1c                	je     101d97 <trap_dispatch+0x49>
  101d7b:	e9 e4 01 00 00       	jmp    101f64 <trap_dispatch+0x216>
  101d80:	83 f8 78             	cmp    $0x78,%eax
  101d83:	0f 84 4c 01 00 00    	je     101ed5 <trap_dispatch+0x187>
  101d89:	83 f8 79             	cmp    $0x79,%eax
  101d8c:	0f 84 95 01 00 00    	je     101f27 <trap_dispatch+0x1d9>
  101d92:	e9 cd 01 00 00       	jmp    101f64 <trap_dispatch+0x216>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
  101d97:	a1 58 a9 11 00       	mov    0x11a958,%eax
  101d9c:	83 c0 01             	add    $0x1,%eax
  101d9f:	a3 58 a9 11 00       	mov    %eax,0x11a958
		if (ticks % TICK_NUM == 0) {
  101da4:	8b 0d 58 a9 11 00    	mov    0x11a958,%ecx
  101daa:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101daf:	89 c8                	mov    %ecx,%eax
  101db1:	f7 e2                	mul    %edx
  101db3:	89 d0                	mov    %edx,%eax
  101db5:	c1 e8 05             	shr    $0x5,%eax
  101db8:	6b c0 64             	imul   $0x64,%eax,%eax
  101dbb:	29 c1                	sub    %eax,%ecx
  101dbd:	89 c8                	mov    %ecx,%eax
  101dbf:	85 c0                	test   %eax,%eax
  101dc1:	0f 85 d6 01 00 00    	jne    101f9d <trap_dispatch+0x24f>
			print_ticks();
  101dc7:	e8 9c fa ff ff       	call   101868 <print_ticks>
		}
        break;
  101dcc:	e9 cc 01 00 00       	jmp    101f9d <trap_dispatch+0x24f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dd1:	e8 4f f8 ff ff       	call   101625 <cons_getc>
  101dd6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101dd9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ddd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101de1:	83 ec 04             	sub    $0x4,%esp
  101de4:	52                   	push   %edx
  101de5:	50                   	push   %eax
  101de6:	68 49 6e 10 00       	push   $0x106e49
  101deb:	e8 77 e4 ff ff       	call   100267 <cprintf>
  101df0:	83 c4 10             	add    $0x10,%esp
        break;
  101df3:	e9 af 01 00 00       	jmp    101fa7 <trap_dispatch+0x259>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101df8:	e8 28 f8 ff ff       	call   101625 <cons_getc>
  101dfd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e00:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e04:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e08:	83 ec 04             	sub    $0x4,%esp
  101e0b:	52                   	push   %edx
  101e0c:	50                   	push   %eax
  101e0d:	68 5b 6e 10 00       	push   $0x106e5b
  101e12:	e8 50 e4 ff ff       	call   100267 <cprintf>
  101e17:	83 c4 10             	add    $0x10,%esp
        if (c == '0') {
  101e1a:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101e1e:	75 46                	jne    101e66 <trap_dispatch+0x118>
        	cprintf("Now switched to kernel mode");
  101e20:	83 ec 0c             	sub    $0xc,%esp
  101e23:	68 6a 6e 10 00       	push   $0x106e6a
  101e28:	e8 3a e4 ff ff       	call   100267 <cprintf>
  101e2d:	83 c4 10             	add    $0x10,%esp
        	if (tf->tf_cs != KERNEL_CS) {
  101e30:	8b 45 08             	mov    0x8(%ebp),%eax
  101e33:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e37:	66 83 f8 08          	cmp    $0x8,%ax
  101e3b:	0f 84 5f 01 00 00    	je     101fa0 <trap_dispatch+0x252>
				tf->tf_cs = KERNEL_CS;
  101e41:	8b 45 08             	mov    0x8(%ebp),%eax
  101e44:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
				tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4d:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e53:	8b 45 08             	mov    0x8(%ebp),%eax
  101e56:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_cs = USER_CS;
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
				tf->tf_eflags |= FL_IOPL_MASK;
			}
        }
        break;
  101e61:	e9 3a 01 00 00       	jmp    101fa0 <trap_dispatch+0x252>
        	cprintf("Now switched to kernel mode");
        	if (tf->tf_cs != KERNEL_CS) {
				tf->tf_cs = KERNEL_CS;
				tf->tf_ds = tf->tf_es = KERNEL_DS;
			}
        } else if (c == '3') {
  101e66:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101e6a:	0f 85 30 01 00 00    	jne    101fa0 <trap_dispatch+0x252>
        	cprintf("Now switched to user mode");
  101e70:	83 ec 0c             	sub    $0xc,%esp
  101e73:	68 86 6e 10 00       	push   $0x106e86
  101e78:	e8 ea e3 ff ff       	call   100267 <cprintf>
  101e7d:	83 c4 10             	add    $0x10,%esp
        	if (tf->tf_cs != USER_CS) {
  101e80:	8b 45 08             	mov    0x8(%ebp),%eax
  101e83:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e87:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e8b:	0f 84 0f 01 00 00    	je     101fa0 <trap_dispatch+0x252>
				tf->tf_cs = USER_CS;
  101e91:	8b 45 08             	mov    0x8(%ebp),%eax
  101e94:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101ead:	66 89 50 28          	mov    %dx,0x28(%eax)
  101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags |= FL_IOPL_MASK;
  101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec2:	8b 40 40             	mov    0x40(%eax),%eax
  101ec5:	80 cc 30             	or     $0x30,%ah
  101ec8:	89 c2                	mov    %eax,%edx
  101eca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecd:	89 50 40             	mov    %edx,0x40(%eax)
			}
        }
        break;
  101ed0:	e9 cb 00 00 00       	jmp    101fa0 <trap_dispatch+0x252>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101edc:	66 83 f8 1b          	cmp    $0x1b,%ax
  101ee0:	0f 84 bd 00 00 00    	je     101fa3 <trap_dispatch+0x255>
            tf->tf_cs = USER_CS;
  101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee9:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101eef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef2:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  101efb:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101eff:	8b 45 08             	mov    0x8(%ebp),%eax
  101f02:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f06:	8b 45 08             	mov    0x8(%ebp),%eax
  101f09:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f10:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101f14:	8b 45 08             	mov    0x8(%ebp),%eax
  101f17:	8b 40 40             	mov    0x40(%eax),%eax
  101f1a:	80 cc 30             	or     $0x30,%ah
  101f1d:	89 c2                	mov    %eax,%edx
  101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f22:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101f25:	eb 7c                	jmp    101fa3 <trap_dispatch+0x255>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f27:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f2e:	66 83 f8 08          	cmp    $0x8,%ax
  101f32:	74 72                	je     101fa6 <trap_dispatch+0x258>
            tf->tf_cs = KERNEL_CS;
  101f34:	8b 45 08             	mov    0x8(%ebp),%eax
  101f37:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f40:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101f46:	8b 45 08             	mov    0x8(%ebp),%eax
  101f49:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f50:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f54:	8b 45 08             	mov    0x8(%ebp),%eax
  101f57:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        break;
  101f62:	eb 42                	jmp    101fa6 <trap_dispatch+0x258>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f64:	8b 45 08             	mov    0x8(%ebp),%eax
  101f67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f6b:	0f b7 c0             	movzwl %ax,%eax
  101f6e:	83 e0 03             	and    $0x3,%eax
  101f71:	85 c0                	test   %eax,%eax
  101f73:	75 32                	jne    101fa7 <trap_dispatch+0x259>
            print_trapframe(tf);
  101f75:	83 ec 0c             	sub    $0xc,%esp
  101f78:	ff 75 08             	pushl  0x8(%ebp)
  101f7b:	e8 31 fb ff ff       	call   101ab1 <print_trapframe>
  101f80:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101f83:	83 ec 04             	sub    $0x4,%esp
  101f86:	68 a0 6e 10 00       	push   $0x106ea0
  101f8b:	68 d1 00 00 00       	push   $0xd1
  101f90:	68 8e 6c 10 00       	push   $0x106c8e
  101f95:	e8 33 e4 ff ff       	call   1003cd <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f9a:	90                   	nop
  101f9b:	eb 0a                	jmp    101fa7 <trap_dispatch+0x259>
         */
		ticks ++;
		if (ticks % TICK_NUM == 0) {
			print_ticks();
		}
        break;
  101f9d:	90                   	nop
  101f9e:	eb 07                	jmp    101fa7 <trap_dispatch+0x259>
				tf->tf_cs = USER_CS;
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
				tf->tf_eflags |= FL_IOPL_MASK;
			}
        }
        break;
  101fa0:	90                   	nop
  101fa1:	eb 04                	jmp    101fa7 <trap_dispatch+0x259>
        if (tf->tf_cs != USER_CS) {
            tf->tf_cs = USER_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
            tf->tf_eflags |= FL_IOPL_MASK;
        }
        break;
  101fa3:	90                   	nop
  101fa4:	eb 01                	jmp    101fa7 <trap_dispatch+0x259>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
        }
        break;
  101fa6:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101fa7:	90                   	nop
  101fa8:	c9                   	leave  
  101fa9:	c3                   	ret    

00101faa <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101faa:	55                   	push   %ebp
  101fab:	89 e5                	mov    %esp,%ebp
  101fad:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fb0:	83 ec 0c             	sub    $0xc,%esp
  101fb3:	ff 75 08             	pushl  0x8(%ebp)
  101fb6:	e8 93 fd ff ff       	call   101d4e <trap_dispatch>
  101fbb:	83 c4 10             	add    $0x10,%esp
}
  101fbe:	90                   	nop
  101fbf:	c9                   	leave  
  101fc0:	c3                   	ret    

00101fc1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $0
  101fc3:	6a 00                	push   $0x0
  jmp __alltraps
  101fc5:	e9 67 0a 00 00       	jmp    102a31 <__alltraps>

00101fca <vector1>:
.globl vector1
vector1:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $1
  101fcc:	6a 01                	push   $0x1
  jmp __alltraps
  101fce:	e9 5e 0a 00 00       	jmp    102a31 <__alltraps>

00101fd3 <vector2>:
.globl vector2
vector2:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $2
  101fd5:	6a 02                	push   $0x2
  jmp __alltraps
  101fd7:	e9 55 0a 00 00       	jmp    102a31 <__alltraps>

00101fdc <vector3>:
.globl vector3
vector3:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $3
  101fde:	6a 03                	push   $0x3
  jmp __alltraps
  101fe0:	e9 4c 0a 00 00       	jmp    102a31 <__alltraps>

00101fe5 <vector4>:
.globl vector4
vector4:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $4
  101fe7:	6a 04                	push   $0x4
  jmp __alltraps
  101fe9:	e9 43 0a 00 00       	jmp    102a31 <__alltraps>

00101fee <vector5>:
.globl vector5
vector5:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $5
  101ff0:	6a 05                	push   $0x5
  jmp __alltraps
  101ff2:	e9 3a 0a 00 00       	jmp    102a31 <__alltraps>

00101ff7 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $6
  101ff9:	6a 06                	push   $0x6
  jmp __alltraps
  101ffb:	e9 31 0a 00 00       	jmp    102a31 <__alltraps>

00102000 <vector7>:
.globl vector7
vector7:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $7
  102002:	6a 07                	push   $0x7
  jmp __alltraps
  102004:	e9 28 0a 00 00       	jmp    102a31 <__alltraps>

00102009 <vector8>:
.globl vector8
vector8:
  pushl $8
  102009:	6a 08                	push   $0x8
  jmp __alltraps
  10200b:	e9 21 0a 00 00       	jmp    102a31 <__alltraps>

00102010 <vector9>:
.globl vector9
vector9:
  pushl $9
  102010:	6a 09                	push   $0x9
  jmp __alltraps
  102012:	e9 1a 0a 00 00       	jmp    102a31 <__alltraps>

00102017 <vector10>:
.globl vector10
vector10:
  pushl $10
  102017:	6a 0a                	push   $0xa
  jmp __alltraps
  102019:	e9 13 0a 00 00       	jmp    102a31 <__alltraps>

0010201e <vector11>:
.globl vector11
vector11:
  pushl $11
  10201e:	6a 0b                	push   $0xb
  jmp __alltraps
  102020:	e9 0c 0a 00 00       	jmp    102a31 <__alltraps>

00102025 <vector12>:
.globl vector12
vector12:
  pushl $12
  102025:	6a 0c                	push   $0xc
  jmp __alltraps
  102027:	e9 05 0a 00 00       	jmp    102a31 <__alltraps>

0010202c <vector13>:
.globl vector13
vector13:
  pushl $13
  10202c:	6a 0d                	push   $0xd
  jmp __alltraps
  10202e:	e9 fe 09 00 00       	jmp    102a31 <__alltraps>

00102033 <vector14>:
.globl vector14
vector14:
  pushl $14
  102033:	6a 0e                	push   $0xe
  jmp __alltraps
  102035:	e9 f7 09 00 00       	jmp    102a31 <__alltraps>

0010203a <vector15>:
.globl vector15
vector15:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $15
  10203c:	6a 0f                	push   $0xf
  jmp __alltraps
  10203e:	e9 ee 09 00 00       	jmp    102a31 <__alltraps>

00102043 <vector16>:
.globl vector16
vector16:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $16
  102045:	6a 10                	push   $0x10
  jmp __alltraps
  102047:	e9 e5 09 00 00       	jmp    102a31 <__alltraps>

0010204c <vector17>:
.globl vector17
vector17:
  pushl $17
  10204c:	6a 11                	push   $0x11
  jmp __alltraps
  10204e:	e9 de 09 00 00       	jmp    102a31 <__alltraps>

00102053 <vector18>:
.globl vector18
vector18:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $18
  102055:	6a 12                	push   $0x12
  jmp __alltraps
  102057:	e9 d5 09 00 00       	jmp    102a31 <__alltraps>

0010205c <vector19>:
.globl vector19
vector19:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $19
  10205e:	6a 13                	push   $0x13
  jmp __alltraps
  102060:	e9 cc 09 00 00       	jmp    102a31 <__alltraps>

00102065 <vector20>:
.globl vector20
vector20:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $20
  102067:	6a 14                	push   $0x14
  jmp __alltraps
  102069:	e9 c3 09 00 00       	jmp    102a31 <__alltraps>

0010206e <vector21>:
.globl vector21
vector21:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $21
  102070:	6a 15                	push   $0x15
  jmp __alltraps
  102072:	e9 ba 09 00 00       	jmp    102a31 <__alltraps>

00102077 <vector22>:
.globl vector22
vector22:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $22
  102079:	6a 16                	push   $0x16
  jmp __alltraps
  10207b:	e9 b1 09 00 00       	jmp    102a31 <__alltraps>

00102080 <vector23>:
.globl vector23
vector23:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $23
  102082:	6a 17                	push   $0x17
  jmp __alltraps
  102084:	e9 a8 09 00 00       	jmp    102a31 <__alltraps>

00102089 <vector24>:
.globl vector24
vector24:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $24
  10208b:	6a 18                	push   $0x18
  jmp __alltraps
  10208d:	e9 9f 09 00 00       	jmp    102a31 <__alltraps>

00102092 <vector25>:
.globl vector25
vector25:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $25
  102094:	6a 19                	push   $0x19
  jmp __alltraps
  102096:	e9 96 09 00 00       	jmp    102a31 <__alltraps>

0010209b <vector26>:
.globl vector26
vector26:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $26
  10209d:	6a 1a                	push   $0x1a
  jmp __alltraps
  10209f:	e9 8d 09 00 00       	jmp    102a31 <__alltraps>

001020a4 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $27
  1020a6:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020a8:	e9 84 09 00 00       	jmp    102a31 <__alltraps>

001020ad <vector28>:
.globl vector28
vector28:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $28
  1020af:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020b1:	e9 7b 09 00 00       	jmp    102a31 <__alltraps>

001020b6 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $29
  1020b8:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020ba:	e9 72 09 00 00       	jmp    102a31 <__alltraps>

001020bf <vector30>:
.globl vector30
vector30:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $30
  1020c1:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020c3:	e9 69 09 00 00       	jmp    102a31 <__alltraps>

001020c8 <vector31>:
.globl vector31
vector31:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $31
  1020ca:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020cc:	e9 60 09 00 00       	jmp    102a31 <__alltraps>

001020d1 <vector32>:
.globl vector32
vector32:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $32
  1020d3:	6a 20                	push   $0x20
  jmp __alltraps
  1020d5:	e9 57 09 00 00       	jmp    102a31 <__alltraps>

001020da <vector33>:
.globl vector33
vector33:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $33
  1020dc:	6a 21                	push   $0x21
  jmp __alltraps
  1020de:	e9 4e 09 00 00       	jmp    102a31 <__alltraps>

001020e3 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $34
  1020e5:	6a 22                	push   $0x22
  jmp __alltraps
  1020e7:	e9 45 09 00 00       	jmp    102a31 <__alltraps>

001020ec <vector35>:
.globl vector35
vector35:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $35
  1020ee:	6a 23                	push   $0x23
  jmp __alltraps
  1020f0:	e9 3c 09 00 00       	jmp    102a31 <__alltraps>

001020f5 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $36
  1020f7:	6a 24                	push   $0x24
  jmp __alltraps
  1020f9:	e9 33 09 00 00       	jmp    102a31 <__alltraps>

001020fe <vector37>:
.globl vector37
vector37:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $37
  102100:	6a 25                	push   $0x25
  jmp __alltraps
  102102:	e9 2a 09 00 00       	jmp    102a31 <__alltraps>

00102107 <vector38>:
.globl vector38
vector38:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $38
  102109:	6a 26                	push   $0x26
  jmp __alltraps
  10210b:	e9 21 09 00 00       	jmp    102a31 <__alltraps>

00102110 <vector39>:
.globl vector39
vector39:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $39
  102112:	6a 27                	push   $0x27
  jmp __alltraps
  102114:	e9 18 09 00 00       	jmp    102a31 <__alltraps>

00102119 <vector40>:
.globl vector40
vector40:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $40
  10211b:	6a 28                	push   $0x28
  jmp __alltraps
  10211d:	e9 0f 09 00 00       	jmp    102a31 <__alltraps>

00102122 <vector41>:
.globl vector41
vector41:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $41
  102124:	6a 29                	push   $0x29
  jmp __alltraps
  102126:	e9 06 09 00 00       	jmp    102a31 <__alltraps>

0010212b <vector42>:
.globl vector42
vector42:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $42
  10212d:	6a 2a                	push   $0x2a
  jmp __alltraps
  10212f:	e9 fd 08 00 00       	jmp    102a31 <__alltraps>

00102134 <vector43>:
.globl vector43
vector43:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $43
  102136:	6a 2b                	push   $0x2b
  jmp __alltraps
  102138:	e9 f4 08 00 00       	jmp    102a31 <__alltraps>

0010213d <vector44>:
.globl vector44
vector44:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $44
  10213f:	6a 2c                	push   $0x2c
  jmp __alltraps
  102141:	e9 eb 08 00 00       	jmp    102a31 <__alltraps>

00102146 <vector45>:
.globl vector45
vector45:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $45
  102148:	6a 2d                	push   $0x2d
  jmp __alltraps
  10214a:	e9 e2 08 00 00       	jmp    102a31 <__alltraps>

0010214f <vector46>:
.globl vector46
vector46:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $46
  102151:	6a 2e                	push   $0x2e
  jmp __alltraps
  102153:	e9 d9 08 00 00       	jmp    102a31 <__alltraps>

00102158 <vector47>:
.globl vector47
vector47:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $47
  10215a:	6a 2f                	push   $0x2f
  jmp __alltraps
  10215c:	e9 d0 08 00 00       	jmp    102a31 <__alltraps>

00102161 <vector48>:
.globl vector48
vector48:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $48
  102163:	6a 30                	push   $0x30
  jmp __alltraps
  102165:	e9 c7 08 00 00       	jmp    102a31 <__alltraps>

0010216a <vector49>:
.globl vector49
vector49:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $49
  10216c:	6a 31                	push   $0x31
  jmp __alltraps
  10216e:	e9 be 08 00 00       	jmp    102a31 <__alltraps>

00102173 <vector50>:
.globl vector50
vector50:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $50
  102175:	6a 32                	push   $0x32
  jmp __alltraps
  102177:	e9 b5 08 00 00       	jmp    102a31 <__alltraps>

0010217c <vector51>:
.globl vector51
vector51:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $51
  10217e:	6a 33                	push   $0x33
  jmp __alltraps
  102180:	e9 ac 08 00 00       	jmp    102a31 <__alltraps>

00102185 <vector52>:
.globl vector52
vector52:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $52
  102187:	6a 34                	push   $0x34
  jmp __alltraps
  102189:	e9 a3 08 00 00       	jmp    102a31 <__alltraps>

0010218e <vector53>:
.globl vector53
vector53:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $53
  102190:	6a 35                	push   $0x35
  jmp __alltraps
  102192:	e9 9a 08 00 00       	jmp    102a31 <__alltraps>

00102197 <vector54>:
.globl vector54
vector54:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $54
  102199:	6a 36                	push   $0x36
  jmp __alltraps
  10219b:	e9 91 08 00 00       	jmp    102a31 <__alltraps>

001021a0 <vector55>:
.globl vector55
vector55:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $55
  1021a2:	6a 37                	push   $0x37
  jmp __alltraps
  1021a4:	e9 88 08 00 00       	jmp    102a31 <__alltraps>

001021a9 <vector56>:
.globl vector56
vector56:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $56
  1021ab:	6a 38                	push   $0x38
  jmp __alltraps
  1021ad:	e9 7f 08 00 00       	jmp    102a31 <__alltraps>

001021b2 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $57
  1021b4:	6a 39                	push   $0x39
  jmp __alltraps
  1021b6:	e9 76 08 00 00       	jmp    102a31 <__alltraps>

001021bb <vector58>:
.globl vector58
vector58:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $58
  1021bd:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021bf:	e9 6d 08 00 00       	jmp    102a31 <__alltraps>

001021c4 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $59
  1021c6:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021c8:	e9 64 08 00 00       	jmp    102a31 <__alltraps>

001021cd <vector60>:
.globl vector60
vector60:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $60
  1021cf:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021d1:	e9 5b 08 00 00       	jmp    102a31 <__alltraps>

001021d6 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $61
  1021d8:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021da:	e9 52 08 00 00       	jmp    102a31 <__alltraps>

001021df <vector62>:
.globl vector62
vector62:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $62
  1021e1:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021e3:	e9 49 08 00 00       	jmp    102a31 <__alltraps>

001021e8 <vector63>:
.globl vector63
vector63:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $63
  1021ea:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021ec:	e9 40 08 00 00       	jmp    102a31 <__alltraps>

001021f1 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $64
  1021f3:	6a 40                	push   $0x40
  jmp __alltraps
  1021f5:	e9 37 08 00 00       	jmp    102a31 <__alltraps>

001021fa <vector65>:
.globl vector65
vector65:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $65
  1021fc:	6a 41                	push   $0x41
  jmp __alltraps
  1021fe:	e9 2e 08 00 00       	jmp    102a31 <__alltraps>

00102203 <vector66>:
.globl vector66
vector66:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $66
  102205:	6a 42                	push   $0x42
  jmp __alltraps
  102207:	e9 25 08 00 00       	jmp    102a31 <__alltraps>

0010220c <vector67>:
.globl vector67
vector67:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $67
  10220e:	6a 43                	push   $0x43
  jmp __alltraps
  102210:	e9 1c 08 00 00       	jmp    102a31 <__alltraps>

00102215 <vector68>:
.globl vector68
vector68:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $68
  102217:	6a 44                	push   $0x44
  jmp __alltraps
  102219:	e9 13 08 00 00       	jmp    102a31 <__alltraps>

0010221e <vector69>:
.globl vector69
vector69:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $69
  102220:	6a 45                	push   $0x45
  jmp __alltraps
  102222:	e9 0a 08 00 00       	jmp    102a31 <__alltraps>

00102227 <vector70>:
.globl vector70
vector70:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $70
  102229:	6a 46                	push   $0x46
  jmp __alltraps
  10222b:	e9 01 08 00 00       	jmp    102a31 <__alltraps>

00102230 <vector71>:
.globl vector71
vector71:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $71
  102232:	6a 47                	push   $0x47
  jmp __alltraps
  102234:	e9 f8 07 00 00       	jmp    102a31 <__alltraps>

00102239 <vector72>:
.globl vector72
vector72:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $72
  10223b:	6a 48                	push   $0x48
  jmp __alltraps
  10223d:	e9 ef 07 00 00       	jmp    102a31 <__alltraps>

00102242 <vector73>:
.globl vector73
vector73:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $73
  102244:	6a 49                	push   $0x49
  jmp __alltraps
  102246:	e9 e6 07 00 00       	jmp    102a31 <__alltraps>

0010224b <vector74>:
.globl vector74
vector74:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $74
  10224d:	6a 4a                	push   $0x4a
  jmp __alltraps
  10224f:	e9 dd 07 00 00       	jmp    102a31 <__alltraps>

00102254 <vector75>:
.globl vector75
vector75:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $75
  102256:	6a 4b                	push   $0x4b
  jmp __alltraps
  102258:	e9 d4 07 00 00       	jmp    102a31 <__alltraps>

0010225d <vector76>:
.globl vector76
vector76:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $76
  10225f:	6a 4c                	push   $0x4c
  jmp __alltraps
  102261:	e9 cb 07 00 00       	jmp    102a31 <__alltraps>

00102266 <vector77>:
.globl vector77
vector77:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $77
  102268:	6a 4d                	push   $0x4d
  jmp __alltraps
  10226a:	e9 c2 07 00 00       	jmp    102a31 <__alltraps>

0010226f <vector78>:
.globl vector78
vector78:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $78
  102271:	6a 4e                	push   $0x4e
  jmp __alltraps
  102273:	e9 b9 07 00 00       	jmp    102a31 <__alltraps>

00102278 <vector79>:
.globl vector79
vector79:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $79
  10227a:	6a 4f                	push   $0x4f
  jmp __alltraps
  10227c:	e9 b0 07 00 00       	jmp    102a31 <__alltraps>

00102281 <vector80>:
.globl vector80
vector80:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $80
  102283:	6a 50                	push   $0x50
  jmp __alltraps
  102285:	e9 a7 07 00 00       	jmp    102a31 <__alltraps>

0010228a <vector81>:
.globl vector81
vector81:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $81
  10228c:	6a 51                	push   $0x51
  jmp __alltraps
  10228e:	e9 9e 07 00 00       	jmp    102a31 <__alltraps>

00102293 <vector82>:
.globl vector82
vector82:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $82
  102295:	6a 52                	push   $0x52
  jmp __alltraps
  102297:	e9 95 07 00 00       	jmp    102a31 <__alltraps>

0010229c <vector83>:
.globl vector83
vector83:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $83
  10229e:	6a 53                	push   $0x53
  jmp __alltraps
  1022a0:	e9 8c 07 00 00       	jmp    102a31 <__alltraps>

001022a5 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $84
  1022a7:	6a 54                	push   $0x54
  jmp __alltraps
  1022a9:	e9 83 07 00 00       	jmp    102a31 <__alltraps>

001022ae <vector85>:
.globl vector85
vector85:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $85
  1022b0:	6a 55                	push   $0x55
  jmp __alltraps
  1022b2:	e9 7a 07 00 00       	jmp    102a31 <__alltraps>

001022b7 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $86
  1022b9:	6a 56                	push   $0x56
  jmp __alltraps
  1022bb:	e9 71 07 00 00       	jmp    102a31 <__alltraps>

001022c0 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $87
  1022c2:	6a 57                	push   $0x57
  jmp __alltraps
  1022c4:	e9 68 07 00 00       	jmp    102a31 <__alltraps>

001022c9 <vector88>:
.globl vector88
vector88:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $88
  1022cb:	6a 58                	push   $0x58
  jmp __alltraps
  1022cd:	e9 5f 07 00 00       	jmp    102a31 <__alltraps>

001022d2 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $89
  1022d4:	6a 59                	push   $0x59
  jmp __alltraps
  1022d6:	e9 56 07 00 00       	jmp    102a31 <__alltraps>

001022db <vector90>:
.globl vector90
vector90:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $90
  1022dd:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022df:	e9 4d 07 00 00       	jmp    102a31 <__alltraps>

001022e4 <vector91>:
.globl vector91
vector91:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $91
  1022e6:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022e8:	e9 44 07 00 00       	jmp    102a31 <__alltraps>

001022ed <vector92>:
.globl vector92
vector92:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $92
  1022ef:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022f1:	e9 3b 07 00 00       	jmp    102a31 <__alltraps>

001022f6 <vector93>:
.globl vector93
vector93:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $93
  1022f8:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022fa:	e9 32 07 00 00       	jmp    102a31 <__alltraps>

001022ff <vector94>:
.globl vector94
vector94:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $94
  102301:	6a 5e                	push   $0x5e
  jmp __alltraps
  102303:	e9 29 07 00 00       	jmp    102a31 <__alltraps>

00102308 <vector95>:
.globl vector95
vector95:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $95
  10230a:	6a 5f                	push   $0x5f
  jmp __alltraps
  10230c:	e9 20 07 00 00       	jmp    102a31 <__alltraps>

00102311 <vector96>:
.globl vector96
vector96:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $96
  102313:	6a 60                	push   $0x60
  jmp __alltraps
  102315:	e9 17 07 00 00       	jmp    102a31 <__alltraps>

0010231a <vector97>:
.globl vector97
vector97:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $97
  10231c:	6a 61                	push   $0x61
  jmp __alltraps
  10231e:	e9 0e 07 00 00       	jmp    102a31 <__alltraps>

00102323 <vector98>:
.globl vector98
vector98:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $98
  102325:	6a 62                	push   $0x62
  jmp __alltraps
  102327:	e9 05 07 00 00       	jmp    102a31 <__alltraps>

0010232c <vector99>:
.globl vector99
vector99:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $99
  10232e:	6a 63                	push   $0x63
  jmp __alltraps
  102330:	e9 fc 06 00 00       	jmp    102a31 <__alltraps>

00102335 <vector100>:
.globl vector100
vector100:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $100
  102337:	6a 64                	push   $0x64
  jmp __alltraps
  102339:	e9 f3 06 00 00       	jmp    102a31 <__alltraps>

0010233e <vector101>:
.globl vector101
vector101:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $101
  102340:	6a 65                	push   $0x65
  jmp __alltraps
  102342:	e9 ea 06 00 00       	jmp    102a31 <__alltraps>

00102347 <vector102>:
.globl vector102
vector102:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $102
  102349:	6a 66                	push   $0x66
  jmp __alltraps
  10234b:	e9 e1 06 00 00       	jmp    102a31 <__alltraps>

00102350 <vector103>:
.globl vector103
vector103:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $103
  102352:	6a 67                	push   $0x67
  jmp __alltraps
  102354:	e9 d8 06 00 00       	jmp    102a31 <__alltraps>

00102359 <vector104>:
.globl vector104
vector104:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $104
  10235b:	6a 68                	push   $0x68
  jmp __alltraps
  10235d:	e9 cf 06 00 00       	jmp    102a31 <__alltraps>

00102362 <vector105>:
.globl vector105
vector105:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $105
  102364:	6a 69                	push   $0x69
  jmp __alltraps
  102366:	e9 c6 06 00 00       	jmp    102a31 <__alltraps>

0010236b <vector106>:
.globl vector106
vector106:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $106
  10236d:	6a 6a                	push   $0x6a
  jmp __alltraps
  10236f:	e9 bd 06 00 00       	jmp    102a31 <__alltraps>

00102374 <vector107>:
.globl vector107
vector107:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $107
  102376:	6a 6b                	push   $0x6b
  jmp __alltraps
  102378:	e9 b4 06 00 00       	jmp    102a31 <__alltraps>

0010237d <vector108>:
.globl vector108
vector108:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $108
  10237f:	6a 6c                	push   $0x6c
  jmp __alltraps
  102381:	e9 ab 06 00 00       	jmp    102a31 <__alltraps>

00102386 <vector109>:
.globl vector109
vector109:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $109
  102388:	6a 6d                	push   $0x6d
  jmp __alltraps
  10238a:	e9 a2 06 00 00       	jmp    102a31 <__alltraps>

0010238f <vector110>:
.globl vector110
vector110:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $110
  102391:	6a 6e                	push   $0x6e
  jmp __alltraps
  102393:	e9 99 06 00 00       	jmp    102a31 <__alltraps>

00102398 <vector111>:
.globl vector111
vector111:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $111
  10239a:	6a 6f                	push   $0x6f
  jmp __alltraps
  10239c:	e9 90 06 00 00       	jmp    102a31 <__alltraps>

001023a1 <vector112>:
.globl vector112
vector112:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $112
  1023a3:	6a 70                	push   $0x70
  jmp __alltraps
  1023a5:	e9 87 06 00 00       	jmp    102a31 <__alltraps>

001023aa <vector113>:
.globl vector113
vector113:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $113
  1023ac:	6a 71                	push   $0x71
  jmp __alltraps
  1023ae:	e9 7e 06 00 00       	jmp    102a31 <__alltraps>

001023b3 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $114
  1023b5:	6a 72                	push   $0x72
  jmp __alltraps
  1023b7:	e9 75 06 00 00       	jmp    102a31 <__alltraps>

001023bc <vector115>:
.globl vector115
vector115:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $115
  1023be:	6a 73                	push   $0x73
  jmp __alltraps
  1023c0:	e9 6c 06 00 00       	jmp    102a31 <__alltraps>

001023c5 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $116
  1023c7:	6a 74                	push   $0x74
  jmp __alltraps
  1023c9:	e9 63 06 00 00       	jmp    102a31 <__alltraps>

001023ce <vector117>:
.globl vector117
vector117:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $117
  1023d0:	6a 75                	push   $0x75
  jmp __alltraps
  1023d2:	e9 5a 06 00 00       	jmp    102a31 <__alltraps>

001023d7 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $118
  1023d9:	6a 76                	push   $0x76
  jmp __alltraps
  1023db:	e9 51 06 00 00       	jmp    102a31 <__alltraps>

001023e0 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $119
  1023e2:	6a 77                	push   $0x77
  jmp __alltraps
  1023e4:	e9 48 06 00 00       	jmp    102a31 <__alltraps>

001023e9 <vector120>:
.globl vector120
vector120:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $120
  1023eb:	6a 78                	push   $0x78
  jmp __alltraps
  1023ed:	e9 3f 06 00 00       	jmp    102a31 <__alltraps>

001023f2 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $121
  1023f4:	6a 79                	push   $0x79
  jmp __alltraps
  1023f6:	e9 36 06 00 00       	jmp    102a31 <__alltraps>

001023fb <vector122>:
.globl vector122
vector122:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $122
  1023fd:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023ff:	e9 2d 06 00 00       	jmp    102a31 <__alltraps>

00102404 <vector123>:
.globl vector123
vector123:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $123
  102406:	6a 7b                	push   $0x7b
  jmp __alltraps
  102408:	e9 24 06 00 00       	jmp    102a31 <__alltraps>

0010240d <vector124>:
.globl vector124
vector124:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $124
  10240f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102411:	e9 1b 06 00 00       	jmp    102a31 <__alltraps>

00102416 <vector125>:
.globl vector125
vector125:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $125
  102418:	6a 7d                	push   $0x7d
  jmp __alltraps
  10241a:	e9 12 06 00 00       	jmp    102a31 <__alltraps>

0010241f <vector126>:
.globl vector126
vector126:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $126
  102421:	6a 7e                	push   $0x7e
  jmp __alltraps
  102423:	e9 09 06 00 00       	jmp    102a31 <__alltraps>

00102428 <vector127>:
.globl vector127
vector127:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $127
  10242a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10242c:	e9 00 06 00 00       	jmp    102a31 <__alltraps>

00102431 <vector128>:
.globl vector128
vector128:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $128
  102433:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102438:	e9 f4 05 00 00       	jmp    102a31 <__alltraps>

0010243d <vector129>:
.globl vector129
vector129:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $129
  10243f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102444:	e9 e8 05 00 00       	jmp    102a31 <__alltraps>

00102449 <vector130>:
.globl vector130
vector130:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $130
  10244b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102450:	e9 dc 05 00 00       	jmp    102a31 <__alltraps>

00102455 <vector131>:
.globl vector131
vector131:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $131
  102457:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10245c:	e9 d0 05 00 00       	jmp    102a31 <__alltraps>

00102461 <vector132>:
.globl vector132
vector132:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $132
  102463:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102468:	e9 c4 05 00 00       	jmp    102a31 <__alltraps>

0010246d <vector133>:
.globl vector133
vector133:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $133
  10246f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102474:	e9 b8 05 00 00       	jmp    102a31 <__alltraps>

00102479 <vector134>:
.globl vector134
vector134:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $134
  10247b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102480:	e9 ac 05 00 00       	jmp    102a31 <__alltraps>

00102485 <vector135>:
.globl vector135
vector135:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $135
  102487:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10248c:	e9 a0 05 00 00       	jmp    102a31 <__alltraps>

00102491 <vector136>:
.globl vector136
vector136:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $136
  102493:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102498:	e9 94 05 00 00       	jmp    102a31 <__alltraps>

0010249d <vector137>:
.globl vector137
vector137:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $137
  10249f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024a4:	e9 88 05 00 00       	jmp    102a31 <__alltraps>

001024a9 <vector138>:
.globl vector138
vector138:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $138
  1024ab:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024b0:	e9 7c 05 00 00       	jmp    102a31 <__alltraps>

001024b5 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $139
  1024b7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024bc:	e9 70 05 00 00       	jmp    102a31 <__alltraps>

001024c1 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $140
  1024c3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024c8:	e9 64 05 00 00       	jmp    102a31 <__alltraps>

001024cd <vector141>:
.globl vector141
vector141:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $141
  1024cf:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024d4:	e9 58 05 00 00       	jmp    102a31 <__alltraps>

001024d9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $142
  1024db:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024e0:	e9 4c 05 00 00       	jmp    102a31 <__alltraps>

001024e5 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $143
  1024e7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024ec:	e9 40 05 00 00       	jmp    102a31 <__alltraps>

001024f1 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $144
  1024f3:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024f8:	e9 34 05 00 00       	jmp    102a31 <__alltraps>

001024fd <vector145>:
.globl vector145
vector145:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $145
  1024ff:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102504:	e9 28 05 00 00       	jmp    102a31 <__alltraps>

00102509 <vector146>:
.globl vector146
vector146:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $146
  10250b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102510:	e9 1c 05 00 00       	jmp    102a31 <__alltraps>

00102515 <vector147>:
.globl vector147
vector147:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $147
  102517:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10251c:	e9 10 05 00 00       	jmp    102a31 <__alltraps>

00102521 <vector148>:
.globl vector148
vector148:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $148
  102523:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102528:	e9 04 05 00 00       	jmp    102a31 <__alltraps>

0010252d <vector149>:
.globl vector149
vector149:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $149
  10252f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102534:	e9 f8 04 00 00       	jmp    102a31 <__alltraps>

00102539 <vector150>:
.globl vector150
vector150:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $150
  10253b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102540:	e9 ec 04 00 00       	jmp    102a31 <__alltraps>

00102545 <vector151>:
.globl vector151
vector151:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $151
  102547:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10254c:	e9 e0 04 00 00       	jmp    102a31 <__alltraps>

00102551 <vector152>:
.globl vector152
vector152:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $152
  102553:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102558:	e9 d4 04 00 00       	jmp    102a31 <__alltraps>

0010255d <vector153>:
.globl vector153
vector153:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $153
  10255f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102564:	e9 c8 04 00 00       	jmp    102a31 <__alltraps>

00102569 <vector154>:
.globl vector154
vector154:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $154
  10256b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102570:	e9 bc 04 00 00       	jmp    102a31 <__alltraps>

00102575 <vector155>:
.globl vector155
vector155:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $155
  102577:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10257c:	e9 b0 04 00 00       	jmp    102a31 <__alltraps>

00102581 <vector156>:
.globl vector156
vector156:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $156
  102583:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102588:	e9 a4 04 00 00       	jmp    102a31 <__alltraps>

0010258d <vector157>:
.globl vector157
vector157:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $157
  10258f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102594:	e9 98 04 00 00       	jmp    102a31 <__alltraps>

00102599 <vector158>:
.globl vector158
vector158:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $158
  10259b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025a0:	e9 8c 04 00 00       	jmp    102a31 <__alltraps>

001025a5 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $159
  1025a7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025ac:	e9 80 04 00 00       	jmp    102a31 <__alltraps>

001025b1 <vector160>:
.globl vector160
vector160:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $160
  1025b3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025b8:	e9 74 04 00 00       	jmp    102a31 <__alltraps>

001025bd <vector161>:
.globl vector161
vector161:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $161
  1025bf:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025c4:	e9 68 04 00 00       	jmp    102a31 <__alltraps>

001025c9 <vector162>:
.globl vector162
vector162:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $162
  1025cb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025d0:	e9 5c 04 00 00       	jmp    102a31 <__alltraps>

001025d5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $163
  1025d7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025dc:	e9 50 04 00 00       	jmp    102a31 <__alltraps>

001025e1 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $164
  1025e3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025e8:	e9 44 04 00 00       	jmp    102a31 <__alltraps>

001025ed <vector165>:
.globl vector165
vector165:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $165
  1025ef:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025f4:	e9 38 04 00 00       	jmp    102a31 <__alltraps>

001025f9 <vector166>:
.globl vector166
vector166:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $166
  1025fb:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102600:	e9 2c 04 00 00       	jmp    102a31 <__alltraps>

00102605 <vector167>:
.globl vector167
vector167:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $167
  102607:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10260c:	e9 20 04 00 00       	jmp    102a31 <__alltraps>

00102611 <vector168>:
.globl vector168
vector168:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $168
  102613:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102618:	e9 14 04 00 00       	jmp    102a31 <__alltraps>

0010261d <vector169>:
.globl vector169
vector169:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $169
  10261f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102624:	e9 08 04 00 00       	jmp    102a31 <__alltraps>

00102629 <vector170>:
.globl vector170
vector170:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $170
  10262b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102630:	e9 fc 03 00 00       	jmp    102a31 <__alltraps>

00102635 <vector171>:
.globl vector171
vector171:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $171
  102637:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10263c:	e9 f0 03 00 00       	jmp    102a31 <__alltraps>

00102641 <vector172>:
.globl vector172
vector172:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $172
  102643:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102648:	e9 e4 03 00 00       	jmp    102a31 <__alltraps>

0010264d <vector173>:
.globl vector173
vector173:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $173
  10264f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102654:	e9 d8 03 00 00       	jmp    102a31 <__alltraps>

00102659 <vector174>:
.globl vector174
vector174:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $174
  10265b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102660:	e9 cc 03 00 00       	jmp    102a31 <__alltraps>

00102665 <vector175>:
.globl vector175
vector175:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $175
  102667:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10266c:	e9 c0 03 00 00       	jmp    102a31 <__alltraps>

00102671 <vector176>:
.globl vector176
vector176:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $176
  102673:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102678:	e9 b4 03 00 00       	jmp    102a31 <__alltraps>

0010267d <vector177>:
.globl vector177
vector177:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $177
  10267f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102684:	e9 a8 03 00 00       	jmp    102a31 <__alltraps>

00102689 <vector178>:
.globl vector178
vector178:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $178
  10268b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102690:	e9 9c 03 00 00       	jmp    102a31 <__alltraps>

00102695 <vector179>:
.globl vector179
vector179:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $179
  102697:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10269c:	e9 90 03 00 00       	jmp    102a31 <__alltraps>

001026a1 <vector180>:
.globl vector180
vector180:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $180
  1026a3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026a8:	e9 84 03 00 00       	jmp    102a31 <__alltraps>

001026ad <vector181>:
.globl vector181
vector181:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $181
  1026af:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026b4:	e9 78 03 00 00       	jmp    102a31 <__alltraps>

001026b9 <vector182>:
.globl vector182
vector182:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $182
  1026bb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026c0:	e9 6c 03 00 00       	jmp    102a31 <__alltraps>

001026c5 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $183
  1026c7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026cc:	e9 60 03 00 00       	jmp    102a31 <__alltraps>

001026d1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $184
  1026d3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026d8:	e9 54 03 00 00       	jmp    102a31 <__alltraps>

001026dd <vector185>:
.globl vector185
vector185:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $185
  1026df:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026e4:	e9 48 03 00 00       	jmp    102a31 <__alltraps>

001026e9 <vector186>:
.globl vector186
vector186:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $186
  1026eb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026f0:	e9 3c 03 00 00       	jmp    102a31 <__alltraps>

001026f5 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $187
  1026f7:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026fc:	e9 30 03 00 00       	jmp    102a31 <__alltraps>

00102701 <vector188>:
.globl vector188
vector188:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $188
  102703:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102708:	e9 24 03 00 00       	jmp    102a31 <__alltraps>

0010270d <vector189>:
.globl vector189
vector189:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $189
  10270f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102714:	e9 18 03 00 00       	jmp    102a31 <__alltraps>

00102719 <vector190>:
.globl vector190
vector190:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $190
  10271b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102720:	e9 0c 03 00 00       	jmp    102a31 <__alltraps>

00102725 <vector191>:
.globl vector191
vector191:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $191
  102727:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10272c:	e9 00 03 00 00       	jmp    102a31 <__alltraps>

00102731 <vector192>:
.globl vector192
vector192:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $192
  102733:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102738:	e9 f4 02 00 00       	jmp    102a31 <__alltraps>

0010273d <vector193>:
.globl vector193
vector193:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $193
  10273f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102744:	e9 e8 02 00 00       	jmp    102a31 <__alltraps>

00102749 <vector194>:
.globl vector194
vector194:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $194
  10274b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102750:	e9 dc 02 00 00       	jmp    102a31 <__alltraps>

00102755 <vector195>:
.globl vector195
vector195:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $195
  102757:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10275c:	e9 d0 02 00 00       	jmp    102a31 <__alltraps>

00102761 <vector196>:
.globl vector196
vector196:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $196
  102763:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102768:	e9 c4 02 00 00       	jmp    102a31 <__alltraps>

0010276d <vector197>:
.globl vector197
vector197:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $197
  10276f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102774:	e9 b8 02 00 00       	jmp    102a31 <__alltraps>

00102779 <vector198>:
.globl vector198
vector198:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $198
  10277b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102780:	e9 ac 02 00 00       	jmp    102a31 <__alltraps>

00102785 <vector199>:
.globl vector199
vector199:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $199
  102787:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10278c:	e9 a0 02 00 00       	jmp    102a31 <__alltraps>

00102791 <vector200>:
.globl vector200
vector200:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $200
  102793:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102798:	e9 94 02 00 00       	jmp    102a31 <__alltraps>

0010279d <vector201>:
.globl vector201
vector201:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $201
  10279f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027a4:	e9 88 02 00 00       	jmp    102a31 <__alltraps>

001027a9 <vector202>:
.globl vector202
vector202:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $202
  1027ab:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027b0:	e9 7c 02 00 00       	jmp    102a31 <__alltraps>

001027b5 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $203
  1027b7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027bc:	e9 70 02 00 00       	jmp    102a31 <__alltraps>

001027c1 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $204
  1027c3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027c8:	e9 64 02 00 00       	jmp    102a31 <__alltraps>

001027cd <vector205>:
.globl vector205
vector205:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $205
  1027cf:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027d4:	e9 58 02 00 00       	jmp    102a31 <__alltraps>

001027d9 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $206
  1027db:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027e0:	e9 4c 02 00 00       	jmp    102a31 <__alltraps>

001027e5 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $207
  1027e7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027ec:	e9 40 02 00 00       	jmp    102a31 <__alltraps>

001027f1 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $208
  1027f3:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027f8:	e9 34 02 00 00       	jmp    102a31 <__alltraps>

001027fd <vector209>:
.globl vector209
vector209:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $209
  1027ff:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102804:	e9 28 02 00 00       	jmp    102a31 <__alltraps>

00102809 <vector210>:
.globl vector210
vector210:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $210
  10280b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102810:	e9 1c 02 00 00       	jmp    102a31 <__alltraps>

00102815 <vector211>:
.globl vector211
vector211:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $211
  102817:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10281c:	e9 10 02 00 00       	jmp    102a31 <__alltraps>

00102821 <vector212>:
.globl vector212
vector212:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $212
  102823:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102828:	e9 04 02 00 00       	jmp    102a31 <__alltraps>

0010282d <vector213>:
.globl vector213
vector213:
  pushl $0
  10282d:	6a 00                	push   $0x0
  pushl $213
  10282f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102834:	e9 f8 01 00 00       	jmp    102a31 <__alltraps>

00102839 <vector214>:
.globl vector214
vector214:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $214
  10283b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102840:	e9 ec 01 00 00       	jmp    102a31 <__alltraps>

00102845 <vector215>:
.globl vector215
vector215:
  pushl $0
  102845:	6a 00                	push   $0x0
  pushl $215
  102847:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10284c:	e9 e0 01 00 00       	jmp    102a31 <__alltraps>

00102851 <vector216>:
.globl vector216
vector216:
  pushl $0
  102851:	6a 00                	push   $0x0
  pushl $216
  102853:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102858:	e9 d4 01 00 00       	jmp    102a31 <__alltraps>

0010285d <vector217>:
.globl vector217
vector217:
  pushl $0
  10285d:	6a 00                	push   $0x0
  pushl $217
  10285f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102864:	e9 c8 01 00 00       	jmp    102a31 <__alltraps>

00102869 <vector218>:
.globl vector218
vector218:
  pushl $0
  102869:	6a 00                	push   $0x0
  pushl $218
  10286b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102870:	e9 bc 01 00 00       	jmp    102a31 <__alltraps>

00102875 <vector219>:
.globl vector219
vector219:
  pushl $0
  102875:	6a 00                	push   $0x0
  pushl $219
  102877:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10287c:	e9 b0 01 00 00       	jmp    102a31 <__alltraps>

00102881 <vector220>:
.globl vector220
vector220:
  pushl $0
  102881:	6a 00                	push   $0x0
  pushl $220
  102883:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102888:	e9 a4 01 00 00       	jmp    102a31 <__alltraps>

0010288d <vector221>:
.globl vector221
vector221:
  pushl $0
  10288d:	6a 00                	push   $0x0
  pushl $221
  10288f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102894:	e9 98 01 00 00       	jmp    102a31 <__alltraps>

00102899 <vector222>:
.globl vector222
vector222:
  pushl $0
  102899:	6a 00                	push   $0x0
  pushl $222
  10289b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028a0:	e9 8c 01 00 00       	jmp    102a31 <__alltraps>

001028a5 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028a5:	6a 00                	push   $0x0
  pushl $223
  1028a7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028ac:	e9 80 01 00 00       	jmp    102a31 <__alltraps>

001028b1 <vector224>:
.globl vector224
vector224:
  pushl $0
  1028b1:	6a 00                	push   $0x0
  pushl $224
  1028b3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028b8:	e9 74 01 00 00       	jmp    102a31 <__alltraps>

001028bd <vector225>:
.globl vector225
vector225:
  pushl $0
  1028bd:	6a 00                	push   $0x0
  pushl $225
  1028bf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028c4:	e9 68 01 00 00       	jmp    102a31 <__alltraps>

001028c9 <vector226>:
.globl vector226
vector226:
  pushl $0
  1028c9:	6a 00                	push   $0x0
  pushl $226
  1028cb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028d0:	e9 5c 01 00 00       	jmp    102a31 <__alltraps>

001028d5 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028d5:	6a 00                	push   $0x0
  pushl $227
  1028d7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028dc:	e9 50 01 00 00       	jmp    102a31 <__alltraps>

001028e1 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028e1:	6a 00                	push   $0x0
  pushl $228
  1028e3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028e8:	e9 44 01 00 00       	jmp    102a31 <__alltraps>

001028ed <vector229>:
.globl vector229
vector229:
  pushl $0
  1028ed:	6a 00                	push   $0x0
  pushl $229
  1028ef:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028f4:	e9 38 01 00 00       	jmp    102a31 <__alltraps>

001028f9 <vector230>:
.globl vector230
vector230:
  pushl $0
  1028f9:	6a 00                	push   $0x0
  pushl $230
  1028fb:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102900:	e9 2c 01 00 00       	jmp    102a31 <__alltraps>

00102905 <vector231>:
.globl vector231
vector231:
  pushl $0
  102905:	6a 00                	push   $0x0
  pushl $231
  102907:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10290c:	e9 20 01 00 00       	jmp    102a31 <__alltraps>

00102911 <vector232>:
.globl vector232
vector232:
  pushl $0
  102911:	6a 00                	push   $0x0
  pushl $232
  102913:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102918:	e9 14 01 00 00       	jmp    102a31 <__alltraps>

0010291d <vector233>:
.globl vector233
vector233:
  pushl $0
  10291d:	6a 00                	push   $0x0
  pushl $233
  10291f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102924:	e9 08 01 00 00       	jmp    102a31 <__alltraps>

00102929 <vector234>:
.globl vector234
vector234:
  pushl $0
  102929:	6a 00                	push   $0x0
  pushl $234
  10292b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102930:	e9 fc 00 00 00       	jmp    102a31 <__alltraps>

00102935 <vector235>:
.globl vector235
vector235:
  pushl $0
  102935:	6a 00                	push   $0x0
  pushl $235
  102937:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10293c:	e9 f0 00 00 00       	jmp    102a31 <__alltraps>

00102941 <vector236>:
.globl vector236
vector236:
  pushl $0
  102941:	6a 00                	push   $0x0
  pushl $236
  102943:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102948:	e9 e4 00 00 00       	jmp    102a31 <__alltraps>

0010294d <vector237>:
.globl vector237
vector237:
  pushl $0
  10294d:	6a 00                	push   $0x0
  pushl $237
  10294f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102954:	e9 d8 00 00 00       	jmp    102a31 <__alltraps>

00102959 <vector238>:
.globl vector238
vector238:
  pushl $0
  102959:	6a 00                	push   $0x0
  pushl $238
  10295b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102960:	e9 cc 00 00 00       	jmp    102a31 <__alltraps>

00102965 <vector239>:
.globl vector239
vector239:
  pushl $0
  102965:	6a 00                	push   $0x0
  pushl $239
  102967:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10296c:	e9 c0 00 00 00       	jmp    102a31 <__alltraps>

00102971 <vector240>:
.globl vector240
vector240:
  pushl $0
  102971:	6a 00                	push   $0x0
  pushl $240
  102973:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102978:	e9 b4 00 00 00       	jmp    102a31 <__alltraps>

0010297d <vector241>:
.globl vector241
vector241:
  pushl $0
  10297d:	6a 00                	push   $0x0
  pushl $241
  10297f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102984:	e9 a8 00 00 00       	jmp    102a31 <__alltraps>

00102989 <vector242>:
.globl vector242
vector242:
  pushl $0
  102989:	6a 00                	push   $0x0
  pushl $242
  10298b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102990:	e9 9c 00 00 00       	jmp    102a31 <__alltraps>

00102995 <vector243>:
.globl vector243
vector243:
  pushl $0
  102995:	6a 00                	push   $0x0
  pushl $243
  102997:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10299c:	e9 90 00 00 00       	jmp    102a31 <__alltraps>

001029a1 <vector244>:
.globl vector244
vector244:
  pushl $0
  1029a1:	6a 00                	push   $0x0
  pushl $244
  1029a3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029a8:	e9 84 00 00 00       	jmp    102a31 <__alltraps>

001029ad <vector245>:
.globl vector245
vector245:
  pushl $0
  1029ad:	6a 00                	push   $0x0
  pushl $245
  1029af:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029b4:	e9 78 00 00 00       	jmp    102a31 <__alltraps>

001029b9 <vector246>:
.globl vector246
vector246:
  pushl $0
  1029b9:	6a 00                	push   $0x0
  pushl $246
  1029bb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029c0:	e9 6c 00 00 00       	jmp    102a31 <__alltraps>

001029c5 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029c5:	6a 00                	push   $0x0
  pushl $247
  1029c7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029cc:	e9 60 00 00 00       	jmp    102a31 <__alltraps>

001029d1 <vector248>:
.globl vector248
vector248:
  pushl $0
  1029d1:	6a 00                	push   $0x0
  pushl $248
  1029d3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029d8:	e9 54 00 00 00       	jmp    102a31 <__alltraps>

001029dd <vector249>:
.globl vector249
vector249:
  pushl $0
  1029dd:	6a 00                	push   $0x0
  pushl $249
  1029df:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029e4:	e9 48 00 00 00       	jmp    102a31 <__alltraps>

001029e9 <vector250>:
.globl vector250
vector250:
  pushl $0
  1029e9:	6a 00                	push   $0x0
  pushl $250
  1029eb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029f0:	e9 3c 00 00 00       	jmp    102a31 <__alltraps>

001029f5 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029f5:	6a 00                	push   $0x0
  pushl $251
  1029f7:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029fc:	e9 30 00 00 00       	jmp    102a31 <__alltraps>

00102a01 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a01:	6a 00                	push   $0x0
  pushl $252
  102a03:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a08:	e9 24 00 00 00       	jmp    102a31 <__alltraps>

00102a0d <vector253>:
.globl vector253
vector253:
  pushl $0
  102a0d:	6a 00                	push   $0x0
  pushl $253
  102a0f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a14:	e9 18 00 00 00       	jmp    102a31 <__alltraps>

00102a19 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a19:	6a 00                	push   $0x0
  pushl $254
  102a1b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a20:	e9 0c 00 00 00       	jmp    102a31 <__alltraps>

00102a25 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a25:	6a 00                	push   $0x0
  pushl $255
  102a27:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a2c:	e9 00 00 00 00       	jmp    102a31 <__alltraps>

00102a31 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a31:	1e                   	push   %ds
    pushl %es
  102a32:	06                   	push   %es
    pushl %fs
  102a33:	0f a0                	push   %fs
    pushl %gs
  102a35:	0f a8                	push   %gs
    pushal
  102a37:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a38:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a3d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a3f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a41:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a42:	e8 63 f5 ff ff       	call   101faa <trap>

    # pop the pushed stack pointer
    popl %esp
  102a47:	5c                   	pop    %esp

00102a48 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a48:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a49:	0f a9                	pop    %gs
    popl %fs
  102a4b:	0f a1                	pop    %fs
    popl %es
  102a4d:	07                   	pop    %es
    popl %ds
  102a4e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a4f:	83 c4 08             	add    $0x8,%esp
    iret
  102a52:	cf                   	iret   

00102a53 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a53:	55                   	push   %ebp
  102a54:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a56:	8b 45 08             	mov    0x8(%ebp),%eax
  102a59:	8b 15 64 a9 11 00    	mov    0x11a964,%edx
  102a5f:	29 d0                	sub    %edx,%eax
  102a61:	c1 f8 02             	sar    $0x2,%eax
  102a64:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a6a:	5d                   	pop    %ebp
  102a6b:	c3                   	ret    

00102a6c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a6c:	55                   	push   %ebp
  102a6d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  102a6f:	ff 75 08             	pushl  0x8(%ebp)
  102a72:	e8 dc ff ff ff       	call   102a53 <page2ppn>
  102a77:	83 c4 04             	add    $0x4,%esp
  102a7a:	c1 e0 0c             	shl    $0xc,%eax
}
  102a7d:	c9                   	leave  
  102a7e:	c3                   	ret    

00102a7f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102a7f:	55                   	push   %ebp
  102a80:	89 e5                	mov    %esp,%ebp
  102a82:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  102a85:	8b 45 08             	mov    0x8(%ebp),%eax
  102a88:	c1 e8 0c             	shr    $0xc,%eax
  102a8b:	89 c2                	mov    %eax,%edx
  102a8d:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  102a92:	39 c2                	cmp    %eax,%edx
  102a94:	72 14                	jb     102aaa <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  102a96:	83 ec 04             	sub    $0x4,%esp
  102a99:	68 50 70 10 00       	push   $0x107050
  102a9e:	6a 5a                	push   $0x5a
  102aa0:	68 6f 70 10 00       	push   $0x10706f
  102aa5:	e8 23 d9 ff ff       	call   1003cd <__panic>
    }
    return &pages[PPN(pa)];
  102aaa:	8b 0d 64 a9 11 00    	mov    0x11a964,%ecx
  102ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab3:	c1 e8 0c             	shr    $0xc,%eax
  102ab6:	89 c2                	mov    %eax,%edx
  102ab8:	89 d0                	mov    %edx,%eax
  102aba:	c1 e0 02             	shl    $0x2,%eax
  102abd:	01 d0                	add    %edx,%eax
  102abf:	c1 e0 02             	shl    $0x2,%eax
  102ac2:	01 c8                	add    %ecx,%eax
}
  102ac4:	c9                   	leave  
  102ac5:	c3                   	ret    

00102ac6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102ac6:	55                   	push   %ebp
  102ac7:	89 e5                	mov    %esp,%ebp
  102ac9:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  102acc:	ff 75 08             	pushl  0x8(%ebp)
  102acf:	e8 98 ff ff ff       	call   102a6c <page2pa>
  102ad4:	83 c4 04             	add    $0x4,%esp
  102ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102add:	c1 e8 0c             	shr    $0xc,%eax
  102ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ae3:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  102ae8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102aeb:	72 14                	jb     102b01 <page2kva+0x3b>
  102aed:	ff 75 f4             	pushl  -0xc(%ebp)
  102af0:	68 80 70 10 00       	push   $0x107080
  102af5:	6a 61                	push   $0x61
  102af7:	68 6f 70 10 00       	push   $0x10706f
  102afc:	e8 cc d8 ff ff       	call   1003cd <__panic>
  102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b04:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102b09:	c9                   	leave  
  102b0a:	c3                   	ret    

00102b0b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102b0b:	55                   	push   %ebp
  102b0c:	89 e5                	mov    %esp,%ebp
  102b0e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102b11:	8b 45 08             	mov    0x8(%ebp),%eax
  102b14:	83 e0 01             	and    $0x1,%eax
  102b17:	85 c0                	test   %eax,%eax
  102b19:	75 14                	jne    102b2f <pte2page+0x24>
        panic("pte2page called with invalid pte");
  102b1b:	83 ec 04             	sub    $0x4,%esp
  102b1e:	68 a4 70 10 00       	push   $0x1070a4
  102b23:	6a 6c                	push   $0x6c
  102b25:	68 6f 70 10 00       	push   $0x10706f
  102b2a:	e8 9e d8 ff ff       	call   1003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b37:	83 ec 0c             	sub    $0xc,%esp
  102b3a:	50                   	push   %eax
  102b3b:	e8 3f ff ff ff       	call   102a7f <pa2page>
  102b40:	83 c4 10             	add    $0x10,%esp
}
  102b43:	c9                   	leave  
  102b44:	c3                   	ret    

00102b45 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102b45:	55                   	push   %ebp
  102b46:	89 e5                	mov    %esp,%ebp
  102b48:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b53:	83 ec 0c             	sub    $0xc,%esp
  102b56:	50                   	push   %eax
  102b57:	e8 23 ff ff ff       	call   102a7f <pa2page>
  102b5c:	83 c4 10             	add    $0x10,%esp
}
  102b5f:	c9                   	leave  
  102b60:	c3                   	ret    

00102b61 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102b61:	55                   	push   %ebp
  102b62:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102b64:	8b 45 08             	mov    0x8(%ebp),%eax
  102b67:	8b 00                	mov    (%eax),%eax
}
  102b69:	5d                   	pop    %ebp
  102b6a:	c3                   	ret    

00102b6b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102b6b:	55                   	push   %ebp
  102b6c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b74:	89 10                	mov    %edx,(%eax)
}
  102b76:	90                   	nop
  102b77:	5d                   	pop    %ebp
  102b78:	c3                   	ret    

00102b79 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102b79:	55                   	push   %ebp
  102b7a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7f:	8b 00                	mov    (%eax),%eax
  102b81:	8d 50 01             	lea    0x1(%eax),%edx
  102b84:	8b 45 08             	mov    0x8(%ebp),%eax
  102b87:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b89:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8c:	8b 00                	mov    (%eax),%eax
}
  102b8e:	5d                   	pop    %ebp
  102b8f:	c3                   	ret    

00102b90 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102b90:	55                   	push   %ebp
  102b91:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102b93:	8b 45 08             	mov    0x8(%ebp),%eax
  102b96:	8b 00                	mov    (%eax),%eax
  102b98:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9e:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	8b 00                	mov    (%eax),%eax
}
  102ba5:	5d                   	pop    %ebp
  102ba6:	c3                   	ret    

00102ba7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  102ba7:	55                   	push   %ebp
  102ba8:	89 e5                	mov    %esp,%ebp
  102baa:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102bad:	9c                   	pushf  
  102bae:	58                   	pop    %eax
  102baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102bb5:	25 00 02 00 00       	and    $0x200,%eax
  102bba:	85 c0                	test   %eax,%eax
  102bbc:	74 0c                	je     102bca <__intr_save+0x23>
        intr_disable();
  102bbe:	e8 9e ec ff ff       	call   101861 <intr_disable>
        return 1;
  102bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  102bc8:	eb 05                	jmp    102bcf <__intr_save+0x28>
    }
    return 0;
  102bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bcf:	c9                   	leave  
  102bd0:	c3                   	ret    

00102bd1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102bd1:	55                   	push   %ebp
  102bd2:	89 e5                	mov    %esp,%ebp
  102bd4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102bdb:	74 05                	je     102be2 <__intr_restore+0x11>
        intr_enable();
  102bdd:	e8 78 ec ff ff       	call   10185a <intr_enable>
    }
}
  102be2:	90                   	nop
  102be3:	c9                   	leave  
  102be4:	c3                   	ret    

00102be5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102be5:	55                   	push   %ebp
  102be6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102be8:	8b 45 08             	mov    0x8(%ebp),%eax
  102beb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102bee:	b8 23 00 00 00       	mov    $0x23,%eax
  102bf3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102bf5:	b8 23 00 00 00       	mov    $0x23,%eax
  102bfa:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102bfc:	b8 10 00 00 00       	mov    $0x10,%eax
  102c01:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102c03:	b8 10 00 00 00       	mov    $0x10,%eax
  102c08:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102c0a:	b8 10 00 00 00       	mov    $0x10,%eax
  102c0f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102c11:	ea 18 2c 10 00 08 00 	ljmp   $0x8,$0x102c18
}
  102c18:	90                   	nop
  102c19:	5d                   	pop    %ebp
  102c1a:	c3                   	ret    

00102c1b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102c1b:	55                   	push   %ebp
  102c1c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c21:	a3 e4 a8 11 00       	mov    %eax,0x11a8e4
}
  102c26:	90                   	nop
  102c27:	5d                   	pop    %ebp
  102c28:	c3                   	ret    

00102c29 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102c29:	55                   	push   %ebp
  102c2a:	89 e5                	mov    %esp,%ebp
  102c2c:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102c2f:	b8 00 90 11 00       	mov    $0x119000,%eax
  102c34:	50                   	push   %eax
  102c35:	e8 e1 ff ff ff       	call   102c1b <load_esp0>
  102c3a:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102c3d:	66 c7 05 e8 a8 11 00 	movw   $0x10,0x11a8e8
  102c44:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102c46:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102c4d:	68 00 
  102c4f:	b8 e0 a8 11 00       	mov    $0x11a8e0,%eax
  102c54:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102c5a:	b8 e0 a8 11 00       	mov    $0x11a8e0,%eax
  102c5f:	c1 e8 10             	shr    $0x10,%eax
  102c62:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102c67:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c6e:	83 e0 f0             	and    $0xfffffff0,%eax
  102c71:	83 c8 09             	or     $0x9,%eax
  102c74:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c79:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c80:	83 e0 ef             	and    $0xffffffef,%eax
  102c83:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c88:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c8f:	83 e0 9f             	and    $0xffffff9f,%eax
  102c92:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c97:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c9e:	83 c8 80             	or     $0xffffff80,%eax
  102ca1:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102ca6:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102cad:	83 e0 f0             	and    $0xfffffff0,%eax
  102cb0:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102cb5:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102cbc:	83 e0 ef             	and    $0xffffffef,%eax
  102cbf:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102cc4:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102ccb:	83 e0 df             	and    $0xffffffdf,%eax
  102cce:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102cd3:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102cda:	83 c8 40             	or     $0x40,%eax
  102cdd:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102ce2:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102ce9:	83 e0 7f             	and    $0x7f,%eax
  102cec:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102cf1:	b8 e0 a8 11 00       	mov    $0x11a8e0,%eax
  102cf6:	c1 e8 18             	shr    $0x18,%eax
  102cf9:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102cfe:	68 30 9a 11 00       	push   $0x119a30
  102d03:	e8 dd fe ff ff       	call   102be5 <lgdt>
  102d08:	83 c4 04             	add    $0x4,%esp
  102d0b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102d11:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102d15:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102d18:	90                   	nop
  102d19:	c9                   	leave  
  102d1a:	c3                   	ret    

00102d1b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102d1b:	55                   	push   %ebp
  102d1c:	89 e5                	mov    %esp,%ebp
  102d1e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102d21:	c7 05 5c a9 11 00 00 	movl   $0x107b00,0x11a95c
  102d28:	7b 10 00 
	// pmm_manager = &buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
  102d2b:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  102d30:	8b 00                	mov    (%eax),%eax
  102d32:	83 ec 08             	sub    $0x8,%esp
  102d35:	50                   	push   %eax
  102d36:	68 d0 70 10 00       	push   $0x1070d0
  102d3b:	e8 27 d5 ff ff       	call   100267 <cprintf>
  102d40:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102d43:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  102d48:	8b 40 04             	mov    0x4(%eax),%eax
  102d4b:	ff d0                	call   *%eax
}
  102d4d:	90                   	nop
  102d4e:	c9                   	leave  
  102d4f:	c3                   	ret    

00102d50 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102d50:	55                   	push   %ebp
  102d51:	89 e5                	mov    %esp,%ebp
  102d53:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102d56:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  102d5b:	8b 40 08             	mov    0x8(%eax),%eax
  102d5e:	83 ec 08             	sub    $0x8,%esp
  102d61:	ff 75 0c             	pushl  0xc(%ebp)
  102d64:	ff 75 08             	pushl  0x8(%ebp)
  102d67:	ff d0                	call   *%eax
  102d69:	83 c4 10             	add    $0x10,%esp
}
  102d6c:	90                   	nop
  102d6d:	c9                   	leave  
  102d6e:	c3                   	ret    

00102d6f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102d6f:	55                   	push   %ebp
  102d70:	89 e5                	mov    %esp,%ebp
  102d72:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102d7c:	e8 26 fe ff ff       	call   102ba7 <__intr_save>
  102d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102d84:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  102d89:	8b 40 0c             	mov    0xc(%eax),%eax
  102d8c:	83 ec 0c             	sub    $0xc,%esp
  102d8f:	ff 75 08             	pushl  0x8(%ebp)
  102d92:	ff d0                	call   *%eax
  102d94:	83 c4 10             	add    $0x10,%esp
  102d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102d9a:	83 ec 0c             	sub    $0xc,%esp
  102d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  102da0:	e8 2c fe ff ff       	call   102bd1 <__intr_restore>
  102da5:	83 c4 10             	add    $0x10,%esp
    return page;
  102da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102dab:	c9                   	leave  
  102dac:	c3                   	ret    

00102dad <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102dad:	55                   	push   %ebp
  102dae:	89 e5                	mov    %esp,%ebp
  102db0:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102db3:	e8 ef fd ff ff       	call   102ba7 <__intr_save>
  102db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102dbb:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  102dc0:	8b 40 10             	mov    0x10(%eax),%eax
  102dc3:	83 ec 08             	sub    $0x8,%esp
  102dc6:	ff 75 0c             	pushl  0xc(%ebp)
  102dc9:	ff 75 08             	pushl  0x8(%ebp)
  102dcc:	ff d0                	call   *%eax
  102dce:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102dd1:	83 ec 0c             	sub    $0xc,%esp
  102dd4:	ff 75 f4             	pushl  -0xc(%ebp)
  102dd7:	e8 f5 fd ff ff       	call   102bd1 <__intr_restore>
  102ddc:	83 c4 10             	add    $0x10,%esp
}
  102ddf:	90                   	nop
  102de0:	c9                   	leave  
  102de1:	c3                   	ret    

00102de2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102de2:	55                   	push   %ebp
  102de3:	89 e5                	mov    %esp,%ebp
  102de5:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102de8:	e8 ba fd ff ff       	call   102ba7 <__intr_save>
  102ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102df0:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  102df5:	8b 40 14             	mov    0x14(%eax),%eax
  102df8:	ff d0                	call   *%eax
  102dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102dfd:	83 ec 0c             	sub    $0xc,%esp
  102e00:	ff 75 f4             	pushl  -0xc(%ebp)
  102e03:	e8 c9 fd ff ff       	call   102bd1 <__intr_restore>
  102e08:	83 c4 10             	add    $0x10,%esp
    return ret;
  102e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102e0e:	c9                   	leave  
  102e0f:	c3                   	ret    

00102e10 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102e10:	55                   	push   %ebp
  102e11:	89 e5                	mov    %esp,%ebp
  102e13:	57                   	push   %edi
  102e14:	56                   	push   %esi
  102e15:	53                   	push   %ebx
  102e16:	83 ec 7c             	sub    $0x7c,%esp
	// e820map is at 0xC0008000 (PA) defined in bootloader.
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102e19:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102e20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102e27:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102e2e:	83 ec 0c             	sub    $0xc,%esp
  102e31:	68 e7 70 10 00       	push   $0x1070e7
  102e36:	e8 2c d4 ff ff       	call   100267 <cprintf>
  102e3b:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102e3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e45:	e9 fc 00 00 00       	jmp    102f46 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e4a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e50:	89 d0                	mov    %edx,%eax
  102e52:	c1 e0 02             	shl    $0x2,%eax
  102e55:	01 d0                	add    %edx,%eax
  102e57:	c1 e0 02             	shl    $0x2,%eax
  102e5a:	01 c8                	add    %ecx,%eax
  102e5c:	8b 50 08             	mov    0x8(%eax),%edx
  102e5f:	8b 40 04             	mov    0x4(%eax),%eax
  102e62:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102e65:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102e68:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e6e:	89 d0                	mov    %edx,%eax
  102e70:	c1 e0 02             	shl    $0x2,%eax
  102e73:	01 d0                	add    %edx,%eax
  102e75:	c1 e0 02             	shl    $0x2,%eax
  102e78:	01 c8                	add    %ecx,%eax
  102e7a:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e7d:	8b 58 10             	mov    0x10(%eax),%ebx
  102e80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e83:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e86:	01 c8                	add    %ecx,%eax
  102e88:	11 da                	adc    %ebx,%edx
  102e8a:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102e8d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102e90:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e96:	89 d0                	mov    %edx,%eax
  102e98:	c1 e0 02             	shl    $0x2,%eax
  102e9b:	01 d0                	add    %edx,%eax
  102e9d:	c1 e0 02             	shl    $0x2,%eax
  102ea0:	01 c8                	add    %ecx,%eax
  102ea2:	83 c0 14             	add    $0x14,%eax
  102ea5:	8b 00                	mov    (%eax),%eax
  102ea7:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102eaa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ead:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102eb0:	83 c0 ff             	add    $0xffffffff,%eax
  102eb3:	83 d2 ff             	adc    $0xffffffff,%edx
  102eb6:	89 c1                	mov    %eax,%ecx
  102eb8:	89 d3                	mov    %edx,%ebx
  102eba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ebd:	89 55 80             	mov    %edx,-0x80(%ebp)
  102ec0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ec3:	89 d0                	mov    %edx,%eax
  102ec5:	c1 e0 02             	shl    $0x2,%eax
  102ec8:	01 d0                	add    %edx,%eax
  102eca:	c1 e0 02             	shl    $0x2,%eax
  102ecd:	03 45 80             	add    -0x80(%ebp),%eax
  102ed0:	8b 50 10             	mov    0x10(%eax),%edx
  102ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  102ed6:	ff 75 84             	pushl  -0x7c(%ebp)
  102ed9:	53                   	push   %ebx
  102eda:	51                   	push   %ecx
  102edb:	ff 75 bc             	pushl  -0x44(%ebp)
  102ede:	ff 75 b8             	pushl  -0x48(%ebp)
  102ee1:	52                   	push   %edx
  102ee2:	50                   	push   %eax
  102ee3:	68 f4 70 10 00       	push   $0x1070f4
  102ee8:	e8 7a d3 ff ff       	call   100267 <cprintf>
  102eed:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102ef0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ef6:	89 d0                	mov    %edx,%eax
  102ef8:	c1 e0 02             	shl    $0x2,%eax
  102efb:	01 d0                	add    %edx,%eax
  102efd:	c1 e0 02             	shl    $0x2,%eax
  102f00:	01 c8                	add    %ecx,%eax
  102f02:	83 c0 14             	add    $0x14,%eax
  102f05:	8b 00                	mov    (%eax),%eax
  102f07:	83 f8 01             	cmp    $0x1,%eax
  102f0a:	75 36                	jne    102f42 <page_init+0x132>
        	// KMEMSIZE restricts the maximum detected physical address.
        	// Thus the block with starting address >= KMEMSIZE will not be recognized.
            if (maxpa < end && begin < KMEMSIZE) {
  102f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f12:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102f15:	77 2b                	ja     102f42 <page_init+0x132>
  102f17:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102f1a:	72 05                	jb     102f21 <page_init+0x111>
  102f1c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102f1f:	73 21                	jae    102f42 <page_init+0x132>
  102f21:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102f25:	77 1b                	ja     102f42 <page_init+0x132>
  102f27:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102f2b:	72 09                	jb     102f36 <page_init+0x126>
  102f2d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102f34:	77 0c                	ja     102f42 <page_init+0x132>
                maxpa = end;
  102f36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f39:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102f3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102f42:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102f46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f49:	8b 00                	mov    (%eax),%eax
  102f4b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102f4e:	0f 8f f6 fe ff ff    	jg     102e4a <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102f54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f58:	72 1d                	jb     102f77 <page_init+0x167>
  102f5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f5e:	77 09                	ja     102f69 <page_init+0x159>
  102f60:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102f67:	76 0e                	jbe    102f77 <page_init+0x167>
        maxpa = KMEMSIZE;
  102f69:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102f70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    // Provided in kernel.ld - End of kernel bss.
    extern char end[];
    cprintf("Detected maxpa = %08llx\n", maxpa);
  102f77:	83 ec 04             	sub    $0x4,%esp
  102f7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  102f7d:	ff 75 e0             	pushl  -0x20(%ebp)
  102f80:	68 24 71 10 00       	push   $0x107124
  102f85:	e8 dd d2 ff ff       	call   100267 <cprintf>
  102f8a:	83 c4 10             	add    $0x10,%esp
    // Here, npage is only used for an estimation of how many entries in the page table.
    npage = maxpa / PGSIZE;
  102f8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f93:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f97:	c1 ea 0c             	shr    $0xc,%edx
  102f9a:	a3 c0 a8 11 00       	mov    %eax,0x11a8c0
    // virtual address of physical pages descriptor array.
    // The array starts at the end of the kernel code.
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102f9f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102fa6:	b8 74 a9 11 00       	mov    $0x11a974,%eax
  102fab:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fae:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102fb1:	01 d0                	add    %edx,%eax
  102fb3:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102fb6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102fb9:	ba 00 00 00 00       	mov    $0x0,%edx
  102fbe:	f7 75 ac             	divl   -0x54(%ebp)
  102fc1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102fc4:	29 d0                	sub    %edx,%eax
  102fc6:	a3 64 a9 11 00       	mov    %eax,0x11a964

    for (i = 0; i < npage; i ++) {
  102fcb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fd2:	eb 2f                	jmp    103003 <page_init+0x1f3>
        SetPageReserved(pages + i);
  102fd4:	8b 0d 64 a9 11 00    	mov    0x11a964,%ecx
  102fda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fdd:	89 d0                	mov    %edx,%eax
  102fdf:	c1 e0 02             	shl    $0x2,%eax
  102fe2:	01 d0                	add    %edx,%eax
  102fe4:	c1 e0 02             	shl    $0x2,%eax
  102fe7:	01 c8                	add    %ecx,%eax
  102fe9:	83 c0 04             	add    $0x4,%eax
  102fec:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102ff3:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ff6:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ff9:	8b 55 90             	mov    -0x70(%ebp),%edx
  102ffc:	0f ab 10             	bts    %edx,(%eax)
    npage = maxpa / PGSIZE;
    // virtual address of physical pages descriptor array.
    // The array starts at the end of the kernel code.
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102fff:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103003:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103006:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  10300b:	39 c2                	cmp    %eax,%edx
  10300d:	72 c5                	jb     102fd4 <page_init+0x1c4>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10300f:	8b 15 c0 a8 11 00    	mov    0x11a8c0,%edx
  103015:	89 d0                	mov    %edx,%eax
  103017:	c1 e0 02             	shl    $0x2,%eax
  10301a:	01 d0                	add    %edx,%eax
  10301c:	c1 e0 02             	shl    $0x2,%eax
  10301f:	89 c2                	mov    %eax,%edx
  103021:	a1 64 a9 11 00       	mov    0x11a964,%eax
  103026:	01 d0                	add    %edx,%eax
  103028:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10302b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103032:	77 17                	ja     10304b <page_init+0x23b>
  103034:	ff 75 a4             	pushl  -0x5c(%ebp)
  103037:	68 40 71 10 00       	push   $0x107140
  10303c:	68 e4 00 00 00       	push   $0xe4
  103041:	68 64 71 10 00       	push   $0x107164
  103046:	e8 82 d3 ff ff       	call   1003cd <__panic>
  10304b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10304e:	05 00 00 00 40       	add    $0x40000000,%eax
  103053:	89 45 a0             	mov    %eax,-0x60(%ebp)

    cprintf("Kernel ends at (va): %08x, Total pages = %d, which takes up %d.\n",
  103056:	8b 15 c0 a8 11 00    	mov    0x11a8c0,%edx
  10305c:	89 d0                	mov    %edx,%eax
  10305e:	c1 e0 02             	shl    $0x2,%eax
  103061:	01 d0                	add    %edx,%eax
  103063:	c1 e0 02             	shl    $0x2,%eax
  103066:	89 c1                	mov    %eax,%ecx
  103068:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  10306d:	ba 74 a9 11 00       	mov    $0x11a974,%edx
  103072:	51                   	push   %ecx
  103073:	50                   	push   %eax
  103074:	52                   	push   %edx
  103075:	68 74 71 10 00       	push   $0x107174
  10307a:	e8 e8 d1 ff ff       	call   100267 <cprintf>
  10307f:	83 c4 10             	add    $0x10,%esp
    		(uintptr_t)end, npage, sizeof(struct Page) * npage);
    cprintf("Freemem = (pa) %08x\n", freemem);
  103082:	83 ec 08             	sub    $0x8,%esp
  103085:	ff 75 a0             	pushl  -0x60(%ebp)
  103088:	68 b5 71 10 00       	push   $0x1071b5
  10308d:	e8 d5 d1 ff ff       	call   100267 <cprintf>
  103092:	83 c4 10             	add    $0x10,%esp

    for (i = 0; i < memmap->nr_map; i ++) {
  103095:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10309c:	e9 85 01 00 00       	jmp    103226 <page_init+0x416>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1030a1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030a7:	89 d0                	mov    %edx,%eax
  1030a9:	c1 e0 02             	shl    $0x2,%eax
  1030ac:	01 d0                	add    %edx,%eax
  1030ae:	c1 e0 02             	shl    $0x2,%eax
  1030b1:	01 c8                	add    %ecx,%eax
  1030b3:	8b 50 08             	mov    0x8(%eax),%edx
  1030b6:	8b 40 04             	mov    0x4(%eax),%eax
  1030b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030bc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030bf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030c5:	89 d0                	mov    %edx,%eax
  1030c7:	c1 e0 02             	shl    $0x2,%eax
  1030ca:	01 d0                	add    %edx,%eax
  1030cc:	c1 e0 02             	shl    $0x2,%eax
  1030cf:	01 c8                	add    %ecx,%eax
  1030d1:	8b 48 0c             	mov    0xc(%eax),%ecx
  1030d4:	8b 58 10             	mov    0x10(%eax),%ebx
  1030d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030dd:	01 c8                	add    %ecx,%eax
  1030df:	11 da                	adc    %ebx,%edx
  1030e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1030e4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1030e7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030ed:	89 d0                	mov    %edx,%eax
  1030ef:	c1 e0 02             	shl    $0x2,%eax
  1030f2:	01 d0                	add    %edx,%eax
  1030f4:	c1 e0 02             	shl    $0x2,%eax
  1030f7:	01 c8                	add    %ecx,%eax
  1030f9:	83 c0 14             	add    $0x14,%eax
  1030fc:	8b 00                	mov    (%eax),%eax
  1030fe:	83 f8 01             	cmp    $0x1,%eax
  103101:	0f 85 1b 01 00 00    	jne    103222 <page_init+0x412>
            if (begin < freemem) {
  103107:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10310a:	ba 00 00 00 00       	mov    $0x0,%edx
  10310f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103112:	72 17                	jb     10312b <page_init+0x31b>
  103114:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103117:	77 05                	ja     10311e <page_init+0x30e>
  103119:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10311c:	76 0d                	jbe    10312b <page_init+0x31b>
                begin = freemem;
  10311e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103121:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103124:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10312b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10312f:	72 1d                	jb     10314e <page_init+0x33e>
  103131:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103135:	77 09                	ja     103140 <page_init+0x330>
  103137:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10313e:	76 0e                	jbe    10314e <page_init+0x33e>
                end = KMEMSIZE;
  103140:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103147:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            // Gather all available blocks and build pages linked list.
            if (begin < end) {
  10314e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103151:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103154:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103157:	0f 87 c5 00 00 00    	ja     103222 <page_init+0x412>
  10315d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103160:	72 09                	jb     10316b <page_init+0x35b>
  103162:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103165:	0f 83 b7 00 00 00    	jae    103222 <page_init+0x412>
                begin = ROUNDUP(begin, PGSIZE);
  10316b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103172:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103175:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103178:	01 d0                	add    %edx,%eax
  10317a:	83 e8 01             	sub    $0x1,%eax
  10317d:	89 45 98             	mov    %eax,-0x68(%ebp)
  103180:	8b 45 98             	mov    -0x68(%ebp),%eax
  103183:	ba 00 00 00 00       	mov    $0x0,%edx
  103188:	f7 75 9c             	divl   -0x64(%ebp)
  10318b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10318e:	29 d0                	sub    %edx,%eax
  103190:	ba 00 00 00 00       	mov    $0x0,%edx
  103195:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103198:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10319b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10319e:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1031a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1031a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1031a9:	89 c3                	mov    %eax,%ebx
  1031ab:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1031b1:	89 de                	mov    %ebx,%esi
  1031b3:	89 d0                	mov    %edx,%eax
  1031b5:	83 e0 00             	and    $0x0,%eax
  1031b8:	89 c7                	mov    %eax,%edi
  1031ba:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1031bd:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1031c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031c6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1031c9:	77 57                	ja     103222 <page_init+0x412>
  1031cb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1031ce:	72 05                	jb     1031d5 <page_init+0x3c5>
  1031d0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1031d3:	73 4d                	jae    103222 <page_init+0x412>
                	cprintf("Detected one allocatable block (pa) start = %08llx, end = %08llx\n", begin, end);
  1031d5:	83 ec 0c             	sub    $0xc,%esp
  1031d8:	ff 75 cc             	pushl  -0x34(%ebp)
  1031db:	ff 75 c8             	pushl  -0x38(%ebp)
  1031de:	ff 75 d4             	pushl  -0x2c(%ebp)
  1031e1:	ff 75 d0             	pushl  -0x30(%ebp)
  1031e4:	68 cc 71 10 00       	push   $0x1071cc
  1031e9:	e8 79 d0 ff ff       	call   100267 <cprintf>
  1031ee:	83 c4 20             	add    $0x20,%esp
                	// pa2page converts physical address into its page descriptor's virtual address.
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1031f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1031f4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1031f7:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1031fa:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1031fd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103201:	c1 ea 0c             	shr    $0xc,%edx
  103204:	89 c3                	mov    %eax,%ebx
  103206:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103209:	83 ec 0c             	sub    $0xc,%esp
  10320c:	50                   	push   %eax
  10320d:	e8 6d f8 ff ff       	call   102a7f <pa2page>
  103212:	83 c4 10             	add    $0x10,%esp
  103215:	83 ec 08             	sub    $0x8,%esp
  103218:	53                   	push   %ebx
  103219:	50                   	push   %eax
  10321a:	e8 31 fb ff ff       	call   102d50 <init_memmap>
  10321f:	83 c4 10             	add    $0x10,%esp

    cprintf("Kernel ends at (va): %08x, Total pages = %d, which takes up %d.\n",
    		(uintptr_t)end, npage, sizeof(struct Page) * npage);
    cprintf("Freemem = (pa) %08x\n", freemem);

    for (i = 0; i < memmap->nr_map; i ++) {
  103222:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103226:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103229:	8b 00                	mov    (%eax),%eax
  10322b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10322e:	0f 8f 6d fe ff ff    	jg     1030a1 <page_init+0x291>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  103234:	90                   	nop
  103235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103238:	5b                   	pop    %ebx
  103239:	5e                   	pop    %esi
  10323a:	5f                   	pop    %edi
  10323b:	5d                   	pop    %ebp
  10323c:	c3                   	ret    

0010323d <enable_paging>:

static void
enable_paging(void) {
  10323d:	55                   	push   %ebp
  10323e:	89 e5                	mov    %esp,%ebp
  103240:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103243:	a1 60 a9 11 00       	mov    0x11a960,%eax
  103248:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10324b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10324e:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103251:	0f 20 c0             	mov    %cr0,%eax
  103254:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103257:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10325a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10325d:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103264:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  103268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10326b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103271:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103274:	90                   	nop
  103275:	c9                   	leave  
  103276:	c3                   	ret    

00103277 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103277:	55                   	push   %ebp
  103278:	89 e5                	mov    %esp,%ebp
  10327a:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10327d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103280:	33 45 14             	xor    0x14(%ebp),%eax
  103283:	25 ff 0f 00 00       	and    $0xfff,%eax
  103288:	85 c0                	test   %eax,%eax
  10328a:	74 19                	je     1032a5 <boot_map_segment+0x2e>
  10328c:	68 0e 72 10 00       	push   $0x10720e
  103291:	68 25 72 10 00       	push   $0x107225
  103296:	68 14 01 00 00       	push   $0x114
  10329b:	68 64 71 10 00       	push   $0x107164
  1032a0:	e8 28 d1 ff ff       	call   1003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1032a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1032ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032af:	25 ff 0f 00 00       	and    $0xfff,%eax
  1032b4:	89 c2                	mov    %eax,%edx
  1032b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1032b9:	01 c2                	add    %eax,%edx
  1032bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032be:	01 d0                	add    %edx,%eax
  1032c0:	83 e8 01             	sub    $0x1,%eax
  1032c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032c9:	ba 00 00 00 00       	mov    $0x0,%edx
  1032ce:	f7 75 f0             	divl   -0x10(%ebp)
  1032d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032d4:	29 d0                	sub    %edx,%eax
  1032d6:	c1 e8 0c             	shr    $0xc,%eax
  1032d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1032ea:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1032ed:	8b 45 14             	mov    0x14(%ebp),%eax
  1032f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1032fb:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1032fe:	eb 57                	jmp    103357 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103300:	83 ec 04             	sub    $0x4,%esp
  103303:	6a 01                	push   $0x1
  103305:	ff 75 0c             	pushl  0xc(%ebp)
  103308:	ff 75 08             	pushl  0x8(%ebp)
  10330b:	e8 98 01 00 00       	call   1034a8 <get_pte>
  103310:	83 c4 10             	add    $0x10,%esp
  103313:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103316:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10331a:	75 19                	jne    103335 <boot_map_segment+0xbe>
  10331c:	68 3a 72 10 00       	push   $0x10723a
  103321:	68 25 72 10 00       	push   $0x107225
  103326:	68 1a 01 00 00       	push   $0x11a
  10332b:	68 64 71 10 00       	push   $0x107164
  103330:	e8 98 d0 ff ff       	call   1003cd <__panic>
        *ptep = pa | PTE_P | perm;
  103335:	8b 45 14             	mov    0x14(%ebp),%eax
  103338:	0b 45 18             	or     0x18(%ebp),%eax
  10333b:	83 c8 01             	or     $0x1,%eax
  10333e:	89 c2                	mov    %eax,%edx
  103340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103343:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103345:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103349:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103350:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10335b:	75 a3                	jne    103300 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10335d:	90                   	nop
  10335e:	c9                   	leave  
  10335f:	c3                   	ret    

00103360 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103360:	55                   	push   %ebp
  103361:	89 e5                	mov    %esp,%ebp
  103363:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  103366:	83 ec 0c             	sub    $0xc,%esp
  103369:	6a 01                	push   $0x1
  10336b:	e8 ff f9 ff ff       	call   102d6f <alloc_pages>
  103370:	83 c4 10             	add    $0x10,%esp
  103373:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10337a:	75 17                	jne    103393 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  10337c:	83 ec 04             	sub    $0x4,%esp
  10337f:	68 47 72 10 00       	push   $0x107247
  103384:	68 26 01 00 00       	push   $0x126
  103389:	68 64 71 10 00       	push   $0x107164
  10338e:	e8 3a d0 ff ff       	call   1003cd <__panic>
    }
    return page2kva(p);
  103393:	83 ec 0c             	sub    $0xc,%esp
  103396:	ff 75 f4             	pushl  -0xc(%ebp)
  103399:	e8 28 f7 ff ff       	call   102ac6 <page2kva>
  10339e:	83 c4 10             	add    $0x10,%esp
}
  1033a1:	c9                   	leave  
  1033a2:	c3                   	ret    

001033a3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1033a3:	55                   	push   %ebp
  1033a4:	89 e5                	mov    %esp,%ebp
  1033a6:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1033a9:	e8 6d f9 ff ff       	call   102d1b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1033ae:	e8 5d fa ff ff       	call   102e10 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1033b3:	e8 2d 04 00 00       	call   1037e5 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1033b8:	e8 a3 ff ff ff       	call   103360 <boot_alloc_page>
  1033bd:	a3 c4 a8 11 00       	mov    %eax,0x11a8c4
    memset(boot_pgdir, 0, PGSIZE);
  1033c2:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  1033c7:	83 ec 04             	sub    $0x4,%esp
  1033ca:	68 00 10 00 00       	push   $0x1000
  1033cf:	6a 00                	push   $0x0
  1033d1:	50                   	push   %eax
  1033d2:	e8 90 2d 00 00       	call   106167 <memset>
  1033d7:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  1033da:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  1033df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033e2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1033e9:	77 17                	ja     103402 <pmm_init+0x5f>
  1033eb:	ff 75 f4             	pushl  -0xc(%ebp)
  1033ee:	68 40 71 10 00       	push   $0x107140
  1033f3:	68 40 01 00 00       	push   $0x140
  1033f8:	68 64 71 10 00       	push   $0x107164
  1033fd:	e8 cb cf ff ff       	call   1003cd <__panic>
  103402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103405:	05 00 00 00 40       	add    $0x40000000,%eax
  10340a:	a3 60 a9 11 00       	mov    %eax,0x11a960

    check_pgdir();
  10340f:	e8 f4 03 00 00       	call   103808 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103414:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103419:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10341f:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103427:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10342e:	77 17                	ja     103447 <pmm_init+0xa4>
  103430:	ff 75 f0             	pushl  -0x10(%ebp)
  103433:	68 40 71 10 00       	push   $0x107140
  103438:	68 48 01 00 00       	push   $0x148
  10343d:	68 64 71 10 00       	push   $0x107164
  103442:	e8 86 cf ff ff       	call   1003cd <__panic>
  103447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10344a:	05 00 00 00 40       	add    $0x40000000,%eax
  10344f:	83 c8 03             	or     $0x3,%eax
  103452:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103454:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103459:	83 ec 0c             	sub    $0xc,%esp
  10345c:	6a 02                	push   $0x2
  10345e:	6a 00                	push   $0x0
  103460:	68 00 00 00 38       	push   $0x38000000
  103465:	68 00 00 00 c0       	push   $0xc0000000
  10346a:	50                   	push   %eax
  10346b:	e8 07 fe ff ff       	call   103277 <boot_map_segment>
  103470:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103473:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103478:	8b 15 c4 a8 11 00    	mov    0x11a8c4,%edx
  10347e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103484:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103486:	e8 b2 fd ff ff       	call   10323d <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10348b:	e8 99 f7 ff ff       	call   102c29 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  103490:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10349b:	e8 ce 08 00 00       	call   103d6e <check_boot_pgdir>

    print_pgdir();
  1034a0:	e8 c4 0c 00 00       	call   104169 <print_pgdir>

}
  1034a5:	90                   	nop
  1034a6:	c9                   	leave  
  1034a7:	c3                   	ret    

001034a8 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1034a8:	55                   	push   %ebp
  1034a9:	89 e5                	mov    %esp,%ebp
  1034ab:	83 ec 28             	sub    $0x28,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    pde_t *pdep = pgdir + PDX(la);   // (1) find page directory entry
  1034ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b1:	c1 e8 16             	shr    $0x16,%eax
  1034b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034be:	01 d0                	add    %edx,%eax
  1034c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep) & PTE_P) != 1) {              // (2) check if entry is not present
  1034c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034c6:	8b 00                	mov    (%eax),%eax
  1034c8:	83 e0 01             	and    $0x1,%eax
  1034cb:	85 c0                	test   %eax,%eax
  1034cd:	0f 85 bd 00 00 00    	jne    103590 <get_pte+0xe8>
        if (!create) return NULL;                  // (3) check if creating is needed, then alloc page for page table
  1034d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1034d7:	75 0a                	jne    1034e3 <get_pte+0x3b>
  1034d9:	b8 00 00 00 00       	mov    $0x0,%eax
  1034de:	e9 fe 00 00 00       	jmp    1035e1 <get_pte+0x139>
        struct Page* ptPage;
        assert(ptPage = alloc_page());
  1034e3:	83 ec 0c             	sub    $0xc,%esp
  1034e6:	6a 01                	push   $0x1
  1034e8:	e8 82 f8 ff ff       	call   102d6f <alloc_pages>
  1034ed:	83 c4 10             	add    $0x10,%esp
  1034f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1034f7:	75 19                	jne    103512 <get_pte+0x6a>
  1034f9:	68 60 72 10 00       	push   $0x107260
  1034fe:	68 25 72 10 00       	push   $0x107225
  103503:	68 87 01 00 00       	push   $0x187
  103508:	68 64 71 10 00       	push   $0x107164
  10350d:	e8 bb ce ff ff       	call   1003cd <__panic>
        set_page_ref(ptPage, 1);         // (4) set page reference
  103512:	83 ec 08             	sub    $0x8,%esp
  103515:	6a 01                	push   $0x1
  103517:	ff 75 f0             	pushl  -0x10(%ebp)
  10351a:	e8 4c f6 ff ff       	call   102b6b <set_page_ref>
  10351f:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(ptPage); // (5) get linear address of page
  103522:	83 ec 0c             	sub    $0xc,%esp
  103525:	ff 75 f0             	pushl  -0x10(%ebp)
  103528:	e8 3f f5 ff ff       	call   102a6c <page2pa>
  10352d:	83 c4 10             	add    $0x10,%esp
  103530:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);   // (6) clear page content using memset
  103533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103536:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10353c:	c1 e8 0c             	shr    $0xc,%eax
  10353f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103542:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  103547:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10354a:	72 17                	jb     103563 <get_pte+0xbb>
  10354c:	ff 75 e8             	pushl  -0x18(%ebp)
  10354f:	68 80 70 10 00       	push   $0x107080
  103554:	68 8a 01 00 00       	push   $0x18a
  103559:	68 64 71 10 00       	push   $0x107164
  10355e:	e8 6a ce ff ff       	call   1003cd <__panic>
  103563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103566:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10356b:	83 ec 04             	sub    $0x4,%esp
  10356e:	68 00 10 00 00       	push   $0x1000
  103573:	6a 00                	push   $0x0
  103575:	50                   	push   %eax
  103576:	e8 ec 2b 00 00       	call   106167 <memset>
  10357b:	83 c4 10             	add    $0x10,%esp
        *pdep = ((pa & ~0x0FFF) | PTE_U | PTE_W | PTE_P);                  // (7) set page directory entry's permission
  10357e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103581:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103586:	83 c8 07             	or     $0x7,%eax
  103589:	89 c2                	mov    %eax,%edx
  10358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10358e:	89 10                	mov    %edx,(%eax)
    }
    return ((pte_t*)KADDR((*pdep) & ~0xFFF)) + PTX(la);          // (8) return page table entry
  103590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103593:	8b 00                	mov    (%eax),%eax
  103595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10359a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10359d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035a0:	c1 e8 0c             	shr    $0xc,%eax
  1035a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1035a6:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  1035ab:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1035ae:	72 17                	jb     1035c7 <get_pte+0x11f>
  1035b0:	ff 75 e0             	pushl  -0x20(%ebp)
  1035b3:	68 80 70 10 00       	push   $0x107080
  1035b8:	68 8d 01 00 00       	push   $0x18d
  1035bd:	68 64 71 10 00       	push   $0x107164
  1035c2:	e8 06 ce ff ff       	call   1003cd <__panic>
  1035c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035ca:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1035cf:	89 c2                	mov    %eax,%edx
  1035d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d4:	c1 e8 0c             	shr    $0xc,%eax
  1035d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  1035dc:	c1 e0 02             	shl    $0x2,%eax
  1035df:	01 d0                	add    %edx,%eax
}
  1035e1:	c9                   	leave  
  1035e2:	c3                   	ret    

001035e3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1035e3:	55                   	push   %ebp
  1035e4:	89 e5                	mov    %esp,%ebp
  1035e6:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1035e9:	83 ec 04             	sub    $0x4,%esp
  1035ec:	6a 00                	push   $0x0
  1035ee:	ff 75 0c             	pushl  0xc(%ebp)
  1035f1:	ff 75 08             	pushl  0x8(%ebp)
  1035f4:	e8 af fe ff ff       	call   1034a8 <get_pte>
  1035f9:	83 c4 10             	add    $0x10,%esp
  1035fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1035ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103603:	74 08                	je     10360d <get_page+0x2a>
        *ptep_store = ptep;
  103605:	8b 45 10             	mov    0x10(%ebp),%eax
  103608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10360b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10360d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103611:	74 1f                	je     103632 <get_page+0x4f>
  103613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103616:	8b 00                	mov    (%eax),%eax
  103618:	83 e0 01             	and    $0x1,%eax
  10361b:	85 c0                	test   %eax,%eax
  10361d:	74 13                	je     103632 <get_page+0x4f>
        return pte2page(*ptep);
  10361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103622:	8b 00                	mov    (%eax),%eax
  103624:	83 ec 0c             	sub    $0xc,%esp
  103627:	50                   	push   %eax
  103628:	e8 de f4 ff ff       	call   102b0b <pte2page>
  10362d:	83 c4 10             	add    $0x10,%esp
  103630:	eb 05                	jmp    103637 <get_page+0x54>
    }
    return NULL;
  103632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103637:	c9                   	leave  
  103638:	c3                   	ret    

00103639 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103639:	55                   	push   %ebp
  10363a:	89 e5                	mov    %esp,%ebp
  10363c:	83 ec 18             	sub    $0x18,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    if (((*ptep) & PTE_P) == 1) {                      //(1) check if this page table entry is present
  10363f:	8b 45 10             	mov    0x10(%ebp),%eax
  103642:	8b 00                	mov    (%eax),%eax
  103644:	83 e0 01             	and    $0x1,%eax
  103647:	85 c0                	test   %eax,%eax
  103649:	74 55                	je     1036a0 <page_remove_pte+0x67>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
  10364b:	8b 45 10             	mov    0x10(%ebp),%eax
  10364e:	8b 00                	mov    (%eax),%eax
  103650:	83 ec 0c             	sub    $0xc,%esp
  103653:	50                   	push   %eax
  103654:	e8 b2 f4 ff ff       	call   102b0b <pte2page>
  103659:	83 c4 10             	add    $0x10,%esp
  10365c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
  10365f:	83 ec 0c             	sub    $0xc,%esp
  103662:	ff 75 f4             	pushl  -0xc(%ebp)
  103665:	e8 26 f5 ff ff       	call   102b90 <page_ref_dec>
  10366a:	83 c4 10             	add    $0x10,%esp
        if (page->ref == 0) {
  10366d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103670:	8b 00                	mov    (%eax),%eax
  103672:	85 c0                	test   %eax,%eax
  103674:	75 10                	jne    103686 <page_remove_pte+0x4d>
        	free_page(page);           //(4) and free this page when page reference reachs 0
  103676:	83 ec 08             	sub    $0x8,%esp
  103679:	6a 01                	push   $0x1
  10367b:	ff 75 f4             	pushl  -0xc(%ebp)
  10367e:	e8 2a f7 ff ff       	call   102dad <free_pages>
  103683:	83 c4 10             	add    $0x10,%esp
        }
        (*ptep) = 0;                          //(5) clear second page table entry
  103686:	8b 45 10             	mov    0x10(%ebp),%eax
  103689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
  10368f:	83 ec 08             	sub    $0x8,%esp
  103692:	ff 75 0c             	pushl  0xc(%ebp)
  103695:	ff 75 08             	pushl  0x8(%ebp)
  103698:	e8 f8 00 00 00       	call   103795 <tlb_invalidate>
  10369d:	83 c4 10             	add    $0x10,%esp
    }
    // Should I check whether all entries in PT is not present and recycle the PT?
    // Then Maybe I should set the pde to be not present.
}
  1036a0:	90                   	nop
  1036a1:	c9                   	leave  
  1036a2:	c3                   	ret    

001036a3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1036a3:	55                   	push   %ebp
  1036a4:	89 e5                	mov    %esp,%ebp
  1036a6:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1036a9:	83 ec 04             	sub    $0x4,%esp
  1036ac:	6a 00                	push   $0x0
  1036ae:	ff 75 0c             	pushl  0xc(%ebp)
  1036b1:	ff 75 08             	pushl  0x8(%ebp)
  1036b4:	e8 ef fd ff ff       	call   1034a8 <get_pte>
  1036b9:	83 c4 10             	add    $0x10,%esp
  1036bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1036bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036c3:	74 14                	je     1036d9 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  1036c5:	83 ec 04             	sub    $0x4,%esp
  1036c8:	ff 75 f4             	pushl  -0xc(%ebp)
  1036cb:	ff 75 0c             	pushl  0xc(%ebp)
  1036ce:	ff 75 08             	pushl  0x8(%ebp)
  1036d1:	e8 63 ff ff ff       	call   103639 <page_remove_pte>
  1036d6:	83 c4 10             	add    $0x10,%esp
    }
}
  1036d9:	90                   	nop
  1036da:	c9                   	leave  
  1036db:	c3                   	ret    

001036dc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1036dc:	55                   	push   %ebp
  1036dd:	89 e5                	mov    %esp,%ebp
  1036df:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1036e2:	83 ec 04             	sub    $0x4,%esp
  1036e5:	6a 01                	push   $0x1
  1036e7:	ff 75 10             	pushl  0x10(%ebp)
  1036ea:	ff 75 08             	pushl  0x8(%ebp)
  1036ed:	e8 b6 fd ff ff       	call   1034a8 <get_pte>
  1036f2:	83 c4 10             	add    $0x10,%esp
  1036f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1036f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036fc:	75 0a                	jne    103708 <page_insert+0x2c>
        return -E_NO_MEM;
  1036fe:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103703:	e9 8b 00 00 00       	jmp    103793 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103708:	83 ec 0c             	sub    $0xc,%esp
  10370b:	ff 75 0c             	pushl  0xc(%ebp)
  10370e:	e8 66 f4 ff ff       	call   102b79 <page_ref_inc>
  103713:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  103716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103719:	8b 00                	mov    (%eax),%eax
  10371b:	83 e0 01             	and    $0x1,%eax
  10371e:	85 c0                	test   %eax,%eax
  103720:	74 40                	je     103762 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  103722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103725:	8b 00                	mov    (%eax),%eax
  103727:	83 ec 0c             	sub    $0xc,%esp
  10372a:	50                   	push   %eax
  10372b:	e8 db f3 ff ff       	call   102b0b <pte2page>
  103730:	83 c4 10             	add    $0x10,%esp
  103733:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103739:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10373c:	75 10                	jne    10374e <page_insert+0x72>
            page_ref_dec(page);
  10373e:	83 ec 0c             	sub    $0xc,%esp
  103741:	ff 75 0c             	pushl  0xc(%ebp)
  103744:	e8 47 f4 ff ff       	call   102b90 <page_ref_dec>
  103749:	83 c4 10             	add    $0x10,%esp
  10374c:	eb 14                	jmp    103762 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10374e:	83 ec 04             	sub    $0x4,%esp
  103751:	ff 75 f4             	pushl  -0xc(%ebp)
  103754:	ff 75 10             	pushl  0x10(%ebp)
  103757:	ff 75 08             	pushl  0x8(%ebp)
  10375a:	e8 da fe ff ff       	call   103639 <page_remove_pte>
  10375f:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103762:	83 ec 0c             	sub    $0xc,%esp
  103765:	ff 75 0c             	pushl  0xc(%ebp)
  103768:	e8 ff f2 ff ff       	call   102a6c <page2pa>
  10376d:	83 c4 10             	add    $0x10,%esp
  103770:	0b 45 14             	or     0x14(%ebp),%eax
  103773:	83 c8 01             	or     $0x1,%eax
  103776:	89 c2                	mov    %eax,%edx
  103778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10377b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10377d:	83 ec 08             	sub    $0x8,%esp
  103780:	ff 75 10             	pushl  0x10(%ebp)
  103783:	ff 75 08             	pushl  0x8(%ebp)
  103786:	e8 0a 00 00 00       	call   103795 <tlb_invalidate>
  10378b:	83 c4 10             	add    $0x10,%esp
    return 0;
  10378e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103793:	c9                   	leave  
  103794:	c3                   	ret    

00103795 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103795:	55                   	push   %ebp
  103796:	89 e5                	mov    %esp,%ebp
  103798:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10379b:	0f 20 d8             	mov    %cr3,%eax
  10379e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  1037a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1037a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1037a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037aa:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1037b1:	77 17                	ja     1037ca <tlb_invalidate+0x35>
  1037b3:	ff 75 f0             	pushl  -0x10(%ebp)
  1037b6:	68 40 71 10 00       	push   $0x107140
  1037bb:	68 e9 01 00 00       	push   $0x1e9
  1037c0:	68 64 71 10 00       	push   $0x107164
  1037c5:	e8 03 cc ff ff       	call   1003cd <__panic>
  1037ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037cd:	05 00 00 00 40       	add    $0x40000000,%eax
  1037d2:	39 c2                	cmp    %eax,%edx
  1037d4:	75 0c                	jne    1037e2 <tlb_invalidate+0x4d>
        invlpg((void *)la);
  1037d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1037dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037df:	0f 01 38             	invlpg (%eax)
    }
}
  1037e2:	90                   	nop
  1037e3:	c9                   	leave  
  1037e4:	c3                   	ret    

001037e5 <check_alloc_page>:

static void
check_alloc_page(void) {
  1037e5:	55                   	push   %ebp
  1037e6:	89 e5                	mov    %esp,%ebp
  1037e8:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  1037eb:	a1 5c a9 11 00       	mov    0x11a95c,%eax
  1037f0:	8b 40 18             	mov    0x18(%eax),%eax
  1037f3:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1037f5:	83 ec 0c             	sub    $0xc,%esp
  1037f8:	68 78 72 10 00       	push   $0x107278
  1037fd:	e8 65 ca ff ff       	call   100267 <cprintf>
  103802:	83 c4 10             	add    $0x10,%esp
}
  103805:	90                   	nop
  103806:	c9                   	leave  
  103807:	c3                   	ret    

00103808 <check_pgdir>:

static void
check_pgdir(void) {
  103808:	55                   	push   %ebp
  103809:	89 e5                	mov    %esp,%ebp
  10380b:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10380e:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  103813:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103818:	76 19                	jbe    103833 <check_pgdir+0x2b>
  10381a:	68 97 72 10 00       	push   $0x107297
  10381f:	68 25 72 10 00       	push   $0x107225
  103824:	68 f6 01 00 00       	push   $0x1f6
  103829:	68 64 71 10 00       	push   $0x107164
  10382e:	e8 9a cb ff ff       	call   1003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103833:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103838:	85 c0                	test   %eax,%eax
  10383a:	74 0e                	je     10384a <check_pgdir+0x42>
  10383c:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103841:	25 ff 0f 00 00       	and    $0xfff,%eax
  103846:	85 c0                	test   %eax,%eax
  103848:	74 19                	je     103863 <check_pgdir+0x5b>
  10384a:	68 b4 72 10 00       	push   $0x1072b4
  10384f:	68 25 72 10 00       	push   $0x107225
  103854:	68 f7 01 00 00       	push   $0x1f7
  103859:	68 64 71 10 00       	push   $0x107164
  10385e:	e8 6a cb ff ff       	call   1003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103863:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103868:	83 ec 04             	sub    $0x4,%esp
  10386b:	6a 00                	push   $0x0
  10386d:	6a 00                	push   $0x0
  10386f:	50                   	push   %eax
  103870:	e8 6e fd ff ff       	call   1035e3 <get_page>
  103875:	83 c4 10             	add    $0x10,%esp
  103878:	85 c0                	test   %eax,%eax
  10387a:	74 19                	je     103895 <check_pgdir+0x8d>
  10387c:	68 ec 72 10 00       	push   $0x1072ec
  103881:	68 25 72 10 00       	push   $0x107225
  103886:	68 f8 01 00 00       	push   $0x1f8
  10388b:	68 64 71 10 00       	push   $0x107164
  103890:	e8 38 cb ff ff       	call   1003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103895:	83 ec 0c             	sub    $0xc,%esp
  103898:	6a 01                	push   $0x1
  10389a:	e8 d0 f4 ff ff       	call   102d6f <alloc_pages>
  10389f:	83 c4 10             	add    $0x10,%esp
  1038a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1038a5:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  1038aa:	6a 00                	push   $0x0
  1038ac:	6a 00                	push   $0x0
  1038ae:	ff 75 f4             	pushl  -0xc(%ebp)
  1038b1:	50                   	push   %eax
  1038b2:	e8 25 fe ff ff       	call   1036dc <page_insert>
  1038b7:	83 c4 10             	add    $0x10,%esp
  1038ba:	85 c0                	test   %eax,%eax
  1038bc:	74 19                	je     1038d7 <check_pgdir+0xcf>
  1038be:	68 14 73 10 00       	push   $0x107314
  1038c3:	68 25 72 10 00       	push   $0x107225
  1038c8:	68 fc 01 00 00       	push   $0x1fc
  1038cd:	68 64 71 10 00       	push   $0x107164
  1038d2:	e8 f6 ca ff ff       	call   1003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1038d7:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  1038dc:	83 ec 04             	sub    $0x4,%esp
  1038df:	6a 00                	push   $0x0
  1038e1:	6a 00                	push   $0x0
  1038e3:	50                   	push   %eax
  1038e4:	e8 bf fb ff ff       	call   1034a8 <get_pte>
  1038e9:	83 c4 10             	add    $0x10,%esp
  1038ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038f3:	75 19                	jne    10390e <check_pgdir+0x106>
  1038f5:	68 40 73 10 00       	push   $0x107340
  1038fa:	68 25 72 10 00       	push   $0x107225
  1038ff:	68 ff 01 00 00       	push   $0x1ff
  103904:	68 64 71 10 00       	push   $0x107164
  103909:	e8 bf ca ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  10390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103911:	8b 00                	mov    (%eax),%eax
  103913:	83 ec 0c             	sub    $0xc,%esp
  103916:	50                   	push   %eax
  103917:	e8 ef f1 ff ff       	call   102b0b <pte2page>
  10391c:	83 c4 10             	add    $0x10,%esp
  10391f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103922:	74 19                	je     10393d <check_pgdir+0x135>
  103924:	68 6d 73 10 00       	push   $0x10736d
  103929:	68 25 72 10 00       	push   $0x107225
  10392e:	68 00 02 00 00       	push   $0x200
  103933:	68 64 71 10 00       	push   $0x107164
  103938:	e8 90 ca ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 1);
  10393d:	83 ec 0c             	sub    $0xc,%esp
  103940:	ff 75 f4             	pushl  -0xc(%ebp)
  103943:	e8 19 f2 ff ff       	call   102b61 <page_ref>
  103948:	83 c4 10             	add    $0x10,%esp
  10394b:	83 f8 01             	cmp    $0x1,%eax
  10394e:	74 19                	je     103969 <check_pgdir+0x161>
  103950:	68 83 73 10 00       	push   $0x107383
  103955:	68 25 72 10 00       	push   $0x107225
  10395a:	68 01 02 00 00       	push   $0x201
  10395f:	68 64 71 10 00       	push   $0x107164
  103964:	e8 64 ca ff ff       	call   1003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103969:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  10396e:	8b 00                	mov    (%eax),%eax
  103970:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103975:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10397b:	c1 e8 0c             	shr    $0xc,%eax
  10397e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103981:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  103986:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103989:	72 17                	jb     1039a2 <check_pgdir+0x19a>
  10398b:	ff 75 ec             	pushl  -0x14(%ebp)
  10398e:	68 80 70 10 00       	push   $0x107080
  103993:	68 03 02 00 00       	push   $0x203
  103998:	68 64 71 10 00       	push   $0x107164
  10399d:	e8 2b ca ff ff       	call   1003cd <__panic>
  1039a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039a5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1039aa:	83 c0 04             	add    $0x4,%eax
  1039ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1039b0:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  1039b5:	83 ec 04             	sub    $0x4,%esp
  1039b8:	6a 00                	push   $0x0
  1039ba:	68 00 10 00 00       	push   $0x1000
  1039bf:	50                   	push   %eax
  1039c0:	e8 e3 fa ff ff       	call   1034a8 <get_pte>
  1039c5:	83 c4 10             	add    $0x10,%esp
  1039c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1039cb:	74 19                	je     1039e6 <check_pgdir+0x1de>
  1039cd:	68 98 73 10 00       	push   $0x107398
  1039d2:	68 25 72 10 00       	push   $0x107225
  1039d7:	68 04 02 00 00       	push   $0x204
  1039dc:	68 64 71 10 00       	push   $0x107164
  1039e1:	e8 e7 c9 ff ff       	call   1003cd <__panic>

    p2 = alloc_page();
  1039e6:	83 ec 0c             	sub    $0xc,%esp
  1039e9:	6a 01                	push   $0x1
  1039eb:	e8 7f f3 ff ff       	call   102d6f <alloc_pages>
  1039f0:	83 c4 10             	add    $0x10,%esp
  1039f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1039f6:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  1039fb:	6a 06                	push   $0x6
  1039fd:	68 00 10 00 00       	push   $0x1000
  103a02:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a05:	50                   	push   %eax
  103a06:	e8 d1 fc ff ff       	call   1036dc <page_insert>
  103a0b:	83 c4 10             	add    $0x10,%esp
  103a0e:	85 c0                	test   %eax,%eax
  103a10:	74 19                	je     103a2b <check_pgdir+0x223>
  103a12:	68 c0 73 10 00       	push   $0x1073c0
  103a17:	68 25 72 10 00       	push   $0x107225
  103a1c:	68 07 02 00 00       	push   $0x207
  103a21:	68 64 71 10 00       	push   $0x107164
  103a26:	e8 a2 c9 ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a2b:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103a30:	83 ec 04             	sub    $0x4,%esp
  103a33:	6a 00                	push   $0x0
  103a35:	68 00 10 00 00       	push   $0x1000
  103a3a:	50                   	push   %eax
  103a3b:	e8 68 fa ff ff       	call   1034a8 <get_pte>
  103a40:	83 c4 10             	add    $0x10,%esp
  103a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a4a:	75 19                	jne    103a65 <check_pgdir+0x25d>
  103a4c:	68 f8 73 10 00       	push   $0x1073f8
  103a51:	68 25 72 10 00       	push   $0x107225
  103a56:	68 08 02 00 00       	push   $0x208
  103a5b:	68 64 71 10 00       	push   $0x107164
  103a60:	e8 68 c9 ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_U);
  103a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a68:	8b 00                	mov    (%eax),%eax
  103a6a:	83 e0 04             	and    $0x4,%eax
  103a6d:	85 c0                	test   %eax,%eax
  103a6f:	75 19                	jne    103a8a <check_pgdir+0x282>
  103a71:	68 28 74 10 00       	push   $0x107428
  103a76:	68 25 72 10 00       	push   $0x107225
  103a7b:	68 09 02 00 00       	push   $0x209
  103a80:	68 64 71 10 00       	push   $0x107164
  103a85:	e8 43 c9 ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_W);
  103a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a8d:	8b 00                	mov    (%eax),%eax
  103a8f:	83 e0 02             	and    $0x2,%eax
  103a92:	85 c0                	test   %eax,%eax
  103a94:	75 19                	jne    103aaf <check_pgdir+0x2a7>
  103a96:	68 36 74 10 00       	push   $0x107436
  103a9b:	68 25 72 10 00       	push   $0x107225
  103aa0:	68 0a 02 00 00       	push   $0x20a
  103aa5:	68 64 71 10 00       	push   $0x107164
  103aaa:	e8 1e c9 ff ff       	call   1003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103aaf:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103ab4:	8b 00                	mov    (%eax),%eax
  103ab6:	83 e0 04             	and    $0x4,%eax
  103ab9:	85 c0                	test   %eax,%eax
  103abb:	75 19                	jne    103ad6 <check_pgdir+0x2ce>
  103abd:	68 44 74 10 00       	push   $0x107444
  103ac2:	68 25 72 10 00       	push   $0x107225
  103ac7:	68 0b 02 00 00       	push   $0x20b
  103acc:	68 64 71 10 00       	push   $0x107164
  103ad1:	e8 f7 c8 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 1);
  103ad6:	83 ec 0c             	sub    $0xc,%esp
  103ad9:	ff 75 e4             	pushl  -0x1c(%ebp)
  103adc:	e8 80 f0 ff ff       	call   102b61 <page_ref>
  103ae1:	83 c4 10             	add    $0x10,%esp
  103ae4:	83 f8 01             	cmp    $0x1,%eax
  103ae7:	74 19                	je     103b02 <check_pgdir+0x2fa>
  103ae9:	68 5a 74 10 00       	push   $0x10745a
  103aee:	68 25 72 10 00       	push   $0x107225
  103af3:	68 0c 02 00 00       	push   $0x20c
  103af8:	68 64 71 10 00       	push   $0x107164
  103afd:	e8 cb c8 ff ff       	call   1003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103b02:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103b07:	6a 00                	push   $0x0
  103b09:	68 00 10 00 00       	push   $0x1000
  103b0e:	ff 75 f4             	pushl  -0xc(%ebp)
  103b11:	50                   	push   %eax
  103b12:	e8 c5 fb ff ff       	call   1036dc <page_insert>
  103b17:	83 c4 10             	add    $0x10,%esp
  103b1a:	85 c0                	test   %eax,%eax
  103b1c:	74 19                	je     103b37 <check_pgdir+0x32f>
  103b1e:	68 6c 74 10 00       	push   $0x10746c
  103b23:	68 25 72 10 00       	push   $0x107225
  103b28:	68 0e 02 00 00       	push   $0x20e
  103b2d:	68 64 71 10 00       	push   $0x107164
  103b32:	e8 96 c8 ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 2);
  103b37:	83 ec 0c             	sub    $0xc,%esp
  103b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  103b3d:	e8 1f f0 ff ff       	call   102b61 <page_ref>
  103b42:	83 c4 10             	add    $0x10,%esp
  103b45:	83 f8 02             	cmp    $0x2,%eax
  103b48:	74 19                	je     103b63 <check_pgdir+0x35b>
  103b4a:	68 98 74 10 00       	push   $0x107498
  103b4f:	68 25 72 10 00       	push   $0x107225
  103b54:	68 0f 02 00 00       	push   $0x20f
  103b59:	68 64 71 10 00       	push   $0x107164
  103b5e:	e8 6a c8 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103b63:	83 ec 0c             	sub    $0xc,%esp
  103b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b69:	e8 f3 ef ff ff       	call   102b61 <page_ref>
  103b6e:	83 c4 10             	add    $0x10,%esp
  103b71:	85 c0                	test   %eax,%eax
  103b73:	74 19                	je     103b8e <check_pgdir+0x386>
  103b75:	68 aa 74 10 00       	push   $0x1074aa
  103b7a:	68 25 72 10 00       	push   $0x107225
  103b7f:	68 10 02 00 00       	push   $0x210
  103b84:	68 64 71 10 00       	push   $0x107164
  103b89:	e8 3f c8 ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b8e:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103b93:	83 ec 04             	sub    $0x4,%esp
  103b96:	6a 00                	push   $0x0
  103b98:	68 00 10 00 00       	push   $0x1000
  103b9d:	50                   	push   %eax
  103b9e:	e8 05 f9 ff ff       	call   1034a8 <get_pte>
  103ba3:	83 c4 10             	add    $0x10,%esp
  103ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bad:	75 19                	jne    103bc8 <check_pgdir+0x3c0>
  103baf:	68 f8 73 10 00       	push   $0x1073f8
  103bb4:	68 25 72 10 00       	push   $0x107225
  103bb9:	68 11 02 00 00       	push   $0x211
  103bbe:	68 64 71 10 00       	push   $0x107164
  103bc3:	e8 05 c8 ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  103bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bcb:	8b 00                	mov    (%eax),%eax
  103bcd:	83 ec 0c             	sub    $0xc,%esp
  103bd0:	50                   	push   %eax
  103bd1:	e8 35 ef ff ff       	call   102b0b <pte2page>
  103bd6:	83 c4 10             	add    $0x10,%esp
  103bd9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103bdc:	74 19                	je     103bf7 <check_pgdir+0x3ef>
  103bde:	68 6d 73 10 00       	push   $0x10736d
  103be3:	68 25 72 10 00       	push   $0x107225
  103be8:	68 12 02 00 00       	push   $0x212
  103bed:	68 64 71 10 00       	push   $0x107164
  103bf2:	e8 d6 c7 ff ff       	call   1003cd <__panic>
    assert((*ptep & PTE_U) == 0);
  103bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bfa:	8b 00                	mov    (%eax),%eax
  103bfc:	83 e0 04             	and    $0x4,%eax
  103bff:	85 c0                	test   %eax,%eax
  103c01:	74 19                	je     103c1c <check_pgdir+0x414>
  103c03:	68 bc 74 10 00       	push   $0x1074bc
  103c08:	68 25 72 10 00       	push   $0x107225
  103c0d:	68 13 02 00 00       	push   $0x213
  103c12:	68 64 71 10 00       	push   $0x107164
  103c17:	e8 b1 c7 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, 0x0);
  103c1c:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103c21:	83 ec 08             	sub    $0x8,%esp
  103c24:	6a 00                	push   $0x0
  103c26:	50                   	push   %eax
  103c27:	e8 77 fa ff ff       	call   1036a3 <page_remove>
  103c2c:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103c2f:	83 ec 0c             	sub    $0xc,%esp
  103c32:	ff 75 f4             	pushl  -0xc(%ebp)
  103c35:	e8 27 ef ff ff       	call   102b61 <page_ref>
  103c3a:	83 c4 10             	add    $0x10,%esp
  103c3d:	83 f8 01             	cmp    $0x1,%eax
  103c40:	74 19                	je     103c5b <check_pgdir+0x453>
  103c42:	68 83 73 10 00       	push   $0x107383
  103c47:	68 25 72 10 00       	push   $0x107225
  103c4c:	68 16 02 00 00       	push   $0x216
  103c51:	68 64 71 10 00       	push   $0x107164
  103c56:	e8 72 c7 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103c5b:	83 ec 0c             	sub    $0xc,%esp
  103c5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  103c61:	e8 fb ee ff ff       	call   102b61 <page_ref>
  103c66:	83 c4 10             	add    $0x10,%esp
  103c69:	85 c0                	test   %eax,%eax
  103c6b:	74 19                	je     103c86 <check_pgdir+0x47e>
  103c6d:	68 aa 74 10 00       	push   $0x1074aa
  103c72:	68 25 72 10 00       	push   $0x107225
  103c77:	68 17 02 00 00       	push   $0x217
  103c7c:	68 64 71 10 00       	push   $0x107164
  103c81:	e8 47 c7 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103c86:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103c8b:	83 ec 08             	sub    $0x8,%esp
  103c8e:	68 00 10 00 00       	push   $0x1000
  103c93:	50                   	push   %eax
  103c94:	e8 0a fa ff ff       	call   1036a3 <page_remove>
  103c99:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103c9c:	83 ec 0c             	sub    $0xc,%esp
  103c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  103ca2:	e8 ba ee ff ff       	call   102b61 <page_ref>
  103ca7:	83 c4 10             	add    $0x10,%esp
  103caa:	85 c0                	test   %eax,%eax
  103cac:	74 19                	je     103cc7 <check_pgdir+0x4bf>
  103cae:	68 d1 74 10 00       	push   $0x1074d1
  103cb3:	68 25 72 10 00       	push   $0x107225
  103cb8:	68 1a 02 00 00       	push   $0x21a
  103cbd:	68 64 71 10 00       	push   $0x107164
  103cc2:	e8 06 c7 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103cc7:	83 ec 0c             	sub    $0xc,%esp
  103cca:	ff 75 e4             	pushl  -0x1c(%ebp)
  103ccd:	e8 8f ee ff ff       	call   102b61 <page_ref>
  103cd2:	83 c4 10             	add    $0x10,%esp
  103cd5:	85 c0                	test   %eax,%eax
  103cd7:	74 19                	je     103cf2 <check_pgdir+0x4ea>
  103cd9:	68 aa 74 10 00       	push   $0x1074aa
  103cde:	68 25 72 10 00       	push   $0x107225
  103ce3:	68 1b 02 00 00       	push   $0x21b
  103ce8:	68 64 71 10 00       	push   $0x107164
  103ced:	e8 db c6 ff ff       	call   1003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103cf2:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103cf7:	8b 00                	mov    (%eax),%eax
  103cf9:	83 ec 0c             	sub    $0xc,%esp
  103cfc:	50                   	push   %eax
  103cfd:	e8 43 ee ff ff       	call   102b45 <pde2page>
  103d02:	83 c4 10             	add    $0x10,%esp
  103d05:	83 ec 0c             	sub    $0xc,%esp
  103d08:	50                   	push   %eax
  103d09:	e8 53 ee ff ff       	call   102b61 <page_ref>
  103d0e:	83 c4 10             	add    $0x10,%esp
  103d11:	83 f8 01             	cmp    $0x1,%eax
  103d14:	74 19                	je     103d2f <check_pgdir+0x527>
  103d16:	68 e4 74 10 00       	push   $0x1074e4
  103d1b:	68 25 72 10 00       	push   $0x107225
  103d20:	68 1d 02 00 00       	push   $0x21d
  103d25:	68 64 71 10 00       	push   $0x107164
  103d2a:	e8 9e c6 ff ff       	call   1003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103d2f:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103d34:	8b 00                	mov    (%eax),%eax
  103d36:	83 ec 0c             	sub    $0xc,%esp
  103d39:	50                   	push   %eax
  103d3a:	e8 06 ee ff ff       	call   102b45 <pde2page>
  103d3f:	83 c4 10             	add    $0x10,%esp
  103d42:	83 ec 08             	sub    $0x8,%esp
  103d45:	6a 01                	push   $0x1
  103d47:	50                   	push   %eax
  103d48:	e8 60 f0 ff ff       	call   102dad <free_pages>
  103d4d:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103d50:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103d55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103d5b:	83 ec 0c             	sub    $0xc,%esp
  103d5e:	68 0b 75 10 00       	push   $0x10750b
  103d63:	e8 ff c4 ff ff       	call   100267 <cprintf>
  103d68:	83 c4 10             	add    $0x10,%esp
}
  103d6b:	90                   	nop
  103d6c:	c9                   	leave  
  103d6d:	c3                   	ret    

00103d6e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103d6e:	55                   	push   %ebp
  103d6f:	89 e5                	mov    %esp,%ebp
  103d71:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103d74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d7b:	e9 a3 00 00 00       	jmp    103e23 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d89:	c1 e8 0c             	shr    $0xc,%eax
  103d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103d8f:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  103d94:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103d97:	72 17                	jb     103db0 <check_boot_pgdir+0x42>
  103d99:	ff 75 f0             	pushl  -0x10(%ebp)
  103d9c:	68 80 70 10 00       	push   $0x107080
  103da1:	68 29 02 00 00       	push   $0x229
  103da6:	68 64 71 10 00       	push   $0x107164
  103dab:	e8 1d c6 ff ff       	call   1003cd <__panic>
  103db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103db3:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103db8:	89 c2                	mov    %eax,%edx
  103dba:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103dbf:	83 ec 04             	sub    $0x4,%esp
  103dc2:	6a 00                	push   $0x0
  103dc4:	52                   	push   %edx
  103dc5:	50                   	push   %eax
  103dc6:	e8 dd f6 ff ff       	call   1034a8 <get_pte>
  103dcb:	83 c4 10             	add    $0x10,%esp
  103dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103dd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103dd5:	75 19                	jne    103df0 <check_boot_pgdir+0x82>
  103dd7:	68 28 75 10 00       	push   $0x107528
  103ddc:	68 25 72 10 00       	push   $0x107225
  103de1:	68 29 02 00 00       	push   $0x229
  103de6:	68 64 71 10 00       	push   $0x107164
  103deb:	e8 dd c5 ff ff       	call   1003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103df0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103df3:	8b 00                	mov    (%eax),%eax
  103df5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103dfa:	89 c2                	mov    %eax,%edx
  103dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dff:	39 c2                	cmp    %eax,%edx
  103e01:	74 19                	je     103e1c <check_boot_pgdir+0xae>
  103e03:	68 65 75 10 00       	push   $0x107565
  103e08:	68 25 72 10 00       	push   $0x107225
  103e0d:	68 2a 02 00 00       	push   $0x22a
  103e12:	68 64 71 10 00       	push   $0x107164
  103e17:	e8 b1 c5 ff ff       	call   1003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103e1c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e26:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  103e2b:	39 c2                	cmp    %eax,%edx
  103e2d:	0f 82 4d ff ff ff    	jb     103d80 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103e33:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103e38:	05 ac 0f 00 00       	add    $0xfac,%eax
  103e3d:	8b 00                	mov    (%eax),%eax
  103e3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e44:	89 c2                	mov    %eax,%edx
  103e46:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103e4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103e4e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103e55:	77 17                	ja     103e6e <check_boot_pgdir+0x100>
  103e57:	ff 75 e4             	pushl  -0x1c(%ebp)
  103e5a:	68 40 71 10 00       	push   $0x107140
  103e5f:	68 2d 02 00 00       	push   $0x22d
  103e64:	68 64 71 10 00       	push   $0x107164
  103e69:	e8 5f c5 ff ff       	call   1003cd <__panic>
  103e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e71:	05 00 00 00 40       	add    $0x40000000,%eax
  103e76:	39 c2                	cmp    %eax,%edx
  103e78:	74 19                	je     103e93 <check_boot_pgdir+0x125>
  103e7a:	68 7c 75 10 00       	push   $0x10757c
  103e7f:	68 25 72 10 00       	push   $0x107225
  103e84:	68 2d 02 00 00       	push   $0x22d
  103e89:	68 64 71 10 00       	push   $0x107164
  103e8e:	e8 3a c5 ff ff       	call   1003cd <__panic>

    assert(boot_pgdir[0] == 0);
  103e93:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103e98:	8b 00                	mov    (%eax),%eax
  103e9a:	85 c0                	test   %eax,%eax
  103e9c:	74 19                	je     103eb7 <check_boot_pgdir+0x149>
  103e9e:	68 b0 75 10 00       	push   $0x1075b0
  103ea3:	68 25 72 10 00       	push   $0x107225
  103ea8:	68 2f 02 00 00       	push   $0x22f
  103ead:	68 64 71 10 00       	push   $0x107164
  103eb2:	e8 16 c5 ff ff       	call   1003cd <__panic>

    struct Page *p;
    p = alloc_page();
  103eb7:	83 ec 0c             	sub    $0xc,%esp
  103eba:	6a 01                	push   $0x1
  103ebc:	e8 ae ee ff ff       	call   102d6f <alloc_pages>
  103ec1:	83 c4 10             	add    $0x10,%esp
  103ec4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103ec7:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103ecc:	6a 02                	push   $0x2
  103ece:	68 00 01 00 00       	push   $0x100
  103ed3:	ff 75 e0             	pushl  -0x20(%ebp)
  103ed6:	50                   	push   %eax
  103ed7:	e8 00 f8 ff ff       	call   1036dc <page_insert>
  103edc:	83 c4 10             	add    $0x10,%esp
  103edf:	85 c0                	test   %eax,%eax
  103ee1:	74 19                	je     103efc <check_boot_pgdir+0x18e>
  103ee3:	68 c4 75 10 00       	push   $0x1075c4
  103ee8:	68 25 72 10 00       	push   $0x107225
  103eed:	68 33 02 00 00       	push   $0x233
  103ef2:	68 64 71 10 00       	push   $0x107164
  103ef7:	e8 d1 c4 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 1);
  103efc:	83 ec 0c             	sub    $0xc,%esp
  103eff:	ff 75 e0             	pushl  -0x20(%ebp)
  103f02:	e8 5a ec ff ff       	call   102b61 <page_ref>
  103f07:	83 c4 10             	add    $0x10,%esp
  103f0a:	83 f8 01             	cmp    $0x1,%eax
  103f0d:	74 19                	je     103f28 <check_boot_pgdir+0x1ba>
  103f0f:	68 f2 75 10 00       	push   $0x1075f2
  103f14:	68 25 72 10 00       	push   $0x107225
  103f19:	68 34 02 00 00       	push   $0x234
  103f1e:	68 64 71 10 00       	push   $0x107164
  103f23:	e8 a5 c4 ff ff       	call   1003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103f28:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  103f2d:	6a 02                	push   $0x2
  103f2f:	68 00 11 00 00       	push   $0x1100
  103f34:	ff 75 e0             	pushl  -0x20(%ebp)
  103f37:	50                   	push   %eax
  103f38:	e8 9f f7 ff ff       	call   1036dc <page_insert>
  103f3d:	83 c4 10             	add    $0x10,%esp
  103f40:	85 c0                	test   %eax,%eax
  103f42:	74 19                	je     103f5d <check_boot_pgdir+0x1ef>
  103f44:	68 04 76 10 00       	push   $0x107604
  103f49:	68 25 72 10 00       	push   $0x107225
  103f4e:	68 35 02 00 00       	push   $0x235
  103f53:	68 64 71 10 00       	push   $0x107164
  103f58:	e8 70 c4 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 2);
  103f5d:	83 ec 0c             	sub    $0xc,%esp
  103f60:	ff 75 e0             	pushl  -0x20(%ebp)
  103f63:	e8 f9 eb ff ff       	call   102b61 <page_ref>
  103f68:	83 c4 10             	add    $0x10,%esp
  103f6b:	83 f8 02             	cmp    $0x2,%eax
  103f6e:	74 19                	je     103f89 <check_boot_pgdir+0x21b>
  103f70:	68 3b 76 10 00       	push   $0x10763b
  103f75:	68 25 72 10 00       	push   $0x107225
  103f7a:	68 36 02 00 00       	push   $0x236
  103f7f:	68 64 71 10 00       	push   $0x107164
  103f84:	e8 44 c4 ff ff       	call   1003cd <__panic>

    const char *str = "ucore: Hello world!!";
  103f89:	c7 45 dc 4c 76 10 00 	movl   $0x10764c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103f90:	83 ec 08             	sub    $0x8,%esp
  103f93:	ff 75 dc             	pushl  -0x24(%ebp)
  103f96:	68 00 01 00 00       	push   $0x100
  103f9b:	e8 ee 1e 00 00       	call   105e8e <strcpy>
  103fa0:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103fa3:	83 ec 08             	sub    $0x8,%esp
  103fa6:	68 00 11 00 00       	push   $0x1100
  103fab:	68 00 01 00 00       	push   $0x100
  103fb0:	e8 53 1f 00 00       	call   105f08 <strcmp>
  103fb5:	83 c4 10             	add    $0x10,%esp
  103fb8:	85 c0                	test   %eax,%eax
  103fba:	74 19                	je     103fd5 <check_boot_pgdir+0x267>
  103fbc:	68 64 76 10 00       	push   $0x107664
  103fc1:	68 25 72 10 00       	push   $0x107225
  103fc6:	68 3a 02 00 00       	push   $0x23a
  103fcb:	68 64 71 10 00       	push   $0x107164
  103fd0:	e8 f8 c3 ff ff       	call   1003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103fd5:	83 ec 0c             	sub    $0xc,%esp
  103fd8:	ff 75 e0             	pushl  -0x20(%ebp)
  103fdb:	e8 e6 ea ff ff       	call   102ac6 <page2kva>
  103fe0:	83 c4 10             	add    $0x10,%esp
  103fe3:	05 00 01 00 00       	add    $0x100,%eax
  103fe8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103feb:	83 ec 0c             	sub    $0xc,%esp
  103fee:	68 00 01 00 00       	push   $0x100
  103ff3:	e8 3e 1e 00 00       	call   105e36 <strlen>
  103ff8:	83 c4 10             	add    $0x10,%esp
  103ffb:	85 c0                	test   %eax,%eax
  103ffd:	74 19                	je     104018 <check_boot_pgdir+0x2aa>
  103fff:	68 9c 76 10 00       	push   $0x10769c
  104004:	68 25 72 10 00       	push   $0x107225
  104009:	68 3d 02 00 00       	push   $0x23d
  10400e:	68 64 71 10 00       	push   $0x107164
  104013:	e8 b5 c3 ff ff       	call   1003cd <__panic>

    free_page(p);
  104018:	83 ec 08             	sub    $0x8,%esp
  10401b:	6a 01                	push   $0x1
  10401d:	ff 75 e0             	pushl  -0x20(%ebp)
  104020:	e8 88 ed ff ff       	call   102dad <free_pages>
  104025:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  104028:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  10402d:	8b 00                	mov    (%eax),%eax
  10402f:	83 ec 0c             	sub    $0xc,%esp
  104032:	50                   	push   %eax
  104033:	e8 0d eb ff ff       	call   102b45 <pde2page>
  104038:	83 c4 10             	add    $0x10,%esp
  10403b:	83 ec 08             	sub    $0x8,%esp
  10403e:	6a 01                	push   $0x1
  104040:	50                   	push   %eax
  104041:	e8 67 ed ff ff       	call   102dad <free_pages>
  104046:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  104049:	a1 c4 a8 11 00       	mov    0x11a8c4,%eax
  10404e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104054:	83 ec 0c             	sub    $0xc,%esp
  104057:	68 c0 76 10 00       	push   $0x1076c0
  10405c:	e8 06 c2 ff ff       	call   100267 <cprintf>
  104061:	83 c4 10             	add    $0x10,%esp
}
  104064:	90                   	nop
  104065:	c9                   	leave  
  104066:	c3                   	ret    

00104067 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104067:	55                   	push   %ebp
  104068:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10406a:	8b 45 08             	mov    0x8(%ebp),%eax
  10406d:	83 e0 04             	and    $0x4,%eax
  104070:	85 c0                	test   %eax,%eax
  104072:	74 07                	je     10407b <perm2str+0x14>
  104074:	b8 75 00 00 00       	mov    $0x75,%eax
  104079:	eb 05                	jmp    104080 <perm2str+0x19>
  10407b:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104080:	a2 48 a9 11 00       	mov    %al,0x11a948
    str[1] = 'r';
  104085:	c6 05 49 a9 11 00 72 	movb   $0x72,0x11a949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10408c:	8b 45 08             	mov    0x8(%ebp),%eax
  10408f:	83 e0 02             	and    $0x2,%eax
  104092:	85 c0                	test   %eax,%eax
  104094:	74 07                	je     10409d <perm2str+0x36>
  104096:	b8 77 00 00 00       	mov    $0x77,%eax
  10409b:	eb 05                	jmp    1040a2 <perm2str+0x3b>
  10409d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1040a2:	a2 4a a9 11 00       	mov    %al,0x11a94a
    str[3] = '\0';
  1040a7:	c6 05 4b a9 11 00 00 	movb   $0x0,0x11a94b
    return str;
  1040ae:	b8 48 a9 11 00       	mov    $0x11a948,%eax
}
  1040b3:	5d                   	pop    %ebp
  1040b4:	c3                   	ret    

001040b5 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1040b5:	55                   	push   %ebp
  1040b6:	89 e5                	mov    %esp,%ebp
  1040b8:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1040bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1040be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1040c1:	72 0e                	jb     1040d1 <get_pgtable_items+0x1c>
        return 0;
  1040c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1040c8:	e9 9a 00 00 00       	jmp    104167 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1040cd:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1040d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1040d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1040d7:	73 18                	jae    1040f1 <get_pgtable_items+0x3c>
  1040d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1040dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1040e3:	8b 45 14             	mov    0x14(%ebp),%eax
  1040e6:	01 d0                	add    %edx,%eax
  1040e8:	8b 00                	mov    (%eax),%eax
  1040ea:	83 e0 01             	and    $0x1,%eax
  1040ed:	85 c0                	test   %eax,%eax
  1040ef:	74 dc                	je     1040cd <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  1040f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1040f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1040f7:	73 69                	jae    104162 <get_pgtable_items+0xad>
        if (left_store != NULL) {
  1040f9:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1040fd:	74 08                	je     104107 <get_pgtable_items+0x52>
            *left_store = start;
  1040ff:	8b 45 18             	mov    0x18(%ebp),%eax
  104102:	8b 55 10             	mov    0x10(%ebp),%edx
  104105:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104107:	8b 45 10             	mov    0x10(%ebp),%eax
  10410a:	8d 50 01             	lea    0x1(%eax),%edx
  10410d:	89 55 10             	mov    %edx,0x10(%ebp)
  104110:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104117:	8b 45 14             	mov    0x14(%ebp),%eax
  10411a:	01 d0                	add    %edx,%eax
  10411c:	8b 00                	mov    (%eax),%eax
  10411e:	83 e0 07             	and    $0x7,%eax
  104121:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104124:	eb 04                	jmp    10412a <get_pgtable_items+0x75>
            start ++;
  104126:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10412a:	8b 45 10             	mov    0x10(%ebp),%eax
  10412d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104130:	73 1d                	jae    10414f <get_pgtable_items+0x9a>
  104132:	8b 45 10             	mov    0x10(%ebp),%eax
  104135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10413c:	8b 45 14             	mov    0x14(%ebp),%eax
  10413f:	01 d0                	add    %edx,%eax
  104141:	8b 00                	mov    (%eax),%eax
  104143:	83 e0 07             	and    $0x7,%eax
  104146:	89 c2                	mov    %eax,%edx
  104148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10414b:	39 c2                	cmp    %eax,%edx
  10414d:	74 d7                	je     104126 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  10414f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104153:	74 08                	je     10415d <get_pgtable_items+0xa8>
            *right_store = start;
  104155:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104158:	8b 55 10             	mov    0x10(%ebp),%edx
  10415b:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10415d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104160:	eb 05                	jmp    104167 <get_pgtable_items+0xb2>
    }
    return 0;
  104162:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104167:	c9                   	leave  
  104168:	c3                   	ret    

00104169 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104169:	55                   	push   %ebp
  10416a:	89 e5                	mov    %esp,%ebp
  10416c:	57                   	push   %edi
  10416d:	56                   	push   %esi
  10416e:	53                   	push   %ebx
  10416f:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104172:	83 ec 0c             	sub    $0xc,%esp
  104175:	68 e0 76 10 00       	push   $0x1076e0
  10417a:	e8 e8 c0 ff ff       	call   100267 <cprintf>
  10417f:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  104182:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104189:	e9 e5 00 00 00       	jmp    104273 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10418e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104191:	83 ec 0c             	sub    $0xc,%esp
  104194:	50                   	push   %eax
  104195:	e8 cd fe ff ff       	call   104067 <perm2str>
  10419a:	83 c4 10             	add    $0x10,%esp
  10419d:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10419f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041a5:	29 c2                	sub    %eax,%edx
  1041a7:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1041a9:	c1 e0 16             	shl    $0x16,%eax
  1041ac:	89 c3                	mov    %eax,%ebx
  1041ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1041b1:	c1 e0 16             	shl    $0x16,%eax
  1041b4:	89 c1                	mov    %eax,%ecx
  1041b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041b9:	c1 e0 16             	shl    $0x16,%eax
  1041bc:	89 c2                	mov    %eax,%edx
  1041be:	8b 75 dc             	mov    -0x24(%ebp),%esi
  1041c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041c4:	29 c6                	sub    %eax,%esi
  1041c6:	89 f0                	mov    %esi,%eax
  1041c8:	83 ec 08             	sub    $0x8,%esp
  1041cb:	57                   	push   %edi
  1041cc:	53                   	push   %ebx
  1041cd:	51                   	push   %ecx
  1041ce:	52                   	push   %edx
  1041cf:	50                   	push   %eax
  1041d0:	68 11 77 10 00       	push   $0x107711
  1041d5:	e8 8d c0 ff ff       	call   100267 <cprintf>
  1041da:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1041dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041e0:	c1 e0 0a             	shl    $0xa,%eax
  1041e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1041e6:	eb 4f                	jmp    104237 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1041e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041eb:	83 ec 0c             	sub    $0xc,%esp
  1041ee:	50                   	push   %eax
  1041ef:	e8 73 fe ff ff       	call   104067 <perm2str>
  1041f4:	83 c4 10             	add    $0x10,%esp
  1041f7:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1041f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1041ff:	29 c2                	sub    %eax,%edx
  104201:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104203:	c1 e0 0c             	shl    $0xc,%eax
  104206:	89 c3                	mov    %eax,%ebx
  104208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10420b:	c1 e0 0c             	shl    $0xc,%eax
  10420e:	89 c1                	mov    %eax,%ecx
  104210:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104213:	c1 e0 0c             	shl    $0xc,%eax
  104216:	89 c2                	mov    %eax,%edx
  104218:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  10421b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10421e:	29 c6                	sub    %eax,%esi
  104220:	89 f0                	mov    %esi,%eax
  104222:	83 ec 08             	sub    $0x8,%esp
  104225:	57                   	push   %edi
  104226:	53                   	push   %ebx
  104227:	51                   	push   %ecx
  104228:	52                   	push   %edx
  104229:	50                   	push   %eax
  10422a:	68 30 77 10 00       	push   $0x107730
  10422f:	e8 33 c0 ff ff       	call   100267 <cprintf>
  104234:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104237:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  10423c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10423f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104242:	89 d3                	mov    %edx,%ebx
  104244:	c1 e3 0a             	shl    $0xa,%ebx
  104247:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10424a:	89 d1                	mov    %edx,%ecx
  10424c:	c1 e1 0a             	shl    $0xa,%ecx
  10424f:	83 ec 08             	sub    $0x8,%esp
  104252:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104255:	52                   	push   %edx
  104256:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104259:	52                   	push   %edx
  10425a:	56                   	push   %esi
  10425b:	50                   	push   %eax
  10425c:	53                   	push   %ebx
  10425d:	51                   	push   %ecx
  10425e:	e8 52 fe ff ff       	call   1040b5 <get_pgtable_items>
  104263:	83 c4 20             	add    $0x20,%esp
  104266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104269:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10426d:	0f 85 75 ff ff ff    	jne    1041e8 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104273:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104278:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10427b:	83 ec 08             	sub    $0x8,%esp
  10427e:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104281:	52                   	push   %edx
  104282:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104285:	52                   	push   %edx
  104286:	51                   	push   %ecx
  104287:	50                   	push   %eax
  104288:	68 00 04 00 00       	push   $0x400
  10428d:	6a 00                	push   $0x0
  10428f:	e8 21 fe ff ff       	call   1040b5 <get_pgtable_items>
  104294:	83 c4 20             	add    $0x20,%esp
  104297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10429a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10429e:	0f 85 ea fe ff ff    	jne    10418e <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1042a4:	83 ec 0c             	sub    $0xc,%esp
  1042a7:	68 54 77 10 00       	push   $0x107754
  1042ac:	e8 b6 bf ff ff       	call   100267 <cprintf>
  1042b1:	83 c4 10             	add    $0x10,%esp
}
  1042b4:	90                   	nop
  1042b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1042b8:	5b                   	pop    %ebx
  1042b9:	5e                   	pop    %esi
  1042ba:	5f                   	pop    %edi
  1042bb:	5d                   	pop    %ebp
  1042bc:	c3                   	ret    

001042bd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1042bd:	55                   	push   %ebp
  1042be:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1042c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1042c3:	8b 15 64 a9 11 00    	mov    0x11a964,%edx
  1042c9:	29 d0                	sub    %edx,%eax
  1042cb:	c1 f8 02             	sar    $0x2,%eax
  1042ce:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1042d4:	5d                   	pop    %ebp
  1042d5:	c3                   	ret    

001042d6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1042d6:	55                   	push   %ebp
  1042d7:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  1042d9:	ff 75 08             	pushl  0x8(%ebp)
  1042dc:	e8 dc ff ff ff       	call   1042bd <page2ppn>
  1042e1:	83 c4 04             	add    $0x4,%esp
  1042e4:	c1 e0 0c             	shl    $0xc,%eax
}
  1042e7:	c9                   	leave  
  1042e8:	c3                   	ret    

001042e9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1042e9:	55                   	push   %ebp
  1042ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1042ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ef:	8b 00                	mov    (%eax),%eax
}
  1042f1:	5d                   	pop    %ebp
  1042f2:	c3                   	ret    

001042f3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1042f3:	55                   	push   %ebp
  1042f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1042f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1042f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042fc:	89 10                	mov    %edx,(%eax)
}
  1042fe:	90                   	nop
  1042ff:	5d                   	pop    %ebp
  104300:	c3                   	ret    

00104301 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104301:	55                   	push   %ebp
  104302:	89 e5                	mov    %esp,%ebp
  104304:	83 ec 10             	sub    $0x10,%esp
  104307:	c7 45 fc 68 a9 11 00 	movl   $0x11a968,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10430e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104311:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104314:	89 50 04             	mov    %edx,0x4(%eax)
  104317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10431a:	8b 50 04             	mov    0x4(%eax),%edx
  10431d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104320:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  104322:	c7 05 70 a9 11 00 00 	movl   $0x0,0x11a970
  104329:	00 00 00 
}
  10432c:	90                   	nop
  10432d:	c9                   	leave  
  10432e:	c3                   	ret    

0010432f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10432f:	55                   	push   %ebp
  104330:	89 e5                	mov    %esp,%ebp
  104332:	83 ec 38             	sub    $0x38,%esp
	assert(n > 0);
  104335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104339:	75 16                	jne    104351 <default_init_memmap+0x22>
  10433b:	68 88 77 10 00       	push   $0x107788
  104340:	68 8e 77 10 00       	push   $0x10778e
  104345:	6a 46                	push   $0x46
  104347:	68 a3 77 10 00       	push   $0x1077a3
  10434c:	e8 7c c0 ff ff       	call   1003cd <__panic>
	struct Page *p = base;
  104351:	8b 45 08             	mov    0x8(%ebp),%eax
  104354:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p ++) {
  104357:	eb 6c                	jmp    1043c5 <default_init_memmap+0x96>
		// Before: the page must have been set reserved in page_init.
		assert(PageReserved(p));
  104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10435c:	83 c0 04             	add    $0x4,%eax
  10435f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10436c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10436f:	0f a3 10             	bt     %edx,(%eax)
  104372:	19 c0                	sbb    %eax,%eax
  104374:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  104377:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10437b:	0f 95 c0             	setne  %al
  10437e:	0f b6 c0             	movzbl %al,%eax
  104381:	85 c0                	test   %eax,%eax
  104383:	75 16                	jne    10439b <default_init_memmap+0x6c>
  104385:	68 b9 77 10 00       	push   $0x1077b9
  10438a:	68 8e 77 10 00       	push   $0x10778e
  10438f:	6a 4a                	push   $0x4a
  104391:	68 a3 77 10 00       	push   $0x1077a3
  104396:	e8 32 c0 ff ff       	call   1003cd <__panic>
		// Initialize flags, property and ref
		p->flags = p->property = 0;
  10439b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1043a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043a8:	8b 50 08             	mov    0x8(%eax),%edx
  1043ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043ae:	89 50 04             	mov    %edx,0x4(%eax)
		set_page_ref(p, 0);
  1043b1:	83 ec 08             	sub    $0x8,%esp
  1043b4:	6a 00                	push   $0x0
  1043b6:	ff 75 f4             	pushl  -0xc(%ebp)
  1043b9:	e8 35 ff ff ff       	call   1042f3 <set_page_ref>
  1043be:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page *p = base;
	for (; p != base + n; p ++) {
  1043c1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1043c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043c8:	89 d0                	mov    %edx,%eax
  1043ca:	c1 e0 02             	shl    $0x2,%eax
  1043cd:	01 d0                	add    %edx,%eax
  1043cf:	c1 e0 02             	shl    $0x2,%eax
  1043d2:	89 c2                	mov    %eax,%edx
  1043d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1043d7:	01 d0                	add    %edx,%eax
  1043d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1043dc:	0f 85 77 ff ff ff    	jne    104359 <default_init_memmap+0x2a>
		// Initialize flags, property and ref
		p->flags = p->property = 0;
		set_page_ref(p, 0);
	}
	// The base page is the start of continuous free pages.
	base->property = n;
  1043e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1043e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043e8:	89 50 08             	mov    %edx,0x8(%eax)
	SetPageProperty(base);
  1043eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1043ee:	83 c0 04             	add    $0x4,%eax
  1043f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  1043f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1043fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1043fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104401:	0f ab 10             	bts    %edx,(%eax)
	nr_free += n;
  104404:	8b 15 70 a9 11 00    	mov    0x11a970,%edx
  10440a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10440d:	01 d0                	add    %edx,%eax
  10440f:	a3 70 a9 11 00       	mov    %eax,0x11a970
	list_add_before(&free_list, &(base->page_link));
  104414:	8b 45 08             	mov    0x8(%ebp),%eax
  104417:	83 c0 0c             	add    $0xc,%eax
  10441a:	c7 45 f0 68 a9 11 00 	movl   $0x11a968,-0x10(%ebp)
  104421:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104427:	8b 00                	mov    (%eax),%eax
  104429:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10442c:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10442f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104435:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104438:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10443b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10443e:	89 10                	mov    %edx,(%eax)
  104440:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104443:	8b 10                	mov    (%eax),%edx
  104445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104448:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10444b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10444e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104451:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104457:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10445a:	89 10                	mov    %edx,(%eax)
}
  10445c:	90                   	nop
  10445d:	c9                   	leave  
  10445e:	c3                   	ret    

0010445f <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10445f:	55                   	push   %ebp
  104460:	89 e5                	mov    %esp,%ebp
  104462:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104465:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104469:	75 16                	jne    104481 <default_alloc_pages+0x22>
  10446b:	68 88 77 10 00       	push   $0x107788
  104470:	68 8e 77 10 00       	push   $0x10778e
  104475:	6a 58                	push   $0x58
  104477:	68 a3 77 10 00       	push   $0x1077a3
  10447c:	e8 4c bf ff ff       	call   1003cd <__panic>
    if (n > nr_free) {
  104481:	a1 70 a9 11 00       	mov    0x11a970,%eax
  104486:	3b 45 08             	cmp    0x8(%ebp),%eax
  104489:	73 0a                	jae    104495 <default_alloc_pages+0x36>
        return NULL;
  10448b:	b8 00 00 00 00       	mov    $0x0,%eax
  104490:	e9 a8 01 00 00       	jmp    10463d <default_alloc_pages+0x1de>
    }
    struct Page *page = NULL;
  104495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  10449c:	c7 45 f0 68 a9 11 00 	movl   $0x11a968,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1044a3:	eb 1c                	jmp    1044c1 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
  1044a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044a8:	83 e8 0c             	sub    $0xc,%eax
  1044ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
  1044ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044b1:	8b 40 08             	mov    0x8(%eax),%eax
  1044b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  1044b7:	72 08                	jb     1044c1 <default_alloc_pages+0x62>
            page = p;
  1044b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1044bf:	eb 18                	jmp    1044d9 <default_alloc_pages+0x7a>
  1044c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1044c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1044ca:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1044cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044d0:	81 7d f0 68 a9 11 00 	cmpl   $0x11a968,-0x10(%ebp)
  1044d7:	75 cc                	jne    1044a5 <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  1044d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044dd:	0f 84 57 01 00 00    	je     10463a <default_alloc_pages+0x1db>
    	for (int i = 1; i < n; ++ i) {
  1044e3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  1044ea:	eb 4e                	jmp    10453a <default_alloc_pages+0xdb>
    		struct Page *p = page + i;
  1044ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1044ef:	89 d0                	mov    %edx,%eax
  1044f1:	c1 e0 02             	shl    $0x2,%eax
  1044f4:	01 d0                	add    %edx,%eax
  1044f6:	c1 e0 02             	shl    $0x2,%eax
  1044f9:	89 c2                	mov    %eax,%edx
  1044fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044fe:	01 d0                	add    %edx,%eax
  104500:	89 45 e0             	mov    %eax,-0x20(%ebp)
    		// assert(!PageReserved(p));
    		ClearPageProperty(p);
  104503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104506:	83 c0 04             	add    $0x4,%eax
  104509:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104510:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104513:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104516:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104519:	0f b3 10             	btr    %edx,(%eax)
    		p->property = 0;
  10451c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10451f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    		set_page_ref(p, 0);
  104526:	83 ec 08             	sub    $0x8,%esp
  104529:	6a 00                	push   $0x0
  10452b:	ff 75 e0             	pushl  -0x20(%ebp)
  10452e:	e8 c0 fd ff ff       	call   1042f3 <set_page_ref>
  104533:	83 c4 10             	add    $0x10,%esp
            page = p;
            break;
        }
    }
    if (page != NULL) {
    	for (int i = 1; i < n; ++ i) {
  104536:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  10453a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10453d:	3b 45 08             	cmp    0x8(%ebp),%eax
  104540:	72 aa                	jb     1044ec <default_alloc_pages+0x8d>
    		// assert(!PageReserved(p));
    		ClearPageProperty(p);
    		p->property = 0;
    		set_page_ref(p, 0);
    	}
        if (page->property > n) {
  104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104545:	8b 40 08             	mov    0x8(%eax),%eax
  104548:	3b 45 08             	cmp    0x8(%ebp),%eax
  10454b:	0f 86 98 00 00 00    	jbe    1045e9 <default_alloc_pages+0x18a>
            struct Page *p = page + n;
  104551:	8b 55 08             	mov    0x8(%ebp),%edx
  104554:	89 d0                	mov    %edx,%eax
  104556:	c1 e0 02             	shl    $0x2,%eax
  104559:	01 d0                	add    %edx,%eax
  10455b:	c1 e0 02             	shl    $0x2,%eax
  10455e:	89 c2                	mov    %eax,%edx
  104560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104563:	01 d0                	add    %edx,%eax
  104565:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;
  104568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10456b:	8b 40 08             	mov    0x8(%eax),%eax
  10456e:	2b 45 08             	sub    0x8(%ebp),%eax
  104571:	89 c2                	mov    %eax,%edx
  104573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104576:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104579:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10457c:	83 c0 04             	add    $0x4,%eax
  10457f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104586:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104589:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10458c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10458f:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
  104592:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104595:	83 c0 0c             	add    $0xc,%eax
  104598:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10459b:	83 c2 0c             	add    $0xc,%edx
  10459e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1045a1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1045a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045a7:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1045aa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1045ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1045b0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1045b3:	8b 40 04             	mov    0x4(%eax),%eax
  1045b6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1045b9:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  1045bc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1045bf:	89 55 b0             	mov    %edx,-0x50(%ebp)
  1045c2:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1045c5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1045c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1045cb:	89 10                	mov    %edx,(%eax)
  1045cd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1045d0:	8b 10                	mov    (%eax),%edx
  1045d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1045d5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1045d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1045db:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1045de:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1045e1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1045e4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1045e7:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  1045e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ec:	83 c0 0c             	add    $0xc,%eax
  1045ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1045f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1045f5:	8b 40 04             	mov    0x4(%eax),%eax
  1045f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1045fb:	8b 12                	mov    (%edx),%edx
  1045fd:	89 55 a0             	mov    %edx,-0x60(%ebp)
  104600:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104603:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104606:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104609:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10460c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10460f:	8b 55 a0             	mov    -0x60(%ebp),%edx
  104612:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  104614:	a1 70 a9 11 00       	mov    0x11a970,%eax
  104619:	2b 45 08             	sub    0x8(%ebp),%eax
  10461c:	a3 70 a9 11 00       	mov    %eax,0x11a970
        ClearPageProperty(page);
  104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104624:	83 c0 04             	add    $0x4,%eax
  104627:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10462e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104631:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104634:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104637:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  10463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10463d:	c9                   	leave  
  10463e:	c3                   	ret    

0010463f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  10463f:	55                   	push   %ebp
  104640:	89 e5                	mov    %esp,%ebp
  104642:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10464c:	75 16                	jne    104664 <default_free_pages+0x25>
  10464e:	68 88 77 10 00       	push   $0x107788
  104653:	68 8e 77 10 00       	push   $0x10778e
  104658:	6a 7c                	push   $0x7c
  10465a:	68 a3 77 10 00       	push   $0x1077a3
  10465f:	e8 69 bd ff ff       	call   1003cd <__panic>
    struct Page *p = base;
  104664:	8b 45 08             	mov    0x8(%ebp),%eax
  104667:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10466a:	e9 8c 00 00 00       	jmp    1046fb <default_free_pages+0xbc>
        assert(!PageReserved(p) && !PageProperty(p));
  10466f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104672:	83 c0 04             	add    $0x4,%eax
  104675:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  10467c:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10467f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104682:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104685:	0f a3 10             	bt     %edx,(%eax)
  104688:	19 c0                	sbb    %eax,%eax
  10468a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  10468d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  104691:	0f 95 c0             	setne  %al
  104694:	0f b6 c0             	movzbl %al,%eax
  104697:	85 c0                	test   %eax,%eax
  104699:	75 2c                	jne    1046c7 <default_free_pages+0x88>
  10469b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469e:	83 c0 04             	add    $0x4,%eax
  1046a1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1046a8:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1046ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1046ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1046b1:	0f a3 10             	bt     %edx,(%eax)
  1046b4:	19 c0                	sbb    %eax,%eax
  1046b6:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  1046b9:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  1046bd:	0f 95 c0             	setne  %al
  1046c0:	0f b6 c0             	movzbl %al,%eax
  1046c3:	85 c0                	test   %eax,%eax
  1046c5:	74 16                	je     1046dd <default_free_pages+0x9e>
  1046c7:	68 cc 77 10 00       	push   $0x1077cc
  1046cc:	68 8e 77 10 00       	push   $0x10778e
  1046d1:	6a 7f                	push   $0x7f
  1046d3:	68 a3 77 10 00       	push   $0x1077a3
  1046d8:	e8 f0 bc ff ff       	call   1003cd <__panic>
        p->flags = 0;
  1046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1046e7:	83 ec 08             	sub    $0x8,%esp
  1046ea:	6a 00                	push   $0x0
  1046ec:	ff 75 f4             	pushl  -0xc(%ebp)
  1046ef:	e8 ff fb ff ff       	call   1042f3 <set_page_ref>
  1046f4:	83 c4 10             	add    $0x10,%esp

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1046f7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1046fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046fe:	89 d0                	mov    %edx,%eax
  104700:	c1 e0 02             	shl    $0x2,%eax
  104703:	01 d0                	add    %edx,%eax
  104705:	c1 e0 02             	shl    $0x2,%eax
  104708:	89 c2                	mov    %eax,%edx
  10470a:	8b 45 08             	mov    0x8(%ebp),%eax
  10470d:	01 d0                	add    %edx,%eax
  10470f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104712:	0f 85 57 ff ff ff    	jne    10466f <default_free_pages+0x30>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  104718:	8b 45 08             	mov    0x8(%ebp),%eax
  10471b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10471e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104721:	8b 45 08             	mov    0x8(%ebp),%eax
  104724:	83 c0 04             	add    $0x4,%eax
  104727:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  10472e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104731:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104734:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104737:	0f ab 10             	bts    %edx,(%eax)
  10473a:	c7 45 e0 68 a9 11 00 	movl   $0x11a968,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104744:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *merge_previous = NULL;
  10474a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    struct Page *merge_next = NULL;
  104751:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while (le != &free_list) {
  104758:	eb 66                	jmp    1047c0 <default_free_pages+0x181>
        p = le2page(le, page_link);
  10475a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10475d:	83 e8 0c             	sub    $0xc,%eax
  104760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104766:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10476c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  10476f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104772:	8b 45 08             	mov    0x8(%ebp),%eax
  104775:	8b 50 08             	mov    0x8(%eax),%edx
  104778:	89 d0                	mov    %edx,%eax
  10477a:	c1 e0 02             	shl    $0x2,%eax
  10477d:	01 d0                	add    %edx,%eax
  10477f:	c1 e0 02             	shl    $0x2,%eax
  104782:	89 c2                	mov    %eax,%edx
  104784:	8b 45 08             	mov    0x8(%ebp),%eax
  104787:	01 d0                	add    %edx,%eax
  104789:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10478c:	75 08                	jne    104796 <default_free_pages+0x157>
        	merge_next = p;
  10478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104791:	89 45 e8             	mov    %eax,-0x18(%ebp)
        	break;
  104794:	eb 36                	jmp    1047cc <default_free_pages+0x18d>
        }
        else if (p + p->property == base) {
  104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104799:	8b 50 08             	mov    0x8(%eax),%edx
  10479c:	89 d0                	mov    %edx,%eax
  10479e:	c1 e0 02             	shl    $0x2,%eax
  1047a1:	01 d0                	add    %edx,%eax
  1047a3:	c1 e0 02             	shl    $0x2,%eax
  1047a6:	89 c2                	mov    %eax,%edx
  1047a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047ab:	01 d0                	add    %edx,%eax
  1047ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  1047b0:	75 06                	jne    1047b8 <default_free_pages+0x179>
            merge_previous = p;
  1047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        }
        if (p > base) break;
  1047b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  1047be:	77 0b                	ja     1047cb <default_free_pages+0x18c>
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    struct Page *merge_previous = NULL;
    struct Page *merge_next = NULL;
    while (le != &free_list) {
  1047c0:	81 7d f0 68 a9 11 00 	cmpl   $0x11a968,-0x10(%ebp)
  1047c7:	75 91                	jne    10475a <default_free_pages+0x11b>
  1047c9:	eb 01                	jmp    1047cc <default_free_pages+0x18d>
        	break;
        }
        else if (p + p->property == base) {
            merge_previous = p;
        }
        if (p > base) break;
  1047cb:	90                   	nop
    }
    nr_free += n;
  1047cc:	8b 15 70 a9 11 00    	mov    0x11a970,%edx
  1047d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047d5:	01 d0                	add    %edx,%eax
  1047d7:	a3 70 a9 11 00       	mov    %eax,0x11a970
    // Try to merge base with merge_previous and merge_next.
    if (merge_previous != NULL) {
  1047dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1047e0:	74 33                	je     104815 <default_free_pages+0x1d6>
    	merge_previous->property += base->property;
  1047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047e5:	8b 50 08             	mov    0x8(%eax),%edx
  1047e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1047eb:	8b 40 08             	mov    0x8(%eax),%eax
  1047ee:	01 c2                	add    %eax,%edx
  1047f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047f3:	89 50 08             	mov    %edx,0x8(%eax)
    	ClearPageProperty(base);
  1047f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f9:	83 c0 04             	add    $0x4,%eax
  1047fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104803:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104806:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104809:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10480c:	0f b3 10             	btr    %edx,(%eax)
    	base = merge_previous;
  10480f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104812:	89 45 08             	mov    %eax,0x8(%ebp)
    }
    if (merge_next != NULL) {
  104815:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104819:	0f 84 a8 00 00 00    	je     1048c7 <default_free_pages+0x288>
    	base->property += merge_next->property;
  10481f:	8b 45 08             	mov    0x8(%ebp),%eax
  104822:	8b 50 08             	mov    0x8(%eax),%edx
  104825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104828:	8b 40 08             	mov    0x8(%eax),%eax
  10482b:	01 c2                	add    %eax,%edx
  10482d:	8b 45 08             	mov    0x8(%ebp),%eax
  104830:	89 50 08             	mov    %edx,0x8(%eax)
    	ClearPageProperty(merge_next);
  104833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104836:	83 c0 04             	add    $0x4,%eax
  104839:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104840:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104843:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104846:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104849:	0f b3 10             	btr    %edx,(%eax)
    	if (merge_previous == NULL) {
  10484c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104850:	75 4a                	jne    10489c <default_free_pages+0x25d>
    		list_add_before(&(merge_next->page_link), &(base->page_link));
  104852:	8b 45 08             	mov    0x8(%ebp),%eax
  104855:	83 c0 0c             	add    $0xc,%eax
  104858:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10485b:	83 c2 0c             	add    $0xc,%edx
  10485e:	89 55 cc             	mov    %edx,-0x34(%ebp)
  104861:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104864:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104867:	8b 00                	mov    (%eax),%eax
  104869:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10486c:	89 55 98             	mov    %edx,-0x68(%ebp)
  10486f:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104872:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104875:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104878:	8b 45 90             	mov    -0x70(%ebp),%eax
  10487b:	8b 55 98             	mov    -0x68(%ebp),%edx
  10487e:	89 10                	mov    %edx,(%eax)
  104880:	8b 45 90             	mov    -0x70(%ebp),%eax
  104883:	8b 10                	mov    (%eax),%edx
  104885:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104888:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10488b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10488e:	8b 55 90             	mov    -0x70(%ebp),%edx
  104891:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104894:	8b 45 98             	mov    -0x68(%ebp),%eax
  104897:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10489a:	89 10                	mov    %edx,(%eax)
    	}

    	list_del(&(merge_next->page_link));
  10489c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10489f:	83 c0 0c             	add    $0xc,%eax
  1048a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1048a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048a8:	8b 40 04             	mov    0x4(%eax),%eax
  1048ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1048ae:	8b 12                	mov    (%edx),%edx
  1048b0:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1048b3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1048b6:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1048b9:	8b 55 88             	mov    -0x78(%ebp),%edx
  1048bc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1048bf:	8b 45 88             	mov    -0x78(%ebp),%eax
  1048c2:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1048c5:	89 10                	mov    %edx,(%eax)
    }
    if (merge_next == NULL && merge_previous == NULL) {
  1048c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1048cb:	0f 85 fc 00 00 00    	jne    1049cd <default_free_pages+0x38e>
  1048d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1048d5:	0f 85 f2 00 00 00    	jne    1049cd <default_free_pages+0x38e>
    	if (p > base && p != (base + n)) {
  1048db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048de:	3b 45 08             	cmp    0x8(%ebp),%eax
  1048e1:	76 7b                	jbe    10495e <default_free_pages+0x31f>
  1048e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048e6:	89 d0                	mov    %edx,%eax
  1048e8:	c1 e0 02             	shl    $0x2,%eax
  1048eb:	01 d0                	add    %edx,%eax
  1048ed:	c1 e0 02             	shl    $0x2,%eax
  1048f0:	89 c2                	mov    %eax,%edx
  1048f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f5:	01 d0                	add    %edx,%eax
  1048f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048fa:	74 62                	je     10495e <default_free_pages+0x31f>
    		list_add_before(&(p->page_link), &(base->page_link));
  1048fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ff:	83 c0 0c             	add    $0xc,%eax
  104902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104905:	83 c2 0c             	add    $0xc,%edx
  104908:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  10490b:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10490e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104911:	8b 00                	mov    (%eax),%eax
  104913:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104916:	89 55 80             	mov    %edx,-0x80(%ebp)
  104919:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  10491f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104922:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104928:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  10492e:	8b 55 80             	mov    -0x80(%ebp),%edx
  104931:	89 10                	mov    %edx,(%eax)
  104933:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  104939:	8b 10                	mov    (%eax),%edx
  10493b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104941:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104944:	8b 45 80             	mov    -0x80(%ebp),%eax
  104947:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  10494d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104950:	8b 45 80             	mov    -0x80(%ebp),%eax
  104953:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  104959:	89 10                	mov    %edx,(%eax)
  10495b:	90                   	nop
    	} else {
    		list_add_before(&free_list, &(base->page_link));
    	}
    }
}
  10495c:	eb 6f                	jmp    1049cd <default_free_pages+0x38e>
    }
    if (merge_next == NULL && merge_previous == NULL) {
    	if (p > base && p != (base + n)) {
    		list_add_before(&(p->page_link), &(base->page_link));
    	} else {
    		list_add_before(&free_list, &(base->page_link));
  10495e:	8b 45 08             	mov    0x8(%ebp),%eax
  104961:	83 c0 0c             	add    $0xc,%eax
  104964:	c7 45 c0 68 a9 11 00 	movl   $0x11a968,-0x40(%ebp)
  10496b:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104971:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104974:	8b 00                	mov    (%eax),%eax
  104976:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  10497c:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  104982:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  104988:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10498b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104991:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  104997:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  10499d:	89 10                	mov    %edx,(%eax)
  10499f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  1049a5:	8b 10                	mov    (%eax),%edx
  1049a7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  1049ad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1049b0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  1049b6:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  1049bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1049bf:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  1049c5:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  1049cb:	89 10                	mov    %edx,(%eax)
    	}
    }
}
  1049cd:	90                   	nop
  1049ce:	c9                   	leave  
  1049cf:	c3                   	ret    

001049d0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1049d0:	55                   	push   %ebp
  1049d1:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1049d3:	a1 70 a9 11 00       	mov    0x11a970,%eax
}
  1049d8:	5d                   	pop    %ebp
  1049d9:	c3                   	ret    

001049da <basic_check>:
    cprintf("+ 1 = %x, 1.next = %x, prev = %x\n", &(p2->page_link), p2->page_link.next, p2->page_link.prev);
    cprintf("+ 2 = %x, 2.next = %x, prev = %x\n", &(p3->page_link), p3->page_link.next, p3->page_link.prev);
}
*/
static void
basic_check(void) {
  1049da:	55                   	push   %ebp
  1049db:	89 e5                	mov    %esp,%ebp
  1049dd:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1049e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1049e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1049f3:	83 ec 0c             	sub    $0xc,%esp
  1049f6:	6a 01                	push   $0x1
  1049f8:	e8 72 e3 ff ff       	call   102d6f <alloc_pages>
  1049fd:	83 c4 10             	add    $0x10,%esp
  104a00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a07:	75 19                	jne    104a22 <basic_check+0x48>
  104a09:	68 f1 77 10 00       	push   $0x1077f1
  104a0e:	68 8e 77 10 00       	push   $0x10778e
  104a13:	68 be 00 00 00       	push   $0xbe
  104a18:	68 a3 77 10 00       	push   $0x1077a3
  104a1d:	e8 ab b9 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a22:	83 ec 0c             	sub    $0xc,%esp
  104a25:	6a 01                	push   $0x1
  104a27:	e8 43 e3 ff ff       	call   102d6f <alloc_pages>
  104a2c:	83 c4 10             	add    $0x10,%esp
  104a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a36:	75 19                	jne    104a51 <basic_check+0x77>
  104a38:	68 0d 78 10 00       	push   $0x10780d
  104a3d:	68 8e 77 10 00       	push   $0x10778e
  104a42:	68 bf 00 00 00       	push   $0xbf
  104a47:	68 a3 77 10 00       	push   $0x1077a3
  104a4c:	e8 7c b9 ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  104a51:	83 ec 0c             	sub    $0xc,%esp
  104a54:	6a 01                	push   $0x1
  104a56:	e8 14 e3 ff ff       	call   102d6f <alloc_pages>
  104a5b:	83 c4 10             	add    $0x10,%esp
  104a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a65:	75 19                	jne    104a80 <basic_check+0xa6>
  104a67:	68 29 78 10 00       	push   $0x107829
  104a6c:	68 8e 77 10 00       	push   $0x10778e
  104a71:	68 c0 00 00 00       	push   $0xc0
  104a76:	68 a3 77 10 00       	push   $0x1077a3
  104a7b:	e8 4d b9 ff ff       	call   1003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104a86:	74 10                	je     104a98 <basic_check+0xbe>
  104a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a8e:	74 08                	je     104a98 <basic_check+0xbe>
  104a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a96:	75 19                	jne    104ab1 <basic_check+0xd7>
  104a98:	68 48 78 10 00       	push   $0x107848
  104a9d:	68 8e 77 10 00       	push   $0x10778e
  104aa2:	68 c2 00 00 00       	push   $0xc2
  104aa7:	68 a3 77 10 00       	push   $0x1077a3
  104aac:	e8 1c b9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104ab1:	83 ec 0c             	sub    $0xc,%esp
  104ab4:	ff 75 ec             	pushl  -0x14(%ebp)
  104ab7:	e8 2d f8 ff ff       	call   1042e9 <page_ref>
  104abc:	83 c4 10             	add    $0x10,%esp
  104abf:	85 c0                	test   %eax,%eax
  104ac1:	75 24                	jne    104ae7 <basic_check+0x10d>
  104ac3:	83 ec 0c             	sub    $0xc,%esp
  104ac6:	ff 75 f0             	pushl  -0x10(%ebp)
  104ac9:	e8 1b f8 ff ff       	call   1042e9 <page_ref>
  104ace:	83 c4 10             	add    $0x10,%esp
  104ad1:	85 c0                	test   %eax,%eax
  104ad3:	75 12                	jne    104ae7 <basic_check+0x10d>
  104ad5:	83 ec 0c             	sub    $0xc,%esp
  104ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  104adb:	e8 09 f8 ff ff       	call   1042e9 <page_ref>
  104ae0:	83 c4 10             	add    $0x10,%esp
  104ae3:	85 c0                	test   %eax,%eax
  104ae5:	74 19                	je     104b00 <basic_check+0x126>
  104ae7:	68 6c 78 10 00       	push   $0x10786c
  104aec:	68 8e 77 10 00       	push   $0x10778e
  104af1:	68 c3 00 00 00       	push   $0xc3
  104af6:	68 a3 77 10 00       	push   $0x1077a3
  104afb:	e8 cd b8 ff ff       	call   1003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104b00:	83 ec 0c             	sub    $0xc,%esp
  104b03:	ff 75 ec             	pushl  -0x14(%ebp)
  104b06:	e8 cb f7 ff ff       	call   1042d6 <page2pa>
  104b0b:	83 c4 10             	add    $0x10,%esp
  104b0e:	89 c2                	mov    %eax,%edx
  104b10:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  104b15:	c1 e0 0c             	shl    $0xc,%eax
  104b18:	39 c2                	cmp    %eax,%edx
  104b1a:	72 19                	jb     104b35 <basic_check+0x15b>
  104b1c:	68 a8 78 10 00       	push   $0x1078a8
  104b21:	68 8e 77 10 00       	push   $0x10778e
  104b26:	68 c5 00 00 00       	push   $0xc5
  104b2b:	68 a3 77 10 00       	push   $0x1077a3
  104b30:	e8 98 b8 ff ff       	call   1003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104b35:	83 ec 0c             	sub    $0xc,%esp
  104b38:	ff 75 f0             	pushl  -0x10(%ebp)
  104b3b:	e8 96 f7 ff ff       	call   1042d6 <page2pa>
  104b40:	83 c4 10             	add    $0x10,%esp
  104b43:	89 c2                	mov    %eax,%edx
  104b45:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  104b4a:	c1 e0 0c             	shl    $0xc,%eax
  104b4d:	39 c2                	cmp    %eax,%edx
  104b4f:	72 19                	jb     104b6a <basic_check+0x190>
  104b51:	68 c5 78 10 00       	push   $0x1078c5
  104b56:	68 8e 77 10 00       	push   $0x10778e
  104b5b:	68 c6 00 00 00       	push   $0xc6
  104b60:	68 a3 77 10 00       	push   $0x1077a3
  104b65:	e8 63 b8 ff ff       	call   1003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104b6a:	83 ec 0c             	sub    $0xc,%esp
  104b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  104b70:	e8 61 f7 ff ff       	call   1042d6 <page2pa>
  104b75:	83 c4 10             	add    $0x10,%esp
  104b78:	89 c2                	mov    %eax,%edx
  104b7a:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  104b7f:	c1 e0 0c             	shl    $0xc,%eax
  104b82:	39 c2                	cmp    %eax,%edx
  104b84:	72 19                	jb     104b9f <basic_check+0x1c5>
  104b86:	68 e2 78 10 00       	push   $0x1078e2
  104b8b:	68 8e 77 10 00       	push   $0x10778e
  104b90:	68 c7 00 00 00       	push   $0xc7
  104b95:	68 a3 77 10 00       	push   $0x1077a3
  104b9a:	e8 2e b8 ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104b9f:	a1 68 a9 11 00       	mov    0x11a968,%eax
  104ba4:	8b 15 6c a9 11 00    	mov    0x11a96c,%edx
  104baa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104bad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104bb0:	c7 45 e4 68 a9 11 00 	movl   $0x11a968,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104bbd:	89 50 04             	mov    %edx,0x4(%eax)
  104bc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bc3:	8b 50 04             	mov    0x4(%eax),%edx
  104bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bc9:	89 10                	mov    %edx,(%eax)
  104bcb:	c7 45 d8 68 a9 11 00 	movl   $0x11a968,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104bd2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104bd5:	8b 40 04             	mov    0x4(%eax),%eax
  104bd8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104bdb:	0f 94 c0             	sete   %al
  104bde:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104be1:	85 c0                	test   %eax,%eax
  104be3:	75 19                	jne    104bfe <basic_check+0x224>
  104be5:	68 ff 78 10 00       	push   $0x1078ff
  104bea:	68 8e 77 10 00       	push   $0x10778e
  104bef:	68 cb 00 00 00       	push   $0xcb
  104bf4:	68 a3 77 10 00       	push   $0x1077a3
  104bf9:	e8 cf b7 ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  104bfe:	a1 70 a9 11 00       	mov    0x11a970,%eax
  104c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  104c06:	c7 05 70 a9 11 00 00 	movl   $0x0,0x11a970
  104c0d:	00 00 00 

    assert(alloc_page() == NULL);
  104c10:	83 ec 0c             	sub    $0xc,%esp
  104c13:	6a 01                	push   $0x1
  104c15:	e8 55 e1 ff ff       	call   102d6f <alloc_pages>
  104c1a:	83 c4 10             	add    $0x10,%esp
  104c1d:	85 c0                	test   %eax,%eax
  104c1f:	74 19                	je     104c3a <basic_check+0x260>
  104c21:	68 16 79 10 00       	push   $0x107916
  104c26:	68 8e 77 10 00       	push   $0x10778e
  104c2b:	68 d0 00 00 00       	push   $0xd0
  104c30:	68 a3 77 10 00       	push   $0x1077a3
  104c35:	e8 93 b7 ff ff       	call   1003cd <__panic>
    free_page(p0);
  104c3a:	83 ec 08             	sub    $0x8,%esp
  104c3d:	6a 01                	push   $0x1
  104c3f:	ff 75 ec             	pushl  -0x14(%ebp)
  104c42:	e8 66 e1 ff ff       	call   102dad <free_pages>
  104c47:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104c4a:	83 ec 08             	sub    $0x8,%esp
  104c4d:	6a 01                	push   $0x1
  104c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  104c52:	e8 56 e1 ff ff       	call   102dad <free_pages>
  104c57:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104c5a:	83 ec 08             	sub    $0x8,%esp
  104c5d:	6a 01                	push   $0x1
  104c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  104c62:	e8 46 e1 ff ff       	call   102dad <free_pages>
  104c67:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  104c6a:	a1 70 a9 11 00       	mov    0x11a970,%eax
  104c6f:	83 f8 03             	cmp    $0x3,%eax
  104c72:	74 19                	je     104c8d <basic_check+0x2b3>
  104c74:	68 2b 79 10 00       	push   $0x10792b
  104c79:	68 8e 77 10 00       	push   $0x10778e
  104c7e:	68 d4 00 00 00       	push   $0xd4
  104c83:	68 a3 77 10 00       	push   $0x1077a3
  104c88:	e8 40 b7 ff ff       	call   1003cd <__panic>
    assert((p0 = alloc_page()) != NULL);
  104c8d:	83 ec 0c             	sub    $0xc,%esp
  104c90:	6a 01                	push   $0x1
  104c92:	e8 d8 e0 ff ff       	call   102d6f <alloc_pages>
  104c97:	83 c4 10             	add    $0x10,%esp
  104c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104ca1:	75 19                	jne    104cbc <basic_check+0x2e2>
  104ca3:	68 f1 77 10 00       	push   $0x1077f1
  104ca8:	68 8e 77 10 00       	push   $0x10778e
  104cad:	68 d5 00 00 00       	push   $0xd5
  104cb2:	68 a3 77 10 00       	push   $0x1077a3
  104cb7:	e8 11 b7 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104cbc:	83 ec 0c             	sub    $0xc,%esp
  104cbf:	6a 01                	push   $0x1
  104cc1:	e8 a9 e0 ff ff       	call   102d6f <alloc_pages>
  104cc6:	83 c4 10             	add    $0x10,%esp
  104cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ccc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cd0:	75 19                	jne    104ceb <basic_check+0x311>
  104cd2:	68 0d 78 10 00       	push   $0x10780d
  104cd7:	68 8e 77 10 00       	push   $0x10778e
  104cdc:	68 d6 00 00 00       	push   $0xd6
  104ce1:	68 a3 77 10 00       	push   $0x1077a3
  104ce6:	e8 e2 b6 ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  104ceb:	83 ec 0c             	sub    $0xc,%esp
  104cee:	6a 01                	push   $0x1
  104cf0:	e8 7a e0 ff ff       	call   102d6f <alloc_pages>
  104cf5:	83 c4 10             	add    $0x10,%esp
  104cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104cff:	75 19                	jne    104d1a <basic_check+0x340>
  104d01:	68 29 78 10 00       	push   $0x107829
  104d06:	68 8e 77 10 00       	push   $0x10778e
  104d0b:	68 d7 00 00 00       	push   $0xd7
  104d10:	68 a3 77 10 00       	push   $0x1077a3
  104d15:	e8 b3 b6 ff ff       	call   1003cd <__panic>

    assert(alloc_page() == NULL);
  104d1a:	83 ec 0c             	sub    $0xc,%esp
  104d1d:	6a 01                	push   $0x1
  104d1f:	e8 4b e0 ff ff       	call   102d6f <alloc_pages>
  104d24:	83 c4 10             	add    $0x10,%esp
  104d27:	85 c0                	test   %eax,%eax
  104d29:	74 19                	je     104d44 <basic_check+0x36a>
  104d2b:	68 16 79 10 00       	push   $0x107916
  104d30:	68 8e 77 10 00       	push   $0x10778e
  104d35:	68 d9 00 00 00       	push   $0xd9
  104d3a:	68 a3 77 10 00       	push   $0x1077a3
  104d3f:	e8 89 b6 ff ff       	call   1003cd <__panic>

    free_page(p0);
  104d44:	83 ec 08             	sub    $0x8,%esp
  104d47:	6a 01                	push   $0x1
  104d49:	ff 75 ec             	pushl  -0x14(%ebp)
  104d4c:	e8 5c e0 ff ff       	call   102dad <free_pages>
  104d51:	83 c4 10             	add    $0x10,%esp
  104d54:	c7 45 e8 68 a9 11 00 	movl   $0x11a968,-0x18(%ebp)
  104d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d5e:	8b 40 04             	mov    0x4(%eax),%eax
  104d61:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104d64:	0f 94 c0             	sete   %al
  104d67:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104d6a:	85 c0                	test   %eax,%eax
  104d6c:	74 19                	je     104d87 <basic_check+0x3ad>
  104d6e:	68 38 79 10 00       	push   $0x107938
  104d73:	68 8e 77 10 00       	push   $0x10778e
  104d78:	68 dc 00 00 00       	push   $0xdc
  104d7d:	68 a3 77 10 00       	push   $0x1077a3
  104d82:	e8 46 b6 ff ff       	call   1003cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104d87:	83 ec 0c             	sub    $0xc,%esp
  104d8a:	6a 01                	push   $0x1
  104d8c:	e8 de df ff ff       	call   102d6f <alloc_pages>
  104d91:	83 c4 10             	add    $0x10,%esp
  104d94:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d9a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104d9d:	74 19                	je     104db8 <basic_check+0x3de>
  104d9f:	68 50 79 10 00       	push   $0x107950
  104da4:	68 8e 77 10 00       	push   $0x10778e
  104da9:	68 df 00 00 00       	push   $0xdf
  104dae:	68 a3 77 10 00       	push   $0x1077a3
  104db3:	e8 15 b6 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104db8:	83 ec 0c             	sub    $0xc,%esp
  104dbb:	6a 01                	push   $0x1
  104dbd:	e8 ad df ff ff       	call   102d6f <alloc_pages>
  104dc2:	83 c4 10             	add    $0x10,%esp
  104dc5:	85 c0                	test   %eax,%eax
  104dc7:	74 19                	je     104de2 <basic_check+0x408>
  104dc9:	68 16 79 10 00       	push   $0x107916
  104dce:	68 8e 77 10 00       	push   $0x10778e
  104dd3:	68 e0 00 00 00       	push   $0xe0
  104dd8:	68 a3 77 10 00       	push   $0x1077a3
  104ddd:	e8 eb b5 ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  104de2:	a1 70 a9 11 00       	mov    0x11a970,%eax
  104de7:	85 c0                	test   %eax,%eax
  104de9:	74 19                	je     104e04 <basic_check+0x42a>
  104deb:	68 69 79 10 00       	push   $0x107969
  104df0:	68 8e 77 10 00       	push   $0x10778e
  104df5:	68 e2 00 00 00       	push   $0xe2
  104dfa:	68 a3 77 10 00       	push   $0x1077a3
  104dff:	e8 c9 b5 ff ff       	call   1003cd <__panic>
    free_list = free_list_store;
  104e04:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104e07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104e0a:	a3 68 a9 11 00       	mov    %eax,0x11a968
  104e0f:	89 15 6c a9 11 00    	mov    %edx,0x11a96c
    nr_free = nr_free_store;
  104e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e18:	a3 70 a9 11 00       	mov    %eax,0x11a970

    free_page(p);
  104e1d:	83 ec 08             	sub    $0x8,%esp
  104e20:	6a 01                	push   $0x1
  104e22:	ff 75 dc             	pushl  -0x24(%ebp)
  104e25:	e8 83 df ff ff       	call   102dad <free_pages>
  104e2a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104e2d:	83 ec 08             	sub    $0x8,%esp
  104e30:	6a 01                	push   $0x1
  104e32:	ff 75 f0             	pushl  -0x10(%ebp)
  104e35:	e8 73 df ff ff       	call   102dad <free_pages>
  104e3a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104e3d:	83 ec 08             	sub    $0x8,%esp
  104e40:	6a 01                	push   $0x1
  104e42:	ff 75 f4             	pushl  -0xc(%ebp)
  104e45:	e8 63 df ff ff       	call   102dad <free_pages>
  104e4a:	83 c4 10             	add    $0x10,%esp
}
  104e4d:	90                   	nop
  104e4e:	c9                   	leave  
  104e4f:	c3                   	ret    

00104e50 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104e50:	55                   	push   %ebp
  104e51:	89 e5                	mov    %esp,%ebp
  104e53:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  104e59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104e67:	c7 45 ec 68 a9 11 00 	movl   $0x11a968,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104e6e:	eb 60                	jmp    104ed0 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  104e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e73:	83 e8 0c             	sub    $0xc,%eax
  104e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e7c:	83 c0 04             	add    $0x4,%eax
  104e7f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104e86:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e89:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104e8c:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104e8f:	0f a3 10             	bt     %edx,(%eax)
  104e92:	19 c0                	sbb    %eax,%eax
  104e94:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104e97:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104e9b:	0f 95 c0             	setne  %al
  104e9e:	0f b6 c0             	movzbl %al,%eax
  104ea1:	85 c0                	test   %eax,%eax
  104ea3:	75 19                	jne    104ebe <default_check+0x6e>
  104ea5:	68 76 79 10 00       	push   $0x107976
  104eaa:	68 8e 77 10 00       	push   $0x10778e
  104eaf:	68 f3 00 00 00       	push   $0xf3
  104eb4:	68 a3 77 10 00       	push   $0x1077a3
  104eb9:	e8 0f b5 ff ff       	call   1003cd <__panic>
        count ++, total += p->property;
  104ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ec5:	8b 50 08             	mov    0x8(%eax),%edx
  104ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ecb:	01 d0                	add    %edx,%eax
  104ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ed9:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104edf:	81 7d ec 68 a9 11 00 	cmpl   $0x11a968,-0x14(%ebp)
  104ee6:	75 88                	jne    104e70 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104ee8:	e8 f5 de ff ff       	call   102de2 <nr_free_pages>
  104eed:	89 c2                	mov    %eax,%edx
  104eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef2:	39 c2                	cmp    %eax,%edx
  104ef4:	74 19                	je     104f0f <default_check+0xbf>
  104ef6:	68 86 79 10 00       	push   $0x107986
  104efb:	68 8e 77 10 00       	push   $0x10778e
  104f00:	68 f6 00 00 00       	push   $0xf6
  104f05:	68 a3 77 10 00       	push   $0x1077a3
  104f0a:	e8 be b4 ff ff       	call   1003cd <__panic>

    basic_check();
  104f0f:	e8 c6 fa ff ff       	call   1049da <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104f14:	83 ec 0c             	sub    $0xc,%esp
  104f17:	6a 05                	push   $0x5
  104f19:	e8 51 de ff ff       	call   102d6f <alloc_pages>
  104f1e:	83 c4 10             	add    $0x10,%esp
  104f21:	89 45 dc             	mov    %eax,-0x24(%ebp)
    struct Page *p0_saved = p0;
  104f24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f27:	89 45 d8             	mov    %eax,-0x28(%ebp)

    assert(p0 != NULL);
  104f2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104f2e:	75 19                	jne    104f49 <default_check+0xf9>
  104f30:	68 9f 79 10 00       	push   $0x10799f
  104f35:	68 8e 77 10 00       	push   $0x10778e
  104f3a:	68 fd 00 00 00       	push   $0xfd
  104f3f:	68 a3 77 10 00       	push   $0x1077a3
  104f44:	e8 84 b4 ff ff       	call   1003cd <__panic>
    assert(!PageProperty(p0));
  104f49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f4c:	83 c0 04             	add    $0x4,%eax
  104f4f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104f56:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f59:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104f5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104f5f:	0f a3 10             	bt     %edx,(%eax)
  104f62:	19 c0                	sbb    %eax,%eax
  104f64:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
  104f67:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  104f6b:	0f 95 c0             	setne  %al
  104f6e:	0f b6 c0             	movzbl %al,%eax
  104f71:	85 c0                	test   %eax,%eax
  104f73:	74 19                	je     104f8e <default_check+0x13e>
  104f75:	68 aa 79 10 00       	push   $0x1079aa
  104f7a:	68 8e 77 10 00       	push   $0x10778e
  104f7f:	68 fe 00 00 00       	push   $0xfe
  104f84:	68 a3 77 10 00       	push   $0x1077a3
  104f89:	e8 3f b4 ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104f8e:	a1 68 a9 11 00       	mov    0x11a968,%eax
  104f93:	8b 15 6c a9 11 00    	mov    0x11a96c,%edx
  104f99:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104f9f:	89 55 80             	mov    %edx,-0x80(%ebp)
  104fa2:	c7 45 cc 68 a9 11 00 	movl   $0x11a968,-0x34(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104fa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104fac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104faf:	89 50 04             	mov    %edx,0x4(%eax)
  104fb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104fb5:	8b 50 04             	mov    0x4(%eax),%edx
  104fb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104fbb:	89 10                	mov    %edx,(%eax)
  104fbd:	c7 45 d4 68 a9 11 00 	movl   $0x11a968,-0x2c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104fc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fc7:	8b 40 04             	mov    0x4(%eax),%eax
  104fca:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  104fcd:	0f 94 c0             	sete   %al
  104fd0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104fd3:	85 c0                	test   %eax,%eax
  104fd5:	75 19                	jne    104ff0 <default_check+0x1a0>
  104fd7:	68 ff 78 10 00       	push   $0x1078ff
  104fdc:	68 8e 77 10 00       	push   $0x10778e
  104fe1:	68 02 01 00 00       	push   $0x102
  104fe6:	68 a3 77 10 00       	push   $0x1077a3
  104feb:	e8 dd b3 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104ff0:	83 ec 0c             	sub    $0xc,%esp
  104ff3:	6a 01                	push   $0x1
  104ff5:	e8 75 dd ff ff       	call   102d6f <alloc_pages>
  104ffa:	83 c4 10             	add    $0x10,%esp
  104ffd:	85 c0                	test   %eax,%eax
  104fff:	74 19                	je     10501a <default_check+0x1ca>
  105001:	68 16 79 10 00       	push   $0x107916
  105006:	68 8e 77 10 00       	push   $0x10778e
  10500b:	68 03 01 00 00       	push   $0x103
  105010:	68 a3 77 10 00       	push   $0x1077a3
  105015:	e8 b3 b3 ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  10501a:	a1 70 a9 11 00       	mov    0x11a970,%eax
  10501f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    nr_free = 0;
  105022:	c7 05 70 a9 11 00 00 	movl   $0x0,0x11a970
  105029:	00 00 00 

    free_pages(p0 + 2, 3);
  10502c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10502f:	83 c0 28             	add    $0x28,%eax
  105032:	83 ec 08             	sub    $0x8,%esp
  105035:	6a 03                	push   $0x3
  105037:	50                   	push   %eax
  105038:	e8 70 dd ff ff       	call   102dad <free_pages>
  10503d:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  105040:	83 ec 0c             	sub    $0xc,%esp
  105043:	6a 04                	push   $0x4
  105045:	e8 25 dd ff ff       	call   102d6f <alloc_pages>
  10504a:	83 c4 10             	add    $0x10,%esp
  10504d:	85 c0                	test   %eax,%eax
  10504f:	74 19                	je     10506a <default_check+0x21a>
  105051:	68 bc 79 10 00       	push   $0x1079bc
  105056:	68 8e 77 10 00       	push   $0x10778e
  10505b:	68 09 01 00 00       	push   $0x109
  105060:	68 a3 77 10 00       	push   $0x1077a3
  105065:	e8 63 b3 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10506a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10506d:	83 c0 28             	add    $0x28,%eax
  105070:	83 c0 04             	add    $0x4,%eax
  105073:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10507a:	89 45 98             	mov    %eax,-0x68(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10507d:	8b 45 98             	mov    -0x68(%ebp),%eax
  105080:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105083:	0f a3 10             	bt     %edx,(%eax)
  105086:	19 c0                	sbb    %eax,%eax
  105088:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return oldbit != 0;
  10508b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  10508f:	0f 95 c0             	setne  %al
  105092:	0f b6 c0             	movzbl %al,%eax
  105095:	85 c0                	test   %eax,%eax
  105097:	74 0e                	je     1050a7 <default_check+0x257>
  105099:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10509c:	83 c0 28             	add    $0x28,%eax
  10509f:	8b 40 08             	mov    0x8(%eax),%eax
  1050a2:	83 f8 03             	cmp    $0x3,%eax
  1050a5:	74 19                	je     1050c0 <default_check+0x270>
  1050a7:	68 d4 79 10 00       	push   $0x1079d4
  1050ac:	68 8e 77 10 00       	push   $0x10778e
  1050b1:	68 0a 01 00 00       	push   $0x10a
  1050b6:	68 a3 77 10 00       	push   $0x1077a3
  1050bb:	e8 0d b3 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1050c0:	83 ec 0c             	sub    $0xc,%esp
  1050c3:	6a 03                	push   $0x3
  1050c5:	e8 a5 dc ff ff       	call   102d6f <alloc_pages>
  1050ca:	83 c4 10             	add    $0x10,%esp
  1050cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1050d0:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  1050d4:	75 19                	jne    1050ef <default_check+0x29f>
  1050d6:	68 00 7a 10 00       	push   $0x107a00
  1050db:	68 8e 77 10 00       	push   $0x10778e
  1050e0:	68 0b 01 00 00       	push   $0x10b
  1050e5:	68 a3 77 10 00       	push   $0x1077a3
  1050ea:	e8 de b2 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  1050ef:	83 ec 0c             	sub    $0xc,%esp
  1050f2:	6a 01                	push   $0x1
  1050f4:	e8 76 dc ff ff       	call   102d6f <alloc_pages>
  1050f9:	83 c4 10             	add    $0x10,%esp
  1050fc:	85 c0                	test   %eax,%eax
  1050fe:	74 19                	je     105119 <default_check+0x2c9>
  105100:	68 16 79 10 00       	push   $0x107916
  105105:	68 8e 77 10 00       	push   $0x10778e
  10510a:	68 0c 01 00 00       	push   $0x10c
  10510f:	68 a3 77 10 00       	push   $0x1077a3
  105114:	e8 b4 b2 ff ff       	call   1003cd <__panic>
    assert(p0 + 2 == p1);
  105119:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10511c:	83 c0 28             	add    $0x28,%eax
  10511f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  105122:	74 19                	je     10513d <default_check+0x2ed>
  105124:	68 1e 7a 10 00       	push   $0x107a1e
  105129:	68 8e 77 10 00       	push   $0x10778e
  10512e:	68 0d 01 00 00       	push   $0x10d
  105133:	68 a3 77 10 00       	push   $0x1077a3
  105138:	e8 90 b2 ff ff       	call   1003cd <__panic>

    p2 = p0 + 1;
  10513d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105140:	83 c0 14             	add    $0x14,%eax
  105143:	89 45 bc             	mov    %eax,-0x44(%ebp)
    free_page(p0);
  105146:	83 ec 08             	sub    $0x8,%esp
  105149:	6a 01                	push   $0x1
  10514b:	ff 75 dc             	pushl  -0x24(%ebp)
  10514e:	e8 5a dc ff ff       	call   102dad <free_pages>
  105153:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  105156:	83 ec 08             	sub    $0x8,%esp
  105159:	6a 03                	push   $0x3
  10515b:	ff 75 c0             	pushl  -0x40(%ebp)
  10515e:	e8 4a dc ff ff       	call   102dad <free_pages>
  105163:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  105166:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105169:	83 c0 04             	add    $0x4,%eax
  10516c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  105173:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105176:	8b 45 90             	mov    -0x70(%ebp),%eax
  105179:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10517c:	0f a3 10             	bt     %edx,(%eax)
  10517f:	19 c0                	sbb    %eax,%eax
  105181:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105184:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105188:	0f 95 c0             	setne  %al
  10518b:	0f b6 c0             	movzbl %al,%eax
  10518e:	85 c0                	test   %eax,%eax
  105190:	74 0b                	je     10519d <default_check+0x34d>
  105192:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105195:	8b 40 08             	mov    0x8(%eax),%eax
  105198:	83 f8 01             	cmp    $0x1,%eax
  10519b:	74 19                	je     1051b6 <default_check+0x366>
  10519d:	68 2c 7a 10 00       	push   $0x107a2c
  1051a2:	68 8e 77 10 00       	push   $0x10778e
  1051a7:	68 12 01 00 00       	push   $0x112
  1051ac:	68 a3 77 10 00       	push   $0x1077a3
  1051b1:	e8 17 b2 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1051b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1051b9:	83 c0 04             	add    $0x4,%eax
  1051bc:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1051c3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051c6:	8b 45 88             	mov    -0x78(%ebp),%eax
  1051c9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1051cc:	0f a3 10             	bt     %edx,(%eax)
  1051cf:	19 c0                	sbb    %eax,%eax
  1051d1:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
  1051d4:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
  1051d8:	0f 95 c0             	setne  %al
  1051db:	0f b6 c0             	movzbl %al,%eax
  1051de:	85 c0                	test   %eax,%eax
  1051e0:	74 0b                	je     1051ed <default_check+0x39d>
  1051e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1051e5:	8b 40 08             	mov    0x8(%eax),%eax
  1051e8:	83 f8 03             	cmp    $0x3,%eax
  1051eb:	74 19                	je     105206 <default_check+0x3b6>
  1051ed:	68 54 7a 10 00       	push   $0x107a54
  1051f2:	68 8e 77 10 00       	push   $0x10778e
  1051f7:	68 13 01 00 00       	push   $0x113
  1051fc:	68 a3 77 10 00       	push   $0x1077a3
  105201:	e8 c7 b1 ff ff       	call   1003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105206:	83 ec 0c             	sub    $0xc,%esp
  105209:	6a 01                	push   $0x1
  10520b:	e8 5f db ff ff       	call   102d6f <alloc_pages>
  105210:	83 c4 10             	add    $0x10,%esp
  105213:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105216:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105219:	83 e8 14             	sub    $0x14,%eax
  10521c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10521f:	74 19                	je     10523a <default_check+0x3ea>
  105221:	68 7a 7a 10 00       	push   $0x107a7a
  105226:	68 8e 77 10 00       	push   $0x10778e
  10522b:	68 15 01 00 00       	push   $0x115
  105230:	68 a3 77 10 00       	push   $0x1077a3
  105235:	e8 93 b1 ff ff       	call   1003cd <__panic>
    free_page(p0);
  10523a:	83 ec 08             	sub    $0x8,%esp
  10523d:	6a 01                	push   $0x1
  10523f:	ff 75 dc             	pushl  -0x24(%ebp)
  105242:	e8 66 db ff ff       	call   102dad <free_pages>
  105247:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10524a:	83 ec 0c             	sub    $0xc,%esp
  10524d:	6a 02                	push   $0x2
  10524f:	e8 1b db ff ff       	call   102d6f <alloc_pages>
  105254:	83 c4 10             	add    $0x10,%esp
  105257:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10525a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10525d:	83 c0 14             	add    $0x14,%eax
  105260:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105263:	74 19                	je     10527e <default_check+0x42e>
  105265:	68 98 7a 10 00       	push   $0x107a98
  10526a:	68 8e 77 10 00       	push   $0x10778e
  10526f:	68 17 01 00 00       	push   $0x117
  105274:	68 a3 77 10 00       	push   $0x1077a3
  105279:	e8 4f b1 ff ff       	call   1003cd <__panic>

    free_pages(p0, 2);
  10527e:	83 ec 08             	sub    $0x8,%esp
  105281:	6a 02                	push   $0x2
  105283:	ff 75 dc             	pushl  -0x24(%ebp)
  105286:	e8 22 db ff ff       	call   102dad <free_pages>
  10528b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  10528e:	83 ec 08             	sub    $0x8,%esp
  105291:	6a 01                	push   $0x1
  105293:	ff 75 bc             	pushl  -0x44(%ebp)
  105296:	e8 12 db ff ff       	call   102dad <free_pages>
  10529b:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  10529e:	83 ec 0c             	sub    $0xc,%esp
  1052a1:	6a 05                	push   $0x5
  1052a3:	e8 c7 da ff ff       	call   102d6f <alloc_pages>
  1052a8:	83 c4 10             	add    $0x10,%esp
  1052ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1052ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1052b2:	75 19                	jne    1052cd <default_check+0x47d>
  1052b4:	68 b8 7a 10 00       	push   $0x107ab8
  1052b9:	68 8e 77 10 00       	push   $0x10778e
  1052be:	68 1c 01 00 00       	push   $0x11c
  1052c3:	68 a3 77 10 00       	push   $0x1077a3
  1052c8:	e8 00 b1 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  1052cd:	83 ec 0c             	sub    $0xc,%esp
  1052d0:	6a 01                	push   $0x1
  1052d2:	e8 98 da ff ff       	call   102d6f <alloc_pages>
  1052d7:	83 c4 10             	add    $0x10,%esp
  1052da:	85 c0                	test   %eax,%eax
  1052dc:	74 19                	je     1052f7 <default_check+0x4a7>
  1052de:	68 16 79 10 00       	push   $0x107916
  1052e3:	68 8e 77 10 00       	push   $0x10778e
  1052e8:	68 1d 01 00 00       	push   $0x11d
  1052ed:	68 a3 77 10 00       	push   $0x1077a3
  1052f2:	e8 d6 b0 ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  1052f7:	a1 70 a9 11 00       	mov    0x11a970,%eax
  1052fc:	85 c0                	test   %eax,%eax
  1052fe:	74 19                	je     105319 <default_check+0x4c9>
  105300:	68 69 79 10 00       	push   $0x107969
  105305:	68 8e 77 10 00       	push   $0x10778e
  10530a:	68 1f 01 00 00       	push   $0x11f
  10530f:	68 a3 77 10 00       	push   $0x1077a3
  105314:	e8 b4 b0 ff ff       	call   1003cd <__panic>
    nr_free = nr_free_store;
  105319:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10531c:	a3 70 a9 11 00       	mov    %eax,0x11a970

    free_list = free_list_store;
  105321:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  105327:	8b 55 80             	mov    -0x80(%ebp),%edx
  10532a:	a3 68 a9 11 00       	mov    %eax,0x11a968
  10532f:	89 15 6c a9 11 00    	mov    %edx,0x11a96c
    free_pages(p0, 5);
  105335:	83 ec 08             	sub    $0x8,%esp
  105338:	6a 05                	push   $0x5
  10533a:	ff 75 dc             	pushl  -0x24(%ebp)
  10533d:	e8 6b da ff ff       	call   102dad <free_pages>
  105342:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  105345:	c7 45 ec 68 a9 11 00 	movl   $0x11a968,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10534c:	eb 1d                	jmp    10536b <default_check+0x51b>
        struct Page *p = le2page(le, page_link);
  10534e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105351:	83 e8 0c             	sub    $0xc,%eax
  105354:	89 45 b0             	mov    %eax,-0x50(%ebp)
        count --, total -= p->property;
  105357:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10535b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10535e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105361:	8b 40 08             	mov    0x8(%eax),%eax
  105364:	29 c2                	sub    %eax,%edx
  105366:	89 d0                	mov    %edx,%eax
  105368:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10536b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10536e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  105371:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105374:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  105377:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10537a:	81 7d ec 68 a9 11 00 	cmpl   $0x11a968,-0x14(%ebp)
  105381:	75 cb                	jne    10534e <default_check+0x4fe>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  105383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105387:	74 19                	je     1053a2 <default_check+0x552>
  105389:	68 d6 7a 10 00       	push   $0x107ad6
  10538e:	68 8e 77 10 00       	push   $0x10778e
  105393:	68 2a 01 00 00       	push   $0x12a
  105398:	68 a3 77 10 00       	push   $0x1077a3
  10539d:	e8 2b b0 ff ff       	call   1003cd <__panic>
    assert(total == 0);
  1053a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053a6:	74 19                	je     1053c1 <default_check+0x571>
  1053a8:	68 e1 7a 10 00       	push   $0x107ae1
  1053ad:	68 8e 77 10 00       	push   $0x10778e
  1053b2:	68 2b 01 00 00       	push   $0x12b
  1053b7:	68 a3 77 10 00       	push   $0x1077a3
  1053bc:	e8 0c b0 ff ff       	call   1003cd <__panic>
}
  1053c1:	90                   	nop
  1053c2:	c9                   	leave  
  1053c3:	c3                   	ret    

001053c4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1053c4:	55                   	push   %ebp
  1053c5:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1053c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ca:	8b 15 64 a9 11 00    	mov    0x11a964,%edx
  1053d0:	29 d0                	sub    %edx,%eax
  1053d2:	c1 f8 02             	sar    $0x2,%eax
  1053d5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1053db:	5d                   	pop    %ebp
  1053dc:	c3                   	ret    

001053dd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1053dd:	55                   	push   %ebp
  1053de:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  1053e0:	ff 75 08             	pushl  0x8(%ebp)
  1053e3:	e8 dc ff ff ff       	call   1053c4 <page2ppn>
  1053e8:	83 c4 04             	add    $0x4,%esp
  1053eb:	c1 e0 0c             	shl    $0xc,%eax
}
  1053ee:	c9                   	leave  
  1053ef:	c3                   	ret    

001053f0 <set_page_ref>:
page_ref(struct Page *page) {
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
  1053f0:	55                   	push   %ebp
  1053f1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1053f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053f9:	89 10                	mov    %edx,(%eax)
}
  1053fb:	90                   	nop
  1053fc:	5d                   	pop    %ebp
  1053fd:	c3                   	ret    

001053fe <buddy_find_first_zero>:
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) ( ((index) + 1) / 2 - 1)
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static unsigned int
buddy_find_first_zero(unsigned int bit_array) {
  1053fe:	55                   	push   %ebp
  1053ff:	89 e5                	mov    %esp,%ebp
  105401:	83 ec 10             	sub    $0x10,%esp
    unsigned pos = 0;
  105404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (bit_array >>= 1) ++ pos;
  10540b:	eb 04                	jmp    105411 <buddy_find_first_zero+0x13>
  10540d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105411:	d1 6d 08             	shrl   0x8(%ebp)
  105414:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105418:	75 f3                	jne    10540d <buddy_find_first_zero+0xf>
    return pos;
  10541a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10541d:	c9                   	leave  
  10541e:	c3                   	ret    

0010541f <buddy_node_index_to_page>:

static struct Page*
buddy_node_index_to_page(unsigned int index, unsigned int node_size) {
  10541f:	55                   	push   %ebp
  105420:	89 e5                	mov    %esp,%ebp
	return buddy_allocatable_base + ((index + 1) * node_size - buddy_max_pages);
  105422:	8b 0d 54 a9 11 00    	mov    0x11a954,%ecx
  105428:	8b 45 08             	mov    0x8(%ebp),%eax
  10542b:	83 c0 01             	add    $0x1,%eax
  10542e:	0f af 45 0c          	imul   0xc(%ebp),%eax
  105432:	89 c2                	mov    %eax,%edx
  105434:	a1 50 a9 11 00       	mov    0x11a950,%eax
  105439:	29 c2                	sub    %eax,%edx
  10543b:	89 d0                	mov    %edx,%eax
  10543d:	c1 e0 02             	shl    $0x2,%eax
  105440:	01 d0                	add    %edx,%eax
  105442:	c1 e0 02             	shl    $0x2,%eax
  105445:	01 c8                	add    %ecx,%eax
}
  105447:	5d                   	pop    %ebp
  105448:	c3                   	ret    

00105449 <buddy_init>:

static void
buddy_init(void) {
  105449:	55                   	push   %ebp
  10544a:	89 e5                	mov    %esp,%ebp
	// do nothing.
}
  10544c:	90                   	nop
  10544d:	5d                   	pop    %ebp
  10544e:	c3                   	ret    

0010544f <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  10544f:	55                   	push   %ebp
  105450:	89 e5                	mov    %esp,%ebp
  105452:	83 ec 58             	sub    $0x58,%esp
	assert(n > 0);
  105455:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105459:	75 16                	jne    105471 <buddy_init_memmap+0x22>
  10545b:	68 1c 7b 10 00       	push   $0x107b1c
  105460:	68 22 7b 10 00       	push   $0x107b22
  105465:	6a 28                	push   $0x28
  105467:	68 37 7b 10 00       	push   $0x107b37
  10546c:	e8 5c af ff ff       	call   1003cd <__panic>
	// Calculate maximum manageable memory zone
	unsigned int max_pages = 1;
  105471:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	for (unsigned int i = 1; i < BUDDY_MAX_DEPTH; ++ i) {
  105478:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10547f:	eb 23                	jmp    1054a4 <buddy_init_memmap+0x55>
		// Should consider the page for storing 'longest' array.
		if (max_pages + max_pages / 512 >= n) {
  105481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105484:	c1 e8 09             	shr    $0x9,%eax
  105487:	89 c2                	mov    %eax,%edx
  105489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10548c:	01 d0                	add    %edx,%eax
  10548e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105491:	72 0a                	jb     10549d <buddy_init_memmap+0x4e>
			max_pages /= 2;
  105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105496:	d1 e8                	shr    %eax
  105498:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  10549b:	eb 0d                	jmp    1054aa <buddy_init_memmap+0x5b>
		}
		max_pages *= 2;
  10549d:	d1 65 f4             	shll   -0xc(%ebp)
static void
buddy_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	// Calculate maximum manageable memory zone
	unsigned int max_pages = 1;
	for (unsigned int i = 1; i < BUDDY_MAX_DEPTH; ++ i) {
  1054a0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1054a4:	83 7d f0 1d          	cmpl   $0x1d,-0x10(%ebp)
  1054a8:	76 d7                	jbe    105481 <buddy_init_memmap+0x32>
			max_pages /= 2;
			break;
		}
		max_pages *= 2;
	}
	unsigned int longest_array_pages = max_pages / 512 + 1;
  1054aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054ad:	c1 e8 09             	shr    $0x9,%eax
  1054b0:	83 c0 01             	add    $0x1,%eax
  1054b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("BUDDY: Maximum manageable pages = %d, pages for storing longest = %d\n",
  1054b6:	83 ec 04             	sub    $0x4,%esp
  1054b9:	ff 75 dc             	pushl  -0x24(%ebp)
  1054bc:	ff 75 f4             	pushl  -0xc(%ebp)
  1054bf:	68 4c 7b 10 00       	push   $0x107b4c
  1054c4:	e8 9e ad ff ff       	call   100267 <cprintf>
  1054c9:	83 c4 10             	add    $0x10,%esp
			max_pages, longest_array_pages);
	buddy_longest = (unsigned int*)KADDR(page2pa(base));
  1054cc:	83 ec 0c             	sub    $0xc,%esp
  1054cf:	ff 75 08             	pushl  0x8(%ebp)
  1054d2:	e8 06 ff ff ff       	call   1053dd <page2pa>
  1054d7:	83 c4 10             	add    $0x10,%esp
  1054da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1054dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1054e0:	c1 e8 0c             	shr    $0xc,%eax
  1054e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1054e6:	a1 c0 a8 11 00       	mov    0x11a8c0,%eax
  1054eb:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  1054ee:	72 14                	jb     105504 <buddy_init_memmap+0xb5>
  1054f0:	ff 75 d8             	pushl  -0x28(%ebp)
  1054f3:	68 94 7b 10 00       	push   $0x107b94
  1054f8:	6a 36                	push   $0x36
  1054fa:	68 37 7b 10 00       	push   $0x107b37
  1054ff:	e8 c9 ae ff ff       	call   1003cd <__panic>
  105504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105507:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10550c:	a3 4c a9 11 00       	mov    %eax,0x11a94c
	buddy_max_pages = max_pages;
  105511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105514:	a3 50 a9 11 00       	mov    %eax,0x11a950

	unsigned int node_size = max_pages * 2;
  105519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10551c:	01 c0                	add    %eax,%eax
  10551e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
  105521:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  105528:	eb 2b                	jmp    105555 <buddy_init_memmap+0x106>
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
  10552a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10552d:	83 c0 01             	add    $0x1,%eax
  105530:	23 45 e8             	and    -0x18(%ebp),%eax
  105533:	85 c0                	test   %eax,%eax
  105535:	75 08                	jne    10553f <buddy_init_memmap+0xf0>
  105537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10553a:	d1 e8                	shr    %eax
  10553c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		buddy_longest[i] = node_size;
  10553f:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  105544:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105547:	c1 e2 02             	shl    $0x2,%edx
  10554a:	01 c2                	add    %eax,%edx
  10554c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10554f:	89 02                	mov    %eax,(%edx)
			max_pages, longest_array_pages);
	buddy_longest = (unsigned int*)KADDR(page2pa(base));
	buddy_max_pages = max_pages;

	unsigned int node_size = max_pages * 2;
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
  105551:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105558:	01 c0                	add    %eax,%eax
  10555a:	83 e8 01             	sub    $0x1,%eax
  10555d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  105560:	77 c8                	ja     10552a <buddy_init_memmap+0xdb>
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
		buddy_longest[i] = node_size;
	}

	for (int i = 0; i < longest_array_pages; ++ i) {
  105562:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  105569:	eb 34                	jmp    10559f <buddy_init_memmap+0x150>
		struct Page *p = base + i;
  10556b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10556e:	89 d0                	mov    %edx,%eax
  105570:	c1 e0 02             	shl    $0x2,%eax
  105573:	01 d0                	add    %edx,%eax
  105575:	c1 e0 02             	shl    $0x2,%eax
  105578:	89 c2                	mov    %eax,%edx
  10557a:	8b 45 08             	mov    0x8(%ebp),%eax
  10557d:	01 d0                	add    %edx,%eax
  10557f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		SetPageReserved(p);
  105582:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105585:	83 c0 04             	add    $0x4,%eax
  105588:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  10558f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105592:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105595:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105598:	0f ab 10             	bts    %edx,(%eax)
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
		buddy_longest[i] = node_size;
	}

	for (int i = 0; i < longest_array_pages; ++ i) {
  10559b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  10559f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055a2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1055a5:	72 c4                	jb     10556b <buddy_init_memmap+0x11c>
		struct Page *p = base + i;
		SetPageReserved(p);
	}

	struct Page *p = base + longest_array_pages;
  1055a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1055aa:	89 d0                	mov    %edx,%eax
  1055ac:	c1 e0 02             	shl    $0x2,%eax
  1055af:	01 d0                	add    %edx,%eax
  1055b1:	c1 e0 02             	shl    $0x2,%eax
  1055b4:	89 c2                	mov    %eax,%edx
  1055b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b9:	01 d0                	add    %edx,%eax
  1055bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	buddy_allocatable_base = p;
  1055be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055c1:	a3 54 a9 11 00       	mov    %eax,0x11a954
	for (; p != base + n; p ++) {
  1055c6:	e9 88 00 00 00       	jmp    105653 <buddy_init_memmap+0x204>
		assert(PageReserved(p));
  1055cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055ce:	83 c0 04             	add    $0x4,%eax
  1055d1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  1055d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1055db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1055de:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1055e1:	0f a3 10             	bt     %edx,(%eax)
  1055e4:	19 c0                	sbb    %eax,%eax
  1055e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  1055e9:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  1055ed:	0f 95 c0             	setne  %al
  1055f0:	0f b6 c0             	movzbl %al,%eax
  1055f3:	85 c0                	test   %eax,%eax
  1055f5:	75 16                	jne    10560d <buddy_init_memmap+0x1be>
  1055f7:	68 b7 7b 10 00       	push   $0x107bb7
  1055fc:	68 22 7b 10 00       	push   $0x107b22
  105601:	6a 47                	push   $0x47
  105603:	68 37 7b 10 00       	push   $0x107b37
  105608:	e8 c0 ad ff ff       	call   1003cd <__panic>
		ClearPageReserved(p);
  10560d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105610:	83 c0 04             	add    $0x4,%eax
  105613:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  10561a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10561d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  105620:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105623:	0f b3 10             	btr    %edx,(%eax)
		SetPageProperty(p);
  105626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105629:	83 c0 04             	add    $0x4,%eax
  10562c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  105633:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105636:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105639:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10563c:	0f ab 10             	bts    %edx,(%eax)
		set_page_ref(p, 0);
  10563f:	83 ec 08             	sub    $0x8,%esp
  105642:	6a 00                	push   $0x0
  105644:	ff 75 e0             	pushl  -0x20(%ebp)
  105647:	e8 a4 fd ff ff       	call   1053f0 <set_page_ref>
  10564c:	83 c4 10             	add    $0x10,%esp
		SetPageReserved(p);
	}

	struct Page *p = base + longest_array_pages;
	buddy_allocatable_base = p;
	for (; p != base + n; p ++) {
  10564f:	83 45 e0 14          	addl   $0x14,-0x20(%ebp)
  105653:	8b 55 0c             	mov    0xc(%ebp),%edx
  105656:	89 d0                	mov    %edx,%eax
  105658:	c1 e0 02             	shl    $0x2,%eax
  10565b:	01 d0                	add    %edx,%eax
  10565d:	c1 e0 02             	shl    $0x2,%eax
  105660:	89 c2                	mov    %eax,%edx
  105662:	8b 45 08             	mov    0x8(%ebp),%eax
  105665:	01 d0                	add    %edx,%eax
  105667:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  10566a:	0f 85 5b ff ff ff    	jne    1055cb <buddy_init_memmap+0x17c>
		assert(PageReserved(p));
		ClearPageReserved(p);
		SetPageProperty(p);
		set_page_ref(p, 0);
	}
}
  105670:	90                   	nop
  105671:	c9                   	leave  
  105672:	c3                   	ret    

00105673 <buddy_fix_size>:

static size_t
buddy_fix_size(size_t before) {
  105673:	55                   	push   %ebp
  105674:	89 e5                	mov    %esp,%ebp
  105676:	83 ec 10             	sub    $0x10,%esp
	unsigned int ffz = buddy_find_first_zero(before) + 1;
  105679:	ff 75 08             	pushl  0x8(%ebp)
  10567c:	e8 7d fd ff ff       	call   1053fe <buddy_find_first_zero>
  105681:	83 c4 04             	add    $0x4,%esp
  105684:	83 c0 01             	add    $0x1,%eax
  105687:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (1 << ffz);
  10568a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10568d:	ba 01 00 00 00       	mov    $0x1,%edx
  105692:	89 c1                	mov    %eax,%ecx
  105694:	d3 e2                	shl    %cl,%edx
  105696:	89 d0                	mov    %edx,%eax
}
  105698:	c9                   	leave  
  105699:	c3                   	ret    

0010569a <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
  10569a:	55                   	push   %ebp
  10569b:	89 e5                	mov    %esp,%ebp
  10569d:	53                   	push   %ebx
  10569e:	83 ec 24             	sub    $0x24,%esp
	assert(n > 0);
  1056a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1056a5:	75 16                	jne    1056bd <buddy_alloc_pages+0x23>
  1056a7:	68 1c 7b 10 00       	push   $0x107b1c
  1056ac:	68 22 7b 10 00       	push   $0x107b22
  1056b1:	6a 56                	push   $0x56
  1056b3:	68 37 7b 10 00       	push   $0x107b37
  1056b8:	e8 10 ad ff ff       	call   1003cd <__panic>
	if (!IS_POWER_OF_2(n)) {
  1056bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c0:	83 e8 01             	sub    $0x1,%eax
  1056c3:	23 45 08             	and    0x8(%ebp),%eax
  1056c6:	85 c0                	test   %eax,%eax
  1056c8:	74 11                	je     1056db <buddy_alloc_pages+0x41>
		n = buddy_fix_size(n);
  1056ca:	83 ec 0c             	sub    $0xc,%esp
  1056cd:	ff 75 08             	pushl  0x8(%ebp)
  1056d0:	e8 9e ff ff ff       	call   105673 <buddy_fix_size>
  1056d5:	83 c4 10             	add    $0x10,%esp
  1056d8:	89 45 08             	mov    %eax,0x8(%ebp)
	}
	if (n > buddy_longest[0]) {
  1056db:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1056e0:	8b 00                	mov    (%eax),%eax
  1056e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  1056e5:	73 0a                	jae    1056f1 <buddy_alloc_pages+0x57>
		return NULL;
  1056e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1056ec:	e9 17 01 00 00       	jmp    105808 <buddy_alloc_pages+0x16e>
	}

	// Find the top node for allocation.
	// Starting from root
	unsigned int index = 0;
  1056f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	// The size of current node
	unsigned int node_size;

	// go from the root and find the most suitable position
	for (node_size = buddy_max_pages; node_size != n; node_size /= 2) {
  1056f8:	a1 50 a9 11 00       	mov    0x11a950,%eax
  1056fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105700:	eb 37                	jmp    105739 <buddy_alloc_pages+0x9f>
		if (buddy_longest[LEFT_LEAF(index)] >= n) {
  105702:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  105707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10570a:	c1 e2 03             	shl    $0x3,%edx
  10570d:	83 c2 04             	add    $0x4,%edx
  105710:	01 d0                	add    %edx,%eax
  105712:	8b 00                	mov    (%eax),%eax
  105714:	3b 45 08             	cmp    0x8(%ebp),%eax
  105717:	72 0d                	jb     105726 <buddy_alloc_pages+0x8c>
			index = LEFT_LEAF(index);
  105719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10571c:	01 c0                	add    %eax,%eax
  10571e:	83 c0 01             	add    $0x1,%eax
  105721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105724:	eb 0b                	jmp    105731 <buddy_alloc_pages+0x97>
		} else {
			index = RIGHT_LEAF(index);
  105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105729:	83 c0 01             	add    $0x1,%eax
  10572c:	01 c0                	add    %eax,%eax
  10572e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	unsigned int index = 0;
	// The size of current node
	unsigned int node_size;

	// go from the root and find the most suitable position
	for (node_size = buddy_max_pages; node_size != n; node_size /= 2) {
  105731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105734:	d1 e8                	shr    %eax
  105736:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10573c:	3b 45 08             	cmp    0x8(%ebp),%eax
  10573f:	75 c1                	jne    105702 <buddy_alloc_pages+0x68>
			index = RIGHT_LEAF(index);
		}
	}

	// Allocate all pages under this node.
	buddy_longest[index] = 0;
  105741:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  105746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105749:	c1 e2 02             	shl    $0x2,%edx
  10574c:	01 d0                	add    %edx,%eax
  10574e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	struct Page* new_page = buddy_node_index_to_page(index, node_size);
  105754:	83 ec 08             	sub    $0x8,%esp
  105757:	ff 75 f0             	pushl  -0x10(%ebp)
  10575a:	ff 75 f4             	pushl  -0xc(%ebp)
  10575d:	e8 bd fc ff ff       	call   10541f <buddy_node_index_to_page>
  105762:	83 c4 10             	add    $0x10,%esp
  105765:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (struct Page* p = new_page; p != (new_page + node_size); ++ p) {
  105768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10576b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10576e:	eb 2d                	jmp    10579d <buddy_alloc_pages+0x103>
		// Set new allocated page ref = 0;
		set_page_ref(p, 0);
  105770:	83 ec 08             	sub    $0x8,%esp
  105773:	6a 00                	push   $0x0
  105775:	ff 75 ec             	pushl  -0x14(%ebp)
  105778:	e8 73 fc ff ff       	call   1053f0 <set_page_ref>
  10577d:	83 c4 10             	add    $0x10,%esp
		// Set property = not free.
		ClearPageProperty(p);
  105780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105783:	83 c0 04             	add    $0x4,%eax
  105786:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10578d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105796:	0f b3 10             	btr    %edx,(%eax)
	}

	// Allocate all pages under this node.
	buddy_longest[index] = 0;
	struct Page* new_page = buddy_node_index_to_page(index, node_size);
	for (struct Page* p = new_page; p != (new_page + node_size); ++ p) {
  105799:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  10579d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1057a0:	89 d0                	mov    %edx,%eax
  1057a2:	c1 e0 02             	shl    $0x2,%eax
  1057a5:	01 d0                	add    %edx,%eax
  1057a7:	c1 e0 02             	shl    $0x2,%eax
  1057aa:	89 c2                	mov    %eax,%edx
  1057ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057af:	01 d0                	add    %edx,%eax
  1057b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1057b4:	75 ba                	jne    105770 <buddy_alloc_pages+0xd6>
		// Set property = not free.
		ClearPageProperty(p);
	}

	// Update parent longest value because this node is used.
	while (index) {
  1057b6:	eb 47                	jmp    1057ff <buddy_alloc_pages+0x165>
		index = PARENT(index);
  1057b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057bb:	83 c0 01             	add    $0x1,%eax
  1057be:	d1 e8                	shr    %eax
  1057c0:	83 e8 01             	sub    $0x1,%eax
  1057c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		buddy_longest[index] =
  1057c6:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1057cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057ce:	c1 e2 02             	shl    $0x2,%edx
  1057d1:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
				MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
  1057d4:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1057d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057dc:	83 c2 01             	add    $0x1,%edx
  1057df:	c1 e2 03             	shl    $0x3,%edx
  1057e2:	01 d0                	add    %edx,%eax
  1057e4:	8b 10                	mov    (%eax),%edx
  1057e6:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1057eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1057ee:	c1 e3 03             	shl    $0x3,%ebx
  1057f1:	83 c3 04             	add    $0x4,%ebx
  1057f4:	01 d8                	add    %ebx,%eax
  1057f6:	8b 00                	mov    (%eax),%eax
  1057f8:	39 c2                	cmp    %eax,%edx
  1057fa:	0f 43 c2             	cmovae %edx,%eax
	}

	// Update parent longest value because this node is used.
	while (index) {
		index = PARENT(index);
		buddy_longest[index] =
  1057fd:	89 01                	mov    %eax,(%ecx)
		// Set property = not free.
		ClearPageProperty(p);
	}

	// Update parent longest value because this node is used.
	while (index) {
  1057ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105803:	75 b3                	jne    1057b8 <buddy_alloc_pages+0x11e>
		index = PARENT(index);
		buddy_longest[index] =
				MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
	}
	return new_page;
  105805:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  105808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10580b:	c9                   	leave  
  10580c:	c3                   	ret    

0010580d <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
  10580d:	55                   	push   %ebp
  10580e:	89 e5                	mov    %esp,%ebp
  105810:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
  105813:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105817:	75 19                	jne    105832 <buddy_free_pages+0x25>
  105819:	68 1c 7b 10 00       	push   $0x107b1c
  10581e:	68 22 7b 10 00       	push   $0x107b22
  105823:	68 82 00 00 00       	push   $0x82
  105828:	68 37 7b 10 00       	push   $0x107b37
  10582d:	e8 9b ab ff ff       	call   1003cd <__panic>
	// Find the base-correponded node and its size;
	unsigned int index = (unsigned int)(base - buddy_allocatable_base) + buddy_max_pages - 1;
  105832:	8b 45 08             	mov    0x8(%ebp),%eax
  105835:	8b 15 54 a9 11 00    	mov    0x11a954,%edx
  10583b:	29 d0                	sub    %edx,%eax
  10583d:	c1 f8 02             	sar    $0x2,%eax
  105840:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  105846:	89 c2                	mov    %eax,%edx
  105848:	a1 50 a9 11 00       	mov    0x11a950,%eax
  10584d:	01 d0                	add    %edx,%eax
  10584f:	83 e8 01             	sub    $0x1,%eax
  105852:	89 45 f4             	mov    %eax,-0xc(%ebp)
	unsigned int node_size = 1;
  105855:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// Starting from the leaf and find the first (lowest) node has longest = 0;
	while (buddy_longest[index] != 0) {
  10585c:	eb 30                	jmp    10588e <buddy_free_pages+0x81>
		node_size *= 2;
  10585e:	d1 65 f0             	shll   -0x10(%ebp)
		// cannot find the corresponding node for the base.
		assert(index != 0);
  105861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105865:	75 19                	jne    105880 <buddy_free_pages+0x73>
  105867:	68 c7 7b 10 00       	push   $0x107bc7
  10586c:	68 22 7b 10 00       	push   $0x107b22
  105871:	68 8b 00 00 00       	push   $0x8b
  105876:	68 37 7b 10 00       	push   $0x107b37
  10587b:	e8 4d ab ff ff       	call   1003cd <__panic>
		index = PARENT(index);
  105880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105883:	83 c0 01             	add    $0x1,%eax
  105886:	d1 e8                	shr    %eax
  105888:	83 e8 01             	sub    $0x1,%eax
  10588b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Find the base-correponded node and its size;
	unsigned int index = (unsigned int)(base - buddy_allocatable_base) + buddy_max_pages - 1;
	unsigned int node_size = 1;

	// Starting from the leaf and find the first (lowest) node has longest = 0;
	while (buddy_longest[index] != 0) {
  10588e:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  105893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105896:	c1 e2 02             	shl    $0x2,%edx
  105899:	01 d0                	add    %edx,%eax
  10589b:	8b 00                	mov    (%eax),%eax
  10589d:	85 c0                	test   %eax,%eax
  10589f:	75 bd                	jne    10585e <buddy_free_pages+0x51>

	// NOTICE: Be careful when releasing memory if the following line is commented.
	// assert(node_size == n);

	// Free the pages.
	struct Page *p = base;
  1058a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (; p != base + n; p ++) {
  1058a7:	e9 9e 00 00 00       	jmp    10594a <buddy_free_pages+0x13d>
	    assert(!PageReserved(p) && !PageProperty(p));
  1058ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058af:	83 c0 04             	add    $0x4,%eax
  1058b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  1058b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1058bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1058bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1058c2:	0f a3 10             	bt     %edx,(%eax)
  1058c5:	19 c0                	sbb    %eax,%eax
  1058c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  1058ca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  1058ce:	0f 95 c0             	setne  %al
  1058d1:	0f b6 c0             	movzbl %al,%eax
  1058d4:	85 c0                	test   %eax,%eax
  1058d6:	75 2c                	jne    105904 <buddy_free_pages+0xf7>
  1058d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058db:	83 c0 04             	add    $0x4,%eax
  1058de:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  1058e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1058e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1058eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1058ee:	0f a3 10             	bt     %edx,(%eax)
  1058f1:	19 c0                	sbb    %eax,%eax
  1058f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1058f6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1058fa:	0f 95 c0             	setne  %al
  1058fd:	0f b6 c0             	movzbl %al,%eax
  105900:	85 c0                	test   %eax,%eax
  105902:	74 19                	je     10591d <buddy_free_pages+0x110>
  105904:	68 d4 7b 10 00       	push   $0x107bd4
  105909:	68 22 7b 10 00       	push   $0x107b22
  10590e:	68 95 00 00 00       	push   $0x95
  105913:	68 37 7b 10 00       	push   $0x107b37
  105918:	e8 b0 aa ff ff       	call   1003cd <__panic>
	    SetPageProperty(p);
  10591d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105920:	83 c0 04             	add    $0x4,%eax
  105923:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10592a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10592d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105933:	0f ab 10             	bts    %edx,(%eax)
	    set_page_ref(p, 0);
  105936:	83 ec 08             	sub    $0x8,%esp
  105939:	6a 00                	push   $0x0
  10593b:	ff 75 ec             	pushl  -0x14(%ebp)
  10593e:	e8 ad fa ff ff       	call   1053f0 <set_page_ref>
  105943:	83 c4 10             	add    $0x10,%esp
	// NOTICE: Be careful when releasing memory if the following line is commented.
	// assert(node_size == n);

	// Free the pages.
	struct Page *p = base;
	for (; p != base + n; p ++) {
  105946:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  10594a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10594d:	89 d0                	mov    %edx,%eax
  10594f:	c1 e0 02             	shl    $0x2,%eax
  105952:	01 d0                	add    %edx,%eax
  105954:	c1 e0 02             	shl    $0x2,%eax
  105957:	89 c2                	mov    %eax,%edx
  105959:	8b 45 08             	mov    0x8(%ebp),%eax
  10595c:	01 d0                	add    %edx,%eax
  10595e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105961:	0f 85 45 ff ff ff    	jne    1058ac <buddy_free_pages+0x9f>
	    SetPageProperty(p);
	    set_page_ref(p, 0);
	}

	// Update longest.
	buddy_longest[index] = node_size;
  105967:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  10596c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10596f:	c1 e2 02             	shl    $0x2,%edx
  105972:	01 c2                	add    %eax,%edx
  105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105977:	89 02                	mov    %eax,(%edx)
	while (index != 0) {
  105979:	eb 75                	jmp    1059f0 <buddy_free_pages+0x1e3>
		// Starting from this node, try to merge all the way to parent.
		// The condition for merging is (left_child + right_child = node_size)
		index = PARENT(index);
  10597b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10597e:	83 c0 01             	add    $0x1,%eax
  105981:	d1 e8                	shr    %eax
  105983:	83 e8 01             	sub    $0x1,%eax
  105986:	89 45 f4             	mov    %eax,-0xc(%ebp)
		node_size *= 2;
  105989:	d1 65 f0             	shll   -0x10(%ebp)
		unsigned int left_longest = buddy_longest[LEFT_LEAF(index)];
  10598c:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  105991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105994:	c1 e2 03             	shl    $0x3,%edx
  105997:	83 c2 04             	add    $0x4,%edx
  10599a:	01 d0                	add    %edx,%eax
  10599c:	8b 00                	mov    (%eax),%eax
  10599e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		unsigned int right_longest = buddy_longest[RIGHT_LEAF(index)];
  1059a1:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1059a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059a9:	83 c2 01             	add    $0x1,%edx
  1059ac:	c1 e2 03             	shl    $0x3,%edx
  1059af:	01 d0                	add    %edx,%eax
  1059b1:	8b 00                	mov    (%eax),%eax
  1059b3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if (left_longest + right_longest == node_size) {
  1059b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1059b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1059bc:	01 d0                	add    %edx,%eax
  1059be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1059c1:	75 14                	jne    1059d7 <buddy_free_pages+0x1ca>
			buddy_longest[index] = node_size;
  1059c3:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1059c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059cb:	c1 e2 02             	shl    $0x2,%edx
  1059ce:	01 c2                	add    %eax,%edx
  1059d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059d3:	89 02                	mov    %eax,(%edx)
  1059d5:	eb 19                	jmp    1059f0 <buddy_free_pages+0x1e3>
		} else {
			// update because the child is updated.
			buddy_longest[index] = MAX(left_longest, right_longest);
  1059d7:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  1059dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059df:	c1 e2 02             	shl    $0x2,%edx
  1059e2:	01 c2                	add    %eax,%edx
  1059e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059e7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1059ea:	0f 43 45 dc          	cmovae -0x24(%ebp),%eax
  1059ee:	89 02                	mov    %eax,(%edx)
	    set_page_ref(p, 0);
	}

	// Update longest.
	buddy_longest[index] = node_size;
	while (index != 0) {
  1059f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1059f4:	75 85                	jne    10597b <buddy_free_pages+0x16e>
		} else {
			// update because the child is updated.
			buddy_longest[index] = MAX(left_longest, right_longest);
		}
	}
}
  1059f6:	90                   	nop
  1059f7:	c9                   	leave  
  1059f8:	c3                   	ret    

001059f9 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  1059f9:	55                   	push   %ebp
  1059fa:	89 e5                	mov    %esp,%ebp
    return buddy_longest[0];
  1059fc:	a1 4c a9 11 00       	mov    0x11a94c,%eax
  105a01:	8b 00                	mov    (%eax),%eax
}
  105a03:	5d                   	pop    %ebp
  105a04:	c3                   	ret    

00105a05 <buddy_check>:

static void
buddy_check(void) {
  105a05:	55                   	push   %ebp
  105a06:	89 e5                	mov    %esp,%ebp
  105a08:	81 ec 98 00 00 00    	sub    $0x98,%esp
	int all_pages = nr_free_pages();
  105a0e:	e8 cf d3 ff ff       	call   102de2 <nr_free_pages>
  105a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct Page* p0, *p1, *p2, *p3, *p4;
	assert(alloc_pages(all_pages + 1) == NULL);
  105a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a19:	83 c0 01             	add    $0x1,%eax
  105a1c:	83 ec 0c             	sub    $0xc,%esp
  105a1f:	50                   	push   %eax
  105a20:	e8 4a d3 ff ff       	call   102d6f <alloc_pages>
  105a25:	83 c4 10             	add    $0x10,%esp
  105a28:	85 c0                	test   %eax,%eax
  105a2a:	74 19                	je     105a45 <buddy_check+0x40>
  105a2c:	68 fc 7b 10 00       	push   $0x107bfc
  105a31:	68 22 7b 10 00       	push   $0x107b22
  105a36:	68 b6 00 00 00       	push   $0xb6
  105a3b:	68 37 7b 10 00       	push   $0x107b37
  105a40:	e8 88 a9 ff ff       	call   1003cd <__panic>

	p0 = alloc_pages(1);
  105a45:	83 ec 0c             	sub    $0xc,%esp
  105a48:	6a 01                	push   $0x1
  105a4a:	e8 20 d3 ff ff       	call   102d6f <alloc_pages>
  105a4f:	83 c4 10             	add    $0x10,%esp
  105a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert(p0 != NULL);
  105a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a59:	75 19                	jne    105a74 <buddy_check+0x6f>
  105a5b:	68 1f 7c 10 00       	push   $0x107c1f
  105a60:	68 22 7b 10 00       	push   $0x107b22
  105a65:	68 b9 00 00 00       	push   $0xb9
  105a6a:	68 37 7b 10 00       	push   $0x107b37
  105a6f:	e8 59 a9 ff ff       	call   1003cd <__panic>
	p1 = alloc_pages(2);
  105a74:	83 ec 0c             	sub    $0xc,%esp
  105a77:	6a 02                	push   $0x2
  105a79:	e8 f1 d2 ff ff       	call   102d6f <alloc_pages>
  105a7e:	83 c4 10             	add    $0x10,%esp
  105a81:	89 45 ec             	mov    %eax,-0x14(%ebp)
	assert(p1 == p0 + 2);
  105a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a87:	83 c0 28             	add    $0x28,%eax
  105a8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105a8d:	74 19                	je     105aa8 <buddy_check+0xa3>
  105a8f:	68 2a 7c 10 00       	push   $0x107c2a
  105a94:	68 22 7b 10 00       	push   $0x107b22
  105a99:	68 bb 00 00 00       	push   $0xbb
  105a9e:	68 37 7b 10 00       	push   $0x107b37
  105aa3:	e8 25 a9 ff ff       	call   1003cd <__panic>
	assert(!PageReserved(p0) && !PageReserved(p1));
  105aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aab:	83 c0 04             	add    $0x4,%eax
  105aae:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  105ab5:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105ab8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105abb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105abe:	0f a3 10             	bt     %edx,(%eax)
  105ac1:	19 c0                	sbb    %eax,%eax
  105ac3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  105ac6:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  105aca:	0f 95 c0             	setne  %al
  105acd:	0f b6 c0             	movzbl %al,%eax
  105ad0:	85 c0                	test   %eax,%eax
  105ad2:	75 2c                	jne    105b00 <buddy_check+0xfb>
  105ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ad7:	83 c0 04             	add    $0x4,%eax
  105ada:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  105ae1:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105ae4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105ae7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105aea:	0f a3 10             	bt     %edx,(%eax)
  105aed:	19 c0                	sbb    %eax,%eax
  105aef:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  105af2:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  105af6:	0f 95 c0             	setne  %al
  105af9:	0f b6 c0             	movzbl %al,%eax
  105afc:	85 c0                	test   %eax,%eax
  105afe:	74 19                	je     105b19 <buddy_check+0x114>
  105b00:	68 38 7c 10 00       	push   $0x107c38
  105b05:	68 22 7b 10 00       	push   $0x107b22
  105b0a:	68 bc 00 00 00       	push   $0xbc
  105b0f:	68 37 7b 10 00       	push   $0x107b37
  105b14:	e8 b4 a8 ff ff       	call   1003cd <__panic>
	assert(!PageProperty(p0) && !PageProperty(p1));
  105b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b1c:	83 c0 04             	add    $0x4,%eax
  105b1f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  105b26:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105b29:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b2f:	0f a3 10             	bt     %edx,(%eax)
  105b32:	19 c0                	sbb    %eax,%eax
  105b34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105b37:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105b3b:	0f 95 c0             	setne  %al
  105b3e:	0f b6 c0             	movzbl %al,%eax
  105b41:	85 c0                	test   %eax,%eax
  105b43:	75 2c                	jne    105b71 <buddy_check+0x16c>
  105b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b48:	83 c0 04             	add    $0x4,%eax
  105b4b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  105b52:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105b55:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105b5b:	0f a3 10             	bt     %edx,(%eax)
  105b5e:	19 c0                	sbb    %eax,%eax
  105b60:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
  105b63:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  105b67:	0f 95 c0             	setne  %al
  105b6a:	0f b6 c0             	movzbl %al,%eax
  105b6d:	85 c0                	test   %eax,%eax
  105b6f:	74 19                	je     105b8a <buddy_check+0x185>
  105b71:	68 60 7c 10 00       	push   $0x107c60
  105b76:	68 22 7b 10 00       	push   $0x107b22
  105b7b:	68 bd 00 00 00       	push   $0xbd
  105b80:	68 37 7b 10 00       	push   $0x107b37
  105b85:	e8 43 a8 ff ff       	call   1003cd <__panic>

	p2 = alloc_pages(1);
  105b8a:	83 ec 0c             	sub    $0xc,%esp
  105b8d:	6a 01                	push   $0x1
  105b8f:	e8 db d1 ff ff       	call   102d6f <alloc_pages>
  105b94:	83 c4 10             	add    $0x10,%esp
  105b97:	89 45 d8             	mov    %eax,-0x28(%ebp)
	assert(p2 == p0 + 1);
  105b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b9d:	83 c0 14             	add    $0x14,%eax
  105ba0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  105ba3:	74 19                	je     105bbe <buddy_check+0x1b9>
  105ba5:	68 87 7c 10 00       	push   $0x107c87
  105baa:	68 22 7b 10 00       	push   $0x107b22
  105baf:	68 c0 00 00 00       	push   $0xc0
  105bb4:	68 37 7b 10 00       	push   $0x107b37
  105bb9:	e8 0f a8 ff ff       	call   1003cd <__panic>

	p3 = alloc_pages(2);
  105bbe:	83 ec 0c             	sub    $0xc,%esp
  105bc1:	6a 02                	push   $0x2
  105bc3:	e8 a7 d1 ff ff       	call   102d6f <alloc_pages>
  105bc8:	83 c4 10             	add    $0x10,%esp
  105bcb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	assert(p3 == p0 + 4);
  105bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bd1:	83 c0 50             	add    $0x50,%eax
  105bd4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  105bd7:	74 19                	je     105bf2 <buddy_check+0x1ed>
  105bd9:	68 94 7c 10 00       	push   $0x107c94
  105bde:	68 22 7b 10 00       	push   $0x107b22
  105be3:	68 c3 00 00 00       	push   $0xc3
  105be8:	68 37 7b 10 00       	push   $0x107b37
  105bed:	e8 db a7 ff ff       	call   1003cd <__panic>
	assert(!PageProperty(p3) && !PageProperty(p3 + 1) && PageProperty(p3 + 2));
  105bf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105bf5:	83 c0 04             	add    $0x4,%eax
  105bf8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  105bff:	89 45 98             	mov    %eax,-0x68(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105c02:	8b 45 98             	mov    -0x68(%ebp),%eax
  105c05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105c08:	0f a3 10             	bt     %edx,(%eax)
  105c0b:	19 c0                	sbb    %eax,%eax
  105c0d:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return oldbit != 0;
  105c10:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  105c14:	0f 95 c0             	setne  %al
  105c17:	0f b6 c0             	movzbl %al,%eax
  105c1a:	85 c0                	test   %eax,%eax
  105c1c:	75 5e                	jne    105c7c <buddy_check+0x277>
  105c1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105c21:	83 c0 14             	add    $0x14,%eax
  105c24:	83 c0 04             	add    $0x4,%eax
  105c27:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105c2e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105c31:	8b 45 90             	mov    -0x70(%ebp),%eax
  105c34:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105c37:	0f a3 10             	bt     %edx,(%eax)
  105c3a:	19 c0                	sbb    %eax,%eax
  105c3c:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105c3f:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105c43:	0f 95 c0             	setne  %al
  105c46:	0f b6 c0             	movzbl %al,%eax
  105c49:	85 c0                	test   %eax,%eax
  105c4b:	75 2f                	jne    105c7c <buddy_check+0x277>
  105c4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105c50:	83 c0 28             	add    $0x28,%eax
  105c53:	83 c0 04             	add    $0x4,%eax
  105c56:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  105c5d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105c60:	8b 45 88             	mov    -0x78(%ebp),%eax
  105c63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105c66:	0f a3 10             	bt     %edx,(%eax)
  105c69:	19 c0                	sbb    %eax,%eax
  105c6b:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
  105c6e:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
  105c72:	0f 95 c0             	setne  %al
  105c75:	0f b6 c0             	movzbl %al,%eax
  105c78:	85 c0                	test   %eax,%eax
  105c7a:	75 19                	jne    105c95 <buddy_check+0x290>
  105c7c:	68 a4 7c 10 00       	push   $0x107ca4
  105c81:	68 22 7b 10 00       	push   $0x107b22
  105c86:	68 c4 00 00 00       	push   $0xc4
  105c8b:	68 37 7b 10 00       	push   $0x107b37
  105c90:	e8 38 a7 ff ff       	call   1003cd <__panic>

	free_pages(p1, 2);
  105c95:	83 ec 08             	sub    $0x8,%esp
  105c98:	6a 02                	push   $0x2
  105c9a:	ff 75 ec             	pushl  -0x14(%ebp)
  105c9d:	e8 0b d1 ff ff       	call   102dad <free_pages>
  105ca2:	83 c4 10             	add    $0x10,%esp
	assert(PageProperty(p1) && PageProperty(p1 + 1));
  105ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ca8:	83 c0 04             	add    $0x4,%eax
  105cab:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  105cb2:	89 45 80             	mov    %eax,-0x80(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105cb5:	8b 45 80             	mov    -0x80(%ebp),%eax
  105cb8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  105cbb:	0f a3 10             	bt     %edx,(%eax)
  105cbe:	19 c0                	sbb    %eax,%eax
  105cc0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    return oldbit != 0;
  105cc6:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  105ccd:	0f 95 c0             	setne  %al
  105cd0:	0f b6 c0             	movzbl %al,%eax
  105cd3:	85 c0                	test   %eax,%eax
  105cd5:	74 3b                	je     105d12 <buddy_check+0x30d>
  105cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cda:	83 c0 14             	add    $0x14,%eax
  105cdd:	83 c0 04             	add    $0x4,%eax
  105ce0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  105ce7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105ced:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  105cf3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105cf6:	0f a3 10             	bt     %edx,(%eax)
  105cf9:	19 c0                	sbb    %eax,%eax
  105cfb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return oldbit != 0;
  105d01:	83 bd 74 ff ff ff 00 	cmpl   $0x0,-0x8c(%ebp)
  105d08:	0f 95 c0             	setne  %al
  105d0b:	0f b6 c0             	movzbl %al,%eax
  105d0e:	85 c0                	test   %eax,%eax
  105d10:	75 19                	jne    105d2b <buddy_check+0x326>
  105d12:	68 e8 7c 10 00       	push   $0x107ce8
  105d17:	68 22 7b 10 00       	push   $0x107b22
  105d1c:	68 c7 00 00 00       	push   $0xc7
  105d21:	68 37 7b 10 00       	push   $0x107b37
  105d26:	e8 a2 a6 ff ff       	call   1003cd <__panic>
	assert(p1->ref == 0);
  105d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d2e:	8b 00                	mov    (%eax),%eax
  105d30:	85 c0                	test   %eax,%eax
  105d32:	74 19                	je     105d4d <buddy_check+0x348>
  105d34:	68 11 7d 10 00       	push   $0x107d11
  105d39:	68 22 7b 10 00       	push   $0x107b22
  105d3e:	68 c8 00 00 00       	push   $0xc8
  105d43:	68 37 7b 10 00       	push   $0x107b37
  105d48:	e8 80 a6 ff ff       	call   1003cd <__panic>

	free_pages(p0, 1);
  105d4d:	83 ec 08             	sub    $0x8,%esp
  105d50:	6a 01                	push   $0x1
  105d52:	ff 75 f0             	pushl  -0x10(%ebp)
  105d55:	e8 53 d0 ff ff       	call   102dad <free_pages>
  105d5a:	83 c4 10             	add    $0x10,%esp
	free_pages(p2, 1);
  105d5d:	83 ec 08             	sub    $0x8,%esp
  105d60:	6a 01                	push   $0x1
  105d62:	ff 75 d8             	pushl  -0x28(%ebp)
  105d65:	e8 43 d0 ff ff       	call   102dad <free_pages>
  105d6a:	83 c4 10             	add    $0x10,%esp

	p4 = alloc_pages(2);
  105d6d:	83 ec 0c             	sub    $0xc,%esp
  105d70:	6a 02                	push   $0x2
  105d72:	e8 f8 cf ff ff       	call   102d6f <alloc_pages>
  105d77:	83 c4 10             	add    $0x10,%esp
  105d7a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	assert(p4 == p0);
  105d7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105d80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  105d83:	74 19                	je     105d9e <buddy_check+0x399>
  105d85:	68 1e 7d 10 00       	push   $0x107d1e
  105d8a:	68 22 7b 10 00       	push   $0x107b22
  105d8f:	68 ce 00 00 00       	push   $0xce
  105d94:	68 37 7b 10 00       	push   $0x107b37
  105d99:	e8 2f a6 ff ff       	call   1003cd <__panic>
	free_pages(p4, 2);
  105d9e:	83 ec 08             	sub    $0x8,%esp
  105da1:	6a 02                	push   $0x2
  105da3:	ff 75 c0             	pushl  -0x40(%ebp)
  105da6:	e8 02 d0 ff ff       	call   102dad <free_pages>
  105dab:	83 c4 10             	add    $0x10,%esp
	assert((*(p4 + 1)).ref == 0);
  105dae:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105db1:	83 c0 14             	add    $0x14,%eax
  105db4:	8b 00                	mov    (%eax),%eax
  105db6:	85 c0                	test   %eax,%eax
  105db8:	74 19                	je     105dd3 <buddy_check+0x3ce>
  105dba:	68 27 7d 10 00       	push   $0x107d27
  105dbf:	68 22 7b 10 00       	push   $0x107b22
  105dc4:	68 d0 00 00 00       	push   $0xd0
  105dc9:	68 37 7b 10 00       	push   $0x107b37
  105dce:	e8 fa a5 ff ff       	call   1003cd <__panic>

	assert(nr_free_pages() == all_pages / 2);
  105dd3:	e8 0a d0 ff ff       	call   102de2 <nr_free_pages>
  105dd8:	89 c1                	mov    %eax,%ecx
  105dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ddd:	89 c2                	mov    %eax,%edx
  105ddf:	c1 ea 1f             	shr    $0x1f,%edx
  105de2:	01 d0                	add    %edx,%eax
  105de4:	d1 f8                	sar    %eax
  105de6:	39 c1                	cmp    %eax,%ecx
  105de8:	74 19                	je     105e03 <buddy_check+0x3fe>
  105dea:	68 3c 7d 10 00       	push   $0x107d3c
  105def:	68 22 7b 10 00       	push   $0x107b22
  105df4:	68 d2 00 00 00       	push   $0xd2
  105df9:	68 37 7b 10 00       	push   $0x107b37
  105dfe:	e8 ca a5 ff ff       	call   1003cd <__panic>

	free_pages(p3, 2);
  105e03:	83 ec 08             	sub    $0x8,%esp
  105e06:	6a 02                	push   $0x2
  105e08:	ff 75 d4             	pushl  -0x2c(%ebp)
  105e0b:	e8 9d cf ff ff       	call   102dad <free_pages>
  105e10:	83 c4 10             	add    $0x10,%esp

	p1 = alloc_pages(33);
  105e13:	83 ec 0c             	sub    $0xc,%esp
  105e16:	6a 21                	push   $0x21
  105e18:	e8 52 cf ff ff       	call   102d6f <alloc_pages>
  105e1d:	83 c4 10             	add    $0x10,%esp
  105e20:	89 45 ec             	mov    %eax,-0x14(%ebp)
	free_pages(p1, 64);
  105e23:	83 ec 08             	sub    $0x8,%esp
  105e26:	6a 40                	push   $0x40
  105e28:	ff 75 ec             	pushl  -0x14(%ebp)
  105e2b:	e8 7d cf ff ff       	call   102dad <free_pages>
  105e30:	83 c4 10             	add    $0x10,%esp
}
  105e33:	90                   	nop
  105e34:	c9                   	leave  
  105e35:	c3                   	ret    

00105e36 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105e36:	55                   	push   %ebp
  105e37:	89 e5                	mov    %esp,%ebp
  105e39:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105e3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105e43:	eb 04                	jmp    105e49 <strlen+0x13>
        cnt ++;
  105e45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105e49:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4c:	8d 50 01             	lea    0x1(%eax),%edx
  105e4f:	89 55 08             	mov    %edx,0x8(%ebp)
  105e52:	0f b6 00             	movzbl (%eax),%eax
  105e55:	84 c0                	test   %al,%al
  105e57:	75 ec                	jne    105e45 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105e5c:	c9                   	leave  
  105e5d:	c3                   	ret    

00105e5e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105e5e:	55                   	push   %ebp
  105e5f:	89 e5                	mov    %esp,%ebp
  105e61:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105e64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105e6b:	eb 04                	jmp    105e71 <strnlen+0x13>
        cnt ++;
  105e6d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105e77:	73 10                	jae    105e89 <strnlen+0x2b>
  105e79:	8b 45 08             	mov    0x8(%ebp),%eax
  105e7c:	8d 50 01             	lea    0x1(%eax),%edx
  105e7f:	89 55 08             	mov    %edx,0x8(%ebp)
  105e82:	0f b6 00             	movzbl (%eax),%eax
  105e85:	84 c0                	test   %al,%al
  105e87:	75 e4                	jne    105e6d <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105e8c:	c9                   	leave  
  105e8d:	c3                   	ret    

00105e8e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105e8e:	55                   	push   %ebp
  105e8f:	89 e5                	mov    %esp,%ebp
  105e91:	57                   	push   %edi
  105e92:	56                   	push   %esi
  105e93:	83 ec 20             	sub    $0x20,%esp
  105e96:	8b 45 08             	mov    0x8(%ebp),%eax
  105e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105ea2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ea8:	89 d1                	mov    %edx,%ecx
  105eaa:	89 c2                	mov    %eax,%edx
  105eac:	89 ce                	mov    %ecx,%esi
  105eae:	89 d7                	mov    %edx,%edi
  105eb0:	ac                   	lods   %ds:(%esi),%al
  105eb1:	aa                   	stos   %al,%es:(%edi)
  105eb2:	84 c0                	test   %al,%al
  105eb4:	75 fa                	jne    105eb0 <strcpy+0x22>
  105eb6:	89 fa                	mov    %edi,%edx
  105eb8:	89 f1                	mov    %esi,%ecx
  105eba:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ebd:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105ec6:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105ec7:	83 c4 20             	add    $0x20,%esp
  105eca:	5e                   	pop    %esi
  105ecb:	5f                   	pop    %edi
  105ecc:	5d                   	pop    %ebp
  105ecd:	c3                   	ret    

00105ece <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105ece:	55                   	push   %ebp
  105ecf:	89 e5                	mov    %esp,%ebp
  105ed1:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105eda:	eb 21                	jmp    105efd <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105edf:	0f b6 10             	movzbl (%eax),%edx
  105ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ee5:	88 10                	mov    %dl,(%eax)
  105ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105eea:	0f b6 00             	movzbl (%eax),%eax
  105eed:	84 c0                	test   %al,%al
  105eef:	74 04                	je     105ef5 <strncpy+0x27>
            src ++;
  105ef1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105ef5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105ef9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105efd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f01:	75 d9                	jne    105edc <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105f06:	c9                   	leave  
  105f07:	c3                   	ret    

00105f08 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105f08:	55                   	push   %ebp
  105f09:	89 e5                	mov    %esp,%ebp
  105f0b:	57                   	push   %edi
  105f0c:	56                   	push   %esi
  105f0d:	83 ec 20             	sub    $0x20,%esp
  105f10:	8b 45 08             	mov    0x8(%ebp),%eax
  105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f22:	89 d1                	mov    %edx,%ecx
  105f24:	89 c2                	mov    %eax,%edx
  105f26:	89 ce                	mov    %ecx,%esi
  105f28:	89 d7                	mov    %edx,%edi
  105f2a:	ac                   	lods   %ds:(%esi),%al
  105f2b:	ae                   	scas   %es:(%edi),%al
  105f2c:	75 08                	jne    105f36 <strcmp+0x2e>
  105f2e:	84 c0                	test   %al,%al
  105f30:	75 f8                	jne    105f2a <strcmp+0x22>
  105f32:	31 c0                	xor    %eax,%eax
  105f34:	eb 04                	jmp    105f3a <strcmp+0x32>
  105f36:	19 c0                	sbb    %eax,%eax
  105f38:	0c 01                	or     $0x1,%al
  105f3a:	89 fa                	mov    %edi,%edx
  105f3c:	89 f1                	mov    %esi,%ecx
  105f3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105f41:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105f4a:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105f4b:	83 c4 20             	add    $0x20,%esp
  105f4e:	5e                   	pop    %esi
  105f4f:	5f                   	pop    %edi
  105f50:	5d                   	pop    %ebp
  105f51:	c3                   	ret    

00105f52 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105f52:	55                   	push   %ebp
  105f53:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105f55:	eb 0c                	jmp    105f63 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105f57:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105f5b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f5f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f67:	74 1a                	je     105f83 <strncmp+0x31>
  105f69:	8b 45 08             	mov    0x8(%ebp),%eax
  105f6c:	0f b6 00             	movzbl (%eax),%eax
  105f6f:	84 c0                	test   %al,%al
  105f71:	74 10                	je     105f83 <strncmp+0x31>
  105f73:	8b 45 08             	mov    0x8(%ebp),%eax
  105f76:	0f b6 10             	movzbl (%eax),%edx
  105f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f7c:	0f b6 00             	movzbl (%eax),%eax
  105f7f:	38 c2                	cmp    %al,%dl
  105f81:	74 d4                	je     105f57 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f87:	74 18                	je     105fa1 <strncmp+0x4f>
  105f89:	8b 45 08             	mov    0x8(%ebp),%eax
  105f8c:	0f b6 00             	movzbl (%eax),%eax
  105f8f:	0f b6 d0             	movzbl %al,%edx
  105f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f95:	0f b6 00             	movzbl (%eax),%eax
  105f98:	0f b6 c0             	movzbl %al,%eax
  105f9b:	29 c2                	sub    %eax,%edx
  105f9d:	89 d0                	mov    %edx,%eax
  105f9f:	eb 05                	jmp    105fa6 <strncmp+0x54>
  105fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105fa6:	5d                   	pop    %ebp
  105fa7:	c3                   	ret    

00105fa8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105fa8:	55                   	push   %ebp
  105fa9:	89 e5                	mov    %esp,%ebp
  105fab:	83 ec 04             	sub    $0x4,%esp
  105fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fb1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105fb4:	eb 14                	jmp    105fca <strchr+0x22>
        if (*s == c) {
  105fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105fb9:	0f b6 00             	movzbl (%eax),%eax
  105fbc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105fbf:	75 05                	jne    105fc6 <strchr+0x1e>
            return (char *)s;
  105fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  105fc4:	eb 13                	jmp    105fd9 <strchr+0x31>
        }
        s ++;
  105fc6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105fca:	8b 45 08             	mov    0x8(%ebp),%eax
  105fcd:	0f b6 00             	movzbl (%eax),%eax
  105fd0:	84 c0                	test   %al,%al
  105fd2:	75 e2                	jne    105fb6 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105fd9:	c9                   	leave  
  105fda:	c3                   	ret    

00105fdb <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105fdb:	55                   	push   %ebp
  105fdc:	89 e5                	mov    %esp,%ebp
  105fde:	83 ec 04             	sub    $0x4,%esp
  105fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fe4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105fe7:	eb 0f                	jmp    105ff8 <strfind+0x1d>
        if (*s == c) {
  105fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  105fec:	0f b6 00             	movzbl (%eax),%eax
  105fef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ff2:	74 10                	je     106004 <strfind+0x29>
            break;
        }
        s ++;
  105ff4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ffb:	0f b6 00             	movzbl (%eax),%eax
  105ffe:	84 c0                	test   %al,%al
  106000:	75 e7                	jne    105fe9 <strfind+0xe>
  106002:	eb 01                	jmp    106005 <strfind+0x2a>
        if (*s == c) {
            break;
  106004:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  106005:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106008:	c9                   	leave  
  106009:	c3                   	ret    

0010600a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10600a:	55                   	push   %ebp
  10600b:	89 e5                	mov    %esp,%ebp
  10600d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  106010:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  106017:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10601e:	eb 04                	jmp    106024 <strtol+0x1a>
        s ++;
  106020:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  106024:	8b 45 08             	mov    0x8(%ebp),%eax
  106027:	0f b6 00             	movzbl (%eax),%eax
  10602a:	3c 20                	cmp    $0x20,%al
  10602c:	74 f2                	je     106020 <strtol+0x16>
  10602e:	8b 45 08             	mov    0x8(%ebp),%eax
  106031:	0f b6 00             	movzbl (%eax),%eax
  106034:	3c 09                	cmp    $0x9,%al
  106036:	74 e8                	je     106020 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  106038:	8b 45 08             	mov    0x8(%ebp),%eax
  10603b:	0f b6 00             	movzbl (%eax),%eax
  10603e:	3c 2b                	cmp    $0x2b,%al
  106040:	75 06                	jne    106048 <strtol+0x3e>
        s ++;
  106042:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106046:	eb 15                	jmp    10605d <strtol+0x53>
    }
    else if (*s == '-') {
  106048:	8b 45 08             	mov    0x8(%ebp),%eax
  10604b:	0f b6 00             	movzbl (%eax),%eax
  10604e:	3c 2d                	cmp    $0x2d,%al
  106050:	75 0b                	jne    10605d <strtol+0x53>
        s ++, neg = 1;
  106052:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106056:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10605d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106061:	74 06                	je     106069 <strtol+0x5f>
  106063:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106067:	75 24                	jne    10608d <strtol+0x83>
  106069:	8b 45 08             	mov    0x8(%ebp),%eax
  10606c:	0f b6 00             	movzbl (%eax),%eax
  10606f:	3c 30                	cmp    $0x30,%al
  106071:	75 1a                	jne    10608d <strtol+0x83>
  106073:	8b 45 08             	mov    0x8(%ebp),%eax
  106076:	83 c0 01             	add    $0x1,%eax
  106079:	0f b6 00             	movzbl (%eax),%eax
  10607c:	3c 78                	cmp    $0x78,%al
  10607e:	75 0d                	jne    10608d <strtol+0x83>
        s += 2, base = 16;
  106080:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106084:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10608b:	eb 2a                	jmp    1060b7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10608d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106091:	75 17                	jne    1060aa <strtol+0xa0>
  106093:	8b 45 08             	mov    0x8(%ebp),%eax
  106096:	0f b6 00             	movzbl (%eax),%eax
  106099:	3c 30                	cmp    $0x30,%al
  10609b:	75 0d                	jne    1060aa <strtol+0xa0>
        s ++, base = 8;
  10609d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1060a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1060a8:	eb 0d                	jmp    1060b7 <strtol+0xad>
    }
    else if (base == 0) {
  1060aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1060ae:	75 07                	jne    1060b7 <strtol+0xad>
        base = 10;
  1060b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1060b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ba:	0f b6 00             	movzbl (%eax),%eax
  1060bd:	3c 2f                	cmp    $0x2f,%al
  1060bf:	7e 1b                	jle    1060dc <strtol+0xd2>
  1060c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1060c4:	0f b6 00             	movzbl (%eax),%eax
  1060c7:	3c 39                	cmp    $0x39,%al
  1060c9:	7f 11                	jg     1060dc <strtol+0xd2>
            dig = *s - '0';
  1060cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ce:	0f b6 00             	movzbl (%eax),%eax
  1060d1:	0f be c0             	movsbl %al,%eax
  1060d4:	83 e8 30             	sub    $0x30,%eax
  1060d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060da:	eb 48                	jmp    106124 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1060dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1060df:	0f b6 00             	movzbl (%eax),%eax
  1060e2:	3c 60                	cmp    $0x60,%al
  1060e4:	7e 1b                	jle    106101 <strtol+0xf7>
  1060e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1060e9:	0f b6 00             	movzbl (%eax),%eax
  1060ec:	3c 7a                	cmp    $0x7a,%al
  1060ee:	7f 11                	jg     106101 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1060f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1060f3:	0f b6 00             	movzbl (%eax),%eax
  1060f6:	0f be c0             	movsbl %al,%eax
  1060f9:	83 e8 57             	sub    $0x57,%eax
  1060fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060ff:	eb 23                	jmp    106124 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106101:	8b 45 08             	mov    0x8(%ebp),%eax
  106104:	0f b6 00             	movzbl (%eax),%eax
  106107:	3c 40                	cmp    $0x40,%al
  106109:	7e 3c                	jle    106147 <strtol+0x13d>
  10610b:	8b 45 08             	mov    0x8(%ebp),%eax
  10610e:	0f b6 00             	movzbl (%eax),%eax
  106111:	3c 5a                	cmp    $0x5a,%al
  106113:	7f 32                	jg     106147 <strtol+0x13d>
            dig = *s - 'A' + 10;
  106115:	8b 45 08             	mov    0x8(%ebp),%eax
  106118:	0f b6 00             	movzbl (%eax),%eax
  10611b:	0f be c0             	movsbl %al,%eax
  10611e:	83 e8 37             	sub    $0x37,%eax
  106121:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106127:	3b 45 10             	cmp    0x10(%ebp),%eax
  10612a:	7d 1a                	jge    106146 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  10612c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106133:	0f af 45 10          	imul   0x10(%ebp),%eax
  106137:	89 c2                	mov    %eax,%edx
  106139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10613c:	01 d0                	add    %edx,%eax
  10613e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  106141:	e9 71 ff ff ff       	jmp    1060b7 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  106146:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  106147:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10614b:	74 08                	je     106155 <strtol+0x14b>
        *endptr = (char *) s;
  10614d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106150:	8b 55 08             	mov    0x8(%ebp),%edx
  106153:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106159:	74 07                	je     106162 <strtol+0x158>
  10615b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10615e:	f7 d8                	neg    %eax
  106160:	eb 03                	jmp    106165 <strtol+0x15b>
  106162:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106165:	c9                   	leave  
  106166:	c3                   	ret    

00106167 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106167:	55                   	push   %ebp
  106168:	89 e5                	mov    %esp,%ebp
  10616a:	57                   	push   %edi
  10616b:	83 ec 24             	sub    $0x24,%esp
  10616e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106171:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106174:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  106178:	8b 55 08             	mov    0x8(%ebp),%edx
  10617b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10617e:	88 45 f7             	mov    %al,-0x9(%ebp)
  106181:	8b 45 10             	mov    0x10(%ebp),%eax
  106184:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106187:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10618a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10618e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106191:	89 d7                	mov    %edx,%edi
  106193:	f3 aa                	rep stos %al,%es:(%edi)
  106195:	89 fa                	mov    %edi,%edx
  106197:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10619a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10619d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1061a0:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1061a1:	83 c4 24             	add    $0x24,%esp
  1061a4:	5f                   	pop    %edi
  1061a5:	5d                   	pop    %ebp
  1061a6:	c3                   	ret    

001061a7 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1061a7:	55                   	push   %ebp
  1061a8:	89 e5                	mov    %esp,%ebp
  1061aa:	57                   	push   %edi
  1061ab:	56                   	push   %esi
  1061ac:	53                   	push   %ebx
  1061ad:	83 ec 30             	sub    $0x30,%esp
  1061b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1061b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1061bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1061bf:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1061c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1061c8:	73 42                	jae    10620c <memmove+0x65>
  1061ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1061d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1061d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1061d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1061dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1061df:	c1 e8 02             	shr    $0x2,%eax
  1061e2:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1061e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1061e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1061ea:	89 d7                	mov    %edx,%edi
  1061ec:	89 c6                	mov    %eax,%esi
  1061ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1061f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1061f3:	83 e1 03             	and    $0x3,%ecx
  1061f6:	74 02                	je     1061fa <memmove+0x53>
  1061f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1061fa:	89 f0                	mov    %esi,%eax
  1061fc:	89 fa                	mov    %edi,%edx
  1061fe:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106201:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106204:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  106207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  10620a:	eb 36                	jmp    106242 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10620c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10620f:	8d 50 ff             	lea    -0x1(%eax),%edx
  106212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106215:	01 c2                	add    %eax,%edx
  106217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10621a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10621d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106220:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  106223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106226:	89 c1                	mov    %eax,%ecx
  106228:	89 d8                	mov    %ebx,%eax
  10622a:	89 d6                	mov    %edx,%esi
  10622c:	89 c7                	mov    %eax,%edi
  10622e:	fd                   	std    
  10622f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106231:	fc                   	cld    
  106232:	89 f8                	mov    %edi,%eax
  106234:	89 f2                	mov    %esi,%edx
  106236:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106239:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10623c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  10623f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106242:	83 c4 30             	add    $0x30,%esp
  106245:	5b                   	pop    %ebx
  106246:	5e                   	pop    %esi
  106247:	5f                   	pop    %edi
  106248:	5d                   	pop    %ebp
  106249:	c3                   	ret    

0010624a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10624a:	55                   	push   %ebp
  10624b:	89 e5                	mov    %esp,%ebp
  10624d:	57                   	push   %edi
  10624e:	56                   	push   %esi
  10624f:	83 ec 20             	sub    $0x20,%esp
  106252:	8b 45 08             	mov    0x8(%ebp),%eax
  106255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106258:	8b 45 0c             	mov    0xc(%ebp),%eax
  10625b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10625e:	8b 45 10             	mov    0x10(%ebp),%eax
  106261:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106264:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106267:	c1 e8 02             	shr    $0x2,%eax
  10626a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10626c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10626f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106272:	89 d7                	mov    %edx,%edi
  106274:	89 c6                	mov    %eax,%esi
  106276:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106278:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10627b:	83 e1 03             	and    $0x3,%ecx
  10627e:	74 02                	je     106282 <memcpy+0x38>
  106280:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106282:	89 f0                	mov    %esi,%eax
  106284:	89 fa                	mov    %edi,%edx
  106286:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106289:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10628c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10628f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  106292:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106293:	83 c4 20             	add    $0x20,%esp
  106296:	5e                   	pop    %esi
  106297:	5f                   	pop    %edi
  106298:	5d                   	pop    %ebp
  106299:	c3                   	ret    

0010629a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10629a:	55                   	push   %ebp
  10629b:	89 e5                	mov    %esp,%ebp
  10629d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1062a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1062a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1062a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1062ac:	eb 30                	jmp    1062de <memcmp+0x44>
        if (*s1 != *s2) {
  1062ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1062b1:	0f b6 10             	movzbl (%eax),%edx
  1062b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1062b7:	0f b6 00             	movzbl (%eax),%eax
  1062ba:	38 c2                	cmp    %al,%dl
  1062bc:	74 18                	je     1062d6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1062be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1062c1:	0f b6 00             	movzbl (%eax),%eax
  1062c4:	0f b6 d0             	movzbl %al,%edx
  1062c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1062ca:	0f b6 00             	movzbl (%eax),%eax
  1062cd:	0f b6 c0             	movzbl %al,%eax
  1062d0:	29 c2                	sub    %eax,%edx
  1062d2:	89 d0                	mov    %edx,%eax
  1062d4:	eb 1a                	jmp    1062f0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1062d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1062da:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1062de:	8b 45 10             	mov    0x10(%ebp),%eax
  1062e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1062e4:	89 55 10             	mov    %edx,0x10(%ebp)
  1062e7:	85 c0                	test   %eax,%eax
  1062e9:	75 c3                	jne    1062ae <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1062eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1062f0:	c9                   	leave  
  1062f1:	c3                   	ret    

001062f2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1062f2:	55                   	push   %ebp
  1062f3:	89 e5                	mov    %esp,%ebp
  1062f5:	83 ec 38             	sub    $0x38,%esp
  1062f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1062fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1062fe:	8b 45 14             	mov    0x14(%ebp),%eax
  106301:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106304:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106307:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10630a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10630d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  106310:	8b 45 18             	mov    0x18(%ebp),%eax
  106313:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10631c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10631f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  106322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10632c:	74 1c                	je     10634a <printnum+0x58>
  10632e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106331:	ba 00 00 00 00       	mov    $0x0,%edx
  106336:	f7 75 e4             	divl   -0x1c(%ebp)
  106339:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10633c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10633f:	ba 00 00 00 00       	mov    $0x0,%edx
  106344:	f7 75 e4             	divl   -0x1c(%ebp)
  106347:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10634a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10634d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106350:	f7 75 e4             	divl   -0x1c(%ebp)
  106353:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106356:	89 55 dc             	mov    %edx,-0x24(%ebp)
  106359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10635c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10635f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106362:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106365:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106368:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10636b:	8b 45 18             	mov    0x18(%ebp),%eax
  10636e:	ba 00 00 00 00       	mov    $0x0,%edx
  106373:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  106376:	77 41                	ja     1063b9 <printnum+0xc7>
  106378:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10637b:	72 05                	jb     106382 <printnum+0x90>
  10637d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  106380:	77 37                	ja     1063b9 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  106382:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106385:	83 e8 01             	sub    $0x1,%eax
  106388:	83 ec 04             	sub    $0x4,%esp
  10638b:	ff 75 20             	pushl  0x20(%ebp)
  10638e:	50                   	push   %eax
  10638f:	ff 75 18             	pushl  0x18(%ebp)
  106392:	ff 75 ec             	pushl  -0x14(%ebp)
  106395:	ff 75 e8             	pushl  -0x18(%ebp)
  106398:	ff 75 0c             	pushl  0xc(%ebp)
  10639b:	ff 75 08             	pushl  0x8(%ebp)
  10639e:	e8 4f ff ff ff       	call   1062f2 <printnum>
  1063a3:	83 c4 20             	add    $0x20,%esp
  1063a6:	eb 1b                	jmp    1063c3 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1063a8:	83 ec 08             	sub    $0x8,%esp
  1063ab:	ff 75 0c             	pushl  0xc(%ebp)
  1063ae:	ff 75 20             	pushl  0x20(%ebp)
  1063b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1063b4:	ff d0                	call   *%eax
  1063b6:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1063b9:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1063bd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1063c1:	7f e5                	jg     1063a8 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1063c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1063c6:	05 0c 7e 10 00       	add    $0x107e0c,%eax
  1063cb:	0f b6 00             	movzbl (%eax),%eax
  1063ce:	0f be c0             	movsbl %al,%eax
  1063d1:	83 ec 08             	sub    $0x8,%esp
  1063d4:	ff 75 0c             	pushl  0xc(%ebp)
  1063d7:	50                   	push   %eax
  1063d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1063db:	ff d0                	call   *%eax
  1063dd:	83 c4 10             	add    $0x10,%esp
}
  1063e0:	90                   	nop
  1063e1:	c9                   	leave  
  1063e2:	c3                   	ret    

001063e3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1063e3:	55                   	push   %ebp
  1063e4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1063e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1063ea:	7e 14                	jle    106400 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1063ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1063ef:	8b 00                	mov    (%eax),%eax
  1063f1:	8d 48 08             	lea    0x8(%eax),%ecx
  1063f4:	8b 55 08             	mov    0x8(%ebp),%edx
  1063f7:	89 0a                	mov    %ecx,(%edx)
  1063f9:	8b 50 04             	mov    0x4(%eax),%edx
  1063fc:	8b 00                	mov    (%eax),%eax
  1063fe:	eb 30                	jmp    106430 <getuint+0x4d>
    }
    else if (lflag) {
  106400:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106404:	74 16                	je     10641c <getuint+0x39>
        return va_arg(*ap, unsigned long);
  106406:	8b 45 08             	mov    0x8(%ebp),%eax
  106409:	8b 00                	mov    (%eax),%eax
  10640b:	8d 48 04             	lea    0x4(%eax),%ecx
  10640e:	8b 55 08             	mov    0x8(%ebp),%edx
  106411:	89 0a                	mov    %ecx,(%edx)
  106413:	8b 00                	mov    (%eax),%eax
  106415:	ba 00 00 00 00       	mov    $0x0,%edx
  10641a:	eb 14                	jmp    106430 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10641c:	8b 45 08             	mov    0x8(%ebp),%eax
  10641f:	8b 00                	mov    (%eax),%eax
  106421:	8d 48 04             	lea    0x4(%eax),%ecx
  106424:	8b 55 08             	mov    0x8(%ebp),%edx
  106427:	89 0a                	mov    %ecx,(%edx)
  106429:	8b 00                	mov    (%eax),%eax
  10642b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106430:	5d                   	pop    %ebp
  106431:	c3                   	ret    

00106432 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  106432:	55                   	push   %ebp
  106433:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106435:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106439:	7e 14                	jle    10644f <getint+0x1d>
        return va_arg(*ap, long long);
  10643b:	8b 45 08             	mov    0x8(%ebp),%eax
  10643e:	8b 00                	mov    (%eax),%eax
  106440:	8d 48 08             	lea    0x8(%eax),%ecx
  106443:	8b 55 08             	mov    0x8(%ebp),%edx
  106446:	89 0a                	mov    %ecx,(%edx)
  106448:	8b 50 04             	mov    0x4(%eax),%edx
  10644b:	8b 00                	mov    (%eax),%eax
  10644d:	eb 28                	jmp    106477 <getint+0x45>
    }
    else if (lflag) {
  10644f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106453:	74 12                	je     106467 <getint+0x35>
        return va_arg(*ap, long);
  106455:	8b 45 08             	mov    0x8(%ebp),%eax
  106458:	8b 00                	mov    (%eax),%eax
  10645a:	8d 48 04             	lea    0x4(%eax),%ecx
  10645d:	8b 55 08             	mov    0x8(%ebp),%edx
  106460:	89 0a                	mov    %ecx,(%edx)
  106462:	8b 00                	mov    (%eax),%eax
  106464:	99                   	cltd   
  106465:	eb 10                	jmp    106477 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  106467:	8b 45 08             	mov    0x8(%ebp),%eax
  10646a:	8b 00                	mov    (%eax),%eax
  10646c:	8d 48 04             	lea    0x4(%eax),%ecx
  10646f:	8b 55 08             	mov    0x8(%ebp),%edx
  106472:	89 0a                	mov    %ecx,(%edx)
  106474:	8b 00                	mov    (%eax),%eax
  106476:	99                   	cltd   
    }
}
  106477:	5d                   	pop    %ebp
  106478:	c3                   	ret    

00106479 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  106479:	55                   	push   %ebp
  10647a:	89 e5                	mov    %esp,%ebp
  10647c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  10647f:	8d 45 14             	lea    0x14(%ebp),%eax
  106482:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106488:	50                   	push   %eax
  106489:	ff 75 10             	pushl  0x10(%ebp)
  10648c:	ff 75 0c             	pushl  0xc(%ebp)
  10648f:	ff 75 08             	pushl  0x8(%ebp)
  106492:	e8 06 00 00 00       	call   10649d <vprintfmt>
  106497:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10649a:	90                   	nop
  10649b:	c9                   	leave  
  10649c:	c3                   	ret    

0010649d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10649d:	55                   	push   %ebp
  10649e:	89 e5                	mov    %esp,%ebp
  1064a0:	56                   	push   %esi
  1064a1:	53                   	push   %ebx
  1064a2:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1064a5:	eb 17                	jmp    1064be <vprintfmt+0x21>
            if (ch == '\0') {
  1064a7:	85 db                	test   %ebx,%ebx
  1064a9:	0f 84 8e 03 00 00    	je     10683d <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1064af:	83 ec 08             	sub    $0x8,%esp
  1064b2:	ff 75 0c             	pushl  0xc(%ebp)
  1064b5:	53                   	push   %ebx
  1064b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1064b9:	ff d0                	call   *%eax
  1064bb:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1064be:	8b 45 10             	mov    0x10(%ebp),%eax
  1064c1:	8d 50 01             	lea    0x1(%eax),%edx
  1064c4:	89 55 10             	mov    %edx,0x10(%ebp)
  1064c7:	0f b6 00             	movzbl (%eax),%eax
  1064ca:	0f b6 d8             	movzbl %al,%ebx
  1064cd:	83 fb 25             	cmp    $0x25,%ebx
  1064d0:	75 d5                	jne    1064a7 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1064d2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1064d6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1064dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1064e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1064ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1064ed:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1064f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1064f3:	8d 50 01             	lea    0x1(%eax),%edx
  1064f6:	89 55 10             	mov    %edx,0x10(%ebp)
  1064f9:	0f b6 00             	movzbl (%eax),%eax
  1064fc:	0f b6 d8             	movzbl %al,%ebx
  1064ff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106502:	83 f8 55             	cmp    $0x55,%eax
  106505:	0f 87 05 03 00 00    	ja     106810 <vprintfmt+0x373>
  10650b:	8b 04 85 30 7e 10 00 	mov    0x107e30(,%eax,4),%eax
  106512:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  106514:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106518:	eb d6                	jmp    1064f0 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10651a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10651e:	eb d0                	jmp    1064f0 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  106527:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10652a:	89 d0                	mov    %edx,%eax
  10652c:	c1 e0 02             	shl    $0x2,%eax
  10652f:	01 d0                	add    %edx,%eax
  106531:	01 c0                	add    %eax,%eax
  106533:	01 d8                	add    %ebx,%eax
  106535:	83 e8 30             	sub    $0x30,%eax
  106538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10653b:	8b 45 10             	mov    0x10(%ebp),%eax
  10653e:	0f b6 00             	movzbl (%eax),%eax
  106541:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  106544:	83 fb 2f             	cmp    $0x2f,%ebx
  106547:	7e 39                	jle    106582 <vprintfmt+0xe5>
  106549:	83 fb 39             	cmp    $0x39,%ebx
  10654c:	7f 34                	jg     106582 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10654e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  106552:	eb d3                	jmp    106527 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  106554:	8b 45 14             	mov    0x14(%ebp),%eax
  106557:	8d 50 04             	lea    0x4(%eax),%edx
  10655a:	89 55 14             	mov    %edx,0x14(%ebp)
  10655d:	8b 00                	mov    (%eax),%eax
  10655f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  106562:	eb 1f                	jmp    106583 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  106564:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106568:	79 86                	jns    1064f0 <vprintfmt+0x53>
                width = 0;
  10656a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  106571:	e9 7a ff ff ff       	jmp    1064f0 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  106576:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10657d:	e9 6e ff ff ff       	jmp    1064f0 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  106582:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  106583:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106587:	0f 89 63 ff ff ff    	jns    1064f0 <vprintfmt+0x53>
                width = precision, precision = -1;
  10658d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106590:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106593:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10659a:	e9 51 ff ff ff       	jmp    1064f0 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10659f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1065a3:	e9 48 ff ff ff       	jmp    1064f0 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1065a8:	8b 45 14             	mov    0x14(%ebp),%eax
  1065ab:	8d 50 04             	lea    0x4(%eax),%edx
  1065ae:	89 55 14             	mov    %edx,0x14(%ebp)
  1065b1:	8b 00                	mov    (%eax),%eax
  1065b3:	83 ec 08             	sub    $0x8,%esp
  1065b6:	ff 75 0c             	pushl  0xc(%ebp)
  1065b9:	50                   	push   %eax
  1065ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1065bd:	ff d0                	call   *%eax
  1065bf:	83 c4 10             	add    $0x10,%esp
            break;
  1065c2:	e9 71 02 00 00       	jmp    106838 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1065c7:	8b 45 14             	mov    0x14(%ebp),%eax
  1065ca:	8d 50 04             	lea    0x4(%eax),%edx
  1065cd:	89 55 14             	mov    %edx,0x14(%ebp)
  1065d0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1065d2:	85 db                	test   %ebx,%ebx
  1065d4:	79 02                	jns    1065d8 <vprintfmt+0x13b>
                err = -err;
  1065d6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1065d8:	83 fb 06             	cmp    $0x6,%ebx
  1065db:	7f 0b                	jg     1065e8 <vprintfmt+0x14b>
  1065dd:	8b 34 9d f0 7d 10 00 	mov    0x107df0(,%ebx,4),%esi
  1065e4:	85 f6                	test   %esi,%esi
  1065e6:	75 19                	jne    106601 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  1065e8:	53                   	push   %ebx
  1065e9:	68 1d 7e 10 00       	push   $0x107e1d
  1065ee:	ff 75 0c             	pushl  0xc(%ebp)
  1065f1:	ff 75 08             	pushl  0x8(%ebp)
  1065f4:	e8 80 fe ff ff       	call   106479 <printfmt>
  1065f9:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1065fc:	e9 37 02 00 00       	jmp    106838 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  106601:	56                   	push   %esi
  106602:	68 26 7e 10 00       	push   $0x107e26
  106607:	ff 75 0c             	pushl  0xc(%ebp)
  10660a:	ff 75 08             	pushl  0x8(%ebp)
  10660d:	e8 67 fe ff ff       	call   106479 <printfmt>
  106612:	83 c4 10             	add    $0x10,%esp
            }
            break;
  106615:	e9 1e 02 00 00       	jmp    106838 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10661a:	8b 45 14             	mov    0x14(%ebp),%eax
  10661d:	8d 50 04             	lea    0x4(%eax),%edx
  106620:	89 55 14             	mov    %edx,0x14(%ebp)
  106623:	8b 30                	mov    (%eax),%esi
  106625:	85 f6                	test   %esi,%esi
  106627:	75 05                	jne    10662e <vprintfmt+0x191>
                p = "(null)";
  106629:	be 29 7e 10 00       	mov    $0x107e29,%esi
            }
            if (width > 0 && padc != '-') {
  10662e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106632:	7e 76                	jle    1066aa <vprintfmt+0x20d>
  106634:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  106638:	74 70                	je     1066aa <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10663a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10663d:	83 ec 08             	sub    $0x8,%esp
  106640:	50                   	push   %eax
  106641:	56                   	push   %esi
  106642:	e8 17 f8 ff ff       	call   105e5e <strnlen>
  106647:	83 c4 10             	add    $0x10,%esp
  10664a:	89 c2                	mov    %eax,%edx
  10664c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10664f:	29 d0                	sub    %edx,%eax
  106651:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106654:	eb 17                	jmp    10666d <vprintfmt+0x1d0>
                    putch(padc, putdat);
  106656:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10665a:	83 ec 08             	sub    $0x8,%esp
  10665d:	ff 75 0c             	pushl  0xc(%ebp)
  106660:	50                   	push   %eax
  106661:	8b 45 08             	mov    0x8(%ebp),%eax
  106664:	ff d0                	call   *%eax
  106666:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  106669:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10666d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106671:	7f e3                	jg     106656 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106673:	eb 35                	jmp    1066aa <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  106675:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106679:	74 1c                	je     106697 <vprintfmt+0x1fa>
  10667b:	83 fb 1f             	cmp    $0x1f,%ebx
  10667e:	7e 05                	jle    106685 <vprintfmt+0x1e8>
  106680:	83 fb 7e             	cmp    $0x7e,%ebx
  106683:	7e 12                	jle    106697 <vprintfmt+0x1fa>
                    putch('?', putdat);
  106685:	83 ec 08             	sub    $0x8,%esp
  106688:	ff 75 0c             	pushl  0xc(%ebp)
  10668b:	6a 3f                	push   $0x3f
  10668d:	8b 45 08             	mov    0x8(%ebp),%eax
  106690:	ff d0                	call   *%eax
  106692:	83 c4 10             	add    $0x10,%esp
  106695:	eb 0f                	jmp    1066a6 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  106697:	83 ec 08             	sub    $0x8,%esp
  10669a:	ff 75 0c             	pushl  0xc(%ebp)
  10669d:	53                   	push   %ebx
  10669e:	8b 45 08             	mov    0x8(%ebp),%eax
  1066a1:	ff d0                	call   *%eax
  1066a3:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1066a6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1066aa:	89 f0                	mov    %esi,%eax
  1066ac:	8d 70 01             	lea    0x1(%eax),%esi
  1066af:	0f b6 00             	movzbl (%eax),%eax
  1066b2:	0f be d8             	movsbl %al,%ebx
  1066b5:	85 db                	test   %ebx,%ebx
  1066b7:	74 26                	je     1066df <vprintfmt+0x242>
  1066b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1066bd:	78 b6                	js     106675 <vprintfmt+0x1d8>
  1066bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1066c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1066c7:	79 ac                	jns    106675 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1066c9:	eb 14                	jmp    1066df <vprintfmt+0x242>
                putch(' ', putdat);
  1066cb:	83 ec 08             	sub    $0x8,%esp
  1066ce:	ff 75 0c             	pushl  0xc(%ebp)
  1066d1:	6a 20                	push   $0x20
  1066d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1066d6:	ff d0                	call   *%eax
  1066d8:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1066db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1066df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1066e3:	7f e6                	jg     1066cb <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  1066e5:	e9 4e 01 00 00       	jmp    106838 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1066ea:	83 ec 08             	sub    $0x8,%esp
  1066ed:	ff 75 e0             	pushl  -0x20(%ebp)
  1066f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1066f3:	50                   	push   %eax
  1066f4:	e8 39 fd ff ff       	call   106432 <getint>
  1066f9:	83 c4 10             	add    $0x10,%esp
  1066fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  106702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106708:	85 d2                	test   %edx,%edx
  10670a:	79 23                	jns    10672f <vprintfmt+0x292>
                putch('-', putdat);
  10670c:	83 ec 08             	sub    $0x8,%esp
  10670f:	ff 75 0c             	pushl  0xc(%ebp)
  106712:	6a 2d                	push   $0x2d
  106714:	8b 45 08             	mov    0x8(%ebp),%eax
  106717:	ff d0                	call   *%eax
  106719:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10671c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10671f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106722:	f7 d8                	neg    %eax
  106724:	83 d2 00             	adc    $0x0,%edx
  106727:	f7 da                	neg    %edx
  106729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10672c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10672f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106736:	e9 9f 00 00 00       	jmp    1067da <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10673b:	83 ec 08             	sub    $0x8,%esp
  10673e:	ff 75 e0             	pushl  -0x20(%ebp)
  106741:	8d 45 14             	lea    0x14(%ebp),%eax
  106744:	50                   	push   %eax
  106745:	e8 99 fc ff ff       	call   1063e3 <getuint>
  10674a:	83 c4 10             	add    $0x10,%esp
  10674d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106750:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106753:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10675a:	eb 7e                	jmp    1067da <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10675c:	83 ec 08             	sub    $0x8,%esp
  10675f:	ff 75 e0             	pushl  -0x20(%ebp)
  106762:	8d 45 14             	lea    0x14(%ebp),%eax
  106765:	50                   	push   %eax
  106766:	e8 78 fc ff ff       	call   1063e3 <getuint>
  10676b:	83 c4 10             	add    $0x10,%esp
  10676e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106771:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106774:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10677b:	eb 5d                	jmp    1067da <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10677d:	83 ec 08             	sub    $0x8,%esp
  106780:	ff 75 0c             	pushl  0xc(%ebp)
  106783:	6a 30                	push   $0x30
  106785:	8b 45 08             	mov    0x8(%ebp),%eax
  106788:	ff d0                	call   *%eax
  10678a:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10678d:	83 ec 08             	sub    $0x8,%esp
  106790:	ff 75 0c             	pushl  0xc(%ebp)
  106793:	6a 78                	push   $0x78
  106795:	8b 45 08             	mov    0x8(%ebp),%eax
  106798:	ff d0                	call   *%eax
  10679a:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10679d:	8b 45 14             	mov    0x14(%ebp),%eax
  1067a0:	8d 50 04             	lea    0x4(%eax),%edx
  1067a3:	89 55 14             	mov    %edx,0x14(%ebp)
  1067a6:	8b 00                	mov    (%eax),%eax
  1067a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1067ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1067b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1067b9:	eb 1f                	jmp    1067da <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1067bb:	83 ec 08             	sub    $0x8,%esp
  1067be:	ff 75 e0             	pushl  -0x20(%ebp)
  1067c1:	8d 45 14             	lea    0x14(%ebp),%eax
  1067c4:	50                   	push   %eax
  1067c5:	e8 19 fc ff ff       	call   1063e3 <getuint>
  1067ca:	83 c4 10             	add    $0x10,%esp
  1067cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1067d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1067d3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1067da:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1067de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1067e1:	83 ec 04             	sub    $0x4,%esp
  1067e4:	52                   	push   %edx
  1067e5:	ff 75 e8             	pushl  -0x18(%ebp)
  1067e8:	50                   	push   %eax
  1067e9:	ff 75 f4             	pushl  -0xc(%ebp)
  1067ec:	ff 75 f0             	pushl  -0x10(%ebp)
  1067ef:	ff 75 0c             	pushl  0xc(%ebp)
  1067f2:	ff 75 08             	pushl  0x8(%ebp)
  1067f5:	e8 f8 fa ff ff       	call   1062f2 <printnum>
  1067fa:	83 c4 20             	add    $0x20,%esp
            break;
  1067fd:	eb 39                	jmp    106838 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1067ff:	83 ec 08             	sub    $0x8,%esp
  106802:	ff 75 0c             	pushl  0xc(%ebp)
  106805:	53                   	push   %ebx
  106806:	8b 45 08             	mov    0x8(%ebp),%eax
  106809:	ff d0                	call   *%eax
  10680b:	83 c4 10             	add    $0x10,%esp
            break;
  10680e:	eb 28                	jmp    106838 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106810:	83 ec 08             	sub    $0x8,%esp
  106813:	ff 75 0c             	pushl  0xc(%ebp)
  106816:	6a 25                	push   $0x25
  106818:	8b 45 08             	mov    0x8(%ebp),%eax
  10681b:	ff d0                	call   *%eax
  10681d:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  106820:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106824:	eb 04                	jmp    10682a <vprintfmt+0x38d>
  106826:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10682a:	8b 45 10             	mov    0x10(%ebp),%eax
  10682d:	83 e8 01             	sub    $0x1,%eax
  106830:	0f b6 00             	movzbl (%eax),%eax
  106833:	3c 25                	cmp    $0x25,%al
  106835:	75 ef                	jne    106826 <vprintfmt+0x389>
                /* do nothing */;
            break;
  106837:	90                   	nop
        }
    }
  106838:	e9 68 fc ff ff       	jmp    1064a5 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  10683d:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10683e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  106841:	5b                   	pop    %ebx
  106842:	5e                   	pop    %esi
  106843:	5d                   	pop    %ebp
  106844:	c3                   	ret    

00106845 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106845:	55                   	push   %ebp
  106846:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106848:	8b 45 0c             	mov    0xc(%ebp),%eax
  10684b:	8b 40 08             	mov    0x8(%eax),%eax
  10684e:	8d 50 01             	lea    0x1(%eax),%edx
  106851:	8b 45 0c             	mov    0xc(%ebp),%eax
  106854:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106857:	8b 45 0c             	mov    0xc(%ebp),%eax
  10685a:	8b 10                	mov    (%eax),%edx
  10685c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10685f:	8b 40 04             	mov    0x4(%eax),%eax
  106862:	39 c2                	cmp    %eax,%edx
  106864:	73 12                	jae    106878 <sprintputch+0x33>
        *b->buf ++ = ch;
  106866:	8b 45 0c             	mov    0xc(%ebp),%eax
  106869:	8b 00                	mov    (%eax),%eax
  10686b:	8d 48 01             	lea    0x1(%eax),%ecx
  10686e:	8b 55 0c             	mov    0xc(%ebp),%edx
  106871:	89 0a                	mov    %ecx,(%edx)
  106873:	8b 55 08             	mov    0x8(%ebp),%edx
  106876:	88 10                	mov    %dl,(%eax)
    }
}
  106878:	90                   	nop
  106879:	5d                   	pop    %ebp
  10687a:	c3                   	ret    

0010687b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10687b:	55                   	push   %ebp
  10687c:	89 e5                	mov    %esp,%ebp
  10687e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106881:	8d 45 14             	lea    0x14(%ebp),%eax
  106884:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10688a:	50                   	push   %eax
  10688b:	ff 75 10             	pushl  0x10(%ebp)
  10688e:	ff 75 0c             	pushl  0xc(%ebp)
  106891:	ff 75 08             	pushl  0x8(%ebp)
  106894:	e8 0b 00 00 00       	call   1068a4 <vsnprintf>
  106899:	83 c4 10             	add    $0x10,%esp
  10689c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10689f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1068a2:	c9                   	leave  
  1068a3:	c3                   	ret    

001068a4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1068a4:	55                   	push   %ebp
  1068a5:	89 e5                	mov    %esp,%ebp
  1068a7:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1068aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1068ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1068b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1068b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1068b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1068b9:	01 d0                	add    %edx,%eax
  1068bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1068be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1068c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1068c9:	74 0a                	je     1068d5 <vsnprintf+0x31>
  1068cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1068ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068d1:	39 c2                	cmp    %eax,%edx
  1068d3:	76 07                	jbe    1068dc <vsnprintf+0x38>
        return -E_INVAL;
  1068d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1068da:	eb 20                	jmp    1068fc <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1068dc:	ff 75 14             	pushl  0x14(%ebp)
  1068df:	ff 75 10             	pushl  0x10(%ebp)
  1068e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1068e5:	50                   	push   %eax
  1068e6:	68 45 68 10 00       	push   $0x106845
  1068eb:	e8 ad fb ff ff       	call   10649d <vprintfmt>
  1068f0:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1068f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1068f6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1068f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1068fc:	c9                   	leave  
  1068fd:	c3                   	ret    
