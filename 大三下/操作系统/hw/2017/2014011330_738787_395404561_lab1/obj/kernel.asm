
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void grade_backtrace(void);
static void lab1_switch_test(void);
static void lab1_print_cur_status(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 40 fd 10 00       	mov    $0x10fd40,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 41 2e 00 00       	call   102e65 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 42 15 00 00       	call   10156e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 00 36 10 00 	movl   $0x103600,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 1c 36 10 00       	push   $0x10361c
  10003e:	e8 25 02 00 00       	call   100268 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 a7 08 00 00       	call   1008f2 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 91 00 00 00       	call   1000e1 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 d4 2a 00 00       	call   102b29 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 57 16 00 00       	call   1016b1 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 d9 17 00 00       	call   101838 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 ef 0c 00 00       	call   100d53 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 85 17 00 00       	call   1017ee <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 6b 01 00 00       	call   1001d9 <lab1_switch_test>

    /* do nothing */
    // extern bool should_print;
    while (1) {
    	if (should_print) {
  10006e:	a1 a0 f0 10 00       	mov    0x10f0a0,%eax
  100073:	85 c0                	test   %eax,%eax
  100075:	74 f7                	je     10006e <kern_init+0x6e>
    		should_print = 0;
  100077:	c7 05 a0 f0 10 00 00 	movl   $0x0,0x10f0a0
  10007e:	00 00 00 
    		lab1_print_cur_status();
  100081:	e8 7c 00 00 00       	call   100102 <lab1_print_cur_status>
    	}
    }
  100086:	eb e6                	jmp    10006e <kern_init+0x6e>

00100088 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100088:	55                   	push   %ebp
  100089:	89 e5                	mov    %esp,%ebp
  10008b:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10008e:	83 ec 04             	sub    $0x4,%esp
  100091:	6a 00                	push   $0x0
  100093:	6a 00                	push   $0x0
  100095:	6a 00                	push   $0x0
  100097:	e8 a5 0c 00 00       	call   100d41 <mon_backtrace>
  10009c:	83 c4 10             	add    $0x10,%esp
}
  10009f:	90                   	nop
  1000a0:	c9                   	leave  
  1000a1:	c3                   	ret    

001000a2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	51                   	push   %ecx
  1000b6:	52                   	push   %edx
  1000b7:	53                   	push   %ebx
  1000b8:	50                   	push   %eax
  1000b9:	e8 ca ff ff ff       	call   100088 <grade_backtrace2>
  1000be:	83 c4 10             	add    $0x10,%esp
}
  1000c1:	90                   	nop
  1000c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c5:	c9                   	leave  
  1000c6:	c3                   	ret    

001000c7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c7:	55                   	push   %ebp
  1000c8:	89 e5                	mov    %esp,%ebp
  1000ca:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000cd:	83 ec 08             	sub    $0x8,%esp
  1000d0:	ff 75 10             	pushl  0x10(%ebp)
  1000d3:	ff 75 08             	pushl  0x8(%ebp)
  1000d6:	e8 c7 ff ff ff       	call   1000a2 <grade_backtrace1>
  1000db:	83 c4 10             	add    $0x10,%esp
}
  1000de:	90                   	nop
  1000df:	c9                   	leave  
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e7:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ec:	83 ec 04             	sub    $0x4,%esp
  1000ef:	68 00 00 ff ff       	push   $0xffff0000
  1000f4:	50                   	push   %eax
  1000f5:	6a 00                	push   $0x0
  1000f7:	e8 cb ff ff ff       	call   1000c7 <grade_backtrace0>
  1000fc:	83 c4 10             	add    $0x10,%esp
}
  1000ff:	90                   	nop
  100100:	c9                   	leave  
  100101:	c3                   	ret    

00100102 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100102:	55                   	push   %ebp
  100103:	89 e5                	mov    %esp,%ebp
  100105:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100108:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010b:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010e:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100111:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100114:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100118:	0f b7 c0             	movzwl %ax,%eax
  10011b:	83 e0 03             	and    $0x3,%eax
  10011e:	89 c2                	mov    %eax,%edx
  100120:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100125:	83 ec 04             	sub    $0x4,%esp
  100128:	52                   	push   %edx
  100129:	50                   	push   %eax
  10012a:	68 21 36 10 00       	push   $0x103621
  10012f:	e8 34 01 00 00       	call   100268 <cprintf>
  100134:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	83 ec 04             	sub    $0x4,%esp
  100146:	52                   	push   %edx
  100147:	50                   	push   %eax
  100148:	68 2f 36 10 00       	push   $0x10362f
  10014d:	e8 16 01 00 00       	call   100268 <cprintf>
  100152:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100155:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100159:	0f b7 d0             	movzwl %ax,%edx
  10015c:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100161:	83 ec 04             	sub    $0x4,%esp
  100164:	52                   	push   %edx
  100165:	50                   	push   %eax
  100166:	68 3d 36 10 00       	push   $0x10363d
  10016b:	e8 f8 00 00 00       	call   100268 <cprintf>
  100170:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100173:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100177:	0f b7 d0             	movzwl %ax,%edx
  10017a:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10017f:	83 ec 04             	sub    $0x4,%esp
  100182:	52                   	push   %edx
  100183:	50                   	push   %eax
  100184:	68 4b 36 10 00       	push   $0x10364b
  100189:	e8 da 00 00 00       	call   100268 <cprintf>
  10018e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100191:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100195:	0f b7 d0             	movzwl %ax,%edx
  100198:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019d:	83 ec 04             	sub    $0x4,%esp
  1001a0:	52                   	push   %edx
  1001a1:	50                   	push   %eax
  1001a2:	68 59 36 10 00       	push   $0x103659
  1001a7:	e8 bc 00 00 00       	call   100268 <cprintf>
  1001ac:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001af:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001b4:	83 c0 01             	add    $0x1,%eax
  1001b7:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001bc:	90                   	nop
  1001bd:	c9                   	leave  
  1001be:	c3                   	ret    

001001bf <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001bf:	55                   	push   %ebp
  1001c0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001c2:	83 ec 08             	sub    $0x8,%esp
  1001c5:	cd 78                	int    $0x78
  1001c7:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp"
		:
		: "i"(T_SWITCH_TOU)
	);
}
  1001c9:	90                   	nop
  1001ca:	5d                   	pop    %ebp
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001cf:	83 ec 08             	sub    $0x8,%esp
  1001d2:	cd 79                	int    $0x79
  1001d4:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp"
		:
		: "i"(T_SWITCH_TOK)
	);
}
  1001d6:	90                   	nop
  1001d7:	5d                   	pop    %ebp
  1001d8:	c3                   	ret    

001001d9 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d9:	55                   	push   %ebp
  1001da:	89 e5                	mov    %esp,%ebp
  1001dc:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001df:	e8 1e ff ff ff       	call   100102 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e4:	83 ec 0c             	sub    $0xc,%esp
  1001e7:	68 68 36 10 00       	push   $0x103668
  1001ec:	e8 77 00 00 00       	call   100268 <cprintf>
  1001f1:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f4:	e8 c6 ff ff ff       	call   1001bf <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f9:	e8 04 ff ff ff       	call   100102 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001fe:	83 ec 0c             	sub    $0xc,%esp
  100201:	68 88 36 10 00       	push   $0x103688
  100206:	e8 5d 00 00 00       	call   100268 <cprintf>
  10020b:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10020e:	e8 b9 ff ff ff       	call   1001cc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100213:	e8 ea fe ff ff       	call   100102 <lab1_print_cur_status>
}
  100218:	90                   	nop
  100219:	c9                   	leave  
  10021a:	c3                   	ret    

0010021b <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021b:	55                   	push   %ebp
  10021c:	89 e5                	mov    %esp,%ebp
  10021e:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100221:	83 ec 0c             	sub    $0xc,%esp
  100224:	ff 75 08             	pushl  0x8(%ebp)
  100227:	e8 73 13 00 00       	call   10159f <cons_putc>
  10022c:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100232:	8b 00                	mov    (%eax),%eax
  100234:	8d 50 01             	lea    0x1(%eax),%edx
  100237:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023a:	89 10                	mov    %edx,(%eax)
}
  10023c:	90                   	nop
  10023d:	c9                   	leave  
  10023e:	c3                   	ret    

0010023f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10023f:	55                   	push   %ebp
  100240:	89 e5                	mov    %esp,%ebp
  100242:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100245:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10024c:	ff 75 0c             	pushl  0xc(%ebp)
  10024f:	ff 75 08             	pushl  0x8(%ebp)
  100252:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100255:	50                   	push   %eax
  100256:	68 1b 02 10 00       	push   $0x10021b
  10025b:	e8 3b 2f 00 00       	call   10319b <vprintfmt>
  100260:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100263:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100266:	c9                   	leave  
  100267:	c3                   	ret    

00100268 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100268:	55                   	push   %ebp
  100269:	89 e5                	mov    %esp,%ebp
  10026b:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10026e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100271:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100277:	83 ec 08             	sub    $0x8,%esp
  10027a:	50                   	push   %eax
  10027b:	ff 75 08             	pushl  0x8(%ebp)
  10027e:	e8 bc ff ff ff       	call   10023f <vcprintf>
  100283:	83 c4 10             	add    $0x10,%esp
  100286:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100289:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028c:	c9                   	leave  
  10028d:	c3                   	ret    

0010028e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10028e:	55                   	push   %ebp
  10028f:	89 e5                	mov    %esp,%ebp
  100291:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100294:	83 ec 0c             	sub    $0xc,%esp
  100297:	ff 75 08             	pushl  0x8(%ebp)
  10029a:	e8 00 13 00 00       	call   10159f <cons_putc>
  10029f:	83 c4 10             	add    $0x10,%esp
}
  1002a2:	90                   	nop
  1002a3:	c9                   	leave  
  1002a4:	c3                   	ret    

001002a5 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a5:	55                   	push   %ebp
  1002a6:	89 e5                	mov    %esp,%ebp
  1002a8:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b2:	eb 14                	jmp    1002c8 <cputs+0x23>
        cputch(c, &cnt);
  1002b4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b8:	83 ec 08             	sub    $0x8,%esp
  1002bb:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002be:	52                   	push   %edx
  1002bf:	50                   	push   %eax
  1002c0:	e8 56 ff ff ff       	call   10021b <cputch>
  1002c5:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	8d 50 01             	lea    0x1(%eax),%edx
  1002ce:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d1:	0f b6 00             	movzbl (%eax),%eax
  1002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002db:	75 d7                	jne    1002b4 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002dd:	83 ec 08             	sub    $0x8,%esp
  1002e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e3:	50                   	push   %eax
  1002e4:	6a 0a                	push   $0xa
  1002e6:	e8 30 ff ff ff       	call   10021b <cputch>
  1002eb:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f1:	c9                   	leave  
  1002f2:	c3                   	ret    

001002f3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f3:	55                   	push   %ebp
  1002f4:	89 e5                	mov    %esp,%ebp
  1002f6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002f9:	e8 d1 12 00 00       	call   1015cf <cons_getc>
  1002fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100305:	74 f2                	je     1002f9 <getchar+0x6>
        /* do nothing */;
    return c;
  100307:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030a:	c9                   	leave  
  10030b:	c3                   	ret    

0010030c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030c:	55                   	push   %ebp
  10030d:	89 e5                	mov    %esp,%ebp
  10030f:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100312:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100316:	74 13                	je     10032b <readline+0x1f>
        cprintf("%s", prompt);
  100318:	83 ec 08             	sub    $0x8,%esp
  10031b:	ff 75 08             	pushl  0x8(%ebp)
  10031e:	68 a7 36 10 00       	push   $0x1036a7
  100323:	e8 40 ff ff ff       	call   100268 <cprintf>
  100328:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100332:	e8 bc ff ff ff       	call   1002f3 <getchar>
  100337:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10033e:	79 0a                	jns    10034a <readline+0x3e>
            return NULL;
  100340:	b8 00 00 00 00       	mov    $0x0,%eax
  100345:	e9 82 00 00 00       	jmp    1003cc <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10034a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034e:	7e 2b                	jle    10037b <readline+0x6f>
  100350:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100357:	7f 22                	jg     10037b <readline+0x6f>
            cputchar(c);
  100359:	83 ec 0c             	sub    $0xc,%esp
  10035c:	ff 75 f0             	pushl  -0x10(%ebp)
  10035f:	e8 2a ff ff ff       	call   10028e <cputchar>
  100364:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10036a:	8d 50 01             	lea    0x1(%eax),%edx
  10036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100370:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100373:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100379:	eb 4c                	jmp    1003c7 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037f:	75 1a                	jne    10039b <readline+0x8f>
  100381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100385:	7e 14                	jle    10039b <readline+0x8f>
            cputchar(c);
  100387:	83 ec 0c             	sub    $0xc,%esp
  10038a:	ff 75 f0             	pushl  -0x10(%ebp)
  10038d:	e8 fc fe ff ff       	call   10028e <cputchar>
  100392:	83 c4 10             	add    $0x10,%esp
            i --;
  100395:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100399:	eb 2c                	jmp    1003c7 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10039f:	74 06                	je     1003a7 <readline+0x9b>
  1003a1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a5:	75 8b                	jne    100332 <readline+0x26>
            cputchar(c);
  1003a7:	83 ec 0c             	sub    $0xc,%esp
  1003aa:	ff 75 f0             	pushl  -0x10(%ebp)
  1003ad:	e8 dc fe ff ff       	call   10028e <cputchar>
  1003b2:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b8:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003bd:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003c0:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003c5:	eb 05                	jmp    1003cc <readline+0xc0>
        }
    }
  1003c7:	e9 66 ff ff ff       	jmp    100332 <readline+0x26>
}
  1003cc:	c9                   	leave  
  1003cd:	c3                   	ret    

001003ce <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003ce:	55                   	push   %ebp
  1003cf:	89 e5                	mov    %esp,%ebp
  1003d1:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d4:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003d9:	85 c0                	test   %eax,%eax
  1003db:	75 4a                	jne    100427 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003dd:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003e4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003e7:	8d 45 14             	lea    0x14(%ebp),%eax
  1003ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ed:	83 ec 04             	sub    $0x4,%esp
  1003f0:	ff 75 0c             	pushl  0xc(%ebp)
  1003f3:	ff 75 08             	pushl  0x8(%ebp)
  1003f6:	68 aa 36 10 00       	push   $0x1036aa
  1003fb:	e8 68 fe ff ff       	call   100268 <cprintf>
  100400:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100406:	83 ec 08             	sub    $0x8,%esp
  100409:	50                   	push   %eax
  10040a:	ff 75 10             	pushl  0x10(%ebp)
  10040d:	e8 2d fe ff ff       	call   10023f <vcprintf>
  100412:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100415:	83 ec 0c             	sub    $0xc,%esp
  100418:	68 c6 36 10 00       	push   $0x1036c6
  10041d:	e8 46 fe ff ff       	call   100268 <cprintf>
  100422:	83 c4 10             	add    $0x10,%esp
  100425:	eb 01                	jmp    100428 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100427:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100428:	e8 c8 13 00 00       	call   1017f5 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10042d:	83 ec 0c             	sub    $0xc,%esp
  100430:	6a 00                	push   $0x0
  100432:	e8 30 08 00 00       	call   100c67 <kmonitor>
  100437:	83 c4 10             	add    $0x10,%esp
    }
  10043a:	eb f1                	jmp    10042d <__panic+0x5f>

0010043c <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10043c:	55                   	push   %ebp
  10043d:	89 e5                	mov    %esp,%ebp
  10043f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100442:	8d 45 14             	lea    0x14(%ebp),%eax
  100445:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100448:	83 ec 04             	sub    $0x4,%esp
  10044b:	ff 75 0c             	pushl  0xc(%ebp)
  10044e:	ff 75 08             	pushl  0x8(%ebp)
  100451:	68 c8 36 10 00       	push   $0x1036c8
  100456:	e8 0d fe ff ff       	call   100268 <cprintf>
  10045b:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100461:	83 ec 08             	sub    $0x8,%esp
  100464:	50                   	push   %eax
  100465:	ff 75 10             	pushl  0x10(%ebp)
  100468:	e8 d2 fd ff ff       	call   10023f <vcprintf>
  10046d:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100470:	83 ec 0c             	sub    $0xc,%esp
  100473:	68 c6 36 10 00       	push   $0x1036c6
  100478:	e8 eb fd ff ff       	call   100268 <cprintf>
  10047d:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100480:	90                   	nop
  100481:	c9                   	leave  
  100482:	c3                   	ret    

00100483 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100483:	55                   	push   %ebp
  100484:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100486:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10048b:	5d                   	pop    %ebp
  10048c:	c3                   	ret    

0010048d <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10048d:	55                   	push   %ebp
  10048e:	89 e5                	mov    %esp,%ebp
  100490:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100493:	8b 45 0c             	mov    0xc(%ebp),%eax
  100496:	8b 00                	mov    (%eax),%eax
  100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049b:	8b 45 10             	mov    0x10(%ebp),%eax
  10049e:	8b 00                	mov    (%eax),%eax
  1004a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004aa:	e9 d2 00 00 00       	jmp    100581 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b5:	01 d0                	add    %edx,%eax
  1004b7:	89 c2                	mov    %eax,%edx
  1004b9:	c1 ea 1f             	shr    $0x1f,%edx
  1004bc:	01 d0                	add    %edx,%eax
  1004be:	d1 f8                	sar    %eax
  1004c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c9:	eb 04                	jmp    1004cf <stab_binsearch+0x42>
            m --;
  1004cb:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d5:	7c 1f                	jl     1004f6 <stab_binsearch+0x69>
  1004d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004da:	89 d0                	mov    %edx,%eax
  1004dc:	01 c0                	add    %eax,%eax
  1004de:	01 d0                	add    %edx,%eax
  1004e0:	c1 e0 02             	shl    $0x2,%eax
  1004e3:	89 c2                	mov    %eax,%edx
  1004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e8:	01 d0                	add    %edx,%eax
  1004ea:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004ee:	0f b6 c0             	movzbl %al,%eax
  1004f1:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f4:	75 d5                	jne    1004cb <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fc:	7d 0b                	jge    100509 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100501:	83 c0 01             	add    $0x1,%eax
  100504:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100507:	eb 78                	jmp    100581 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100509:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100513:	89 d0                	mov    %edx,%eax
  100515:	01 c0                	add    %eax,%eax
  100517:	01 d0                	add    %edx,%eax
  100519:	c1 e0 02             	shl    $0x2,%eax
  10051c:	89 c2                	mov    %eax,%edx
  10051e:	8b 45 08             	mov    0x8(%ebp),%eax
  100521:	01 d0                	add    %edx,%eax
  100523:	8b 40 08             	mov    0x8(%eax),%eax
  100526:	3b 45 18             	cmp    0x18(%ebp),%eax
  100529:	73 13                	jae    10053e <stab_binsearch+0xb1>
            *region_left = m;
  10052b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100531:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100536:	83 c0 01             	add    $0x1,%eax
  100539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053c:	eb 43                	jmp    100581 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	3b 45 18             	cmp    0x18(%ebp),%eax
  100557:	76 16                	jbe    10056f <stab_binsearch+0xe2>
            *region_right = m - 1;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055f:	8b 45 10             	mov    0x10(%ebp),%eax
  100562:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100567:	83 e8 01             	sub    $0x1,%eax
  10056a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056d:	eb 12                	jmp    100581 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100572:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100575:	89 10                	mov    %edx,(%eax)
            l = m;
  100577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057d:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100581:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100584:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100587:	0f 8e 22 ff ff ff    	jle    1004af <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10058d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100591:	75 0f                	jne    1005a2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100593:	8b 45 0c             	mov    0xc(%ebp),%eax
  100596:	8b 00                	mov    (%eax),%eax
  100598:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059b:	8b 45 10             	mov    0x10(%ebp),%eax
  10059e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005a0:	eb 3f                	jmp    1005e1 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a5:	8b 00                	mov    (%eax),%eax
  1005a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005aa:	eb 04                	jmp    1005b0 <stab_binsearch+0x123>
  1005ac:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b3:	8b 00                	mov    (%eax),%eax
  1005b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005b8:	7d 1f                	jge    1005d9 <stab_binsearch+0x14c>
  1005ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	01 c0                	add    %eax,%eax
  1005c1:	01 d0                	add    %edx,%eax
  1005c3:	c1 e0 02             	shl    $0x2,%eax
  1005c6:	89 c2                	mov    %eax,%edx
  1005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cb:	01 d0                	add    %edx,%eax
  1005cd:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d1:	0f b6 c0             	movzbl %al,%eax
  1005d4:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005d7:	75 d3                	jne    1005ac <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005df:	89 10                	mov    %edx,(%eax)
    }
}
  1005e1:	90                   	nop
  1005e2:	c9                   	leave  
  1005e3:	c3                   	ret    

