.section .text
.globl _start
_start:
	call allocate_init
	pushl $10
	call allocate
	subl $4, %esp
	pushl %eax

	pushl $20
	call allocate
	addl $4, %esp
	pushl %eax

	pushl $100
	call allocate
	addl $4, %esp
	pushl %eax

	movl 8(%esp), %eax
	pushl %eax
	call deallocate
	addl $4, %esp

	movl 4(%esp), %eax
	pushl %eax
	call deallocate
	addl $4, %esp

	pushl $30
	call allocate
	addl $4, %esp

	movl $1, %eax
	movl $0, %ebx
	int $0x80
