
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3c010101 	lui	at,0x101
   4:	34210101 	ori	at,at,0x101
   8:	34221100 	ori	v0,at,0x1100
   c:	00220825 	or	at,at,v0
  10:	302300fe 	andi	v1,at,0xfe
  14:	00610824 	and	at,v1,at
  18:	3824ff00 	xori	a0,at,0xff00
  1c:	00810826 	xor	at,a0,at
  20:	00810827 	nor	at,a0,at
Disassembly of section .reginfo:

00000000 <_ram_end-0x30>:
   0:	0000001e 	0x1e
	...
