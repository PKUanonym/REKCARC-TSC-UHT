
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34010100 	li	at,0x100
   4:	00200008 	jr	at
   8:	00000000 	nop
	...
  40:	34018000 	li	at,0x8000
  44:	34019000 	li	at,0x9000
  48:	40017000 	mfc0	at,c0_epc
  4c:	20210004 	addi	at,at,4
  50:	40817000 	mtc0	at,c0_epc
  54:	42000018 	eret
	...
 100:	34011000 	li	at,0x1000
 104:	ac010100 	sw	at,256(zero)
 108:	00200011 	mthi	at
 10c:	0000000c 	syscall
 110:	8c010100 	lw	at,256(zero)
 114:	00001010 	mfhi	v0

00000118 <_loop>:
 118:	08000046 	j	118 <_loop>
 11c:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x120>:
   0:	00000006 	srlv	zero,zero,zero
	...
