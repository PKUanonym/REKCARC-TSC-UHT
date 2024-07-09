.section .data

.equ SYS_read,  0
.equ SYS_write, 1
.equ SYS_open,  2
.equ SYS_close, 3
.equ SYS_lseek, 8
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
	.lcomm buffer, 100

.section .text

.type printInt, @function
printInt: # %rdi: num
	movq $1, outputSize
	movq %rdi, %rax
	movq %rsp, %r8
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

	movq $SYS_write, %rax
	movq $STDOUT, %rdi
	movq %rsp, %rsi
	movq outputSize, %rdx
	imulq $8, %rdx
	syscall
	movq %r8, %rsp
	ret

.type getline, @function
getline: # %rdi: fileDesc  %rsi: buffer  %rdx: num
	pushq %rdx	
	decq %rdx
flushBuffer:
	cmp $0, %rdx
	jl flushDone
	movq $0, buffer(%rdx)
	decq %rdx
flushDone:
	popq %rdx
	movq $SYS_read, %rax
	syscall
	movq %rax, %rcx
	cmpq $0, %rax
	jle ret1
	movq $0, %rax
	cmpb $0, buffer(%rax)
	jne nxt
	# decq %rax
	ret
nxt0:
	cmpb $0, buffer(%rax)
	jne nxt
	movq $1, %rdx
	movq $1, %rsi
	movq $SYS_lseek, %rax
	syscall
	movq $0, %rax
	ret
nxt:
	incq %rax
	cmpb $0, buffer(%rax)
	je retr # EOF
	cmpb $0xA, buffer(%rax)
	jne nxt

	movq %rax, %r8
	subq %rax, %rcx
	negq %rcx
	incq %rcx
bp:
	movq $1, %rdx
	movq %rcx, %rsi
	movq $SYS_lseek, %rax
	syscall
	movq %r8, %rax
	ret
retr:
	movq %rax, %rcx
	ret
ret1:
	movq $-1, %rax
	ret

.globl _start
_start:
# readFile:
	movq %rsp, %r8
	movq $SYS_open, %rax
	movq 16(%rsp), %rdi
	movq $0644, %rsi
	syscall
	movq %rax, fileDescriptor
work:
	movq $100, %rdx
	movq $buffer, %rsi
	movq fileDescriptor, %rdi
	call getline
	cmpq $0, %rax
	jle exit
	movq %rax, %rdi
	call printInt
	jmp work
exit:
	movq $SYS_exit, %rax
	movq $0, %rdi
	syscall