001005e4 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e4:	55                   	push   %ebp
  1005e5:	89 e5                	mov    %esp,%ebp
  1005e7:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ed:	c7 00 e8 36 10 00    	movl   $0x1036e8,(%eax)
    info->eip_line = 0;
  1005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100600:	c7 40 08 e8 36 10 00 	movl   $0x1036e8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060a:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100611:	8b 45 0c             	mov    0xc(%ebp),%eax
  100614:	8b 55 08             	mov    0x8(%ebp),%edx
  100617:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100624:	c7 45 f4 4c 3f 10 00 	movl   $0x103f4c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062b:	c7 45 f0 28 ba 10 00 	movl   $0x10ba28,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100632:	c7 45 ec 29 ba 10 00 	movl   $0x10ba29,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100639:	c7 45 e8 83 da 10 00 	movl   $0x10da83,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100643:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100646:	76 0d                	jbe    100655 <debuginfo_eip+0x71>
  100648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064b:	83 e8 01             	sub    $0x1,%eax
  10064e:	0f b6 00             	movzbl (%eax),%eax
  100651:	84 c0                	test   %al,%al
  100653:	74 0a                	je     10065f <debuginfo_eip+0x7b>
        return -1;
  100655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10065a:	e9 91 02 00 00       	jmp    1008f0 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10065f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100666:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066c:	29 c2                	sub    %eax,%edx
  10066e:	89 d0                	mov    %edx,%eax
  100670:	c1 f8 02             	sar    $0x2,%eax
  100673:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100679:	83 e8 01             	sub    $0x1,%eax
  10067c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10067f:	ff 75 08             	pushl  0x8(%ebp)
  100682:	6a 64                	push   $0x64
  100684:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100687:	50                   	push   %eax
  100688:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068b:	50                   	push   %eax
  10068c:	ff 75 f4             	pushl  -0xc(%ebp)
  10068f:	e8 f9 fd ff ff       	call   10048d <stab_binsearch>
  100694:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069a:	85 c0                	test   %eax,%eax
  10069c:	75 0a                	jne    1006a8 <debuginfo_eip+0xc4>
        return -1;
  10069e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a3:	e9 48 02 00 00       	jmp    1008f0 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b4:	ff 75 08             	pushl  0x8(%ebp)
  1006b7:	6a 24                	push   $0x24
  1006b9:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bc:	50                   	push   %eax
  1006bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c0:	50                   	push   %eax
  1006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c4:	e8 c4 fd ff ff       	call   10048d <stab_binsearch>
  1006c9:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d2:	39 c2                	cmp    %eax,%edx
  1006d4:	7f 7c                	jg     100752 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d9:	89 c2                	mov    %eax,%edx
  1006db:	89 d0                	mov    %edx,%eax
  1006dd:	01 c0                	add    %eax,%eax
  1006df:	01 d0                	add    %edx,%eax
  1006e1:	c1 e0 02             	shl    $0x2,%eax
  1006e4:	89 c2                	mov    %eax,%edx
  1006e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e9:	01 d0                	add    %edx,%eax
  1006eb:	8b 00                	mov    (%eax),%eax
  1006ed:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f3:	29 d1                	sub    %edx,%ecx
  1006f5:	89 ca                	mov    %ecx,%edx
  1006f7:	39 d0                	cmp    %edx,%eax
  1006f9:	73 22                	jae    10071d <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006fe:	89 c2                	mov    %eax,%edx
  100700:	89 d0                	mov    %edx,%eax
  100702:	01 c0                	add    %eax,%eax
  100704:	01 d0                	add    %edx,%eax
  100706:	c1 e0 02             	shl    $0x2,%eax
  100709:	89 c2                	mov    %eax,%edx
  10070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070e:	01 d0                	add    %edx,%eax
  100710:	8b 10                	mov    (%eax),%edx
  100712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100715:	01 c2                	add    %eax,%edx
  100717:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10071d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100720:	89 c2                	mov    %eax,%edx
  100722:	89 d0                	mov    %edx,%eax
  100724:	01 c0                	add    %eax,%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	c1 e0 02             	shl    $0x2,%eax
  10072b:	89 c2                	mov    %eax,%edx
  10072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100730:	01 d0                	add    %edx,%eax
  100732:	8b 50 08             	mov    0x8(%eax),%edx
  100735:	8b 45 0c             	mov    0xc(%ebp),%eax
  100738:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073e:	8b 40 10             	mov    0x10(%eax),%eax
  100741:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100744:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100747:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10074a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10074d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100750:	eb 15                	jmp    100767 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100752:	8b 45 0c             	mov    0xc(%ebp),%eax
  100755:	8b 55 08             	mov    0x8(%ebp),%edx
  100758:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10075e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100764:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100767:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076a:	8b 40 08             	mov    0x8(%eax),%eax
  10076d:	83 ec 08             	sub    $0x8,%esp
  100770:	6a 3a                	push   $0x3a
  100772:	50                   	push   %eax
  100773:	e8 61 25 00 00       	call   102cd9 <strfind>
  100778:	83 c4 10             	add    $0x10,%esp
  10077b:	89 c2                	mov    %eax,%edx
  10077d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100780:	8b 40 08             	mov    0x8(%eax),%eax
  100783:	29 c2                	sub    %eax,%edx
  100785:	8b 45 0c             	mov    0xc(%ebp),%eax
  100788:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078b:	83 ec 0c             	sub    $0xc,%esp
  10078e:	ff 75 08             	pushl  0x8(%ebp)
  100791:	6a 44                	push   $0x44
  100793:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100796:	50                   	push   %eax
  100797:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10079a:	50                   	push   %eax
  10079b:	ff 75 f4             	pushl  -0xc(%ebp)
  10079e:	e8 ea fc ff ff       	call   10048d <stab_binsearch>
  1007a3:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ac:	39 c2                	cmp    %eax,%edx
  1007ae:	7f 24                	jg     1007d4 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	89 d0                	mov    %edx,%eax
  1007b7:	01 c0                	add    %eax,%eax
  1007b9:	01 d0                	add    %edx,%eax
  1007bb:	c1 e0 02             	shl    $0x2,%eax
  1007be:	89 c2                	mov    %eax,%edx
  1007c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c3:	01 d0                	add    %edx,%eax
  1007c5:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c9:	0f b7 d0             	movzwl %ax,%edx
  1007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cf:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d2:	eb 13                	jmp    1007e7 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d9:	e9 12 01 00 00       	jmp    1008f0 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	83 e8 01             	sub    $0x1,%eax
  1007e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ed:	39 c2                	cmp    %eax,%edx
  1007ef:	7c 56                	jl     100847 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f4:	89 c2                	mov    %eax,%edx
  1007f6:	89 d0                	mov    %edx,%eax
  1007f8:	01 c0                	add    %eax,%eax
  1007fa:	01 d0                	add    %edx,%eax
  1007fc:	c1 e0 02             	shl    $0x2,%eax
  1007ff:	89 c2                	mov    %eax,%edx
  100801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100804:	01 d0                	add    %edx,%eax
  100806:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080a:	3c 84                	cmp    $0x84,%al
  10080c:	74 39                	je     100847 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10080e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100811:	89 c2                	mov    %eax,%edx
  100813:	89 d0                	mov    %edx,%eax
  100815:	01 c0                	add    %eax,%eax
  100817:	01 d0                	add    %edx,%eax
  100819:	c1 e0 02             	shl    $0x2,%eax
  10081c:	89 c2                	mov    %eax,%edx
  10081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100821:	01 d0                	add    %edx,%eax
  100823:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100827:	3c 64                	cmp    $0x64,%al
  100829:	75 b3                	jne    1007de <debuginfo_eip+0x1fa>
  10082b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	89 d0                	mov    %edx,%eax
  100832:	01 c0                	add    %eax,%eax
  100834:	01 d0                	add    %edx,%eax
  100836:	c1 e0 02             	shl    $0x2,%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083e:	01 d0                	add    %edx,%eax
  100840:	8b 40 08             	mov    0x8(%eax),%eax
  100843:	85 c0                	test   %eax,%eax
  100845:	74 97                	je     1007de <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084d:	39 c2                	cmp    %eax,%edx
  10084f:	7c 46                	jl     100897 <debuginfo_eip+0x2b3>
  100851:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	89 d0                	mov    %edx,%eax
  100858:	01 c0                	add    %eax,%eax
  10085a:	01 d0                	add    %edx,%eax
  10085c:	c1 e0 02             	shl    $0x2,%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	8b 00                	mov    (%eax),%eax
  100868:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10086e:	29 d1                	sub    %edx,%ecx
  100870:	89 ca                	mov    %ecx,%edx
  100872:	39 d0                	cmp    %edx,%eax
  100874:	73 21                	jae    100897 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100879:	89 c2                	mov    %eax,%edx
  10087b:	89 d0                	mov    %edx,%eax
  10087d:	01 c0                	add    %eax,%eax
  10087f:	01 d0                	add    %edx,%eax
  100881:	c1 e0 02             	shl    $0x2,%eax
  100884:	89 c2                	mov    %eax,%edx
  100886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100889:	01 d0                	add    %edx,%eax
  10088b:	8b 10                	mov    (%eax),%edx
  10088d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100890:	01 c2                	add    %eax,%edx
  100892:	8b 45 0c             	mov    0xc(%ebp),%eax
  100895:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100897:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10089a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10089d:	39 c2                	cmp    %eax,%edx
  10089f:	7d 4a                	jge    1008eb <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a4:	83 c0 01             	add    $0x1,%eax
  1008a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008aa:	eb 18                	jmp    1008c4 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008af:	8b 40 14             	mov    0x14(%eax),%eax
  1008b2:	8d 50 01             	lea    0x1(%eax),%edx
  1008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b8:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008be:	83 c0 01             	add    $0x1,%eax
  1008c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008ca:	39 c2                	cmp    %eax,%edx
  1008cc:	7d 1d                	jge    1008eb <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d1:	89 c2                	mov    %eax,%edx
  1008d3:	89 d0                	mov    %edx,%eax
  1008d5:	01 c0                	add    %eax,%eax
  1008d7:	01 d0                	add    %edx,%eax
  1008d9:	c1 e0 02             	shl    $0x2,%eax
  1008dc:	89 c2                	mov    %eax,%edx
  1008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e1:	01 d0                	add    %edx,%eax
  1008e3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e7:	3c a0                	cmp    $0xa0,%al
  1008e9:	74 c1                	je     1008ac <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008f0:	c9                   	leave  
  1008f1:	c3                   	ret    

001008f2 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f2:	55                   	push   %ebp
  1008f3:	89 e5                	mov    %esp,%ebp
  1008f5:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f8:	83 ec 0c             	sub    $0xc,%esp
  1008fb:	68 f2 36 10 00       	push   $0x1036f2
  100900:	e8 63 f9 ff ff       	call   100268 <cprintf>
  100905:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100908:	83 ec 08             	sub    $0x8,%esp
  10090b:	68 00 00 10 00       	push   $0x100000
  100910:	68 0b 37 10 00       	push   $0x10370b
  100915:	e8 4e f9 ff ff       	call   100268 <cprintf>
  10091a:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10091d:	83 ec 08             	sub    $0x8,%esp
  100920:	68 fc 35 10 00       	push   $0x1035fc
  100925:	68 23 37 10 00       	push   $0x103723
  10092a:	e8 39 f9 ff ff       	call   100268 <cprintf>
  10092f:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100932:	83 ec 08             	sub    $0x8,%esp
  100935:	68 16 ea 10 00       	push   $0x10ea16
  10093a:	68 3b 37 10 00       	push   $0x10373b
  10093f:	e8 24 f9 ff ff       	call   100268 <cprintf>
  100944:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100947:	83 ec 08             	sub    $0x8,%esp
  10094a:	68 40 fd 10 00       	push   $0x10fd40
  10094f:	68 53 37 10 00       	push   $0x103753
  100954:	e8 0f f9 ff ff       	call   100268 <cprintf>
  100959:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10095c:	b8 40 fd 10 00       	mov    $0x10fd40,%eax
  100961:	05 ff 03 00 00       	add    $0x3ff,%eax
  100966:	ba 00 00 10 00       	mov    $0x100000,%edx
  10096b:	29 d0                	sub    %edx,%eax
  10096d:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100973:	85 c0                	test   %eax,%eax
  100975:	0f 48 c2             	cmovs  %edx,%eax
  100978:	c1 f8 0a             	sar    $0xa,%eax
  10097b:	83 ec 08             	sub    $0x8,%esp
  10097e:	50                   	push   %eax
  10097f:	68 6c 37 10 00       	push   $0x10376c
  100984:	e8 df f8 ff ff       	call   100268 <cprintf>
  100989:	83 c4 10             	add    $0x10,%esp
}
  10098c:	90                   	nop
  10098d:	c9                   	leave  
  10098e:	c3                   	ret    

0010098f <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100998:	83 ec 08             	sub    $0x8,%esp
  10099b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10099e:	50                   	push   %eax
  10099f:	ff 75 08             	pushl  0x8(%ebp)
  1009a2:	e8 3d fc ff ff       	call   1005e4 <debuginfo_eip>
  1009a7:	83 c4 10             	add    $0x10,%esp
  1009aa:	85 c0                	test   %eax,%eax
  1009ac:	74 15                	je     1009c3 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ae:	83 ec 08             	sub    $0x8,%esp
  1009b1:	ff 75 08             	pushl  0x8(%ebp)
  1009b4:	68 96 37 10 00       	push   $0x103796
  1009b9:	e8 aa f8 ff ff       	call   100268 <cprintf>
  1009be:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c1:	eb 65                	jmp    100a28 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009ca:	eb 1c                	jmp    1009e8 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	01 d0                	add    %edx,%eax
  1009d4:	0f b6 00             	movzbl (%eax),%eax
  1009d7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009e0:	01 ca                	add    %ecx,%edx
  1009e2:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009ee:	7f dc                	jg     1009cc <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009f0:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f9:	01 d0                	add    %edx,%eax
  1009fb:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a01:	8b 55 08             	mov    0x8(%ebp),%edx
  100a04:	89 d1                	mov    %edx,%ecx
  100a06:	29 c1                	sub    %eax,%ecx
  100a08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a0e:	83 ec 0c             	sub    $0xc,%esp
  100a11:	51                   	push   %ecx
  100a12:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a18:	51                   	push   %ecx
  100a19:	52                   	push   %edx
  100a1a:	50                   	push   %eax
  100a1b:	68 b2 37 10 00       	push   $0x1037b2
  100a20:	e8 43 f8 ff ff       	call   100268 <cprintf>
  100a25:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a28:	90                   	nop
  100a29:	c9                   	leave  
  100a2a:	c3                   	ret    

00100a2b <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2b:	55                   	push   %ebp
  100a2c:	89 e5                	mov    %esp,%ebp
  100a2e:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a31:	8b 45 04             	mov    0x4(%ebp),%eax
  100a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a3a:	c9                   	leave  
  100a3b:	c3                   	ret    

00100a3c <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a3c:	55                   	push   %ebp
  100a3d:	89 e5                	mov    %esp,%ebp
  100a3f:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a42:	89 e8                	mov    %ebp,%eax
  100a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
  100a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
  100a4d:	e8 d9 ff ff ff       	call   100a2b <read_eip>
  100a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
  100a55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a5c:	e9 87 00 00 00       	jmp    100ae8 <print_stackframe+0xac>
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
  100a61:	83 ec 04             	sub    $0x4,%esp
  100a64:	ff 75 f0             	pushl  -0x10(%ebp)
  100a67:	ff 75 f4             	pushl  -0xc(%ebp)
  100a6a:	68 c4 37 10 00       	push   $0x1037c4
  100a6f:	e8 f4 f7 ff ff       	call   100268 <cprintf>
  100a74:	83 c4 10             	add    $0x10,%esp
		for (int argi = 0; argi < 4; ++ argi) {
  100a77:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a7e:	eb 29                	jmp    100aa9 <print_stackframe+0x6d>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
  100a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8d:	01 d0                	add    %edx,%eax
  100a8f:	83 c0 08             	add    $0x8,%eax
  100a92:	8b 00                	mov    (%eax),%eax
  100a94:	83 ec 08             	sub    $0x8,%esp
  100a97:	50                   	push   %eax
  100a98:	68 e0 37 10 00       	push   $0x1037e0
  100a9d:	e8 c6 f7 ff ff       	call   100268 <cprintf>
  100aa2:	83 c4 10             	add    $0x10,%esp
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
		cprintf("ebp:0x%08x eip:0x%08x args:", current_ebp, current_eip);
		for (int argi = 0; argi < 4; ++ argi) {
  100aa5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aa9:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aad:	7e d1                	jle    100a80 <print_stackframe+0x44>
			cprintf("0x%08x ", *((uint32_t*) current_ebp + 2 + argi));
		}
		cprintf("\n");
  100aaf:	83 ec 0c             	sub    $0xc,%esp
  100ab2:	68 e8 37 10 00       	push   $0x1037e8
  100ab7:	e8 ac f7 ff ff       	call   100268 <cprintf>
  100abc:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(current_eip - 1);
  100abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac2:	83 e8 01             	sub    $0x1,%eax
  100ac5:	83 ec 0c             	sub    $0xc,%esp
  100ac8:	50                   	push   %eax
  100ac9:	e8 c1 fe ff ff       	call   10098f <print_debuginfo>
  100ace:	83 c4 10             	add    $0x10,%esp
		current_eip = *((uint32_t*)current_ebp + 1);
  100ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad4:	83 c0 04             	add    $0x4,%eax
  100ad7:	8b 00                	mov    (%eax),%eax
  100ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);
  100adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adf:	8b 00                	mov    (%eax),%eax
  100ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	for (int i = 0; i < STACKFRAME_DEPTH && current_ebp != 0; ++ i) {
  100ae4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ae8:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100aec:	7f 0a                	jg     100af8 <print_stackframe+0xbc>
  100aee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af2:	0f 85 69 ff ff ff    	jne    100a61 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(current_eip - 1);
		current_eip = *((uint32_t*)current_ebp + 1);
		current_ebp = *((uint32_t*)current_ebp);
	}
}
  100af8:	90                   	nop
  100af9:	c9                   	leave  
  100afa:	c3                   	ret    

00100afb <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100afb:	55                   	push   %ebp
  100afc:	89 e5                	mov    %esp,%ebp
  100afe:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b08:	eb 0c                	jmp    100b16 <parse+0x1b>
            *buf ++ = '\0';
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	8d 50 01             	lea    0x1(%eax),%edx
  100b10:	89 55 08             	mov    %edx,0x8(%ebp)
  100b13:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	0f b6 00             	movzbl (%eax),%eax
  100b1c:	84 c0                	test   %al,%al
  100b1e:	74 1e                	je     100b3e <parse+0x43>
  100b20:	8b 45 08             	mov    0x8(%ebp),%eax
  100b23:	0f b6 00             	movzbl (%eax),%eax
  100b26:	0f be c0             	movsbl %al,%eax
  100b29:	83 ec 08             	sub    $0x8,%esp
  100b2c:	50                   	push   %eax
  100b2d:	68 6c 38 10 00       	push   $0x10386c
  100b32:	e8 6f 21 00 00       	call   102ca6 <strchr>
  100b37:	83 c4 10             	add    $0x10,%esp
  100b3a:	85 c0                	test   %eax,%eax
  100b3c:	75 cc                	jne    100b0a <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b41:	0f b6 00             	movzbl (%eax),%eax
  100b44:	84 c0                	test   %al,%al
  100b46:	74 69                	je     100bb1 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b48:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b4c:	75 12                	jne    100b60 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b4e:	83 ec 08             	sub    $0x8,%esp
  100b51:	6a 10                	push   $0x10
  100b53:	68 71 38 10 00       	push   $0x103871
  100b58:	e8 0b f7 ff ff       	call   100268 <cprintf>
  100b5d:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b63:	8d 50 01             	lea    0x1(%eax),%edx
  100b66:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b73:	01 c2                	add    %eax,%edx
  100b75:	8b 45 08             	mov    0x8(%ebp),%eax
  100b78:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7a:	eb 04                	jmp    100b80 <parse+0x85>
            buf ++;
  100b7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	0f b6 00             	movzbl (%eax),%eax
  100b86:	84 c0                	test   %al,%al
  100b88:	0f 84 7a ff ff ff    	je     100b08 <parse+0xd>
  100b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b91:	0f b6 00             	movzbl (%eax),%eax
  100b94:	0f be c0             	movsbl %al,%eax
  100b97:	83 ec 08             	sub    $0x8,%esp
  100b9a:	50                   	push   %eax
  100b9b:	68 6c 38 10 00       	push   $0x10386c
  100ba0:	e8 01 21 00 00       	call   102ca6 <strchr>
  100ba5:	83 c4 10             	add    $0x10,%esp
  100ba8:	85 c0                	test   %eax,%eax
  100baa:	74 d0                	je     100b7c <parse+0x81>
            buf ++;
        }
    }
  100bac:	e9 57 ff ff ff       	jmp    100b08 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bb1:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bb5:	c9                   	leave  
  100bb6:	c3                   	ret    

00100bb7 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bb7:	55                   	push   %ebp
  100bb8:	89 e5                	mov    %esp,%ebp
  100bba:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bbd:	83 ec 08             	sub    $0x8,%esp
  100bc0:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc3:	50                   	push   %eax
  100bc4:	ff 75 08             	pushl  0x8(%ebp)
  100bc7:	e8 2f ff ff ff       	call   100afb <parse>
  100bcc:	83 c4 10             	add    $0x10,%esp
  100bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd6:	75 0a                	jne    100be2 <runcmd+0x2b>
        return 0;
  100bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  100bdd:	e9 83 00 00 00       	jmp    100c65 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100be9:	eb 59                	jmp    100c44 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100beb:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf1:	89 d0                	mov    %edx,%eax
  100bf3:	01 c0                	add    %eax,%eax
  100bf5:	01 d0                	add    %edx,%eax
  100bf7:	c1 e0 02             	shl    $0x2,%eax
  100bfa:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bff:	8b 00                	mov    (%eax),%eax
  100c01:	83 ec 08             	sub    $0x8,%esp
  100c04:	51                   	push   %ecx
  100c05:	50                   	push   %eax
  100c06:	e8 fb 1f 00 00       	call   102c06 <strcmp>
  100c0b:	83 c4 10             	add    $0x10,%esp
  100c0e:	85 c0                	test   %eax,%eax
  100c10:	75 2e                	jne    100c40 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c15:	89 d0                	mov    %edx,%eax
  100c17:	01 c0                	add    %eax,%eax
  100c19:	01 d0                	add    %edx,%eax
  100c1b:	c1 e0 02             	shl    $0x2,%eax
  100c1e:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c23:	8b 10                	mov    (%eax),%edx
  100c25:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c28:	83 c0 04             	add    $0x4,%eax
  100c2b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c2e:	83 e9 01             	sub    $0x1,%ecx
  100c31:	83 ec 04             	sub    $0x4,%esp
  100c34:	ff 75 0c             	pushl  0xc(%ebp)
  100c37:	50                   	push   %eax
  100c38:	51                   	push   %ecx
  100c39:	ff d2                	call   *%edx
  100c3b:	83 c4 10             	add    $0x10,%esp
  100c3e:	eb 25                	jmp    100c65 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c47:	83 f8 02             	cmp    $0x2,%eax
  100c4a:	76 9f                	jbe    100beb <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c4f:	83 ec 08             	sub    $0x8,%esp
  100c52:	50                   	push   %eax
  100c53:	68 8f 38 10 00       	push   $0x10388f
  100c58:	e8 0b f6 ff ff       	call   100268 <cprintf>
  100c5d:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c65:	c9                   	leave  
  100c66:	c3                   	ret    

00100c67 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c67:	55                   	push   %ebp
  100c68:	89 e5                	mov    %esp,%ebp
  100c6a:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c6d:	83 ec 0c             	sub    $0xc,%esp
  100c70:	68 a8 38 10 00       	push   $0x1038a8
  100c75:	e8 ee f5 ff ff       	call   100268 <cprintf>
  100c7a:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c7d:	83 ec 0c             	sub    $0xc,%esp
  100c80:	68 d0 38 10 00       	push   $0x1038d0
  100c85:	e8 de f5 ff ff       	call   100268 <cprintf>
  100c8a:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c91:	74 0e                	je     100ca1 <kmonitor+0x3a>
        print_trapframe(tf);
  100c93:	83 ec 0c             	sub    $0xc,%esp
  100c96:	ff 75 08             	pushl  0x8(%ebp)
  100c99:	e8 a7 0d 00 00       	call   101a45 <print_trapframe>
  100c9e:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ca1:	83 ec 0c             	sub    $0xc,%esp
  100ca4:	68 f5 38 10 00       	push   $0x1038f5
  100ca9:	e8 5e f6 ff ff       	call   10030c <readline>
  100cae:	83 c4 10             	add    $0x10,%esp
  100cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb8:	74 e7                	je     100ca1 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cba:	83 ec 08             	sub    $0x8,%esp
  100cbd:	ff 75 08             	pushl  0x8(%ebp)
  100cc0:	ff 75 f4             	pushl  -0xc(%ebp)
  100cc3:	e8 ef fe ff ff       	call   100bb7 <runcmd>
  100cc8:	83 c4 10             	add    $0x10,%esp
  100ccb:	85 c0                	test   %eax,%eax
  100ccd:	78 02                	js     100cd1 <kmonitor+0x6a>
                break;
            }
        }
    }
  100ccf:	eb d0                	jmp    100ca1 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cd1:	90                   	nop
            }
        }
    }
}
  100cd2:	90                   	nop
  100cd3:	c9                   	leave  
  100cd4:	c3                   	ret    

00100cd5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd5:	55                   	push   %ebp
  100cd6:	89 e5                	mov    %esp,%ebp
  100cd8:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce2:	eb 3c                	jmp    100d20 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce7:	89 d0                	mov    %edx,%eax
  100ce9:	01 c0                	add    %eax,%eax
  100ceb:	01 d0                	add    %edx,%eax
  100ced:	c1 e0 02             	shl    $0x2,%eax
  100cf0:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cf5:	8b 08                	mov    (%eax),%ecx
  100cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfa:	89 d0                	mov    %edx,%eax
  100cfc:	01 c0                	add    %eax,%eax
  100cfe:	01 d0                	add    %edx,%eax
  100d00:	c1 e0 02             	shl    $0x2,%eax
  100d03:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d08:	8b 00                	mov    (%eax),%eax
  100d0a:	83 ec 04             	sub    $0x4,%esp
  100d0d:	51                   	push   %ecx
  100d0e:	50                   	push   %eax
  100d0f:	68 f9 38 10 00       	push   $0x1038f9
  100d14:	e8 4f f5 ff ff       	call   100268 <cprintf>
  100d19:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d23:	83 f8 02             	cmp    $0x2,%eax
  100d26:	76 bc                	jbe    100ce4 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2d:	c9                   	leave  
  100d2e:	c3                   	ret    

00100d2f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d2f:	55                   	push   %ebp
  100d30:	89 e5                	mov    %esp,%ebp
  100d32:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d35:	e8 b8 fb ff ff       	call   1008f2 <print_kerninfo>
    return 0;
  100d3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3f:	c9                   	leave  
  100d40:	c3                   	ret    

00100d41 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d41:	55                   	push   %ebp
  100d42:	89 e5                	mov    %esp,%ebp
  100d44:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d47:	e8 f0 fc ff ff       	call   100a3c <print_stackframe>
    return 0;
  100d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d51:	c9                   	leave  
  100d52:	c3                   	ret    

00100d53 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d53:	55                   	push   %ebp
  100d54:	89 e5                	mov    %esp,%ebp
  100d56:	83 ec 18             	sub    $0x18,%esp
  100d59:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d5f:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d63:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d67:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d6b:	ee                   	out    %al,(%dx)
  100d6c:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d72:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d76:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d7a:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d7e:	ee                   	out    %al,(%dx)
  100d7f:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d85:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d89:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d91:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d92:	c7 05 28 f9 10 00 00 	movl   $0x0,0x10f928
  100d99:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9c:	83 ec 0c             	sub    $0xc,%esp
  100d9f:	68 02 39 10 00       	push   $0x103902
  100da4:	e8 bf f4 ff ff       	call   100268 <cprintf>
  100da9:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100dac:	83 ec 0c             	sub    $0xc,%esp
  100daf:	6a 00                	push   $0x0
  100db1:	e8 ce 08 00 00       	call   101684 <pic_enable>
  100db6:	83 c4 10             	add    $0x10,%esp
}
  100db9:	90                   	nop
  100dba:	c9                   	leave  
  100dbb:	c3                   	ret    

