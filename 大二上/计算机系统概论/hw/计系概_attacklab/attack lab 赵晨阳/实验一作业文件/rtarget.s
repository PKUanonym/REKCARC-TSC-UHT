
rtarget:     file format elf64-x86-64


Disassembly of section .init:

0000000000400c48 <_init>:
  400c48:	48 83 ec 08          	sub    $0x8,%rsp
  400c4c:	48 8b 05 a5 43 20 00 	mov    0x2043a5(%rip),%rax        # 604ff8 <__gmon_start__>
  400c53:	48 85 c0             	test   %rax,%rax
  400c56:	74 02                	je     400c5a <_init+0x12>
  400c58:	ff d0                	callq  *%rax
  400c5a:	48 83 c4 08          	add    $0x8,%rsp
  400c5e:	c3                   	retq   

Disassembly of section .plt:

0000000000400c60 <.plt>:
  400c60:	ff 35 a2 43 20 00    	pushq  0x2043a2(%rip)        # 605008 <_GLOBAL_OFFSET_TABLE_+0x8>
  400c66:	ff 25 a4 43 20 00    	jmpq   *0x2043a4(%rip)        # 605010 <_GLOBAL_OFFSET_TABLE_+0x10>
  400c6c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400c70 <strcasecmp@plt>:
  400c70:	ff 25 a2 43 20 00    	jmpq   *0x2043a2(%rip)        # 605018 <strcasecmp@GLIBC_2.2.5>
  400c76:	68 00 00 00 00       	pushq  $0x0
  400c7b:	e9 e0 ff ff ff       	jmpq   400c60 <.plt>

0000000000400c80 <__errno_location@plt>:
  400c80:	ff 25 9a 43 20 00    	jmpq   *0x20439a(%rip)        # 605020 <__errno_location@GLIBC_2.2.5>
  400c86:	68 01 00 00 00       	pushq  $0x1
  400c8b:	e9 d0 ff ff ff       	jmpq   400c60 <.plt>

0000000000400c90 <srandom@plt>:
  400c90:	ff 25 92 43 20 00    	jmpq   *0x204392(%rip)        # 605028 <srandom@GLIBC_2.2.5>
  400c96:	68 02 00 00 00       	pushq  $0x2
  400c9b:	e9 c0 ff ff ff       	jmpq   400c60 <.plt>

0000000000400ca0 <strncmp@plt>:
  400ca0:	ff 25 8a 43 20 00    	jmpq   *0x20438a(%rip)        # 605030 <strncmp@GLIBC_2.2.5>
  400ca6:	68 03 00 00 00       	pushq  $0x3
  400cab:	e9 b0 ff ff ff       	jmpq   400c60 <.plt>

0000000000400cb0 <strcpy@plt>:
  400cb0:	ff 25 82 43 20 00    	jmpq   *0x204382(%rip)        # 605038 <strcpy@GLIBC_2.2.5>
  400cb6:	68 04 00 00 00       	pushq  $0x4
  400cbb:	e9 a0 ff ff ff       	jmpq   400c60 <.plt>

0000000000400cc0 <puts@plt>:
  400cc0:	ff 25 7a 43 20 00    	jmpq   *0x20437a(%rip)        # 605040 <puts@GLIBC_2.2.5>
  400cc6:	68 05 00 00 00       	pushq  $0x5
  400ccb:	e9 90 ff ff ff       	jmpq   400c60 <.plt>

0000000000400cd0 <write@plt>:
  400cd0:	ff 25 72 43 20 00    	jmpq   *0x204372(%rip)        # 605048 <write@GLIBC_2.2.5>
  400cd6:	68 06 00 00 00       	pushq  $0x6
  400cdb:	e9 80 ff ff ff       	jmpq   400c60 <.plt>

0000000000400ce0 <__stack_chk_fail@plt>:
  400ce0:	ff 25 6a 43 20 00    	jmpq   *0x20436a(%rip)        # 605050 <__stack_chk_fail@GLIBC_2.4>
  400ce6:	68 07 00 00 00       	pushq  $0x7
  400ceb:	e9 70 ff ff ff       	jmpq   400c60 <.plt>

0000000000400cf0 <mmap@plt>:
  400cf0:	ff 25 62 43 20 00    	jmpq   *0x204362(%rip)        # 605058 <mmap@GLIBC_2.2.5>
  400cf6:	68 08 00 00 00       	pushq  $0x8
  400cfb:	e9 60 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d00 <memset@plt>:
  400d00:	ff 25 5a 43 20 00    	jmpq   *0x20435a(%rip)        # 605060 <memset@GLIBC_2.2.5>
  400d06:	68 09 00 00 00       	pushq  $0x9
  400d0b:	e9 50 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d10 <alarm@plt>:
  400d10:	ff 25 52 43 20 00    	jmpq   *0x204352(%rip)        # 605068 <alarm@GLIBC_2.2.5>
  400d16:	68 0a 00 00 00       	pushq  $0xa
  400d1b:	e9 40 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d20 <close@plt>:
  400d20:	ff 25 4a 43 20 00    	jmpq   *0x20434a(%rip)        # 605070 <close@GLIBC_2.2.5>
  400d26:	68 0b 00 00 00       	pushq  $0xb
  400d2b:	e9 30 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d30 <read@plt>:
  400d30:	ff 25 42 43 20 00    	jmpq   *0x204342(%rip)        # 605078 <read@GLIBC_2.2.5>
  400d36:	68 0c 00 00 00       	pushq  $0xc
  400d3b:	e9 20 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d40 <signal@plt>:
  400d40:	ff 25 3a 43 20 00    	jmpq   *0x20433a(%rip)        # 605080 <signal@GLIBC_2.2.5>
  400d46:	68 0d 00 00 00       	pushq  $0xd
  400d4b:	e9 10 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d50 <gethostbyname@plt>:
  400d50:	ff 25 32 43 20 00    	jmpq   *0x204332(%rip)        # 605088 <gethostbyname@GLIBC_2.2.5>
  400d56:	68 0e 00 00 00       	pushq  $0xe
  400d5b:	e9 00 ff ff ff       	jmpq   400c60 <.plt>

0000000000400d60 <__memmove_chk@plt>:
  400d60:	ff 25 2a 43 20 00    	jmpq   *0x20432a(%rip)        # 605090 <__memmove_chk@GLIBC_2.3.4>
  400d66:	68 0f 00 00 00       	pushq  $0xf
  400d6b:	e9 f0 fe ff ff       	jmpq   400c60 <.plt>

0000000000400d70 <strtol@plt>:
  400d70:	ff 25 22 43 20 00    	jmpq   *0x204322(%rip)        # 605098 <strtol@GLIBC_2.2.5>
  400d76:	68 10 00 00 00       	pushq  $0x10
  400d7b:	e9 e0 fe ff ff       	jmpq   400c60 <.plt>

0000000000400d80 <memcpy@plt>:
  400d80:	ff 25 1a 43 20 00    	jmpq   *0x20431a(%rip)        # 6050a0 <memcpy@GLIBC_2.14>
  400d86:	68 11 00 00 00       	pushq  $0x11
  400d8b:	e9 d0 fe ff ff       	jmpq   400c60 <.plt>

0000000000400d90 <time@plt>:
  400d90:	ff 25 12 43 20 00    	jmpq   *0x204312(%rip)        # 6050a8 <time@GLIBC_2.2.5>
  400d96:	68 12 00 00 00       	pushq  $0x12
  400d9b:	e9 c0 fe ff ff       	jmpq   400c60 <.plt>

0000000000400da0 <random@plt>:
  400da0:	ff 25 0a 43 20 00    	jmpq   *0x20430a(%rip)        # 6050b0 <random@GLIBC_2.2.5>
  400da6:	68 13 00 00 00       	pushq  $0x13
  400dab:	e9 b0 fe ff ff       	jmpq   400c60 <.plt>

0000000000400db0 <_IO_getc@plt>:
  400db0:	ff 25 02 43 20 00    	jmpq   *0x204302(%rip)        # 6050b8 <_IO_getc@GLIBC_2.2.5>
  400db6:	68 14 00 00 00       	pushq  $0x14
  400dbb:	e9 a0 fe ff ff       	jmpq   400c60 <.plt>

0000000000400dc0 <__isoc99_sscanf@plt>:
  400dc0:	ff 25 fa 42 20 00    	jmpq   *0x2042fa(%rip)        # 6050c0 <__isoc99_sscanf@GLIBC_2.7>
  400dc6:	68 15 00 00 00       	pushq  $0x15
  400dcb:	e9 90 fe ff ff       	jmpq   400c60 <.plt>

0000000000400dd0 <munmap@plt>:
  400dd0:	ff 25 f2 42 20 00    	jmpq   *0x2042f2(%rip)        # 6050c8 <munmap@GLIBC_2.2.5>
  400dd6:	68 16 00 00 00       	pushq  $0x16
  400ddb:	e9 80 fe ff ff       	jmpq   400c60 <.plt>

0000000000400de0 <__printf_chk@plt>:
  400de0:	ff 25 ea 42 20 00    	jmpq   *0x2042ea(%rip)        # 6050d0 <__printf_chk@GLIBC_2.3.4>
  400de6:	68 17 00 00 00       	pushq  $0x17
  400deb:	e9 70 fe ff ff       	jmpq   400c60 <.plt>

0000000000400df0 <fopen@plt>:
  400df0:	ff 25 e2 42 20 00    	jmpq   *0x2042e2(%rip)        # 6050d8 <fopen@GLIBC_2.2.5>
  400df6:	68 18 00 00 00       	pushq  $0x18
  400dfb:	e9 60 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e00 <getopt@plt>:
  400e00:	ff 25 da 42 20 00    	jmpq   *0x2042da(%rip)        # 6050e0 <getopt@GLIBC_2.2.5>
  400e06:	68 19 00 00 00       	pushq  $0x19
  400e0b:	e9 50 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e10 <strtoul@plt>:
  400e10:	ff 25 d2 42 20 00    	jmpq   *0x2042d2(%rip)        # 6050e8 <strtoul@GLIBC_2.2.5>
  400e16:	68 1a 00 00 00       	pushq  $0x1a
  400e1b:	e9 40 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e20 <gethostname@plt>:
  400e20:	ff 25 ca 42 20 00    	jmpq   *0x2042ca(%rip)        # 6050f0 <gethostname@GLIBC_2.2.5>
  400e26:	68 1b 00 00 00       	pushq  $0x1b
  400e2b:	e9 30 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e30 <exit@plt>:
  400e30:	ff 25 c2 42 20 00    	jmpq   *0x2042c2(%rip)        # 6050f8 <exit@GLIBC_2.2.5>
  400e36:	68 1c 00 00 00       	pushq  $0x1c
  400e3b:	e9 20 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e40 <connect@plt>:
  400e40:	ff 25 ba 42 20 00    	jmpq   *0x2042ba(%rip)        # 605100 <connect@GLIBC_2.2.5>
  400e46:	68 1d 00 00 00       	pushq  $0x1d
  400e4b:	e9 10 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e50 <__fprintf_chk@plt>:
  400e50:	ff 25 b2 42 20 00    	jmpq   *0x2042b2(%rip)        # 605108 <__fprintf_chk@GLIBC_2.3.4>
  400e56:	68 1e 00 00 00       	pushq  $0x1e
  400e5b:	e9 00 fe ff ff       	jmpq   400c60 <.plt>

0000000000400e60 <__sprintf_chk@plt>:
  400e60:	ff 25 aa 42 20 00    	jmpq   *0x2042aa(%rip)        # 605110 <__sprintf_chk@GLIBC_2.3.4>
  400e66:	68 1f 00 00 00       	pushq  $0x1f
  400e6b:	e9 f0 fd ff ff       	jmpq   400c60 <.plt>

0000000000400e70 <socket@plt>:
  400e70:	ff 25 a2 42 20 00    	jmpq   *0x2042a2(%rip)        # 605118 <socket@GLIBC_2.2.5>
  400e76:	68 20 00 00 00       	pushq  $0x20
  400e7b:	e9 e0 fd ff ff       	jmpq   400c60 <.plt>

Disassembly of section .text:

0000000000400e80 <_start>:
  400e80:	31 ed                	xor    %ebp,%ebp
  400e82:	49 89 d1             	mov    %rdx,%r9
  400e85:	5e                   	pop    %rsi
  400e86:	48 89 e2             	mov    %rsp,%rdx
  400e89:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  400e8d:	50                   	push   %rax
  400e8e:	54                   	push   %rsp
  400e8f:	49 c7 c0 e0 2f 40 00 	mov    $0x402fe0,%r8
  400e96:	48 c7 c1 70 2f 40 00 	mov    $0x402f70,%rcx
  400e9d:	48 c7 c7 8e 11 40 00 	mov    $0x40118e,%rdi
  400ea4:	ff 15 46 41 20 00    	callq  *0x204146(%rip)        # 604ff0 <__libc_start_main@GLIBC_2.2.5>
  400eaa:	f4                   	hlt    
  400eab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000400eb0 <_dl_relocate_static_pie>:
  400eb0:	f3 c3                	repz retq 
  400eb2:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400eb9:	00 00 00 
  400ebc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400ec0 <deregister_tm_clones>:
  400ec0:	55                   	push   %rbp
  400ec1:	b8 90 54 60 00       	mov    $0x605490,%eax
  400ec6:	48 3d 90 54 60 00    	cmp    $0x605490,%rax
  400ecc:	48 89 e5             	mov    %rsp,%rbp
  400ecf:	74 17                	je     400ee8 <deregister_tm_clones+0x28>
  400ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  400ed6:	48 85 c0             	test   %rax,%rax
  400ed9:	74 0d                	je     400ee8 <deregister_tm_clones+0x28>
  400edb:	5d                   	pop    %rbp
  400edc:	bf 90 54 60 00       	mov    $0x605490,%edi
  400ee1:	ff e0                	jmpq   *%rax
  400ee3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  400ee8:	5d                   	pop    %rbp
  400ee9:	c3                   	retq   
  400eea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400ef0 <register_tm_clones>:
  400ef0:	be 90 54 60 00       	mov    $0x605490,%esi
  400ef5:	55                   	push   %rbp
  400ef6:	48 81 ee 90 54 60 00 	sub    $0x605490,%rsi
  400efd:	48 89 e5             	mov    %rsp,%rbp
  400f00:	48 c1 fe 03          	sar    $0x3,%rsi
  400f04:	48 89 f0             	mov    %rsi,%rax
  400f07:	48 c1 e8 3f          	shr    $0x3f,%rax
  400f0b:	48 01 c6             	add    %rax,%rsi
  400f0e:	48 d1 fe             	sar    %rsi
  400f11:	74 15                	je     400f28 <register_tm_clones+0x38>
  400f13:	b8 00 00 00 00       	mov    $0x0,%eax
  400f18:	48 85 c0             	test   %rax,%rax
  400f1b:	74 0b                	je     400f28 <register_tm_clones+0x38>
  400f1d:	5d                   	pop    %rbp
  400f1e:	bf 90 54 60 00       	mov    $0x605490,%edi
  400f23:	ff e0                	jmpq   *%rax
  400f25:	0f 1f 00             	nopl   (%rax)
  400f28:	5d                   	pop    %rbp
  400f29:	c3                   	retq   
  400f2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400f30 <__do_global_dtors_aux>:
  400f30:	80 3d 91 45 20 00 00 	cmpb   $0x0,0x204591(%rip)        # 6054c8 <completed.7698>
  400f37:	75 17                	jne    400f50 <__do_global_dtors_aux+0x20>
  400f39:	55                   	push   %rbp
  400f3a:	48 89 e5             	mov    %rsp,%rbp
  400f3d:	e8 7e ff ff ff       	callq  400ec0 <deregister_tm_clones>
  400f42:	c6 05 7f 45 20 00 01 	movb   $0x1,0x20457f(%rip)        # 6054c8 <completed.7698>
  400f49:	5d                   	pop    %rbp
  400f4a:	c3                   	retq   
  400f4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  400f50:	f3 c3                	repz retq 
  400f52:	0f 1f 40 00          	nopl   0x0(%rax)
  400f56:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400f5d:	00 00 00 

0000000000400f60 <frame_dummy>:
  400f60:	55                   	push   %rbp
  400f61:	48 89 e5             	mov    %rsp,%rbp
  400f64:	5d                   	pop    %rbp
  400f65:	eb 89                	jmp    400ef0 <register_tm_clones>

0000000000400f67 <usage>:
  400f67:	48 83 ec 08          	sub    $0x8,%rsp
  400f6b:	48 89 fa             	mov    %rdi,%rdx
  400f6e:	83 3d 93 45 20 00 00 	cmpl   $0x0,0x204593(%rip)        # 605508 <is_checker>
  400f75:	74 50                	je     400fc7 <usage+0x60>
}

