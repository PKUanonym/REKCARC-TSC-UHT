
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34038000 	li	v1,0x8000
   4:	00031c00 	sll	v1,v1,0x10
   8:	34010001 	li	at,0x1
   c:	10000004 	b	20 <s1>
  10:	34010002 	li	at,0x2
  14:	34011111 	li	at,0x1111
  18:	34011100 	li	at,0x1100
  1c:	00000000 	nop

00000020 <s1>:
  20:	34010003 	li	at,0x3
  24:	0411000a 	bal	50 <s2>
  28:	03e1001a 	div	zero,ra,at
  2c:	34011100 	li	at,0x1100
  30:	34011111 	li	at,0x1111
  34:	14200012 	bnez	at,80 <s3>
  38:	00000000 	nop
  3c:	34011100 	li	at,0x1100
  40:	34011111 	li	at,0x1111
	...

00000050 <s2>:
  50:	34010004 	li	at,0x4
  54:	1063000a 	beq	v1,v1,80 <s3>
  58:	03e00825 	move	at,ra
  5c:	34011111 	li	at,0x1111
  60:	34011100 	li	at,0x1100
  64:	34010007 	li	at,0x7
  68:	34010008 	li	at,0x8
  6c:	1c200024 	bgtz	at,100 <s4>
  70:	34010009 	li	at,0x9
  74:	34011111 	li	at,0x1111
  78:	34011100 	li	at,0x1100
  7c:	00000000 	nop

00000080 <s3>:
  80:	34010005 	li	at,0x5
  84:	0421fff7 	bgez	at,64 <s2+0x14>
  88:	34010006 	li	at,0x6
  8c:	34011111 	li	at,0x1111
  90:	34011100 	li	at,0x1100
	...

00000100 <s4>:
 100:	3401000a 	li	at,0xa
 104:	0471ffde 	bgezal	v1,80 <s3>
 108:	001f0825 	or	at,zero,ra
 10c:	3401000b 	li	at,0xb
 110:	3401000c 	li	at,0xc
 114:	3401000d 	li	at,0xd
 118:	3401000e 	li	at,0xe
 11c:	04600004 	bltz	v1,130 <s5>
 120:	3401000f 	li	at,0xf
 124:	34011100 	li	at,0x1100
	...

00000130 <s5>:
 130:	34010010 	li	at,0x10
 134:	1820ffcb 	blez	at,64 <s2+0x14>
 138:	34010011 	li	at,0x11
 13c:	34010012 	li	at,0x12
 140:	34010013 	li	at,0x13
 144:	04700006 	bltzal	v1,160 <s6>
 148:	001f0825 	or	at,zero,ra
 14c:	34011100 	li	at,0x1100
	...

00000160 <s6>:
 160:	34010014 	li	at,0x14
 164:	00000000 	nop

00000168 <_loop>:
 168:	0800005a 	j	168 <_loop>
 16c:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x170>:
   0:	8000000a 	lb	zero,10(zero)
	...
