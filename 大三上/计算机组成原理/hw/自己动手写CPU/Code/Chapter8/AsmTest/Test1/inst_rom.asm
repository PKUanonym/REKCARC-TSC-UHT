
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34010001 	li	at,0x1
   4:	08000008 	j	20 <_start+0x20>
   8:	34010002 	li	at,0x2
   c:	34011111 	li	at,0x1111
  10:	34011100 	li	at,0x1100
	...
  20:	34010003 	li	at,0x3
  24:	0c000010 	jal	40 <_start+0x40>
  28:	03e1001a 	div	zero,ra,at
  2c:	34010005 	li	at,0x5
  30:	34010006 	li	at,0x6
  34:	08000018 	j	60 <_start+0x60>
  38:	00000000 	nop
  3c:	00000000 	nop
  40:	03e01009 	jalr	v0,ra
  44:	00400825 	move	at,v0
  48:	34010009 	li	at,0x9
  4c:	3401000a 	li	at,0xa
  50:	08000020 	j	80 <_start+0x80>
  54:	00000000 	nop
	...
  60:	34010007 	li	at,0x7
  64:	00400008 	jr	v0
  68:	34010008 	li	at,0x8
  6c:	34011111 	li	at,0x1111
  70:	34011100 	li	at,0x1100
	...

00000084 <_loop>:
  84:	08000021 	j	84 <_loop>
  88:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x90>:
   0:	80000006 	lb	zero,6(zero)
	...
