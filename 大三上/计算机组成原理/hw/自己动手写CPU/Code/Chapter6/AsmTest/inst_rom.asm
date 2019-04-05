
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3c010000 	lui	at,0x0
   4:	3c02ffff 	lui	v0,0xffff
   8:	3c030505 	lui	v1,0x505
   c:	3c040000 	lui	a0,0x0
  10:	0041200a 	movz	a0,v0,at
  14:	0061200b 	movn	a0,v1,at
  18:	0062200b 	movn	a0,v1,v0
  1c:	0043200a 	movz	a0,v0,v1
  20:	00000011 	mthi	zero
  24:	00400011 	mthi	v0
  28:	00600011 	mthi	v1
  2c:	00002010 	mfhi	a0
  30:	00600013 	mtlo	v1
  34:	00400013 	mtlo	v0
  38:	00200013 	mtlo	at
  3c:	00002012 	mflo	a0
Disassembly of section .reginfo:

00000000 <_ram_end-0x40>:
   0:	0000001e 	0x1e
	...
