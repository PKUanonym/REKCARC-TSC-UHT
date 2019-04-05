
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

30000000 <_start>:
30000000:	3c012000 	lui	at,0x2000
30000004:	34210008 	ori	at,at,0x8
30000008:	3c02ffff 	lui	v0,0xffff
3000000c:	3442ffff 	ori	v0,v0,0xffff
30000010:	ac220000 	sw	v0,0(at)
30000014:	3c012000 	lui	at,0x2000
30000018:	3421000c 	ori	at,at,0xc
3000001c:	3c020000 	lui	v0,0x0
30000020:	34420000 	ori	v0,v0,0x0
30000024:	ac220000 	sw	v0,0(at)
30000028:	3c012000 	lui	at,0x2000
3000002c:	34210004 	ori	at,at,0x4
30000030:	3c024740 	lui	v0,0x4740
30000034:	34424106 	ori	v0,v0,0x4106
30000038:	ac220000 	sw	v0,0(at)
Disassembly of section .reginfo:

00000000 <_ram_end-0x30000040>:
   0:	00000006 	srlv	zero,zero,zero
	...
