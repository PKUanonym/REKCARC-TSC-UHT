
ctarget：     文件格式 elf64-x86-64


Disassembly of section .init:

0000000000400c48 <_init>:
  400c48:	48 83 ec 08          	sub    $0x8,%rsp
  400c4c:	48 8b 05 a5 33 20 00 	mov    0x2033a5(%rip),%rax        # 603ff8 <_DYNAMIC+0x1d0>
  400c53:	48 85 c0             	test   %rax,%rax
  400c56:	74 05                	je     400c5d <_init+0x15>
  400c58:	e8 43 02 00 00       	callq  400ea0 <socket@plt+0x10>
  400c5d:	48 83 c4 08          	add    $0x8,%rsp
  400c61:	c3                   	retq   

Disassembly of section .plt:

0000000000400c70 <strcasecmp@plt-0x10>:
  400c70:	ff 35 92 33 20 00    	pushq  0x203392(%rip)        # 604008 <_GLOBAL_OFFSET_TABLE_+0x8>
  400c76:	ff 25 94 33 20 00    	jmpq   *0x203394(%rip)        # 604010 <_GLOBAL_OFFSET_TABLE_+0x10>
  400c7c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400c80 <strcasecmp@plt>:
  400c80:	ff 25 92 33 20 00    	jmpq   *0x203392(%rip)        # 604018 <_GLOBAL_OFFSET_TABLE_+0x18>
  400c86:	68 00 00 00 00       	pushq  $0x0
  400c8b:	e9 e0 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400c90 <__errno_location@plt>:
  400c90:	ff 25 8a 33 20 00    	jmpq   *0x20338a(%rip)        # 604020 <_GLOBAL_OFFSET_TABLE_+0x20>
  400c96:	68 01 00 00 00       	pushq  $0x1
  400c9b:	e9 d0 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400ca0 <srandom@plt>:
  400ca0:	ff 25 82 33 20 00    	jmpq   *0x203382(%rip)        # 604028 <_GLOBAL_OFFSET_TABLE_+0x28>
  400ca6:	68 02 00 00 00       	pushq  $0x2
  400cab:	e9 c0 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400cb0 <strncmp@plt>:
  400cb0:	ff 25 7a 33 20 00    	jmpq   *0x20337a(%rip)        # 604030 <_GLOBAL_OFFSET_TABLE_+0x30>
  400cb6:	68 03 00 00 00       	pushq  $0x3
  400cbb:	e9 b0 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400cc0 <strcpy@plt>:
  400cc0:	ff 25 72 33 20 00    	jmpq   *0x203372(%rip)        # 604038 <_GLOBAL_OFFSET_TABLE_+0x38>
  400cc6:	68 04 00 00 00       	pushq  $0x4
  400ccb:	e9 a0 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400cd0 <puts@plt>:
  400cd0:	ff 25 6a 33 20 00    	jmpq   *0x20336a(%rip)        # 604040 <_GLOBAL_OFFSET_TABLE_+0x40>
  400cd6:	68 05 00 00 00       	pushq  $0x5
  400cdb:	e9 90 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400ce0 <write@plt>:
  400ce0:	ff 25 62 33 20 00    	jmpq   *0x203362(%rip)        # 604048 <_GLOBAL_OFFSET_TABLE_+0x48>
  400ce6:	68 06 00 00 00       	pushq  $0x6
  400ceb:	e9 80 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400cf0 <__stack_chk_fail@plt>:
  400cf0:	ff 25 5a 33 20 00    	jmpq   *0x20335a(%rip)        # 604050 <_GLOBAL_OFFSET_TABLE_+0x50>
  400cf6:	68 07 00 00 00       	pushq  $0x7
  400cfb:	e9 70 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d00 <mmap@plt>:
  400d00:	ff 25 52 33 20 00    	jmpq   *0x203352(%rip)        # 604058 <_GLOBAL_OFFSET_TABLE_+0x58>
  400d06:	68 08 00 00 00       	pushq  $0x8
  400d0b:	e9 60 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d10 <memset@plt>:
  400d10:	ff 25 4a 33 20 00    	jmpq   *0x20334a(%rip)        # 604060 <_GLOBAL_OFFSET_TABLE_+0x60>
  400d16:	68 09 00 00 00       	pushq  $0x9
  400d1b:	e9 50 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d20 <alarm@plt>:
  400d20:	ff 25 42 33 20 00    	jmpq   *0x203342(%rip)        # 604068 <_GLOBAL_OFFSET_TABLE_+0x68>
  400d26:	68 0a 00 00 00       	pushq  $0xa
  400d2b:	e9 40 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d30 <close@plt>:
  400d30:	ff 25 3a 33 20 00    	jmpq   *0x20333a(%rip)        # 604070 <_GLOBAL_OFFSET_TABLE_+0x70>
  400d36:	68 0b 00 00 00       	pushq  $0xb
  400d3b:	e9 30 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d40 <read@plt>:
  400d40:	ff 25 32 33 20 00    	jmpq   *0x203332(%rip)        # 604078 <_GLOBAL_OFFSET_TABLE_+0x78>
  400d46:	68 0c 00 00 00       	pushq  $0xc
  400d4b:	e9 20 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d50 <__libc_start_main@plt>:
  400d50:	ff 25 2a 33 20 00    	jmpq   *0x20332a(%rip)        # 604080 <_GLOBAL_OFFSET_TABLE_+0x80>
  400d56:	68 0d 00 00 00       	pushq  $0xd
  400d5b:	e9 10 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d60 <signal@plt>:
  400d60:	ff 25 22 33 20 00    	jmpq   *0x203322(%rip)        # 604088 <_GLOBAL_OFFSET_TABLE_+0x88>
  400d66:	68 0e 00 00 00       	pushq  $0xe
  400d6b:	e9 00 ff ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d70 <gethostbyname@plt>:
  400d70:	ff 25 1a 33 20 00    	jmpq   *0x20331a(%rip)        # 604090 <_GLOBAL_OFFSET_TABLE_+0x90>
  400d76:	68 0f 00 00 00       	pushq  $0xf
  400d7b:	e9 f0 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d80 <__memmove_chk@plt>:
  400d80:	ff 25 12 33 20 00    	jmpq   *0x203312(%rip)        # 604098 <_GLOBAL_OFFSET_TABLE_+0x98>
  400d86:	68 10 00 00 00       	pushq  $0x10
  400d8b:	e9 e0 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400d90 <strtol@plt>:
  400d90:	ff 25 0a 33 20 00    	jmpq   *0x20330a(%rip)        # 6040a0 <_GLOBAL_OFFSET_TABLE_+0xa0>
  400d96:	68 11 00 00 00       	pushq  $0x11
  400d9b:	e9 d0 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400da0 <memcpy@plt>:
  400da0:	ff 25 02 33 20 00    	jmpq   *0x203302(%rip)        # 6040a8 <_GLOBAL_OFFSET_TABLE_+0xa8>
  400da6:	68 12 00 00 00       	pushq  $0x12
  400dab:	e9 c0 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400db0 <time@plt>:
  400db0:	ff 25 fa 32 20 00    	jmpq   *0x2032fa(%rip)        # 6040b0 <_GLOBAL_OFFSET_TABLE_+0xb0>
  400db6:	68 13 00 00 00       	pushq  $0x13
  400dbb:	e9 b0 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400dc0 <random@plt>:
  400dc0:	ff 25 f2 32 20 00    	jmpq   *0x2032f2(%rip)        # 6040b8 <_GLOBAL_OFFSET_TABLE_+0xb8>
  400dc6:	68 14 00 00 00       	pushq  $0x14
  400dcb:	e9 a0 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400dd0 <_IO_getc@plt>:
  400dd0:	ff 25 ea 32 20 00    	jmpq   *0x2032ea(%rip)        # 6040c0 <_GLOBAL_OFFSET_TABLE_+0xc0>
  400dd6:	68 15 00 00 00       	pushq  $0x15
  400ddb:	e9 90 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400de0 <__isoc99_sscanf@plt>:
  400de0:	ff 25 e2 32 20 00    	jmpq   *0x2032e2(%rip)        # 6040c8 <_GLOBAL_OFFSET_TABLE_+0xc8>
  400de6:	68 16 00 00 00       	pushq  $0x16
  400deb:	e9 80 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400df0 <munmap@plt>:
  400df0:	ff 25 da 32 20 00    	jmpq   *0x2032da(%rip)        # 6040d0 <_GLOBAL_OFFSET_TABLE_+0xd0>
  400df6:	68 17 00 00 00       	pushq  $0x17
  400dfb:	e9 70 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e00 <__printf_chk@plt>:
  400e00:	ff 25 d2 32 20 00    	jmpq   *0x2032d2(%rip)        # 6040d8 <_GLOBAL_OFFSET_TABLE_+0xd8>
  400e06:	68 18 00 00 00       	pushq  $0x18
  400e0b:	e9 60 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e10 <fopen@plt>:
  400e10:	ff 25 ca 32 20 00    	jmpq   *0x2032ca(%rip)        # 6040e0 <_GLOBAL_OFFSET_TABLE_+0xe0>
  400e16:	68 19 00 00 00       	pushq  $0x19
  400e1b:	e9 50 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e20 <getopt@plt>:
  400e20:	ff 25 c2 32 20 00    	jmpq   *0x2032c2(%rip)        # 6040e8 <_GLOBAL_OFFSET_TABLE_+0xe8>
  400e26:	68 1a 00 00 00       	pushq  $0x1a
  400e2b:	e9 40 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e30 <strtoul@plt>:
  400e30:	ff 25 ba 32 20 00    	jmpq   *0x2032ba(%rip)        # 6040f0 <_GLOBAL_OFFSET_TABLE_+0xf0>
  400e36:	68 1b 00 00 00       	pushq  $0x1b
  400e3b:	e9 30 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e40 <gethostname@plt>:
  400e40:	ff 25 b2 32 20 00    	jmpq   *0x2032b2(%rip)        # 6040f8 <_GLOBAL_OFFSET_TABLE_+0xf8>
  400e46:	68 1c 00 00 00       	pushq  $0x1c
  400e4b:	e9 20 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e50 <exit@plt>:
  400e50:	ff 25 aa 32 20 00    	jmpq   *0x2032aa(%rip)        # 604100 <_GLOBAL_OFFSET_TABLE_+0x100>
  400e56:	68 1d 00 00 00       	pushq  $0x1d
  400e5b:	e9 10 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e60 <connect@plt>:
  400e60:	ff 25 a2 32 20 00    	jmpq   *0x2032a2(%rip)        # 604108 <_GLOBAL_OFFSET_TABLE_+0x108>
  400e66:	68 1e 00 00 00       	pushq  $0x1e
  400e6b:	e9 00 fe ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e70 <__fprintf_chk@plt>:
  400e70:	ff 25 9a 32 20 00    	jmpq   *0x20329a(%rip)        # 604110 <_GLOBAL_OFFSET_TABLE_+0x110>
  400e76:	68 1f 00 00 00       	pushq  $0x1f
  400e7b:	e9 f0 fd ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e80 <__sprintf_chk@plt>:
  400e80:	ff 25 92 32 20 00    	jmpq   *0x203292(%rip)        # 604118 <_GLOBAL_OFFSET_TABLE_+0x118>
  400e86:	68 20 00 00 00       	pushq  $0x20
  400e8b:	e9 e0 fd ff ff       	jmpq   400c70 <_init+0x28>

0000000000400e90 <socket@plt>:
  400e90:	ff 25 8a 32 20 00    	jmpq   *0x20328a(%rip)        # 604120 <_GLOBAL_OFFSET_TABLE_+0x120>
  400e96:	68 21 00 00 00       	pushq  $0x21
  400e9b:	e9 d0 fd ff ff       	jmpq   400c70 <_init+0x28>

Disassembly of section .plt.got:

0000000000400ea0 <.plt.got>:
  400ea0:	ff 25 52 31 20 00    	jmpq   *0x203152(%rip)        # 603ff8 <_DYNAMIC+0x1d0>
  400ea6:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000400eb0 <_start>:
  400eb0:	31 ed                	xor    %ebp,%ebp
  400eb2:	49 89 d1             	mov    %rdx,%r9
  400eb5:	5e                   	pop    %rsi
  400eb6:	48 89 e2             	mov    %rsp,%rdx
  400eb9:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  400ebd:	50                   	push   %rax
  400ebe:	54                   	push   %rsp
  400ebf:	49 c7 c0 f0 2d 40 00 	mov    $0x402df0,%r8
  400ec6:	48 c7 c1 80 2d 40 00 	mov    $0x402d80,%rcx
  400ecd:	48 c7 c7 89 11 40 00 	mov    $0x401189,%rdi
  400ed4:	e8 77 fe ff ff       	callq  400d50 <__libc_start_main@plt>
  400ed9:	f4                   	hlt    
  400eda:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400ee0 <deregister_tm_clones>:
  400ee0:	b8 b7 44 60 00       	mov    $0x6044b7,%eax
  400ee5:	55                   	push   %rbp
  400ee6:	48 2d b0 44 60 00    	sub    $0x6044b0,%rax
  400eec:	48 83 f8 0e          	cmp    $0xe,%rax
  400ef0:	48 89 e5             	mov    %rsp,%rbp
  400ef3:	76 1b                	jbe    400f10 <deregister_tm_clones+0x30>
  400ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  400efa:	48 85 c0             	test   %rax,%rax
  400efd:	74 11                	je     400f10 <deregister_tm_clones+0x30>
  400eff:	5d                   	pop    %rbp
  400f00:	bf b0 44 60 00       	mov    $0x6044b0,%edi
  400f05:	ff e0                	jmpq   *%rax
  400f07:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  400f0e:	00 00 
  400f10:	5d                   	pop    %rbp
  400f11:	c3                   	retq   
  400f12:	0f 1f 40 00          	nopl   0x0(%rax)
  400f16:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400f1d:	00 00 00 

0000000000400f20 <register_tm_clones>:
  400f20:	be b0 44 60 00       	mov    $0x6044b0,%esi
  400f25:	55                   	push   %rbp
  400f26:	48 81 ee b0 44 60 00 	sub    $0x6044b0,%rsi
  400f2d:	48 c1 fe 03          	sar    $0x3,%rsi
  400f31:	48 89 e5             	mov    %rsp,%rbp
  400f34:	48 89 f0             	mov    %rsi,%rax
  400f37:	48 c1 e8 3f          	shr    $0x3f,%rax
  400f3b:	48 01 c6             	add    %rax,%rsi
  400f3e:	48 d1 fe             	sar    %rsi
  400f41:	74 15                	je     400f58 <register_tm_clones+0x38>
  400f43:	b8 00 00 00 00       	mov    $0x0,%eax
  400f48:	48 85 c0             	test   %rax,%rax
  400f4b:	74 0b                	je     400f58 <register_tm_clones+0x38>
  400f4d:	5d                   	pop    %rbp
  400f4e:	bf b0 44 60 00       	mov    $0x6044b0,%edi
  400f53:	ff e0                	jmpq   *%rax
  400f55:	0f 1f 00             	nopl   (%rax)
  400f58:	5d                   	pop    %rbp
  400f59:	c3                   	retq   
  400f5a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400f60 <__do_global_dtors_aux>:
  400f60:	80 3d 81 35 20 00 00 	cmpb   $0x0,0x203581(%rip)        # 6044e8 <completed.7594>
  400f67:	75 11                	jne    400f7a <__do_global_dtors_aux+0x1a>
  400f69:	55                   	push   %rbp
  400f6a:	48 89 e5             	mov    %rsp,%rbp
  400f6d:	e8 6e ff ff ff       	callq  400ee0 <deregister_tm_clones>
  400f72:	5d                   	pop    %rbp
  400f73:	c6 05 6e 35 20 00 01 	movb   $0x1,0x20356e(%rip)        # 6044e8 <completed.7594>
  400f7a:	f3 c3                	repz retq 
  400f7c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400f80 <frame_dummy>:
  400f80:	bf 20 3e 60 00       	mov    $0x603e20,%edi
  400f85:	48 83 3f 00          	cmpq   $0x0,(%rdi)
  400f89:	75 05                	jne    400f90 <frame_dummy+0x10>
  400f8b:	eb 93                	jmp    400f20 <register_tm_clones>
  400f8d:	0f 1f 00             	nopl   (%rax)
  400f90:	b8 00 00 00 00       	mov    $0x0,%eax
  400f95:	48 85 c0             	test   %rax,%rax
  400f98:	74 f1                	je     400f8b <frame_dummy+0xb>
  400f9a:	55                   	push   %rbp
  400f9b:	48 89 e5             	mov    %rsp,%rbp
  400f9e:	ff d0                	callq  *%rax
  400fa0:	5d                   	pop    %rbp
  400fa1:	e9 7a ff ff ff       	jmpq   400f20 <register_tm_clones>

0000000000400fa6 <usage>:
  400fa6:	48 83 ec 08          	sub    $0x8,%rsp
  400faa:	48 89 fa             	mov    %rdi,%rdx
  400fad:	83 3d 74 35 20 00 00 	cmpl   $0x0,0x203574(%rip)        # 604528 <is_checker>
  400fb4:	74 3e                	je     400ff4 <usage+0x4e>
  400fb6:	be 08 2e 40 00       	mov    $0x402e08,%esi
  400fbb:	bf 01 00 00 00       	mov    $0x1,%edi
  400fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  400fc5:	e8 36 fe ff ff       	callq  400e00 <__printf_chk@plt>
  400fca:	bf 40 2e 40 00       	mov    $0x402e40,%edi
  400fcf:	e8 fc fc ff ff       	callq  400cd0 <puts@plt>
  400fd4:	bf 78 2f 40 00       	mov    $0x402f78,%edi
  400fd9:	e8 f2 fc ff ff       	callq  400cd0 <puts@plt>
  400fde:	bf 68 2e 40 00       	mov    $0x402e68,%edi
  400fe3:	e8 e8 fc ff ff       	callq  400cd0 <puts@plt>
  400fe8:	bf 92 2f 40 00       	mov    $0x402f92,%edi
  400fed:	e8 de fc ff ff       	callq  400cd0 <puts@plt>
  400ff2:	eb 32                	jmp    401026 <usage+0x80>
  400ff4:	be ae 2f 40 00       	mov    $0x402fae,%esi
  400ff9:	bf 01 00 00 00       	mov    $0x1,%edi
  400ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  401003:	e8 f8 fd ff ff       	callq  400e00 <__printf_chk@plt>
  401008:	bf 90 2e 40 00       	mov    $0x402e90,%edi
  40100d:	e8 be fc ff ff       	callq  400cd0 <puts@plt>
  401012:	bf b8 2e 40 00       	mov    $0x402eb8,%edi
  401017:	e8 b4 fc ff ff       	callq  400cd0 <puts@plt>
  40101c:	bf cc 2f 40 00       	mov    $0x402fcc,%edi
  401021:	e8 aa fc ff ff       	callq  400cd0 <puts@plt>
  401026:	bf 00 00 00 00       	mov    $0x0,%edi
  40102b:	e8 20 fe ff ff       	callq  400e50 <exit@plt>