__fortify_function int
printf (const char *__restrict __fmt, ...)
{
  return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
  400f77:	48 8d 35 7a 20 00 00 	lea    0x207a(%rip),%rsi        # 402ff8 <_IO_stdin_used+0x8>
  400f7e:	bf 01 00 00 00       	mov    $0x1,%edi
  400f83:	b8 00 00 00 00       	mov    $0x0,%eax
  400f88:	e8 53 fe ff ff       	callq  400de0 <__printf_chk@plt>
  400f8d:	48 8d 3d 9c 20 00 00 	lea    0x209c(%rip),%rdi        # 403030 <_IO_stdin_used+0x40>
  400f94:	e8 27 fd ff ff       	callq  400cc0 <puts@plt>
  400f99:	48 8d 3d 08 22 00 00 	lea    0x2208(%rip),%rdi        # 4031a8 <_IO_stdin_used+0x1b8>
  400fa0:	e8 1b fd ff ff       	callq  400cc0 <puts@plt>
  400fa5:	48 8d 3d ac 20 00 00 	lea    0x20ac(%rip),%rdi        # 403058 <_IO_stdin_used+0x68>
  400fac:	e8 0f fd ff ff       	callq  400cc0 <puts@plt>
  400fb1:	48 8d 3d 0a 22 00 00 	lea    0x220a(%rip),%rdi        # 4031c2 <_IO_stdin_used+0x1d2>
  400fb8:	e8 03 fd ff ff       	callq  400cc0 <puts@plt>
  400fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  400fc2:	e8 69 fe ff ff       	callq  400e30 <exit@plt>
  400fc7:	48 8d 35 10 22 00 00 	lea    0x2210(%rip),%rsi        # 4031de <_IO_stdin_used+0x1ee>
  400fce:	bf 01 00 00 00       	mov    $0x1,%edi
  400fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  400fd8:	e8 03 fe ff ff       	callq  400de0 <__printf_chk@plt>
  400fdd:	48 8d 3d 9c 20 00 00 	lea    0x209c(%rip),%rdi        # 403080 <_IO_stdin_used+0x90>
  400fe4:	e8 d7 fc ff ff       	callq  400cc0 <puts@plt>
  400fe9:	48 8d 3d b8 20 00 00 	lea    0x20b8(%rip),%rdi        # 4030a8 <_IO_stdin_used+0xb8>
  400ff0:	e8 cb fc ff ff       	callq  400cc0 <puts@plt>
  400ff5:	48 8d 3d 00 22 00 00 	lea    0x2200(%rip),%rdi        # 4031fc <_IO_stdin_used+0x20c>
  400ffc:	e8 bf fc ff ff       	callq  400cc0 <puts@plt>
  401001:	eb ba                	jmp    400fbd <usage+0x56>

0000000000401003 <initialize_target>:
  401003:	55                   	push   %rbp
  401004:	53                   	push   %rbx
  401005:	48 81 ec 18 21 00 00 	sub    $0x2118,%rsp
  40100c:	89 f5                	mov    %esi,%ebp
  40100e:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  401015:	00 00 
  401017:	48 89 84 24 08 21 00 	mov    %rax,0x2108(%rsp)
  40101e:	00 
  40101f:	31 c0                	xor    %eax,%eax
  401021:	89 3d d1 44 20 00    	mov    %edi,0x2044d1(%rip)        # 6054f8 <check_level>
  401027:	8b 3d 03 41 20 00    	mov    0x204103(%rip),%edi        # 605130 <target_id>
  40102d:	e8 17 1f 00 00       	callq  402f49 <gencookie>
  401032:	89 05 cc 44 20 00    	mov    %eax,0x2044cc(%rip)        # 605504 <cookie>
  401038:	89 c7                	mov    %eax,%edi
  40103a:	e8 0a 1f 00 00       	callq  402f49 <gencookie>
  40103f:	89 05 bb 44 20 00    	mov    %eax,0x2044bb(%rip)        # 605500 <authkey>
  401045:	8b 05 e5 40 20 00    	mov    0x2040e5(%rip),%eax        # 605130 <target_id>
  40104b:	8d 78 01             	lea    0x1(%rax),%edi
  40104e:	e8 3d fc ff ff       	callq  400c90 <srandom@plt>
  401053:	e8 48 fd ff ff       	callq  400da0 <random@plt>
  401058:	89 c7                	mov    %eax,%edi
  40105a:	e8 1a 03 00 00       	callq  401379 <scramble>
  40105f:	89 c3                	mov    %eax,%ebx
  401061:	85 ed                	test   %ebp,%ebp
  401063:	75 54                	jne    4010b9 <initialize_target+0xb6>
  401065:	b8 00 00 00 00       	mov    $0x0,%eax
  40106a:	01 d8                	add    %ebx,%eax
  40106c:	0f b7 c0             	movzwl %ax,%eax
  40106f:	8d 04 c5 00 01 00 00 	lea    0x100(,%rax,8),%eax
  401076:	89 c0                	mov    %eax,%eax
  401078:	48 89 05 01 44 20 00 	mov    %rax,0x204401(%rip)        # 605480 <buf_offset>
  40107f:	c6 05 a2 50 20 00 72 	movb   $0x72,0x2050a2(%rip)        # 606128 <target_prefix>
  401086:	83 3d fb 43 20 00 00 	cmpl   $0x0,0x2043fb(%rip)        # 605488 <notify>
  40108d:	74 09                	je     401098 <initialize_target+0x95>
  40108f:	83 3d 72 44 20 00 00 	cmpl   $0x0,0x204472(%rip)        # 605508 <is_checker>
  401096:	74 39                	je     4010d1 <initialize_target+0xce>
  401098:	48 8b 84 24 08 21 00 	mov    0x2108(%rsp),%rax
  40109f:	00 
  4010a0:	64 48 33 04 25 28 00 	xor    %fs:0x28,%rax
  4010a7:	00 00 
  4010a9:	0f 85 da 00 00 00    	jne    401189 <initialize_target+0x186>
  4010af:	48 81 c4 18 21 00 00 	add    $0x2118,%rsp
  4010b6:	5b                   	pop    %rbx
  4010b7:	5d                   	pop    %rbp
  4010b8:	c3                   	retq   
  4010b9:	bf 00 00 00 00       	mov    $0x0,%edi
  4010be:	e8 cd fc ff ff       	callq  400d90 <time@plt>
  4010c3:	89 c7                	mov    %eax,%edi
  4010c5:	e8 c6 fb ff ff       	callq  400c90 <srandom@plt>
  4010ca:	e8 d1 fc ff ff       	callq  400da0 <random@plt>
  4010cf:	eb 99                	jmp    40106a <initialize_target+0x67>
	return __gethostname_chk (__buf, __buflen, __bos (__buf));

      if (__buflen > __bos (__buf))
	return __gethostname_chk_warn (__buf, __buflen, __bos (__buf));
    }
  return __gethostname_alias (__buf, __buflen);
  4010d1:	48 89 e7             	mov    %rsp,%rdi
  4010d4:	be 00 01 00 00       	mov    $0x100,%esi
  4010d9:	e8 42 fd ff ff       	callq  400e20 <gethostname@plt>
  4010de:	89 c5                	mov    %eax,%ebp
  4010e0:	85 c0                	test   %eax,%eax
  4010e2:	75 26                	jne    40110a <initialize_target+0x107>
  4010e4:	89 c3                	mov    %eax,%ebx
  4010e6:	48 63 c3             	movslq %ebx,%rax
  4010e9:	48 8d 15 70 40 20 00 	lea    0x204070(%rip),%rdx        # 605160 <host_table>
  4010f0:	48 8b 3c c2          	mov    (%rdx,%rax,8),%rdi
  4010f4:	48 85 ff             	test   %rdi,%rdi
  4010f7:	74 2c                	je     401125 <initialize_target+0x122>
  4010f9:	48 89 e6             	mov    %rsp,%rsi
  4010fc:	e8 6f fb ff ff       	callq  400c70 <strcasecmp@plt>
  401101:	85 c0                	test   %eax,%eax
  401103:	74 1b                	je     401120 <initialize_target+0x11d>
  401105:	83 c3 01             	add    $0x1,%ebx
  401108:	eb dc                	jmp    4010e6 <initialize_target+0xe3>
  40110a:	48 8d 3d c7 1f 00 00 	lea    0x1fc7(%rip),%rdi        # 4030d8 <_IO_stdin_used+0xe8>
  401111:	e8 aa fb ff ff       	callq  400cc0 <puts@plt>
  401116:	bf 08 00 00 00       	mov    $0x8,%edi
  40111b:	e8 10 fd ff ff       	callq  400e30 <exit@plt>
  401120:	bd 01 00 00 00       	mov    $0x1,%ebp
  401125:	85 ed                	test   %ebp,%ebp
  401127:	74 3d                	je     401166 <initialize_target+0x163>
  401129:	48 8d bc 24 00 01 00 	lea    0x100(%rsp),%rdi
  401130:	00 
  401131:	e8 43 1b 00 00       	callq  402c79 <init_driver>
  401136:	85 c0                	test   %eax,%eax
  401138:	0f 89 5a ff ff ff    	jns    401098 <initialize_target+0x95>
  40113e:	48 8d 94 24 00 01 00 	lea    0x100(%rsp),%rdx
  401145:	00 
  401146:	48 8d 35 03 20 00 00 	lea    0x2003(%rip),%rsi        # 403150 <_IO_stdin_used+0x160>
  40114d:	bf 01 00 00 00       	mov    $0x1,%edi
  401152:	b8 00 00 00 00       	mov    $0x0,%eax
  401157:	e8 84 fc ff ff       	callq  400de0 <__printf_chk@plt>
  40115c:	bf 08 00 00 00       	mov    $0x8,%edi
  401161:	e8 ca fc ff ff       	callq  400e30 <exit@plt>
  401166:	48 89 e2             	mov    %rsp,%rdx
  401169:	48 8d 35 a0 1f 00 00 	lea    0x1fa0(%rip),%rsi        # 403110 <_IO_stdin_used+0x120>
  401170:	bf 01 00 00 00       	mov    $0x1,%edi
  401175:	b8 00 00 00 00       	mov    $0x0,%eax
  40117a:	e8 61 fc ff ff       	callq  400de0 <__printf_chk@plt>
  40117f:	bf 08 00 00 00       	mov    $0x8,%edi
  401184:	e8 a7 fc ff ff       	callq  400e30 <exit@plt>
  401189:	e8 52 fb ff ff       	callq  400ce0 <__stack_chk_fail@plt>

