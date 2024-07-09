.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_EXIT, 60
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.section .bss
    .lcomm stdin_buffer, 500

.section .data
.section .text

.global _start
.global scan_int
.global print_int

.global fib

_start:
    # 读入一个整数 n
    call scan_int
    movq %rax, %rdi

    # 调用 fib 函数
    call fib

    # 输出结果
    movq %rax, %rdi
    call print_int

    # 退出
    movq $SYS_EXIT, %rax
    xor %rdi, %rdi
    syscall

.type fib, @function
fib:
    # TODO: 修正fib函数，使得能够正确计算fibonacci数列
    # hint0: 可以使用GDB打断点，进行指令粒度的调试
    # hint1: 检查栈帧的分配与回收是否正确
    # hint2: 检查函数调用前后寄存器是否被正确保存与恢复
    # hint3: 检查函数调用时的参数是否正确传递

    # n is in %rdi
    pushq %rbp
    movq  %rsp, %rbp
    movq %rdi, %rax
    cmpq $2, %rdi
    jl fib_end
    pushq %rdi
    decq %rdi
    call fib
    movq %rax, %r8
    popq %rdi
    pushq %r8
    subq $2, %rdi
    call fib
    popq %r8
    addq %r8, %rax
fib_end:
    movq %rbp, %rsp
    popq %rbp
    ret

.equ DIGIT_0, '0'
.equ NEWLINE, 10
.type scan_int, @function
scan_int:
    pushq %rbp
    movq %rsp, %rbp

    movq $STDIN, %rdi
    movq $stdin_buffer, %rsi
    movq $500, %rdx
    movq $SYS_READ, %rax
    syscall

    movq $stdin_buffer, %rdi
    movq $500, %rsi
    xorq %rax, %rax
    xorq %rbx, %rbx
    movq $10, %r10
atoi_digits:
    xorq %rcx, %rcx
    movb (%rdi, %rbx, 1), %cl
    cmpb $NEWLINE, %cl       # 检查是否已经接收到'\n'，如果是则结束输入
    je scan_int_done

    subb $DIGIT_0, %cl
    imulq %r10
    addq %rcx, %rax

    incq %rbx
    jmp atoi_digits
    
scan_int_done:
    movq %rbp, %rsp
    popq %rbp
    ret


.type print_int, @function
print_int:
    # number to be printed in %rdi
    pushq %rbp
    movq  %rsp, %rbp
    movq %rdi, %rax # 将参数从 %rdi 保存到 %rax 中

    # 先令换行符入栈，最后输出时换行
    movq $NEWLINE, %rsi
    pushq %rsi
    movq $1, %rbx   # 记录当前待输出的字符数量，因为含'\n'所以初始为1
    
itoa_digits:
    # TODO: 将数字转换为字符串，并逆序保存在栈上，使得打印时次序正确
    # hint0: 从低位开始向高位处理，低位先入栈，高位先出栈
    # hint1: 使用cqto指令从32位扩展至64位，再用divq指令获取 商（%rax）和 余数（%rdx）
    # hint2: 通过加上 $DIGIT_0 将余数转换为字符，并压入栈中保存，注意压入的是 X86-64寄存器
    # hint3: 更新待输出的字符总数（%rbx）中，这将作为print_digits循环结束的依据
    movq $10, %rcx
    cqto
    divq %rcx
    # quotient is in %rax, remainder is in %rdx
    addq $DIGIT_0, %rdx
    pushq %rdx
    incq %rbx
    cmpq $0, %rax
    jnz itoa_digits

print_digits:
    # Reference: https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    leaq (%rsp), %rsi   # 需要的是char*所在的地址，而不是实际的char
    movq $1, %rdx
    syscall

    addq $8, %rsp       # 所以我们是移动栈顶指针来遍历每个字符所在的位置
    decq %rbx
    cmpq $0, %rbx       # 检查所有字符是否已经处理完毕
    jnz print_digits

print_int_done:
    movq %rbp, %rsp
    popq %rbp
    ret