0000000000401030 <initialize_target>:
  401030:	55                   	push   %rbp
  401031:	53                   	push   %rbx
  401032:	48 81 ec 18 21 00 00 	sub    $0x2118,%rsp
  401039:	89 f5                	mov    %esi,%ebp
  40103b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  401042:	00 00 
  401044:	48 89 84 24 08 21 00 	mov    %rax,0x2108(%rsp)
  40104b:	00 
  40104c:	31 c0                	xor    %eax,%eax
  40104e:	89 3d c4 34 20 00    	mov    %edi,0x2034c4(%rip)        # 604518 <check_level>
  401054:	8b 3d 0e 31 20 00    	mov    0x20310e(%rip),%edi        # 604168 <target_id>
  40105a:	e8 f8 1c 00 00       	callq  402d57 <gencookie>
  40105f:	89 05 bf 34 20 00    	mov    %eax,0x2034bf(%rip)        # 604524 <cookie>
  401065:	89 c7                	mov    %eax,%edi
  401067:	e8 eb 1c 00 00       	callq  402d57 <gencookie>
  40106c:	89 05 ae 34 20 00    	mov    %eax,0x2034ae(%rip)        # 604520 <authkey>
  401072:	8b 05 f0 30 20 00    	mov    0x2030f0(%rip),%eax        # 604168 <target_id>
  401078:	8d 78 01             	lea    0x1(%rax),%edi
  40107b:	e8 20 fc ff ff       	callq  400ca0 <srandom@plt>
  401080:	e8 3b fd ff ff       	callq  400dc0 <random@plt>
  401085:	89 c7                	mov    %eax,%edi
  401087:	e8 d7 02 00 00       	callq  401363 <scramble>
  40108c:	89 c3                	mov    %eax,%ebx
  40108e:	85 ed                	test   %ebp,%ebp
  401090:	74 18                	je     4010aa <initialize_target+0x7a>
  401092:	bf 00 00 00 00       	mov    $0x0,%edi
  401097:	e8 14 fd ff ff       	callq  400db0 <time@plt>
  40109c:	89 c7                	mov    %eax,%edi
  40109e:	e8 fd fb ff ff       	callq  400ca0 <srandom@plt>
  4010a3:	e8 18 fd ff ff       	callq  400dc0 <random@plt>
  4010a8:	eb 05                	jmp    4010af <initialize_target+0x7f>
  4010aa:	b8 00 00 00 00       	mov    $0x0,%eax
  4010af:	01 c3                	add    %eax,%ebx
  4010b1:	0f b7 db             	movzwl %bx,%ebx
  4010b4:	8d 04 dd 00 01 00 00 	lea    0x100(,%rbx,8),%eax
  4010bb:	89 c0                	mov    %eax,%eax
  4010bd:	48 89 05 dc 33 20 00 	mov    %rax,0x2033dc(%rip)        # 6044a0 <buf_offset>
  4010c4:	c6 05 7d 40 20 00 63 	movb   $0x63,0x20407d(%rip)        # 605148 <target_prefix>
  4010cb:	83 3d d6 33 20 00 00 	cmpl   $0x0,0x2033d6(%rip)        # 6044a8 <notify>
  4010d2:	0f 84 8f 00 00 00    	je     401167 <initialize_target+0x137>
  4010d8:	83 3d 49 34 20 00 00 	cmpl   $0x0,0x203449(%rip)        # 604528 <is_checker>
  4010df:	0f 85 82 00 00 00    	jne    401167 <initialize_target+0x137>
  4010e5:	be 00 01 00 00       	mov    $0x100,%esi
  4010ea:	48 89 e7             	mov    %rsp,%rdi
  4010ed:	e8 4e fd ff ff       	callq  400e40 <gethostname@plt>
  4010f2:	85 c0                	test   %eax,%eax
  4010f4:	74 25                	je     40111b <initialize_target+0xeb>
  4010f6:	bf e8 2e 40 00       	mov    $0x402ee8,%edi
  4010fb:	e8 d0 fb ff ff       	callq  400cd0 <puts@plt>
  401100:	bf 08 00 00 00       	mov    $0x8,%edi
  401105:	e8 46 fd ff ff       	callq  400e50 <exit@plt>
  40110a:	48 89 e6             	mov    %rsp,%rsi
  40110d:	e8 6e fb ff ff       	callq  400c80 <strcasecmp@plt>
  401112:	85 c0                	test   %eax,%eax
  401114:	74 1a                	je     401130 <initialize_target+0x100>
  401116:	83 c3 01             	add    $0x1,%ebx
  401119:	eb 05                	jmp    401120 <initialize_target+0xf0>
  40111b:	bb 00 00 00 00       	mov    $0x0,%ebx
  401120:	48 63 c3             	movslq %ebx,%rax
  401123:	48 8b 3c c5 80 41 60 	mov    0x604180(,%rax,8),%rdi
  40112a:	00 
  40112b:	48 85 ff             	test   %rdi,%rdi
  40112e:	75 da                	jne    40110a <initialize_target+0xda>
  401130:	48 8d bc 24 00 01 00 	lea    0x100(%rsp),%rdi
  401137:	00 
  401138:	e8 84 19 00 00       	callq  402ac1 <init_driver>
  40113d:	85 c0                	test   %eax,%eax
  40113f:	79 26                	jns    401167 <initialize_target+0x137>
  401141:	48 8d 94 24 00 01 00 	lea    0x100(%rsp),%rdx
  401148:	00 
  401149:	be 20 2f 40 00       	mov    $0x402f20,%esi
  40114e:	bf 01 00 00 00       	mov    $0x1,%edi
  401153:	b8 00 00 00 00       	mov    $0x0,%eax
  401158:	e8 a3 fc ff ff       	callq  400e00 <__printf_chk@plt>
  40115d:	bf 08 00 00 00       	mov    $0x8,%edi
  401162:	e8 e9 fc ff ff       	callq  400e50 <exit@plt>
  401167:	48 8b 84 24 08 21 00 	mov    0x2108(%rsp),%rax
  40116e:	00 
  40116f:	64 48 33 04 25 28 00 	xor    %fs:0x28,%rax
  401176:	00 00 
  401178:	74 05                	je     40117f <initialize_target+0x14f>
  40117a:	e8 71 fb ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  40117f:	48 81 c4 18 21 00 00 	add    $0x2118,%rsp
  401186:	5b                   	pop    %rbx
  401187:	5d                   	pop    %rbp
  401188:	c3                   	retq   

0000000000401189 <main>:
  401189:	41 56                	push   %r14
  40118b:	41 55                	push   %r13
  40118d:	41 54                	push   %r12
  40118f:	55                   	push   %rbp
  401190:	53                   	push   %rbx
  401191:	41 89 fc             	mov    %edi,%r12d
  401194:	48 89 f3             	mov    %rsi,%rbx
  401197:	be fc 1d 40 00       	mov    $0x401dfc,%esi
  40119c:	bf 0b 00 00 00       	mov    $0xb,%edi
  4011a1:	e8 ba fb ff ff       	callq  400d60 <signal@plt>
  4011a6:	be ae 1d 40 00       	mov    $0x401dae,%esi
  4011ab:	bf 07 00 00 00       	mov    $0x7,%edi
  4011b0:	e8 ab fb ff ff       	callq  400d60 <signal@plt>
  4011b5:	be 4a 1e 40 00       	mov    $0x401e4a,%esi
  4011ba:	bf 04 00 00 00       	mov    $0x4,%edi
  4011bf:	e8 9c fb ff ff       	callq  400d60 <signal@plt>
  4011c4:	83 3d 5d 33 20 00 00 	cmpl   $0x0,0x20335d(%rip)        # 604528 <is_checker>
  4011cb:	74 20                	je     4011ed <main+0x64>
  4011cd:	be 98 1e 40 00       	mov    $0x401e98,%esi
  4011d2:	bf 0e 00 00 00       	mov    $0xe,%edi
  4011d7:	e8 84 fb ff ff       	callq  400d60 <signal@plt>
  4011dc:	bf 05 00 00 00       	mov    $0x5,%edi
  4011e1:	e8 3a fb ff ff       	callq  400d20 <alarm@plt>
  4011e6:	bd ea 2f 40 00       	mov    $0x402fea,%ebp
  4011eb:	eb 05                	jmp    4011f2 <main+0x69>
  4011ed:	bd e5 2f 40 00       	mov    $0x402fe5,%ebp
  4011f2:	48 8b 05 c7 32 20 00 	mov    0x2032c7(%rip),%rax        # 6044c0 <stdin@@GLIBC_2.2.5>
  4011f9:	48 89 05 10 33 20 00 	mov    %rax,0x203310(%rip)        # 604510 <infile>
  401200:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  401206:	41 be 00 00 00 00    	mov    $0x0,%r14d
  40120c:	e9 c6 00 00 00       	jmpq   4012d7 <main+0x14e>
  401211:	83 e8 61             	sub    $0x61,%eax
  401214:	3c 10                	cmp    $0x10,%al
  401216:	0f 87 9c 00 00 00    	ja     4012b8 <main+0x12f>
  40121c:	0f b6 c0             	movzbl %al,%eax
  40121f:	ff 24 c5 30 30 40 00 	jmpq   *0x403030(,%rax,8)
  401226:	48 8b 3b             	mov    (%rbx),%rdi
  401229:	e8 78 fd ff ff       	callq  400fa6 <usage>
  40122e:	be ad 32 40 00       	mov    $0x4032ad,%esi
  401233:	48 8b 3d 8e 32 20 00 	mov    0x20328e(%rip),%rdi        # 6044c8 <optarg@@GLIBC_2.2.5>
  40123a:	e8 d1 fb ff ff       	callq  400e10 <fopen@plt>
  40123f:	48 89 05 ca 32 20 00 	mov    %rax,0x2032ca(%rip)        # 604510 <infile>
  401246:	48 85 c0             	test   %rax,%rax
  401249:	0f 85 88 00 00 00    	jne    4012d7 <main+0x14e>
  40124f:	48 8b 0d 72 32 20 00 	mov    0x203272(%rip),%rcx        # 6044c8 <optarg@@GLIBC_2.2.5>
  401256:	ba f2 2f 40 00       	mov    $0x402ff2,%edx
  40125b:	be 01 00 00 00       	mov    $0x1,%esi
  401260:	48 8b 3d 79 32 20 00 	mov    0x203279(%rip),%rdi        # 6044e0 <stderr@@GLIBC_2.2.5>
  401267:	e8 04 fc ff ff       	callq  400e70 <__fprintf_chk@plt>
  40126c:	b8 01 00 00 00       	mov    $0x1,%eax
  401271:	e9 e4 00 00 00       	jmpq   40135a <main+0x1d1>
  401276:	ba 10 00 00 00       	mov    $0x10,%edx
  40127b:	be 00 00 00 00       	mov    $0x0,%esi
  401280:	48 8b 3d 41 32 20 00 	mov    0x203241(%rip),%rdi        # 6044c8 <optarg@@GLIBC_2.2.5>
  401287:	e8 a4 fb ff ff       	callq  400e30 <strtoul@plt>
  40128c:	41 89 c6             	mov    %eax,%r14d
  40128f:	eb 46                	jmp    4012d7 <main+0x14e>
  401291:	ba 0a 00 00 00       	mov    $0xa,%edx
  401296:	be 00 00 00 00       	mov    $0x0,%esi
  40129b:	48 8b 3d 26 32 20 00 	mov    0x203226(%rip),%rdi        # 6044c8 <optarg@@GLIBC_2.2.5>
  4012a2:	e8 e9 fa ff ff       	callq  400d90 <strtol@plt>
  4012a7:	41 89 c5             	mov    %eax,%r13d
  4012aa:	eb 2b                	jmp    4012d7 <main+0x14e>
  4012ac:	c7 05 f2 31 20 00 00 	movl   $0x0,0x2031f2(%rip)        # 6044a8 <notify>
  4012b3:	00 00 00 
  4012b6:	eb 1f                	jmp    4012d7 <main+0x14e>
  4012b8:	0f be d2             	movsbl %dl,%edx
  4012bb:	be 0f 30 40 00       	mov    $0x40300f,%esi
  4012c0:	bf 01 00 00 00       	mov    $0x1,%edi
  4012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  4012ca:	e8 31 fb ff ff       	callq  400e00 <__printf_chk@plt>
  4012cf:	48 8b 3b             	mov    (%rbx),%rdi
  4012d2:	e8 cf fc ff ff       	callq  400fa6 <usage>
  4012d7:	48 89 ea             	mov    %rbp,%rdx
  4012da:	48 89 de             	mov    %rbx,%rsi
  4012dd:	44 89 e7             	mov    %r12d,%edi
  4012e0:	e8 3b fb ff ff       	callq  400e20 <getopt@plt>
  4012e5:	89 c2                	mov    %eax,%edx
  4012e7:	3c ff                	cmp    $0xff,%al
  4012e9:	0f 85 22 ff ff ff    	jne    401211 <main+0x88>
  4012ef:	be 00 00 00 00       	mov    $0x0,%esi
  4012f4:	44 89 ef             	mov    %r13d,%edi
  4012f7:	e8 34 fd ff ff       	callq  401030 <initialize_target>
  4012fc:	83 3d 25 32 20 00 00 	cmpl   $0x0,0x203225(%rip)        # 604528 <is_checker>
  401303:	74 2a                	je     40132f <main+0x1a6>
  401305:	44 3b 35 14 32 20 00 	cmp    0x203214(%rip),%r14d        # 604520 <authkey>
  40130c:	74 21                	je     40132f <main+0x1a6>
  40130e:	44 89 f2             	mov    %r14d,%edx
  401311:	be 48 2f 40 00       	mov    $0x402f48,%esi
  401316:	bf 01 00 00 00       	mov    $0x1,%edi
  40131b:	b8 00 00 00 00       	mov    $0x0,%eax
  401320:	e8 db fa ff ff       	callq  400e00 <__printf_chk@plt>
  401325:	b8 00 00 00 00       	mov    $0x0,%eax
  40132a:	e8 1b 07 00 00       	callq  401a4a <check_fail>
  40132f:	8b 15 ef 31 20 00    	mov    0x2031ef(%rip),%edx        # 604524 <cookie>
  401335:	be 22 30 40 00       	mov    $0x403022,%esi
  40133a:	bf 01 00 00 00       	mov    $0x1,%edi
  40133f:	b8 00 00 00 00       	mov    $0x0,%eax
  401344:	e8 b7 fa ff ff       	callq  400e00 <__printf_chk@plt>
  401349:	48 8b 3d 50 31 20 00 	mov    0x203150(%rip),%rdi        # 6044a0 <buf_offset>
  401350:	e8 43 0c 00 00       	callq  401f98 <stable_launch>
  401355:	b8 00 00 00 00       	mov    $0x0,%eax
  40135a:	5b                   	pop    %rbx
  40135b:	5d                   	pop    %rbp
  40135c:	41 5c                	pop    %r12
  40135e:	41 5d                	pop    %r13
  401360:	41 5e                	pop    %r14
  401362:	c3                   	retq   