000000000040118e <main>:
  40118e:	41 56                	push   %r14
  401190:	41 55                	push   %r13
  401192:	41 54                	push   %r12
  401194:	55                   	push   %rbp
  401195:	53                   	push   %rbx
  401196:	41 89 fc             	mov    %edi,%r12d
  401199:	48 89 f3             	mov    %rsi,%rbx
  40119c:	48 c7 c6 80 1f 40 00 	mov    $0x401f80,%rsi
  4011a3:	bf 0b 00 00 00       	mov    $0xb,%edi
  4011a8:	e8 93 fb ff ff       	callq  400d40 <signal@plt>
  4011ad:	48 c7 c6 2c 1f 40 00 	mov    $0x401f2c,%rsi
  4011b4:	bf 07 00 00 00       	mov    $0x7,%edi
  4011b9:	e8 82 fb ff ff       	callq  400d40 <signal@plt>
  4011be:	48 c7 c6 d4 1f 40 00 	mov    $0x401fd4,%rsi
  4011c5:	bf 04 00 00 00       	mov    $0x4,%edi
  4011ca:	e8 71 fb ff ff       	callq  400d40 <signal@plt>
  4011cf:	83 3d 32 43 20 00 00 	cmpl   $0x0,0x204332(%rip)        # 605508 <is_checker>
  4011d6:	75 26                	jne    4011fe <main+0x70>
  4011d8:	48 8d 2d 36 20 00 00 	lea    0x2036(%rip),%rbp        # 403215 <_IO_stdin_used+0x225>
  4011df:	48 8b 05 ba 42 20 00 	mov    0x2042ba(%rip),%rax        # 6054a0 <stdin@@GLIBC_2.2.5>
  4011e6:	48 89 05 03 43 20 00 	mov    %rax,0x204303(%rip)        # 6054f0 <infile>
  4011ed:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  4011f3:	41 be 00 00 00 00    	mov    $0x0,%r14d
  4011f9:	e9 8d 00 00 00       	jmpq   40128b <main+0xfd>
  4011fe:	48 c7 c6 28 20 40 00 	mov    $0x402028,%rsi
  401205:	bf 0e 00 00 00       	mov    $0xe,%edi
  40120a:	e8 31 fb ff ff       	callq  400d40 <signal@plt>
  40120f:	bf 05 00 00 00       	mov    $0x5,%edi
  401214:	e8 f7 fa ff ff       	callq  400d10 <alarm@plt>
  401219:	48 8d 2d fa 1f 00 00 	lea    0x1ffa(%rip),%rbp        # 40321a <_IO_stdin_used+0x22a>
  401220:	eb bd                	jmp    4011df <main+0x51>
  401222:	48 8b 3b             	mov    (%rbx),%rdi
  401225:	e8 3d fd ff ff       	callq  400f67 <usage>
  40122a:	48 8d 35 6c 22 00 00 	lea    0x226c(%rip),%rsi        # 40349d <_IO_stdin_used+0x4ad>
  401231:	48 8b 3d 70 42 20 00 	mov    0x204270(%rip),%rdi        # 6054a8 <optarg@@GLIBC_2.2.5>
  401238:	e8 b3 fb ff ff       	callq  400df0 <fopen@plt>
  40123d:	48 89 05 ac 42 20 00 	mov    %rax,0x2042ac(%rip)        # 6054f0 <infile>
  401244:	48 85 c0             	test   %rax,%rax
  401247:	75 42                	jne    40128b <main+0xfd>
  return __fprintf_chk (__stream, __USE_FORTIFY_LEVEL - 1, __fmt,
  401249:	48 8b 0d 58 42 20 00 	mov    0x204258(%rip),%rcx        # 6054a8 <optarg@@GLIBC_2.2.5>
  401250:	48 8d 15 cb 1f 00 00 	lea    0x1fcb(%rip),%rdx        # 403222 <_IO_stdin_used+0x232>
  401257:	be 01 00 00 00       	mov    $0x1,%esi
  40125c:	48 8b 3d 5d 42 20 00 	mov    0x20425d(%rip),%rdi        # 6054c0 <stderr@@GLIBC_2.2.5>
  401263:	e8 e8 fb ff ff       	callq  400e50 <__fprintf_chk@plt>
  401268:	b8 01 00 00 00       	mov    $0x1,%eax
  40126d:	e9 d9 00 00 00       	jmpq   40134b <main+0x1bd>
  401272:	ba 10 00 00 00       	mov    $0x10,%edx
  401277:	be 00 00 00 00       	mov    $0x0,%esi
  40127c:	48 8b 3d 25 42 20 00 	mov    0x204225(%rip),%rdi        # 6054a8 <optarg@@GLIBC_2.2.5>
  401283:	e8 88 fb ff ff       	callq  400e10 <strtoul@plt>
  401288:	41 89 c6             	mov    %eax,%r14d
  40128b:	48 89 ea             	mov    %rbp,%rdx
  40128e:	48 89 de             	mov    %rbx,%rsi
  401291:	44 89 e7             	mov    %r12d,%edi
  401294:	e8 67 fb ff ff       	callq  400e00 <getopt@plt>
  401299:	3c ff                	cmp    $0xff,%al
  40129b:	74 62                	je     4012ff <main+0x171>
  40129d:	0f be d0             	movsbl %al,%edx
  4012a0:	83 e8 61             	sub    $0x61,%eax
  4012a3:	3c 10                	cmp    $0x10,%al
  4012a5:	77 3a                	ja     4012e1 <main+0x153>
  4012a7:	0f b6 c0             	movzbl %al,%eax
  4012aa:	48 8d 0d af 1f 00 00 	lea    0x1faf(%rip),%rcx        # 403260 <_IO_stdin_used+0x270>
  4012b1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  4012b5:	48 01 c8             	add    %rcx,%rax
  4012b8:	ff e0                	jmpq   *%rax

#ifdef __USE_EXTERN_INLINES
__extern_inline int
__NTH (atoi (const char *__nptr))
{
  return (int) strtol (__nptr, (char **) NULL, 10);
  4012ba:	ba 0a 00 00 00       	mov    $0xa,%edx
  4012bf:	be 00 00 00 00       	mov    $0x0,%esi
  4012c4:	48 8b 3d dd 41 20 00 	mov    0x2041dd(%rip),%rdi        # 6054a8 <optarg@@GLIBC_2.2.5>
  4012cb:	e8 a0 fa ff ff       	callq  400d70 <strtol@plt>
  4012d0:	41 89 c5             	mov    %eax,%r13d
  4012d3:	eb b6                	jmp    40128b <main+0xfd>
  4012d5:	c7 05 a9 41 20 00 00 	movl   $0x0,0x2041a9(%rip)        # 605488 <notify>
  4012dc:	00 00 00 
  4012df:	eb aa                	jmp    40128b <main+0xfd>
  return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
  4012e1:	48 8d 35 57 1f 00 00 	lea    0x1f57(%rip),%rsi        # 40323f <_IO_stdin_used+0x24f>
  4012e8:	bf 01 00 00 00       	mov    $0x1,%edi
  4012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  4012f2:	e8 e9 fa ff ff       	callq  400de0 <__printf_chk@plt>
  4012f7:	48 8b 3b             	mov    (%rbx),%rdi
  4012fa:	e8 68 fc ff ff       	callq  400f67 <usage>
  4012ff:	be 01 00 00 00       	mov    $0x1,%esi
  401304:	44 89 ef             	mov    %r13d,%edi
  401307:	e8 f7 fc ff ff       	callq  401003 <initialize_target>
  40130c:	83 3d f5 41 20 00 00 	cmpl   $0x0,0x2041f5(%rip)        # 605508 <is_checker>
  401313:	74 09                	je     40131e <main+0x190>
  401315:	44 39 35 e4 41 20 00 	cmp    %r14d,0x2041e4(%rip)        # 605500 <authkey>
  40131c:	75 36                	jne    401354 <main+0x1c6>
  40131e:	8b 15 e0 41 20 00    	mov    0x2041e0(%rip),%edx        # 605504 <cookie>
  401324:	48 8d 35 27 1f 00 00 	lea    0x1f27(%rip),%rsi        # 403252 <_IO_stdin_used+0x262>
  40132b:	bf 01 00 00 00       	mov    $0x1,%edi
  401330:	b8 00 00 00 00       	mov    $0x0,%eax
  401335:	e8 a6 fa ff ff       	callq  400de0 <__printf_chk@plt>
  40133a:	48 8b 3d 3f 41 20 00 	mov    0x20413f(%rip),%rdi        # 605480 <buf_offset>
  401341:	e8 39 0d 00 00       	callq  40207f <launch>
  401346:	b8 00 00 00 00       	mov    $0x0,%eax
  40134b:	5b                   	pop    %rbx
  40134c:	5d                   	pop    %rbp
  40134d:	41 5c                	pop    %r12
  40134f:	41 5d                	pop    %r13
  401351:	41 5e                	pop    %r14
  401353:	c3                   	retq   
  401354:	44 89 f2             	mov    %r14d,%edx
  401357:	48 8d 35 1a 1e 00 00 	lea    0x1e1a(%rip),%rsi        # 403178 <_IO_stdin_used+0x188>
  40135e:	bf 01 00 00 00       	mov    $0x1,%edi
  401363:	b8 00 00 00 00       	mov    $0x0,%eax
  401368:	e8 73 fa ff ff       	callq  400de0 <__printf_chk@plt>
  40136d:	b8 00 00 00 00       	mov    $0x0,%eax
  401372:	e8 15 08 00 00       	callq  401b8c <check_fail>
  401377:	eb a5                	jmp    40131e <main+0x190>

0000000000401379 <scramble>:
  401379:	48 83 ec 38          	sub    $0x38,%rsp
  40137d:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  401384:	00 00 
  401386:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  40138b:	31 c0                	xor    %eax,%eax
  40138d:	eb 10                	jmp    40139f <scramble+0x26>
  40138f:	69 d0 52 73 00 00    	imul   $0x7352,%eax,%edx
  401395:	01 fa                	add    %edi,%edx
  401397:	89 c1                	mov    %eax,%ecx
  401399:	89 14 8c             	mov    %edx,(%rsp,%rcx,4)
  40139c:	83 c0 01             	add    $0x1,%eax
  40139f:	83 f8 09             	cmp    $0x9,%eax
  4013a2:	76 eb                	jbe    40138f <scramble+0x16>
  4013a4:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4013a8:	69 c0 34 52 00 00    	imul   $0x5234,%eax,%eax
  4013ae:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4013b2:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  4013b6:	69 c0 52 91 00 00    	imul   $0x9152,%eax,%eax
  4013bc:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  4013c0:	8b 44 24 14          	mov    0x14(%rsp),%eax
  4013c4:	69 c0 c5 54 00 00    	imul   $0x54c5,%eax,%eax
  4013ca:	89 44 24 14          	mov    %eax,0x14(%rsp)
  4013ce:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4013d2:	69 c0 36 4b 00 00    	imul   $0x4b36,%eax,%eax
  4013d8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4013dc:	8b 44 24 14          	mov    0x14(%rsp),%eax
  4013e0:	69 c0 8e 97 00 00    	imul   $0x978e,%eax,%eax
  4013e6:	89 44 24 14          	mov    %eax,0x14(%rsp)
  4013ea:	8b 44 24 20          	mov    0x20(%rsp),%eax
  4013ee:	69 c0 6c a1 00 00    	imul   $0xa16c,%eax,%eax
  4013f4:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4013f8:	8b 04 24             	mov    (%rsp),%eax
  4013fb:	69 c0 ed 13 00 00    	imul   $0x13ed,%eax,%eax
  401401:	89 04 24             	mov    %eax,(%rsp)
  401404:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401408:	69 c0 70 af 00 00    	imul   $0xaf70,%eax,%eax
  40140e:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401412:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401416:	69 c0 bd 71 00 00    	imul   $0x71bd,%eax,%eax
  40141c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401420:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401424:	69 c0 3b 89 00 00    	imul   $0x893b,%eax,%eax
  40142a:	89 44 24 14          	mov    %eax,0x14(%rsp)
  40142e:	8b 44 24 20          	mov    0x20(%rsp),%eax
  401432:	69 c0 40 15 00 00    	imul   $0x1540,%eax,%eax
  401438:	89 44 24 20          	mov    %eax,0x20(%rsp)
  40143c:	8b 04 24             	mov    (%rsp),%eax
  40143f:	69 c0 ed b3 00 00    	imul   $0xb3ed,%eax,%eax
  401445:	89 04 24             	mov    %eax,(%rsp)
  401448:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  40144c:	69 c0 1d 10 00 00    	imul   $0x101d,%eax,%eax
  401452:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  401456:	8b 04 24             	mov    (%rsp),%eax
  401459:	69 c0 9c a4 00 00    	imul   $0xa49c,%eax,%eax
  40145f:	89 04 24             	mov    %eax,(%rsp)
  401462:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401466:	69 c0 8a 03 00 00    	imul   $0x38a,%eax,%eax
  40146c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401470:	8b 44 24 10          	mov    0x10(%rsp),%eax
  401474:	69 c0 54 79 00 00    	imul   $0x7954,%eax,%eax
  40147a:	89 44 24 10          	mov    %eax,0x10(%rsp)
  40147e:	8b 44 24 10          	mov    0x10(%rsp),%eax
  401482:	69 c0 bc c4 00 00    	imul   $0xc4bc,%eax,%eax
  401488:	89 44 24 10          	mov    %eax,0x10(%rsp)
  40148c:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401490:	69 c0 61 1c 00 00    	imul   $0x1c61,%eax,%eax
  401496:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40149a:	8b 44 24 04          	mov    0x4(%rsp),%eax
  40149e:	69 c0 89 b4 00 00    	imul   $0xb489,%eax,%eax
  4014a4:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4014a8:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4014ac:	69 c0 56 9f 00 00    	imul   $0x9f56,%eax,%eax
  4014b2:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4014b6:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4014ba:	69 c0 69 0b 00 00    	imul   $0xb69,%eax,%eax
  4014c0:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4014c4:	8b 04 24             	mov    (%rsp),%eax
  4014c7:	69 c0 12 1d 00 00    	imul   $0x1d12,%eax,%eax
  4014cd:	89 04 24             	mov    %eax,(%rsp)
  4014d0:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4014d4:	69 c0 cb 9f 00 00    	imul   $0x9fcb,%eax,%eax
  4014da:	89 44 24 18          	mov    %eax,0x18(%rsp)
  4014de:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4014e2:	69 c0 a8 11 00 00    	imul   $0x11a8,%eax,%eax
  4014e8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4014ec:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4014f0:	69 c0 24 36 00 00    	imul   $0x3624,%eax,%eax
  4014f6:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4014fa:	8b 44 24 18          	mov    0x18(%rsp),%eax
  4014fe:	69 c0 b0 5a 00 00    	imul   $0x5ab0,%eax,%eax
  401504:	89 44 24 18          	mov    %eax,0x18(%rsp)
  401508:	8b 44 24 24          	mov    0x24(%rsp),%eax
  40150c:	69 c0 56 9b 00 00    	imul   $0x9b56,%eax,%eax
  401512:	89 44 24 24          	mov    %eax,0x24(%rsp)
  401516:	8b 44 24 04          	mov    0x4(%rsp),%eax
  40151a:	69 c0 7c 41 00 00    	imul   $0x417c,%eax,%eax
  401520:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401524:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401528:	6b c0 31             	imul   $0x31,%eax,%eax
  40152b:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40152f:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401533:	69 c0 75 b1 00 00    	imul   $0xb175,%eax,%eax
  401539:	89 44 24 04          	mov    %eax,0x4(%rsp)
  40153d:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401541:	69 c0 79 74 00 00    	imul   $0x7479,%eax,%eax
  401547:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40154b:	8b 44 24 04          	mov    0x4(%rsp),%eax
  40154f:	69 c0 79 59 00 00    	imul   $0x5979,%eax,%eax
  401555:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401559:	8b 44 24 14          	mov    0x14(%rsp),%eax
  40155d:	69 c0 70 35 00 00    	imul   $0x3570,%eax,%eax
  401563:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401567:	8b 44 24 04          	mov    0x4(%rsp),%eax
  40156b:	69 c0 b7 52 00 00    	imul   $0x52b7,%eax,%eax
  401571:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401575:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401579:	69 c0 72 dd 00 00    	imul   $0xdd72,%eax,%eax
  40157f:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  401583:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401587:	69 c0 11 36 00 00    	imul   $0x3611,%eax,%eax
  40158d:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  401591:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401595:	69 c0 cf 32 00 00    	imul   $0x32cf,%eax,%eax
  40159b:	89 44 24 14          	mov    %eax,0x14(%rsp)
  40159f:	8b 44 24 10          	mov    0x10(%rsp),%eax
  4015a3:	69 c0 31 08 00 00    	imul   $0x831,%eax,%eax
  4015a9:	89 44 24 10          	mov    %eax,0x10(%rsp)
  4015ad:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4015b1:	69 c0 a5 1f 00 00    	imul   $0x1fa5,%eax,%eax
  4015b7:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4015bb:	8b 44 24 10          	mov    0x10(%rsp),%eax
  4015bf:	69 c0 23 e4 00 00    	imul   $0xe423,%eax,%eax
  4015c5:	89 44 24 10          	mov    %eax,0x10(%rsp)
  4015c9:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4015cd:	69 c0 bd b4 00 00    	imul   $0xb4bd,%eax,%eax
  4015d3:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4015d7:	8b 44 24 14          	mov    0x14(%rsp),%eax
  4015db:	69 c0 2e a1 00 00    	imul   $0xa12e,%eax,%eax
  4015e1:	89 44 24 14          	mov    %eax,0x14(%rsp)
  4015e5:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4015e9:	69 c0 70 4d 00 00    	imul   $0x4d70,%eax,%eax
  4015ef:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4015f3:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4015f7:	69 c0 86 fb 00 00    	imul   $0xfb86,%eax,%eax
  4015fd:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401601:	8b 44 24 24          	mov    0x24(%rsp),%eax
  401605:	69 c0 c4 c8 00 00    	imul   $0xc8c4,%eax,%eax
  40160b:	89 44 24 24          	mov    %eax,0x24(%rsp)
  40160f:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401613:	69 c0 5c 51 00 00    	imul   $0x515c,%eax,%eax
  401619:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40161d:	8b 04 24             	mov    (%rsp),%eax
  401620:	69 c0 c5 d7 00 00    	imul   $0xd7c5,%eax,%eax
  401626:	89 04 24             	mov    %eax,(%rsp)
  401629:	8b 44 24 14          	mov    0x14(%rsp),%eax
  40162d:	69 c0 73 76 00 00    	imul   $0x7673,%eax,%eax
  401633:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401637:	8b 44 24 18          	mov    0x18(%rsp),%eax
  40163b:	69 c0 b1 20 00 00    	imul   $0x20b1,%eax,%eax
  401641:	89 44 24 18          	mov    %eax,0x18(%rsp)
  401645:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401649:	69 c0 2e f7 00 00    	imul   $0xf72e,%eax,%eax
  40164f:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401653:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401657:	69 c0 37 bb 00 00    	imul   $0xbb37,%eax,%eax
  40165d:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401661:	8b 44 24 20          	mov    0x20(%rsp),%eax
  401665:	69 c0 ff e6 00 00    	imul   $0xe6ff,%eax,%eax
  40166b:	89 44 24 20          	mov    %eax,0x20(%rsp)
  40166f:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401673:	69 c0 63 80 00 00    	imul   $0x8063,%eax,%eax
  401679:	89 44 24 08          	mov    %eax,0x8(%rsp)
  40167d:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401681:	69 c0 a1 c0 00 00    	imul   $0xc0a1,%eax,%eax
  401687:	89 44 24 14          	mov    %eax,0x14(%rsp)
  40168b:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40168f:	69 c0 0a 09 00 00    	imul   $0x90a,%eax,%eax
  401695:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401699:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40169d:	69 c0 d3 f5 00 00    	imul   $0xf5d3,%eax,%eax
  4016a3:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4016a7:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  4016ab:	69 c0 97 e3 00 00    	imul   $0xe397,%eax,%eax
  4016b1:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  4016b5:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4016b9:	69 c0 db 0d 00 00    	imul   $0xddb,%eax,%eax
  4016bf:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4016c3:	8b 44 24 20          	mov    0x20(%rsp),%eax
  4016c7:	69 c0 ac 79 00 00    	imul   $0x79ac,%eax,%eax
  4016cd:	89 44 24 20          	mov    %eax,0x20(%rsp)
  4016d1:	8b 04 24             	mov    (%rsp),%eax
  4016d4:	69 c0 a9 7e 00 00    	imul   $0x7ea9,%eax,%eax
  4016da:	89 04 24             	mov    %eax,(%rsp)
  4016dd:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  4016e1:	69 c0 5d b6 00 00    	imul   $0xb65d,%eax,%eax
  4016e7:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4016eb:	8b 44 24 08          	mov    0x8(%rsp),%eax
  4016ef:	69 c0 ae 7f 00 00    	imul   $0x7fae,%eax,%eax
  4016f5:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4016f9:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4016fd:	69 c0 db 7a 00 00    	imul   $0x7adb,%eax,%eax
  401703:	89 44 24 04          	mov    %eax,0x4(%rsp)
  401707:	8b 44 24 20          	mov    0x20(%rsp),%eax
  40170b:	69 c0 57 9b 00 00    	imul   $0x9b57,%eax,%eax
  401711:	89 44 24 20          	mov    %eax,0x20(%rsp)
  401715:	8b 44 24 18          	mov    0x18(%rsp),%eax
  401719:	69 c0 4b bf 00 00    	imul   $0xbf4b,%eax,%eax
  40171f:	89 44 24 18          	mov    %eax,0x18(%rsp)
  401723:	8b 44 24 08          	mov    0x8(%rsp),%eax
  401727:	69 c0 b0 99 00 00    	imul   $0x99b0,%eax,%eax
  40172d:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401731:	8b 44 24 04          	mov    0x4(%rsp),%eax
  401735:	69 c0 c6 bf 00 00    	imul   $0xbfc6,%eax,%eax
  40173b:	89 44 24 04          	mov    %eax,0x4(%rsp)
  40173f:	8b 44 24 24          	mov    0x24(%rsp),%eax
  401743:	69 c0 88 68 00 00    	imul   $0x6888,%eax,%eax
  401749:	89 44 24 24          	mov    %eax,0x24(%rsp)
  40174d:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  401751:	69 c0 df 6f 00 00    	imul   $0x6fdf,%eax,%eax
  401757:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  40175b:	8b 44 24 08          	mov    0x8(%rsp),%eax
  40175f:	69 c0 32 e0 00 00    	imul   $0xe032,%eax,%eax
  401765:	89 44 24 08          	mov    %eax,0x8(%rsp)
  401769:	8b 44 24 14          	mov    0x14(%rsp),%eax
  40176d:	69 c0 ed cd 00 00    	imul   $0xcded,%eax,%eax
  401773:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401777:	8b 44 24 10          	mov    0x10(%rsp),%eax
  40177b:	69 c0 b2 36 00 00    	imul   $0x36b2,%eax,%eax
  401781:	89 44 24 10          	mov    %eax,0x10(%rsp)
  401785:	8b 44 24 14          	mov    0x14(%rsp),%eax
  401789:	69 c0 07 6d 00 00    	imul   $0x6d07,%eax,%eax
  40178f:	89 44 24 14          	mov    %eax,0x14(%rsp)
  401793:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  401797:	69 c0 8c e2 00 00    	imul   $0xe28c,%eax,%eax
  40179d:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  4017a1:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4017a5:	69 c0 ef 4d 00 00    	imul   $0x4def,%eax,%eax
  4017ab:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4017af:	8b 44 24 04          	mov    0x4(%rsp),%eax
  4017b3:	69 c0 24 29 00 00    	imul   $0x2924,%eax,%eax
  4017b9:	89 44 24 04          	mov    %eax,0x4(%rsp)
  4017bd:	8b 04 24             	mov    (%rsp),%eax
  4017c0:	69 c0 3a 31 00 00    	imul   $0x313a,%eax,%eax
  4017c6:	89 04 24             	mov    %eax,(%rsp)
  4017c9:	ba 00 00 00 00       	mov    $0x0,%edx
  4017ce:	b8 00 00 00 00       	mov    $0x0,%eax
  4017d3:	eb 0a                	jmp    4017df <scramble+0x466>
  4017d5:	89 d1                	mov    %edx,%ecx
  4017d7:	8b 0c 8c             	mov    (%rsp,%rcx,4),%ecx
  4017da:	01 c8                	add    %ecx,%eax
  4017dc:	83 c2 01             	add    $0x1,%edx
  4017df:	83 fa 09             	cmp    $0x9,%edx
  4017e2:	76 f1                	jbe    4017d5 <scramble+0x45c>
  4017e4:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  4017e9:	64 48 33 34 25 28 00 	xor    %fs:0x28,%rsi
  4017f0:	00 00 
  4017f2:	75 05                	jne    4017f9 <scramble+0x480>
  4017f4:	48 83 c4 38          	add    $0x38,%rsp
  4017f8:	c3                   	retq   
  4017f9:	e8 e2 f4 ff ff       	callq  400ce0 <__stack_chk_fail@plt>

00000000004017fe <getbuf>:
  4017fe:	48 83 ec 28          	sub    $0x28,%rsp
  401802:	48 89 e7             	mov    %rsp,%rdi
  401805:	e8 ba 03 00 00       	callq  401bc4 <Gets>
  40180a:	b8 01 00 00 00       	mov    $0x1,%eax
  40180f:	48 83 c4 28          	add    $0x28,%rsp
  401813:	c3                   	retq   

0000000000401814 <touch1>:
  401814:	48 83 ec 08          	sub    $0x8,%rsp
  401818:	c7 05 da 3c 20 00 01 	movl   $0x1,0x203cda(%rip)        # 6054fc <vlevel>
  40181f:	00 00 00 
  401822:	48 8d 3d c8 1a 00 00 	lea    0x1ac8(%rip),%rdi        # 4032f1 <_IO_stdin_used+0x301>
  401829:	e8 92 f4 ff ff       	callq  400cc0 <puts@plt>
  40182e:	bf 01 00 00 00       	mov    $0x1,%edi
  401833:	e8 fc 05 00 00       	callq  401e34 <validate>
  401838:	bf 00 00 00 00       	mov    $0x0,%edi
  40183d:	e8 ee f5 ff ff       	callq  400e30 <exit@plt>

0000000000401842 <touch2>:
  401842:	48 83 ec 08          	sub    $0x8,%rsp
  401846:	89 fa                	mov    %edi,%edx
  401848:	c7 05 aa 3c 20 00 02 	movl   $0x2,0x203caa(%rip)        # 6054fc <vlevel>
  40184f:	00 00 00 
  401852:	39 3d ac 3c 20 00    	cmp    %edi,0x203cac(%rip)        # 605504 <cookie>
  401858:	74 2a                	je     401884 <touch2+0x42>
  40185a:	48 8d 35 df 1a 00 00 	lea    0x1adf(%rip),%rsi        # 403340 <_IO_stdin_used+0x350>
  401861:	bf 01 00 00 00       	mov    $0x1,%edi
  401866:	b8 00 00 00 00       	mov    $0x0,%eax
  40186b:	e8 70 f5 ff ff       	callq  400de0 <__printf_chk@plt>
  401870:	bf 02 00 00 00       	mov    $0x2,%edi
  401875:	e8 8a 06 00 00       	callq  401f04 <fail>
  40187a:	bf 00 00 00 00       	mov    $0x0,%edi
  40187f:	e8 ac f5 ff ff       	callq  400e30 <exit@plt>
  401884:	48 8d 35 8d 1a 00 00 	lea    0x1a8d(%rip),%rsi        # 403318 <_IO_stdin_used+0x328>
  40188b:	bf 01 00 00 00       	mov    $0x1,%edi
  401890:	b8 00 00 00 00       	mov    $0x0,%eax
  401895:	e8 46 f5 ff ff       	callq  400de0 <__printf_chk@plt>
  40189a:	bf 02 00 00 00       	mov    $0x2,%edi
  40189f:	e8 90 05 00 00       	callq  401e34 <validate>
  4018a4:	eb d4                	jmp    40187a <touch2+0x38>

00000000004018a6 <hexmatch>:
  4018a6:	41 54                	push   %r12
  4018a8:	55                   	push   %rbp
  4018a9:	53                   	push   %rbx
  4018aa:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  4018ae:	89 fd                	mov    %edi,%ebp
  4018b0:	48 89 f3             	mov    %rsi,%rbx
  4018b3:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  4018ba:	00 00 
  4018bc:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  4018c1:	31 c0                	xor    %eax,%eax
  4018c3:	e8 d8 f4 ff ff       	callq  400da0 <random@plt>
  4018c8:	48 89 c1             	mov    %rax,%rcx
  4018cb:	48 ba 0b d7 a3 70 3d 	movabs $0xa3d70a3d70a3d70b,%rdx
  4018d2:	0a d7 a3 
  4018d5:	48 f7 ea             	imul   %rdx
  4018d8:	48 01 ca             	add    %rcx,%rdx
  4018db:	48 c1 fa 06          	sar    $0x6,%rdx
  4018df:	48 89 c8             	mov    %rcx,%rax
  4018e2:	48 c1 f8 3f          	sar    $0x3f,%rax
  4018e6:	48 29 c2             	sub    %rax,%rdx
  4018e9:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  4018ed:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
  4018f1:	48 8d 04 95 00 00 00 	lea    0x0(,%rdx,4),%rax
  4018f8:	00 
  4018f9:	48 29 c1             	sub    %rax,%rcx
  4018fc:	4c 8d 24 0c          	lea    (%rsp,%rcx,1),%r12
  return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
  401900:	41 89 e8             	mov    %ebp,%r8d
  401903:	48 8d 0d 04 1a 00 00 	lea    0x1a04(%rip),%rcx        # 40330e <_IO_stdin_used+0x31e>
  40190a:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  401911:	be 01 00 00 00       	mov    $0x1,%esi
  401916:	4c 89 e7             	mov    %r12,%rdi
  401919:	b8 00 00 00 00       	mov    $0x0,%eax
  40191e:	e8 3d f5 ff ff       	callq  400e60 <__sprintf_chk@plt>
  401923:	ba 09 00 00 00       	mov    $0x9,%edx
  401928:	4c 89 e6             	mov    %r12,%rsi
  40192b:	48 89 df             	mov    %rbx,%rdi
  40192e:	e8 6d f3 ff ff       	callq  400ca0 <strncmp@plt>
  401933:	85 c0                	test   %eax,%eax
  401935:	0f 94 c0             	sete   %al
  401938:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  40193d:	64 48 33 1c 25 28 00 	xor    %fs:0x28,%rbx
  401944:	00 00 
  401946:	75 0c                	jne    401954 <hexmatch+0xae>
  401948:	0f b6 c0             	movzbl %al,%eax
  40194b:	48 83 ec 80          	sub    $0xffffffffffffff80,%rsp
  40194f:	5b                   	pop    %rbx
  401950:	5d                   	pop    %rbp
  401951:	41 5c                	pop    %r12
  401953:	c3                   	retq   
  401954:	e8 87 f3 ff ff       	callq  400ce0 <__stack_chk_fail@plt>

0000000000401959 <touch3>:
  401959:	53                   	push   %rbx
  40195a:	48 89 fb             	mov    %rdi,%rbx
  40195d:	c7 05 95 3b 20 00 03 	movl   $0x3,0x203b95(%rip)        # 6054fc <vlevel>
  401964:	00 00 00 
  401967:	48 89 fe             	mov    %rdi,%rsi
  40196a:	8b 3d 94 3b 20 00    	mov    0x203b94(%rip),%edi        # 605504 <cookie>
  401970:	e8 31 ff ff ff       	callq  4018a6 <hexmatch>
  401975:	85 c0                	test   %eax,%eax
  401977:	74 2d                	je     4019a6 <touch3+0x4d>
  return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
  401979:	48 89 da             	mov    %rbx,%rdx
  40197c:	48 8d 35 e5 19 00 00 	lea    0x19e5(%rip),%rsi        # 403368 <_IO_stdin_used+0x378>
  401983:	bf 01 00 00 00       	mov    $0x1,%edi
  401988:	b8 00 00 00 00       	mov    $0x0,%eax
  40198d:	e8 4e f4 ff ff       	callq  400de0 <__printf_chk@plt>
  401992:	bf 03 00 00 00       	mov    $0x3,%edi
  401997:	e8 98 04 00 00       	callq  401e34 <validate>
  40199c:	bf 00 00 00 00       	mov    $0x0,%edi
  4019a1:	e8 8a f4 ff ff       	callq  400e30 <exit@plt>
  4019a6:	48 89 da             	mov    %rbx,%rdx
  4019a9:	48 8d 35 e0 19 00 00 	lea    0x19e0(%rip),%rsi        # 403390 <_IO_stdin_used+0x3a0>
  4019b0:	bf 01 00 00 00       	mov    $0x1,%edi
  4019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  4019ba:	e8 21 f4 ff ff       	callq  400de0 <__printf_chk@plt>
  4019bf:	bf 03 00 00 00       	mov    $0x3,%edi
  4019c4:	e8 3b 05 00 00       	callq  401f04 <fail>
  4019c9:	eb d1                	jmp    40199c <touch3+0x43>

00000000004019cb <test>:
  4019cb:	48 83 ec 08          	sub    $0x8,%rsp
  4019cf:	b8 00 00 00 00       	mov    $0x0,%eax
  4019d4:	e8 25 fe ff ff       	callq  4017fe <getbuf>
  4019d9:	89 c2                	mov    %eax,%edx
  4019db:	48 8d 35 d6 19 00 00 	lea    0x19d6(%rip),%rsi        # 4033b8 <_IO_stdin_used+0x3c8>
  4019e2:	bf 01 00 00 00       	mov    $0x1,%edi
  4019e7:	b8 00 00 00 00       	mov    $0x0,%eax
  4019ec:	e8 ef f3 ff ff       	callq  400de0 <__printf_chk@plt>
  4019f1:	48 83 c4 08          	add    $0x8,%rsp
  4019f5:	c3                   	retq   

00000000004019f6 <start_farm>:
  4019f6:	b8 01 00 00 00       	mov    $0x1,%eax
  4019fb:	c3                   	retq   

00000000004019fc <addval_327>:
  4019fc:	8d 87 58 90 c3 e0    	lea    -0x1f3c6fa8(%rdi),%eax
  401a02:	c3                   	retq   

0000000000401a03 <addval_304>:
  401a03:	8d 87 cd 48 81 c7    	lea    -0x387eb733(%rdi),%eax
  401a09:	c3                   	retq   

0000000000401a0a <setval_120>:
  401a0a:	c7 07 20 58 94 c3    	movl   $0xc3945820,(%rdi)
  401a10:	c3                   	retq   

0000000000401a11 <setval_114>:
  401a11:	c7 07 48 89 c7 94    	movl   $0x94c78948,(%rdi)
  401a17:	c3                   	retq   

0000000000401a18 <getval_449>:
  401a18:	b8 48 89 c7 c3       	mov    $0xc3c78948,%eax
  401a1d:	c3                   	retq   

0000000000401a1e <getval_450>:
  401a1e:	b8 48 89 c7 90       	mov    $0x90c78948,%eax
  401a23:	c3                   	retq   

0000000000401a24 <addval_378>:
  401a24:	8d 87 58 90 90 c3    	lea    -0x3c6f6fa8(%rdi),%eax
  401a2a:	c3                   	retq   

0000000000401a2b <addval_160>:
  401a2b:	8d 87 ee 58 c7 a0    	lea    -0x5f38a712(%rdi),%eax
  401a31:	c3                   	retq   

0000000000401a32 <mid_farm>:
  401a32:	b8 01 00 00 00       	mov    $0x1,%eax
  401a37:	c3                   	retq   

0000000000401a38 <add_xy>:
  401a38:	48 8d 04 37          	lea    (%rdi,%rsi,1),%rax
  401a3c:	c3                   	retq   

0000000000401a3d <addval_426>:
  401a3d:	8d 87 89 c2 a4 c9    	lea    -0x365b3d77(%rdi),%eax
  401a43:	c3                   	retq   

0000000000401a44 <setval_196>:
  401a44:	c7 07 48 89 e0 90    	movl   $0x90e08948,(%rdi)
  401a4a:	c3                   	retq   

0000000000401a4b <setval_308>:
  401a4b:	c7 07 89 c2 91 90    	movl   $0x9091c289,(%rdi)
  401a51:	c3                   	retq   

0000000000401a52 <setval_318>:
  401a52:	c7 07 89 ce 48 d2    	movl   $0xd248ce89,(%rdi)
  401a58:	c3                   	retq   

0000000000401a59 <addval_235>:
  401a59:	8d 87 89 d1 20 d2    	lea    -0x2ddf2e77(%rdi),%eax
  401a5f:	c3                   	retq   

0000000000401a60 <addval_495>:
  401a60:	8d 87 89 ce 60 c9    	lea    -0x369f3177(%rdi),%eax
  401a66:	c3                   	retq   

0000000000401a67 <addval_419>:
  401a67:	8d 87 99 ce 90 c3    	lea    -0x3c6f3167(%rdi),%eax
  401a6d:	c3                   	retq   

0000000000401a6e <setval_136>:
  401a6e:	c7 07 8b ce 08 db    	movl   $0xdb08ce8b,(%rdi)
  401a74:	c3                   	retq   

0000000000401a75 <addval_246>:
  401a75:	8d 87 89 c2 90 90    	lea    -0x6f6f3d77(%rdi),%eax
  401a7b:	c3                   	retq   

0000000000401a7c <setval_337>:
  401a7c:	c7 07 89 c2 20 c9    	movl   $0xc920c289,(%rdi)
  401a82:	c3                   	retq   

0000000000401a83 <addval_323>:
  401a83:	8d 87 48 c9 e0 c3    	lea    -0x3c1f36b8(%rdi),%eax
  401a89:	c3                   	retq   

0000000000401a8a <getval_344>:
  401a8a:	b8 89 d1 84 d2       	mov    $0xd284d189,%eax
  401a8f:	c3                   	retq   

0000000000401a90 <getval_496>:
  401a90:	b8 b4 08 89 e0       	mov    $0xe08908b4,%eax
  401a95:	c3                   	retq   

0000000000401a96 <setval_255>:
  401a96:	c7 07 c3 89 d1 92    	movl   $0x92d189c3,(%rdi)
  401a9c:	c3                   	retq   

0000000000401a9d <setval_144>:
  401a9d:	c7 07 88 c2 38 db    	movl   $0xdb38c288,(%rdi)
  401aa3:	c3                   	retq   

0000000000401aa4 <addval_197>:
  401aa4:	8d 87 89 ce 84 c0    	lea    -0x3f7b3177(%rdi),%eax
  401aaa:	c3                   	retq   

0000000000401aab <addval_445>:
  401aab:	8d 87 48 8d e0 c3    	lea    -0x3c1f72b8(%rdi),%eax
  401ab1:	c3                   	retq   

0000000000401ab2 <getval_293>:
  401ab2:	b8 4c 89 e0 90       	mov    $0x90e0894c,%eax
  401ab7:	c3                   	retq   

0000000000401ab8 <setval_218>:
  401ab8:	c7 07 89 c2 00 c0    	movl   $0xc000c289,(%rdi)
  401abe:	c3                   	retq   

0000000000401abf <addval_390>:
  401abf:	8d 87 99 d1 20 db    	lea    -0x24df2e67(%rdi),%eax
  401ac5:	c3                   	retq   

0000000000401ac6 <setval_439>:
  401ac6:	c7 07 09 ce 90 c3    	movl   $0xc390ce09,(%rdi)
  401acc:	c3                   	retq   

0000000000401acd <setval_232>:
  401acd:	c7 07 8d d1 90 c3    	movl   $0xc390d18d,(%rdi)
  401ad3:	c3                   	retq   

0000000000401ad4 <addval_180>:
  401ad4:	8d 87 46 6a 89 ce    	lea    -0x317695ba(%rdi),%eax
  401ada:	c3                   	retq   

0000000000401adb <addval_113>:
  401adb:	8d 87 89 c2 00 c9    	lea    -0x36ff3d77(%rdi),%eax
  401ae1:	c3                   	retq   

0000000000401ae2 <getval_141>:
  401ae2:	b8 48 89 e0 c3       	mov    $0xc3e08948,%eax
  401ae7:	c3                   	retq   

0000000000401ae8 <addval_467>:
  401ae8:	8d 87 c9 d1 84 c9    	lea    -0x367b2e37(%rdi),%eax
  401aee:	c3                   	retq   

0000000000401aef <addval_184>:
  401aef:	8d 87 f7 a9 d1 90    	lea    -0x6f2e5609(%rdi),%eax
  401af5:	c3                   	retq   

0000000000401af6 <getval_488>:
  401af6:	b8 48 89 e0 c7       	mov    $0xc7e08948,%eax
  401afb:	c3                   	retq   

0000000000401afc <getval_195>:
  401afc:	b8 89 c2 00 c9       	mov    $0xc900c289,%eax
  401b01:	c3                   	retq   

0000000000401b02 <addval_463>:
  401b02:	8d 87 89 d1 18 c0    	lea    -0x3fe72e77(%rdi),%eax
  401b08:	c3                   	retq   

0000000000401b09 <getval_341>:
  401b09:	b8 89 ce 28 c0       	mov    $0xc028ce89,%eax
  401b0e:	c3                   	retq   

0000000000401b0f <addval_438>:
  401b0f:	8d 87 48 89 e0 c2    	lea    -0x3d1f76b8(%rdi),%eax
  401b15:	c3                   	retq   

0000000000401b16 <end_farm>:
  401b16:	b8 01 00 00 00       	mov    $0x1,%eax
  401b1b:	c3                   	retq   

0000000000401b1c <save_char>:
  401b1c:	8b 05 02 46 20 00    	mov    0x204602(%rip),%eax        # 606124 <gets_cnt>
  401b22:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  401b27:	7f 4a                	jg     401b73 <save_char+0x57>
  401b29:	89 f9                	mov    %edi,%ecx
  401b2b:	c0 e9 04             	shr    $0x4,%cl
  401b2e:	8d 14 40             	lea    (%rax,%rax,2),%edx
  401b31:	4c 8d 05 a8 1b 00 00 	lea    0x1ba8(%rip),%r8        # 4036e0 <trans_char>
  401b38:	83 e1 0f             	and    $0xf,%ecx
  401b3b:	45 0f b6 0c 08       	movzbl (%r8,%rcx,1),%r9d
  401b40:	48 8d 0d d9 39 20 00 	lea    0x2039d9(%rip),%rcx        # 605520 <gets_buf>
  401b47:	48 63 f2             	movslq %edx,%rsi
  401b4a:	44 88 0c 31          	mov    %r9b,(%rcx,%rsi,1)
  401b4e:	8d 72 01             	lea    0x1(%rdx),%esi
  401b51:	83 e7 0f             	and    $0xf,%edi
  401b54:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
  401b59:	48 63 f6             	movslq %esi,%rsi
  401b5c:	40 88 3c 31          	mov    %dil,(%rcx,%rsi,1)
  401b60:	83 c2 02             	add    $0x2,%edx
  401b63:	48 63 d2             	movslq %edx,%rdx
  401b66:	c6 04 11 20          	movb   $0x20,(%rcx,%rdx,1)
  401b6a:	83 c0 01             	add    $0x1,%eax
  401b6d:	89 05 b1 45 20 00    	mov    %eax,0x2045b1(%rip)        # 606124 <gets_cnt>
  401b73:	f3 c3                	repz retq 

0000000000401b75 <save_term>:
  401b75:	8b 05 a9 45 20 00    	mov    0x2045a9(%rip),%eax        # 606124 <gets_cnt>
  401b7b:	8d 04 40             	lea    (%rax,%rax,2),%eax
  401b7e:	48 98                	cltq   
  401b80:	48 8d 15 99 39 20 00 	lea    0x203999(%rip),%rdx        # 605520 <gets_buf>
  401b87:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
  401b8b:	c3                   	retq   

0000000000401b8c <check_fail>:
  401b8c:	48 83 ec 08          	sub    $0x8,%rsp
  401b90:	0f be 15 91 45 20 00 	movsbl 0x204591(%rip),%edx        # 606128 <target_prefix>
  401b97:	4c 8d 05 82 39 20 00 	lea    0x203982(%rip),%r8        # 605520 <gets_buf>
  401b9e:	8b 0d 54 39 20 00    	mov    0x203954(%rip),%ecx        # 6054f8 <check_level>
  401ba4:	48 8d 35 30 18 00 00 	lea    0x1830(%rip),%rsi        # 4033db <_IO_stdin_used+0x3eb>
  401bab:	bf 01 00 00 00       	mov    $0x1,%edi
  401bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  401bb5:	e8 26 f2 ff ff       	callq  400de0 <__printf_chk@plt>
  401bba:	bf 01 00 00 00       	mov    $0x1,%edi
  401bbf:	e8 6c f2 ff ff       	callq  400e30 <exit@plt>

0000000000401bc4 <Gets>:
  401bc4:	41 54                	push   %r12
  401bc6:	55                   	push   %rbp
  401bc7:	53                   	push   %rbx
  401bc8:	49 89 fc             	mov    %rdi,%r12
  401bcb:	c7 05 4f 45 20 00 00 	movl   $0x0,0x20454f(%rip)        # 606124 <gets_cnt>
  401bd2:	00 00 00 
  401bd5:	48 89 fb             	mov    %rdi,%rbx
  401bd8:	eb 11                	jmp    401beb <Gets+0x27>
  401bda:	48 8d 6b 01          	lea    0x1(%rbx),%rbp
  401bde:	88 03                	mov    %al,(%rbx)
  401be0:	0f b6 f8             	movzbl %al,%edi
  401be3:	e8 34 ff ff ff       	callq  401b1c <save_char>
  401be8:	48 89 eb             	mov    %rbp,%rbx
  401beb:	48 8b 3d fe 38 20 00 	mov    0x2038fe(%rip),%rdi        # 6054f0 <infile>
  401bf2:	e8 b9 f1 ff ff       	callq  400db0 <_IO_getc@plt>
  401bf7:	83 f8 ff             	cmp    $0xffffffff,%eax
  401bfa:	74 05                	je     401c01 <Gets+0x3d>
  401bfc:	83 f8 0a             	cmp    $0xa,%eax
  401bff:	75 d9                	jne    401bda <Gets+0x16>
  401c01:	c6 03 00             	movb   $0x0,(%rbx)
  401c04:	b8 00 00 00 00       	mov    $0x0,%eax
  401c09:	e8 67 ff ff ff       	callq  401b75 <save_term>
  401c0e:	4c 89 e0             	mov    %r12,%rax
  401c11:	5b                   	pop    %rbx
  401c12:	5d                   	pop    %rbp
  401c13:	41 5c                	pop    %r12
  401c15:	c3                   	retq   

0000000000401c16 <notify_server>:
  401c16:	55                   	push   %rbp
  401c17:	53                   	push   %rbx
  401c18:	48 81 ec 18 40 00 00 	sub    $0x4018,%rsp
  401c1f:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  401c26:	00 00 
  401c28:	48 89 84 24 08 40 00 	mov    %rax,0x4008(%rsp)
  401c2f:	00 
  401c30:	31 c0                	xor    %eax,%eax
  401c32:	83 3d cf 38 20 00 00 	cmpl   $0x0,0x2038cf(%rip)        # 605508 <is_checker>
  401c39:	0f 85 d2 00 00 00    	jne    401d11 <notify_server+0xfb>
  401c3f:	89 fb                	mov    %edi,%ebx
  401c41:	8b 05 dd 44 20 00    	mov    0x2044dd(%rip),%eax        # 606124 <gets_cnt>
  401c47:	83 c0 64             	add    $0x64,%eax
  401c4a:	3d 00 20 00 00       	cmp    $0x2000,%eax
  401c4f:	0f 8f dd 00 00 00    	jg     401d32 <notify_server+0x11c>
  401c55:	0f be 05 cc 44 20 00 	movsbl 0x2044cc(%rip),%eax        # 606128 <target_prefix>
  401c5c:	83 3d 25 38 20 00 00 	cmpl   $0x0,0x203825(%rip)        # 605488 <notify>
  401c63:	0f 84 e9 00 00 00    	je     401d52 <notify_server+0x13c>
  401c69:	8b 15 91 38 20 00    	mov    0x203891(%rip),%edx        # 605500 <authkey>
  401c6f:	85 db                	test   %ebx,%ebx
  401c71:	0f 84 e5 00 00 00    	je     401d5c <notify_server+0x146>
  401c77:	48 8d 2d 73 17 00 00 	lea    0x1773(%rip),%rbp        # 4033f1 <_IO_stdin_used+0x401>
  return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
  401c7e:	48 89 e7             	mov    %rsp,%rdi
  401c81:	48 8d 0d 98 38 20 00 	lea    0x203898(%rip),%rcx        # 605520 <gets_buf>
  401c88:	51                   	push   %rcx
  401c89:	56                   	push   %rsi
  401c8a:	50                   	push   %rax
  401c8b:	52                   	push   %rdx
  401c8c:	49 89 e9             	mov    %rbp,%r9
  401c8f:	44 8b 05 9a 34 20 00 	mov    0x20349a(%rip),%r8d        # 605130 <target_id>
  401c96:	48 8d 0d 5e 17 00 00 	lea    0x175e(%rip),%rcx        # 4033fb <_IO_stdin_used+0x40b>
  401c9d:	ba 00 20 00 00       	mov    $0x2000,%edx
  401ca2:	be 01 00 00 00       	mov    $0x1,%esi
  401ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  401cac:	e8 af f1 ff ff       	callq  400e60 <__sprintf_chk@plt>
  401cb1:	48 83 c4 20          	add    $0x20,%rsp
  401cb5:	83 3d cc 37 20 00 00 	cmpl   $0x0,0x2037cc(%rip)        # 605488 <notify>
  401cbc:	0f 84 df 00 00 00    	je     401da1 <notify_server+0x18b>
  401cc2:	85 db                	test   %ebx,%ebx
  401cc4:	0f 84 c6 00 00 00    	je     401d90 <notify_server+0x17a>
  401cca:	48 89 e1             	mov    %rsp,%rcx
  401ccd:	4c 8d 8c 24 00 20 00 	lea    0x2000(%rsp),%r9
  401cd4:	00 
  401cd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  401cdb:	48 8b 15 66 34 20 00 	mov    0x203466(%rip),%rdx        # 605148 <lab>
  401ce2:	48 8b 35 67 34 20 00 	mov    0x203467(%rip),%rsi        # 605150 <course>
  401ce9:	48 8b 3d 50 34 20 00 	mov    0x203450(%rip),%rdi        # 605140 <user_id>
  401cf0:	e8 af 11 00 00       	callq  402ea4 <driver_post>
  401cf5:	85 c0                	test   %eax,%eax
  401cf7:	78 6f                	js     401d68 <notify_server+0x152>
  return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
  401cf9:	48 8d 3d 40 18 00 00 	lea    0x1840(%rip),%rdi        # 403540 <_IO_stdin_used+0x550>
  401d00:	e8 bb ef ff ff       	callq  400cc0 <puts@plt>
  401d05:	48 8d 3d 17 17 00 00 	lea    0x1717(%rip),%rdi        # 403423 <_IO_stdin_used+0x433>
  401d0c:	e8 af ef ff ff       	callq  400cc0 <puts@plt>
  401d11:	48 8b 84 24 08 40 00 	mov    0x4008(%rsp),%rax
  401d18:	00 
  401d19:	64 48 33 04 25 28 00 	xor    %fs:0x28,%rax
  401d20:	00 00 
  401d22:	0f 85 07 01 00 00    	jne    401e2f <notify_server+0x219>
  401d28:	48 81 c4 18 40 00 00 	add    $0x4018,%rsp
  401d2f:	5b                   	pop    %rbx
  401d30:	5d                   	pop    %rbp
  401d31:	c3                   	retq   
  401d32:	48 8d 35 d7 17 00 00 	lea    0x17d7(%rip),%rsi        # 403510 <_IO_stdin_used+0x520>
  401d39:	bf 01 00 00 00       	mov    $0x1,%edi
  401d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  401d43:	e8 98 f0 ff ff       	callq  400de0 <__printf_chk@plt>
  401d48:	bf 01 00 00 00       	mov    $0x1,%edi
  401d4d:	e8 de f0 ff ff       	callq  400e30 <exit@plt>
  401d52:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  401d57:	e9 13 ff ff ff       	jmpq   401c6f <notify_server+0x59>
  401d5c:	48 8d 2d 93 16 00 00 	lea    0x1693(%rip),%rbp        # 4033f6 <_IO_stdin_used+0x406>
  401d63:	e9 16 ff ff ff       	jmpq   401c7e <notify_server+0x68>
  401d68:	48 8d 94 24 00 20 00 	lea    0x2000(%rsp),%rdx
  401d6f:	00 
  401d70:	48 8d 35 a0 16 00 00 	lea    0x16a0(%rip),%rsi        # 403417 <_IO_stdin_used+0x427>
  401d77:	bf 01 00 00 00       	mov    $0x1,%edi
  401d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  401d81:	e8 5a f0 ff ff       	callq  400de0 <__printf_chk@plt>
  401d86:	bf 01 00 00 00       	mov    $0x1,%edi
  401d8b:	e8 a0 f0 ff ff       	callq  400e30 <exit@plt>
  401d90:	48 8d 3d 96 16 00 00 	lea    0x1696(%rip),%rdi        # 40342d <_IO_stdin_used+0x43d>
  401d97:	e8 24 ef ff ff       	callq  400cc0 <puts@plt>
  401d9c:	e9 70 ff ff ff       	jmpq   401d11 <notify_server+0xfb>
  401da1:	48 89 ea             	mov    %rbp,%rdx
  401da4:	48 8d 35 cd 17 00 00 	lea    0x17cd(%rip),%rsi        # 403578 <_IO_stdin_used+0x588>
  401dab:	bf 01 00 00 00       	mov    $0x1,%edi
  401db0:	b8 00 00 00 00       	mov    $0x0,%eax
  401db5:	e8 26 f0 ff ff       	callq  400de0 <__printf_chk@plt>
  401dba:	48 8b 15 7f 33 20 00 	mov    0x20337f(%rip),%rdx        # 605140 <user_id>
  401dc1:	48 8d 35 6c 16 00 00 	lea    0x166c(%rip),%rsi        # 403434 <_IO_stdin_used+0x444>
  401dc8:	bf 01 00 00 00       	mov    $0x1,%edi
  401dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  401dd2:	e8 09 f0 ff ff       	callq  400de0 <__printf_chk@plt>
  401dd7:	48 8b 15 72 33 20 00 	mov    0x203372(%rip),%rdx        # 605150 <course>
  401dde:	48 8d 35 5c 16 00 00 	lea    0x165c(%rip),%rsi        # 403441 <_IO_stdin_used+0x451>
  401de5:	bf 01 00 00 00       	mov    $0x1,%edi
  401dea:	b8 00 00 00 00       	mov    $0x0,%eax
  401def:	e8 ec ef ff ff       	callq  400de0 <__printf_chk@plt>
  401df4:	48 8b 15 4d 33 20 00 	mov    0x20334d(%rip),%rdx        # 605148 <lab>
  401dfb:	48 8d 35 4b 16 00 00 	lea    0x164b(%rip),%rsi        # 40344d <_IO_stdin_used+0x45d>
  401e02:	bf 01 00 00 00       	mov    $0x1,%edi
  401e07:	b8 00 00 00 00       	mov    $0x0,%eax
  401e0c:	e8 cf ef ff ff       	callq  400de0 <__printf_chk@plt>
  401e11:	48 89 e2             	mov    %rsp,%rdx
  401e14:	48 8d 35 3b 16 00 00 	lea    0x163b(%rip),%rsi        # 403456 <_IO_stdin_used+0x466>
  401e1b:	bf 01 00 00 00       	mov    $0x1,%edi
  401e20:	b8 00 00 00 00       	mov    $0x0,%eax
  401e25:	e8 b6 ef ff ff       	callq  400de0 <__printf_chk@plt>
  401e2a:	e9 e2 fe ff ff       	jmpq   401d11 <notify_server+0xfb>
  401e2f:	e8 ac ee ff ff       	callq  400ce0 <__stack_chk_fail@plt>

0000000000401e34 <validate>:
  401e34:	53                   	push   %rbx
  401e35:	89 fb                	mov    %edi,%ebx
  401e37:	83 3d ca 36 20 00 00 	cmpl   $0x0,0x2036ca(%rip)        # 605508 <is_checker>
  401e3e:	74 72                	je     401eb2 <validate+0x7e>
  401e40:	39 3d b6 36 20 00    	cmp    %edi,0x2036b6(%rip)        # 6054fc <vlevel>
  401e46:	75 32                	jne    401e7a <validate+0x46>
  401e48:	8b 15 aa 36 20 00    	mov    0x2036aa(%rip),%edx        # 6054f8 <check_level>
  401e4e:	39 fa                	cmp    %edi,%edx
  401e50:	75 3e                	jne    401e90 <validate+0x5c>
  401e52:	0f be 15 cf 42 20 00 	movsbl 0x2042cf(%rip),%edx        # 606128 <target_prefix>
  401e59:	4c 8d 05 c0 36 20 00 	lea    0x2036c0(%rip),%r8        # 605520 <gets_buf>
  401e60:	89 f9                	mov    %edi,%ecx
  401e62:	48 8d 35 17 16 00 00 	lea    0x1617(%rip),%rsi        # 403480 <_IO_stdin_used+0x490>
  401e69:	bf 01 00 00 00       	mov    $0x1,%edi
  401e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  401e73:	e8 68 ef ff ff       	callq  400de0 <__printf_chk@plt>
  401e78:	5b                   	pop    %rbx
  401e79:	c3                   	retq   
  401e7a:	48 8d 3d e1 15 00 00 	lea    0x15e1(%rip),%rdi        # 403462 <_IO_stdin_used+0x472>
  401e81:	e8 3a ee ff ff       	callq  400cc0 <puts@plt>
  401e86:	b8 00 00 00 00       	mov    $0x0,%eax
  401e8b:	e8 fc fc ff ff       	callq  401b8c <check_fail>
  401e90:	89 f9                	mov    %edi,%ecx
  401e92:	48 8d 35 07 17 00 00 	lea    0x1707(%rip),%rsi        # 4035a0 <_IO_stdin_used+0x5b0>
  401e99:	bf 01 00 00 00       	mov    $0x1,%edi
  401e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  401ea3:	e8 38 ef ff ff       	callq  400de0 <__printf_chk@plt>
  401ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  401ead:	e8 da fc ff ff       	callq  401b8c <check_fail>
  401eb2:	39 3d 44 36 20 00    	cmp    %edi,0x203644(%rip)        # 6054fc <vlevel>
  401eb8:	74 1a                	je     401ed4 <validate+0xa0>
  401eba:	48 8d 3d a1 15 00 00 	lea    0x15a1(%rip),%rdi        # 403462 <_IO_stdin_used+0x472>
  401ec1:	e8 fa ed ff ff       	callq  400cc0 <puts@plt>
  401ec6:	89 de                	mov    %ebx,%esi
  401ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  401ecd:	e8 44 fd ff ff       	callq  401c16 <notify_server>
  401ed2:	eb a4                	jmp    401e78 <validate+0x44>
  401ed4:	0f be 0d 4d 42 20 00 	movsbl 0x20424d(%rip),%ecx        # 606128 <target_prefix>
  401edb:	89 fa                	mov    %edi,%edx
  401edd:	48 8d 35 e4 16 00 00 	lea    0x16e4(%rip),%rsi        # 4035c8 <_IO_stdin_used+0x5d8>
  401ee4:	bf 01 00 00 00       	mov    $0x1,%edi
  401ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  401eee:	e8 ed ee ff ff       	callq  400de0 <__printf_chk@plt>
  401ef3:	89 de                	mov    %ebx,%esi
  401ef5:	bf 01 00 00 00       	mov    $0x1,%edi
  401efa:	e8 17 fd ff ff       	callq  401c16 <notify_server>
  401eff:	e9 74 ff ff ff       	jmpq   401e78 <validate+0x44>

0000000000401f04 <fail>:
  401f04:	48 83 ec 08          	sub    $0x8,%rsp
  401f08:	83 3d f9 35 20 00 00 	cmpl   $0x0,0x2035f9(%rip)        # 605508 <is_checker>
  401f0f:	75 11                	jne    401f22 <fail+0x1e>
  401f11:	89 fe                	mov    %edi,%esi
  401f13:	bf 00 00 00 00       	mov    $0x0,%edi
  401f18:	e8 f9 fc ff ff       	callq  401c16 <notify_server>
  401f1d:	48 83 c4 08          	add    $0x8,%rsp
  401f21:	c3                   	retq   
  401f22:	b8 00 00 00 00       	mov    $0x0,%eax
  401f27:	e8 60 fc ff ff       	callq  401b8c <check_fail>

0000000000401f2c <bushandler>:
  401f2c:	48 83 ec 08          	sub    $0x8,%rsp
  401f30:	83 3d d1 35 20 00 00 	cmpl   $0x0,0x2035d1(%rip)        # 605508 <is_checker>
  401f37:	74 16                	je     401f4f <bushandler+0x23>
  401f39:	48 8d 3d 55 15 00 00 	lea    0x1555(%rip),%rdi        # 403495 <_IO_stdin_used+0x4a5>
  401f40:	e8 7b ed ff ff       	callq  400cc0 <puts@plt>
  401f45:	b8 00 00 00 00       	mov    $0x0,%eax
  401f4a:	e8 3d fc ff ff       	callq  401b8c <check_fail>
  401f4f:	48 8d 3d aa 16 00 00 	lea    0x16aa(%rip),%rdi        # 403600 <_IO_stdin_used+0x610>
  401f56:	e8 65 ed ff ff       	callq  400cc0 <puts@plt>
  401f5b:	48 8d 3d 3d 15 00 00 	lea    0x153d(%rip),%rdi        # 40349f <_IO_stdin_used+0x4af>
  401f62:	e8 59 ed ff ff       	callq  400cc0 <puts@plt>
  401f67:	be 00 00 00 00       	mov    $0x0,%esi
  401f6c:	bf 00 00 00 00       	mov    $0x0,%edi
  401f71:	e8 a0 fc ff ff       	callq  401c16 <notify_server>
  401f76:	bf 01 00 00 00       	mov    $0x1,%edi
  401f7b:	e8 b0 ee ff ff       	callq  400e30 <exit@plt>

0000000000401f80 <seghandler>:
  401f80:	48 83 ec 08          	sub    $0x8,%rsp
  401f84:	83 3d 7d 35 20 00 00 	cmpl   $0x0,0x20357d(%rip)        # 605508 <is_checker>
  401f8b:	74 16                	je     401fa3 <seghandler+0x23>
  401f8d:	48 8d 3d 21 15 00 00 	lea    0x1521(%rip),%rdi        # 4034b5 <_IO_stdin_used+0x4c5>
  401f94:	e8 27 ed ff ff       	callq  400cc0 <puts@plt>
  401f99:	b8 00 00 00 00       	mov    $0x0,%eax
  401f9e:	e8 e9 fb ff ff       	callq  401b8c <check_fail>
  401fa3:	48 8d 3d 76 16 00 00 	lea    0x1676(%rip),%rdi        # 403620 <_IO_stdin_used+0x630>
  401faa:	e8 11 ed ff ff       	callq  400cc0 <puts@plt>
  401faf:	48 8d 3d e9 14 00 00 	lea    0x14e9(%rip),%rdi        # 40349f <_IO_stdin_used+0x4af>
  401fb6:	e8 05 ed ff ff       	callq  400cc0 <puts@plt>
  401fbb:	be 00 00 00 00       	mov    $0x0,%esi
  401fc0:	bf 00 00 00 00       	mov    $0x0,%edi
  401fc5:	e8 4c fc ff ff       	callq  401c16 <notify_server>
  401fca:	bf 01 00 00 00       	mov    $0x1,%edi
  401fcf:	e8 5c ee ff ff       	callq  400e30 <exit@plt>

0000000000401fd4 <illegalhandler>:
  401fd4:	48 83 ec 08          	sub    $0x8,%rsp
  401fd8:	83 3d 29 35 20 00 00 	cmpl   $0x0,0x203529(%rip)        # 605508 <is_checker>
  401fdf:	74 16                	je     401ff7 <illegalhandler+0x23>
  401fe1:	48 8d 3d e0 14 00 00 	lea    0x14e0(%rip),%rdi        # 4034c8 <_IO_stdin_used+0x4d8>
  401fe8:	e8 d3 ec ff ff       	callq  400cc0 <puts@plt>
  401fed:	b8 00 00 00 00       	mov    $0x0,%eax
  401ff2:	e8 95 fb ff ff       	callq  401b8c <check_fail>
  401ff7:	48 8d 3d 4a 16 00 00 	lea    0x164a(%rip),%rdi        # 403648 <_IO_stdin_used+0x658>
  401ffe:	e8 bd ec ff ff       	callq  400cc0 <puts@plt>
  402003:	48 8d 3d 95 14 00 00 	lea    0x1495(%rip),%rdi        # 40349f <_IO_stdin_used+0x4af>
  40200a:	e8 b1 ec ff ff       	callq  400cc0 <puts@plt>
  40200f:	be 00 00 00 00       	mov    $0x0,%esi
  402014:	bf 00 00 00 00       	mov    $0x0,%edi
  402019:	e8 f8 fb ff ff       	callq  401c16 <notify_server>
  40201e:	bf 01 00 00 00       	mov    $0x1,%edi
  402023:	e8 08 ee ff ff       	callq  400e30 <exit@plt>

0000000000402028 <sigalrmhandler>:
  402028:	48 83 ec 08          	sub    $0x8,%rsp
  40202c:	83 3d d5 34 20 00 00 	cmpl   $0x0,0x2034d5(%rip)        # 605508 <is_checker>
  402033:	74 16                	je     40204b <sigalrmhandler+0x23>
  402035:	48 8d 3d a0 14 00 00 	lea    0x14a0(%rip),%rdi        # 4034dc <_IO_stdin_used+0x4ec>
  40203c:	e8 7f ec ff ff       	callq  400cc0 <puts@plt>
  402041:	b8 00 00 00 00       	mov    $0x0,%eax
  402046:	e8 41 fb ff ff       	callq  401b8c <check_fail>
  40204b:	ba 05 00 00 00       	mov    $0x5,%edx
  402050:	48 8d 35 21 16 00 00 	lea    0x1621(%rip),%rsi        # 403678 <_IO_stdin_used+0x688>
  402057:	bf 01 00 00 00       	mov    $0x1,%edi
  40205c:	b8 00 00 00 00       	mov    $0x0,%eax
  402061:	e8 7a ed ff ff       	callq  400de0 <__printf_chk@plt>
  402066:	be 00 00 00 00       	mov    $0x0,%esi
  40206b:	bf 00 00 00 00       	mov    $0x0,%edi
  402070:	e8 a1 fb ff ff       	callq  401c16 <notify_server>
  402075:	bf 01 00 00 00       	mov    $0x1,%edi
  40207a:	e8 b1 ed ff ff       	callq  400e30 <exit@plt>

000000000040207f <launch>:
  40207f:	55                   	push   %rbp
  402080:	48 89 e5             	mov    %rsp,%rbp
  402083:	48 83 ec 10          	sub    $0x10,%rsp
  402087:	48 89 fa             	mov    %rdi,%rdx
  40208a:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  402091:	00 00 
  402093:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  402097:	31 c0                	xor    %eax,%eax
  402099:	48 8d 47 1e          	lea    0x1e(%rdi),%rax
  40209d:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  4020a1:	48 29 c4             	sub    %rax,%rsp
  4020a4:	48 8d 7c 24 0f       	lea    0xf(%rsp),%rdi
  4020a9:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
    {
      __warn_memset_zero_len ();
      return __dest;
    }
#endif
  return __builtin___memset_chk (__dest, __ch, __len, __bos0 (__dest));
  4020ad:	be f4 00 00 00       	mov    $0xf4,%esi
  4020b2:	e8 49 ec ff ff       	callq  400d00 <memset@plt>
  4020b7:	48 8b 05 e2 33 20 00 	mov    0x2033e2(%rip),%rax        # 6054a0 <stdin@@GLIBC_2.2.5>
  4020be:	48 39 05 2b 34 20 00 	cmp    %rax,0x20342b(%rip)        # 6054f0 <infile>
  4020c5:	74 3a                	je     402101 <launch+0x82>
  4020c7:	c7 05 2b 34 20 00 00 	movl   $0x0,0x20342b(%rip)        # 6054fc <vlevel>
  4020ce:	00 00 00 
  4020d1:	b8 00 00 00 00       	mov    $0x0,%eax
  4020d6:	e8 f0 f8 ff ff       	callq  4019cb <test>
  4020db:	83 3d 26 34 20 00 00 	cmpl   $0x0,0x203426(%rip)        # 605508 <is_checker>
  4020e2:	75 35                	jne    402119 <launch+0x9a>
  4020e4:	48 8d 3d 11 14 00 00 	lea    0x1411(%rip),%rdi        # 4034fc <_IO_stdin_used+0x50c>
  4020eb:	e8 d0 eb ff ff       	callq  400cc0 <puts@plt>
  4020f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4020f4:	64 48 33 04 25 28 00 	xor    %fs:0x28,%rax
  4020fb:	00 00 
  4020fd:	75 30                	jne    40212f <launch+0xb0>
  4020ff:	c9                   	leaveq 
  402100:	c3                   	retq   
  402101:	48 8d 35 dc 13 00 00 	lea    0x13dc(%rip),%rsi        # 4034e4 <_IO_stdin_used+0x4f4>
  402108:	bf 01 00 00 00       	mov    $0x1,%edi
  40210d:	b8 00 00 00 00       	mov    $0x0,%eax
  402112:	e8 c9 ec ff ff       	callq  400de0 <__printf_chk@plt>
  402117:	eb ae                	jmp    4020c7 <launch+0x48>
  402119:	48 8d 3d d1 13 00 00 	lea    0x13d1(%rip),%rdi        # 4034f1 <_IO_stdin_used+0x501>
  402120:	e8 9b eb ff ff       	callq  400cc0 <puts@plt>
  402125:	b8 00 00 00 00       	mov    $0x0,%eax
  40212a:	e8 5d fa ff ff       	callq  401b8c <check_fail>
  40212f:	e8 ac eb ff ff       	callq  400ce0 <__stack_chk_fail@plt>

0000000000402134 <stable_launch>:
  402134:	53                   	push   %rbx
  402135:	48 89 3d ac 33 20 00 	mov    %rdi,0x2033ac(%rip)        # 6054e8 <global_offset>
  40213c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  402142:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  402148:	b9 32 01 00 00       	mov    $0x132,%ecx
  40214d:	ba 07 00 00 00       	mov    $0x7,%edx
  402152:	be 00 00 10 00       	mov    $0x100000,%esi
  402157:	bf 00 60 58 55       	mov    $0x55586000,%edi
  40215c:	e8 8f eb ff ff       	callq  400cf0 <mmap@plt>
  402161:	48 89 c3             	mov    %rax,%rbx
  402164:	48 3d 00 60 58 55    	cmp    $0x55586000,%rax
  40216a:	75 43                	jne    4021af <stable_launch+0x7b>
  40216c:	48 8d 90 f8 ff 0f 00 	lea    0xffff8(%rax),%rdx
  402173:	48 89 15 b6 3f 20 00 	mov    %rdx,0x203fb6(%rip)        # 606130 <stack_top>
  40217a:	48 89 e0             	mov    %rsp,%rax
  40217d:	48 89 d4             	mov    %rdx,%rsp
  402180:	48 89 c2             	mov    %rax,%rdx
  402183:	48 89 15 56 33 20 00 	mov    %rdx,0x203356(%rip)        # 6054e0 <global_save_stack>
  40218a:	48 8b 3d 57 33 20 00 	mov    0x203357(%rip),%rdi        # 6054e8 <global_offset>
  402191:	e8 e9 fe ff ff       	callq  40207f <launch>
  402196:	48 8b 05 43 33 20 00 	mov    0x203343(%rip),%rax        # 6054e0 <global_save_stack>
  40219d:	48 89 c4             	mov    %rax,%rsp
  4021a0:	be 00 00 10 00       	mov    $0x100000,%esi
  4021a5:	48 89 df             	mov    %rbx,%rdi
  4021a8:	e8 23 ec ff ff       	callq  400dd0 <munmap@plt>
  4021ad:	5b                   	pop    %rbx
  4021ae:	c3                   	retq   
  4021af:	be 00 00 10 00       	mov    $0x100000,%esi
  4021b4:	48 89 c7             	mov    %rax,%rdi
  4021b7:	e8 14 ec ff ff       	callq  400dd0 <munmap@plt>
  return __fprintf_chk (__stream, __USE_FORTIFY_LEVEL - 1, __fmt,
  4021bc:	b9 00 60 58 55       	mov    $0x55586000,%ecx
  4021c1:	48 8d 15 e8 14 00 00 	lea    0x14e8(%rip),%rdx        # 4036b0 <_IO_stdin_used+0x6c0>
  4021c8:	be 01 00 00 00       	mov    $0x1,%esi
  4021cd:	48 8b 3d ec 32 20 00 	mov    0x2032ec(%rip),%rdi        # 6054c0 <stderr@@GLIBC_2.2.5>
  4021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  4021d9:	e8 72 ec ff ff       	callq  400e50 <__fprintf_chk@plt>
  4021de:	bf 01 00 00 00       	mov    $0x1,%edi
  4021e3:	e8 48 ec ff ff       	callq  400e30 <exit@plt>

00000000004021e8 <rio_readinitb>:
  4021e8:	89 37                	mov    %esi,(%rdi)
  4021ea:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%rdi)
  4021f1:	48 8d 47 10          	lea    0x10(%rdi),%rax
  4021f5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  4021f9:	c3                   	retq   

00000000004021fa <sigalrm_handler>:
  4021fa:	48 83 ec 08          	sub    $0x8,%rsp
  4021fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  402203:	48 8d 15 e6 14 00 00 	lea    0x14e6(%rip),%rdx        # 4036f0 <trans_char+0x10>
  40220a:	be 01 00 00 00       	mov    $0x1,%esi
  40220f:	48 8b 3d aa 32 20 00 	mov    0x2032aa(%rip),%rdi        # 6054c0 <stderr@@GLIBC_2.2.5>
  402216:	b8 00 00 00 00       	mov    $0x0,%eax
  40221b:	e8 30 ec ff ff       	callq  400e50 <__fprintf_chk@plt>
  402220:	bf 01 00 00 00       	mov    $0x1,%edi
  402225:	e8 06 ec ff ff       	callq  400e30 <exit@plt>

000000000040222a <rio_writen>:
  40222a:	41 55                	push   %r13
  40222c:	41 54                	push   %r12
  40222e:	55                   	push   %rbp
  40222f:	53                   	push   %rbx
  402230:	48 83 ec 08          	sub    $0x8,%rsp
  402234:	41 89 fc             	mov    %edi,%r12d
  402237:	48 89 f5             	mov    %rsi,%rbp
  40223a:	49 89 d5             	mov    %rdx,%r13
  40223d:	48 89 d3             	mov    %rdx,%rbx
  402240:	eb 06                	jmp    402248 <rio_writen+0x1e>
  402242:	48 29 c3             	sub    %rax,%rbx
  402245:	48 01 c5             	add    %rax,%rbp
  402248:	48 85 db             	test   %rbx,%rbx
  40224b:	74 24                	je     402271 <rio_writen+0x47>
  40224d:	48 89 da             	mov    %rbx,%rdx
  402250:	48 89 ee             	mov    %rbp,%rsi
  402253:	44 89 e7             	mov    %r12d,%edi
  402256:	e8 75 ea ff ff       	callq  400cd0 <write@plt>
  40225b:	48 85 c0             	test   %rax,%rax
  40225e:	7f e2                	jg     402242 <rio_writen+0x18>
  402260:	e8 1b ea ff ff       	callq  400c80 <__errno_location@plt>
  402265:	83 38 04             	cmpl   $0x4,(%rax)
  402268:	75 15                	jne    40227f <rio_writen+0x55>
  40226a:	b8 00 00 00 00       	mov    $0x0,%eax
  40226f:	eb d1                	jmp    402242 <rio_writen+0x18>
  402271:	4c 89 e8             	mov    %r13,%rax
  402274:	48 83 c4 08          	add    $0x8,%rsp
  402278:	5b                   	pop    %rbx
  402279:	5d                   	pop    %rbp
  40227a:	41 5c                	pop    %r12
  40227c:	41 5d                	pop    %r13
  40227e:	c3                   	retq   
  40227f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  402286:	eb ec                	jmp    402274 <rio_writen+0x4a>

0000000000402288 <rio_read>:
  402288:	41 55                	push   %r13
  40228a:	41 54                	push   %r12
  40228c:	55                   	push   %rbp
  40228d:	53                   	push   %rbx
  40228e:	48 83 ec 08          	sub    $0x8,%rsp
  402292:	48 89 fb             	mov    %rdi,%rbx
  402295:	49 89 f5             	mov    %rsi,%r13
  402298:	49 89 d4             	mov    %rdx,%r12
  40229b:	eb 0a                	jmp    4022a7 <rio_read+0x1f>
  40229d:	e8 de e9 ff ff       	callq  400c80 <__errno_location@plt>
  4022a2:	83 38 04             	cmpl   $0x4,(%rax)
  4022a5:	75 5c                	jne    402303 <rio_read+0x7b>
  4022a7:	8b 6b 04             	mov    0x4(%rbx),%ebp
  4022aa:	85 ed                	test   %ebp,%ebp
  4022ac:	7f 24                	jg     4022d2 <rio_read+0x4a>
  4022ae:	48 8d 6b 10          	lea    0x10(%rbx),%rbp
  4022b2:	8b 3b                	mov    (%rbx),%edi
  return __read_alias (__fd, __buf, __nbytes);
  4022b4:	ba 00 20 00 00       	mov    $0x2000,%edx
  4022b9:	48 89 ee             	mov    %rbp,%rsi
  4022bc:	e8 6f ea ff ff       	callq  400d30 <read@plt>
  4022c1:	89 43 04             	mov    %eax,0x4(%rbx)
  4022c4:	85 c0                	test   %eax,%eax
  4022c6:	78 d5                	js     40229d <rio_read+0x15>
  4022c8:	85 c0                	test   %eax,%eax
  4022ca:	74 40                	je     40230c <rio_read+0x84>
  4022cc:	48 89 6b 08          	mov    %rbp,0x8(%rbx)
  4022d0:	eb d5                	jmp    4022a7 <rio_read+0x1f>
  4022d2:	89 e8                	mov    %ebp,%eax
  4022d4:	4c 39 e0             	cmp    %r12,%rax
  4022d7:	72 03                	jb     4022dc <rio_read+0x54>
  4022d9:	44 89 e5             	mov    %r12d,%ebp
  4022dc:	4c 63 e5             	movslq %ebp,%r12
  4022df:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
  4022e3:	4c 89 e2             	mov    %r12,%rdx
  4022e6:	4c 89 ef             	mov    %r13,%rdi
  4022e9:	e8 92 ea ff ff       	callq  400d80 <memcpy@plt>
  4022ee:	4c 01 63 08          	add    %r12,0x8(%rbx)
  4022f2:	29 6b 04             	sub    %ebp,0x4(%rbx)
  4022f5:	4c 89 e0             	mov    %r12,%rax
  4022f8:	48 83 c4 08          	add    $0x8,%rsp
  4022fc:	5b                   	pop    %rbx
  4022fd:	5d                   	pop    %rbp
  4022fe:	41 5c                	pop    %r12
  402300:	41 5d                	pop    %r13
  402302:	c3                   	retq   
  402303:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  40230a:	eb ec                	jmp    4022f8 <rio_read+0x70>
  40230c:	b8 00 00 00 00       	mov    $0x0,%eax
  402311:	eb e5                	jmp    4022f8 <rio_read+0x70>

0000000000402313 <rio_readlineb>:
  402313:	41 55                	push   %r13
  402315:	41 54                	push   %r12
  402317:	55                   	push   %rbp
  402318:	53                   	push   %rbx
  402319:	48 83 ec 18          	sub    $0x18,%rsp
  40231d:	49 89 fd             	mov    %rdi,%r13
  402320:	48 89 f5             	mov    %rsi,%rbp
  402323:	49 89 d4             	mov    %rdx,%r12
  402326:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  40232d:	00 00 
  40232f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  402334:	31 c0                	xor    %eax,%eax
  402336:	bb 01 00 00 00       	mov    $0x1,%ebx
  40233b:	4c 39 e3             	cmp    %r12,%rbx
  40233e:	73 47                	jae    402387 <rio_readlineb+0x74>
  402340:	48 8d 74 24 07       	lea    0x7(%rsp),%rsi
  402345:	ba 01 00 00 00       	mov    $0x1,%edx
  40234a:	4c 89 ef             	mov    %r13,%rdi
  40234d:	e8 36 ff ff ff       	callq  402288 <rio_read>
  402352:	83 f8 01             	cmp    $0x1,%eax
  402355:	75 1c                	jne    402373 <rio_readlineb+0x60>
  402357:	48 8d 45 01          	lea    0x1(%rbp),%rax
  40235b:	0f b6 54 24 07       	movzbl 0x7(%rsp),%edx
  402360:	88 55 00             	mov    %dl,0x0(%rbp)
  402363:	80 7c 24 07 0a       	cmpb   $0xa,0x7(%rsp)
  402368:	74 1a                	je     402384 <rio_readlineb+0x71>
  40236a:	48 83 c3 01          	add    $0x1,%rbx
  40236e:	48 89 c5             	mov    %rax,%rbp
  402371:	eb c8                	jmp    40233b <rio_readlineb+0x28>
  402373:	85 c0                	test   %eax,%eax
  402375:	75 32                	jne    4023a9 <rio_readlineb+0x96>
  402377:	48 83 fb 01          	cmp    $0x1,%rbx
  40237b:	75 0a                	jne    402387 <rio_readlineb+0x74>
  40237d:	b8 00 00 00 00       	mov    $0x0,%eax
  402382:	eb 0a                	jmp    40238e <rio_readlineb+0x7b>
  402384:	48 89 c5             	mov    %rax,%rbp
  402387:	c6 45 00 00          	movb   $0x0,0x0(%rbp)
  40238b:	48 89 d8             	mov    %rbx,%rax
  40238e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  402393:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
  40239a:	00 00 
  40239c:	75 14                	jne    4023b2 <rio_readlineb+0x9f>
  40239e:	48 83 c4 18          	add    $0x18,%rsp
  4023a2:	5b                   	pop    %rbx
  4023a3:	5d                   	pop    %rbp
  4023a4:	41 5c                	pop    %r12
  4023a6:	41 5d                	pop    %r13
  4023a8:	c3                   	retq   
  4023a9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  4023b0:	eb dc                	jmp    40238e <rio_readlineb+0x7b>
  4023b2:	e8 29 e9 ff ff       	callq  400ce0 <__stack_chk_fail@plt>

00000000004023b7 <urlencode>:
  4023b7:	41 54                	push   %r12
  4023b9:	55                   	push   %rbp
  4023ba:	53                   	push   %rbx
  4023bb:	48 83 ec 10          	sub    $0x10,%rsp
  4023bf:	48 89 fb             	mov    %rdi,%rbx
  4023c2:	48 89 f5             	mov    %rsi,%rbp
  4023c5:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  4023cc:	00 00 
  4023ce:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4023d3:	31 c0                	xor    %eax,%eax
  4023d5:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  4023dc:	f2 ae                	repnz scas %es:(%rdi),%al
  4023de:	48 89 ce             	mov    %rcx,%rsi
  4023e1:	48 f7 d6             	not    %rsi
  4023e4:	8d 46 ff             	lea    -0x1(%rsi),%eax
  4023e7:	eb 0f                	jmp    4023f8 <urlencode+0x41>
  4023e9:	44 88 45 00          	mov    %r8b,0x0(%rbp)
  4023ed:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
  4023f1:	48 83 c3 01          	add    $0x1,%rbx
  4023f5:	44 89 e0             	mov    %r12d,%eax
  4023f8:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  4023fc:	85 c0                	test   %eax,%eax
  4023fe:	0f 84 a8 00 00 00    	je     4024ac <urlencode+0xf5>
  402404:	44 0f b6 03          	movzbl (%rbx),%r8d
  402408:	41 80 f8 2a          	cmp    $0x2a,%r8b
  40240c:	0f 94 c2             	sete   %dl
  40240f:	41 80 f8 2d          	cmp    $0x2d,%r8b
  402413:	0f 94 c0             	sete   %al
  402416:	08 c2                	or     %al,%dl
  402418:	75 cf                	jne    4023e9 <urlencode+0x32>
  40241a:	41 80 f8 2e          	cmp    $0x2e,%r8b
  40241e:	74 c9                	je     4023e9 <urlencode+0x32>
  402420:	41 80 f8 5f          	cmp    $0x5f,%r8b
  402424:	74 c3                	je     4023e9 <urlencode+0x32>
  402426:	41 8d 40 d0          	lea    -0x30(%r8),%eax
  40242a:	3c 09                	cmp    $0x9,%al
  40242c:	76 bb                	jbe    4023e9 <urlencode+0x32>
  40242e:	41 8d 40 bf          	lea    -0x41(%r8),%eax
  402432:	3c 19                	cmp    $0x19,%al
  402434:	76 b3                	jbe    4023e9 <urlencode+0x32>
  402436:	41 8d 40 9f          	lea    -0x61(%r8),%eax
  40243a:	3c 19                	cmp    $0x19,%al
  40243c:	76 ab                	jbe    4023e9 <urlencode+0x32>
  40243e:	41 80 f8 20          	cmp    $0x20,%r8b
  402442:	74 56                	je     40249a <urlencode+0xe3>
  402444:	41 8d 40 e0          	lea    -0x20(%r8),%eax
  402448:	3c 5f                	cmp    $0x5f,%al
  40244a:	0f 96 c2             	setbe  %dl
  40244d:	41 80 f8 09          	cmp    $0x9,%r8b
  402451:	0f 94 c0             	sete   %al
  402454:	08 c2                	or     %al,%dl
  402456:	74 4f                	je     4024a7 <urlencode+0xf0>
  return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
  402458:	48 89 e7             	mov    %rsp,%rdi
  40245b:	45 0f b6 c0          	movzbl %r8b,%r8d
  40245f:	48 8d 0d 22 13 00 00 	lea    0x1322(%rip),%rcx        # 403788 <trans_char+0xa8>
  402466:	ba 08 00 00 00       	mov    $0x8,%edx
  40246b:	be 01 00 00 00       	mov    $0x1,%esi
  402470:	b8 00 00 00 00       	mov    $0x0,%eax
  402475:	e8 e6 e9 ff ff       	callq  400e60 <__sprintf_chk@plt>
  40247a:	0f b6 04 24          	movzbl (%rsp),%eax
  40247e:	88 45 00             	mov    %al,0x0(%rbp)
  402481:	0f b6 44 24 01       	movzbl 0x1(%rsp),%eax
  402486:	88 45 01             	mov    %al,0x1(%rbp)
  402489:	0f b6 44 24 02       	movzbl 0x2(%rsp),%eax
  40248e:	88 45 02             	mov    %al,0x2(%rbp)
  402491:	48 8d 6d 03          	lea    0x3(%rbp),%rbp
  402495:	e9 57 ff ff ff       	jmpq   4023f1 <urlencode+0x3a>
  40249a:	c6 45 00 2b          	movb   $0x2b,0x0(%rbp)
  40249e:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
  4024a2:	e9 4a ff ff ff       	jmpq   4023f1 <urlencode+0x3a>
  4024a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4024ac:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  4024b1:	64 48 33 34 25 28 00 	xor    %fs:0x28,%rsi
  4024b8:	00 00 
  4024ba:	75 09                	jne    4024c5 <urlencode+0x10e>
  4024bc:	48 83 c4 10          	add    $0x10,%rsp
  4024c0:	5b                   	pop    %rbx
  4024c1:	5d                   	pop    %rbp
  4024c2:	41 5c                	pop    %r12
  4024c4:	c3                   	retq   
  4024c5:	e8 16 e8 ff ff       	callq  400ce0 <__stack_chk_fail@plt>

00000000004024ca <submitr>:
  4024ca:	41 57                	push   %r15
  4024cc:	41 56                	push   %r14
  4024ce:	41 55                	push   %r13
  4024d0:	41 54                	push   %r12
  4024d2:	55                   	push   %rbp
  4024d3:	53                   	push   %rbx
  4024d4:	48 81 ec 68 a0 00 00 	sub    $0xa068,%rsp
  4024db:	49 89 fd             	mov    %rdi,%r13
  4024de:	89 74 24 14          	mov    %esi,0x14(%rsp)
  4024e2:	49 89 d7             	mov    %rdx,%r15
  4024e5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  4024ea:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  4024ef:	4d 89 ce             	mov    %r9,%r14
  4024f2:	48 8b ac 24 a0 a0 00 	mov    0xa0a0(%rsp),%rbp
  4024f9:	00 
  4024fa:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  402501:	00 00 
  402503:	48 89 84 24 58 a0 00 	mov    %rax,0xa058(%rsp)
  40250a:	00 
  40250b:	31 c0                	xor    %eax,%eax
  40250d:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%rsp)
  402514:	00 
  402515:	ba 00 00 00 00       	mov    $0x0,%edx
  40251a:	be 01 00 00 00       	mov    $0x1,%esi
  40251f:	bf 02 00 00 00       	mov    $0x2,%edi
  402524:	e8 47 e9 ff ff       	callq  400e70 <socket@plt>
  402529:	85 c0                	test   %eax,%eax
  40252b:	0f 88 a9 02 00 00    	js     4027da <submitr+0x310>
  402531:	89 c3                	mov    %eax,%ebx
  402533:	4c 89 ef             	mov    %r13,%rdi
  402536:	e8 15 e8 ff ff       	callq  400d50 <gethostbyname@plt>
  40253b:	48 85 c0             	test   %rax,%rax
  40253e:	0f 84 e2 02 00 00    	je     402826 <submitr+0x35c>
}