00100dbc <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dbc:	55                   	push   %ebp
  100dbd:	89 e5                	mov    %esp,%ebp
  100dbf:	83 ec 10             	sub    $0x10,%esp
  100dc2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dcc:	89 c2                	mov    %eax,%edx
  100dce:	ec                   	in     (%dx),%al
  100dcf:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dd2:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dd8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100ddc:	89 c2                	mov    %eax,%edx
  100dde:	ec                   	in     (%dx),%al
  100ddf:	88 45 f5             	mov    %al,-0xb(%ebp)
  100de2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dec:	89 c2                	mov    %eax,%edx
  100dee:	ec                   	in     (%dx),%al
  100def:	88 45 f6             	mov    %al,-0xa(%ebp)
  100df2:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100df8:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e02:	90                   	nop
  100e03:	c9                   	leave  
  100e04:	c3                   	ret    

00100e05 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e05:	55                   	push   %ebp
  100e06:	89 e5                	mov    %esp,%ebp
  100e08:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e0b:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e15:	0f b7 00             	movzwl (%eax),%eax
  100e18:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e27:	0f b7 00             	movzwl (%eax),%eax
  100e2a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e2e:	74 12                	je     100e42 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e30:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e37:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3e:	b4 03 
  100e40:	eb 13                	jmp    100e55 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e45:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e49:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e4c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e53:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e55:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5c:	0f b7 c0             	movzwl %ax,%eax
  100e5f:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e63:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e67:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e6b:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e6f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e70:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e77:	83 c0 01             	add    $0x1,%eax
  100e7a:	0f b7 c0             	movzwl %ax,%eax
  100e7d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e81:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e85:	89 c2                	mov    %eax,%edx
  100e87:	ec                   	in     (%dx),%al
  100e88:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e8b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e8f:	0f b6 c0             	movzbl %al,%eax
  100e92:	c1 e0 08             	shl    $0x8,%eax
  100e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e98:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9f:	0f b7 c0             	movzwl %ax,%eax
  100ea2:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ea6:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eaa:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100eae:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100eb2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eb3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eba:	83 c0 01             	add    $0x1,%eax
  100ebd:	0f b7 c0             	movzwl %ax,%eax
  100ec0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ec8:	89 c2                	mov    %eax,%edx
  100eca:	ec                   	in     (%dx),%al
  100ecb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ece:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed2:	0f b6 c0             	movzbl %al,%eax
  100ed5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100edb:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee9:	90                   	nop
  100eea:	c9                   	leave  
  100eeb:	c3                   	ret    

00100eec <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100eec:	55                   	push   %ebp
  100eed:	89 e5                	mov    %esp,%ebp
  100eef:	83 ec 28             	sub    $0x28,%esp
  100ef2:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ef8:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100efc:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f00:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f04:	ee                   	out    %al,(%dx)
  100f05:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f0b:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f0f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f13:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
  100f18:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f1e:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f22:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f26:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f2a:	ee                   	out    %al,(%dx)
  100f2b:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f31:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f35:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f39:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f3d:	ee                   	out    %al,(%dx)
  100f3e:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f44:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f48:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f4c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f50:	ee                   	out    %al,(%dx)
  100f51:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f57:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f5b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f5f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f63:	ee                   	out    %al,(%dx)
  100f64:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f6a:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f6e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f72:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f76:	ee                   	out    %al,(%dx)
  100f77:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7d:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f81:	89 c2                	mov    %eax,%edx
  100f83:	ec                   	in     (%dx),%al
  100f84:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f87:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f8b:	3c ff                	cmp    $0xff,%al
  100f8d:	0f 95 c0             	setne  %al
  100f90:	0f b6 c0             	movzbl %al,%eax
  100f93:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f98:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fa2:	89 c2                	mov    %eax,%edx
  100fa4:	ec                   	in     (%dx),%al
  100fa5:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100fa8:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100fae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fb2:	89 c2                	mov    %eax,%edx
  100fb4:	ec                   	in     (%dx),%al
  100fb5:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb8:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fbd:	85 c0                	test   %eax,%eax
  100fbf:	74 0d                	je     100fce <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fc1:	83 ec 0c             	sub    $0xc,%esp
  100fc4:	6a 04                	push   $0x4
  100fc6:	e8 b9 06 00 00       	call   101684 <pic_enable>
  100fcb:	83 c4 10             	add    $0x10,%esp
    }
}
  100fce:	90                   	nop
  100fcf:	c9                   	leave  
  100fd0:	c3                   	ret    

00100fd1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fd1:	55                   	push   %ebp
  100fd2:	89 e5                	mov    %esp,%ebp
  100fd4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fde:	eb 09                	jmp    100fe9 <lpt_putc_sub+0x18>
        delay();
  100fe0:	e8 d7 fd ff ff       	call   100dbc <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe9:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fef:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100ff3:	89 c2                	mov    %eax,%edx
  100ff5:	ec                   	in     (%dx),%al
  100ff6:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100ff9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100ffd:	84 c0                	test   %al,%al
  100fff:	78 09                	js     10100a <lpt_putc_sub+0x39>
  101001:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101008:	7e d6                	jle    100fe0 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10100a:	8b 45 08             	mov    0x8(%ebp),%eax
  10100d:	0f b6 c0             	movzbl %al,%eax
  101010:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101016:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101019:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10101d:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101021:	ee                   	out    %al,(%dx)
  101022:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101028:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10102c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101030:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
  101035:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10103b:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10103f:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101043:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101047:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101048:	90                   	nop
  101049:	c9                   	leave  
  10104a:	c3                   	ret    

0010104b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10104b:	55                   	push   %ebp
  10104c:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10104e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101052:	74 0d                	je     101061 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101054:	ff 75 08             	pushl  0x8(%ebp)
  101057:	e8 75 ff ff ff       	call   100fd1 <lpt_putc_sub>
  10105c:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10105f:	eb 1e                	jmp    10107f <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101061:	6a 08                	push   $0x8
  101063:	e8 69 ff ff ff       	call   100fd1 <lpt_putc_sub>
  101068:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10106b:	6a 20                	push   $0x20
  10106d:	e8 5f ff ff ff       	call   100fd1 <lpt_putc_sub>
  101072:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101075:	6a 08                	push   $0x8
  101077:	e8 55 ff ff ff       	call   100fd1 <lpt_putc_sub>
  10107c:	83 c4 04             	add    $0x4,%esp
    }
}
  10107f:	90                   	nop
  101080:	c9                   	leave  
  101081:	c3                   	ret    

00101082 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	53                   	push   %ebx
  101086:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	b0 00                	mov    $0x0,%al
  10108e:	85 c0                	test   %eax,%eax
  101090:	75 07                	jne    101099 <cga_putc+0x17>
        c |= 0x0700;
  101092:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	0f b6 c0             	movzbl %al,%eax
  10109f:	83 f8 0a             	cmp    $0xa,%eax
  1010a2:	74 4e                	je     1010f2 <cga_putc+0x70>
  1010a4:	83 f8 0d             	cmp    $0xd,%eax
  1010a7:	74 59                	je     101102 <cga_putc+0x80>
  1010a9:	83 f8 08             	cmp    $0x8,%eax
  1010ac:	0f 85 8a 00 00 00    	jne    10113c <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010b2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b9:	66 85 c0             	test   %ax,%ax
  1010bc:	0f 84 a0 00 00 00    	je     101162 <cga_putc+0xe0>
            crt_pos --;
  1010c2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c9:	83 e8 01             	sub    $0x1,%eax
  1010cc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d2:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010d7:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010de:	0f b7 d2             	movzwl %dx,%edx
  1010e1:	01 d2                	add    %edx,%edx
  1010e3:	01 d0                	add    %edx,%eax
  1010e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1010e8:	b2 00                	mov    $0x0,%dl
  1010ea:	83 ca 20             	or     $0x20,%edx
  1010ed:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010f0:	eb 70                	jmp    101162 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010f2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f9:	83 c0 50             	add    $0x50,%eax
  1010fc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101102:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101109:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101110:	0f b7 c1             	movzwl %cx,%eax
  101113:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101119:	c1 e8 10             	shr    $0x10,%eax
  10111c:	89 c2                	mov    %eax,%edx
  10111e:	66 c1 ea 06          	shr    $0x6,%dx
  101122:	89 d0                	mov    %edx,%eax
  101124:	c1 e0 02             	shl    $0x2,%eax
  101127:	01 d0                	add    %edx,%eax
  101129:	c1 e0 04             	shl    $0x4,%eax
  10112c:	29 c1                	sub    %eax,%ecx
  10112e:	89 ca                	mov    %ecx,%edx
  101130:	89 d8                	mov    %ebx,%eax
  101132:	29 d0                	sub    %edx,%eax
  101134:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10113a:	eb 27                	jmp    101163 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10113c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101142:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101149:	8d 50 01             	lea    0x1(%eax),%edx
  10114c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101153:	0f b7 c0             	movzwl %ax,%eax
  101156:	01 c0                	add    %eax,%eax
  101158:	01 c8                	add    %ecx,%eax
  10115a:	8b 55 08             	mov    0x8(%ebp),%edx
  10115d:	66 89 10             	mov    %dx,(%eax)
        break;
  101160:	eb 01                	jmp    101163 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101162:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101163:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10116e:	76 59                	jbe    1011c9 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101170:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101175:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10117b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101180:	83 ec 04             	sub    $0x4,%esp
  101183:	68 00 0f 00 00       	push   $0xf00
  101188:	52                   	push   %edx
  101189:	50                   	push   %eax
  10118a:	e8 16 1d 00 00       	call   102ea5 <memmove>
  10118f:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101192:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101199:	eb 15                	jmp    1011b0 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  10119b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a3:	01 d2                	add    %edx,%edx
  1011a5:	01 d0                	add    %edx,%eax
  1011a7:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b7:	7e e2                	jle    10119b <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011b9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c0:	83 e8 50             	sub    $0x50,%eax
  1011c3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c9:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d0:	0f b7 c0             	movzwl %ax,%eax
  1011d3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d7:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011db:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011df:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011e3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011eb:	66 c1 e8 08          	shr    $0x8,%ax
  1011ef:	0f b6 c0             	movzbl %al,%eax
  1011f2:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f9:	83 c2 01             	add    $0x1,%edx
  1011fc:	0f b7 d2             	movzwl %dx,%edx
  1011ff:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101203:	88 45 e9             	mov    %al,-0x17(%ebp)
  101206:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10120a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10120e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10120f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101216:	0f b7 c0             	movzwl %ax,%eax
  101219:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10121d:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101221:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101225:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101229:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10122a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101231:	0f b6 c0             	movzbl %al,%eax
  101234:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123b:	83 c2 01             	add    $0x1,%edx
  10123e:	0f b7 d2             	movzwl %dx,%edx
  101241:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101245:	88 45 eb             	mov    %al,-0x15(%ebp)
  101248:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10124c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101250:	ee                   	out    %al,(%dx)
}
  101251:	90                   	nop
  101252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101255:	c9                   	leave  
  101256:	c3                   	ret    

00101257 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101257:	55                   	push   %ebp
  101258:	89 e5                	mov    %esp,%ebp
  10125a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101264:	eb 09                	jmp    10126f <serial_putc_sub+0x18>
        delay();
  101266:	e8 51 fb ff ff       	call   100dbc <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10126f:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101275:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101279:	89 c2                	mov    %eax,%edx
  10127b:	ec                   	in     (%dx),%al
  10127c:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10127f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101283:	0f b6 c0             	movzbl %al,%eax
  101286:	83 e0 20             	and    $0x20,%eax
  101289:	85 c0                	test   %eax,%eax
  10128b:	75 09                	jne    101296 <serial_putc_sub+0x3f>
  10128d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101294:	7e d0                	jle    101266 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101296:	8b 45 08             	mov    0x8(%ebp),%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012a2:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012a9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012ad:	ee                   	out    %al,(%dx)
}
  1012ae:	90                   	nop
  1012af:	c9                   	leave  
  1012b0:	c3                   	ret    

001012b1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012b1:	55                   	push   %ebp
  1012b2:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012b4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b8:	74 0d                	je     1012c7 <serial_putc+0x16>
        serial_putc_sub(c);
  1012ba:	ff 75 08             	pushl  0x8(%ebp)
  1012bd:	e8 95 ff ff ff       	call   101257 <serial_putc_sub>
  1012c2:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012c5:	eb 1e                	jmp    1012e5 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012c7:	6a 08                	push   $0x8
  1012c9:	e8 89 ff ff ff       	call   101257 <serial_putc_sub>
  1012ce:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012d1:	6a 20                	push   $0x20
  1012d3:	e8 7f ff ff ff       	call   101257 <serial_putc_sub>
  1012d8:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012db:	6a 08                	push   $0x8
  1012dd:	e8 75 ff ff ff       	call   101257 <serial_putc_sub>
  1012e2:	83 c4 04             	add    $0x4,%esp
    }
}
  1012e5:	90                   	nop
  1012e6:	c9                   	leave  
  1012e7:	c3                   	ret    

001012e8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012e8:	55                   	push   %ebp
  1012e9:	89 e5                	mov    %esp,%ebp
  1012eb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012ee:	eb 33                	jmp    101323 <cons_intr+0x3b>
        if (c != 0) {
  1012f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f4:	74 2d                	je     101323 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f6:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012fb:	8d 50 01             	lea    0x1(%eax),%edx
  1012fe:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101307:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10130d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101312:	3d 00 02 00 00       	cmp    $0x200,%eax
  101317:	75 0a                	jne    101323 <cons_intr+0x3b>
                cons.wpos = 0;
  101319:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101320:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101323:	8b 45 08             	mov    0x8(%ebp),%eax
  101326:	ff d0                	call   *%eax
  101328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10132b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10132f:	75 bf                	jne    1012f0 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101331:	90                   	nop
  101332:	c9                   	leave  
  101333:	c3                   	ret    

00101334 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101334:	55                   	push   %ebp
  101335:	89 e5                	mov    %esp,%ebp
  101337:	83 ec 10             	sub    $0x10,%esp
  10133a:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101340:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101344:	89 c2                	mov    %eax,%edx
  101346:	ec                   	in     (%dx),%al
  101347:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10134a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10134e:	0f b6 c0             	movzbl %al,%eax
  101351:	83 e0 01             	and    $0x1,%eax
  101354:	85 c0                	test   %eax,%eax
  101356:	75 07                	jne    10135f <serial_proc_data+0x2b>
        return -1;
  101358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10135d:	eb 2a                	jmp    101389 <serial_proc_data+0x55>
  10135f:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101365:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101369:	89 c2                	mov    %eax,%edx
  10136b:	ec                   	in     (%dx),%al
  10136c:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10136f:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101373:	0f b6 c0             	movzbl %al,%eax
  101376:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101379:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10137d:	75 07                	jne    101386 <serial_proc_data+0x52>
        c = '\b';
  10137f:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101386:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101389:	c9                   	leave  
  10138a:	c3                   	ret    

0010138b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10138b:	55                   	push   %ebp
  10138c:	89 e5                	mov    %esp,%ebp
  10138e:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101391:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101396:	85 c0                	test   %eax,%eax
  101398:	74 10                	je     1013aa <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10139a:	83 ec 0c             	sub    $0xc,%esp
  10139d:	68 34 13 10 00       	push   $0x101334
  1013a2:	e8 41 ff ff ff       	call   1012e8 <cons_intr>
  1013a7:	83 c4 10             	add    $0x10,%esp
    }
}
  1013aa:	90                   	nop
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 18             	sub    $0x18,%esp
  1013b3:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013bd:	89 c2                	mov    %eax,%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013c3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	83 e0 01             	and    $0x1,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	75 0a                	jne    1013db <kbd_proc_data+0x2e>
        return -1;
  1013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d6:	e9 5d 01 00 00       	jmp    101538 <kbd_proc_data+0x18b>
  1013db:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013e5:	89 c2                	mov    %eax,%edx
  1013e7:	ec                   	in     (%dx),%al
  1013e8:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013eb:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ef:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f2:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f6:	75 17                	jne    10140f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013f8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013fd:	83 c8 40             	or     $0x40,%eax
  101400:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101405:	b8 00 00 00 00       	mov    $0x0,%eax
  10140a:	e9 29 01 00 00       	jmp    101538 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10140f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101413:	84 c0                	test   %al,%al
  101415:	79 47                	jns    10145e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101417:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141c:	83 e0 40             	and    $0x40,%eax
  10141f:	85 c0                	test   %eax,%eax
  101421:	75 09                	jne    10142c <kbd_proc_data+0x7f>
  101423:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101427:	83 e0 7f             	and    $0x7f,%eax
  10142a:	eb 04                	jmp    101430 <kbd_proc_data+0x83>
  10142c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101430:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101433:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101437:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143e:	83 c8 40             	or     $0x40,%eax
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	f7 d0                	not    %eax
  101446:	89 c2                	mov    %eax,%edx
  101448:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144d:	21 d0                	and    %edx,%eax
  10144f:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101454:	b8 00 00 00 00       	mov    $0x0,%eax
  101459:	e9 da 00 00 00       	jmp    101538 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10145e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101463:	83 e0 40             	and    $0x40,%eax
  101466:	85 c0                	test   %eax,%eax
  101468:	74 11                	je     10147b <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10146a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101473:	83 e0 bf             	and    $0xffffffbf,%eax
  101476:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101486:	0f b6 d0             	movzbl %al,%edx
  101489:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148e:	09 d0                	or     %edx,%eax
  101490:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a0:	0f b6 d0             	movzbl %al,%edx
  1014a3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a8:	31 d0                	xor    %edx,%eax
  1014aa:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014af:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b4:	83 e0 03             	and    $0x3,%eax
  1014b7:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c2:	01 d0                	add    %edx,%eax
  1014c4:	0f b6 00             	movzbl (%eax),%eax
  1014c7:	0f b6 c0             	movzbl %al,%eax
  1014ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d2:	83 e0 08             	and    $0x8,%eax
  1014d5:	85 c0                	test   %eax,%eax
  1014d7:	74 22                	je     1014fb <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014d9:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014dd:	7e 0c                	jle    1014eb <kbd_proc_data+0x13e>
  1014df:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e3:	7f 06                	jg     1014eb <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e5:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e9:	eb 10                	jmp    1014fb <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014eb:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ef:	7e 0a                	jle    1014fb <kbd_proc_data+0x14e>
  1014f1:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f5:	7f 04                	jg     1014fb <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f7:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014fb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101500:	f7 d0                	not    %eax
  101502:	83 e0 06             	and    $0x6,%eax
  101505:	85 c0                	test   %eax,%eax
  101507:	75 2c                	jne    101535 <kbd_proc_data+0x188>
  101509:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101510:	75 23                	jne    101535 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101512:	83 ec 0c             	sub    $0xc,%esp
  101515:	68 1d 39 10 00       	push   $0x10391d
  10151a:	e8 49 ed ff ff       	call   100268 <cprintf>
  10151f:	83 c4 10             	add    $0x10,%esp
  101522:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101528:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101530:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101534:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101535:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101538:	c9                   	leave  
  101539:	c3                   	ret    

0010153a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10153a:	55                   	push   %ebp
  10153b:	89 e5                	mov    %esp,%ebp
  10153d:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101540:	83 ec 0c             	sub    $0xc,%esp
  101543:	68 ad 13 10 00       	push   $0x1013ad
  101548:	e8 9b fd ff ff       	call   1012e8 <cons_intr>
  10154d:	83 c4 10             	add    $0x10,%esp
}
  101550:	90                   	nop
  101551:	c9                   	leave  
  101552:	c3                   	ret    

00101553 <kbd_init>:

static void
kbd_init(void) {
  101553:	55                   	push   %ebp
  101554:	89 e5                	mov    %esp,%ebp
  101556:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101559:	e8 dc ff ff ff       	call   10153a <kbd_intr>
    pic_enable(IRQ_KBD);
  10155e:	83 ec 0c             	sub    $0xc,%esp
  101561:	6a 01                	push   $0x1
  101563:	e8 1c 01 00 00       	call   101684 <pic_enable>
  101568:	83 c4 10             	add    $0x10,%esp
}
  10156b:	90                   	nop
  10156c:	c9                   	leave  
  10156d:	c3                   	ret    

0010156e <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10156e:	55                   	push   %ebp
  10156f:	89 e5                	mov    %esp,%ebp
  101571:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101574:	e8 8c f8 ff ff       	call   100e05 <cga_init>
    serial_init();
  101579:	e8 6e f9 ff ff       	call   100eec <serial_init>
    kbd_init();
  10157e:	e8 d0 ff ff ff       	call   101553 <kbd_init>
    if (!serial_exists) {
  101583:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101588:	85 c0                	test   %eax,%eax
  10158a:	75 10                	jne    10159c <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10158c:	83 ec 0c             	sub    $0xc,%esp
  10158f:	68 29 39 10 00       	push   $0x103929
  101594:	e8 cf ec ff ff       	call   100268 <cprintf>
  101599:	83 c4 10             	add    $0x10,%esp
    }
}
  10159c:	90                   	nop
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1015a5:	ff 75 08             	pushl  0x8(%ebp)
  1015a8:	e8 9e fa ff ff       	call   10104b <lpt_putc>
  1015ad:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015b0:	83 ec 0c             	sub    $0xc,%esp
  1015b3:	ff 75 08             	pushl  0x8(%ebp)
  1015b6:	e8 c7 fa ff ff       	call   101082 <cga_putc>
  1015bb:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015be:	83 ec 0c             	sub    $0xc,%esp
  1015c1:	ff 75 08             	pushl  0x8(%ebp)
  1015c4:	e8 e8 fc ff ff       	call   1012b1 <serial_putc>
  1015c9:	83 c4 10             	add    $0x10,%esp
}
  1015cc:	90                   	nop
  1015cd:	c9                   	leave  
  1015ce:	c3                   	ret    

001015cf <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cf:	55                   	push   %ebp
  1015d0:	89 e5                	mov    %esp,%ebp
  1015d2:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d5:	e8 b1 fd ff ff       	call   10138b <serial_intr>
    kbd_intr();
  1015da:	e8 5b ff ff ff       	call   10153a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015df:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ea:	39 c2                	cmp    %eax,%edx
  1015ec:	74 36                	je     101624 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015ee:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f3:	8d 50 01             	lea    0x1(%eax),%edx
  1015f6:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015fc:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101603:	0f b6 c0             	movzbl %al,%eax
  101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101609:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101613:	75 0a                	jne    10161f <cons_getc+0x50>
            cons.rpos = 0;
  101615:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10161c:	00 00 00 
        }
        return c;
  10161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101622:	eb 05                	jmp    101629 <cons_getc+0x5a>
    }
    return 0;
  101624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101629:	c9                   	leave  
  10162a:	c3                   	ret    

0010162b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10162b:	55                   	push   %ebp
  10162c:	89 e5                	mov    %esp,%ebp
  10162e:	83 ec 14             	sub    $0x14,%esp
  101631:	8b 45 08             	mov    0x8(%ebp),%eax
  101634:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101638:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163c:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101642:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101647:	85 c0                	test   %eax,%eax
  101649:	74 36                	je     101681 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10164b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164f:	0f b6 c0             	movzbl %al,%eax
  101652:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101658:	88 45 fa             	mov    %al,-0x6(%ebp)
  10165b:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10165f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101663:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101664:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101668:	66 c1 e8 08          	shr    $0x8,%ax
  10166c:	0f b6 c0             	movzbl %al,%eax
  10166f:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101675:	88 45 fb             	mov    %al,-0x5(%ebp)
  101678:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10167c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101680:	ee                   	out    %al,(%dx)
    }
}
  101681:	90                   	nop
  101682:	c9                   	leave  
  101683:	c3                   	ret    

