# write-record.s
.include "linux.s"
.include "record_def.s"

.equ ST_WRITE_BUFFER, 8
.equ ST_FILEDES, 12

.section .text
.globl write_record
.type write_record, @function
write_record:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	movl $SYS_WRITE, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl ST_WRITE_BUFFER(%ebp), %ecx
	movl $ONE_RECORD_SIZE, %edx
	int $LINUX_SYSCALL

	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