0000000000401363 <scramble>:
  401363:	48 83 ec 38          	sub    $0x38,%rsp
  401367:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  40136e:	00 00 
  401370:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  401375:	31 c0                	xor    %eax,%eax
  401377:	eb 10                	jmp    401389 <scramble+0x26>
  401379:	69 d0 d1 40 00 00    	imul   $0x40d1,%eax,%edx
  40137f:	01 fa                	add    %edi,%edx
  401381:	89 c1                	mov    %eax,%ecx
  401383:	89 14 8c             	mov    %edx,(%rsp,%rcx,4)
  401386:	83 c0 01             	add    $0x1,%eax
  401389:	83 f8 09             	cmp    $0x9,%eax
  40138c:	76 eb                	jbe    401379 <scramble+0x16>
  40138e:	8b 04 24             	mov    (%rsp),%eax
  401391:	69 c0 d8 d4 00 00    	imul   $0xd4d8,%eax,%eax
  401397:	89 04 24             	mov    %eax,(%rsp)
  40139a:	8b 04 24             	mov    (%rsp),%eax
  40139d:	69 c0 51 3b 00 00    	imul   $0x3b51,%eax,%eax
  4013a3:	89 04 24             	mov    %eax,(%rsp)
  4013a6:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4013aa:	69 c0 c8 8d 00 00    	imul   $0x8dc8,%eax,%eax
  4013b0:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4013b4:	8b 44 24 10          	mov    0x10(%rsp),%eax
  4013b8:	69 c0 01 87 00 00    	imul   $0x8701,%eax,%eax
  4013be:	89 44 24 10          	mov    %eax,0x10(%rsp)
  4013c2:	8b 44 24 10          	mov    0x10(%rsp),%eax
  4013c6:	69 c0 ca 73 00 00    	imul   $0x73ca,%eax,%eax
  4013cc:	89 44 24 10          	mov    %eax,0x10(%rsp)
  4013d0:	8b 44 24 24          	mov    0x24(%rsp),%eax
  4013d4:	69 c0 01 c3 00 00    	imul   $0xc301,%eax,%eax
  4013da:	89 44 24 24          	mov    %eax,0x24(%rsp)
  4013de:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4013e2:	69 c0 3a 9e 00 00    	imul   $0x9e3a,%eax,%eax
  4013e8:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4013ec:	8b 44 24 14          	mov    0x14(%rsp),%eax
  4013f0:	69 c0 68 94 00 00    	imul   $0x9468,%eax,%eax
  4013f6:	89 44 24 14          	mov    %eax,0x14(%rsp)
  4013fa:	8b 44 24 14          	mov    0x14(%rsp),%eax
  4013fe:	69 c0 11 68 00 00    	imul   $0x6811,%eax,%eax
  401404:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401408:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40140c:	69 c0 23 22 00 00    	imul   $0x2223,%eax,%eax
  401412:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401416:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40141a:	69 c0 de 63 00 00    	imul   $0x63de,%eax,%eax
  401420:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401424:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401428:	69 c0 91 eb 00 00    	imul   $0xeb91,%eax,%eax
  40142e:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  401432:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401436:	69 c0 ad c4 00 00    	imul   $0xc4ad,%eax,%eax
  40143c:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  401440:	8b 44 24 20          	mov    0x20(%rsp),%eax
  401444:	69 c0 b4 ff 00 00    	imul   $0xffb4,%eax,%eax
  40144a:	89 44 24 20          	mov    %eax,0x20(%rsp)
  40144e:	8b 44 24 10          	mov    0x10(%rsp),%eax
  401452:	69 c0 7e a2 00 00    	imul   $0xa27e,%eax,%eax
  401458:	89 44 24 10          	mov    %eax,0x10(%rsp)
  40145c:	8b 44 24 10          	mov    0x10(%rsp),%eax
  401460:	69 c0 70 48 00 00    	imul   $0x4870,%eax,%eax
  401466:	89 44 24 10          	mov    %eax,0x10(%rsp)
  40146a:	8b 44 24 04          	mov    0x4(%rsp),%eax
  40146e:	69 c0 16 47 00 00    	imul   $0x4716,%eax,%eax
  401474:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401478:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40147c:	69 c0 d3 a6 00 00    	imul   $0xa6d3,%eax,%eax
  401482:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401486:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40148a:	69 c0 72 4e 00 00    	imul   $0x4e72,%eax,%eax
  401490:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401494:	8b 44 24 20          	mov    0x20(%rsp),%eax
  401498:	69 c0 ce d6 00 00    	imul   $0xd6ce,%eax,%eax
  40149e:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4014a2:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4014a6:	69 c0 58 7e 00 00    	imul   $0x7e58,%eax,%eax
  4014ac:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4014b0:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4014b4:	69 c0 48 f9 00 00    	imul   $0xf948,%eax,%eax
  4014ba:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4014be:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4014c2:	69 c0 d9 19 00 00    	imul   $0x19d9,%eax,%eax
  4014c8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4014cc:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4014d0:	69 c0 42 23 00 00    	imul   $0x2342,%eax,%eax
  4014d6:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4014da:	8b 44 24 24          	mov    0x24(%rsp),%eax
  4014de:	69 c0 d7 d2 00 00    	imul   $0xd2d7,%eax,%eax
  4014e4:	89 44 24 24          	mov    %eax,0x24(%rsp)
  4014e8:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4014ec:	69 c0 20 a8 00 00    	imul   $0xa820,%eax,%eax
  4014f2:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4014f6:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4014fa:	69 c0 c0 11 00 00    	imul   $0x11c0,%eax,%eax
  401500:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  401504:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401508:	69 c0 5c 02 00 00    	imul   $0x25c,%eax,%eax
  40150e:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401512:	8b 44 24 10          	mov    0x10(%rsp),%eax
  401516:	69 c0 1a 03 00 00    	imul   $0x31a,%eax,%eax
  40151c:	89 44 24 10          	mov    %eax,0x10(%rsp)
  401520:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401524:	69 c0 0b de 00 00    	imul   $0xde0b,%eax,%eax
  40152a:	89 44 24 04          	mov    %eax,0x4(%rsp)
  40152e:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401532:	69 c0 ff 4f 00 00    	imul   $0x4fff,%eax,%eax
  401538:	89 44 24 04          	mov    %eax,0x4(%rsp)
  40153c:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401540:	69 c0 ef 1c 00 00    	imul   $0x1cef,%eax,%eax
  401546:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  40154a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40154e:	69 c0 3d aa 00 00    	imul   $0xaa3d,%eax,%eax
  401554:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401558:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  40155c:	69 c0 f4 6b 00 00    	imul   $0x6bf4,%eax,%eax
  401562:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  401566:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40156a:	69 c0 96 f1 00 00    	imul   $0xf196,%eax,%eax
  401570:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401574:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401578:	69 c0 eb ba 00 00    	imul   $0xbaeb,%eax,%eax
  40157e:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401582:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401586:	69 c0 92 dc 00 00    	imul   $0xdc92,%eax,%eax
  40158c:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401590:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401594:	69 c0 82 8c 00 00    	imul   $0x8c82,%eax,%eax
  40159a:	89 44 24 04          	mov    %eax,0x4(%rsp)
  40159e:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4015a2:	69 c0 e3 41 00 00    	imul   $0x41e3,%eax,%eax
  4015a8:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4015ac:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4015b0:	69 c0 55 78 00 00    	imul   $0x7855,%eax,%eax
  4015b6:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4015ba:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4015be:	69 c0 2a f5 00 00    	imul   $0xf52a,%eax,%eax
  4015c4:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4015c8:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4015cc:	69 c0 70 4b 00 00    	imul   $0x4b70,%eax,%eax
  4015d2:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4015d6:	8b 04 24             	mov    (%rsp),%eax
  4015d9:	69 c0 26 b4 00 00    	imul   $0xb426,%eax,%eax
  4015df:	89 04 24             	mov    %eax,(%rsp)
  4015e2:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  4015e6:	69 c0 57 dd 00 00    	imul   $0xdd57,%eax,%eax
  4015ec:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  4015f0:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4015f4:	69 c0 dd 4f 00 00    	imul   $0x4fdd,%eax,%eax
  4015fa:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4015fe:	8b 44 24 20          	mov    0x20(%rsp),%eax
  401602:	69 c0 da 5c 00 00    	imul   $0x5cda,%eax,%eax
  401608:	89 44 24 20          	mov    %eax,0x20(%rsp)
  40160c:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401610:	69 c0 de e1 00 00    	imul   $0xe1de,%eax,%eax
  401616:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40161a:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  40161e:	69 c0 f1 36 00 00    	imul   $0x36f1,%eax,%eax
  401624:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  401628:	8b 44 24 14          	mov    0x14(%rsp),%eax
  40162c:	69 c0 8c 3d 00 00    	imul   $0x3d8c,%eax,%eax
  401632:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401636:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40163a:	69 c0 ca 84 00 00    	imul   $0x84ca,%eax,%eax
  401640:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401644:	8b 44 24 24          	mov    0x24(%rsp),%eax
  401648:	69 c0 a8 e5 00 00    	imul   $0xe5a8,%eax,%eax
  40164e:	89 44 24 24          	mov    %eax,0x24(%rsp)
  401652:	8b 44 24 20          	mov    0x20(%rsp),%eax
  401656:	69 c0 11 9f 00 00    	imul   $0x9f11,%eax,%eax
  40165c:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401660:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401664:	69 c0 e9 f3 00 00    	imul   $0xf3e9,%eax,%eax
  40166a:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  40166e:	8b 04 24             	mov    (%rsp),%eax
  401671:	69 c0 a5 b8 00 00    	imul   $0xb8a5,%eax,%eax
  401677:	89 04 24             	mov    %eax,(%rsp)
  40167a:	8b 44 24 10          	mov    0x10(%rsp),%eax
  40167e:	69 c0 58 db 00 00    	imul   $0xdb58,%eax,%eax
  401684:	89 44 24 10          	mov    %eax,0x10(%rsp)
  401688:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40168c:	69 c0 87 4a 00 00    	imul   $0x4a87,%eax,%eax
  401692:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401696:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  40169a:	69 c0 6f 51 00 00    	imul   $0x516f,%eax,%eax
  4016a0:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  4016a4:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4016a8:	69 c0 6c d7 00 00    	imul   $0xd76c,%eax,%eax
  4016ae:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4016b2:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4016b6:	69 c0 c3 e3 00 00    	imul   $0xe3c3,%eax,%eax
  4016bc:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4016c0:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4016c4:	69 c0 d6 bc 00 00    	imul   $0xbcd6,%eax,%eax
  4016ca:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4016ce:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4016d2:	69 c0 25 70 00 00    	imul   $0x7025,%eax,%eax
  4016d8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4016dc:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4016e0:	69 c0 7c d3 00 00    	imul   $0xd37c,%eax,%eax
  4016e6:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4016ea:	8b 44 24 20          	mov    0x20(%rsp),%eax
  4016ee:	69 c0 7a 93 00 00    	imul   $0x937a,%eax,%eax
  4016f4:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4016f8:	8b 44 24 10          	mov    0x10(%rsp),%eax
  4016fc:	69 c0 1e de 00 00    	imul   $0xde1e,%eax,%eax
  401702:	89 44 24 10          	mov    %eax,0x10(%rsp)
  401706:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40170a:	69 c0 53 ad 00 00    	imul   $0xad53,%eax,%eax
  401710:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401714:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401718:	8d 14 80             	lea    (%rax,%rax,4),%edx
  40171b:	8d 04 d5 00 00 00 00 	lea    0x0(,%rdx,8),%eax
  401722:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401726:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40172a:	69 c0 9e a2 00 00    	imul   $0xa29e,%eax,%eax
  401730:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401734:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401738:	69 c0 35 55 00 00    	imul   $0x5535,%eax,%eax
  40173e:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401742:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401746:	69 c0 cd ca 00 00    	imul   $0xcacd,%eax,%eax
  40174c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401750:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401754:	69 c0 53 cc 00 00    	imul   $0xcc53,%eax,%eax
  40175a:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40175e:	8b 44 24 10          	mov    0x10(%rsp),%eax
  401762:	69 c0 d4 3e 00 00    	imul   $0x3ed4,%eax,%eax
  401768:	89 44 24 10          	mov    %eax,0x10(%rsp)
  40176c:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401770:	69 c0 a7 76 00 00    	imul   $0x76a7,%eax,%eax
  401776:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40177a:	8b 44 24 14          	mov    0x14(%rsp),%eax
  40177e:	69 c0 d1 ac 00 00    	imul   $0xacd1,%eax,%eax
  401784:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401788:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  40178c:	69 c0 d9 95 00 00    	imul   $0x95d9,%eax,%eax
  401792:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  401796:	8b 44 24 04          	mov    0x4(%rsp),%eax
  40179a:	69 c0 d6 02 00 00    	imul   $0x2d6,%eax,%eax
  4017a0:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4017a4:	8b 44 24 20          	mov    0x20(%rsp),%eax
  4017a8:	69 c0 35 c4 00 00    	imul   $0xc435,%eax,%eax
  4017ae:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4017b2:	8b 44 24 20          	mov    0x20(%rsp),%eax
  4017b6:	69 c0 60 6c 00 00    	imul   $0x6c60,%eax,%eax
  4017bc:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  4017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  4017ca:	eb 0a                	jmp    4017d6 <scramble+0x473>
  4017cc:	89 d1                	mov    %edx,%ecx
  4017ce:	8b 0c 8c             	mov    (%rsp,%rcx,4),%ecx
  4017d1:	01 c8                	add    %ecx,%eax
  4017d3:	83 c2 01             	add    $0x1,%edx
  4017d6:	83 fa 09             	cmp    $0x9,%edx
  4017d9:	76 f1                	jbe    4017cc <scramble+0x469>
  4017db:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  4017e0:	64 48 33 34 25 28 00 	xor    %fs:0x28,%rsi
  4017e7:	00 00 
  4017e9:	74 05                	je     4017f0 <scramble+0x48d>
  4017eb:	e8 00 f5 ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  4017f0:	48 83 c4 38          	add    $0x38,%rsp
  4017f4:	c3                   	retq   

00000000004017f5 <getbuf>:
  4017f5:	48 83 ec 38          	sub    $0x38,%rsp
  4017f9:	48 89 e7             	mov    %rsp,%rdi
  4017fc:	e8 7e 02 00 00       	callq  401a7f <Gets>
  401801:	b8 01 00 00 00       	mov    $0x1,%eax
  401806:	48 83 c4 38          	add    $0x38,%rsp
  40180a:	c3                   	retq   

000000000040180b <touch1>:
  40180b:	48 83 ec 08          	sub    $0x8,%rsp
  40180f:	c7 05 03 2d 20 00 01 	movl   $0x1,0x202d03(%rip)        # 60451c <vlevel>
  401816:	00 00 00 
  401819:	bf 03 31 40 00       	mov    $0x403103,%edi
  40181e:	e8 ad f4 ff ff       	callq  400cd0 <puts@plt>
  401823:	bf 01 00 00 00       	mov    $0x1,%edi
  401828:	e8 97 04 00 00       	callq  401cc4 <validate>
  40182d:	bf 00 00 00 00       	mov    $0x0,%edi
  401832:	e8 19 f6 ff ff       	callq  400e50 <exit@plt>

0000000000401837 <touch2>:
  401837:	48 83 ec 08          	sub    $0x8,%rsp
  40183b:	89 fa                	mov    %edi,%edx
  40183d:	c7 05 d5 2c 20 00 02 	movl   $0x2,0x202cd5(%rip)        # 60451c <vlevel>
  401844:	00 00 00 
  401847:	39 3d d7 2c 20 00    	cmp    %edi,0x202cd7(%rip)        # 604524 <cookie>
  40184d:	75 20                	jne    40186f <touch2+0x38>
  40184f:	be 28 31 40 00       	mov    $0x403128,%esi
  401854:	bf 01 00 00 00       	mov    $0x1,%edi
  401859:	b8 00 00 00 00       	mov    $0x0,%eax
  40185e:	e8 9d f5 ff ff       	callq  400e00 <__printf_chk@plt>
  401863:	bf 02 00 00 00       	mov    $0x2,%edi
  401868:	e8 57 04 00 00       	callq  401cc4 <validate>
  40186d:	eb 1e                	jmp    40188d <touch2+0x56>
  40186f:	be 50 31 40 00       	mov    $0x403150,%esi
  401874:	bf 01 00 00 00       	mov    $0x1,%edi
  401879:	b8 00 00 00 00       	mov    $0x0,%eax
  40187e:	e8 7d f5 ff ff       	callq  400e00 <__printf_chk@plt>
  401883:	bf 02 00 00 00       	mov    $0x2,%edi
  401888:	e8 f9 04 00 00       	callq  401d86 <fail>
  40188d:	bf 00 00 00 00       	mov    $0x0,%edi
  401892:	e8 b9 f5 ff ff       	callq  400e50 <exit@plt>

0000000000401897 <hexmatch>:
  401897:	41 54                	push   %r12
  401899:	55                   	push   %rbp
  40189a:	53                   	push   %rbx
  40189b:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  40189f:	89 fd                	mov    %edi,%ebp
  4018a1:	48 89 f3             	mov    %rsi,%rbx
  4018a4:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  4018ab:	00 00 
  4018ad:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  4018b2:	31 c0                	xor    %eax,%eax
  4018b4:	e8 07 f5 ff ff       	callq  400dc0 <random@plt>
  4018b9:	48 89 c1             	mov    %rax,%rcx
  4018bc:	48 ba 0b d7 a3 70 3d 	movabs $0xa3d70a3d70a3d70b,%rdx
  4018c3:	0a d7 a3 
  4018c6:	48 f7 ea             	imul   %rdx
  4018c9:	48 01 ca             	add    %rcx,%rdx
  4018cc:	48 c1 fa 06          	sar    $0x6,%rdx
  4018d0:	48 89 c8             	mov    %rcx,%rax
  4018d3:	48 c1 f8 3f          	sar    $0x3f,%rax
  4018d7:	48 29 c2             	sub    %rax,%rdx
  4018da:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  4018de:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
  4018e2:	48 8d 04 95 00 00 00 	lea    0x0(,%rdx,4),%rax
  4018e9:	00 
  4018ea:	48 29 c1             	sub    %rax,%rcx
  4018ed:	4c 8d 24 0c          	lea    (%rsp,%rcx,1),%r12
  4018f1:	41 89 e8             	mov    %ebp,%r8d
  4018f4:	b9 20 31 40 00       	mov    $0x403120,%ecx
  4018f9:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  401900:	be 01 00 00 00       	mov    $0x1,%esi
  401905:	4c 89 e7             	mov    %r12,%rdi
  401908:	b8 00 00 00 00       	mov    $0x0,%eax
  40190d:	e8 6e f5 ff ff       	callq  400e80 <__sprintf_chk@plt>
  401912:	ba 09 00 00 00       	mov    $0x9,%edx
  401917:	4c 89 e6             	mov    %r12,%rsi
  40191a:	48 89 df             	mov    %rbx,%rdi
  40191d:	e8 8e f3 ff ff       	callq  400cb0 <strncmp@plt>
  401922:	85 c0                	test   %eax,%eax
  401924:	0f 94 c0             	sete   %al
  401927:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  40192c:	64 48 33 1c 25 28 00 	xor    %fs:0x28,%rbx
  401933:	00 00 
  401935:	74 05                	je     40193c <hexmatch+0xa5>
  401937:	e8 b4 f3 ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  40193c:	0f b6 c0             	movzbl %al,%eax
  40193f:	48 83 ec 80          	sub    $0xffffffffffffff80,%rsp
  401943:	5b                   	pop    %rbx
  401944:	5d                   	pop    %rbp
  401945:	41 5c                	pop    %r12
  401947:	c3                   	retq   