00101684 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101684:	55                   	push   %ebp
  101685:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101687:	8b 45 08             	mov    0x8(%ebp),%eax
  10168a:	ba 01 00 00 00       	mov    $0x1,%edx
  10168f:	89 c1                	mov    %eax,%ecx
  101691:	d3 e2                	shl    %cl,%edx
  101693:	89 d0                	mov    %edx,%eax
  101695:	f7 d0                	not    %eax
  101697:	89 c2                	mov    %eax,%edx
  101699:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a0:	21 d0                	and    %edx,%eax
  1016a2:	0f b7 c0             	movzwl %ax,%eax
  1016a5:	50                   	push   %eax
  1016a6:	e8 80 ff ff ff       	call   10162b <pic_setmask>
  1016ab:	83 c4 04             	add    $0x4,%esp
}
  1016ae:	90                   	nop
  1016af:	c9                   	leave  
  1016b0:	c3                   	ret    

001016b1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b1:	55                   	push   %ebp
  1016b2:	89 e5                	mov    %esp,%ebp
  1016b4:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016b7:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016be:	00 00 00 
  1016c1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c7:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016cb:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016cf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016da:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016de:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016e2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
  1016e7:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016ed:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016f1:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016f5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f9:	ee                   	out    %al,(%dx)
  1016fa:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  101700:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101704:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101708:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10170c:	ee                   	out    %al,(%dx)
  10170d:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101713:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101717:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10171b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
  101720:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101726:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10172a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10172e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
  101733:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101739:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10173d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101741:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10174c:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  101750:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101754:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10175f:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101763:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101767:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101772:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101776:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10177a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101785:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101789:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10178d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101798:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10179c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017a0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017ab:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1017af:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1017b3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
  1017b8:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017be:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017c2:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017c6:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017cb:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d2:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d6:	74 13                	je     1017eb <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017d8:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017df:	0f b7 c0             	movzwl %ax,%eax
  1017e2:	50                   	push   %eax
  1017e3:	e8 43 fe ff ff       	call   10162b <pic_setmask>
  1017e8:	83 c4 04             	add    $0x4,%esp
    }
}
  1017eb:	90                   	nop
  1017ec:	c9                   	leave  
  1017ed:	c3                   	ret    

001017ee <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017ee:	55                   	push   %ebp
  1017ef:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017f1:	fb                   	sti    
    sti();
}
  1017f2:	90                   	nop
  1017f3:	5d                   	pop    %ebp
  1017f4:	c3                   	ret    

001017f5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017f5:	55                   	push   %ebp
  1017f6:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f8:	fa                   	cli    
    cli();
}
  1017f9:	90                   	nop
  1017fa:	5d                   	pop    %ebp
  1017fb:	c3                   	ret    

001017fc <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fc:	55                   	push   %ebp
  1017fd:	89 e5                	mov    %esp,%ebp
  1017ff:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101802:	83 ec 08             	sub    $0x8,%esp
  101805:	6a 64                	push   $0x64
  101807:	68 60 39 10 00       	push   $0x103960
  10180c:	e8 57 ea ff ff       	call   100268 <cprintf>
  101811:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101814:	83 ec 0c             	sub    $0xc,%esp
  101817:	68 6a 39 10 00       	push   $0x10396a
  10181c:	e8 47 ea ff ff       	call   100268 <cprintf>
  101821:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101824:	83 ec 04             	sub    $0x4,%esp
  101827:	68 78 39 10 00       	push   $0x103978
  10182c:	6a 12                	push   $0x12
  10182e:	68 8e 39 10 00       	push   $0x10398e
  101833:	e8 96 eb ff ff       	call   1003ce <__panic>

00101838 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101838:	55                   	push   %ebp
  101839:	89 e5                	mov    %esp,%ebp
  10183b:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
  10183e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101845:	e9 97 01 00 00       	jmp    1019e1 <idt_init+0x1a9>
//		cprintf("vectors %d: 0x%08x\n", i, __vectors[i]);
		if (i == T_SYSCALL || i == T_SWITCH_TOK) {
  10184a:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  101851:	74 0a                	je     10185d <idt_init+0x25>
  101853:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  101857:	0f 85 c1 00 00 00    	jne    10191e <idt_init+0xe6>
			SETGATE(idt[i], 1, KERNEL_CS, __vectors[i], DPL_USER);
  10185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101860:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101867:	89 c2                	mov    %eax,%edx
  101869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186c:	66 89 14 c5 c0 f0 10 	mov    %dx,0x10f0c0(,%eax,8)
  101873:	00 
  101874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101877:	66 c7 04 c5 c2 f0 10 	movw   $0x8,0x10f0c2(,%eax,8)
  10187e:	00 08 00 
  101881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101884:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  10188b:	00 
  10188c:	83 e2 e0             	and    $0xffffffe0,%edx
  10188f:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101896:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101899:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  1018a0:	00 
  1018a1:	83 e2 1f             	and    $0x1f,%edx
  1018a4:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  1018ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ae:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018b5:	00 
  1018b6:	83 ca 0f             	or     $0xf,%edx
  1018b9:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c3:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018ca:	00 
  1018cb:	83 e2 ef             	and    $0xffffffef,%edx
  1018ce:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d8:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018df:	00 
  1018e0:	83 ca 60             	or     $0x60,%edx
  1018e3:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ed:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018f4:	00 
  1018f5:	83 ca 80             	or     $0xffffff80,%edx
  1018f8:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101902:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101909:	c1 e8 10             	shr    $0x10,%eax
  10190c:	89 c2                	mov    %eax,%edx
  10190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101911:	66 89 14 c5 c6 f0 10 	mov    %dx,0x10f0c6(,%eax,8)
  101918:	00 
  101919:	e9 bf 00 00 00       	jmp    1019dd <idt_init+0x1a5>
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
  10191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101921:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101928:	89 c2                	mov    %eax,%edx
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	66 89 14 c5 c0 f0 10 	mov    %dx,0x10f0c0(,%eax,8)
  101934:	00 
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	66 c7 04 c5 c2 f0 10 	movw   $0x8,0x10f0c2(,%eax,8)
  10193f:	00 08 00 
  101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101945:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  10194c:	00 
  10194d:	83 e2 e0             	and    $0xffffffe0,%edx
  101950:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195a:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  101961:	00 
  101962:	83 e2 1f             	and    $0x1f,%edx
  101965:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  101976:	00 
  101977:	83 e2 f0             	and    $0xfffffff0,%edx
  10197a:	83 ca 0e             	or     $0xe,%edx
  10197d:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  10198e:	00 
  10198f:	83 e2 ef             	and    $0xffffffef,%edx
  101992:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  101999:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199c:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1019a3:	00 
  1019a4:	83 e2 9f             	and    $0xffffff9f,%edx
  1019a7:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b1:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1019b8:	00 
  1019b9:	83 ca 80             	or     $0xffffff80,%edx
  1019bc:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c6:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019cd:	c1 e8 10             	shr    $0x10,%eax
  1019d0:	89 c2                	mov    %eax,%edx
  1019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d5:	66 89 14 c5 c6 f0 10 	mov    %dx,0x10f0c6(,%eax,8)
  1019dc:	00 
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	for (int i = 0; i < 256; ++ i) {
  1019dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019e1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019e8:	0f 8e 5c fe ff ff    	jle    10184a <idt_init+0x12>
  1019ee:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019f8:	0f 01 18             	lidtl  (%eax)
		} else {
			SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
		}
	}
	lidt(&idt_pd);
}
  1019fb:	90                   	nop
  1019fc:	c9                   	leave  
  1019fd:	c3                   	ret    

001019fe <trapname>:

static const char *
trapname(int trapno) {
  1019fe:	55                   	push   %ebp
  1019ff:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a01:	8b 45 08             	mov    0x8(%ebp),%eax
  101a04:	83 f8 13             	cmp    $0x13,%eax
  101a07:	77 0c                	ja     101a15 <trapname+0x17>
        return excnames[trapno];
  101a09:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0c:	8b 04 85 00 3d 10 00 	mov    0x103d00(,%eax,4),%eax
  101a13:	eb 18                	jmp    101a2d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a15:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a19:	7e 0d                	jle    101a28 <trapname+0x2a>
  101a1b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a1f:	7f 07                	jg     101a28 <trapname+0x2a>
        return "Hardware Interrupt";
  101a21:	b8 9f 39 10 00       	mov    $0x10399f,%eax
  101a26:	eb 05                	jmp    101a2d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a28:	b8 b2 39 10 00       	mov    $0x1039b2,%eax
}
  101a2d:	5d                   	pop    %ebp
  101a2e:	c3                   	ret    

00101a2f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a2f:	55                   	push   %ebp
  101a30:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a32:	8b 45 08             	mov    0x8(%ebp),%eax
  101a35:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a39:	66 83 f8 08          	cmp    $0x8,%ax
  101a3d:	0f 94 c0             	sete   %al
  101a40:	0f b6 c0             	movzbl %al,%eax
}
  101a43:	5d                   	pop    %ebp
  101a44:	c3                   	ret    

00101a45 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a45:	55                   	push   %ebp
  101a46:	89 e5                	mov    %esp,%ebp
  101a48:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a4b:	83 ec 08             	sub    $0x8,%esp
  101a4e:	ff 75 08             	pushl  0x8(%ebp)
  101a51:	68 f3 39 10 00       	push   $0x1039f3
  101a56:	e8 0d e8 ff ff       	call   100268 <cprintf>
  101a5b:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a61:	83 ec 0c             	sub    $0xc,%esp
  101a64:	50                   	push   %eax
  101a65:	e8 b8 01 00 00       	call   101c22 <print_regs>
  101a6a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a70:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a74:	0f b7 c0             	movzwl %ax,%eax
  101a77:	83 ec 08             	sub    $0x8,%esp
  101a7a:	50                   	push   %eax
  101a7b:	68 04 3a 10 00       	push   $0x103a04
  101a80:	e8 e3 e7 ff ff       	call   100268 <cprintf>
  101a85:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a88:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a8f:	0f b7 c0             	movzwl %ax,%eax
  101a92:	83 ec 08             	sub    $0x8,%esp
  101a95:	50                   	push   %eax
  101a96:	68 17 3a 10 00       	push   $0x103a17
  101a9b:	e8 c8 e7 ff ff       	call   100268 <cprintf>
  101aa0:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aaa:	0f b7 c0             	movzwl %ax,%eax
  101aad:	83 ec 08             	sub    $0x8,%esp
  101ab0:	50                   	push   %eax
  101ab1:	68 2a 3a 10 00       	push   $0x103a2a
  101ab6:	e8 ad e7 ff ff       	call   100268 <cprintf>
  101abb:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101abe:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac5:	0f b7 c0             	movzwl %ax,%eax
  101ac8:	83 ec 08             	sub    $0x8,%esp
  101acb:	50                   	push   %eax
  101acc:	68 3d 3a 10 00       	push   $0x103a3d
  101ad1:	e8 92 e7 ff ff       	call   100268 <cprintf>
  101ad6:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	8b 40 30             	mov    0x30(%eax),%eax
  101adf:	83 ec 0c             	sub    $0xc,%esp
  101ae2:	50                   	push   %eax
  101ae3:	e8 16 ff ff ff       	call   1019fe <trapname>
  101ae8:	83 c4 10             	add    $0x10,%esp
  101aeb:	89 c2                	mov    %eax,%edx
  101aed:	8b 45 08             	mov    0x8(%ebp),%eax
  101af0:	8b 40 30             	mov    0x30(%eax),%eax
  101af3:	83 ec 04             	sub    $0x4,%esp
  101af6:	52                   	push   %edx
  101af7:	50                   	push   %eax
  101af8:	68 50 3a 10 00       	push   $0x103a50
  101afd:	e8 66 e7 ff ff       	call   100268 <cprintf>
  101b02:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b05:	8b 45 08             	mov    0x8(%ebp),%eax
  101b08:	8b 40 34             	mov    0x34(%eax),%eax
  101b0b:	83 ec 08             	sub    $0x8,%esp
  101b0e:	50                   	push   %eax
  101b0f:	68 62 3a 10 00       	push   $0x103a62
  101b14:	e8 4f e7 ff ff       	call   100268 <cprintf>
  101b19:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1f:	8b 40 38             	mov    0x38(%eax),%eax
  101b22:	83 ec 08             	sub    $0x8,%esp
  101b25:	50                   	push   %eax
  101b26:	68 71 3a 10 00       	push   $0x103a71
  101b2b:	e8 38 e7 ff ff       	call   100268 <cprintf>
  101b30:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b33:	8b 45 08             	mov    0x8(%ebp),%eax
  101b36:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b3a:	0f b7 c0             	movzwl %ax,%eax
  101b3d:	83 ec 08             	sub    $0x8,%esp
  101b40:	50                   	push   %eax
  101b41:	68 80 3a 10 00       	push   $0x103a80
  101b46:	e8 1d e7 ff ff       	call   100268 <cprintf>
  101b4b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b51:	8b 40 40             	mov    0x40(%eax),%eax
  101b54:	83 ec 08             	sub    $0x8,%esp
  101b57:	50                   	push   %eax
  101b58:	68 93 3a 10 00       	push   $0x103a93
  101b5d:	e8 06 e7 ff ff       	call   100268 <cprintf>
  101b62:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b6c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b73:	eb 3f                	jmp    101bb4 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	8b 50 40             	mov    0x40(%eax),%edx
  101b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b7e:	21 d0                	and    %edx,%eax
  101b80:	85 c0                	test   %eax,%eax
  101b82:	74 29                	je     101bad <print_trapframe+0x168>
  101b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b87:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b8e:	85 c0                	test   %eax,%eax
  101b90:	74 1b                	je     101bad <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b95:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b9c:	83 ec 08             	sub    $0x8,%esp
  101b9f:	50                   	push   %eax
  101ba0:	68 a2 3a 10 00       	push   $0x103aa2
  101ba5:	e8 be e6 ff ff       	call   100268 <cprintf>
  101baa:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bb1:	d1 65 f0             	shll   -0x10(%ebp)
  101bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb7:	83 f8 17             	cmp    $0x17,%eax
  101bba:	76 b9                	jbe    101b75 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbf:	8b 40 40             	mov    0x40(%eax),%eax
  101bc2:	25 00 30 00 00       	and    $0x3000,%eax
  101bc7:	c1 e8 0c             	shr    $0xc,%eax
  101bca:	83 ec 08             	sub    $0x8,%esp
  101bcd:	50                   	push   %eax
  101bce:	68 a6 3a 10 00       	push   $0x103aa6
  101bd3:	e8 90 e6 ff ff       	call   100268 <cprintf>
  101bd8:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bdb:	83 ec 0c             	sub    $0xc,%esp
  101bde:	ff 75 08             	pushl  0x8(%ebp)
  101be1:	e8 49 fe ff ff       	call   101a2f <trap_in_kernel>
  101be6:	83 c4 10             	add    $0x10,%esp
  101be9:	85 c0                	test   %eax,%eax
  101beb:	75 32                	jne    101c1f <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	8b 40 44             	mov    0x44(%eax),%eax
  101bf3:	83 ec 08             	sub    $0x8,%esp
  101bf6:	50                   	push   %eax
  101bf7:	68 af 3a 10 00       	push   $0x103aaf
  101bfc:	e8 67 e6 ff ff       	call   100268 <cprintf>
  101c01:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c0b:	0f b7 c0             	movzwl %ax,%eax
  101c0e:	83 ec 08             	sub    $0x8,%esp
  101c11:	50                   	push   %eax
  101c12:	68 be 3a 10 00       	push   $0x103abe
  101c17:	e8 4c e6 ff ff       	call   100268 <cprintf>
  101c1c:	83 c4 10             	add    $0x10,%esp
    }
}
  101c1f:	90                   	nop
  101c20:	c9                   	leave  
  101c21:	c3                   	ret    

00101c22 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c22:	55                   	push   %ebp
  101c23:	89 e5                	mov    %esp,%ebp
  101c25:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 00                	mov    (%eax),%eax
  101c2d:	83 ec 08             	sub    $0x8,%esp
  101c30:	50                   	push   %eax
  101c31:	68 d1 3a 10 00       	push   $0x103ad1
  101c36:	e8 2d e6 ff ff       	call   100268 <cprintf>
  101c3b:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c41:	8b 40 04             	mov    0x4(%eax),%eax
  101c44:	83 ec 08             	sub    $0x8,%esp
  101c47:	50                   	push   %eax
  101c48:	68 e0 3a 10 00       	push   $0x103ae0
  101c4d:	e8 16 e6 ff ff       	call   100268 <cprintf>
  101c52:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c55:	8b 45 08             	mov    0x8(%ebp),%eax
  101c58:	8b 40 08             	mov    0x8(%eax),%eax
  101c5b:	83 ec 08             	sub    $0x8,%esp
  101c5e:	50                   	push   %eax
  101c5f:	68 ef 3a 10 00       	push   $0x103aef
  101c64:	e8 ff e5 ff ff       	call   100268 <cprintf>
  101c69:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6f:	8b 40 0c             	mov    0xc(%eax),%eax
  101c72:	83 ec 08             	sub    $0x8,%esp
  101c75:	50                   	push   %eax
  101c76:	68 fe 3a 10 00       	push   $0x103afe
  101c7b:	e8 e8 e5 ff ff       	call   100268 <cprintf>
  101c80:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	8b 40 10             	mov    0x10(%eax),%eax
  101c89:	83 ec 08             	sub    $0x8,%esp
  101c8c:	50                   	push   %eax
  101c8d:	68 0d 3b 10 00       	push   $0x103b0d
  101c92:	e8 d1 e5 ff ff       	call   100268 <cprintf>
  101c97:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9d:	8b 40 14             	mov    0x14(%eax),%eax
  101ca0:	83 ec 08             	sub    $0x8,%esp
  101ca3:	50                   	push   %eax
  101ca4:	68 1c 3b 10 00       	push   $0x103b1c
  101ca9:	e8 ba e5 ff ff       	call   100268 <cprintf>
  101cae:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb4:	8b 40 18             	mov    0x18(%eax),%eax
  101cb7:	83 ec 08             	sub    $0x8,%esp
  101cba:	50                   	push   %eax
  101cbb:	68 2b 3b 10 00       	push   $0x103b2b
  101cc0:	e8 a3 e5 ff ff       	call   100268 <cprintf>
  101cc5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccb:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cce:	83 ec 08             	sub    $0x8,%esp
  101cd1:	50                   	push   %eax
  101cd2:	68 3a 3b 10 00       	push   $0x103b3a
  101cd7:	e8 8c e5 ff ff       	call   100268 <cprintf>
  101cdc:	83 c4 10             	add    $0x10,%esp
}
  101cdf:	90                   	nop
  101ce0:	c9                   	leave  
  101ce1:	c3                   	ret    

00101ce2 <trap_dispatch>:

bool should_print = 0;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ce2:	55                   	push   %ebp
  101ce3:	89 e5                	mov    %esp,%ebp
  101ce5:	83 ec 18             	sub    $0x18,%esp
    char c;
    switch (tf->tf_trapno) {
  101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ceb:	8b 40 30             	mov    0x30(%eax),%eax
  101cee:	83 f8 2f             	cmp    $0x2f,%eax
  101cf1:	77 21                	ja     101d14 <trap_dispatch+0x32>
  101cf3:	83 f8 2e             	cmp    $0x2e,%eax
  101cf6:	0f 83 3c 02 00 00    	jae    101f38 <trap_dispatch+0x256>
  101cfc:	83 f8 21             	cmp    $0x21,%eax
  101cff:	0f 84 91 00 00 00    	je     101d96 <trap_dispatch+0xb4>
  101d05:	83 f8 24             	cmp    $0x24,%eax
  101d08:	74 65                	je     101d6f <trap_dispatch+0x8d>
  101d0a:	83 f8 20             	cmp    $0x20,%eax
  101d0d:	74 1c                	je     101d2b <trap_dispatch+0x49>
  101d0f:	e9 ee 01 00 00       	jmp    101f02 <trap_dispatch+0x220>
  101d14:	83 f8 78             	cmp    $0x78,%eax
  101d17:	0f 84 56 01 00 00    	je     101e73 <trap_dispatch+0x191>
  101d1d:	83 f8 79             	cmp    $0x79,%eax
  101d20:	0f 84 9f 01 00 00    	je     101ec5 <trap_dispatch+0x1e3>
  101d26:	e9 d7 01 00 00       	jmp    101f02 <trap_dispatch+0x220>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
  101d2b:	a1 28 f9 10 00       	mov    0x10f928,%eax
  101d30:	83 c0 01             	add    $0x1,%eax
  101d33:	a3 28 f9 10 00       	mov    %eax,0x10f928
		if (ticks % TICK_NUM == 0) {
  101d38:	8b 0d 28 f9 10 00    	mov    0x10f928,%ecx
  101d3e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d43:	89 c8                	mov    %ecx,%eax
  101d45:	f7 e2                	mul    %edx
  101d47:	89 d0                	mov    %edx,%eax
  101d49:	c1 e8 05             	shr    $0x5,%eax
  101d4c:	6b c0 64             	imul   $0x64,%eax,%eax
  101d4f:	29 c1                	sub    %eax,%ecx
  101d51:	89 c8                	mov    %ecx,%eax
  101d53:	85 c0                	test   %eax,%eax
  101d55:	0f 85 e0 01 00 00    	jne    101f3b <trap_dispatch+0x259>
			print_ticks();
  101d5b:	e8 9c fa ff ff       	call   1017fc <print_ticks>
			should_print = 1;
  101d60:	c7 05 a0 f0 10 00 01 	movl   $0x1,0x10f0a0
  101d67:	00 00 00 
		}
        break;
  101d6a:	e9 cc 01 00 00       	jmp    101f3b <trap_dispatch+0x259>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d6f:	e8 5b f8 ff ff       	call   1015cf <cons_getc>
  101d74:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d77:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d7b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d7f:	83 ec 04             	sub    $0x4,%esp
  101d82:	52                   	push   %edx
  101d83:	50                   	push   %eax
  101d84:	68 49 3b 10 00       	push   $0x103b49
  101d89:	e8 da e4 ff ff       	call   100268 <cprintf>
  101d8e:	83 c4 10             	add    $0x10,%esp
        break;
  101d91:	e9 af 01 00 00       	jmp    101f45 <trap_dispatch+0x263>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d96:	e8 34 f8 ff ff       	call   1015cf <cons_getc>
  101d9b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d9e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da6:	83 ec 04             	sub    $0x4,%esp
  101da9:	52                   	push   %edx
  101daa:	50                   	push   %eax
  101dab:	68 5b 3b 10 00       	push   $0x103b5b
  101db0:	e8 b3 e4 ff ff       	call   100268 <cprintf>
  101db5:	83 c4 10             	add    $0x10,%esp
        if (c == '0') {
  101db8:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101dbc:	75 46                	jne    101e04 <trap_dispatch+0x122>
        	cprintf("Now switched to kernel mode");
  101dbe:	83 ec 0c             	sub    $0xc,%esp
  101dc1:	68 6a 3b 10 00       	push   $0x103b6a
  101dc6:	e8 9d e4 ff ff       	call   100268 <cprintf>
  101dcb:	83 c4 10             	add    $0x10,%esp
        	if (tf->tf_cs != KERNEL_CS) {
  101dce:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dd5:	66 83 f8 08          	cmp    $0x8,%ax
  101dd9:	0f 84 5f 01 00 00    	je     101f3e <trap_dispatch+0x25c>
				tf->tf_cs = KERNEL_CS;
  101ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  101de2:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
				tf->tf_ds = tf->tf_es = KERNEL_DS;
  101de8:	8b 45 08             	mov    0x8(%ebp),%eax
  101deb:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101df1:	8b 45 08             	mov    0x8(%ebp),%eax
  101df4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_cs = USER_CS;
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
				tf->tf_eflags |= FL_IOPL_MASK;
			}
        }
        break;
  101dff:	e9 3a 01 00 00       	jmp    101f3e <trap_dispatch+0x25c>
        	cprintf("Now switched to kernel mode");
        	if (tf->tf_cs != KERNEL_CS) {
				tf->tf_cs = KERNEL_CS;
				tf->tf_ds = tf->tf_es = KERNEL_DS;
			}
        } else if (c == '3') {
  101e04:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101e08:	0f 85 30 01 00 00    	jne    101f3e <trap_dispatch+0x25c>
        	cprintf("Now switched to user mode");
  101e0e:	83 ec 0c             	sub    $0xc,%esp
  101e11:	68 86 3b 10 00       	push   $0x103b86
  101e16:	e8 4d e4 ff ff       	call   100268 <cprintf>
  101e1b:	83 c4 10             	add    $0x10,%esp
        	if (tf->tf_cs != USER_CS) {
  101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e21:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e25:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e29:	0f 84 0f 01 00 00    	je     101f3e <trap_dispatch+0x25c>
				tf->tf_cs = USER_CS;
  101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e32:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101e38:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101e41:	8b 45 08             	mov    0x8(%ebp),%eax
  101e44:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e48:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4b:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e52:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e56:	8b 45 08             	mov    0x8(%ebp),%eax
  101e59:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags |= FL_IOPL_MASK;
  101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e60:	8b 40 40             	mov    0x40(%eax),%eax
  101e63:	80 cc 30             	or     $0x30,%ah
  101e66:	89 c2                	mov    %eax,%edx
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	89 50 40             	mov    %edx,0x40(%eax)
			}
        }
        break;
  101e6e:	e9 cb 00 00 00       	jmp    101f3e <trap_dispatch+0x25c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101e73:	8b 45 08             	mov    0x8(%ebp),%eax
  101e76:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e7a:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e7e:	0f 84 bd 00 00 00    	je     101f41 <trap_dispatch+0x25f>
            tf->tf_cs = USER_CS;
  101e84:	8b 45 08             	mov    0x8(%ebp),%eax
  101e87:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e90:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101e96:	8b 45 08             	mov    0x8(%ebp),%eax
  101e99:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea0:	66 89 50 28          	mov    %dx,0x28(%eax)
  101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea7:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101eab:	8b 45 08             	mov    0x8(%ebp),%eax
  101eae:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb5:	8b 40 40             	mov    0x40(%eax),%eax
  101eb8:	80 cc 30             	or     $0x30,%ah
  101ebb:	89 c2                	mov    %eax,%edx
  101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec0:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101ec3:	eb 7c                	jmp    101f41 <trap_dispatch+0x25f>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ecc:	66 83 f8 08          	cmp    $0x8,%ax
  101ed0:	74 72                	je     101f44 <trap_dispatch+0x262>
            tf->tf_cs = KERNEL_CS;
  101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed5:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101edb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ede:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee7:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  101eee:	66 89 50 28          	mov    %dx,0x28(%eax)
  101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef5:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        break;
  101f00:	eb 42                	jmp    101f44 <trap_dispatch+0x262>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f02:	8b 45 08             	mov    0x8(%ebp),%eax
  101f05:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f09:	0f b7 c0             	movzwl %ax,%eax
  101f0c:	83 e0 03             	and    $0x3,%eax
  101f0f:	85 c0                	test   %eax,%eax
  101f11:	75 32                	jne    101f45 <trap_dispatch+0x263>
            print_trapframe(tf);
  101f13:	83 ec 0c             	sub    $0xc,%esp
  101f16:	ff 75 08             	pushl  0x8(%ebp)
  101f19:	e8 27 fb ff ff       	call   101a45 <print_trapframe>
  101f1e:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101f21:	83 ec 04             	sub    $0x4,%esp
  101f24:	68 a0 3b 10 00       	push   $0x103ba0
  101f29:	68 d3 00 00 00       	push   $0xd3
  101f2e:	68 8e 39 10 00       	push   $0x10398e
  101f33:	e8 96 e4 ff ff       	call   1003ce <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f38:	90                   	nop
  101f39:	eb 0a                	jmp    101f45 <trap_dispatch+0x263>
		ticks ++;
		if (ticks % TICK_NUM == 0) {
			print_ticks();
			should_print = 1;
		}
        break;
  101f3b:	90                   	nop
  101f3c:	eb 07                	jmp    101f45 <trap_dispatch+0x263>
				tf->tf_cs = USER_CS;
				tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
				tf->tf_eflags |= FL_IOPL_MASK;
			}
        }
        break;
  101f3e:	90                   	nop
  101f3f:	eb 04                	jmp    101f45 <trap_dispatch+0x263>
        if (tf->tf_cs != USER_CS) {
            tf->tf_cs = USER_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
            tf->tf_eflags |= FL_IOPL_MASK;
        }
        break;
  101f41:	90                   	nop
  101f42:	eb 01                	jmp    101f45 <trap_dispatch+0x263>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
        }
        break;
  101f44:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f45:	90                   	nop
  101f46:	c9                   	leave  
  101f47:	c3                   	ret    

