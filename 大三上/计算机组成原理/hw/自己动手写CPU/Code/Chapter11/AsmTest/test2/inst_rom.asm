
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34010100 	li	at,0x100
   4:	00200008 	jr	at
   8:	00000000 	nop
	...
  40:	3401f0f0 	li	at,0xf0f0
  44:	3401ffff 	li	at,0xffff
  48:	34010f0f 	li	at,0xf0f
  4c:	3403000e 	li	v1,0xe
  50:	40047000 	mfc0	a0,c0_epc
  54:	20840004 	addi	a0,a0,4
  58:	40847000 	mtc0	a0,c0_epc
  5c:	42000018 	eret
	...
 100:	34011000 	li	at,0x1000
 104:	34021000 	li	v0,0x1000
 108:	00220034 	teq	at,v0
 10c:	34012000 	li	at,0x2000
 110:	00220036 	tne	at,v0
 114:	34013000 	li	at,0x3000
 118:	042c3000 	teqi	at,12288
 11c:	34014000 	li	at,0x4000
 120:	042e2000 	tnei	at,8192
 124:	34015000 	li	at,0x5000
 128:	00220030 	tge	at,v0
 12c:	34016000 	li	at,0x6000
 130:	04284000 	tgei	at,16384
 134:	34017000 	li	at,0x7000
 138:	04297000 	tgeiu	at,28672
 13c:	34018000 	li	at,0x8000
 140:	00220031 	tgeu	at,v0
 144:	34019000 	li	at,0x9000
 148:	00220032 	tlt	at,v0
 14c:	3401a000 	li	at,0xa000
 150:	042a9000 	tlti	at,-28672
 154:	3401b000 	li	at,0xb000
 158:	042bb000 	tltiu	at,-20480
 15c:	3401c000 	li	at,0xc000
 160:	00410033 	tltu	v0,at
 164:	3401d000 	li	at,0xd000

00000168 <_loop>:
 168:	0800005a 	j	168 <_loop>
 16c:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x170>:
   0:	0000001e 	0x1e
	...