0000000000401948 <touch3>:
  401948:	53                   	push   %rbx
  401949:	48 89 fb             	mov    %rdi,%rbx
  40194c:	c7 05 c6 2b 20 00 03 	movl   $0x3,0x202bc6(%rip)        # 60451c <vlevel>
  401953:	00 00 00 
  401956:	48 89 fe             	mov    %rdi,%rsi
  401959:	8b 3d c5 2b 20 00    	mov    0x202bc5(%rip),%edi        # 604524 <cookie>
  40195f:	e8 33 ff ff ff       	callq  401897 <hexmatch>
  401964:	85 c0                	test   %eax,%eax
  401966:	74 23                	je     40198b <touch3+0x43>
  401968:	48 89 da             	mov    %rbx,%rdx
  40196b:	be 78 31 40 00       	mov    $0x403178,%esi
  401970:	bf 01 00 00 00       	mov    $0x1,%edi
  401975:	b8 00 00 00 00       	mov    $0x0,%eax
  40197a:	e8 81 f4 ff ff       	callq  400e00 <__printf_chk@plt>
  40197f:	bf 03 00 00 00       	mov    $0x3,%edi
  401984:	e8 3b 03 00 00       	callq  401cc4 <validate>
  401989:	eb 21                	jmp    4019ac <touch3+0x64>
  40198b:	48 89 da             	mov    %rbx,%rdx
  40198e:	be a0 31 40 00       	mov    $0x4031a0,%esi
  401993:	bf 01 00 00 00       	mov    $0x1,%edi
  401998:	b8 00 00 00 00       	mov    $0x0,%eax
  40199d:	e8 5e f4 ff ff       	callq  400e00 <__printf_chk@plt>
  4019a2:	bf 03 00 00 00       	mov    $0x3,%edi
  4019a7:	e8 da 03 00 00       	callq  401d86 <fail>
  4019ac:	bf 00 00 00 00       	mov    $0x0,%edi
  4019b1:	e8 9a f4 ff ff       	callq  400e50 <exit@plt>

00000000004019b6 <test>:
  4019b6:	48 83 ec 08          	sub    $0x8,%rsp
  4019ba:	b8 00 00 00 00       	mov    $0x0,%eax
  4019bf:	e8 31 fe ff ff       	callq  4017f5 <getbuf>
  4019c4:	89 c2                	mov    %eax,%edx
  4019c6:	be c8 31 40 00       	mov    $0x4031c8,%esi
  4019cb:	bf 01 00 00 00       	mov    $0x1,%edi
  4019d0:	b8 00 00 00 00       	mov    $0x0,%eax
  4019d5:	e8 26 f4 ff ff       	callq  400e00 <__printf_chk@plt>
  4019da:	48 83 c4 08          	add    $0x8,%rsp
  4019de:	c3                   	retq   

00000000004019df <save_char>:
  4019df:	8b 05 5f 37 20 00    	mov    0x20375f(%rip),%eax        # 605144 <gets_cnt>
  4019e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  4019ea:	7f 49                	jg     401a35 <save_char+0x56>
  4019ec:	8d 14 40             	lea    (%rax,%rax,2),%edx
  4019ef:	89 f9                	mov    %edi,%ecx
  4019f1:	c0 e9 04             	shr    $0x4,%cl
  4019f4:	83 e1 0f             	and    $0xf,%ecx
  4019f7:	0f b6 b1 f0 34 40 00 	movzbl 0x4034f0(%rcx),%esi
  4019fe:	48 63 ca             	movslq %edx,%rcx
  401a01:	40 88 b1 40 45 60 00 	mov    %sil,0x604540(%rcx)
  401a08:	8d 4a 01             	lea    0x1(%rdx),%ecx
  401a0b:	83 e7 0f             	and    $0xf,%edi
  401a0e:	0f b6 b7 f0 34 40 00 	movzbl 0x4034f0(%rdi),%esi
  401a15:	48 63 c9             	movslq %ecx,%rcx
  401a18:	40 88 b1 40 45 60 00 	mov    %sil,0x604540(%rcx)
  401a1f:	83 c2 02             	add    $0x2,%edx
  401a22:	48 63 d2             	movslq %edx,%rdx
  401a25:	c6 82 40 45 60 00 20 	movb   $0x20,0x604540(%rdx)
  401a2c:	83 c0 01             	add    $0x1,%eax
  401a2f:	89 05 0f 37 20 00    	mov    %eax,0x20370f(%rip)        # 605144 <gets_cnt>
  401a35:	f3 c3                	repz retq 

0000000000401a37 <save_term>:
  401a37:	8b 05 07 37 20 00    	mov    0x203707(%rip),%eax        # 605144 <gets_cnt>
  401a3d:	8d 04 40             	lea    (%rax,%rax,2),%eax
  401a40:	48 98                	cltq   
  401a42:	c6 80 40 45 60 00 00 	movb   $0x0,0x604540(%rax)
  401a49:	c3                   	retq   

0000000000401a4a <check_fail>:
  401a4a:	48 83 ec 08          	sub    $0x8,%rsp
  401a4e:	0f be 15 f3 36 20 00 	movsbl 0x2036f3(%rip),%edx        # 605148 <target_prefix>
  401a55:	41 b8 40 45 60 00    	mov    $0x604540,%r8d
  401a5b:	8b 0d b7 2a 20 00    	mov    0x202ab7(%rip),%ecx        # 604518 <check_level>
  401a61:	be eb 31 40 00       	mov    $0x4031eb,%esi
  401a66:	bf 01 00 00 00       	mov    $0x1,%edi
  401a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  401a70:	e8 8b f3 ff ff       	callq  400e00 <__printf_chk@plt>
  401a75:	bf 01 00 00 00       	mov    $0x1,%edi
  401a7a:	e8 d1 f3 ff ff       	callq  400e50 <exit@plt>

0000000000401a7f <Gets>:
  401a7f:	41 54                	push   %r12
  401a81:	55                   	push   %rbp
  401a82:	53                   	push   %rbx
  401a83:	49 89 fc             	mov    %rdi,%r12
  401a86:	c7 05 b4 36 20 00 00 	movl   $0x0,0x2036b4(%rip)        # 605144 <gets_cnt>
  401a8d:	00 00 00 
  401a90:	48 89 fb             	mov    %rdi,%rbx
  401a93:	eb 11                	jmp    401aa6 <Gets+0x27>
  401a95:	48 8d 6b 01          	lea    0x1(%rbx),%rbp
  401a99:	88 03                	mov    %al,(%rbx)
  401a9b:	0f b6 f8             	movzbl %al,%edi
  401a9e:	e8 3c ff ff ff       	callq  4019df <save_char>
  401aa3:	48 89 eb             	mov    %rbp,%rbx
  401aa6:	48 8b 3d 63 2a 20 00 	mov    0x202a63(%rip),%rdi        # 604510 <infile>
  401aad:	e8 1e f3 ff ff       	callq  400dd0 <_IO_getc@plt>
  401ab2:	83 f8 ff             	cmp    $0xffffffff,%eax
  401ab5:	74 05                	je     401abc <Gets+0x3d>
  401ab7:	83 f8 0a             	cmp    $0xa,%eax
  401aba:	75 d9                	jne    401a95 <Gets+0x16>
  401abc:	c6 03 00             	movb   $0x0,(%rbx)
  401abf:	b8 00 00 00 00       	mov    $0x0,%eax
  401ac4:	e8 6e ff ff ff       	callq  401a37 <save_term>
  401ac9:	4c 89 e0             	mov    %r12,%rax
  401acc:	5b                   	pop    %rbx
  401acd:	5d                   	pop    %rbp
  401ace:	41 5c                	pop    %r12
  401ad0:	c3                   	retq   

0000000000401ad1 <notify_server>:
  401ad1:	53                   	push   %rbx
  401ad2:	48 81 ec 10 40 00 00 	sub    $0x4010,%rsp
  401ad9:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  401ae0:	00 00 
  401ae2:	48 89 84 24 08 40 00 	mov    %rax,0x4008(%rsp)
  401ae9:	00 
  401aea:	31 c0                	xor    %eax,%eax
  401aec:	83 3d 35 2a 20 00 00 	cmpl   $0x0,0x202a35(%rip)        # 604528 <is_checker>
  401af3:	0f 85 aa 01 00 00    	jne    401ca3 <notify_server+0x1d2>
  401af9:	89 fb                	mov    %edi,%ebx
  401afb:	8b 05 43 36 20 00    	mov    0x203643(%rip),%eax        # 605144 <gets_cnt>
  401b01:	83 c0 64             	add    $0x64,%eax
  401b04:	3d 00 20 00 00       	cmp    $0x2000,%eax
  401b09:	7e 1e                	jle    401b29 <notify_server+0x58>
  401b0b:	be 20 33 40 00       	mov    $0x403320,%esi
  401b10:	bf 01 00 00 00       	mov    $0x1,%edi
  401b15:	b8 00 00 00 00       	mov    $0x0,%eax
  401b1a:	e8 e1 f2 ff ff       	callq  400e00 <__printf_chk@plt>
  401b1f:	bf 01 00 00 00       	mov    $0x1,%edi
  401b24:	e8 27 f3 ff ff       	callq  400e50 <exit@plt>
  401b29:	0f be 05 18 36 20 00 	movsbl 0x203618(%rip),%eax        # 605148 <target_prefix>
  401b30:	83 3d 71 29 20 00 00 	cmpl   $0x0,0x202971(%rip)        # 6044a8 <notify>
  401b37:	74 08                	je     401b41 <notify_server+0x70>
  401b39:	8b 15 e1 29 20 00    	mov    0x2029e1(%rip),%edx        # 604520 <authkey>
  401b3f:	eb 05                	jmp    401b46 <notify_server+0x75>
  401b41:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  401b46:	85 db                	test   %ebx,%ebx
  401b48:	74 08                	je     401b52 <notify_server+0x81>
  401b4a:	41 b9 01 32 40 00    	mov    $0x403201,%r9d
  401b50:	eb 06                	jmp    401b58 <notify_server+0x87>
  401b52:	41 b9 06 32 40 00    	mov    $0x403206,%r9d
  401b58:	68 40 45 60 00       	pushq  $0x604540
  401b5d:	56                   	push   %rsi
  401b5e:	50                   	push   %rax
  401b5f:	52                   	push   %rdx
  401b60:	44 8b 05 01 26 20 00 	mov    0x202601(%rip),%r8d        # 604168 <target_id>
  401b67:	b9 0b 32 40 00       	mov    $0x40320b,%ecx
  401b6c:	ba 00 20 00 00       	mov    $0x2000,%edx
  401b71:	be 01 00 00 00       	mov    $0x1,%esi
  401b76:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  401b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  401b80:	e8 fb f2 ff ff       	callq  400e80 <__sprintf_chk@plt>
  401b85:	48 83 c4 20          	add    $0x20,%rsp
  401b89:	83 3d 18 29 20 00 00 	cmpl   $0x0,0x202918(%rip)        # 6044a8 <notify>
  401b90:	0f 84 81 00 00 00    	je     401c17 <notify_server+0x146>
  401b96:	85 db                	test   %ebx,%ebx
  401b98:	74 6e                	je     401c08 <notify_server+0x137>
  401b9a:	4c 8d 8c 24 00 20 00 	lea    0x2000(%rsp),%r9
  401ba1:	00 
  401ba2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  401ba8:	48 89 e1             	mov    %rsp,%rcx
  401bab:	48 8b 15 be 25 20 00 	mov    0x2025be(%rip),%rdx        # 604170 <lab>
  401bb2:	48 8b 35 bf 25 20 00 	mov    0x2025bf(%rip),%rsi        # 604178 <course>
  401bb9:	48 8b 3d a0 25 20 00 	mov    0x2025a0(%rip),%rdi        # 604160 <user_id>
  401bc0:	e8 ef 10 00 00       	callq  402cb4 <driver_post>
  401bc5:	85 c0                	test   %eax,%eax
  401bc7:	79 26                	jns    401bef <notify_server+0x11e>
  401bc9:	48 8d 94 24 00 20 00 	lea    0x2000(%rsp),%rdx
  401bd0:	00 
  401bd1:	be 27 32 40 00       	mov    $0x403227,%esi
  401bd6:	bf 01 00 00 00       	mov    $0x1,%edi
  401bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  401be0:	e8 1b f2 ff ff       	callq  400e00 <__printf_chk@plt>
  401be5:	bf 01 00 00 00       	mov    $0x1,%edi
  401bea:	e8 61 f2 ff ff       	callq  400e50 <exit@plt>
  401bef:	bf 50 33 40 00       	mov    $0x403350,%edi
  401bf4:	e8 d7 f0 ff ff       	callq  400cd0 <puts@plt>
  401bf9:	bf 33 32 40 00       	mov    $0x403233,%edi
  401bfe:	e8 cd f0 ff ff       	callq  400cd0 <puts@plt>
  401c03:	e9 9b 00 00 00       	jmpq   401ca3 <notify_server+0x1d2>
  401c08:	bf 3d 32 40 00       	mov    $0x40323d,%edi
  401c0d:	e8 be f0 ff ff       	callq  400cd0 <puts@plt>
  401c12:	e9 8c 00 00 00       	jmpq   401ca3 <notify_server+0x1d2>
  401c17:	85 db                	test   %ebx,%ebx
  401c19:	74 07                	je     401c22 <notify_server+0x151>
  401c1b:	ba 01 32 40 00       	mov    $0x403201,%edx
  401c20:	eb 05                	jmp    401c27 <notify_server+0x156>
  401c22:	ba 06 32 40 00       	mov    $0x403206,%edx
  401c27:	be 88 33 40 00       	mov    $0x403388,%esi
  401c2c:	bf 01 00 00 00       	mov    $0x1,%edi
  401c31:	b8 00 00 00 00       	mov    $0x0,%eax
  401c36:	e8 c5 f1 ff ff       	callq  400e00 <__printf_chk@plt>
  401c3b:	48 8b 15 1e 25 20 00 	mov    0x20251e(%rip),%rdx        # 604160 <user_id>
  401c42:	be 44 32 40 00       	mov    $0x403244,%esi
  401c47:	bf 01 00 00 00       	mov    $0x1,%edi
  401c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  401c51:	e8 aa f1 ff ff       	callq  400e00 <__printf_chk@plt>
  401c56:	48 8b 15 1b 25 20 00 	mov    0x20251b(%rip),%rdx        # 604178 <course>
  401c5d:	be 51 32 40 00       	mov    $0x403251,%esi
  401c62:	bf 01 00 00 00       	mov    $0x1,%edi
  401c67:	b8 00 00 00 00       	mov    $0x0,%eax
  401c6c:	e8 8f f1 ff ff       	callq  400e00 <__printf_chk@plt>
  401c71:	48 8b 15 f8 24 20 00 	mov    0x2024f8(%rip),%rdx        # 604170 <lab>
  401c78:	be 5d 32 40 00       	mov    $0x40325d,%esi
  401c7d:	bf 01 00 00 00       	mov    $0x1,%edi
  401c82:	b8 00 00 00 00       	mov    $0x0,%eax
  401c87:	e8 74 f1 ff ff       	callq  400e00 <__printf_chk@plt>
  401c8c:	48 89 e2             	mov    %rsp,%rdx
  401c8f:	be 66 32 40 00       	mov    $0x403266,%esi
  401c94:	bf 01 00 00 00       	mov    $0x1,%edi
  401c99:	b8 00 00 00 00       	mov    $0x0,%eax
  401c9e:	e8 5d f1 ff ff       	callq  400e00 <__printf_chk@plt>
  401ca3:	48 8b 84 24 08 40 00 	mov    0x4008(%rsp),%rax
  401caa:	00 
  401cab:	64 48 33 04 25 28 00 	xor    %fs:0x28,%rax
  401cb2:	00 00 
  401cb4:	74 05                	je     401cbb <notify_server+0x1ea>
  401cb6:	e8 35 f0 ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  401cbb:	48 81 c4 10 40 00 00 	add    $0x4010,%rsp
  401cc2:	5b                   	pop    %rbx
  401cc3:	c3                   	retq   

0000000000401cc4 <validate>:
  401cc4:	53                   	push   %rbx
  401cc5:	89 fb                	mov    %edi,%ebx
  401cc7:	83 3d 5a 28 20 00 00 	cmpl   $0x0,0x20285a(%rip)        # 604528 <is_checker>
  401cce:	74 6b                	je     401d3b <validate+0x77>
  401cd0:	39 3d 46 28 20 00    	cmp    %edi,0x202846(%rip)        # 60451c <vlevel>
  401cd6:	74 14                	je     401cec <validate+0x28>
  401cd8:	bf 72 32 40 00       	mov    $0x403272,%edi
  401cdd:	e8 ee ef ff ff       	callq  400cd0 <puts@plt>
  401ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  401ce7:	e8 5e fd ff ff       	callq  401a4a <check_fail>
  401cec:	8b 15 26 28 20 00    	mov    0x202826(%rip),%edx        # 604518 <check_level>
  401cf2:	39 d7                	cmp    %edx,%edi
  401cf4:	74 20                	je     401d16 <validate+0x52>
  401cf6:	89 f9                	mov    %edi,%ecx
  401cf8:	be b0 33 40 00       	mov    $0x4033b0,%esi
  401cfd:	bf 01 00 00 00       	mov    $0x1,%edi
  401d02:	b8 00 00 00 00       	mov    $0x0,%eax
  401d07:	e8 f4 f0 ff ff       	callq  400e00 <__printf_chk@plt>
  401d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  401d11:	e8 34 fd ff ff       	callq  401a4a <check_fail>
  401d16:	0f be 15 2b 34 20 00 	movsbl 0x20342b(%rip),%edx        # 605148 <target_prefix>
  401d1d:	41 b8 40 45 60 00    	mov    $0x604540,%r8d
  401d23:	89 f9                	mov    %edi,%ecx
  401d25:	be 90 32 40 00       	mov    $0x403290,%esi
  401d2a:	bf 01 00 00 00       	mov    $0x1,%edi
  401d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  401d34:	e8 c7 f0 ff ff       	callq  400e00 <__printf_chk@plt>
  401d39:	eb 49                	jmp    401d84 <validate+0xc0>
  401d3b:	3b 3d db 27 20 00    	cmp    0x2027db(%rip),%edi        # 60451c <vlevel>
  401d41:	74 18                	je     401d5b <validate+0x97>
  401d43:	bf 72 32 40 00       	mov    $0x403272,%edi
  401d48:	e8 83 ef ff ff       	callq  400cd0 <puts@plt>
  401d4d:	89 de                	mov    %ebx,%esi
  401d4f:	bf 00 00 00 00       	mov    $0x0,%edi
  401d54:	e8 78 fd ff ff       	callq  401ad1 <notify_server>
  401d59:	eb 29                	jmp    401d84 <validate+0xc0>
  401d5b:	0f be 0d e6 33 20 00 	movsbl 0x2033e6(%rip),%ecx        # 605148 <target_prefix>
  401d62:	89 fa                	mov    %edi,%edx
  401d64:	be d8 33 40 00       	mov    $0x4033d8,%esi
  401d69:	bf 01 00 00 00       	mov    $0x1,%edi
  401d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  401d73:	e8 88 f0 ff ff       	callq  400e00 <__printf_chk@plt>
  401d78:	89 de                	mov    %ebx,%esi
  401d7a:	bf 01 00 00 00       	mov    $0x1,%edi
  401d7f:	e8 4d fd ff ff       	callq  401ad1 <notify_server>
  401d84:	5b                   	pop    %rbx
  401d85:	c3                   	retq   

