.include "linux.s"
.include "record_def.s"
.section .data
in_file_name:
	.ascii "test.dat\0"
out_file_name:
	.ascii "test_out.dat\0"

.section .bss
.lcomm BUFFER_DATA, RECORD_SIZE

.section .text
#STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8
.equ ST_ARGC, 0

#Output file name
.globl _start
_start:
	movl %esp, %ebp
	subl $ST_SIZE_RESERVE, %esp
open_files:
open_fd_in:
	movl $SYS_OPEN, %eax
	movl $in_file_name, %ebx
	movl $O_RDONLY, %ecx
	movl $O_PERMISSION, %edx
	int $LINUX_SYSCALL
store_fd_in:
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)
	movl $SYS_OPEN, %eax
	movl $out_file_name, %ebx
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	movl $O_PERMISSION, %edx
	int $LINUX_SYSCALL
store_fd_out:
	movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)



loop_begin:
	pushl ST_INPUT_DESCRIPTOR(%ebp)
	pushl $BUFFER_DATA
	call read_record

	cmpl $END_OF_FILE, %eax
	jle loop_end

	pushl $BUFFER_DATA
	pushl %eax
	call add_age
	popl %eax
	addl $4, %esp

	pushl ST_OUTPUT_DESCRIPTOR(%ebp)
	pushl $BUFFER_DATA
	call write_record
	
	jmp loop_begin

loop_end:
	movl $SYS_CLOSE, %eax
	movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_INPUT_DESCRIPTOR(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

add_age:
	pushl %ebp
	movl %esp, %ebp
	movl ST_BUFFER(%ebp), %eax
	movl ST_BUFFER_LEN(%ebp), %ebx
	movl $0, %esi
	cmpl $0, %ebx
	je end_loop

add_age_loop:
	movl RECORD_AGE(%eax,%esi,1), %edi
	incl %edi
	movl %edi, RECORD_AGE(%eax,%esi,1)
	addl $324, %esi
	cmpl $1296, %esi
	jne add_age_loop

end_loop:
	movl %ebp, %esp
	popl %ebp
	ret

