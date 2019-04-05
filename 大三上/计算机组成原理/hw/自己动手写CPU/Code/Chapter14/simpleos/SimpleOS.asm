
SimpleOS.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34010100 	li	at,0x100
   4:	00200008 	jr	at
   8:	00000000 	nop
	...
  20:	40016800 	mfc0	at,c0_cause
  24:	30240800 	andi	a0,at,0x800
  28:	1480004e 	bnez	a0,164 <_int2>
  2c:	00000000 	nop
  30:	42000018 	eret
	...
 100:	3c011000 	lui	at,0x1000
 104:	34210003 	ori	at,at,0x3
 108:	34020080 	li	v0,0x80
 10c:	a0220000 	sb	v0,0(at)
 110:	3c011000 	lui	at,0x1000
 114:	34210001 	ori	at,at,0x1
 118:	34020000 	li	v0,0x0
 11c:	a0220000 	sb	v0,0(at)
 120:	3c011000 	lui	at,0x1000
 124:	34210000 	ori	at,at,0x0
 128:	340200b0 	li	v0,0xb0
 12c:	a0220000 	sb	v0,0(at)
 130:	3c011000 	lui	at,0x1000
 134:	34210003 	ori	at,at,0x3
 138:	34020003 	li	v0,0x3
 13c:	a0220000 	sb	v0,0(at)
 140:	3c011000 	lui	at,0x1000
 144:	34210001 	ori	at,at,0x1
 148:	34020001 	li	v0,0x1
 14c:	a0220000 	sb	v0,0(at)
 150:	3c011000 	lui	at,0x1000
 154:	34210801 	ori	at,at,0x801
 158:	40816000 	mtc0	at,c0_status

0000015c <_loop>:
 15c:	08000057 	j	15c <_loop>
 160:	00000000 	nop

00000164 <_int2>:
 164:	3c011000 	lui	at,0x1000
 168:	34210005 	ori	at,at,0x5
 16c:	80230000 	lb	v1,0(at)
 170:	30630001 	andi	v1,v1,0x1
 174:	10600011 	beqz	v1,1bc <_end>
 178:	00000000 	nop

0000017c <_sendback>:
 17c:	3c011000 	lui	at,0x1000
 180:	34210000 	ori	at,at,0x0
 184:	80220000 	lb	v0,0(at)
 188:	a0220000 	sb	v0,0(at)

0000018c <_loop2>:
 18c:	3c011000 	lui	at,0x1000
 190:	34210005 	ori	at,at,0x5
 194:	80220000 	lb	v0,0(at)
 198:	30420020 	andi	v0,v0,0x20
 19c:	1040fffb 	beqz	v0,18c <_loop2>
 1a0:	00000000 	nop
 1a4:	3c011000 	lui	at,0x1000
 1a8:	34210005 	ori	at,at,0x5
 1ac:	80230000 	lb	v1,0(at)
 1b0:	30630001 	andi	v1,v1,0x1
 1b4:	1460fff1 	bnez	v1,17c <_sendback>
 1b8:	00000000 	nop

000001bc <_end>:
 1bc:	42000018 	eret
 1c0:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x1d0>:
   0:	0000001e 	0x1e
	...