00101f48 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f48:	55                   	push   %ebp
  101f49:	89 e5                	mov    %esp,%ebp
  101f4b:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f4e:	83 ec 0c             	sub    $0xc,%esp
  101f51:	ff 75 08             	pushl  0x8(%ebp)
  101f54:	e8 89 fd ff ff       	call   101ce2 <trap_dispatch>
  101f59:	83 c4 10             	add    $0x10,%esp
}
  101f5c:	90                   	nop
  101f5d:	c9                   	leave  
  101f5e:	c3                   	ret    

00101f5f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $0
  101f61:	6a 00                	push   $0x0
  jmp __alltraps
  101f63:	e9 67 0a 00 00       	jmp    1029cf <__alltraps>

00101f68 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $1
  101f6a:	6a 01                	push   $0x1
  jmp __alltraps
  101f6c:	e9 5e 0a 00 00       	jmp    1029cf <__alltraps>

00101f71 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $2
  101f73:	6a 02                	push   $0x2
  jmp __alltraps
  101f75:	e9 55 0a 00 00       	jmp    1029cf <__alltraps>

00101f7a <vector3>:
.globl vector3
vector3:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $3
  101f7c:	6a 03                	push   $0x3
  jmp __alltraps
  101f7e:	e9 4c 0a 00 00       	jmp    1029cf <__alltraps>

00101f83 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $4
  101f85:	6a 04                	push   $0x4
  jmp __alltraps
  101f87:	e9 43 0a 00 00       	jmp    1029cf <__alltraps>

00101f8c <vector5>:
.globl vector5
vector5:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $5
  101f8e:	6a 05                	push   $0x5
  jmp __alltraps
  101f90:	e9 3a 0a 00 00       	jmp    1029cf <__alltraps>

00101f95 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $6
  101f97:	6a 06                	push   $0x6
  jmp __alltraps
  101f99:	e9 31 0a 00 00       	jmp    1029cf <__alltraps>

00101f9e <vector7>:
.globl vector7
vector7:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $7
  101fa0:	6a 07                	push   $0x7
  jmp __alltraps
  101fa2:	e9 28 0a 00 00       	jmp    1029cf <__alltraps>

00101fa7 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fa7:	6a 08                	push   $0x8
  jmp __alltraps
  101fa9:	e9 21 0a 00 00       	jmp    1029cf <__alltraps>

00101fae <vector9>:
.globl vector9
vector9:
  pushl $9
  101fae:	6a 09                	push   $0x9
  jmp __alltraps
  101fb0:	e9 1a 0a 00 00       	jmp    1029cf <__alltraps>

00101fb5 <vector10>:
.globl vector10
vector10:
  pushl $10
  101fb5:	6a 0a                	push   $0xa
  jmp __alltraps
  101fb7:	e9 13 0a 00 00       	jmp    1029cf <__alltraps>

00101fbc <vector11>:
.globl vector11
vector11:
  pushl $11
  101fbc:	6a 0b                	push   $0xb
  jmp __alltraps
  101fbe:	e9 0c 0a 00 00       	jmp    1029cf <__alltraps>

00101fc3 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fc3:	6a 0c                	push   $0xc
  jmp __alltraps
  101fc5:	e9 05 0a 00 00       	jmp    1029cf <__alltraps>

00101fca <vector13>:
.globl vector13
vector13:
  pushl $13
  101fca:	6a 0d                	push   $0xd
  jmp __alltraps
  101fcc:	e9 fe 09 00 00       	jmp    1029cf <__alltraps>

00101fd1 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fd1:	6a 0e                	push   $0xe
  jmp __alltraps
  101fd3:	e9 f7 09 00 00       	jmp    1029cf <__alltraps>

00101fd8 <vector15>:
.globl vector15
vector15:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $15
  101fda:	6a 0f                	push   $0xf
  jmp __alltraps
  101fdc:	e9 ee 09 00 00       	jmp    1029cf <__alltraps>

00101fe1 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $16
  101fe3:	6a 10                	push   $0x10
  jmp __alltraps
  101fe5:	e9 e5 09 00 00       	jmp    1029cf <__alltraps>

00101fea <vector17>:
.globl vector17
vector17:
  pushl $17
  101fea:	6a 11                	push   $0x11
  jmp __alltraps
  101fec:	e9 de 09 00 00       	jmp    1029cf <__alltraps>

00101ff1 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $18
  101ff3:	6a 12                	push   $0x12
  jmp __alltraps
  101ff5:	e9 d5 09 00 00       	jmp    1029cf <__alltraps>

00101ffa <vector19>:
.globl vector19
vector19:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $19
  101ffc:	6a 13                	push   $0x13
  jmp __alltraps
  101ffe:	e9 cc 09 00 00       	jmp    1029cf <__alltraps>

00102003 <vector20>:
.globl vector20
vector20:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $20
  102005:	6a 14                	push   $0x14
  jmp __alltraps
  102007:	e9 c3 09 00 00       	jmp    1029cf <__alltraps>

0010200c <vector21>:
.globl vector21
vector21:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $21
  10200e:	6a 15                	push   $0x15
  jmp __alltraps
  102010:	e9 ba 09 00 00       	jmp    1029cf <__alltraps>

00102015 <vector22>:
.globl vector22
vector22:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $22
  102017:	6a 16                	push   $0x16
  jmp __alltraps
  102019:	e9 b1 09 00 00       	jmp    1029cf <__alltraps>

0010201e <vector23>:
.globl vector23
vector23:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $23
  102020:	6a 17                	push   $0x17
  jmp __alltraps
  102022:	e9 a8 09 00 00       	jmp    1029cf <__alltraps>

00102027 <vector24>:
.globl vector24
vector24:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $24
  102029:	6a 18                	push   $0x18
  jmp __alltraps
  10202b:	e9 9f 09 00 00       	jmp    1029cf <__alltraps>

00102030 <vector25>:
.globl vector25
vector25:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $25
  102032:	6a 19                	push   $0x19
  jmp __alltraps
  102034:	e9 96 09 00 00       	jmp    1029cf <__alltraps>

00102039 <vector26>:
.globl vector26
vector26:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $26
  10203b:	6a 1a                	push   $0x1a
  jmp __alltraps
  10203d:	e9 8d 09 00 00       	jmp    1029cf <__alltraps>

00102042 <vector27>:
.globl vector27
vector27:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $27
  102044:	6a 1b                	push   $0x1b
  jmp __alltraps
  102046:	e9 84 09 00 00       	jmp    1029cf <__alltraps>

0010204b <vector28>:
.globl vector28
vector28:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $28
  10204d:	6a 1c                	push   $0x1c
  jmp __alltraps
  10204f:	e9 7b 09 00 00       	jmp    1029cf <__alltraps>

00102054 <vector29>:
.globl vector29
vector29:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $29
  102056:	6a 1d                	push   $0x1d
  jmp __alltraps
  102058:	e9 72 09 00 00       	jmp    1029cf <__alltraps>

0010205d <vector30>:
.globl vector30
vector30:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $30
  10205f:	6a 1e                	push   $0x1e
  jmp __alltraps
  102061:	e9 69 09 00 00       	jmp    1029cf <__alltraps>

00102066 <vector31>:
.globl vector31
vector31:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $31
  102068:	6a 1f                	push   $0x1f
  jmp __alltraps
  10206a:	e9 60 09 00 00       	jmp    1029cf <__alltraps>

0010206f <vector32>:
.globl vector32
vector32:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $32
  102071:	6a 20                	push   $0x20
  jmp __alltraps
  102073:	e9 57 09 00 00       	jmp    1029cf <__alltraps>

00102078 <vector33>:
.globl vector33
vector33:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $33
  10207a:	6a 21                	push   $0x21
  jmp __alltraps
  10207c:	e9 4e 09 00 00       	jmp    1029cf <__alltraps>

00102081 <vector34>:
.globl vector34
vector34:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $34
  102083:	6a 22                	push   $0x22
  jmp __alltraps
  102085:	e9 45 09 00 00       	jmp    1029cf <__alltraps>

0010208a <vector35>:
.globl vector35
vector35:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $35
  10208c:	6a 23                	push   $0x23
  jmp __alltraps
  10208e:	e9 3c 09 00 00       	jmp    1029cf <__alltraps>

00102093 <vector36>:
.globl vector36
vector36:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $36
  102095:	6a 24                	push   $0x24
  jmp __alltraps
  102097:	e9 33 09 00 00       	jmp    1029cf <__alltraps>

0010209c <vector37>:
.globl vector37
vector37:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $37
  10209e:	6a 25                	push   $0x25
  jmp __alltraps
  1020a0:	e9 2a 09 00 00       	jmp    1029cf <__alltraps>

001020a5 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $38
  1020a7:	6a 26                	push   $0x26
  jmp __alltraps
  1020a9:	e9 21 09 00 00       	jmp    1029cf <__alltraps>

001020ae <vector39>:
.globl vector39
vector39:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $39
  1020b0:	6a 27                	push   $0x27
  jmp __alltraps
  1020b2:	e9 18 09 00 00       	jmp    1029cf <__alltraps>

001020b7 <vector40>:
.globl vector40
vector40:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $40
  1020b9:	6a 28                	push   $0x28
  jmp __alltraps
  1020bb:	e9 0f 09 00 00       	jmp    1029cf <__alltraps>

001020c0 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $41
  1020c2:	6a 29                	push   $0x29
  jmp __alltraps
  1020c4:	e9 06 09 00 00       	jmp    1029cf <__alltraps>

001020c9 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $42
  1020cb:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020cd:	e9 fd 08 00 00       	jmp    1029cf <__alltraps>

001020d2 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $43
  1020d4:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020d6:	e9 f4 08 00 00       	jmp    1029cf <__alltraps>

001020db <vector44>:
.globl vector44
vector44:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $44
  1020dd:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020df:	e9 eb 08 00 00       	jmp    1029cf <__alltraps>

001020e4 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $45
  1020e6:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020e8:	e9 e2 08 00 00       	jmp    1029cf <__alltraps>

001020ed <vector46>:
.globl vector46
vector46:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $46
  1020ef:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020f1:	e9 d9 08 00 00       	jmp    1029cf <__alltraps>

001020f6 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $47
  1020f8:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020fa:	e9 d0 08 00 00       	jmp    1029cf <__alltraps>

001020ff <vector48>:
.globl vector48
vector48:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $48
  102101:	6a 30                	push   $0x30
  jmp __alltraps
  102103:	e9 c7 08 00 00       	jmp    1029cf <__alltraps>

00102108 <vector49>:
.globl vector49
vector49:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $49
  10210a:	6a 31                	push   $0x31
  jmp __alltraps
  10210c:	e9 be 08 00 00       	jmp    1029cf <__alltraps>

00102111 <vector50>:
.globl vector50
vector50:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $50
  102113:	6a 32                	push   $0x32
  jmp __alltraps
  102115:	e9 b5 08 00 00       	jmp    1029cf <__alltraps>

0010211a <vector51>:
.globl vector51
vector51:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $51
  10211c:	6a 33                	push   $0x33
  jmp __alltraps
  10211e:	e9 ac 08 00 00       	jmp    1029cf <__alltraps>

00102123 <vector52>:
.globl vector52
vector52:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $52
  102125:	6a 34                	push   $0x34
  jmp __alltraps
  102127:	e9 a3 08 00 00       	jmp    1029cf <__alltraps>

0010212c <vector53>:
.globl vector53
vector53:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $53
  10212e:	6a 35                	push   $0x35
  jmp __alltraps
  102130:	e9 9a 08 00 00       	jmp    1029cf <__alltraps>

00102135 <vector54>:
.globl vector54
vector54:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $54
  102137:	6a 36                	push   $0x36
  jmp __alltraps
  102139:	e9 91 08 00 00       	jmp    1029cf <__alltraps>

0010213e <vector55>:
.globl vector55
vector55:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $55
  102140:	6a 37                	push   $0x37
  jmp __alltraps
  102142:	e9 88 08 00 00       	jmp    1029cf <__alltraps>

00102147 <vector56>:
.globl vector56
vector56:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $56
  102149:	6a 38                	push   $0x38
  jmp __alltraps
  10214b:	e9 7f 08 00 00       	jmp    1029cf <__alltraps>

00102150 <vector57>:
.globl vector57
vector57:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $57
  102152:	6a 39                	push   $0x39
  jmp __alltraps
  102154:	e9 76 08 00 00       	jmp    1029cf <__alltraps>

00102159 <vector58>:
.globl vector58
vector58:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $58
  10215b:	6a 3a                	push   $0x3a
  jmp __alltraps
  10215d:	e9 6d 08 00 00       	jmp    1029cf <__alltraps>

00102162 <vector59>:
.globl vector59
vector59:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $59
  102164:	6a 3b                	push   $0x3b
  jmp __alltraps
  102166:	e9 64 08 00 00       	jmp    1029cf <__alltraps>

0010216b <vector60>:
.globl vector60
vector60:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $60
  10216d:	6a 3c                	push   $0x3c
  jmp __alltraps
  10216f:	e9 5b 08 00 00       	jmp    1029cf <__alltraps>

00102174 <vector61>:
.globl vector61
vector61:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $61
  102176:	6a 3d                	push   $0x3d
  jmp __alltraps
  102178:	e9 52 08 00 00       	jmp    1029cf <__alltraps>

0010217d <vector62>:
.globl vector62
vector62:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $62
  10217f:	6a 3e                	push   $0x3e
  jmp __alltraps
  102181:	e9 49 08 00 00       	jmp    1029cf <__alltraps>

00102186 <vector63>:
.globl vector63
vector63:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $63
  102188:	6a 3f                	push   $0x3f
  jmp __alltraps
  10218a:	e9 40 08 00 00       	jmp    1029cf <__alltraps>

0010218f <vector64>:
.globl vector64
vector64:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $64
  102191:	6a 40                	push   $0x40
  jmp __alltraps
  102193:	e9 37 08 00 00       	jmp    1029cf <__alltraps>

00102198 <vector65>:
.globl vector65
vector65:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $65
  10219a:	6a 41                	push   $0x41
  jmp __alltraps
  10219c:	e9 2e 08 00 00       	jmp    1029cf <__alltraps>

001021a1 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $66
  1021a3:	6a 42                	push   $0x42
  jmp __alltraps
  1021a5:	e9 25 08 00 00       	jmp    1029cf <__alltraps>

001021aa <vector67>:
.globl vector67
vector67:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $67
  1021ac:	6a 43                	push   $0x43
  jmp __alltraps
  1021ae:	e9 1c 08 00 00       	jmp    1029cf <__alltraps>

001021b3 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $68
  1021b5:	6a 44                	push   $0x44
  jmp __alltraps
  1021b7:	e9 13 08 00 00       	jmp    1029cf <__alltraps>

001021bc <vector69>:
.globl vector69
vector69:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $69
  1021be:	6a 45                	push   $0x45
  jmp __alltraps
  1021c0:	e9 0a 08 00 00       	jmp    1029cf <__alltraps>

001021c5 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $70
  1021c7:	6a 46                	push   $0x46
  jmp __alltraps
  1021c9:	e9 01 08 00 00       	jmp    1029cf <__alltraps>

001021ce <vector71>:
.globl vector71
vector71:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $71
  1021d0:	6a 47                	push   $0x47
  jmp __alltraps
  1021d2:	e9 f8 07 00 00       	jmp    1029cf <__alltraps>

001021d7 <vector72>:
.globl vector72
vector72:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $72
  1021d9:	6a 48                	push   $0x48
  jmp __alltraps
  1021db:	e9 ef 07 00 00       	jmp    1029cf <__alltraps>

001021e0 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $73
  1021e2:	6a 49                	push   $0x49
  jmp __alltraps
  1021e4:	e9 e6 07 00 00       	jmp    1029cf <__alltraps>

001021e9 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $74
  1021eb:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021ed:	e9 dd 07 00 00       	jmp    1029cf <__alltraps>

001021f2 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $75
  1021f4:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021f6:	e9 d4 07 00 00       	jmp    1029cf <__alltraps>

001021fb <vector76>:
.globl vector76
vector76:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $76
  1021fd:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021ff:	e9 cb 07 00 00       	jmp    1029cf <__alltraps>

00102204 <vector77>:
.globl vector77
vector77:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $77
  102206:	6a 4d                	push   $0x4d
  jmp __alltraps
  102208:	e9 c2 07 00 00       	jmp    1029cf <__alltraps>

0010220d <vector78>:
.globl vector78
vector78:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $78
  10220f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102211:	e9 b9 07 00 00       	jmp    1029cf <__alltraps>

00102216 <vector79>:
.globl vector79
vector79:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $79
  102218:	6a 4f                	push   $0x4f
  jmp __alltraps
  10221a:	e9 b0 07 00 00       	jmp    1029cf <__alltraps>

0010221f <vector80>:
.globl vector80
vector80:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $80
  102221:	6a 50                	push   $0x50
  jmp __alltraps
  102223:	e9 a7 07 00 00       	jmp    1029cf <__alltraps>

00102228 <vector81>:
.globl vector81
vector81:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $81
  10222a:	6a 51                	push   $0x51
  jmp __alltraps
  10222c:	e9 9e 07 00 00       	jmp    1029cf <__alltraps>

00102231 <vector82>:
.globl vector82
vector82:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $82
  102233:	6a 52                	push   $0x52
  jmp __alltraps
  102235:	e9 95 07 00 00       	jmp    1029cf <__alltraps>

0010223a <vector83>:
.globl vector83
vector83:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $83
  10223c:	6a 53                	push   $0x53
  jmp __alltraps
  10223e:	e9 8c 07 00 00       	jmp    1029cf <__alltraps>

00102243 <vector84>:
.globl vector84
vector84:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $84
  102245:	6a 54                	push   $0x54
  jmp __alltraps
  102247:	e9 83 07 00 00       	jmp    1029cf <__alltraps>

0010224c <vector85>:
.globl vector85
vector85:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $85
  10224e:	6a 55                	push   $0x55
  jmp __alltraps
  102250:	e9 7a 07 00 00       	jmp    1029cf <__alltraps>

00102255 <vector86>:
.globl vector86
vector86:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $86
  102257:	6a 56                	push   $0x56
  jmp __alltraps
  102259:	e9 71 07 00 00       	jmp    1029cf <__alltraps>

0010225e <vector87>:
.globl vector87
vector87:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $87
  102260:	6a 57                	push   $0x57
  jmp __alltraps
  102262:	e9 68 07 00 00       	jmp    1029cf <__alltraps>

00102267 <vector88>:
.globl vector88
vector88:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $88
  102269:	6a 58                	push   $0x58
  jmp __alltraps
  10226b:	e9 5f 07 00 00       	jmp    1029cf <__alltraps>

00102270 <vector89>:
.globl vector89
vector89:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $89
  102272:	6a 59                	push   $0x59
  jmp __alltraps
  102274:	e9 56 07 00 00       	jmp    1029cf <__alltraps>

00102279 <vector90>:
.globl vector90
vector90:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $90
  10227b:	6a 5a                	push   $0x5a
  jmp __alltraps
  10227d:	e9 4d 07 00 00       	jmp    1029cf <__alltraps>

00102282 <vector91>:
.globl vector91
vector91:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $91
  102284:	6a 5b                	push   $0x5b
  jmp __alltraps
  102286:	e9 44 07 00 00       	jmp    1029cf <__alltraps>

0010228b <vector92>:
.globl vector92
vector92:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $92
  10228d:	6a 5c                	push   $0x5c
  jmp __alltraps
  10228f:	e9 3b 07 00 00       	jmp    1029cf <__alltraps>

00102294 <vector93>:
.globl vector93
vector93:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $93
  102296:	6a 5d                	push   $0x5d
  jmp __alltraps
  102298:	e9 32 07 00 00       	jmp    1029cf <__alltraps>

0010229d <vector94>:
.globl vector94
vector94:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $94
  10229f:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022a1:	e9 29 07 00 00       	jmp    1029cf <__alltraps>

001022a6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $95
  1022a8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022aa:	e9 20 07 00 00       	jmp    1029cf <__alltraps>

001022af <vector96>:
.globl vector96
vector96:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $96
  1022b1:	6a 60                	push   $0x60
  jmp __alltraps
  1022b3:	e9 17 07 00 00       	jmp    1029cf <__alltraps>

001022b8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $97
  1022ba:	6a 61                	push   $0x61
  jmp __alltraps
  1022bc:	e9 0e 07 00 00       	jmp    1029cf <__alltraps>