0000000000401d86 <fail>:
  401d86:	48 83 ec 08          	sub    $0x8,%rsp
  401d8a:	83 3d 97 27 20 00 00 	cmpl   $0x0,0x202797(%rip)        # 604528 <is_checker>
  401d91:	74 0a                	je     401d9d <fail+0x17>
  401d93:	b8 00 00 00 00       	mov    $0x0,%eax
  401d98:	e8 ad fc ff ff       	callq  401a4a <check_fail>
  401d9d:	89 fe                	mov    %edi,%esi
  401d9f:	bf 00 00 00 00       	mov    $0x0,%edi
  401da4:	e8 28 fd ff ff       	callq  401ad1 <notify_server>
  401da9:	48 83 c4 08          	add    $0x8,%rsp
  401dad:	c3                   	retq   

0000000000401dae <bushandler>:
  401dae:	48 83 ec 08          	sub    $0x8,%rsp
  401db2:	83 3d 6f 27 20 00 00 	cmpl   $0x0,0x20276f(%rip)        # 604528 <is_checker>
  401db9:	74 14                	je     401dcf <bushandler+0x21>
  401dbb:	bf a5 32 40 00       	mov    $0x4032a5,%edi
  401dc0:	e8 0b ef ff ff       	callq  400cd0 <puts@plt>
  401dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  401dca:	e8 7b fc ff ff       	callq  401a4a <check_fail>
  401dcf:	bf 10 34 40 00       	mov    $0x403410,%edi
  401dd4:	e8 f7 ee ff ff       	callq  400cd0 <puts@plt>
  401dd9:	bf af 32 40 00       	mov    $0x4032af,%edi
  401dde:	e8 ed ee ff ff       	callq  400cd0 <puts@plt>
  401de3:	be 00 00 00 00       	mov    $0x0,%esi
  401de8:	bf 00 00 00 00       	mov    $0x0,%edi
  401ded:	e8 df fc ff ff       	callq  401ad1 <notify_server>
  401df2:	bf 01 00 00 00       	mov    $0x1,%edi
  401df7:	e8 54 f0 ff ff       	callq  400e50 <exit@plt>

0000000000401dfc <seghandler>:
  401dfc:	48 83 ec 08          	sub    $0x8,%rsp
  401e00:	83 3d 21 27 20 00 00 	cmpl   $0x0,0x202721(%rip)        # 604528 <is_checker>
  401e07:	74 14                	je     401e1d <seghandler+0x21>
  401e09:	bf c5 32 40 00       	mov    $0x4032c5,%edi
  401e0e:	e8 bd ee ff ff       	callq  400cd0 <puts@plt>
  401e13:	b8 00 00 00 00       	mov    $0x0,%eax
  401e18:	e8 2d fc ff ff       	callq  401a4a <check_fail>
  401e1d:	bf 30 34 40 00       	mov    $0x403430,%edi
  401e22:	e8 a9 ee ff ff       	callq  400cd0 <puts@plt>
  401e27:	bf af 32 40 00       	mov    $0x4032af,%edi
  401e2c:	e8 9f ee ff ff       	callq  400cd0 <puts@plt>
  401e31:	be 00 00 00 00       	mov    $0x0,%esi
  401e36:	bf 00 00 00 00       	mov    $0x0,%edi
  401e3b:	e8 91 fc ff ff       	callq  401ad1 <notify_server>
  401e40:	bf 01 00 00 00       	mov    $0x1,%edi
  401e45:	e8 06 f0 ff ff       	callq  400e50 <exit@plt>

0000000000401e4a <illegalhandler>:
  401e4a:	48 83 ec 08          	sub    $0x8,%rsp
  401e4e:	83 3d d3 26 20 00 00 	cmpl   $0x0,0x2026d3(%rip)        # 604528 <is_checker>
  401e55:	74 14                	je     401e6b <illegalhandler+0x21>
  401e57:	bf d8 32 40 00       	mov    $0x4032d8,%edi
  401e5c:	e8 6f ee ff ff       	callq  400cd0 <puts@plt>
  401e61:	b8 00 00 00 00       	mov    $0x0,%eax
  401e66:	e8 df fb ff ff       	callq  401a4a <check_fail>
  401e6b:	bf 58 34 40 00       	mov    $0x403458,%edi
  401e70:	e8 5b ee ff ff       	callq  400cd0 <puts@plt>
  401e75:	bf af 32 40 00       	mov    $0x4032af,%edi
  401e7a:	e8 51 ee ff ff       	callq  400cd0 <puts@plt>
  401e7f:	be 00 00 00 00       	mov    $0x0,%esi
  401e84:	bf 00 00 00 00       	mov    $0x0,%edi
  401e89:	e8 43 fc ff ff       	callq  401ad1 <notify_server>
  401e8e:	bf 01 00 00 00       	mov    $0x1,%edi
  401e93:	e8 b8 ef ff ff       	callq  400e50 <exit@plt>

0000000000401e98 <sigalrmhandler>:
  401e98:	48 83 ec 08          	sub    $0x8,%rsp
  401e9c:	83 3d 85 26 20 00 00 	cmpl   $0x0,0x202685(%rip)        # 604528 <is_checker>
  401ea3:	74 14                	je     401eb9 <sigalrmhandler+0x21>
  401ea5:	bf ec 32 40 00       	mov    $0x4032ec,%edi
  401eaa:	e8 21 ee ff ff       	callq  400cd0 <puts@plt>
  401eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  401eb4:	e8 91 fb ff ff       	callq  401a4a <check_fail>
  401eb9:	ba 05 00 00 00       	mov    $0x5,%edx
  401ebe:	be 88 34 40 00       	mov    $0x403488,%esi
  401ec3:	bf 01 00 00 00       	mov    $0x1,%edi
  401ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  401ecd:	e8 2e ef ff ff       	callq  400e00 <__printf_chk@plt>
  401ed2:	be 00 00 00 00       	mov    $0x0,%esi
  401ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  401edc:	e8 f0 fb ff ff       	callq  401ad1 <notify_server>
  401ee1:	bf 01 00 00 00       	mov    $0x1,%edi
  401ee6:	e8 65 ef ff ff       	callq  400e50 <exit@plt>

0000000000401eeb <launch>:
  401eeb:	55                   	push   %rbp
  401eec:	48 89 e5             	mov    %rsp,%rbp
  401eef:	48 83 ec 10          	sub    $0x10,%rsp
  401ef3:	48 89 fa             	mov    %rdi,%rdx
  401ef6:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  401efd:	00 00 
  401eff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  401f03:	31 c0                	xor    %eax,%eax
  401f05:	48 8d 47 1e          	lea    0x1e(%rdi),%rax
  401f09:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  401f0d:	48 29 c4             	sub    %rax,%rsp
  401f10:	48 8d 7c 24 0f       	lea    0xf(%rsp),%rdi
  401f15:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
  401f19:	be f4 00 00 00       	mov    $0xf4,%esi
  401f1e:	e8 ed ed ff ff       	callq  400d10 <memset@plt>
  401f23:	48 8b 05 96 25 20 00 	mov    0x202596(%rip),%rax        # 6044c0 <stdin@@GLIBC_2.2.5>
  401f2a:	48 39 05 df 25 20 00 	cmp    %rax,0x2025df(%rip)        # 604510 <infile>
  401f31:	75 14                	jne    401f47 <launch+0x5c>
  401f33:	be f4 32 40 00       	mov    $0x4032f4,%esi
  401f38:	bf 01 00 00 00       	mov    $0x1,%edi
  401f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  401f42:	e8 b9 ee ff ff       	callq  400e00 <__printf_chk@plt>
  401f47:	c7 05 cb 25 20 00 00 	movl   $0x0,0x2025cb(%rip)        # 60451c <vlevel>
  401f4e:	00 00 00 
  401f51:	b8 00 00 00 00       	mov    $0x0,%eax
  401f56:	e8 5b fa ff ff       	callq  4019b6 <test>
  401f5b:	83 3d c6 25 20 00 00 	cmpl   $0x0,0x2025c6(%rip)        # 604528 <is_checker>
  401f62:	74 14                	je     401f78 <launch+0x8d>
  401f64:	bf 01 33 40 00       	mov    $0x403301,%edi
  401f69:	e8 62 ed ff ff       	callq  400cd0 <puts@plt>
  401f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  401f73:	e8 d2 fa ff ff       	callq  401a4a <check_fail>
  401f78:	bf 0c 33 40 00       	mov    $0x40330c,%edi
  401f7d:	e8 4e ed ff ff       	callq  400cd0 <puts@plt>
  401f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  401f86:	64 48 33 04 25 28 00 	xor    %fs:0x28,%rax
  401f8d:	00 00 
  401f8f:	74 05                	je     401f96 <launch+0xab>
  401f91:	e8 5a ed ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  401f96:	c9                   	leaveq 
  401f97:	c3                   	retq   

0000000000401f98 <stable_launch>:
  401f98:	53                   	push   %rbx
  401f99:	48 89 3d 68 25 20 00 	mov    %rdi,0x202568(%rip)        # 604508 <global_offset>
  401fa0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  401fa6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  401fac:	b9 32 01 00 00       	mov    $0x132,%ecx
  401fb1:	ba 07 00 00 00       	mov    $0x7,%edx
  401fb6:	be 00 00 10 00       	mov    $0x100000,%esi
  401fbb:	bf 00 60 58 55       	mov    $0x55586000,%edi
  401fc0:	e8 3b ed ff ff       	callq  400d00 <mmap@plt>
  401fc5:	48 89 c3             	mov    %rax,%rbx
  401fc8:	48 3d 00 60 58 55    	cmp    $0x55586000,%rax
  401fce:	74 37                	je     402007 <stable_launch+0x6f>
  401fd0:	be 00 00 10 00       	mov    $0x100000,%esi
  401fd5:	48 89 c7             	mov    %rax,%rdi
  401fd8:	e8 13 ee ff ff       	callq  400df0 <munmap@plt>
  401fdd:	b9 00 60 58 55       	mov    $0x55586000,%ecx
  401fe2:	ba c0 34 40 00       	mov    $0x4034c0,%edx
  401fe7:	be 01 00 00 00       	mov    $0x1,%esi
  401fec:	48 8b 3d ed 24 20 00 	mov    0x2024ed(%rip),%rdi        # 6044e0 <stderr@@GLIBC_2.2.5>
  401ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  401ff8:	e8 73 ee ff ff       	callq  400e70 <__fprintf_chk@plt>
  401ffd:	bf 01 00 00 00       	mov    $0x1,%edi
  402002:	e8 49 ee ff ff       	callq  400e50 <exit@plt>
  402007:	48 8d 90 f8 ff 0f 00 	lea    0xffff8(%rax),%rdx
  40200e:	48 89 15 3b 31 20 00 	mov    %rdx,0x20313b(%rip)        # 605150 <stack_top>
  402015:	48 89 e0             	mov    %rsp,%rax
  402018:	48 89 d4             	mov    %rdx,%rsp
  40201b:	48 89 c2             	mov    %rax,%rdx
  40201e:	48 89 15 db 24 20 00 	mov    %rdx,0x2024db(%rip)        # 604500 <global_save_stack>
  402025:	48 8b 3d dc 24 20 00 	mov    0x2024dc(%rip),%rdi        # 604508 <global_offset>
  40202c:	e8 ba fe ff ff       	callq  401eeb <launch>
  402031:	48 8b 05 c8 24 20 00 	mov    0x2024c8(%rip),%rax        # 604500 <global_save_stack>
  402038:	48 89 c4             	mov    %rax,%rsp
  40203b:	be 00 00 10 00       	mov    $0x100000,%esi
  402040:	48 89 df             	mov    %rbx,%rdi
  402043:	e8 a8 ed ff ff       	callq  400df0 <munmap@plt>
  402048:	5b                   	pop    %rbx
  402049:	c3                   	retq   

000000000040204a <rio_readinitb>:
  40204a:	89 37                	mov    %esi,(%rdi)
  40204c:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%rdi)
  402053:	48 8d 47 10          	lea    0x10(%rdi),%rax
  402057:	48 89 47 08          	mov    %rax,0x8(%rdi)
  40205b:	c3                   	retq   

000000000040205c <sigalrm_handler>:
  40205c:	48 83 ec 08          	sub    $0x8,%rsp
  402060:	b9 00 00 00 00       	mov    $0x0,%ecx
  402065:	ba 00 35 40 00       	mov    $0x403500,%edx
  40206a:	be 01 00 00 00       	mov    $0x1,%esi
  40206f:	48 8b 3d 6a 24 20 00 	mov    0x20246a(%rip),%rdi        # 6044e0 <stderr@@GLIBC_2.2.5>
  402076:	b8 00 00 00 00       	mov    $0x0,%eax
  40207b:	e8 f0 ed ff ff       	callq  400e70 <__fprintf_chk@plt>
  402080:	bf 01 00 00 00       	mov    $0x1,%edi
  402085:	e8 c6 ed ff ff       	callq  400e50 <exit@plt>

000000000040208a <rio_writen>:
  40208a:	41 55                	push   %r13
  40208c:	41 54                	push   %r12
  40208e:	55                   	push   %rbp
  40208f:	53                   	push   %rbx
  402090:	48 83 ec 08          	sub    $0x8,%rsp
  402094:	41 89 fc             	mov    %edi,%r12d
  402097:	48 89 f5             	mov    %rsi,%rbp
  40209a:	49 89 d5             	mov    %rdx,%r13
  40209d:	48 89 d3             	mov    %rdx,%rbx
  4020a0:	eb 28                	jmp    4020ca <rio_writen+0x40>
  4020a2:	48 89 da             	mov    %rbx,%rdx
  4020a5:	48 89 ee             	mov    %rbp,%rsi
  4020a8:	44 89 e7             	mov    %r12d,%edi
  4020ab:	e8 30 ec ff ff       	callq  400ce0 <write@plt>
  4020b0:	48 85 c0             	test   %rax,%rax
  4020b3:	7f 0f                	jg     4020c4 <rio_writen+0x3a>
  4020b5:	e8 d6 eb ff ff       	callq  400c90 <__errno_location@plt>
  4020ba:	83 38 04             	cmpl   $0x4,(%rax)
  4020bd:	75 15                	jne    4020d4 <rio_writen+0x4a>
  4020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  4020c4:	48 29 c3             	sub    %rax,%rbx
  4020c7:	48 01 c5             	add    %rax,%rbp
  4020ca:	48 85 db             	test   %rbx,%rbx
  4020cd:	75 d3                	jne    4020a2 <rio_writen+0x18>
  4020cf:	4c 89 e8             	mov    %r13,%rax
  4020d2:	eb 07                	jmp    4020db <rio_writen+0x51>
  4020d4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  4020db:	48 83 c4 08          	add    $0x8,%rsp
  4020df:	5b                   	pop    %rbx
  4020e0:	5d                   	pop    %rbp
  4020e1:	41 5c                	pop    %r12
  4020e3:	41 5d                	pop    %r13
  4020e5:	c3                   	retq   

