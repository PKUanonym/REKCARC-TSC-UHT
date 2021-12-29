.data 
	myexception:
		.asciiz "Here is an exception!"

.globl main
.text
main:
	li $a1, 0x1
	lw $a1, ($a1)

.kdata
	save0: .word 0
	save1: .word 1

.ktext 0x80000180
	sw  $v0, save0
	sw  $a0, save1
	mfc0 $k0, $13          # Cause register
	srl $a0, $k0, 2        # Extract ExcCode Field
	andi $a0, $a0, 0xf
	bne $k0, 0x18, ok_pc
	mfc0 $a0, $14          # EPC
	andi $a0, $a0, 0x3
	beq $a0, 0, ok_pc
	li $v0, 10
	syscall

ok_pc:
	la $a0, myexception   # Put myexception in the register
	li $v0, 4
	syscall

ret:
	mfc0 $k0, $14
	addiu $k0, $k0 4

	mtc0 $k0, $14

	lw $v0, save0
	lw $a0, save1
	mtc0 $0, $13
	mfc0 $k0, $12
	ori $k0, 0x1          # Interrupts enabled
	mtc0 $k0, $12
	eret

