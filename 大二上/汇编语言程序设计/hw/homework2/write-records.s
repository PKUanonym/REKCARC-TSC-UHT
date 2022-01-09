.include "linux.s"
.include "record-def.s"
.section .data
record1:
	.ascii "Fredrick\0"
	.rept 31
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr
	.long 45

record2:
	.ascii "qwerty\0"
	.rept 33
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr
	.long 34

record3:
	.ascii "asdfghj\0"
	.rept 32
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr
	.long 66

record4:
	.ascii "zxcvb\0"
	.rept 34
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr
	.long 10

file_name:
	.ascii "input.dat\0"
.equ ST_FILE_DESCRIPTOR, -4

.section .text
.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp
	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $03101, %ecx
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