00000000004020e6 <rio_read>:
  4020e6:	41 55                	push   %r13
  4020e8:	41 54                	push   %r12
  4020ea:	55                   	push   %rbp
  4020eb:	53                   	push   %rbx
  4020ec:	48 83 ec 08          	sub    $0x8,%rsp
  4020f0:	48 89 fb             	mov    %rdi,%rbx
  4020f3:	49 89 f5             	mov    %rsi,%r13
  4020f6:	49 89 d4             	mov    %rdx,%r12
  4020f9:	eb 2e                	jmp    402129 <rio_read+0x43>
  4020fb:	48 8d 6b 10          	lea    0x10(%rbx),%rbp
  4020ff:	8b 3b                	mov    (%rbx),%edi
  402101:	ba 00 20 00 00       	mov    $0x2000,%edx
  402106:	48 89 ee             	mov    %rbp,%rsi
  402109:	e8 32 ec ff ff       	callq  400d40 <read@plt>
  40210e:	89 43 04             	mov    %eax,0x4(%rbx)
  402111:	85 c0                	test   %eax,%eax
  402113:	79 0c                	jns    402121 <rio_read+0x3b>
  402115:	e8 76 eb ff ff       	callq  400c90 <__errno_location@plt>
  40211a:	83 38 04             	cmpl   $0x4,(%rax)
  40211d:	74 0a                	je     402129 <rio_read+0x43>
  40211f:	eb 37                	jmp    402158 <rio_read+0x72>
  402121:	85 c0                	test   %eax,%eax
  402123:	74 3c                	je     402161 <rio_read+0x7b>
  402125:	48 89 6b 08          	mov    %rbp,0x8(%rbx)
  402129:	8b 6b 04             	mov    0x4(%rbx),%ebp
  40212c:	85 ed                	test   %ebp,%ebp
  40212e:	7e cb                	jle    4020fb <rio_read+0x15>
  402130:	89 e8                	mov    %ebp,%eax
  402132:	49 39 c4             	cmp    %rax,%r12
  402135:	77 03                	ja     40213a <rio_read+0x54>
  402137:	44 89 e5             	mov    %r12d,%ebp
  40213a:	4c 63 e5             	movslq %ebp,%r12
  40213d:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  402141:	4c 89 e2             	mov    %r12,%rdx
  402144:	4c 89 ef             	mov    %r13,%rdi
  402147:	e8 54 ec ff ff       	callq  400da0 <memcpy@plt>
  40214c:	4c 01 63 08          	add    %r12,0x8(%rbx)
  402150:	29 6b 04             	sub    %ebp,0x4(%rbx)
  402153:	4c 89 e0             	mov    %r12,%rax
  402156:	eb 0e                	jmp    402166 <rio_read+0x80>
  402158:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  40215f:	eb 05                	jmp    402166 <rio_read+0x80>
  402161:	b8 00 00 00 00       	mov    $0x0,%eax
  402166:	48 83 c4 08          	add    $0x8,%rsp
  40216a:	5b                   	pop    %rbx
  40216b:	5d                   	pop    %rbp
  40216c:	41 5c                	pop    %r12
  40216e:	41 5d                	pop    %r13
  402170:	c3                   	retq   

0000000000402171 <rio_readlineb>:
  402171:	41 55                	push   %r13
  402173:	41 54                	push   %r12
  402175:	55                   	push   %rbp
  402176:	53                   	push   %rbx
  402177:	48 83 ec 18          	sub    $0x18,%rsp
  40217b:	49 89 fd             	mov    %rdi,%r13
  40217e:	48 89 f5             	mov    %rsi,%rbp
  402181:	49 89 d4             	mov    %rdx,%r12
  402184:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  40218b:	00 00 
  40218d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  402192:	31 c0                	xor    %eax,%eax
  402194:	bb 01 00 00 00       	mov    $0x1,%ebx
  402199:	eb 3f                	jmp    4021da <rio_readlineb+0x69>
  40219b:	ba 01 00 00 00       	mov    $0x1,%edx
  4021a0:	48 8d 74 24 07       	lea    0x7(%rsp),%rsi
  4021a5:	4c 89 ef             	mov    %r13,%rdi
  4021a8:	e8 39 ff ff ff       	callq  4020e6 <rio_read>
  4021ad:	83 f8 01             	cmp    $0x1,%eax
  4021b0:	75 15                	jne    4021c7 <rio_readlineb+0x56>
  4021b2:	48 8d 45 01          	lea    0x1(%rbp),%rax
  4021b6:	0f b6 54 24 07       	movzbl 0x7(%rsp),%edx
  4021bb:	88 55 00             	mov    %dl,0x0(%rbp)
  4021be:	80 7c 24 07 0a       	cmpb   $0xa,0x7(%rsp)
  4021c3:	75 0e                	jne    4021d3 <rio_readlineb+0x62>
  4021c5:	eb 1a                	jmp    4021e1 <rio_readlineb+0x70>
  4021c7:	85 c0                	test   %eax,%eax
  4021c9:	75 22                	jne    4021ed <rio_readlineb+0x7c>
  4021cb:	48 83 fb 01          	cmp    $0x1,%rbx
  4021cf:	75 13                	jne    4021e4 <rio_readlineb+0x73>
  4021d1:	eb 23                	jmp    4021f6 <rio_readlineb+0x85>
  4021d3:	48 83 c3 01          	add    $0x1,%rbx
  4021d7:	48 89 c5             	mov    %rax,%rbp
  4021da:	4c 39 e3             	cmp    %r12,%rbx
  4021dd:	72 bc                	jb     40219b <rio_readlineb+0x2a>
  4021df:	eb 03                	jmp    4021e4 <rio_readlineb+0x73>
  4021e1:	48 89 c5             	mov    %rax,%rbp
  4021e4:	c6 45 00 00          	movb   $0x0,0x0(%rbp)
  4021e8:	48 89 d8             	mov    %rbx,%rax
  4021eb:	eb 0e                	jmp    4021fb <rio_readlineb+0x8a>
  4021ed:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  4021f4:	eb 05                	jmp    4021fb <rio_readlineb+0x8a>
  4021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  4021fb:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  402200:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
  402207:	00 00 
  402209:	74 05                	je     402210 <rio_readlineb+0x9f>
  40220b:	e8 e0 ea ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  402210:	48 83 c4 18          	add    $0x18,%rsp
  402214:	5b                   	pop    %rbx
  402215:	5d                   	pop    %rbp
  402216:	41 5c                	pop    %r12
  402218:	41 5d                	pop    %r13
  40221a:	c3                   	retq   

000000000040221b <urlencode>:
  40221b:	41 54                	push   %r12
  40221d:	55                   	push   %rbp
  40221e:	53                   	push   %rbx
  40221f:	48 83 ec 10          	sub    $0x10,%rsp
  402223:	48 89 fb             	mov    %rdi,%rbx
  402226:	48 89 f5             	mov    %rsi,%rbp
  402229:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  402230:	00 00 
  402232:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  402237:	31 c0                	xor    %eax,%eax
  402239:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  402240:	f2 ae                	repnz scas %es:(%rdi),%al
  402242:	48 f7 d1             	not    %rcx
  402245:	8d 41 ff             	lea    -0x1(%rcx),%eax
  402248:	e9 aa 00 00 00       	jmpq   4022f7 <urlencode+0xdc>
  40224d:	44 0f b6 03          	movzbl (%rbx),%r8d
  402251:	41 80 f8 2a          	cmp    $0x2a,%r8b
  402255:	0f 94 c2             	sete   %dl
  402258:	41 80 f8 2d          	cmp    $0x2d,%r8b
  40225c:	0f 94 c0             	sete   %al
  40225f:	08 c2                	or     %al,%dl
  402261:	75 24                	jne    402287 <urlencode+0x6c>
  402263:	41 80 f8 2e          	cmp    $0x2e,%r8b
  402267:	74 1e                	je     402287 <urlencode+0x6c>
  402269:	41 80 f8 5f          	cmp    $0x5f,%r8b
  40226d:	74 18                	je     402287 <urlencode+0x6c>
  40226f:	41 8d 40 d0          	lea    -0x30(%r8),%eax
  402273:	3c 09                	cmp    $0x9,%al
  402275:	76 10                	jbe    402287 <urlencode+0x6c>
  402277:	41 8d 40 bf          	lea    -0x41(%r8),%eax
  40227b:	3c 19                	cmp    $0x19,%al
  40227d:	76 08                	jbe    402287 <urlencode+0x6c>
  40227f:	41 8d 40 9f          	lea    -0x61(%r8),%eax
  402283:	3c 19                	cmp    $0x19,%al
  402285:	77 0a                	ja     402291 <urlencode+0x76>
  402287:	44 88 45 00          	mov    %r8b,0x0(%rbp)
  40228b:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
  40228f:	eb 5f                	jmp    4022f0 <urlencode+0xd5>
  402291:	41 80 f8 20          	cmp    $0x20,%r8b
  402295:	75 0a                	jne    4022a1 <urlencode+0x86>
  402297:	c6 45 00 2b          	movb   $0x2b,0x0(%rbp)
  40229b:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
  40229f:	eb 4f                	jmp    4022f0 <urlencode+0xd5>
  4022a1:	41 8d 40 e0          	lea    -0x20(%r8),%eax
  4022a5:	3c 5f                	cmp    $0x5f,%al
  4022a7:	0f 96 c2             	setbe  %dl
  4022aa:	41 80 f8 09          	cmp    $0x9,%r8b
  4022ae:	0f 94 c0             	sete   %al
  4022b1:	08 c2                	or     %al,%dl
  4022b3:	74 50                	je     402305 <urlencode+0xea>
  4022b5:	45 0f b6 c0          	movzbl %r8b,%r8d
  4022b9:	b9 98 35 40 00       	mov    $0x403598,%ecx
  4022be:	ba 08 00 00 00       	mov    $0x8,%edx
  4022c3:	be 01 00 00 00       	mov    $0x1,%esi
  4022c8:	48 89 e7             	mov    %rsp,%rdi
  4022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  4022d0:	e8 ab eb ff ff       	callq  400e80 <__sprintf_chk@plt>
  4022d5:	0f b6 04 24          	movzbl (%rsp),%eax
  4022d9:	88 45 00             	mov    %al,0x0(%rbp)
  4022dc:	0f b6 44 24 01       	movzbl 0x1(%rsp),%eax
  4022e1:	88 45 01             	mov    %al,0x1(%rbp)
  4022e4:	0f b6 44 24 02       	movzbl 0x2(%rsp),%eax
  4022e9:	88 45 02             	mov    %al,0x2(%rbp)
  4022ec:	48 8d 6d 03          	lea    0x3(%rbp),%rbp
  4022f0:	48 83 c3 01          	add    $0x1,%rbx
  4022f4:	44 89 e0             	mov    %r12d,%eax
  4022f7:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  4022fb:	85 c0                	test   %eax,%eax
  4022fd:	0f 85 4a ff ff ff    	jne    40224d <urlencode+0x32>
  402303:	eb 05                	jmp    40230a <urlencode+0xef>
  402305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40230a:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  40230f:	64 48 33 34 25 28 00 	xor    %fs:0x28,%rsi
  402316:	00 00 
  402318:	74 05                	je     40231f <urlencode+0x104>
  40231a:	e8 d1 e9 ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  40231f:	48 83 c4 10          	add    $0x10,%rsp
  402323:	5b                   	pop    %rbx
  402324:	5d                   	pop    %rbp
  402325:	41 5c                	pop    %r12
  402327:	c3                   	retq   

