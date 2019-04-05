
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34010100 	li	at,0x100
   4:	00200008 	jr	at
   8:	00000000 	nop
	...
  20:	20420001 	addi	v0,v0,1
  24:	40015800 	mfc0	at,c0_compare
  28:	20210064 	addi	at,at,100
  2c:	40815800 	mtc0	at,c0_compare
  30:	42000018 	eret
	...
 100:	34020000 	li	v0,0x0
 104:	34010064 	li	at,0x64
 108:	40815800 	mtc0	at,c0_compare
 10c:	3c011000 	lui	at,0x1000
 110:	34210401 	ori	at,at,0x401
 114:	40816000 	mtc0	at,c0_status

00000118 <_loop>:
 118:	08000046 	j	118 <_loop>
 11c:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x120>:
   0:	00000006 	srlv	zero,zero,zero
	...