001022c1 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $98
  1022c3:	6a 62                	push   $0x62
  jmp __alltraps
  1022c5:	e9 05 07 00 00       	jmp    1029cf <__alltraps>

001022ca <vector99>:
.globl vector99
vector99:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $99
  1022cc:	6a 63                	push   $0x63
  jmp __alltraps
  1022ce:	e9 fc 06 00 00       	jmp    1029cf <__alltraps>

001022d3 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $100
  1022d5:	6a 64                	push   $0x64
  jmp __alltraps
  1022d7:	e9 f3 06 00 00       	jmp    1029cf <__alltraps>

001022dc <vector101>:
.globl vector101
vector101:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $101
  1022de:	6a 65                	push   $0x65
  jmp __alltraps
  1022e0:	e9 ea 06 00 00       	jmp    1029cf <__alltraps>

001022e5 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $102
  1022e7:	6a 66                	push   $0x66
  jmp __alltraps
  1022e9:	e9 e1 06 00 00       	jmp    1029cf <__alltraps>

001022ee <vector103>:
.globl vector103
vector103:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $103
  1022f0:	6a 67                	push   $0x67
  jmp __alltraps
  1022f2:	e9 d8 06 00 00       	jmp    1029cf <__alltraps>

001022f7 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $104
  1022f9:	6a 68                	push   $0x68
  jmp __alltraps
  1022fb:	e9 cf 06 00 00       	jmp    1029cf <__alltraps>

00102300 <vector105>:
.globl vector105
vector105:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $105
  102302:	6a 69                	push   $0x69
  jmp __alltraps
  102304:	e9 c6 06 00 00       	jmp    1029cf <__alltraps>

00102309 <vector106>:
.globl vector106
vector106:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $106
  10230b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10230d:	e9 bd 06 00 00       	jmp    1029cf <__alltraps>

00102312 <vector107>:
.globl vector107
vector107:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $107
  102314:	6a 6b                	push   $0x6b
  jmp __alltraps
  102316:	e9 b4 06 00 00       	jmp    1029cf <__alltraps>

0010231b <vector108>:
.globl vector108
vector108:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $108
  10231d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10231f:	e9 ab 06 00 00       	jmp    1029cf <__alltraps>

00102324 <vector109>:
.globl vector109
vector109:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $109
  102326:	6a 6d                	push   $0x6d
  jmp __alltraps
  102328:	e9 a2 06 00 00       	jmp    1029cf <__alltraps>

0010232d <vector110>:
.globl vector110
vector110:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $110
  10232f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102331:	e9 99 06 00 00       	jmp    1029cf <__alltraps>

00102336 <vector111>:
.globl vector111
vector111:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $111
  102338:	6a 6f                	push   $0x6f
  jmp __alltraps
  10233a:	e9 90 06 00 00       	jmp    1029cf <__alltraps>

0010233f <vector112>:
.globl vector112
vector112:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $112
  102341:	6a 70                	push   $0x70
  jmp __alltraps
  102343:	e9 87 06 00 00       	jmp    1029cf <__alltraps>

00102348 <vector113>:
.globl vector113
vector113:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $113
  10234a:	6a 71                	push   $0x71
  jmp __alltraps
  10234c:	e9 7e 06 00 00       	jmp    1029cf <__alltraps>

00102351 <vector114>:
.globl vector114
vector114:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $114
  102353:	6a 72                	push   $0x72
  jmp __alltraps
  102355:	e9 75 06 00 00       	jmp    1029cf <__alltraps>

0010235a <vector115>:
.globl vector115
vector115:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $115
  10235c:	6a 73                	push   $0x73
  jmp __alltraps
  10235e:	e9 6c 06 00 00       	jmp    1029cf <__alltraps>

00102363 <vector116>:
.globl vector116
vector116:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $116
  102365:	6a 74                	push   $0x74
  jmp __alltraps
  102367:	e9 63 06 00 00       	jmp    1029cf <__alltraps>

0010236c <vector117>:
.globl vector117
vector117:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $117
  10236e:	6a 75                	push   $0x75
  jmp __alltraps
  102370:	e9 5a 06 00 00       	jmp    1029cf <__alltraps>

00102375 <vector118>:
.globl vector118
vector118:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $118
  102377:	6a 76                	push   $0x76
  jmp __alltraps
  102379:	e9 51 06 00 00       	jmp    1029cf <__alltraps>

0010237e <vector119>:
.globl vector119
vector119:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $119
  102380:	6a 77                	push   $0x77
  jmp __alltraps
  102382:	e9 48 06 00 00       	jmp    1029cf <__alltraps>

00102387 <vector120>:
.globl vector120
vector120:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $120
  102389:	6a 78                	push   $0x78
  jmp __alltraps
  10238b:	e9 3f 06 00 00       	jmp    1029cf <__alltraps>

00102390 <vector121>:
.globl vector121
vector121:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $121
  102392:	6a 79                	push   $0x79
  jmp __alltraps
  102394:	e9 36 06 00 00       	jmp    1029cf <__alltraps>

00102399 <vector122>:
.globl vector122
vector122:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $122
  10239b:	6a 7a                	push   $0x7a
  jmp __alltraps
  10239d:	e9 2d 06 00 00       	jmp    1029cf <__alltraps>

001023a2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $123
  1023a4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023a6:	e9 24 06 00 00       	jmp    1029cf <__alltraps>

001023ab <vector124>:
.globl vector124
vector124:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $124
  1023ad:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023af:	e9 1b 06 00 00       	jmp    1029cf <__alltraps>

001023b4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $125
  1023b6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023b8:	e9 12 06 00 00       	jmp    1029cf <__alltraps>

001023bd <vector126>:
.globl vector126
vector126:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $126
  1023bf:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023c1:	e9 09 06 00 00       	jmp    1029cf <__alltraps>

001023c6 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $127
  1023c8:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023ca:	e9 00 06 00 00       	jmp    1029cf <__alltraps>

001023cf <vector128>:
.globl vector128
vector128:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $128
  1023d1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023d6:	e9 f4 05 00 00       	jmp    1029cf <__alltraps>

001023db <vector129>:
.globl vector129
vector129:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $129
  1023dd:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023e2:	e9 e8 05 00 00       	jmp    1029cf <__alltraps>

001023e7 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $130
  1023e9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023ee:	e9 dc 05 00 00       	jmp    1029cf <__alltraps>

001023f3 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $131
  1023f5:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023fa:	e9 d0 05 00 00       	jmp    1029cf <__alltraps>

001023ff <vector132>:
.globl vector132
vector132:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $132
  102401:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102406:	e9 c4 05 00 00       	jmp    1029cf <__alltraps>

0010240b <vector133>:
.globl vector133
vector133:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $133
  10240d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102412:	e9 b8 05 00 00       	jmp    1029cf <__alltraps>

00102417 <vector134>:
.globl vector134
vector134:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $134
  102419:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10241e:	e9 ac 05 00 00       	jmp    1029cf <__alltraps>

00102423 <vector135>:
.globl vector135
vector135:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $135
  102425:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10242a:	e9 a0 05 00 00       	jmp    1029cf <__alltraps>

0010242f <vector136>:
.globl vector136
vector136:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $136
  102431:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102436:	e9 94 05 00 00       	jmp    1029cf <__alltraps>

0010243b <vector137>:
.globl vector137
vector137:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $137
  10243d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102442:	e9 88 05 00 00       	jmp    1029cf <__alltraps>

00102447 <vector138>:
.globl vector138
vector138:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $138
  102449:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10244e:	e9 7c 05 00 00       	jmp    1029cf <__alltraps>

00102453 <vector139>:
.globl vector139
vector139:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $139
  102455:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10245a:	e9 70 05 00 00       	jmp    1029cf <__alltraps>

0010245f <vector140>:
.globl vector140
vector140:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $140
  102461:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102466:	e9 64 05 00 00       	jmp    1029cf <__alltraps>

0010246b <vector141>:
.globl vector141
vector141:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $141
  10246d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102472:	e9 58 05 00 00       	jmp    1029cf <__alltraps>

00102477 <vector142>:
.globl vector142
vector142:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $142
  102479:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10247e:	e9 4c 05 00 00       	jmp    1029cf <__alltraps>

00102483 <vector143>:
.globl vector143
vector143:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $143
  102485:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10248a:	e9 40 05 00 00       	jmp    1029cf <__alltraps>

0010248f <vector144>:
.globl vector144
vector144:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $144
  102491:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102496:	e9 34 05 00 00       	jmp    1029cf <__alltraps>

0010249b <vector145>:
.globl vector145
vector145:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $145
  10249d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024a2:	e9 28 05 00 00       	jmp    1029cf <__alltraps>

001024a7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $146
  1024a9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024ae:	e9 1c 05 00 00       	jmp    1029cf <__alltraps>

001024b3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $147
  1024b5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024ba:	e9 10 05 00 00       	jmp    1029cf <__alltraps>

001024bf <vector148>:
.globl vector148
vector148:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $148
  1024c1:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024c6:	e9 04 05 00 00       	jmp    1029cf <__alltraps>

001024cb <vector149>:
.globl vector149
vector149:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $149
  1024cd:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024d2:	e9 f8 04 00 00       	jmp    1029cf <__alltraps>

001024d7 <vector150>:
.globl vector150
vector150:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $150
  1024d9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024de:	e9 ec 04 00 00       	jmp    1029cf <__alltraps>

001024e3 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $151
  1024e5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024ea:	e9 e0 04 00 00       	jmp    1029cf <__alltraps>

001024ef <vector152>:
.globl vector152
vector152:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $152
  1024f1:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024f6:	e9 d4 04 00 00       	jmp    1029cf <__alltraps>

001024fb <vector153>:
.globl vector153
vector153:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $153
  1024fd:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102502:	e9 c8 04 00 00       	jmp    1029cf <__alltraps>

00102507 <vector154>:
.globl vector154
vector154:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $154
  102509:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10250e:	e9 bc 04 00 00       	jmp    1029cf <__alltraps>

00102513 <vector155>:
.globl vector155
vector155:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $155
  102515:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10251a:	e9 b0 04 00 00       	jmp    1029cf <__alltraps>

0010251f <vector156>:
.globl vector156
vector156:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $156
  102521:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102526:	e9 a4 04 00 00       	jmp    1029cf <__alltraps>

0010252b <vector157>:
.globl vector157
vector157:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $157
  10252d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102532:	e9 98 04 00 00       	jmp    1029cf <__alltraps>

00102537 <vector158>:
.globl vector158
vector158:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $158
  102539:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10253e:	e9 8c 04 00 00       	jmp    1029cf <__alltraps>

00102543 <vector159>:
.globl vector159
vector159:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $159
  102545:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10254a:	e9 80 04 00 00       	jmp    1029cf <__alltraps>

0010254f <vector160>:
.globl vector160
vector160:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $160
  102551:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102556:	e9 74 04 00 00       	jmp    1029cf <__alltraps>

0010255b <vector161>:
.globl vector161
vector161:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $161
  10255d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102562:	e9 68 04 00 00       	jmp    1029cf <__alltraps>

00102567 <vector162>:
.globl vector162
vector162:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $162
  102569:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10256e:	e9 5c 04 00 00       	jmp    1029cf <__alltraps>

00102573 <vector163>:
.globl vector163
vector163:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $163
  102575:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10257a:	e9 50 04 00 00       	jmp    1029cf <__alltraps>

0010257f <vector164>:
.globl vector164
vector164:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $164
  102581:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102586:	e9 44 04 00 00       	jmp    1029cf <__alltraps>

0010258b <vector165>:
.globl vector165
vector165:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $165
  10258d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102592:	e9 38 04 00 00       	jmp    1029cf <__alltraps>

00102597 <vector166>:
.globl vector166
vector166:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $166
  102599:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10259e:	e9 2c 04 00 00       	jmp    1029cf <__alltraps>

001025a3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $167
  1025a5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025aa:	e9 20 04 00 00       	jmp    1029cf <__alltraps>

001025af <vector168>:
.globl vector168
vector168:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $168
  1025b1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025b6:	e9 14 04 00 00       	jmp    1029cf <__alltraps>

001025bb <vector169>:
.globl vector169
vector169:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $169
  1025bd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025c2:	e9 08 04 00 00       	jmp    1029cf <__alltraps>

001025c7 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $170
  1025c9:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025ce:	e9 fc 03 00 00       	jmp    1029cf <__alltraps>

001025d3 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $171
  1025d5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025da:	e9 f0 03 00 00       	jmp    1029cf <__alltraps>

001025df <vector172>:
.globl vector172
vector172:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $172
  1025e1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025e6:	e9 e4 03 00 00       	jmp    1029cf <__alltraps>

001025eb <vector173>:
.globl vector173
vector173:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $173
  1025ed:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025f2:	e9 d8 03 00 00       	jmp    1029cf <__alltraps>

001025f7 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $174
  1025f9:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025fe:	e9 cc 03 00 00       	jmp    1029cf <__alltraps>

00102603 <vector175>:
.globl vector175
vector175:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $175
  102605:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10260a:	e9 c0 03 00 00       	jmp    1029cf <__alltraps>

0010260f <vector176>:
.globl vector176
vector176:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $176
  102611:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102616:	e9 b4 03 00 00       	jmp    1029cf <__alltraps>

0010261b <vector177>:
.globl vector177
vector177:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $177
  10261d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102622:	e9 a8 03 00 00       	jmp    1029cf <__alltraps>

00102627 <vector178>:
.globl vector178
vector178:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $178
  102629:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10262e:	e9 9c 03 00 00       	jmp    1029cf <__alltraps>

00102633 <vector179>:
.globl vector179
vector179:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $179
  102635:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10263a:	e9 90 03 00 00       	jmp    1029cf <__alltraps>

0010263f <vector180>:
.globl vector180
vector180:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $180
  102641:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102646:	e9 84 03 00 00       	jmp    1029cf <__alltraps>

0010264b <vector181>:
.globl vector181
vector181:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $181
  10264d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102652:	e9 78 03 00 00       	jmp    1029cf <__alltraps>

00102657 <vector182>:
.globl vector182
vector182:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $182
  102659:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10265e:	e9 6c 03 00 00       	jmp    1029cf <__alltraps>

00102663 <vector183>:
.globl vector183
vector183:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $183
  102665:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10266a:	e9 60 03 00 00       	jmp    1029cf <__alltraps>

0010266f <vector184>:
.globl vector184
vector184:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $184
  102671:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102676:	e9 54 03 00 00       	jmp    1029cf <__alltraps>

0010267b <vector185>:
.globl vector185
vector185:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $185
  10267d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102682:	e9 48 03 00 00       	jmp    1029cf <__alltraps>

00102687 <vector186>:
.globl vector186
vector186:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $186
  102689:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10268e:	e9 3c 03 00 00       	jmp    1029cf <__alltraps>

00102693 <vector187>:
.globl vector187
vector187:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $187
  102695:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10269a:	e9 30 03 00 00       	jmp    1029cf <__alltraps>

0010269f <vector188>:
.globl vector188
vector188:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $188
  1026a1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026a6:	e9 24 03 00 00       	jmp    1029cf <__alltraps>

001026ab <vector189>:
.globl vector189
vector189:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $189
  1026ad:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026b2:	e9 18 03 00 00       	jmp    1029cf <__alltraps>

001026b7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $190
  1026b9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026be:	e9 0c 03 00 00       	jmp    1029cf <__alltraps>

001026c3 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $191
  1026c5:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026ca:	e9 00 03 00 00       	jmp    1029cf <__alltraps>

001026cf <vector192>:
.globl vector192
vector192:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $192
  1026d1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026d6:	e9 f4 02 00 00       	jmp    1029cf <__alltraps>

001026db <vector193>:
.globl vector193
vector193:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $193
  1026dd:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026e2:	e9 e8 02 00 00       	jmp    1029cf <__alltraps>

001026e7 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $194
  1026e9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026ee:	e9 dc 02 00 00       	jmp    1029cf <__alltraps>

001026f3 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $195
  1026f5:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026fa:	e9 d0 02 00 00       	jmp    1029cf <__alltraps>

001026ff <vector196>:
.globl vector196
vector196:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $196
  102701:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102706:	e9 c4 02 00 00       	jmp    1029cf <__alltraps>

0010270b <vector197>:
.globl vector197
vector197:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $197
  10270d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102712:	e9 b8 02 00 00       	jmp    1029cf <__alltraps>

00102717 <vector198>:
.globl vector198
vector198:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $198
  102719:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10271e:	e9 ac 02 00 00       	jmp    1029cf <__alltraps>

00102723 <vector199>:
.globl vector199
vector199:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $199
  102725:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10272a:	e9 a0 02 00 00       	jmp    1029cf <__alltraps>

0010272f <vector200>:
.globl vector200
vector200:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $200
  102731:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102736:	e9 94 02 00 00       	jmp    1029cf <__alltraps>

0010273b <vector201>:
.globl vector201
vector201:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $201
  10273d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102742:	e9 88 02 00 00       	jmp    1029cf <__alltraps>

00102747 <vector202>:
.globl vector202
vector202:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $202
  102749:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10274e:	e9 7c 02 00 00       	jmp    1029cf <__alltraps>

00102753 <vector203>:
.globl vector203
vector203:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $203
  102755:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10275a:	e9 70 02 00 00       	jmp    1029cf <__alltraps>

0010275f <vector204>:
.globl vector204
vector204:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $204
  102761:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102766:	e9 64 02 00 00       	jmp    1029cf <__alltraps>

0010276b <vector205>:
.globl vector205
vector205:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $205
  10276d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102772:	e9 58 02 00 00       	jmp    1029cf <__alltraps>

00102777 <vector206>:
.globl vector206
vector206:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $206
  102779:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10277e:	e9 4c 02 00 00       	jmp    1029cf <__alltraps>

00102783 <vector207>:
.globl vector207
vector207:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $207
  102785:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10278a:	e9 40 02 00 00       	jmp    1029cf <__alltraps>

0010278f <vector208>:
.globl vector208
vector208:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $208
  102791:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102796:	e9 34 02 00 00       	jmp    1029cf <__alltraps>

0010279b <vector209>:
.globl vector209
vector209:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $209
  10279d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027a2:	e9 28 02 00 00       	jmp    1029cf <__alltraps>

001027a7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $210
  1027a9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027ae:	e9 1c 02 00 00       	jmp    1029cf <__alltraps>

001027b3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $211
  1027b5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027ba:	e9 10 02 00 00       	jmp    1029cf <__alltraps>

001027bf <vector212>:
.globl vector212
vector212:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $212
  1027c1:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027c6:	e9 04 02 00 00       	jmp    1029cf <__alltraps>

001027cb <vector213>:
.globl vector213
vector213:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $213
  1027cd:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027d2:	e9 f8 01 00 00       	jmp    1029cf <__alltraps>

001027d7 <vector214>:
.globl vector214
vector214:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $214
  1027d9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027de:	e9 ec 01 00 00       	jmp    1029cf <__alltraps>

001027e3 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $215
  1027e5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027ea:	e9 e0 01 00 00       	jmp    1029cf <__alltraps>

001027ef <vector216>:
.globl vector216
vector216:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $216
  1027f1:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027f6:	e9 d4 01 00 00       	jmp    1029cf <__alltraps>

001027fb <vector217>:
.globl vector217
vector217:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $217
  1027fd:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102802:	e9 c8 01 00 00       	jmp    1029cf <__alltraps>

00102807 <vector218>:
.globl vector218
vector218:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $218
  102809:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10280e:	e9 bc 01 00 00       	jmp    1029cf <__alltraps>

00102813 <vector219>:
.globl vector219
vector219:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $219
  102815:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10281a:	e9 b0 01 00 00       	jmp    1029cf <__alltraps>

0010281f <vector220>:
.globl vector220
vector220:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $220
  102821:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102826:	e9 a4 01 00 00       	jmp    1029cf <__alltraps>

0010282b <vector221>:
.globl vector221
vector221:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $221
  10282d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102832:	e9 98 01 00 00       	jmp    1029cf <__alltraps>

00102837 <vector222>:
.globl vector222
vector222:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $222
  102839:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10283e:	e9 8c 01 00 00       	jmp    1029cf <__alltraps>

00102843 <vector223>:
.globl vector223
vector223:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $223
  102845:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10284a:	e9 80 01 00 00       	jmp    1029cf <__alltraps>

0010284f <vector224>:
.globl vector224
vector224:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $224
  102851:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102856:	e9 74 01 00 00       	jmp    1029cf <__alltraps>

0010285b <vector225>:
.globl vector225
vector225:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $225
  10285d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102862:	e9 68 01 00 00       	jmp    1029cf <__alltraps>

00102867 <vector226>:
.globl vector226
vector226:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $226
  102869:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10286e:	e9 5c 01 00 00       	jmp    1029cf <__alltraps>

00102873 <vector227>:
.globl vector227
vector227:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $227
  102875:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10287a:	e9 50 01 00 00       	jmp    1029cf <__alltraps>

0010287f <vector228>:
.globl vector228
vector228:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $228
  102881:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102886:	e9 44 01 00 00       	jmp    1029cf <__alltraps>

0010288b <vector229>:
.globl vector229
vector229:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $229
  10288d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102892:	e9 38 01 00 00       	jmp    1029cf <__alltraps>

00102897 <vector230>:
.globl vector230
vector230:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $230
  102899:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10289e:	e9 2c 01 00 00       	jmp    1029cf <__alltraps>

001028a3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $231
  1028a5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028aa:	e9 20 01 00 00       	jmp    1029cf <__alltraps>

001028af <vector232>:
.globl vector232
vector232:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $232
  1028b1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028b6:	e9 14 01 00 00       	jmp    1029cf <__alltraps>

001028bb <vector233>:
.globl vector233
vector233:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $233
  1028bd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028c2:	e9 08 01 00 00       	jmp    1029cf <__alltraps>

001028c7 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $234
  1028c9:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028ce:	e9 fc 00 00 00       	jmp    1029cf <__alltraps>

001028d3 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $235
  1028d5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028da:	e9 f0 00 00 00       	jmp    1029cf <__alltraps>

001028df <vector236>:
.globl vector236
vector236:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $236
  1028e1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028e6:	e9 e4 00 00 00       	jmp    1029cf <__alltraps>

001028eb <vector237>:
.globl vector237
vector237:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $237
  1028ed:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028f2:	e9 d8 00 00 00       	jmp    1029cf <__alltraps>

001028f7 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $238
  1028f9:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028fe:	e9 cc 00 00 00       	jmp    1029cf <__alltraps>

00102903 <vector239>:
.globl vector239
vector239:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $239
  102905:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10290a:	e9 c0 00 00 00       	jmp    1029cf <__alltraps>

0010290f <vector240>:
.globl vector240
vector240:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $240
  102911:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102916:	e9 b4 00 00 00       	jmp    1029cf <__alltraps>

0010291b <vector241>:
.globl vector241
vector241:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $241
  10291d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102922:	e9 a8 00 00 00       	jmp    1029cf <__alltraps>

00102927 <vector242>:
.globl vector242
vector242:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $242
  102929:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10292e:	e9 9c 00 00 00       	jmp    1029cf <__alltraps>

00102933 <vector243>:
.globl vector243
vector243:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $243
  102935:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10293a:	e9 90 00 00 00       	jmp    1029cf <__alltraps>

0010293f <vector244>:
.globl vector244
vector244:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $244
  102941:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102946:	e9 84 00 00 00       	jmp    1029cf <__alltraps>

0010294b <vector245>:
.globl vector245
vector245:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $245
  10294d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102952:	e9 78 00 00 00       	jmp    1029cf <__alltraps>

00102957 <vector246>:
.globl vector246
vector246:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $246
  102959:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10295e:	e9 6c 00 00 00       	jmp    1029cf <__alltraps>

00102963 <vector247>:
.globl vector247
vector247:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $247
  102965:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10296a:	e9 60 00 00 00       	jmp    1029cf <__alltraps>

0010296f <vector248>:
.globl vector248
vector248:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $248
  102971:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102976:	e9 54 00 00 00       	jmp    1029cf <__alltraps>

0010297b <vector249>:
.globl vector249
vector249:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $249
  10297d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102982:	e9 48 00 00 00       	jmp    1029cf <__alltraps>

00102987 <vector250>:
.globl vector250
vector250:
  pushl $0
  102987:	6a 00                	push   $0x0
  pushl $250
  102989:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10298e:	e9 3c 00 00 00       	jmp    1029cf <__alltraps>