0000000000402328 <submitr>:
  402328:	41 57                	push   %r15
  40232a:	41 56                	push   %r14
  40232c:	41 55                	push   %r13
  40232e:	41 54                	push   %r12
  402330:	55                   	push   %rbp
  402331:	53                   	push   %rbx
  402332:	48 81 ec 58 a0 00 00 	sub    $0xa058,%rsp
  402339:	49 89 fc             	mov    %rdi,%r12
  40233c:	89 74 24 04          	mov    %esi,0x4(%rsp)
  402340:	49 89 d7             	mov    %rdx,%r15
  402343:	49 89 ce             	mov    %rcx,%r14
  402346:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  40234b:	4d 89 cd             	mov    %r9,%r13
  40234e:	48 8b 9c 24 90 a0 00 	mov    0xa090(%rsp),%rbx
  402355:	00 
  402356:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  40235d:	00 00 
  40235f:	48 89 84 24 48 a0 00 	mov    %rax,0xa048(%rsp)
  402366:	00 
  402367:	31 c0                	xor    %eax,%eax
  402369:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%rsp)
  402370:	00 
  402371:	ba 00 00 00 00       	mov    $0x0,%edx
  402376:	be 01 00 00 00       	mov    $0x1,%esi
  40237b:	bf 02 00 00 00       	mov    $0x2,%edi
  402380:	e8 0b eb ff ff       	callq  400e90 <socket@plt>
  402385:	85 c0                	test   %eax,%eax
  402387:	79 4e                	jns    4023d7 <submitr+0xaf>
  402389:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402390:	3a 20 43 
  402393:	48 89 03             	mov    %rax,(%rbx)
  402396:	48 b8 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rax
  40239d:	20 75 6e 
  4023a0:	48 89 43 08          	mov    %rax,0x8(%rbx)
  4023a4:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  4023ab:	74 6f 20 
  4023ae:	48 89 43 10          	mov    %rax,0x10(%rbx)
  4023b2:	48 b8 63 72 65 61 74 	movabs $0x7320657461657263,%rax
  4023b9:	65 20 73 
  4023bc:	48 89 43 18          	mov    %rax,0x18(%rbx)
  4023c0:	c7 43 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%rbx)
  4023c7:	66 c7 43 24 74 00    	movw   $0x74,0x24(%rbx)
  4023cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4023d2:	e9 97 06 00 00       	jmpq   402a6e <submitr+0x746>
  4023d7:	89 c5                	mov    %eax,%ebp
  4023d9:	4c 89 e7             	mov    %r12,%rdi
  4023dc:	e8 8f e9 ff ff       	callq  400d70 <gethostbyname@plt>
  4023e1:	48 85 c0             	test   %rax,%rax
  4023e4:	75 67                	jne    40244d <submitr+0x125>
  4023e6:	48 b8 45 72 72 6f 72 	movabs $0x44203a726f727245,%rax
  4023ed:	3a 20 44 
  4023f0:	48 89 03             	mov    %rax,(%rbx)
  4023f3:	48 b8 4e 53 20 69 73 	movabs $0x6e7520736920534e,%rax
  4023fa:	20 75 6e 
  4023fd:	48 89 43 08          	mov    %rax,0x8(%rbx)
  402401:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402408:	74 6f 20 
  40240b:	48 89 43 10          	mov    %rax,0x10(%rbx)
  40240f:	48 b8 72 65 73 6f 6c 	movabs $0x2065766c6f736572,%rax
  402416:	76 65 20 
  402419:	48 89 43 18          	mov    %rax,0x18(%rbx)
  40241d:	48 b8 73 65 72 76 65 	movabs $0x6120726576726573,%rax
  402424:	72 20 61 
  402427:	48 89 43 20          	mov    %rax,0x20(%rbx)
  40242b:	c7 43 28 64 64 72 65 	movl   $0x65726464,0x28(%rbx)
  402432:	66 c7 43 2c 73 73    	movw   $0x7373,0x2c(%rbx)
  402438:	c6 43 2e 00          	movb   $0x0,0x2e(%rbx)
  40243c:	89 ef                	mov    %ebp,%edi
  40243e:	e8 ed e8 ff ff       	callq  400d30 <close@plt>
  402443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402448:	e9 21 06 00 00       	jmpq   402a6e <submitr+0x746>
  40244d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  402454:	00 00 
  402456:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  40245d:	00 00 
  40245f:	66 c7 44 24 20 02 00 	movw   $0x2,0x20(%rsp)
  402466:	48 63 50 14          	movslq 0x14(%rax),%rdx
  40246a:	48 8b 40 18          	mov    0x18(%rax),%rax
  40246e:	48 8b 30             	mov    (%rax),%rsi
  402471:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
  402476:	b9 0c 00 00 00       	mov    $0xc,%ecx
  40247b:	e8 00 e9 ff ff       	callq  400d80 <__memmove_chk@plt>
  402480:	0f b7 44 24 04       	movzwl 0x4(%rsp),%eax
  402485:	66 c1 c8 08          	ror    $0x8,%ax
  402489:	66 89 44 24 22       	mov    %ax,0x22(%rsp)
  40248e:	ba 10 00 00 00       	mov    $0x10,%edx
  402493:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  402498:	89 ef                	mov    %ebp,%edi
  40249a:	e8 c1 e9 ff ff       	callq  400e60 <connect@plt>
  40249f:	85 c0                	test   %eax,%eax
  4024a1:	79 59                	jns    4024fc <submitr+0x1d4>
  4024a3:	48 b8 45 72 72 6f 72 	movabs $0x55203a726f727245,%rax
  4024aa:	3a 20 55 
  4024ad:	48 89 03             	mov    %rax,(%rbx)
  4024b0:	48 b8 6e 61 62 6c 65 	movabs $0x6f7420656c62616e,%rax
  4024b7:	20 74 6f 
  4024ba:	48 89 43 08          	mov    %rax,0x8(%rbx)
  4024be:	48 b8 20 63 6f 6e 6e 	movabs $0x7463656e6e6f6320,%rax
  4024c5:	65 63 74 
  4024c8:	48 89 43 10          	mov    %rax,0x10(%rbx)
  4024cc:	48 b8 20 74 6f 20 74 	movabs $0x20656874206f7420,%rax
  4024d3:	68 65 20 
  4024d6:	48 89 43 18          	mov    %rax,0x18(%rbx)
  4024da:	c7 43 20 73 65 72 76 	movl   $0x76726573,0x20(%rbx)
  4024e1:	66 c7 43 24 65 72    	movw   $0x7265,0x24(%rbx)
  4024e7:	c6 43 26 00          	movb   $0x0,0x26(%rbx)
  4024eb:	89 ef                	mov    %ebp,%edi
  4024ed:	e8 3e e8 ff ff       	callq  400d30 <close@plt>
  4024f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4024f7:	e9 72 05 00 00       	jmpq   402a6e <submitr+0x746>
  4024fc:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  402503:	b8 00 00 00 00       	mov    $0x0,%eax
  402508:	48 89 f1             	mov    %rsi,%rcx
  40250b:	4c 89 ef             	mov    %r13,%rdi
  40250e:	f2 ae                	repnz scas %es:(%rdi),%al
  402510:	48 f7 d1             	not    %rcx
  402513:	48 89 ca             	mov    %rcx,%rdx
  402516:	48 89 f1             	mov    %rsi,%rcx
  402519:	4c 89 ff             	mov    %r15,%rdi
  40251c:	f2 ae                	repnz scas %es:(%rdi),%al
  40251e:	48 f7 d1             	not    %rcx
  402521:	49 89 c8             	mov    %rcx,%r8
  402524:	48 89 f1             	mov    %rsi,%rcx
  402527:	4c 89 f7             	mov    %r14,%rdi
  40252a:	f2 ae                	repnz scas %es:(%rdi),%al
  40252c:	48 f7 d1             	not    %rcx
  40252f:	4d 8d 44 08 fe       	lea    -0x2(%r8,%rcx,1),%r8
  402534:	48 89 f1             	mov    %rsi,%rcx
  402537:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  40253c:	f2 ae                	repnz scas %es:(%rdi),%al
  40253e:	48 89 c8             	mov    %rcx,%rax
  402541:	48 f7 d0             	not    %rax
  402544:	49 8d 4c 00 ff       	lea    -0x1(%r8,%rax,1),%rcx
  402549:	48 8d 44 52 fd       	lea    -0x3(%rdx,%rdx,2),%rax
  40254e:	48 8d 84 01 80 00 00 	lea    0x80(%rcx,%rax,1),%rax
  402555:	00 
  402556:	48 3d 00 20 00 00    	cmp    $0x2000,%rax
  40255c:	76 72                	jbe    4025d0 <submitr+0x2a8>
  40255e:	48 b8 45 72 72 6f 72 	movabs $0x52203a726f727245,%rax
  402565:	3a 20 52 
  402568:	48 89 03             	mov    %rax,(%rbx)
  40256b:	48 b8 65 73 75 6c 74 	movabs $0x747320746c757365,%rax
  402572:	20 73 74 
  402575:	48 89 43 08          	mov    %rax,0x8(%rbx)
  402579:	48 b8 72 69 6e 67 20 	movabs $0x6f6f7420676e6972,%rax
  402580:	74 6f 6f 
  402583:	48 89 43 10          	mov    %rax,0x10(%rbx)
  402587:	48 b8 20 6c 61 72 67 	movabs $0x202e656772616c20,%rax
  40258e:	65 2e 20 
  402591:	48 89 43 18          	mov    %rax,0x18(%rbx)
  402595:	48 b8 49 6e 63 72 65 	movabs $0x6573616572636e49,%rax
  40259c:	61 73 65 
  40259f:	48 89 43 20          	mov    %rax,0x20(%rbx)
  4025a3:	48 b8 20 53 55 42 4d 	movabs $0x5254494d42555320,%rax
  4025aa:	49 54 52 
  4025ad:	48 89 43 28          	mov    %rax,0x28(%rbx)
  4025b1:	48 b8 5f 4d 41 58 42 	movabs $0x46554258414d5f,%rax
  4025b8:	55 46 00 
  4025bb:	48 89 43 30          	mov    %rax,0x30(%rbx)
  4025bf:	89 ef                	mov    %ebp,%edi
  4025c1:	e8 6a e7 ff ff       	callq  400d30 <close@plt>
  4025c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4025cb:	e9 9e 04 00 00       	jmpq   402a6e <submitr+0x746>
  4025d0:	48 8d b4 24 40 40 00 	lea    0x4040(%rsp),%rsi
  4025d7:	00 
  4025d8:	b9 00 04 00 00       	mov    $0x400,%ecx
  4025dd:	b8 00 00 00 00       	mov    $0x0,%eax
  4025e2:	48 89 f7             	mov    %rsi,%rdi
  4025e5:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  4025e8:	4c 89 ef             	mov    %r13,%rdi
  4025eb:	e8 2b fc ff ff       	callq  40221b <urlencode>
  4025f0:	85 c0                	test   %eax,%eax
  4025f2:	0f 89 8a 00 00 00    	jns    402682 <submitr+0x35a>
  4025f8:	48 b8 45 72 72 6f 72 	movabs $0x52203a726f727245,%rax
  4025ff:	3a 20 52 
  402602:	48 89 03             	mov    %rax,(%rbx)
  402605:	48 b8 65 73 75 6c 74 	movabs $0x747320746c757365,%rax
  40260c:	20 73 74 
  40260f:	48 89 43 08          	mov    %rax,0x8(%rbx)
  402613:	48 b8 72 69 6e 67 20 	movabs $0x6e6f6320676e6972,%rax
  40261a:	63 6f 6e 
  40261d:	48 89 43 10          	mov    %rax,0x10(%rbx)
  402621:	48 b8 74 61 69 6e 73 	movabs $0x6e6120736e696174,%rax
  402628:	20 61 6e 
  40262b:	48 89 43 18          	mov    %rax,0x18(%rbx)
  40262f:	48 b8 20 69 6c 6c 65 	movabs $0x6c6167656c6c6920,%rax
  402636:	67 61 6c 
  402639:	48 89 43 20          	mov    %rax,0x20(%rbx)
  40263d:	48 b8 20 6f 72 20 75 	movabs $0x72706e7520726f20,%rax
  402644:	6e 70 72 
  402647:	48 89 43 28          	mov    %rax,0x28(%rbx)
  40264b:	48 b8 69 6e 74 61 62 	movabs $0x20656c6261746e69,%rax
  402652:	6c 65 20 
  402655:	48 89 43 30          	mov    %rax,0x30(%rbx)
  402659:	48 b8 63 68 61 72 61 	movabs $0x6574636172616863,%rax
  402660:	63 74 65 
  402663:	48 89 43 38          	mov    %rax,0x38(%rbx)
  402667:	66 c7 43 40 72 2e    	movw   $0x2e72,0x40(%rbx)
  40266d:	c6 43 42 00          	movb   $0x0,0x42(%rbx)
  402671:	89 ef                	mov    %ebp,%edi
  402673:	e8 b8 e6 ff ff       	callq  400d30 <close@plt>
  402678:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40267d:	e9 ec 03 00 00       	jmpq   402a6e <submitr+0x746>
  402682:	4c 8d ac 24 40 20 00 	lea    0x2040(%rsp),%r13
  402689:	00 
  40268a:	41 54                	push   %r12
  40268c:	48 8d 84 24 48 40 00 	lea    0x4048(%rsp),%rax
  402693:	00 
  402694:	50                   	push   %rax
  402695:	4d 89 f9             	mov    %r15,%r9
  402698:	4d 89 f0             	mov    %r14,%r8
  40269b:	b9 28 35 40 00       	mov    $0x403528,%ecx
  4026a0:	ba 00 20 00 00       	mov    $0x2000,%edx
  4026a5:	be 01 00 00 00       	mov    $0x1,%esi
  4026aa:	4c 89 ef             	mov    %r13,%rdi
  4026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  4026b2:	e8 c9 e7 ff ff       	callq  400e80 <__sprintf_chk@plt>
  4026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  4026bc:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  4026c3:	4c 89 ef             	mov    %r13,%rdi
  4026c6:	f2 ae                	repnz scas %es:(%rdi),%al
  4026c8:	48 f7 d1             	not    %rcx
  4026cb:	48 8d 51 ff          	lea    -0x1(%rcx),%rdx
  4026cf:	4c 89 ee             	mov    %r13,%rsi
  4026d2:	89 ef                	mov    %ebp,%edi
  4026d4:	e8 b1 f9 ff ff       	callq  40208a <rio_writen>
  4026d9:	48 83 c4 10          	add    $0x10,%rsp
  4026dd:	48 85 c0             	test   %rax,%rax
  4026e0:	79 6e                	jns    402750 <submitr+0x428>
  4026e2:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  4026e9:	3a 20 43 
  4026ec:	48 89 03             	mov    %rax,(%rbx)
  4026ef:	48 b8 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rax
  4026f6:	20 75 6e 
  4026f9:	48 89 43 08          	mov    %rax,0x8(%rbx)
  4026fd:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402704:	74 6f 20 
  402707:	48 89 43 10          	mov    %rax,0x10(%rbx)
  40270b:	48 b8 77 72 69 74 65 	movabs $0x6f74206574697277,%rax
  402712:	20 74 6f 
  402715:	48 89 43 18          	mov    %rax,0x18(%rbx)
  402719:	48 b8 20 74 68 65 20 	movabs $0x7365722065687420,%rax
  402720:	72 65 73 
  402723:	48 89 43 20          	mov    %rax,0x20(%rbx)
  402727:	48 b8 75 6c 74 20 73 	movabs $0x7672657320746c75,%rax
  40272e:	65 72 76 
  402731:	48 89 43 28          	mov    %rax,0x28(%rbx)
  402735:	66 c7 43 30 65 72    	movw   $0x7265,0x30(%rbx)
  40273b:	c6 43 32 00          	movb   $0x0,0x32(%rbx)
  40273f:	89 ef                	mov    %ebp,%edi
  402741:	e8 ea e5 ff ff       	callq  400d30 <close@plt>
  402746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40274b:	e9 1e 03 00 00       	jmpq   402a6e <submitr+0x746>
  402750:	89 ee                	mov    %ebp,%esi
  402752:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  402757:	e8 ee f8 ff ff       	callq  40204a <rio_readinitb>
  40275c:	ba 00 20 00 00       	mov    $0x2000,%edx
  402761:	48 8d b4 24 40 20 00 	lea    0x2040(%rsp),%rsi
  402768:	00 
  402769:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  40276e:	e8 fe f9 ff ff       	callq  402171 <rio_readlineb>
  402773:	48 85 c0             	test   %rax,%rax
  402776:	7f 7d                	jg     4027f5 <submitr+0x4cd>
  402778:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  40277f:	3a 20 43 
  402782:	48 89 03             	mov    %rax,(%rbx)
  402785:	48 b8 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rax
  40278c:	20 75 6e 
  40278f:	48 89 43 08          	mov    %rax,0x8(%rbx)
  402793:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  40279a:	74 6f 20 
  40279d:	48 89 43 10          	mov    %rax,0x10(%rbx)
  4027a1:	48 b8 72 65 61 64 20 	movabs $0x7269662064616572,%rax
  4027a8:	66 69 72 
  4027ab:	48 89 43 18          	mov    %rax,0x18(%rbx)
  4027af:	48 b8 73 74 20 68 65 	movabs $0x6564616568207473,%rax
  4027b6:	61 64 65 
  4027b9:	48 89 43 20          	mov    %rax,0x20(%rbx)
  4027bd:	48 b8 72 20 66 72 6f 	movabs $0x72206d6f72662072,%rax
  4027c4:	6d 20 72 
  4027c7:	48 89 43 28          	mov    %rax,0x28(%rbx)
  4027cb:	48 b8 65 73 75 6c 74 	movabs $0x657320746c757365,%rax
  4027d2:	20 73 65 
  4027d5:	48 89 43 30          	mov    %rax,0x30(%rbx)
  4027d9:	c7 43 38 72 76 65 72 	movl   $0x72657672,0x38(%rbx)
  4027e0:	c6 43 3c 00          	movb   $0x0,0x3c(%rbx)
  4027e4:	89 ef                	mov    %ebp,%edi
  4027e6:	e8 45 e5 ff ff       	callq  400d30 <close@plt>
  4027eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4027f0:	e9 79 02 00 00       	jmpq   402a6e <submitr+0x746>
  4027f5:	4c 8d 84 24 40 80 00 	lea    0x8040(%rsp),%r8
  4027fc:	00 
  4027fd:	48 8d 4c 24 1c       	lea    0x1c(%rsp),%rcx
  402802:	48 8d 94 24 40 60 00 	lea    0x6040(%rsp),%rdx
  402809:	00 
  40280a:	be 9f 35 40 00       	mov    $0x40359f,%esi
  40280f:	48 8d bc 24 40 20 00 	lea    0x2040(%rsp),%rdi
  402816:	00 
  402817:	b8 00 00 00 00       	mov    $0x0,%eax
  40281c:	e8 bf e5 ff ff       	callq  400de0 <__isoc99_sscanf@plt>
  402821:	e9 95 00 00 00       	jmpq   4028bb <submitr+0x593>
  402826:	ba 00 20 00 00       	mov    $0x2000,%edx
  40282b:	48 8d b4 24 40 20 00 	lea    0x2040(%rsp),%rsi
  402832:	00 
  402833:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  402838:	e8 34 f9 ff ff       	callq  402171 <rio_readlineb>
  40283d:	48 85 c0             	test   %rax,%rax
  402840:	7f 79                	jg     4028bb <submitr+0x593>
  402842:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402849:	3a 20 43 
  40284c:	48 89 03             	mov    %rax,(%rbx)
  40284f:	48 b8 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rax
  402856:	20 75 6e 
  402859:	48 89 43 08          	mov    %rax,0x8(%rbx)
  40285d:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402864:	74 6f 20 
  402867:	48 89 43 10          	mov    %rax,0x10(%rbx)
  40286b:	48 b8 72 65 61 64 20 	movabs $0x6165682064616572,%rax
  402872:	68 65 61 
  402875:	48 89 43 18          	mov    %rax,0x18(%rbx)
  402879:	48 b8 64 65 72 73 20 	movabs $0x6f72662073726564,%rax
  402880:	66 72 6f 
  402883:	48 89 43 20          	mov    %rax,0x20(%rbx)
  402887:	48 b8 6d 20 74 68 65 	movabs $0x657220656874206d,%rax
  40288e:	20 72 65 
  402891:	48 89 43 28          	mov    %rax,0x28(%rbx)
  402895:	48 b8 73 75 6c 74 20 	movabs $0x72657320746c7573,%rax
  40289c:	73 65 72 
  40289f:	48 89 43 30          	mov    %rax,0x30(%rbx)
  4028a3:	c7 43 38 76 65 72 00 	movl   $0x726576,0x38(%rbx)
  4028aa:	89 ef                	mov    %ebp,%edi
  4028ac:	e8 7f e4 ff ff       	callq  400d30 <close@plt>
  4028b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4028b6:	e9 b3 01 00 00       	jmpq   402a6e <submitr+0x746>
  4028bb:	0f b6 94 24 40 20 00 	movzbl 0x2040(%rsp),%edx
  4028c2:	00 
  4028c3:	b8 0d 00 00 00       	mov    $0xd,%eax
  4028c8:	29 d0                	sub    %edx,%eax
  4028ca:	75 1b                	jne    4028e7 <submitr+0x5bf>
  4028cc:	0f b6 94 24 41 20 00 	movzbl 0x2041(%rsp),%edx
  4028d3:	00 
  4028d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  4028d9:	29 d0                	sub    %edx,%eax
  4028db:	75 0a                	jne    4028e7 <submitr+0x5bf>
  4028dd:	0f b6 84 24 42 20 00 	movzbl 0x2042(%rsp),%eax
  4028e4:	00 
  4028e5:	f7 d8                	neg    %eax
  4028e7:	85 c0                	test   %eax,%eax
  4028e9:	0f 85 37 ff ff ff    	jne    402826 <submitr+0x4fe>
  4028ef:	ba 00 20 00 00       	mov    $0x2000,%edx
  4028f4:	48 8d b4 24 40 20 00 	lea    0x2040(%rsp),%rsi
  4028fb:	00 
  4028fc:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  402901:	e8 6b f8 ff ff       	callq  402171 <rio_readlineb>
  402906:	48 85 c0             	test   %rax,%rax
  402909:	0f 8f 83 00 00 00    	jg     402992 <submitr+0x66a>
  40290f:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402916:	3a 20 43 
  402919:	48 89 03             	mov    %rax,(%rbx)
  40291c:	48 b8 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rax
  402923:	20 75 6e 
  402926:	48 89 43 08          	mov    %rax,0x8(%rbx)
  40292a:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402931:	74 6f 20 
  402934:	48 89 43 10          	mov    %rax,0x10(%rbx)
  402938:	48 b8 72 65 61 64 20 	movabs $0x6174732064616572,%rax
  40293f:	73 74 61 
  402942:	48 89 43 18          	mov    %rax,0x18(%rbx)
  402946:	48 b8 74 75 73 20 6d 	movabs $0x7373656d20737574,%rax
  40294d:	65 73 73 
  402950:	48 89 43 20          	mov    %rax,0x20(%rbx)
  402954:	48 b8 61 67 65 20 66 	movabs $0x6d6f726620656761,%rax
  40295b:	72 6f 6d 
  40295e:	48 89 43 28          	mov    %rax,0x28(%rbx)
  402962:	48 b8 20 72 65 73 75 	movabs $0x20746c7573657220,%rax
  402969:	6c 74 20 
  40296c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  402970:	c7 43 38 73 65 72 76 	movl   $0x76726573,0x38(%rbx)
  402977:	66 c7 43 3c 65 72    	movw   $0x7265,0x3c(%rbx)
  40297d:	c6 43 3e 00          	movb   $0x0,0x3e(%rbx)
  402981:	89 ef                	mov    %ebp,%edi
  402983:	e8 a8 e3 ff ff       	callq  400d30 <close@plt>
  402988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40298d:	e9 dc 00 00 00       	jmpq   402a6e <submitr+0x746>
  402992:	44 8b 44 24 1c       	mov    0x1c(%rsp),%r8d
  402997:	41 81 f8 c8 00 00 00 	cmp    $0xc8,%r8d
  40299e:	74 37                	je     4029d7 <submitr+0x6af>
  4029a0:	4c 8d 8c 24 40 80 00 	lea    0x8040(%rsp),%r9
  4029a7:	00 
  4029a8:	b9 68 35 40 00       	mov    $0x403568,%ecx
  4029ad:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  4029b4:	be 01 00 00 00       	mov    $0x1,%esi
  4029b9:	48 89 df             	mov    %rbx,%rdi
  4029bc:	b8 00 00 00 00       	mov    $0x0,%eax
  4029c1:	e8 ba e4 ff ff       	callq  400e80 <__sprintf_chk@plt>
  4029c6:	89 ef                	mov    %ebp,%edi
  4029c8:	e8 63 e3 ff ff       	callq  400d30 <close@plt>
  4029cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4029d2:	e9 97 00 00 00       	jmpq   402a6e <submitr+0x746>
  4029d7:	48 8d b4 24 40 20 00 	lea    0x2040(%rsp),%rsi
  4029de:	00 
  4029df:	48 89 df             	mov    %rbx,%rdi
  4029e2:	e8 d9 e2 ff ff       	callq  400cc0 <strcpy@plt>
  4029e7:	89 ef                	mov    %ebp,%edi
  4029e9:	e8 42 e3 ff ff       	callq  400d30 <close@plt>
  4029ee:	0f b6 03             	movzbl (%rbx),%eax
  4029f1:	ba 4f 00 00 00       	mov    $0x4f,%edx
  4029f6:	29 c2                	sub    %eax,%edx
  4029f8:	75 22                	jne    402a1c <submitr+0x6f4>
  4029fa:	0f b6 4b 01          	movzbl 0x1(%rbx),%ecx
  4029fe:	b8 4b 00 00 00       	mov    $0x4b,%eax
  402a03:	29 c8                	sub    %ecx,%eax
  402a05:	75 17                	jne    402a1e <submitr+0x6f6>
  402a07:	0f b6 4b 02          	movzbl 0x2(%rbx),%ecx
  402a0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  402a10:	29 c8                	sub    %ecx,%eax
  402a12:	75 0a                	jne    402a1e <submitr+0x6f6>
  402a14:	0f b6 43 03          	movzbl 0x3(%rbx),%eax
  402a18:	f7 d8                	neg    %eax
  402a1a:	eb 02                	jmp    402a1e <submitr+0x6f6>
  402a1c:	89 d0                	mov    %edx,%eax
  402a1e:	85 c0                	test   %eax,%eax
  402a20:	74 40                	je     402a62 <submitr+0x73a>
  402a22:	bf b0 35 40 00       	mov    $0x4035b0,%edi
  402a27:	b9 05 00 00 00       	mov    $0x5,%ecx
  402a2c:	48 89 de             	mov    %rbx,%rsi
  402a2f:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  402a31:	0f 97 c0             	seta   %al
  402a34:	0f 92 c1             	setb   %cl
  402a37:	29 c8                	sub    %ecx,%eax
  402a39:	0f be c0             	movsbl %al,%eax
  402a3c:	85 c0                	test   %eax,%eax
  402a3e:	74 2e                	je     402a6e <submitr+0x746>
  402a40:	85 d2                	test   %edx,%edx
  402a42:	75 13                	jne    402a57 <submitr+0x72f>
  402a44:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  402a48:	ba 4b 00 00 00       	mov    $0x4b,%edx
  402a4d:	29 c2                	sub    %eax,%edx
  402a4f:	75 06                	jne    402a57 <submitr+0x72f>
  402a51:	0f b6 53 02          	movzbl 0x2(%rbx),%edx
  402a55:	f7 da                	neg    %edx
  402a57:	85 d2                	test   %edx,%edx
  402a59:	75 0e                	jne    402a69 <submitr+0x741>
  402a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  402a60:	eb 0c                	jmp    402a6e <submitr+0x746>
  402a62:	b8 00 00 00 00       	mov    $0x0,%eax
  402a67:	eb 05                	jmp    402a6e <submitr+0x746>
  402a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402a6e:	48 8b 9c 24 48 a0 00 	mov    0xa048(%rsp),%rbx
  402a75:	00 
  402a76:	64 48 33 1c 25 28 00 	xor    %fs:0x28,%rbx
  402a7d:	00 00 
  402a7f:	74 05                	je     402a86 <submitr+0x75e>
  402a81:	e8 6a e2 ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  402a86:	48 81 c4 58 a0 00 00 	add    $0xa058,%rsp
  402a8d:	5b                   	pop    %rbx
  402a8e:	5d                   	pop    %rbp
  402a8f:	41 5c                	pop    %r12
  402a91:	41 5d                	pop    %r13
  402a93:	41 5e                	pop    %r14
  402a95:	41 5f                	pop    %r15
  402a97:	c3                   	retq   

