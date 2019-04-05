
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34011234 	li	at,0x1234
   4:	ac010000 	sw	at,0(zero)
   8:	34021234 	li	v0,0x1234
   c:	34010000 	li	at,0x0
  10:	8c010000 	lw	at,0(zero)
  14:	10220003 	beq	at,v0,24 <Label>
  18:	00000000 	nop
  1c:	34014567 	li	at,0x4567
  20:	00000000 	nop

00000024 <Label>:
  24:	340189ab 	li	at,0x89ab
  28:	00000000 	nop

0000002c <_loop>:
  2c:	0800000b 	j	2c <_loop>
  30:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x40>:
   0:	00000006 	srlv	zero,zero,zero
	...