00102993 <vector251>:
.globl vector251
vector251:
  pushl $0
  102993:	6a 00                	push   $0x0
  pushl $251
  102995:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10299a:	e9 30 00 00 00       	jmp    1029cf <__alltraps>

0010299f <vector252>:
.globl vector252
vector252:
  pushl $0
  10299f:	6a 00                	push   $0x0
  pushl $252
  1029a1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029a6:	e9 24 00 00 00       	jmp    1029cf <__alltraps>

001029ab <vector253>:
.globl vector253
vector253:
  pushl $0
  1029ab:	6a 00                	push   $0x0
  pushl $253
  1029ad:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029b2:	e9 18 00 00 00       	jmp    1029cf <__alltraps>

001029b7 <vector254>:
.globl vector254
vector254:
  pushl $0
  1029b7:	6a 00                	push   $0x0
  pushl $254
  1029b9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029be:	e9 0c 00 00 00       	jmp    1029cf <__alltraps>

001029c3 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029c3:	6a 00                	push   $0x0
  pushl $255
  1029c5:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029ca:	e9 00 00 00 00       	jmp    1029cf <__alltraps>

001029cf <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029cf:	1e                   	push   %ds
    pushl %es
  1029d0:	06                   	push   %es
    pushl %fs
  1029d1:	0f a0                	push   %fs
    pushl %gs
  1029d3:	0f a8                	push   %gs
    pushal
  1029d5:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029d6:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1029db:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1029dd:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1029df:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1029e0:	e8 63 f5 ff ff       	call   101f48 <trap>

    # pop the pushed stack pointer
    popl %esp
  1029e5:	5c                   	pop    %esp

001029e6 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1029e6:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1029e7:	0f a9                	pop    %gs
    popl %fs
  1029e9:	0f a1                	pop    %fs
    popl %es
  1029eb:	07                   	pop    %es
    popl %ds
  1029ec:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029ed:	83 c4 08             	add    $0x8,%esp
    iret
  1029f0:	cf                   	iret   

001029f1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029f1:	55                   	push   %ebp
  1029f2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029fa:	b8 23 00 00 00       	mov    $0x23,%eax
  1029ff:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a01:	b8 23 00 00 00       	mov    $0x23,%eax
  102a06:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a08:	b8 10 00 00 00       	mov    $0x10,%eax
  102a0d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a0f:	b8 10 00 00 00       	mov    $0x10,%eax
  102a14:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a16:	b8 10 00 00 00       	mov    $0x10,%eax
  102a1b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a1d:	ea 24 2a 10 00 08 00 	ljmp   $0x8,$0x102a24
}
  102a24:	90                   	nop
  102a25:	5d                   	pop    %ebp
  102a26:	c3                   	ret    

00102a27 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a27:	55                   	push   %ebp
  102a28:	89 e5                	mov    %esp,%ebp
  102a2a:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a2d:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  102a32:	05 00 04 00 00       	add    $0x400,%eax
  102a37:	a3 c4 f8 10 00       	mov    %eax,0x10f8c4
    ts.ts_ss0 = KERNEL_DS;
  102a3c:	66 c7 05 c8 f8 10 00 	movw   $0x10,0x10f8c8
  102a43:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a45:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102a4c:	68 00 
  102a4e:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102a53:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102a59:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102a5e:	c1 e8 10             	shr    $0x10,%eax
  102a61:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102a66:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a6d:	83 e0 f0             	and    $0xfffffff0,%eax
  102a70:	83 c8 09             	or     $0x9,%eax
  102a73:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a78:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a7f:	83 c8 10             	or     $0x10,%eax
  102a82:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a87:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a8e:	83 e0 9f             	and    $0xffffff9f,%eax
  102a91:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a96:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a9d:	83 c8 80             	or     $0xffffff80,%eax
  102aa0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102aa5:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aac:	83 e0 f0             	and    $0xfffffff0,%eax
  102aaf:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ab4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102abb:	83 e0 ef             	and    $0xffffffef,%eax
  102abe:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ac3:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aca:	83 e0 df             	and    $0xffffffdf,%eax
  102acd:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ad2:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102ad9:	83 c8 40             	or     $0x40,%eax
  102adc:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ae1:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102ae8:	83 e0 7f             	and    $0x7f,%eax
  102aeb:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102af0:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102af5:	c1 e8 18             	shr    $0x18,%eax
  102af8:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102afd:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b04:	83 e0 ef             	and    $0xffffffef,%eax
  102b07:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102b0c:	68 10 ea 10 00       	push   $0x10ea10
  102b11:	e8 db fe ff ff       	call   1029f1 <lgdt>
  102b16:	83 c4 04             	add    $0x4,%esp
  102b19:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102b1f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b23:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b26:	90                   	nop
  102b27:	c9                   	leave  
  102b28:	c3                   	ret    

00102b29 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b29:	55                   	push   %ebp
  102b2a:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b2c:	e8 f6 fe ff ff       	call   102a27 <gdt_init>
}
  102b31:	90                   	nop
  102b32:	5d                   	pop    %ebp
  102b33:	c3                   	ret    

00102b34 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102b34:	55                   	push   %ebp
  102b35:	89 e5                	mov    %esp,%ebp
  102b37:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102b41:	eb 04                	jmp    102b47 <strlen+0x13>
        cnt ++;
  102b43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102b47:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4a:	8d 50 01             	lea    0x1(%eax),%edx
  102b4d:	89 55 08             	mov    %edx,0x8(%ebp)
  102b50:	0f b6 00             	movzbl (%eax),%eax
  102b53:	84 c0                	test   %al,%al
  102b55:	75 ec                	jne    102b43 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b5a:	c9                   	leave  
  102b5b:	c3                   	ret    

00102b5c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102b5c:	55                   	push   %ebp
  102b5d:	89 e5                	mov    %esp,%ebp
  102b5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102b69:	eb 04                	jmp    102b6f <strnlen+0x13>
        cnt ++;
  102b6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b72:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102b75:	73 10                	jae    102b87 <strnlen+0x2b>
  102b77:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7a:	8d 50 01             	lea    0x1(%eax),%edx
  102b7d:	89 55 08             	mov    %edx,0x8(%ebp)
  102b80:	0f b6 00             	movzbl (%eax),%eax
  102b83:	84 c0                	test   %al,%al
  102b85:	75 e4                	jne    102b6b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b8a:	c9                   	leave  
  102b8b:	c3                   	ret    

00102b8c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102b8c:	55                   	push   %ebp
  102b8d:	89 e5                	mov    %esp,%ebp
  102b8f:	57                   	push   %edi
  102b90:	56                   	push   %esi
  102b91:	83 ec 20             	sub    $0x20,%esp
  102b94:	8b 45 08             	mov    0x8(%ebp),%eax
  102b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102ba0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba6:	89 d1                	mov    %edx,%ecx
  102ba8:	89 c2                	mov    %eax,%edx
  102baa:	89 ce                	mov    %ecx,%esi
  102bac:	89 d7                	mov    %edx,%edi
  102bae:	ac                   	lods   %ds:(%esi),%al
  102baf:	aa                   	stos   %al,%es:(%edi)
  102bb0:	84 c0                	test   %al,%al
  102bb2:	75 fa                	jne    102bae <strcpy+0x22>
  102bb4:	89 fa                	mov    %edi,%edx
  102bb6:	89 f1                	mov    %esi,%ecx
  102bb8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102bbb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102bc4:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102bc5:	83 c4 20             	add    $0x20,%esp
  102bc8:	5e                   	pop    %esi
  102bc9:	5f                   	pop    %edi
  102bca:	5d                   	pop    %ebp
  102bcb:	c3                   	ret    

00102bcc <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102bcc:	55                   	push   %ebp
  102bcd:	89 e5                	mov    %esp,%ebp
  102bcf:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102bd8:	eb 21                	jmp    102bfb <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bdd:	0f b6 10             	movzbl (%eax),%edx
  102be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102be3:	88 10                	mov    %dl,(%eax)
  102be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102be8:	0f b6 00             	movzbl (%eax),%eax
  102beb:	84 c0                	test   %al,%al
  102bed:	74 04                	je     102bf3 <strncpy+0x27>
            src ++;
  102bef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102bf3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102bf7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102bfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bff:	75 d9                	jne    102bda <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102c01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c04:	c9                   	leave  
  102c05:	c3                   	ret    

00102c06 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102c06:	55                   	push   %ebp
  102c07:	89 e5                	mov    %esp,%ebp
  102c09:	57                   	push   %edi
  102c0a:	56                   	push   %esi
  102c0b:	83 ec 20             	sub    $0x20,%esp
  102c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c20:	89 d1                	mov    %edx,%ecx
  102c22:	89 c2                	mov    %eax,%edx
  102c24:	89 ce                	mov    %ecx,%esi
  102c26:	89 d7                	mov    %edx,%edi
  102c28:	ac                   	lods   %ds:(%esi),%al
  102c29:	ae                   	scas   %es:(%edi),%al
  102c2a:	75 08                	jne    102c34 <strcmp+0x2e>
  102c2c:	84 c0                	test   %al,%al
  102c2e:	75 f8                	jne    102c28 <strcmp+0x22>
  102c30:	31 c0                	xor    %eax,%eax
  102c32:	eb 04                	jmp    102c38 <strcmp+0x32>
  102c34:	19 c0                	sbb    %eax,%eax
  102c36:	0c 01                	or     $0x1,%al
  102c38:	89 fa                	mov    %edi,%edx
  102c3a:	89 f1                	mov    %esi,%ecx
  102c3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c3f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102c42:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102c48:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102c49:	83 c4 20             	add    $0x20,%esp
  102c4c:	5e                   	pop    %esi
  102c4d:	5f                   	pop    %edi
  102c4e:	5d                   	pop    %ebp
  102c4f:	c3                   	ret    

00102c50 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102c50:	55                   	push   %ebp
  102c51:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c53:	eb 0c                	jmp    102c61 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102c55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102c59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c5d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c65:	74 1a                	je     102c81 <strncmp+0x31>
  102c67:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6a:	0f b6 00             	movzbl (%eax),%eax
  102c6d:	84 c0                	test   %al,%al
  102c6f:	74 10                	je     102c81 <strncmp+0x31>
  102c71:	8b 45 08             	mov    0x8(%ebp),%eax
  102c74:	0f b6 10             	movzbl (%eax),%edx
  102c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c7a:	0f b6 00             	movzbl (%eax),%eax
  102c7d:	38 c2                	cmp    %al,%dl
  102c7f:	74 d4                	je     102c55 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c85:	74 18                	je     102c9f <strncmp+0x4f>
  102c87:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8a:	0f b6 00             	movzbl (%eax),%eax
  102c8d:	0f b6 d0             	movzbl %al,%edx
  102c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c93:	0f b6 00             	movzbl (%eax),%eax
  102c96:	0f b6 c0             	movzbl %al,%eax
  102c99:	29 c2                	sub    %eax,%edx
  102c9b:	89 d0                	mov    %edx,%eax
  102c9d:	eb 05                	jmp    102ca4 <strncmp+0x54>
  102c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ca4:	5d                   	pop    %ebp
  102ca5:	c3                   	ret    

00102ca6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102ca6:	55                   	push   %ebp
  102ca7:	89 e5                	mov    %esp,%ebp
  102ca9:	83 ec 04             	sub    $0x4,%esp
  102cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  102caf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102cb2:	eb 14                	jmp    102cc8 <strchr+0x22>
        if (*s == c) {
  102cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb7:	0f b6 00             	movzbl (%eax),%eax
  102cba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102cbd:	75 05                	jne    102cc4 <strchr+0x1e>
            return (char *)s;
  102cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc2:	eb 13                	jmp    102cd7 <strchr+0x31>
        }
        s ++;
  102cc4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccb:	0f b6 00             	movzbl (%eax),%eax
  102cce:	84 c0                	test   %al,%al
  102cd0:	75 e2                	jne    102cb4 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102cd7:	c9                   	leave  
  102cd8:	c3                   	ret    

00102cd9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102cd9:	55                   	push   %ebp
  102cda:	89 e5                	mov    %esp,%ebp
  102cdc:	83 ec 04             	sub    $0x4,%esp
  102cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ce2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ce5:	eb 0f                	jmp    102cf6 <strfind+0x1d>
        if (*s == c) {
  102ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cea:	0f b6 00             	movzbl (%eax),%eax
  102ced:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102cf0:	74 10                	je     102d02 <strfind+0x29>
            break;
        }
        s ++;
  102cf2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf9:	0f b6 00             	movzbl (%eax),%eax
  102cfc:	84 c0                	test   %al,%al
  102cfe:	75 e7                	jne    102ce7 <strfind+0xe>
  102d00:	eb 01                	jmp    102d03 <strfind+0x2a>
        if (*s == c) {
            break;
  102d02:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d06:	c9                   	leave  
  102d07:	c3                   	ret    

00102d08 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102d08:	55                   	push   %ebp
  102d09:	89 e5                	mov    %esp,%ebp
  102d0b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102d0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102d15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102d1c:	eb 04                	jmp    102d22 <strtol+0x1a>
        s ++;
  102d1e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102d22:	8b 45 08             	mov    0x8(%ebp),%eax
  102d25:	0f b6 00             	movzbl (%eax),%eax
  102d28:	3c 20                	cmp    $0x20,%al
  102d2a:	74 f2                	je     102d1e <strtol+0x16>
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	0f b6 00             	movzbl (%eax),%eax
  102d32:	3c 09                	cmp    $0x9,%al
  102d34:	74 e8                	je     102d1e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102d36:	8b 45 08             	mov    0x8(%ebp),%eax
  102d39:	0f b6 00             	movzbl (%eax),%eax
  102d3c:	3c 2b                	cmp    $0x2b,%al
  102d3e:	75 06                	jne    102d46 <strtol+0x3e>
        s ++;
  102d40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d44:	eb 15                	jmp    102d5b <strtol+0x53>
    }
    else if (*s == '-') {
  102d46:	8b 45 08             	mov    0x8(%ebp),%eax
  102d49:	0f b6 00             	movzbl (%eax),%eax
  102d4c:	3c 2d                	cmp    $0x2d,%al
  102d4e:	75 0b                	jne    102d5b <strtol+0x53>
        s ++, neg = 1;
  102d50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d54:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d5f:	74 06                	je     102d67 <strtol+0x5f>
  102d61:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102d65:	75 24                	jne    102d8b <strtol+0x83>
  102d67:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6a:	0f b6 00             	movzbl (%eax),%eax
  102d6d:	3c 30                	cmp    $0x30,%al
  102d6f:	75 1a                	jne    102d8b <strtol+0x83>
  102d71:	8b 45 08             	mov    0x8(%ebp),%eax
  102d74:	83 c0 01             	add    $0x1,%eax
  102d77:	0f b6 00             	movzbl (%eax),%eax
  102d7a:	3c 78                	cmp    $0x78,%al
  102d7c:	75 0d                	jne    102d8b <strtol+0x83>
        s += 2, base = 16;
  102d7e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102d82:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102d89:	eb 2a                	jmp    102db5 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d8f:	75 17                	jne    102da8 <strtol+0xa0>
  102d91:	8b 45 08             	mov    0x8(%ebp),%eax
  102d94:	0f b6 00             	movzbl (%eax),%eax
  102d97:	3c 30                	cmp    $0x30,%al
  102d99:	75 0d                	jne    102da8 <strtol+0xa0>
        s ++, base = 8;
  102d9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102da6:	eb 0d                	jmp    102db5 <strtol+0xad>
    }
    else if (base == 0) {
  102da8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dac:	75 07                	jne    102db5 <strtol+0xad>
        base = 10;
  102dae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102db5:	8b 45 08             	mov    0x8(%ebp),%eax
  102db8:	0f b6 00             	movzbl (%eax),%eax
  102dbb:	3c 2f                	cmp    $0x2f,%al
  102dbd:	7e 1b                	jle    102dda <strtol+0xd2>
  102dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc2:	0f b6 00             	movzbl (%eax),%eax
  102dc5:	3c 39                	cmp    $0x39,%al
  102dc7:	7f 11                	jg     102dda <strtol+0xd2>
            dig = *s - '0';
  102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcc:	0f b6 00             	movzbl (%eax),%eax
  102dcf:	0f be c0             	movsbl %al,%eax
  102dd2:	83 e8 30             	sub    $0x30,%eax
  102dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dd8:	eb 48                	jmp    102e22 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102dda:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddd:	0f b6 00             	movzbl (%eax),%eax
  102de0:	3c 60                	cmp    $0x60,%al
  102de2:	7e 1b                	jle    102dff <strtol+0xf7>
  102de4:	8b 45 08             	mov    0x8(%ebp),%eax
  102de7:	0f b6 00             	movzbl (%eax),%eax
  102dea:	3c 7a                	cmp    $0x7a,%al
  102dec:	7f 11                	jg     102dff <strtol+0xf7>
            dig = *s - 'a' + 10;
  102dee:	8b 45 08             	mov    0x8(%ebp),%eax
  102df1:	0f b6 00             	movzbl (%eax),%eax
  102df4:	0f be c0             	movsbl %al,%eax
  102df7:	83 e8 57             	sub    $0x57,%eax
  102dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dfd:	eb 23                	jmp    102e22 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102dff:	8b 45 08             	mov    0x8(%ebp),%eax
  102e02:	0f b6 00             	movzbl (%eax),%eax
  102e05:	3c 40                	cmp    $0x40,%al
  102e07:	7e 3c                	jle    102e45 <strtol+0x13d>
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	0f b6 00             	movzbl (%eax),%eax
  102e0f:	3c 5a                	cmp    $0x5a,%al
  102e11:	7f 32                	jg     102e45 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102e13:	8b 45 08             	mov    0x8(%ebp),%eax
  102e16:	0f b6 00             	movzbl (%eax),%eax
  102e19:	0f be c0             	movsbl %al,%eax
  102e1c:	83 e8 37             	sub    $0x37,%eax
  102e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e25:	3b 45 10             	cmp    0x10(%ebp),%eax
  102e28:	7d 1a                	jge    102e44 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102e2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e31:	0f af 45 10          	imul   0x10(%ebp),%eax
  102e35:	89 c2                	mov    %eax,%edx
  102e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e3a:	01 d0                	add    %edx,%eax
  102e3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102e3f:	e9 71 ff ff ff       	jmp    102db5 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102e44:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102e45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e49:	74 08                	je     102e53 <strtol+0x14b>
        *endptr = (char *) s;
  102e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  102e51:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102e53:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102e57:	74 07                	je     102e60 <strtol+0x158>
  102e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e5c:	f7 d8                	neg    %eax
  102e5e:	eb 03                	jmp    102e63 <strtol+0x15b>
  102e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102e63:	c9                   	leave  
  102e64:	c3                   	ret    

00102e65 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102e65:	55                   	push   %ebp
  102e66:	89 e5                	mov    %esp,%ebp
  102e68:	57                   	push   %edi
  102e69:	83 ec 24             	sub    $0x24,%esp
  102e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e6f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102e72:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102e76:	8b 55 08             	mov    0x8(%ebp),%edx
  102e79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102e7c:	88 45 f7             	mov    %al,-0x9(%ebp)
  102e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  102e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102e85:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102e88:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102e8c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102e8f:	89 d7                	mov    %edx,%edi
  102e91:	f3 aa                	rep stos %al,%es:(%edi)
  102e93:	89 fa                	mov    %edi,%edx
  102e95:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e98:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e9e:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e9f:	83 c4 24             	add    $0x24,%esp
  102ea2:	5f                   	pop    %edi
  102ea3:	5d                   	pop    %ebp
  102ea4:	c3                   	ret    

00102ea5 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102ea5:	55                   	push   %ebp
  102ea6:	89 e5                	mov    %esp,%ebp
  102ea8:	57                   	push   %edi
  102ea9:	56                   	push   %esi
  102eaa:	53                   	push   %ebx
  102eab:	83 ec 30             	sub    $0x30,%esp
  102eae:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102eba:	8b 45 10             	mov    0x10(%ebp),%eax
  102ebd:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102ec6:	73 42                	jae    102f0a <memmove+0x65>
  102ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ecb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ed4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ed7:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102eda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102edd:	c1 e8 02             	shr    $0x2,%eax
  102ee0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102ee2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ee8:	89 d7                	mov    %edx,%edi
  102eea:	89 c6                	mov    %eax,%esi
  102eec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102eee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102ef1:	83 e1 03             	and    $0x3,%ecx
  102ef4:	74 02                	je     102ef8 <memmove+0x53>
  102ef6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ef8:	89 f0                	mov    %esi,%eax
  102efa:	89 fa                	mov    %edi,%edx
  102efc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102eff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f02:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102f05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102f08:	eb 36                	jmp    102f40 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102f0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f13:	01 c2                	add    %eax,%edx
  102f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f18:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f1e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f24:	89 c1                	mov    %eax,%ecx
  102f26:	89 d8                	mov    %ebx,%eax
  102f28:	89 d6                	mov    %edx,%esi
  102f2a:	89 c7                	mov    %eax,%edi
  102f2c:	fd                   	std    
  102f2d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f2f:	fc                   	cld    
  102f30:	89 f8                	mov    %edi,%eax
  102f32:	89 f2                	mov    %esi,%edx
  102f34:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102f37:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102f3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102f40:	83 c4 30             	add    $0x30,%esp
  102f43:	5b                   	pop    %ebx
  102f44:	5e                   	pop    %esi
  102f45:	5f                   	pop    %edi
  102f46:	5d                   	pop    %ebp
  102f47:	c3                   	ret    

00102f48 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102f48:	55                   	push   %ebp
  102f49:	89 e5                	mov    %esp,%ebp
  102f4b:	57                   	push   %edi
  102f4c:	56                   	push   %esi
  102f4d:	83 ec 20             	sub    $0x20,%esp
  102f50:	8b 45 08             	mov    0x8(%ebp),%eax
  102f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f65:	c1 e8 02             	shr    $0x2,%eax
  102f68:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f70:	89 d7                	mov    %edx,%edi
  102f72:	89 c6                	mov    %eax,%esi
  102f74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f76:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102f79:	83 e1 03             	and    $0x3,%ecx
  102f7c:	74 02                	je     102f80 <memcpy+0x38>
  102f7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f80:	89 f0                	mov    %esi,%eax
  102f82:	89 fa                	mov    %edi,%edx
  102f84:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f87:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102f90:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102f91:	83 c4 20             	add    $0x20,%esp
  102f94:	5e                   	pop    %esi
  102f95:	5f                   	pop    %edi
  102f96:	5d                   	pop    %ebp
  102f97:	c3                   	ret    

00102f98 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102f98:	55                   	push   %ebp
  102f99:	89 e5                	mov    %esp,%ebp
  102f9b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102faa:	eb 30                	jmp    102fdc <memcmp+0x44>
        if (*s1 != *s2) {
  102fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102faf:	0f b6 10             	movzbl (%eax),%edx
  102fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fb5:	0f b6 00             	movzbl (%eax),%eax
  102fb8:	38 c2                	cmp    %al,%dl
  102fba:	74 18                	je     102fd4 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fbf:	0f b6 00             	movzbl (%eax),%eax
  102fc2:	0f b6 d0             	movzbl %al,%edx
  102fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fc8:	0f b6 00             	movzbl (%eax),%eax
  102fcb:	0f b6 c0             	movzbl %al,%eax
  102fce:	29 c2                	sub    %eax,%edx
  102fd0:	89 d0                	mov    %edx,%eax
  102fd2:	eb 1a                	jmp    102fee <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102fd4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102fd8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  102fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fe2:	89 55 10             	mov    %edx,0x10(%ebp)
  102fe5:	85 c0                	test   %eax,%eax
  102fe7:	75 c3                	jne    102fac <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fee:	c9                   	leave  
  102fef:	c3                   	ret    

00102ff0 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102ff0:	55                   	push   %ebp
  102ff1:	89 e5                	mov    %esp,%ebp
  102ff3:	83 ec 38             	sub    $0x38,%esp
  102ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  102ff9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ffc:	8b 45 14             	mov    0x14(%ebp),%eax
  102fff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103002:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103005:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103008:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10300b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10300e:	8b 45 18             	mov    0x18(%ebp),%eax
  103011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103017:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10301a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10301d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103023:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10302a:	74 1c                	je     103048 <printnum+0x58>
  10302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10302f:	ba 00 00 00 00       	mov    $0x0,%edx
  103034:	f7 75 e4             	divl   -0x1c(%ebp)
  103037:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10303d:	ba 00 00 00 00       	mov    $0x0,%edx
  103042:	f7 75 e4             	divl   -0x1c(%ebp)
  103045:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10304b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10304e:	f7 75 e4             	divl   -0x1c(%ebp)
  103051:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103054:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103057:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10305a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10305d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103060:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103063:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103066:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103069:	8b 45 18             	mov    0x18(%ebp),%eax
  10306c:	ba 00 00 00 00       	mov    $0x0,%edx
  103071:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103074:	77 41                	ja     1030b7 <printnum+0xc7>
  103076:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103079:	72 05                	jb     103080 <printnum+0x90>
  10307b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10307e:	77 37                	ja     1030b7 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  103080:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103083:	83 e8 01             	sub    $0x1,%eax
  103086:	83 ec 04             	sub    $0x4,%esp
  103089:	ff 75 20             	pushl  0x20(%ebp)
  10308c:	50                   	push   %eax
  10308d:	ff 75 18             	pushl  0x18(%ebp)
  103090:	ff 75 ec             	pushl  -0x14(%ebp)
  103093:	ff 75 e8             	pushl  -0x18(%ebp)
  103096:	ff 75 0c             	pushl  0xc(%ebp)
  103099:	ff 75 08             	pushl  0x8(%ebp)
  10309c:	e8 4f ff ff ff       	call   102ff0 <printnum>
  1030a1:	83 c4 20             	add    $0x20,%esp
  1030a4:	eb 1b                	jmp    1030c1 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1030a6:	83 ec 08             	sub    $0x8,%esp
  1030a9:	ff 75 0c             	pushl  0xc(%ebp)
  1030ac:	ff 75 20             	pushl  0x20(%ebp)
  1030af:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b2:	ff d0                	call   *%eax
  1030b4:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1030b7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1030bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1030bf:	7f e5                	jg     1030a6 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1030c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1030c4:	05 d0 3d 10 00       	add    $0x103dd0,%eax
  1030c9:	0f b6 00             	movzbl (%eax),%eax
  1030cc:	0f be c0             	movsbl %al,%eax
  1030cf:	83 ec 08             	sub    $0x8,%esp
  1030d2:	ff 75 0c             	pushl  0xc(%ebp)
  1030d5:	50                   	push   %eax
  1030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d9:	ff d0                	call   *%eax
  1030db:	83 c4 10             	add    $0x10,%esp
}
  1030de:	90                   	nop
  1030df:	c9                   	leave  
  1030e0:	c3                   	ret    

001030e1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1030e1:	55                   	push   %ebp
  1030e2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1030e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1030e8:	7e 14                	jle    1030fe <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ed:	8b 00                	mov    (%eax),%eax
  1030ef:	8d 48 08             	lea    0x8(%eax),%ecx
  1030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1030f5:	89 0a                	mov    %ecx,(%edx)
  1030f7:	8b 50 04             	mov    0x4(%eax),%edx
  1030fa:	8b 00                	mov    (%eax),%eax
  1030fc:	eb 30                	jmp    10312e <getuint+0x4d>
    }
    else if (lflag) {
  1030fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103102:	74 16                	je     10311a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103104:	8b 45 08             	mov    0x8(%ebp),%eax
  103107:	8b 00                	mov    (%eax),%eax
  103109:	8d 48 04             	lea    0x4(%eax),%ecx
  10310c:	8b 55 08             	mov    0x8(%ebp),%edx
  10310f:	89 0a                	mov    %ecx,(%edx)
  103111:	8b 00                	mov    (%eax),%eax
  103113:	ba 00 00 00 00       	mov    $0x0,%edx
  103118:	eb 14                	jmp    10312e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10311a:	8b 45 08             	mov    0x8(%ebp),%eax
  10311d:	8b 00                	mov    (%eax),%eax
  10311f:	8d 48 04             	lea    0x4(%eax),%ecx
  103122:	8b 55 08             	mov    0x8(%ebp),%edx
  103125:	89 0a                	mov    %ecx,(%edx)
  103127:	8b 00                	mov    (%eax),%eax
  103129:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10312e:	5d                   	pop    %ebp
  10312f:	c3                   	ret    

00103130 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103130:	55                   	push   %ebp
  103131:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103133:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103137:	7e 14                	jle    10314d <getint+0x1d>
        return va_arg(*ap, long long);
  103139:	8b 45 08             	mov    0x8(%ebp),%eax
  10313c:	8b 00                	mov    (%eax),%eax
  10313e:	8d 48 08             	lea    0x8(%eax),%ecx
  103141:	8b 55 08             	mov    0x8(%ebp),%edx
  103144:	89 0a                	mov    %ecx,(%edx)
  103146:	8b 50 04             	mov    0x4(%eax),%edx
  103149:	8b 00                	mov    (%eax),%eax
  10314b:	eb 28                	jmp    103175 <getint+0x45>
    }
    else if (lflag) {
  10314d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103151:	74 12                	je     103165 <getint+0x35>
        return va_arg(*ap, long);
  103153:	8b 45 08             	mov    0x8(%ebp),%eax
  103156:	8b 00                	mov    (%eax),%eax
  103158:	8d 48 04             	lea    0x4(%eax),%ecx
  10315b:	8b 55 08             	mov    0x8(%ebp),%edx
  10315e:	89 0a                	mov    %ecx,(%edx)
  103160:	8b 00                	mov    (%eax),%eax
  103162:	99                   	cltd   
  103163:	eb 10                	jmp    103175 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  103165:	8b 45 08             	mov    0x8(%ebp),%eax
  103168:	8b 00                	mov    (%eax),%eax
  10316a:	8d 48 04             	lea    0x4(%eax),%ecx
  10316d:	8b 55 08             	mov    0x8(%ebp),%edx
  103170:	89 0a                	mov    %ecx,(%edx)
  103172:	8b 00                	mov    (%eax),%eax
  103174:	99                   	cltd   
    }
}
  103175:	5d                   	pop    %ebp
  103176:	c3                   	ret    