__fortify_function void
__NTH (bzero (void *__dest, size_t __len))
{
  (void) __builtin___memset_chk (__dest, '\0', __len, __bos0 (__dest));
  402544:	4c 8d 64 24 30       	lea    0x30(%rsp),%r12
  402549:	48 c7 44 24 32 00 00 	movq   $0x0,0x32(%rsp)
  402550:	00 00 
  402552:	c7 44 24 3a 00 00 00 	movl   $0x0,0x3a(%rsp)
  402559:	00 
  40255a:	66 c7 44 24 3e 00 00 	movw   $0x0,0x3e(%rsp)
  402561:	66 c7 44 24 30 02 00 	movw   $0x2,0x30(%rsp)
  402568:	48 63 50 14          	movslq 0x14(%rax),%rdx
  40256c:	48 8b 40 18          	mov    0x18(%rax),%rax
  402570:	48 8b 30             	mov    (%rax),%rsi
  (void) __builtin___memmove_chk (__dest, __src, __len, __bos0 (__dest));
  402573:	48 8d 7c 24 34       	lea    0x34(%rsp),%rdi
  402578:	b9 0c 00 00 00       	mov    $0xc,%ecx
  40257d:	e8 de e7 ff ff       	callq  400d60 <__memmove_chk@plt>
  402582:	0f b7 44 24 14       	movzwl 0x14(%rsp),%eax
  402587:	66 c1 c8 08          	ror    $0x8,%ax
  40258b:	66 89 44 24 32       	mov    %ax,0x32(%rsp)
  402590:	ba 10 00 00 00       	mov    $0x10,%edx
  402595:	4c 89 e6             	mov    %r12,%rsi
  402598:	89 df                	mov    %ebx,%edi
  40259a:	e8 a1 e8 ff ff       	callq  400e40 <connect@plt>
  40259f:	85 c0                	test   %eax,%eax
  4025a1:	0f 88 e7 02 00 00    	js     40288e <submitr+0x3c4>
  4025a7:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  4025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  4025b3:	48 89 f1             	mov    %rsi,%rcx
  4025b6:	4c 89 f7             	mov    %r14,%rdi
  4025b9:	f2 ae                	repnz scas %es:(%rdi),%al
  4025bb:	48 89 ca             	mov    %rcx,%rdx
  4025be:	48 f7 d2             	not    %rdx
  4025c1:	48 89 f1             	mov    %rsi,%rcx
  4025c4:	4c 89 ff             	mov    %r15,%rdi
  4025c7:	f2 ae                	repnz scas %es:(%rdi),%al
  4025c9:	48 f7 d1             	not    %rcx
  4025cc:	49 89 c8             	mov    %rcx,%r8
  4025cf:	48 89 f1             	mov    %rsi,%rcx
  4025d2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  4025d7:	f2 ae                	repnz scas %es:(%rdi),%al
  4025d9:	48 f7 d1             	not    %rcx
  4025dc:	4d 8d 44 08 fe       	lea    -0x2(%r8,%rcx,1),%r8
  4025e1:	48 89 f1             	mov    %rsi,%rcx
  4025e4:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  4025e9:	f2 ae                	repnz scas %es:(%rdi),%al
  4025eb:	48 89 c8             	mov    %rcx,%rax
  4025ee:	48 f7 d0             	not    %rax
  4025f1:	49 8d 4c 00 ff       	lea    -0x1(%r8,%rax,1),%rcx
  4025f6:	48 8d 44 52 fd       	lea    -0x3(%rdx,%rdx,2),%rax
  4025fb:	48 8d 84 01 80 00 00 	lea    0x80(%rcx,%rax,1),%rax
  402602:	00 
  402603:	48 3d 00 20 00 00    	cmp    $0x2000,%rax
  402609:	0f 87 d9 02 00 00    	ja     4028e8 <submitr+0x41e>
  (void) __builtin___memset_chk (__dest, '\0', __len, __bos0 (__dest));
  40260f:	48 8d b4 24 50 40 00 	lea    0x4050(%rsp),%rsi
  402616:	00 
  402617:	b9 00 04 00 00       	mov    $0x400,%ecx
  40261c:	b8 00 00 00 00       	mov    $0x0,%eax
  402621:	48 89 f7             	mov    %rsi,%rdi
  402624:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  402627:	4c 89 f7             	mov    %r14,%rdi
  40262a:	e8 88 fd ff ff       	callq  4023b7 <urlencode>
  40262f:	85 c0                	test   %eax,%eax
  402631:	0f 88 24 03 00 00    	js     40295b <submitr+0x491>
  402637:	4c 8d a4 24 50 20 00 	lea    0x2050(%rsp),%r12
  40263e:	00 
  40263f:	41 55                	push   %r13
  402641:	48 8d 84 24 58 40 00 	lea    0x4058(%rsp),%rax
  402648:	00 
  402649:	50                   	push   %rax
  40264a:	4d 89 f9             	mov    %r15,%r9
  40264d:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  402652:	48 8d 0d bf 10 00 00 	lea    0x10bf(%rip),%rcx        # 403718 <trans_char+0x38>
  402659:	ba 00 20 00 00       	mov    $0x2000,%edx
  40265e:	be 01 00 00 00       	mov    $0x1,%esi
  402663:	4c 89 e7             	mov    %r12,%rdi
  402666:	b8 00 00 00 00       	mov    $0x0,%eax
  40266b:	e8 f0 e7 ff ff       	callq  400e60 <__sprintf_chk@plt>
  402670:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  402677:	b8 00 00 00 00       	mov    $0x0,%eax
  40267c:	4c 89 e7             	mov    %r12,%rdi
  40267f:	f2 ae                	repnz scas %es:(%rdi),%al
  402681:	48 89 ca             	mov    %rcx,%rdx
  402684:	48 f7 d2             	not    %rdx
  402687:	48 8d 52 ff          	lea    -0x1(%rdx),%rdx
  40268b:	4c 89 e6             	mov    %r12,%rsi
  40268e:	89 df                	mov    %ebx,%edi
  402690:	e8 95 fb ff ff       	callq  40222a <rio_writen>
  402695:	48 83 c4 10          	add    $0x10,%rsp
  402699:	48 85 c0             	test   %rax,%rax
  40269c:	0f 88 44 03 00 00    	js     4029e6 <submitr+0x51c>
  4026a2:	4c 8d 64 24 40       	lea    0x40(%rsp),%r12
  4026a7:	89 de                	mov    %ebx,%esi
  4026a9:	4c 89 e7             	mov    %r12,%rdi
  4026ac:	e8 37 fb ff ff       	callq  4021e8 <rio_readinitb>
  4026b1:	48 8d b4 24 50 20 00 	lea    0x2050(%rsp),%rsi
  4026b8:	00 
  4026b9:	ba 00 20 00 00       	mov    $0x2000,%edx
  4026be:	4c 89 e7             	mov    %r12,%rdi
  4026c1:	e8 4d fc ff ff       	callq  402313 <rio_readlineb>
  4026c6:	48 85 c0             	test   %rax,%rax
  4026c9:	0f 8e 86 03 00 00    	jle    402a55 <submitr+0x58b>
  4026cf:	48 8d 4c 24 2c       	lea    0x2c(%rsp),%rcx
  4026d4:	48 8d 94 24 50 60 00 	lea    0x6050(%rsp),%rdx
  4026db:	00 
  4026dc:	48 8d bc 24 50 20 00 	lea    0x2050(%rsp),%rdi
  4026e3:	00 
  4026e4:	4c 8d 84 24 50 80 00 	lea    0x8050(%rsp),%r8
  4026eb:	00 
  4026ec:	48 8d 35 9c 10 00 00 	lea    0x109c(%rip),%rsi        # 40378f <trans_char+0xaf>
  4026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  4026f8:	e8 c3 e6 ff ff       	callq  400dc0 <__isoc99_sscanf@plt>
  4026fd:	48 8d b4 24 50 20 00 	lea    0x2050(%rsp),%rsi
  402704:	00 
  402705:	b9 03 00 00 00       	mov    $0x3,%ecx
  40270a:	48 8d 3d 95 10 00 00 	lea    0x1095(%rip),%rdi        # 4037a6 <trans_char+0xc6>
  402711:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  402713:	0f 97 c0             	seta   %al
  402716:	1c 00                	sbb    $0x0,%al
  402718:	84 c0                	test   %al,%al
  40271a:	0f 84 b3 03 00 00    	je     402ad3 <submitr+0x609>
  402720:	48 8d b4 24 50 20 00 	lea    0x2050(%rsp),%rsi
  402727:	00 
  402728:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  40272d:	ba 00 20 00 00       	mov    $0x2000,%edx
  402732:	e8 dc fb ff ff       	callq  402313 <rio_readlineb>
  402737:	48 85 c0             	test   %rax,%rax
  40273a:	7f c1                	jg     4026fd <submitr+0x233>
#endif

__fortify_function char *
__NTH (strcpy (char *__restrict __dest, const char *__restrict __src))
{
  return __builtin___strcpy_chk (__dest, __src, __bos (__dest));
  40273c:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402743:	3a 20 43 
  402746:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
  40274d:	20 75 6e 
  402750:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402754:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402758:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  40275f:	74 6f 20 
  402762:	48 ba 72 65 61 64 20 	movabs $0x6165682064616572,%rdx
  402769:	68 65 61 
  40276c:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402770:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402774:	48 b8 64 65 72 73 20 	movabs $0x6f72662073726564,%rax
  40277b:	66 72 6f 
  40277e:	48 ba 6d 20 74 68 65 	movabs $0x657220656874206d,%rdx
  402785:	20 72 65 
  402788:	48 89 45 20          	mov    %rax,0x20(%rbp)
  40278c:	48 89 55 28          	mov    %rdx,0x28(%rbp)
  402790:	48 b8 73 75 6c 74 20 	movabs $0x72657320746c7573,%rax
  402797:	73 65 72 
  40279a:	48 89 45 30          	mov    %rax,0x30(%rbp)
  40279e:	c7 45 38 76 65 72 00 	movl   $0x726576,0x38(%rbp)
  4027a5:	89 df                	mov    %ebx,%edi
  4027a7:	e8 74 e5 ff ff       	callq  400d20 <close@plt>
  4027ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4027b1:	48 8b 9c 24 58 a0 00 	mov    0xa058(%rsp),%rbx
  4027b8:	00 
  4027b9:	64 48 33 1c 25 28 00 	xor    %fs:0x28,%rbx
  4027c0:	00 00 
  4027c2:	0f 85 7e 04 00 00    	jne    402c46 <submitr+0x77c>
  4027c8:	48 81 c4 68 a0 00 00 	add    $0xa068,%rsp
  4027cf:	5b                   	pop    %rbx
  4027d0:	5d                   	pop    %rbp
  4027d1:	41 5c                	pop    %r12
  4027d3:	41 5d                	pop    %r13
  4027d5:	41 5e                	pop    %r14
  4027d7:	41 5f                	pop    %r15
  4027d9:	c3                   	retq   
  4027da:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  4027e1:	3a 20 43 
  4027e4:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
  4027eb:	20 75 6e 
  4027ee:	48 89 45 00          	mov    %rax,0x0(%rbp)
  4027f2:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  4027f6:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  4027fd:	74 6f 20 
  402800:	48 ba 63 72 65 61 74 	movabs $0x7320657461657263,%rdx
  402807:	65 20 73 
  40280a:	48 89 45 10          	mov    %rax,0x10(%rbp)
  40280e:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402812:	c7 45 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%rbp)
  402819:	66 c7 45 24 74 00    	movw   $0x74,0x24(%rbp)
  40281f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402824:	eb 8b                	jmp    4027b1 <submitr+0x2e7>
  402826:	48 b8 45 72 72 6f 72 	movabs $0x44203a726f727245,%rax
  40282d:	3a 20 44 
  402830:	48 ba 4e 53 20 69 73 	movabs $0x6e7520736920534e,%rdx
  402837:	20 75 6e 
  40283a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  40283e:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402842:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402849:	74 6f 20 
  40284c:	48 ba 72 65 73 6f 6c 	movabs $0x2065766c6f736572,%rdx
  402853:	76 65 20 
  402856:	48 89 45 10          	mov    %rax,0x10(%rbp)
  40285a:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  40285e:	48 b8 73 65 72 76 65 	movabs $0x6120726576726573,%rax
  402865:	72 20 61 
  402868:	48 89 45 20          	mov    %rax,0x20(%rbp)
  40286c:	c7 45 28 64 64 72 65 	movl   $0x65726464,0x28(%rbp)
  402873:	66 c7 45 2c 73 73    	movw   $0x7373,0x2c(%rbp)
  402879:	c6 45 2e 00          	movb   $0x0,0x2e(%rbp)
  40287d:	89 df                	mov    %ebx,%edi
  40287f:	e8 9c e4 ff ff       	callq  400d20 <close@plt>
  402884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402889:	e9 23 ff ff ff       	jmpq   4027b1 <submitr+0x2e7>
  40288e:	48 b8 45 72 72 6f 72 	movabs $0x55203a726f727245,%rax
  402895:	3a 20 55 
  402898:	48 ba 6e 61 62 6c 65 	movabs $0x6f7420656c62616e,%rdx
  40289f:	20 74 6f 
  4028a2:	48 89 45 00          	mov    %rax,0x0(%rbp)
  4028a6:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  4028aa:	48 b8 20 63 6f 6e 6e 	movabs $0x7463656e6e6f6320,%rax
  4028b1:	65 63 74 
  4028b4:	48 ba 20 74 6f 20 74 	movabs $0x20656874206f7420,%rdx
  4028bb:	68 65 20 
  4028be:	48 89 45 10          	mov    %rax,0x10(%rbp)
  4028c2:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  4028c6:	c7 45 20 73 65 72 76 	movl   $0x76726573,0x20(%rbp)
  4028cd:	66 c7 45 24 65 72    	movw   $0x7265,0x24(%rbp)
  4028d3:	c6 45 26 00          	movb   $0x0,0x26(%rbp)
  4028d7:	89 df                	mov    %ebx,%edi
  4028d9:	e8 42 e4 ff ff       	callq  400d20 <close@plt>
  4028de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4028e3:	e9 c9 fe ff ff       	jmpq   4027b1 <submitr+0x2e7>
  4028e8:	48 b8 45 72 72 6f 72 	movabs $0x52203a726f727245,%rax
  4028ef:	3a 20 52 
  4028f2:	48 ba 65 73 75 6c 74 	movabs $0x747320746c757365,%rdx
  4028f9:	20 73 74 
  4028fc:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402900:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402904:	48 b8 72 69 6e 67 20 	movabs $0x6f6f7420676e6972,%rax
  40290b:	74 6f 6f 
  40290e:	48 ba 20 6c 61 72 67 	movabs $0x202e656772616c20,%rdx
  402915:	65 2e 20 
  402918:	48 89 45 10          	mov    %rax,0x10(%rbp)
  40291c:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402920:	48 b8 49 6e 63 72 65 	movabs $0x6573616572636e49,%rax
  402927:	61 73 65 
  40292a:	48 ba 20 53 55 42 4d 	movabs $0x5254494d42555320,%rdx
  402931:	49 54 52 
  402934:	48 89 45 20          	mov    %rax,0x20(%rbp)
  402938:	48 89 55 28          	mov    %rdx,0x28(%rbp)
  40293c:	48 b8 5f 4d 41 58 42 	movabs $0x46554258414d5f,%rax
  402943:	55 46 00 
  402946:	48 89 45 30          	mov    %rax,0x30(%rbp)
  40294a:	89 df                	mov    %ebx,%edi
  40294c:	e8 cf e3 ff ff       	callq  400d20 <close@plt>
  402951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402956:	e9 56 fe ff ff       	jmpq   4027b1 <submitr+0x2e7>
  40295b:	48 b8 45 72 72 6f 72 	movabs $0x52203a726f727245,%rax
  402962:	3a 20 52 
  402965:	48 ba 65 73 75 6c 74 	movabs $0x747320746c757365,%rdx
  40296c:	20 73 74 
  40296f:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402973:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402977:	48 b8 72 69 6e 67 20 	movabs $0x6e6f6320676e6972,%rax
  40297e:	63 6f 6e 
  402981:	48 ba 74 61 69 6e 73 	movabs $0x6e6120736e696174,%rdx
  402988:	20 61 6e 
  40298b:	48 89 45 10          	mov    %rax,0x10(%rbp)
  40298f:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402993:	48 b8 20 69 6c 6c 65 	movabs $0x6c6167656c6c6920,%rax
  40299a:	67 61 6c 
  40299d:	48 ba 20 6f 72 20 75 	movabs $0x72706e7520726f20,%rdx
  4029a4:	6e 70 72 
  4029a7:	48 89 45 20          	mov    %rax,0x20(%rbp)
  4029ab:	48 89 55 28          	mov    %rdx,0x28(%rbp)
  4029af:	48 b8 69 6e 74 61 62 	movabs $0x20656c6261746e69,%rax
  4029b6:	6c 65 20 
  4029b9:	48 ba 63 68 61 72 61 	movabs $0x6574636172616863,%rdx
  4029c0:	63 74 65 
  4029c3:	48 89 45 30          	mov    %rax,0x30(%rbp)
  4029c7:	48 89 55 38          	mov    %rdx,0x38(%rbp)
  4029cb:	66 c7 45 40 72 2e    	movw   $0x2e72,0x40(%rbp)
  4029d1:	c6 45 42 00          	movb   $0x0,0x42(%rbp)
  4029d5:	89 df                	mov    %ebx,%edi
  4029d7:	e8 44 e3 ff ff       	callq  400d20 <close@plt>
  4029dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4029e1:	e9 cb fd ff ff       	jmpq   4027b1 <submitr+0x2e7>
  4029e6:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  4029ed:	3a 20 43 
  4029f0:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
  4029f7:	20 75 6e 
  4029fa:	48 89 45 00          	mov    %rax,0x0(%rbp)
  4029fe:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402a02:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402a09:	74 6f 20 
  402a0c:	48 ba 77 72 69 74 65 	movabs $0x6f74206574697277,%rdx
  402a13:	20 74 6f 
  402a16:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402a1a:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402a1e:	48 b8 20 74 68 65 20 	movabs $0x7365722065687420,%rax
  402a25:	72 65 73 
  402a28:	48 ba 75 6c 74 20 73 	movabs $0x7672657320746c75,%rdx
  402a2f:	65 72 76 
  402a32:	48 89 45 20          	mov    %rax,0x20(%rbp)
  402a36:	48 89 55 28          	mov    %rdx,0x28(%rbp)
  402a3a:	66 c7 45 30 65 72    	movw   $0x7265,0x30(%rbp)
  402a40:	c6 45 32 00          	movb   $0x0,0x32(%rbp)
  402a44:	89 df                	mov    %ebx,%edi
  402a46:	e8 d5 e2 ff ff       	callq  400d20 <close@plt>
  402a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402a50:	e9 5c fd ff ff       	jmpq   4027b1 <submitr+0x2e7>
  402a55:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402a5c:	3a 20 43 
  402a5f:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
  402a66:	20 75 6e 
  402a69:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402a6d:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402a71:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402a78:	74 6f 20 
  402a7b:	48 ba 72 65 61 64 20 	movabs $0x7269662064616572,%rdx
  402a82:	66 69 72 
  402a85:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402a89:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402a8d:	48 b8 73 74 20 68 65 	movabs $0x6564616568207473,%rax
  402a94:	61 64 65 
  402a97:	48 ba 72 20 66 72 6f 	movabs $0x72206d6f72662072,%rdx
  402a9e:	6d 20 72 
  402aa1:	48 89 45 20          	mov    %rax,0x20(%rbp)
  402aa5:	48 89 55 28          	mov    %rdx,0x28(%rbp)
  402aa9:	48 b8 65 73 75 6c 74 	movabs $0x657320746c757365,%rax
  402ab0:	20 73 65 
  402ab3:	48 89 45 30          	mov    %rax,0x30(%rbp)
  402ab7:	c7 45 38 72 76 65 72 	movl   $0x72657672,0x38(%rbp)
  402abe:	c6 45 3c 00          	movb   $0x0,0x3c(%rbp)
  402ac2:	89 df                	mov    %ebx,%edi
  402ac4:	e8 57 e2 ff ff       	callq  400d20 <close@plt>
  402ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402ace:	e9 de fc ff ff       	jmpq   4027b1 <submitr+0x2e7>
  402ad3:	48 8d b4 24 50 20 00 	lea    0x2050(%rsp),%rsi
  402ada:	00 
  402adb:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  402ae0:	ba 00 20 00 00       	mov    $0x2000,%edx
  402ae5:	e8 29 f8 ff ff       	callq  402313 <rio_readlineb>
  402aea:	48 85 c0             	test   %rax,%rax
  402aed:	0f 8e 96 00 00 00    	jle    402b89 <submitr+0x6bf>
  402af3:	44 8b 44 24 2c       	mov    0x2c(%rsp),%r8d
  402af8:	41 81 f8 c8 00 00 00 	cmp    $0xc8,%r8d
  402aff:	0f 85 08 01 00 00    	jne    402c0d <submitr+0x743>
  402b05:	48 8d b4 24 50 20 00 	lea    0x2050(%rsp),%rsi
  402b0c:	00 
  402b0d:	48 89 ef             	mov    %rbp,%rdi
  402b10:	e8 9b e1 ff ff       	callq  400cb0 <strcpy@plt>
  402b15:	89 df                	mov    %ebx,%edi
  402b17:	e8 04 e2 ff ff       	callq  400d20 <close@plt>
  402b1c:	b9 04 00 00 00       	mov    $0x4,%ecx
  402b21:	48 8d 3d 78 0c 00 00 	lea    0xc78(%rip),%rdi        # 4037a0 <trans_char+0xc0>
  402b28:	48 89 ee             	mov    %rbp,%rsi
  402b2b:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  402b2d:	0f 97 c0             	seta   %al
  402b30:	1c 00                	sbb    $0x0,%al
  402b32:	0f be c0             	movsbl %al,%eax
  402b35:	85 c0                	test   %eax,%eax
  402b37:	0f 84 74 fc ff ff    	je     4027b1 <submitr+0x2e7>
  402b3d:	b9 05 00 00 00       	mov    $0x5,%ecx
  402b42:	48 8d 3d 5b 0c 00 00 	lea    0xc5b(%rip),%rdi        # 4037a4 <trans_char+0xc4>
  402b49:	48 89 ee             	mov    %rbp,%rsi
  402b4c:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  402b4e:	0f 97 c0             	seta   %al
  402b51:	1c 00                	sbb    $0x0,%al
  402b53:	0f be c0             	movsbl %al,%eax
  402b56:	85 c0                	test   %eax,%eax
  402b58:	0f 84 53 fc ff ff    	je     4027b1 <submitr+0x2e7>
  402b5e:	b9 03 00 00 00       	mov    $0x3,%ecx
  402b63:	48 8d 3d 3f 0c 00 00 	lea    0xc3f(%rip),%rdi        # 4037a9 <trans_char+0xc9>
  402b6a:	48 89 ee             	mov    %rbp,%rsi
  402b6d:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  402b6f:	0f 97 c0             	seta   %al
  402b72:	1c 00                	sbb    $0x0,%al
  402b74:	0f be c0             	movsbl %al,%eax
  402b77:	85 c0                	test   %eax,%eax
  402b79:	0f 84 32 fc ff ff    	je     4027b1 <submitr+0x2e7>
  402b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402b84:	e9 28 fc ff ff       	jmpq   4027b1 <submitr+0x2e7>
  402b89:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402b90:	3a 20 43 
  402b93:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
  402b9a:	20 75 6e 
  402b9d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  402ba1:	48 89 55 08          	mov    %rdx,0x8(%rbp)
  402ba5:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402bac:	74 6f 20 
  402baf:	48 ba 72 65 61 64 20 	movabs $0x6174732064616572,%rdx
  402bb6:	73 74 61 
  402bb9:	48 89 45 10          	mov    %rax,0x10(%rbp)
  402bbd:	48 89 55 18          	mov    %rdx,0x18(%rbp)
  402bc1:	48 b8 74 75 73 20 6d 	movabs $0x7373656d20737574,%rax
  402bc8:	65 73 73 
  402bcb:	48 ba 61 67 65 20 66 	movabs $0x6d6f726620656761,%rdx
  402bd2:	72 6f 6d 
  402bd5:	48 89 45 20          	mov    %rax,0x20(%rbp)
  402bd9:	48 89 55 28          	mov    %rdx,0x28(%rbp)
  402bdd:	48 b8 20 72 65 73 75 	movabs $0x20746c7573657220,%rax
  402be4:	6c 74 20 
  402be7:	48 89 45 30          	mov    %rax,0x30(%rbp)
  402beb:	c7 45 38 73 65 72 76 	movl   $0x76726573,0x38(%rbp)
  402bf2:	66 c7 45 3c 65 72    	movw   $0x7265,0x3c(%rbp)
  402bf8:	c6 45 3e 00          	movb   $0x0,0x3e(%rbp)
  402bfc:	89 df                	mov    %ebx,%edi
  402bfe:	e8 1d e1 ff ff       	callq  400d20 <close@plt>
  402c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402c08:	e9 a4 fb ff ff       	jmpq   4027b1 <submitr+0x2e7>
  402c0d:	4c 8d 8c 24 50 80 00 	lea    0x8050(%rsp),%r9
  402c14:	00 
  402c15:	48 8d 0d 3c 0b 00 00 	lea    0xb3c(%rip),%rcx        # 403758 <trans_char+0x78>
  402c1c:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  402c23:	be 01 00 00 00       	mov    $0x1,%esi
  402c28:	48 89 ef             	mov    %rbp,%rdi
  402c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  402c30:	e8 2b e2 ff ff       	callq  400e60 <__sprintf_chk@plt>
  402c35:	89 df                	mov    %ebx,%edi
  402c37:	e8 e4 e0 ff ff       	callq  400d20 <close@plt>
  402c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402c41:	e9 6b fb ff ff       	jmpq   4027b1 <submitr+0x2e7>
  402c46:	e8 95 e0 ff ff       	callq  400ce0 <__stack_chk_fail@plt>

0000000000402c4b <init_timeout>:
  402c4b:	85 ff                	test   %edi,%edi
  402c4d:	74 28                	je     402c77 <init_timeout+0x2c>
  402c4f:	53                   	push   %rbx
  402c50:	89 fb                	mov    %edi,%ebx
  402c52:	85 ff                	test   %edi,%edi
  402c54:	78 1a                	js     402c70 <init_timeout+0x25>
  402c56:	48 8d 35 9d f5 ff ff 	lea    -0xa63(%rip),%rsi        # 4021fa <sigalrm_handler>
  402c5d:	bf 0e 00 00 00       	mov    $0xe,%edi
  402c62:	e8 d9 e0 ff ff       	callq  400d40 <signal@plt>
  402c67:	89 df                	mov    %ebx,%edi
  402c69:	e8 a2 e0 ff ff       	callq  400d10 <alarm@plt>
  402c6e:	5b                   	pop    %rbx
  402c6f:	c3                   	retq   
  402c70:	bb 00 00 00 00       	mov    $0x0,%ebx
  402c75:	eb df                	jmp    402c56 <init_timeout+0xb>
  402c77:	f3 c3                	repz retq 

0000000000402c79 <init_driver>:
  402c79:	41 54                	push   %r12
  402c7b:	55                   	push   %rbp
  402c7c:	53                   	push   %rbx
  402c7d:	48 83 ec 20          	sub    $0x20,%rsp
  402c81:	49 89 fc             	mov    %rdi,%r12
  402c84:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  402c8b:	00 00 
  402c8d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  402c92:	31 c0                	xor    %eax,%eax
  402c94:	be 01 00 00 00       	mov    $0x1,%esi
  402c99:	bf 0d 00 00 00       	mov    $0xd,%edi
  402c9e:	e8 9d e0 ff ff       	callq  400d40 <signal@plt>
  402ca3:	be 01 00 00 00       	mov    $0x1,%esi
  402ca8:	bf 1d 00 00 00       	mov    $0x1d,%edi
  402cad:	e8 8e e0 ff ff       	callq  400d40 <signal@plt>
  402cb2:	be 01 00 00 00       	mov    $0x1,%esi
  402cb7:	bf 1d 00 00 00       	mov    $0x1d,%edi
  402cbc:	e8 7f e0 ff ff       	callq  400d40 <signal@plt>
  402cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  402cc6:	be 01 00 00 00       	mov    $0x1,%esi
  402ccb:	bf 02 00 00 00       	mov    $0x2,%edi
  402cd0:	e8 9b e1 ff ff       	callq  400e70 <socket@plt>
  402cd5:	85 c0                	test   %eax,%eax
  402cd7:	0f 88 a3 00 00 00    	js     402d80 <init_driver+0x107>
  402cdd:	89 c3                	mov    %eax,%ebx
  402cdf:	48 8d 3d c6 0a 00 00 	lea    0xac6(%rip),%rdi        # 4037ac <trans_char+0xcc>
  402ce6:	e8 65 e0 ff ff       	callq  400d50 <gethostbyname@plt>
  402ceb:	48 85 c0             	test   %rax,%rax
  402cee:	0f 84 df 00 00 00    	je     402dd3 <init_driver+0x15a>
  402cf4:	48 89 e5             	mov    %rsp,%rbp
  402cf7:	48 c7 44 24 02 00 00 	movq   $0x0,0x2(%rsp)
  402cfe:	00 00 
  402d00:	c7 45 0a 00 00 00 00 	movl   $0x0,0xa(%rbp)
  402d07:	66 c7 45 0e 00 00    	movw   $0x0,0xe(%rbp)
  402d0d:	66 c7 04 24 02 00    	movw   $0x2,(%rsp)
  402d13:	48 63 50 14          	movslq 0x14(%rax),%rdx
  402d17:	48 8b 40 18          	mov    0x18(%rax),%rax
  402d1b:	48 8b 30             	mov    (%rax),%rsi
  (void) __builtin___memmove_chk (__dest, __src, __len, __bos0 (__dest));
  402d1e:	48 8d 7d 04          	lea    0x4(%rbp),%rdi
  402d22:	b9 0c 00 00 00       	mov    $0xc,%ecx
  402d27:	e8 34 e0 ff ff       	callq  400d60 <__memmove_chk@plt>
  402d2c:	66 c7 44 24 02 3c 9a 	movw   $0x9a3c,0x2(%rsp)
  402d33:	ba 10 00 00 00       	mov    $0x10,%edx
  402d38:	48 89 ee             	mov    %rbp,%rsi
  402d3b:	89 df                	mov    %ebx,%edi
  402d3d:	e8 fe e0 ff ff       	callq  400e40 <connect@plt>
  402d42:	85 c0                	test   %eax,%eax
  402d44:	0f 88 fb 00 00 00    	js     402e45 <init_driver+0x1cc>
  402d4a:	89 df                	mov    %ebx,%edi
  402d4c:	e8 cf df ff ff       	callq  400d20 <close@plt>
  402d51:	66 41 c7 04 24 4f 4b 	movw   $0x4b4f,(%r12)
  402d58:	41 c6 44 24 02 00    	movb   $0x0,0x2(%r12)
  402d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  402d63:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  402d68:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
  402d6f:	00 00 
  402d71:	0f 85 28 01 00 00    	jne    402e9f <init_driver+0x226>
  402d77:	48 83 c4 20          	add    $0x20,%rsp
  402d7b:	5b                   	pop    %rbx
  402d7c:	5d                   	pop    %rbp
  402d7d:	41 5c                	pop    %r12
  402d7f:	c3                   	retq   
  402d80:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
  402d87:	3a 20 43 
  402d8a:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
  402d91:	20 75 6e 
  402d94:	49 89 04 24          	mov    %rax,(%r12)
  402d98:	49 89 54 24 08       	mov    %rdx,0x8(%r12)
  402d9d:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402da4:	74 6f 20 
  402da7:	48 ba 63 72 65 61 74 	movabs $0x7320657461657263,%rdx
  402dae:	65 20 73 
  402db1:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  402db6:	49 89 54 24 18       	mov    %rdx,0x18(%r12)
  402dbb:	41 c7 44 24 20 6f 63 	movl   $0x656b636f,0x20(%r12)
  402dc2:	6b 65 
  402dc4:	66 41 c7 44 24 24 74 	movw   $0x74,0x24(%r12)
  402dcb:	00 
  402dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402dd1:	eb 90                	jmp    402d63 <init_driver+0xea>
  402dd3:	48 b8 45 72 72 6f 72 	movabs $0x44203a726f727245,%rax
  402dda:	3a 20 44 
  402ddd:	48 ba 4e 53 20 69 73 	movabs $0x6e7520736920534e,%rdx
  402de4:	20 75 6e 
  402de7:	49 89 04 24          	mov    %rax,(%r12)
  402deb:	49 89 54 24 08       	mov    %rdx,0x8(%r12)
  402df0:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
  402df7:	74 6f 20 
  402dfa:	48 ba 72 65 73 6f 6c 	movabs $0x2065766c6f736572,%rdx
  402e01:	76 65 20 
  402e04:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  402e09:	49 89 54 24 18       	mov    %rdx,0x18(%r12)
  402e0e:	48 b8 73 65 72 76 65 	movabs $0x6120726576726573,%rax
  402e15:	72 20 61 
  402e18:	49 89 44 24 20       	mov    %rax,0x20(%r12)
  402e1d:	41 c7 44 24 28 64 64 	movl   $0x65726464,0x28(%r12)
  402e24:	72 65 
  402e26:	66 41 c7 44 24 2c 73 	movw   $0x7373,0x2c(%r12)
  402e2d:	73 
  402e2e:	41 c6 44 24 2e 00    	movb   $0x0,0x2e(%r12)
  402e34:	89 df                	mov    %ebx,%edi
  402e36:	e8 e5 de ff ff       	callq  400d20 <close@plt>
  402e3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402e40:	e9 1e ff ff ff       	jmpq   402d63 <init_driver+0xea>
  402e45:	48 b8 45 72 72 6f 72 	movabs $0x55203a726f727245,%rax
  402e4c:	3a 20 55 
  402e4f:	48 ba 6e 61 62 6c 65 	movabs $0x6f7420656c62616e,%rdx
  402e56:	20 74 6f 
  402e59:	49 89 04 24          	mov    %rax,(%r12)
  402e5d:	49 89 54 24 08       	mov    %rdx,0x8(%r12)
  402e62:	48 b8 20 63 6f 6e 6e 	movabs $0x7463656e6e6f6320,%rax
  402e69:	65 63 74 
  402e6c:	48 ba 20 74 6f 20 73 	movabs $0x76726573206f7420,%rdx
  402e73:	65 72 76 
  402e76:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  402e7b:	49 89 54 24 18       	mov    %rdx,0x18(%r12)
  402e80:	66 41 c7 44 24 20 65 	movw   $0x7265,0x20(%r12)
  402e87:	72 
  402e88:	41 c6 44 24 22 00    	movb   $0x0,0x22(%r12)
  402e8e:	89 df                	mov    %ebx,%edi
  402e90:	e8 8b de ff ff       	callq  400d20 <close@plt>
  402e95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402e9a:	e9 c4 fe ff ff       	jmpq   402d63 <init_driver+0xea>
  402e9f:	e8 3c de ff ff       	callq  400ce0 <__stack_chk_fail@plt>

0000000000402ea4 <driver_post>:
  402ea4:	53                   	push   %rbx
  402ea5:	4c 89 cb             	mov    %r9,%rbx
  402ea8:	45 85 c0             	test   %r8d,%r8d
  402eab:	75 18                	jne    402ec5 <driver_post+0x21>
  402ead:	48 85 ff             	test   %rdi,%rdi
  402eb0:	74 05                	je     402eb7 <driver_post+0x13>
  402eb2:	80 3f 00             	cmpb   $0x0,(%rdi)
  402eb5:	75 37                	jne    402eee <driver_post+0x4a>
  402eb7:	66 c7 03 4f 4b       	movw   $0x4b4f,(%rbx)
  402ebc:	c6 43 02 00          	movb   $0x0,0x2(%rbx)
  402ec0:	44 89 c0             	mov    %r8d,%eax
  402ec3:	5b                   	pop    %rbx
  402ec4:	c3                   	retq   
  return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
  402ec5:	48 89 ca             	mov    %rcx,%rdx
  402ec8:	48 8d 35 f5 08 00 00 	lea    0x8f5(%rip),%rsi        # 4037c4 <trans_char+0xe4>
  402ecf:	bf 01 00 00 00       	mov    $0x1,%edi
  402ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  402ed9:	e8 02 df ff ff       	callq  400de0 <__printf_chk@plt>
  402ede:	66 c7 03 4f 4b       	movw   $0x4b4f,(%rbx)
  402ee3:	c6 43 02 00          	movb   $0x0,0x2(%rbx)
  402ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  402eec:	eb d5                	jmp    402ec3 <driver_post+0x1f>
  402eee:	48 83 ec 08          	sub    $0x8,%rsp
  402ef2:	41 51                	push   %r9
  402ef4:	49 89 c9             	mov    %rcx,%r9
  402ef7:	49 89 d0             	mov    %rdx,%r8
  402efa:	48 89 f9             	mov    %rdi,%rcx
  402efd:	48 89 f2             	mov    %rsi,%rdx
  402f00:	be 9a 3c 00 00       	mov    $0x3c9a,%esi
  402f05:	48 8d 3d a0 08 00 00 	lea    0x8a0(%rip),%rdi        # 4037ac <trans_char+0xcc>
  402f0c:	e8 b9 f5 ff ff       	callq  4024ca <submitr>
  402f11:	48 83 c4 10          	add    $0x10,%rsp
  402f15:	eb ac                	jmp    402ec3 <driver_post+0x1f>

0000000000402f17 <check>:
  402f17:	89 f8                	mov    %edi,%eax
  402f19:	c1 e8 1c             	shr    $0x1c,%eax
  402f1c:	85 c0                	test   %eax,%eax
  402f1e:	74 1d                	je     402f3d <check+0x26>
  402f20:	b9 00 00 00 00       	mov    $0x0,%ecx
  402f25:	83 f9 1f             	cmp    $0x1f,%ecx
  402f28:	7f 0d                	jg     402f37 <check+0x20>
  402f2a:	89 f8                	mov    %edi,%eax
  402f2c:	d3 e8                	shr    %cl,%eax
  402f2e:	3c 0a                	cmp    $0xa,%al
  402f30:	74 11                	je     402f43 <check+0x2c>
  402f32:	83 c1 08             	add    $0x8,%ecx
  402f35:	eb ee                	jmp    402f25 <check+0xe>
  402f37:	b8 01 00 00 00       	mov    $0x1,%eax
  402f3c:	c3                   	retq   
  402f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  402f42:	c3                   	retq   
  402f43:	b8 00 00 00 00       	mov    $0x0,%eax
  402f48:	c3                   	retq   

0000000000402f49 <gencookie>:
  402f49:	53                   	push   %rbx
  402f4a:	83 c7 01             	add    $0x1,%edi
  402f4d:	e8 3e dd ff ff       	callq  400c90 <srandom@plt>
  402f52:	e8 49 de ff ff       	callq  400da0 <random@plt>
  402f57:	89 c3                	mov    %eax,%ebx
  402f59:	89 c7                	mov    %eax,%edi
  402f5b:	e8 b7 ff ff ff       	callq  402f17 <check>
  402f60:	85 c0                	test   %eax,%eax
  402f62:	74 ee                	je     402f52 <gencookie+0x9>
  402f64:	89 d8                	mov    %ebx,%eax
  402f66:	5b                   	pop    %rbx
  402f67:	c3                   	retq   
  402f68:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  402f6f:	00 

0000000000402f70 <__libc_csu_init>:
  402f70:	41 57                	push   %r15
  402f72:	41 56                	push   %r14
  402f74:	49 89 d7             	mov    %rdx,%r15
  402f77:	41 55                	push   %r13
  402f79:	41 54                	push   %r12
  402f7b:	4c 8d 25 8e 1e 20 00 	lea    0x201e8e(%rip),%r12        # 604e10 <__frame_dummy_init_array_entry>
  402f82:	55                   	push   %rbp
  402f83:	48 8d 2d 8e 1e 20 00 	lea    0x201e8e(%rip),%rbp        # 604e18 <__init_array_end>
  402f8a:	53                   	push   %rbx
  402f8b:	41 89 fd             	mov    %edi,%r13d
  402f8e:	49 89 f6             	mov    %rsi,%r14
  402f91:	4c 29 e5             	sub    %r12,%rbp
  402f94:	48 83 ec 08          	sub    $0x8,%rsp
  402f98:	48 c1 fd 03          	sar    $0x3,%rbp
  402f9c:	e8 a7 dc ff ff       	callq  400c48 <_init>
  402fa1:	48 85 ed             	test   %rbp,%rbp
  402fa4:	74 20                	je     402fc6 <__libc_csu_init+0x56>
  402fa6:	31 db                	xor    %ebx,%ebx
  402fa8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  402faf:	00 
  402fb0:	4c 89 fa             	mov    %r15,%rdx
  402fb3:	4c 89 f6             	mov    %r14,%rsi
  402fb6:	44 89 ef             	mov    %r13d,%edi
  402fb9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  402fbd:	48 83 c3 01          	add    $0x1,%rbx
  402fc1:	48 39 dd             	cmp    %rbx,%rbp
  402fc4:	75 ea                	jne    402fb0 <__libc_csu_init+0x40>
  402fc6:	48 83 c4 08          	add    $0x8,%rsp
  402fca:	5b                   	pop    %rbx
  402fcb:	5d                   	pop    %rbp
  402fcc:	41 5c                	pop    %r12
  402fce:	41 5d                	pop    %r13
  402fd0:	41 5e                	pop    %r14
  402fd2:	41 5f                	pop    %r15
  402fd4:	c3                   	retq   
  402fd5:	90                   	nop
  402fd6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  402fdd:	00 00 00 

0000000000402fe0 <__libc_csu_fini>:
  402fe0:	f3 c3                	repz retq 

Disassembly of section .fini:

0000000000402fe4 <_fini>:
  402fe4:	48 83 ec 08          	sub    $0x8,%rsp
  402fe8:	48 83 c4 08          	add    $0x8,%rsp
  402fec:	c3                   	retq   
