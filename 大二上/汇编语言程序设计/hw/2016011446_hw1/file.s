.section .data

.equ SYS_read,  0
.equ SYS_write, 1
.equ SYS_open,  2
.equ SYS_close, 3
.equ SYS_exit,  60
.equ SYS_creat, 85
.equ STDIN,     0
.equ STDOUT,    1
.equ STDERR,    2
.equ O_CREAT,   0x40
.equ O_TRUNC,   0x200
.equ O_APPEND,  0x400
.equ O_RDONLY,  000000
.equ O_WRONLY,  000001
.equ O_RDWR,    000002
.equ S_IRUSR,   0x100
.equ S_IWUSR,   0x80
.equ S_IXUSR,   0x40

fileDescriptor:
	.quad 0
outputSize:
	.quad 0
lineCount:
	.quad 0

.section .bss
	.lcomm buffer, 100000

.section .text

.globl _start
_start:
# readFile:
	movq %rsp, %r8
	movq $SYS_open, %rax
	movq 16(%rsp), %rdi
	movq $0644, %rsi
	syscall
	movq %rax, fileDescriptor
	movq $SYS_read, %rax
	movq fileDescriptor, %rdi
	movq $buffer, %rsi
	movq $100000, %rdx
	syscall
# work:
	movq $0, %rbx
	jmp check
loop:
	movq $0, %rax
	movb buffer(%rbx), %al
	cmpq $0xA, %rax
	jne add
	incq lineCount
add:
	incq %rbx
check:
	movq $0, %rax
	movb buffer(%rbx), %al
	testq %rax, %rax
	jne loop
# print:
	movq $1, outputSize
	movq lineCount, %rax
	pushq $0xA
loopPrint:
	movq $10, %rcx
	movq $0, %rdx
	idivq %rcx
	incq outputSize
	addq $48, %rdx
	pushq %rdx
	testq %rax, %rax
	jne loopPrint
writeFile:
	movq $SYS_creat, %rax
	movq 24(%r8), %rdi
	movq $S_IRUSR|S_IWUSR, %rsi
	syscall
	movq %rax, fileDescriptor
	movq $SYS_write, %rax
	movq fileDescriptor, %rdi
	movq %rsp, %rsi
	movq outputSize, %rdx
	imulq $8, %rdx
	syscall
# exit:
	movq $SYS_exit, %rax
	movq $0, %rdi
	syscall
