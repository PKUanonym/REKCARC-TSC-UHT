
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3401000f 	li	at,0xf
   4:	40815800 	mtc0	at,c0_compare
   8:	3c011000 	lui	at,0x1000
   c:	34210401 	ori	at,at,0x401
  10:	40816000 	mtc0	at,c0_status
  14:	40026000 	mfc0	v0,c0_status

00000018 <_loop>:
  18:	08000006 	j	18 <_loop>
  1c:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x20>:
   0:	00000006 	srlv	zero,zero,zero
	...
