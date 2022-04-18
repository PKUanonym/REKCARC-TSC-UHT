.include "linux.s"
.include "record-def.s"

.section .data
input_name:
	.ascii "input.dat\0"
output_name:
	.ascii "output.dat\0"

.section .bss
	.lcomm record_buffer, RECORD_SIZE

.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

.section .text
.globl _start
_start:
	movl %esp, %ebp
	subl $8, %esp
	movl $SYS_OPEN, %eax
	movl $input_name, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)
	
	movl $SYS_OPEN, %eax
	movl $output_name, %ebx
	movl $03101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
	pushl ST_INPUT_DESCRIPTOR(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp
	cmpl $RECORD_SIZE, %eax
	jne finished_reading

Age_increase:
	movl $record_buffer, %eax
	movl RECORD_AGE(%eax), %ebx
	incl %ebx
	movl %ebx, RECORD_AGE(%eax)

write_to_file:
	movl $SYS_WRITE, %eax
	movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
	movl $record_buffer, %ecx
	movl $RECORD_SIZE, %edx
	int $LINUX_SYSCALL
	
	jmp record_read_loop

finished_reading:
	movl $SYS_CLOSE, %eax
	movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
	int $LINUX_SYSCALL
	movl $SYS_CLOSE, %eax
	movl ST_INPUT_DESCRIPTOR(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

