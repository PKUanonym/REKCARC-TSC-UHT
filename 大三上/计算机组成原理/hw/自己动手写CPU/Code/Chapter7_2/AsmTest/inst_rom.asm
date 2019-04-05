
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3401ffff 	li	at,0xffff
   4:	00010c00 	sll	at,at,0x10
   8:	3421fffb 	ori	at,at,0xfffb
   c:	34020006 	li	v0,0x6
  10:	00220018 	mult	at,v0
  14:	70220000 	madd	at,v0
  18:	70220001 	maddu	at,v0
  1c:	70220004 	msub	at,v0
  20:	70220005 	msubu	at,v0
Disassembly of section .reginfo:

00000000 <_ram_end-0x30>:
   0:	00000006 	srlv	zero,zero,zero
	...
