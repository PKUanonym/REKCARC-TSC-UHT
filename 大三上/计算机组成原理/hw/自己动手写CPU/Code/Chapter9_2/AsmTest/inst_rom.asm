
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34011234 	li	at,0x1234
   4:	ac010000 	sw	at,0(zero)
   8:	34015678 	li	at,0x5678
   c:	e0010000 	sc	at,0(zero)
  10:	8c010000 	lw	at,0(zero)
  14:	00000000 	nop
  18:	34010000 	li	at,0x0
  1c:	c0010000 	ll	at,0(zero)
  20:	00000000 	nop
  24:	20210001 	addi	at,at,1
  28:	e0010000 	sc	at,0(zero)
  2c:	8c010000 	lw	at,0(zero)

00000030 <_loop>:
  30:	0800000c 	j	30 <_loop>
  34:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x40>:
   0:	00000002 	srl	zero,zero,0x0
	...