00103177 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103177:	55                   	push   %ebp
  103178:	89 e5                	mov    %esp,%ebp
  10317a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  10317d:	8d 45 14             	lea    0x14(%ebp),%eax
  103180:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103186:	50                   	push   %eax
  103187:	ff 75 10             	pushl  0x10(%ebp)
  10318a:	ff 75 0c             	pushl  0xc(%ebp)
  10318d:	ff 75 08             	pushl  0x8(%ebp)
  103190:	e8 06 00 00 00       	call   10319b <vprintfmt>
  103195:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  103198:	90                   	nop
  103199:	c9                   	leave  
  10319a:	c3                   	ret    

0010319b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10319b:	55                   	push   %ebp
  10319c:	89 e5                	mov    %esp,%ebp
  10319e:	56                   	push   %esi
  10319f:	53                   	push   %ebx
  1031a0:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1031a3:	eb 17                	jmp    1031bc <vprintfmt+0x21>
            if (ch == '\0') {
  1031a5:	85 db                	test   %ebx,%ebx
  1031a7:	0f 84 8e 03 00 00    	je     10353b <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1031ad:	83 ec 08             	sub    $0x8,%esp
  1031b0:	ff 75 0c             	pushl  0xc(%ebp)
  1031b3:	53                   	push   %ebx
  1031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b7:	ff d0                	call   *%eax
  1031b9:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1031bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1031bf:	8d 50 01             	lea    0x1(%eax),%edx
  1031c2:	89 55 10             	mov    %edx,0x10(%ebp)
  1031c5:	0f b6 00             	movzbl (%eax),%eax
  1031c8:	0f b6 d8             	movzbl %al,%ebx
  1031cb:	83 fb 25             	cmp    $0x25,%ebx
  1031ce:	75 d5                	jne    1031a5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1031d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1031d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1031db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1031e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1031e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1031ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1031f1:	8d 50 01             	lea    0x1(%eax),%edx
  1031f4:	89 55 10             	mov    %edx,0x10(%ebp)
  1031f7:	0f b6 00             	movzbl (%eax),%eax
  1031fa:	0f b6 d8             	movzbl %al,%ebx
  1031fd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103200:	83 f8 55             	cmp    $0x55,%eax
  103203:	0f 87 05 03 00 00    	ja     10350e <vprintfmt+0x373>
  103209:	8b 04 85 f4 3d 10 00 	mov    0x103df4(,%eax,4),%eax
  103210:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103212:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103216:	eb d6                	jmp    1031ee <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103218:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10321c:	eb d0                	jmp    1031ee <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10321e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103225:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103228:	89 d0                	mov    %edx,%eax
  10322a:	c1 e0 02             	shl    $0x2,%eax
  10322d:	01 d0                	add    %edx,%eax
  10322f:	01 c0                	add    %eax,%eax
  103231:	01 d8                	add    %ebx,%eax
  103233:	83 e8 30             	sub    $0x30,%eax
  103236:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103239:	8b 45 10             	mov    0x10(%ebp),%eax
  10323c:	0f b6 00             	movzbl (%eax),%eax
  10323f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103242:	83 fb 2f             	cmp    $0x2f,%ebx
  103245:	7e 39                	jle    103280 <vprintfmt+0xe5>
  103247:	83 fb 39             	cmp    $0x39,%ebx
  10324a:	7f 34                	jg     103280 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10324c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  103250:	eb d3                	jmp    103225 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103252:	8b 45 14             	mov    0x14(%ebp),%eax
  103255:	8d 50 04             	lea    0x4(%eax),%edx
  103258:	89 55 14             	mov    %edx,0x14(%ebp)
  10325b:	8b 00                	mov    (%eax),%eax
  10325d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103260:	eb 1f                	jmp    103281 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  103262:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103266:	79 86                	jns    1031ee <vprintfmt+0x53>
                width = 0;
  103268:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10326f:	e9 7a ff ff ff       	jmp    1031ee <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103274:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10327b:	e9 6e ff ff ff       	jmp    1031ee <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  103280:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103281:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103285:	0f 89 63 ff ff ff    	jns    1031ee <vprintfmt+0x53>
                width = precision, precision = -1;
  10328b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10328e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103291:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103298:	e9 51 ff ff ff       	jmp    1031ee <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10329d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1032a1:	e9 48 ff ff ff       	jmp    1031ee <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1032a6:	8b 45 14             	mov    0x14(%ebp),%eax
  1032a9:	8d 50 04             	lea    0x4(%eax),%edx
  1032ac:	89 55 14             	mov    %edx,0x14(%ebp)
  1032af:	8b 00                	mov    (%eax),%eax
  1032b1:	83 ec 08             	sub    $0x8,%esp
  1032b4:	ff 75 0c             	pushl  0xc(%ebp)
  1032b7:	50                   	push   %eax
  1032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bb:	ff d0                	call   *%eax
  1032bd:	83 c4 10             	add    $0x10,%esp
            break;
  1032c0:	e9 71 02 00 00       	jmp    103536 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1032c5:	8b 45 14             	mov    0x14(%ebp),%eax
  1032c8:	8d 50 04             	lea    0x4(%eax),%edx
  1032cb:	89 55 14             	mov    %edx,0x14(%ebp)
  1032ce:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1032d0:	85 db                	test   %ebx,%ebx
  1032d2:	79 02                	jns    1032d6 <vprintfmt+0x13b>
                err = -err;
  1032d4:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1032d6:	83 fb 06             	cmp    $0x6,%ebx
  1032d9:	7f 0b                	jg     1032e6 <vprintfmt+0x14b>
  1032db:	8b 34 9d b4 3d 10 00 	mov    0x103db4(,%ebx,4),%esi
  1032e2:	85 f6                	test   %esi,%esi
  1032e4:	75 19                	jne    1032ff <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  1032e6:	53                   	push   %ebx
  1032e7:	68 e1 3d 10 00       	push   $0x103de1
  1032ec:	ff 75 0c             	pushl  0xc(%ebp)
  1032ef:	ff 75 08             	pushl  0x8(%ebp)
  1032f2:	e8 80 fe ff ff       	call   103177 <printfmt>
  1032f7:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1032fa:	e9 37 02 00 00       	jmp    103536 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1032ff:	56                   	push   %esi
  103300:	68 ea 3d 10 00       	push   $0x103dea
  103305:	ff 75 0c             	pushl  0xc(%ebp)
  103308:	ff 75 08             	pushl  0x8(%ebp)
  10330b:	e8 67 fe ff ff       	call   103177 <printfmt>
  103310:	83 c4 10             	add    $0x10,%esp
            }
            break;
  103313:	e9 1e 02 00 00       	jmp    103536 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103318:	8b 45 14             	mov    0x14(%ebp),%eax
  10331b:	8d 50 04             	lea    0x4(%eax),%edx
  10331e:	89 55 14             	mov    %edx,0x14(%ebp)
  103321:	8b 30                	mov    (%eax),%esi
  103323:	85 f6                	test   %esi,%esi
  103325:	75 05                	jne    10332c <vprintfmt+0x191>
                p = "(null)";
  103327:	be ed 3d 10 00       	mov    $0x103ded,%esi
            }
            if (width > 0 && padc != '-') {
  10332c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103330:	7e 76                	jle    1033a8 <vprintfmt+0x20d>
  103332:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103336:	74 70                	je     1033a8 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10333b:	83 ec 08             	sub    $0x8,%esp
  10333e:	50                   	push   %eax
  10333f:	56                   	push   %esi
  103340:	e8 17 f8 ff ff       	call   102b5c <strnlen>
  103345:	83 c4 10             	add    $0x10,%esp
  103348:	89 c2                	mov    %eax,%edx
  10334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10334d:	29 d0                	sub    %edx,%eax
  10334f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103352:	eb 17                	jmp    10336b <vprintfmt+0x1d0>
                    putch(padc, putdat);
  103354:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103358:	83 ec 08             	sub    $0x8,%esp
  10335b:	ff 75 0c             	pushl  0xc(%ebp)
  10335e:	50                   	push   %eax
  10335f:	8b 45 08             	mov    0x8(%ebp),%eax
  103362:	ff d0                	call   *%eax
  103364:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103367:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10336b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10336f:	7f e3                	jg     103354 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103371:	eb 35                	jmp    1033a8 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103373:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103377:	74 1c                	je     103395 <vprintfmt+0x1fa>
  103379:	83 fb 1f             	cmp    $0x1f,%ebx
  10337c:	7e 05                	jle    103383 <vprintfmt+0x1e8>
  10337e:	83 fb 7e             	cmp    $0x7e,%ebx
  103381:	7e 12                	jle    103395 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103383:	83 ec 08             	sub    $0x8,%esp
  103386:	ff 75 0c             	pushl  0xc(%ebp)
  103389:	6a 3f                	push   $0x3f
  10338b:	8b 45 08             	mov    0x8(%ebp),%eax
  10338e:	ff d0                	call   *%eax
  103390:	83 c4 10             	add    $0x10,%esp
  103393:	eb 0f                	jmp    1033a4 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103395:	83 ec 08             	sub    $0x8,%esp
  103398:	ff 75 0c             	pushl  0xc(%ebp)
  10339b:	53                   	push   %ebx
  10339c:	8b 45 08             	mov    0x8(%ebp),%eax
  10339f:	ff d0                	call   *%eax
  1033a1:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1033a4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1033a8:	89 f0                	mov    %esi,%eax
  1033aa:	8d 70 01             	lea    0x1(%eax),%esi
  1033ad:	0f b6 00             	movzbl (%eax),%eax
  1033b0:	0f be d8             	movsbl %al,%ebx
  1033b3:	85 db                	test   %ebx,%ebx
  1033b5:	74 26                	je     1033dd <vprintfmt+0x242>
  1033b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033bb:	78 b6                	js     103373 <vprintfmt+0x1d8>
  1033bd:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1033c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033c5:	79 ac                	jns    103373 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1033c7:	eb 14                	jmp    1033dd <vprintfmt+0x242>
                putch(' ', putdat);
  1033c9:	83 ec 08             	sub    $0x8,%esp
  1033cc:	ff 75 0c             	pushl  0xc(%ebp)
  1033cf:	6a 20                	push   $0x20
  1033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d4:	ff d0                	call   *%eax
  1033d6:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1033d9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1033dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033e1:	7f e6                	jg     1033c9 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  1033e3:	e9 4e 01 00 00       	jmp    103536 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1033e8:	83 ec 08             	sub    $0x8,%esp
  1033eb:	ff 75 e0             	pushl  -0x20(%ebp)
  1033ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1033f1:	50                   	push   %eax
  1033f2:	e8 39 fd ff ff       	call   103130 <getint>
  1033f7:	83 c4 10             	add    $0x10,%esp
  1033fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103406:	85 d2                	test   %edx,%edx
  103408:	79 23                	jns    10342d <vprintfmt+0x292>
                putch('-', putdat);
  10340a:	83 ec 08             	sub    $0x8,%esp
  10340d:	ff 75 0c             	pushl  0xc(%ebp)
  103410:	6a 2d                	push   $0x2d
  103412:	8b 45 08             	mov    0x8(%ebp),%eax
  103415:	ff d0                	call   *%eax
  103417:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10341a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10341d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103420:	f7 d8                	neg    %eax
  103422:	83 d2 00             	adc    $0x0,%edx
  103425:	f7 da                	neg    %edx
  103427:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10342a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10342d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103434:	e9 9f 00 00 00       	jmp    1034d8 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103439:	83 ec 08             	sub    $0x8,%esp
  10343c:	ff 75 e0             	pushl  -0x20(%ebp)
  10343f:	8d 45 14             	lea    0x14(%ebp),%eax
  103442:	50                   	push   %eax
  103443:	e8 99 fc ff ff       	call   1030e1 <getuint>
  103448:	83 c4 10             	add    $0x10,%esp
  10344b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10344e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103458:	eb 7e                	jmp    1034d8 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10345a:	83 ec 08             	sub    $0x8,%esp
  10345d:	ff 75 e0             	pushl  -0x20(%ebp)
  103460:	8d 45 14             	lea    0x14(%ebp),%eax
  103463:	50                   	push   %eax
  103464:	e8 78 fc ff ff       	call   1030e1 <getuint>
  103469:	83 c4 10             	add    $0x10,%esp
  10346c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10346f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103472:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103479:	eb 5d                	jmp    1034d8 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10347b:	83 ec 08             	sub    $0x8,%esp
  10347e:	ff 75 0c             	pushl  0xc(%ebp)
  103481:	6a 30                	push   $0x30
  103483:	8b 45 08             	mov    0x8(%ebp),%eax
  103486:	ff d0                	call   *%eax
  103488:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10348b:	83 ec 08             	sub    $0x8,%esp
  10348e:	ff 75 0c             	pushl  0xc(%ebp)
  103491:	6a 78                	push   $0x78
  103493:	8b 45 08             	mov    0x8(%ebp),%eax
  103496:	ff d0                	call   *%eax
  103498:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10349b:	8b 45 14             	mov    0x14(%ebp),%eax
  10349e:	8d 50 04             	lea    0x4(%eax),%edx
  1034a1:	89 55 14             	mov    %edx,0x14(%ebp)
  1034a4:	8b 00                	mov    (%eax),%eax
  1034a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1034b0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1034b7:	eb 1f                	jmp    1034d8 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1034b9:	83 ec 08             	sub    $0x8,%esp
  1034bc:	ff 75 e0             	pushl  -0x20(%ebp)
  1034bf:	8d 45 14             	lea    0x14(%ebp),%eax
  1034c2:	50                   	push   %eax
  1034c3:	e8 19 fc ff ff       	call   1030e1 <getuint>
  1034c8:	83 c4 10             	add    $0x10,%esp
  1034cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1034d1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1034d8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1034dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034df:	83 ec 04             	sub    $0x4,%esp
  1034e2:	52                   	push   %edx
  1034e3:	ff 75 e8             	pushl  -0x18(%ebp)
  1034e6:	50                   	push   %eax
  1034e7:	ff 75 f4             	pushl  -0xc(%ebp)
  1034ea:	ff 75 f0             	pushl  -0x10(%ebp)
  1034ed:	ff 75 0c             	pushl  0xc(%ebp)
  1034f0:	ff 75 08             	pushl  0x8(%ebp)
  1034f3:	e8 f8 fa ff ff       	call   102ff0 <printnum>
  1034f8:	83 c4 20             	add    $0x20,%esp
            break;
  1034fb:	eb 39                	jmp    103536 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1034fd:	83 ec 08             	sub    $0x8,%esp
  103500:	ff 75 0c             	pushl  0xc(%ebp)
  103503:	53                   	push   %ebx
  103504:	8b 45 08             	mov    0x8(%ebp),%eax
  103507:	ff d0                	call   *%eax
  103509:	83 c4 10             	add    $0x10,%esp
            break;
  10350c:	eb 28                	jmp    103536 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10350e:	83 ec 08             	sub    $0x8,%esp
  103511:	ff 75 0c             	pushl  0xc(%ebp)
  103514:	6a 25                	push   $0x25
  103516:	8b 45 08             	mov    0x8(%ebp),%eax
  103519:	ff d0                	call   *%eax
  10351b:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10351e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103522:	eb 04                	jmp    103528 <vprintfmt+0x38d>
  103524:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103528:	8b 45 10             	mov    0x10(%ebp),%eax
  10352b:	83 e8 01             	sub    $0x1,%eax
  10352e:	0f b6 00             	movzbl (%eax),%eax
  103531:	3c 25                	cmp    $0x25,%al
  103533:	75 ef                	jne    103524 <vprintfmt+0x389>
                /* do nothing */;
            break;
  103535:	90                   	nop
        }
    }
  103536:	e9 68 fc ff ff       	jmp    1031a3 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  10353b:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10353c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10353f:	5b                   	pop    %ebx
  103540:	5e                   	pop    %esi
  103541:	5d                   	pop    %ebp
  103542:	c3                   	ret    

00103543 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103543:	55                   	push   %ebp
  103544:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103546:	8b 45 0c             	mov    0xc(%ebp),%eax
  103549:	8b 40 08             	mov    0x8(%eax),%eax
  10354c:	8d 50 01             	lea    0x1(%eax),%edx
  10354f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103552:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103555:	8b 45 0c             	mov    0xc(%ebp),%eax
  103558:	8b 10                	mov    (%eax),%edx
  10355a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10355d:	8b 40 04             	mov    0x4(%eax),%eax
  103560:	39 c2                	cmp    %eax,%edx
  103562:	73 12                	jae    103576 <sprintputch+0x33>
        *b->buf ++ = ch;
  103564:	8b 45 0c             	mov    0xc(%ebp),%eax
  103567:	8b 00                	mov    (%eax),%eax
  103569:	8d 48 01             	lea    0x1(%eax),%ecx
  10356c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10356f:	89 0a                	mov    %ecx,(%edx)
  103571:	8b 55 08             	mov    0x8(%ebp),%edx
  103574:	88 10                	mov    %dl,(%eax)
    }
}
  103576:	90                   	nop
  103577:	5d                   	pop    %ebp
  103578:	c3                   	ret    

00103579 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103579:	55                   	push   %ebp
  10357a:	89 e5                	mov    %esp,%ebp
  10357c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10357f:	8d 45 14             	lea    0x14(%ebp),%eax
  103582:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103588:	50                   	push   %eax
  103589:	ff 75 10             	pushl  0x10(%ebp)
  10358c:	ff 75 0c             	pushl  0xc(%ebp)
  10358f:	ff 75 08             	pushl  0x8(%ebp)
  103592:	e8 0b 00 00 00       	call   1035a2 <vsnprintf>
  103597:	83 c4 10             	add    $0x10,%esp
  10359a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10359d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1035a0:	c9                   	leave  
  1035a1:	c3                   	ret    

001035a2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1035a2:	55                   	push   %ebp
  1035a3:	89 e5                	mov    %esp,%ebp
  1035a5:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b7:	01 d0                	add    %edx,%eax
  1035b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1035c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1035c7:	74 0a                	je     1035d3 <vsnprintf+0x31>
  1035c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1035cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035cf:	39 c2                	cmp    %eax,%edx
  1035d1:	76 07                	jbe    1035da <vsnprintf+0x38>
        return -E_INVAL;
  1035d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1035d8:	eb 20                	jmp    1035fa <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1035da:	ff 75 14             	pushl  0x14(%ebp)
  1035dd:	ff 75 10             	pushl  0x10(%ebp)
  1035e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1035e3:	50                   	push   %eax
  1035e4:	68 43 35 10 00       	push   $0x103543
  1035e9:	e8 ad fb ff ff       	call   10319b <vprintfmt>
  1035ee:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1035f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035f4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1035fa:	c9                   	leave  
  1035fb:	c3                   	ret    
