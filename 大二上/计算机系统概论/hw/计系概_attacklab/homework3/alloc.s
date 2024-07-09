.section .data
heap_begin:
	.long 0
current_break:
	.long 0
heap_size:
	.long 100

.equ HEADER_SIZE, 8
.equ HDR_AVAIL_OFFSET, 0
.equ HDR_SIZE_OFFSET, 4
.equ UNAVAILABLE, 0
.equ AVAILABLE, 1
.equ SYS_BRK, 45
.equ LINUX_SYSCALL, 0x80

.section .text
.globl allocate_init
.type allocate_init,@function
allocate_init:
	pushl %ebp
	movl %esp, %ebp
	movl $SYS_BRK, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
	
	incl %eax
	movl %eax, heap_begin
	movl %eax, %ebx
	addl heap_size, %ebx
	addl $HEADER_SIZE, %ebx
	movl $SYS_BRK, %eax
	int $LINUX_SYSCALL
	movl %eax, current_break
	movl %eax, %ecx
	subl heap_begin, %ecx
	subl $HEADER_SIZE, %ecx
	movl heap_begin, %eax
	
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl %ecx, HDR_SIZE_OFFSET(%eax)
	movl %ebp, %esp
	popl %ebp
	ret

.globl allocate
.type allocate, @function
.equ ST_MEM_SIZE, 8
allocate:
	pushl %ebp
	movl %esp, %ebp
	movl ST_MEM_SIZE(%ebp), %ecx
	movl heap_begin, %eax
	movl current_break, %ebx

loop_begin:
	cmpl %ebx, %eax
	je move_break
	movl HDR_SIZE_OFFSET(%eax), %edx
	cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	je next_location
	cmpl %edx, %ecx
	jle allocate_here

merge:
	leal (%eax, %edx, 1), %edi
	addl $HEADER_SIZE, %edi
	cmpl %ebx, %edi
	je move_break
	cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%edi)
	je next_location
	addl HDR_SIZE_OFFSET(%edi), %edx
	addl $HEADER_SIZE, %edx
	movl %edx, HDR_SIZE_OFFSET(%eax)
	jmp loop_begin
	
next_location:
	addl $HEADER_SIZE, %eax
	addl %edx, %eax
	jmp loop_begin

allocate_here:
	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	addl $HEADER_SIZE, %ecx
	cmpl %edx, %ecx
	jge return
	movl %eax, %ebx
	addl %ecx, %ebx
	subl %ecx, %edx
	
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%ebx)
	movl %edx, HDR_SIZE_OFFSET(%ebx)
	subl $HEADER_SIZE, %ecx
	movl %ecx, HDR_SIZE_OFFSET(%eax)

return:	
	addl $HEADER_SIZE, %eax
	movl %ebp, %esp
	popl %ebp
	ret

move_break:
	movl %eax, %ebx
	addl $HEADER_SIZE, %ebx
	addl heap_size, %ebx
	pushl %eax
	movl heap_size, %eax
	addl %eax, %eax
	movl %eax, heap_size

	movl $SYS_BRK, %eax
	int $LINUX_SYSCALL
	movl %eax, %ebx
	popl %eax
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	pushl %ecx
	movl %ebx, %ecx
	subl %eax, %ecx
	subl $HEADER_SIZE, %ecx
	movl %ecx, HDR_SIZE_OFFSET(%eax)
	popl %ecx
	movl %ebx, current_break
	jmp loop_begin

.globl deallocate
.type deallocate,@function
.equ ST_MEMORY_SEG, 4
deallocate:
	movl ST_MEMORY_SEG(%esp), %eax
	subl $HEADER_SIZE, %eax
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	ret