0000000000402a98 <init_timeout>:
  402a98:	85 ff                	test   %edi,%edi
  402a9a:	74 23                	je     402abf <init_timeout+0x27>
  402a9c:	53                   	push   %rbx
  402a9d:	89 fb                	mov    %edi,%ebx
  402a9f:	85 ff                	test   %edi,%edi
  402aa1:	79 05                	jns    402aa8 <init_timeout+0x10>
  402aa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  402aa8:	be 5c 20 40 00       	mov    $0x40205c,%esi
  402aad:	bf 0e 00 00 00       	mov    $0xe,%edi
  402ab2:	e8 a9 e2 ff ff       	callq  400d60 <signal@plt>
  402ab7:	89 df                	mov    %ebx,%edi
  402ab9:	e8 62 e2 ff ff       	callq  400d20 <alarm@plt>
  402abe:	5b                   	pop    %rbx
  402abf:	f3 c3                	repz retq 

0000000000402ac1 <init_driver>:
  402ac1:	55                   	push   %rbp
  402ac2:	53                   	push   %rbx
  402ac3:	48 83 ec 28          	sub    $0x28,%rsp
  402ac7:	48 89 fd             	mov    %rdi,%rbp
  402aca:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  402ad1:	00 00 
  402ad3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  402ad8:	31 c0                	xor    %eax,%eax
  402ada:	be 01 00 00 00       	mov    $0x1,%esi
  402adf:	bf 0d 00 00 00       	mov    $0xd,%edi
  402ae4:	e8 77 e2 ff ff       	callq  400d60 <signal@plt>
  402ae9:	be 01 00 00 00       	mov    $0x1,%esi
  402aee:	bf 1d 00 00 00       	mov    $0x1d,%edi
  402af3:	e8 68 e2 ff ff       	callq  400d60 <signal@plt>
  402af8:	be 01 00 00 00       	mov    $0x1,%esi
  402afd:	bf 1d 00 00 00       	mov    $0x1d,%edi
  402b02:	e8 59 e2 ff ff       	callq  400d60 <signal@plt>
  402b07:	ba 00 00 00 00       	mov    $0x0,%edx
  402b0c:	be 01 00 00 00       	mov    $0x1,%esi
  402b11:	bf 02 00 00 00       	mov    $0x2,%edi
  402b16:	e8 75 e3 ff ff       	callq  400e90 <socket@plt>
  402b1b:	85 c0                	test   %eax,%eax
  402b1d:	79 4f                	jns    402b6e <init_driver+0xad>
  402b1f:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402b26:	3a 20 43 
  402b29:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402b2d:	48 b8 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rax
  402b34:	20 75 6e 
  402b37:	48 89 45 08          	mov    %rax,0x8(%rbp)
  402b3b:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402b42:	74 6f 20 
  402b45:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402b49:	48 b8 63 72 65 61 74 	movabs $0x7320657461657263,%rax
  402b50:	65 20 73 
  402b53:	48 89 45 18          	mov    %rax,0x18(%rbp)
  402b57:	c7 45 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%rbp)
  402b5e:	66 c7 45 24 74 00    	movw   $0x74,0x24(%rbp)
  402b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402b69:	e9 2a 01 00 00       	jmpq   402c98 <init_driver+0x1d7>
  402b6e:	89 c3                	mov    %eax,%ebx
  402b70:	bf b5 35 40 00       	mov    $0x4035b5,%edi
  402b75:	e8 f6 e1 ff ff       	callq  400d70 <gethostbyname@plt>
  402b7a:	48 85 c0             	test   %rax,%rax
  402b7d:	75 68                	jne    402be7 <init_driver+0x126>
  402b7f:	48 b8 45 72 72 6f 72 	movabs $0x44203a726f727245,%rax
  402b86:	3a 20 44 
  402b89:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402b8d:	48 b8 4e 53 20 69 73 	movabs $0x6e7520736920534e,%rax
  402b94:	20 75 6e 
  402b97:	48 89 45 08          	mov    %rax,0x8(%rbp)
  402b9b:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402ba2:	74 6f 20 
  402ba5:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402ba9:	48 b8 72 65 73 6f 6c 	movabs $0x2065766c6f736572,%rax
  402bb0:	76 65 20 
  402bb3:	48 89 45 18          	mov    %rax,0x18(%rbp)
  402bb7:	48 b8 73 65 72 76 65 	movabs $0x6120726576726573,%rax
  402bbe:	72 20 61 
  402bc1:	48 89 45 20          	mov    %rax,0x20(%rbp)
  402bc5:	c7 45 28 64 64 72 65 	movl   $0x65726464,0x28(%rbp)
  402bcc:	66 c7 45 2c 73 73    	movw   $0x7373,0x2c(%rbp)
  402bd2:	c6 45 2e 00          	movb   $0x0,0x2e(%rbp)
  402bd6:	89 df                	mov    %ebx,%edi
  402bd8:	e8 53 e1 ff ff       	callq  400d30 <close@plt>
  402bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402be2:	e9 b1 00 00 00       	jmpq   402c98 <init_driver+0x1d7>
  402be7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  402bee:	00 
  402bef:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  402bf6:	00 00 
  402bf8:	66 c7 04 24 02 00    	movw   $0x2,(%rsp)
  402bfe:	48 63 50 14          	movslq 0x14(%rax),%rdx
  402c02:	48 8b 40 18          	mov    0x18(%rax),%rax
  402c06:	48 8b 30             	mov    (%rax),%rsi
  402c09:	48 8d 7c 24 04       	lea    0x4(%rsp),%rdi
  402c0e:	b9 0c 00 00 00       	mov    $0xc,%ecx
  402c13:	e8 68 e1 ff ff       	callq  400d80 <__memmove_chk@plt>
  402c18:	66 c7 44 24 02 3c 9a 	movw   $0x9a3c,0x2(%rsp)
  402c1f:	ba 10 00 00 00       	mov    $0x10,%edx
  402c24:	48 89 e6             	mov    %rsp,%rsi
  402c27:	89 df                	mov    %ebx,%edi
  402c29:	e8 32 e2 ff ff       	callq  400e60 <connect@plt>
  402c2e:	85 c0                	test   %eax,%eax
  402c30:	79 50                	jns    402c82 <init_driver+0x1c1>
  402c32:	48 b8 45 72 72 6f 72 	movabs $0x55203a726f727245,%rax
  402c39:	3a 20 55 
  402c3c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402c40:	48 b8 6e 61 62 6c 65 	movabs $0x6f7420656c62616e,%rax
  402c47:	20 74 6f 
  402c4a:	48 89 45 08          	mov    %rax,0x8(%rbp)
  402c4e:	48 b8 20 63 6f 6e 6e 	movabs $0x7463656e6e6f6320,%rax
  402c55:	65 63 74 
  402c58:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402c5c:	48 b8 20 74 6f 20 73 	movabs $0x76726573206f7420,%rax
  402c63:	65 72 76 
  402c66:	48 89 45 18          	mov    %rax,0x18(%rbp)
  402c6a:	66 c7 45 20 65 72    	movw   $0x7265,0x20(%rbp)
  402c70:	c6 45 22 00          	movb   $0x0,0x22(%rbp)
  402c74:	89 df                	mov    %ebx,%edi
  402c76:	e8 b5 e0 ff ff       	callq  400d30 <close@plt>
  402c7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402c80:	eb 16                	jmp    402c98 <init_driver+0x1d7>
  402c82:	89 df                	mov    %ebx,%edi
  402c84:	e8 a7 e0 ff ff       	callq  400d30 <close@plt>
  402c89:	66 c7 45 00 4f 4b    	movw   $0x4b4f,0x0(%rbp)
  402c8f:	c6 45 02 00          	movb   $0x0,0x2(%rbp)
  402c93:	b8 00 00 00 00       	mov    $0x0,%eax
  402c98:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  402c9d:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
  402ca4:	00 00 
  402ca6:	74 05                	je     402cad <init_driver+0x1ec>
  402ca8:	e8 43 e0 ff ff       	callq  400cf0 <__stack_chk_fail@plt>
  402cad:	48 83 c4 28          	add    $0x28,%rsp
  402cb1:	5b                   	pop    %rbx
  402cb2:	5d                   	pop    %rbp
  402cb3:	c3                   	retq   

0000000000402cb4 <driver_post>:
  402cb4:	53                   	push   %rbx
  402cb5:	4c 89 cb             	mov    %r9,%rbx
  402cb8:	45 85 c0             	test   %r8d,%r8d
  402cbb:	74 27                	je     402ce4 <driver_post+0x30>
  402cbd:	48 89 ca             	mov    %rcx,%rdx
  402cc0:	be cd 35 40 00       	mov    $0x4035cd,%esi
  402cc5:	bf 01 00 00 00       	mov    $0x1,%edi
  402cca:	b8 00 00 00 00       	mov    $0x0,%eax
  402ccf:	e8 2c e1 ff ff       	callq  400e00 <__printf_chk@plt>
  402cd4:	66 c7 03 4f 4b       	movw   $0x4b4f,(%rbx)
  402cd9:	c6 43 02 00          	movb   $0x0,0x2(%rbx)
  402cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  402ce2:	eb 3f                	jmp    402d23 <driver_post+0x6f>
  402ce4:	48 85 ff             	test   %rdi,%rdi
  402ce7:	74 2c                	je     402d15 <driver_post+0x61>
  402ce9:	80 3f 00             	cmpb   $0x0,(%rdi)
  402cec:	74 27                	je     402d15 <driver_post+0x61>
  402cee:	48 83 ec 08          	sub    $0x8,%rsp
  402cf2:	41 51                	push   %r9
  402cf4:	49 89 c9             	mov    %rcx,%r9
  402cf7:	49 89 d0             	mov    %rdx,%r8
  402cfa:	48 89 f9             	mov    %rdi,%rcx
  402cfd:	48 89 f2             	mov    %rsi,%rdx
  402d00:	be 9a 3c 00 00       	mov    $0x3c9a,%esi
  402d05:	bf b5 35 40 00       	mov    $0x4035b5,%edi
  402d0a:	e8 19 f6 ff ff       	callq  402328 <submitr>
  402d0f:	48 83 c4 10          	add    $0x10,%rsp
  402d13:	eb 0e                	jmp    402d23 <driver_post+0x6f>
  402d15:	66 c7 03 4f 4b       	movw   $0x4b4f,(%rbx)
  402d1a:	c6 43 02 00          	movb   $0x0,0x2(%rbx)
  402d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  402d23:	5b                   	pop    %rbx
  402d24:	c3                   	retq   

0000000000402d25 <check>:
  402d25:	89 f8                	mov    %edi,%eax
  402d27:	c1 e8 1c             	shr    $0x1c,%eax
  402d2a:	85 c0                	test   %eax,%eax
  402d2c:	74 1d                	je     402d4b <check+0x26>
  402d2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  402d33:	eb 0b                	jmp    402d40 <check+0x1b>
  402d35:	89 f8                	mov    %edi,%eax
  402d37:	d3 e8                	shr    %cl,%eax
  402d39:	3c 0a                	cmp    $0xa,%al
  402d3b:	74 14                	je     402d51 <check+0x2c>
  402d3d:	83 c1 08             	add    $0x8,%ecx
  402d40:	83 f9 1f             	cmp    $0x1f,%ecx
  402d43:	7e f0                	jle    402d35 <check+0x10>
  402d45:	b8 01 00 00 00       	mov    $0x1,%eax
  402d4a:	c3                   	retq   
  402d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  402d50:	c3                   	retq   
  402d51:	b8 00 00 00 00       	mov    $0x0,%eax
  402d56:	c3                   	retq   

0000000000402d57 <gencookie>:
  402d57:	53                   	push   %rbx
  402d58:	83 c7 01             	add    $0x1,%edi
  402d5b:	e8 40 df ff ff       	callq  400ca0 <srandom@plt>
  402d60:	e8 5b e0 ff ff       	callq  400dc0 <random@plt>
  402d65:	89 c3                	mov    %eax,%ebx
  402d67:	89 c7                	mov    %eax,%edi
  402d69:	e8 b7 ff ff ff       	callq  402d25 <check>
  402d6e:	85 c0                	test   %eax,%eax
  402d70:	74 ee                	je     402d60 <gencookie+0x9>
  402d72:	89 d8                	mov    %ebx,%eax
  402d74:	5b                   	pop    %rbx
  402d75:	c3                   	retq   
  402d76:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  402d7d:	00 00 00 

0000000000402d80 <__libc_csu_init>:
  402d80:	41 57                	push   %r15
  402d82:	41 56                	push   %r14
  402d84:	41 89 ff             	mov    %edi,%r15d
  402d87:	41 55                	push   %r13
  402d89:	41 54                	push   %r12
  402d8b:	4c 8d 25 7e 10 20 00 	lea    0x20107e(%rip),%r12        # 603e10 <__frame_dummy_init_array_entry>
  402d92:	55                   	push   %rbp
  402d93:	48 8d 2d 7e 10 20 00 	lea    0x20107e(%rip),%rbp        # 603e18 <__init_array_end>
  402d9a:	53                   	push   %rbx
  402d9b:	49 89 f6             	mov    %rsi,%r14
  402d9e:	49 89 d5             	mov    %rdx,%r13
  402da1:	4c 29 e5             	sub    %r12,%rbp
  402da4:	48 83 ec 08          	sub    $0x8,%rsp
  402da8:	48 c1 fd 03          	sar    $0x3,%rbp
  402dac:	e8 97 de ff ff       	callq  400c48 <_init>
  402db1:	48 85 ed             	test   %rbp,%rbp
  402db4:	74 20                	je     402dd6 <__libc_csu_init+0x56>
  402db6:	31 db                	xor    %ebx,%ebx
  402db8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  402dbf:	00 
  402dc0:	4c 89 ea             	mov    %r13,%rdx
  402dc3:	4c 89 f6             	mov    %r14,%rsi
  402dc6:	44 89 ff             	mov    %r15d,%edi
  402dc9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  402dcd:	48 83 c3 01          	add    $0x1,%rbx
  402dd1:	48 39 eb             	cmp    %rbp,%rbx
  402dd4:	75 ea                	jne    402dc0 <__libc_csu_init+0x40>
  402dd6:	48 83 c4 08          	add    $0x8,%rsp
  402dda:	5b                   	pop    %rbx
  402ddb:	5d                   	pop    %rbp
  402ddc:	41 5c                	pop    %r12
  402dde:	41 5d                	pop    %r13
  402de0:	41 5e                	pop    %r14
  402de2:	41 5f                	pop    %r15
  402de4:	c3                   	retq   
  402de5:	90                   	nop
  402de6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  402ded:	00 00 00 

0000000000402df0 <__libc_csu_fini>:
  402df0:	f3 c3                	repz retq 

Disassembly of section .fini:

0000000000402df4 <_fini>:
  402df4:	48 83 ec 08          	sub    $0x8,%rsp
  402df8:	48 83 c4 08          	add    $0x8,%rsp
  402dfc:	c3                   	retq   
