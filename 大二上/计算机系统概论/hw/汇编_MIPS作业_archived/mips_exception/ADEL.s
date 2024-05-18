.text
.globl main
main:
	li $t0, 0x7ffffe11
	beq $a0, 0x0, rret
	lw $t1, 0($t0)
rret:
	li $v0, 10
	syscall

.kdata
save0:.word 0
save1:.word 0
save2:.word 0
.ktext 0x80000180
sw $v0, save0
sw $a0, save1
sw $v1, save2
mfc0 $k0, $13
srl $a0, $k0, 2
andi $a0, $a0, 0xf
bne $k0, 0x18, ok_pc
nop
mfc0 $a0, $14
andi $a0, $a0, 0x3
beq $a0, 0, ok_pc
li $v0, 10
syscall

ok_pc:
bne $a0, 0x04, addepc
srl $a0, $k0, 31
beq $a0, 0x0, deal
mfc0 $a0, $14
addiu $a0, $a0, 4

deal:
lw $v0, 0($a0)
andi $k0, $v0, 0xffff
mfc0 $v1, $8
andi $v1, $v1, 0x3
sub $k0, $k0, $v1
andi $k0, $k0, 0xffff
srl $v0, $v0, 16
sll $v0, $v0, 16
add $v0, $v0, $k0
sw $v0, 0($a0)
j ret

addepc:
mfc0 $k0, $14
addiu $k0, $k0, 4
mtc0 $k0, $14

ret:
lw $v0, save0
lw $a0, save1
lw $v1, save2
mtc0 $0, $13
mfc0 $k0, $12
ori $k0, 0x1
mtc0 $k0, $12
eret
	