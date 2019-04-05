
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34018000 	li	at,0x8000
   4:	00010c00 	sll	at,at,0x10
   8:	34210010 	ori	at,at,0x10
   c:	34028000 	li	v0,0x8000
  10:	00021400 	sll	v0,v0,0x10
  14:	34420001 	ori	v0,v0,0x1
  18:	34030000 	li	v1,0x0
  1c:	00411821 	addu	v1,v0,at
  20:	34030000 	li	v1,0x0
  24:	00411820 	add	v1,v0,at
  28:	00231822 	sub	v1,at,v1
  2c:	00621823 	subu	v1,v1,v0
  30:	20630002 	addi	v1,v1,2
  34:	34030000 	li	v1,0x0
  38:	24638000 	addiu	v1,v1,-32768
  3c:	3401ffff 	li	at,0xffff
  40:	00010c00 	sll	at,at,0x10
  44:	0020102a 	slt	v0,at,zero
  48:	0020102b 	sltu	v0,at,zero
  4c:	28228000 	slti	v0,at,-32768
  50:	2c228000 	sltiu	v0,at,-32768
  54:	3c010000 	lui	at,0x0
  58:	70221021 	clo	v0,at
  5c:	70221020 	clz	v0,at
  60:	3c01ffff 	lui	at,0xffff
  64:	3421ffff 	ori	at,at,0xffff
  68:	70221020 	clz	v0,at
  6c:	70221021 	clo	v0,at
  70:	3c01a100 	lui	at,0xa100
  74:	70221020 	clz	v0,at
  78:	70221021 	clo	v0,at
  7c:	3c011100 	lui	at,0x1100
  80:	70221020 	clz	v0,at
  84:	70221021 	clo	v0,at
  88:	3401ffff 	li	at,0xffff
  8c:	00010c00 	sll	at,at,0x10
  90:	3421fffb 	ori	at,at,0xfffb
  94:	34020006 	li	v0,0x6
  98:	70221802 	mul	v1,at,v0
  9c:	00220018 	mult	at,v0
  a0:	00220019 	multu	at,v0
	...
Disassembly of section .reginfo:

00000000 <_ram_end-0xb0>:
   0:	0000000e 	0xe
	...
