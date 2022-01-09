.include "linux.s"
.include "record_def.s"
.section .data
record1:
	.ascii "fredrick\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209 #Padding to 240 bytes
	.byte 0
	.endr
	.long 17

record2:
	.ascii "fRedrick\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209 #Padding to 240 bytes
	.byte 0
	.endr
	.long 18

record3:
	.ascii "Fredrick\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209 #Padding to 240 bytes
	.byte 0
	.endr
	.long 19

record4:
	.ascii "FRedrick\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209 #Padding to 240 bytes
	.byte 0
	.endr
	.long 20

file_name:
	.ascii "test.dat\0"

.equ ST_FILE_DESCRIPTOR, -4
.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp
	
	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL

	movl %eax, ST_FILE_DESCRIPTOR(%ebp)
	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record1
	call write_record
	addl $8, %esp

	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record2
	call write_record
	addl $8, %esp

	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record3
	call write_record
	addl $8, %esp

	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record4
	call write_record
	addl $8, %esp

	movl $SYS_CLOSE, %eax
	movl ST_FILE_DESCRIPTOR(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

	movl %ebp, %esp
	popl %ebp
	ret

