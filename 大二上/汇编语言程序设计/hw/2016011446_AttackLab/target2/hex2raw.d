
hex2raw：     文件格式 elf64-x86-64


Disassembly of section .init:

0000000000400780 <_init>:
  400780:	48 83 ec 08          	sub    $0x8,%rsp
  400784:	48 8b 05 6d 18 20 00 	mov    0x20186d(%rip),%rax        # 601ff8 <_DYNAMIC+0x1d0>
  40078b:	48 85 c0             	test   %rax,%rax
  40078e:	74 05                	je     400795 <_init+0x15>
  400790:	e8 eb 00 00 00       	callq  400880 <__ctype_b_loc@plt+0x10>
  400795:	48 83 c4 08          	add    $0x8,%rsp
  400799:	c3                   	retq   

Disassembly of section .plt:

00000000004007a0 <free@plt-0x10>:
  4007a0:	ff 35 62 18 20 00    	pushq  0x201862(%rip)        # 602008 <_GLOBAL_OFFSET_TABLE_+0x8>
  4007a6:	ff 25 64 18 20 00    	jmpq   *0x201864(%rip)        # 602010 <_GLOBAL_OFFSET_TABLE_+0x10>
  4007ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004007b0 <free@plt>:
  4007b0:	ff 25 62 18 20 00    	jmpq   *0x201862(%rip)        # 602018 <_GLOBAL_OFFSET_TABLE_+0x18>
  4007b6:	68 00 00 00 00       	pushq  $0x0
  4007bb:	e9 e0 ff ff ff       	jmpq   4007a0 <_init+0x20>

00000000004007c0 <__isoc99_fscanf@plt>:
  4007c0:	ff 25 5a 18 20 00    	jmpq   *0x20185a(%rip)        # 602020 <_GLOBAL_OFFSET_TABLE_+0x20>
  4007c6:	68 01 00 00 00       	pushq  $0x1
  4007cb:	e9 d0 ff ff ff       	jmpq   4007a0 <_init+0x20>

00000000004007d0 <write@plt>:
  4007d0:	ff 25 52 18 20 00    	jmpq   *0x201852(%rip)        # 602028 <_GLOBAL_OFFSET_TABLE_+0x28>
  4007d6:	68 02 00 00 00       	pushq  $0x2
  4007db:	e9 c0 ff ff ff       	jmpq   4007a0 <_init+0x20>

00000000004007e0 <__stack_chk_fail@plt>:
  4007e0:	ff 25 4a 18 20 00    	jmpq   *0x20184a(%rip)        # 602030 <_GLOBAL_OFFSET_TABLE_+0x30>
  4007e6:	68 03 00 00 00       	pushq  $0x3
  4007eb:	e9 b0 ff ff ff       	jmpq   4007a0 <_init+0x20>

00000000004007f0 <__libc_start_main@plt>:
  4007f0:	ff 25 42 18 20 00    	jmpq   *0x201842(%rip)        # 602038 <_GLOBAL_OFFSET_TABLE_+0x38>
  4007f6:	68 04 00 00 00       	pushq  $0x4
  4007fb:	e9 a0 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400800 <malloc@plt>:
  400800:	ff 25 3a 18 20 00    	jmpq   *0x20183a(%rip)        # 602040 <_GLOBAL_OFFSET_TABLE_+0x40>
  400806:	68 05 00 00 00       	pushq  $0x5
  40080b:	e9 90 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400810 <__isoc99_sscanf@plt>:
  400810:	ff 25 32 18 20 00    	jmpq   *0x201832(%rip)        # 602048 <_GLOBAL_OFFSET_TABLE_+0x48>
  400816:	68 06 00 00 00       	pushq  $0x6
  40081b:	e9 80 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400820 <realloc@plt>:
  400820:	ff 25 2a 18 20 00    	jmpq   *0x20182a(%rip)        # 602050 <_GLOBAL_OFFSET_TABLE_+0x50>
  400826:	68 07 00 00 00       	pushq  $0x7
  40082b:	e9 70 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400830 <fopen@plt>:
  400830:	ff 25 22 18 20 00    	jmpq   *0x201822(%rip)        # 602058 <_GLOBAL_OFFSET_TABLE_+0x58>
  400836:	68 08 00 00 00       	pushq  $0x8
  40083b:	e9 60 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400840 <getopt@plt>:
  400840:	ff 25 1a 18 20 00    	jmpq   *0x20181a(%rip)        # 602060 <_GLOBAL_OFFSET_TABLE_+0x60>
  400846:	68 09 00 00 00       	pushq  $0x9
  40084b:	e9 50 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400850 <fwrite@plt>:
  400850:	ff 25 12 18 20 00    	jmpq   *0x201812(%rip)        # 602068 <_GLOBAL_OFFSET_TABLE_+0x68>
  400856:	68 0a 00 00 00       	pushq  $0xa
  40085b:	e9 40 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400860 <__fprintf_chk@plt>:
  400860:	ff 25 0a 18 20 00    	jmpq   *0x20180a(%rip)        # 602070 <_GLOBAL_OFFSET_TABLE_+0x70>
  400866:	68 0b 00 00 00       	pushq  $0xb
  40086b:	e9 30 ff ff ff       	jmpq   4007a0 <_init+0x20>

0000000000400870 <__ctype_b_loc@plt>:
  400870:	ff 25 02 18 20 00    	jmpq   *0x201802(%rip)        # 602078 <_GLOBAL_OFFSET_TABLE_+0x78>
  400876:	68 0c 00 00 00       	pushq  $0xc
  40087b:	e9 20 ff ff ff       	jmpq   4007a0 <_init+0x20>

Disassembly of section .plt.got:

0000000000400880 <.plt.got>:
  400880:	ff 25 72 17 20 00    	jmpq   *0x201772(%rip)        # 601ff8 <_DYNAMIC+0x1d0>
  400886:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000400890 <_start>:
  400890:	31 ed                	xor    %ebp,%ebp
  400892:	49 89 d1             	mov    %rdx,%r9
  400895:	5e                   	pop    %rsi
  400896:	48 89 e2             	mov    %rsp,%rdx
  400899:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  40089d:	50                   	push   %rax
  40089e:	54                   	push   %rsp
  40089f:	49 c7 c0 f0 0d 40 00 	mov    $0x400df0,%r8
  4008a6:	48 c7 c1 80 0d 40 00 	mov    $0x400d80,%rcx
  4008ad:	48 c7 c7 1e 0c 40 00 	mov    $0x400c1e,%rdi
  4008b4:	e8 37 ff ff ff       	callq  4007f0 <__libc_start_main@plt>
  4008b9:	f4                   	hlt    
  4008ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000004008c0 <deregister_tm_clones>:
  4008c0:	b8 97 20 60 00       	mov    $0x602097,%eax
  4008c5:	55                   	push   %rbp
  4008c6:	48 2d 90 20 60 00    	sub    $0x602090,%rax
  4008cc:	48 83 f8 0e          	cmp    $0xe,%rax
  4008d0:	48 89 e5             	mov    %rsp,%rbp
  4008d3:	76 1b                	jbe    4008f0 <deregister_tm_clones+0x30>
  4008d5:	b8 00 00 00 00       	mov    $0x0,%eax
  4008da:	48 85 c0             	test   %rax,%rax
  4008dd:	74 11                	je     4008f0 <deregister_tm_clones+0x30>
  4008df:	5d                   	pop    %rbp
  4008e0:	bf 90 20 60 00       	mov    $0x602090,%edi
  4008e5:	ff e0                	jmpq   *%rax
  4008e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  4008ee:	00 00 
  4008f0:	5d                   	pop    %rbp
  4008f1:	c3                   	retq   
  4008f2:	0f 1f 40 00          	nopl   0x0(%rax)
  4008f6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4008fd:	00 00 00 

0000000000400900 <register_tm_clones>:
  400900:	be 90 20 60 00       	mov    $0x602090,%esi
  400905:	55                   	push   %rbp
  400906:	48 81 ee 90 20 60 00 	sub    $0x602090,%rsi
  40090d:	48 c1 fe 03          	sar    $0x3,%rsi
  400911:	48 89 e5             	mov    %rsp,%rbp
  400914:	48 89 f0             	mov    %rsi,%rax
  400917:	48 c1 e8 3f          	shr    $0x3f,%rax
  40091b:	48 01 c6             	add    %rax,%rsi
  40091e:	48 d1 fe             	sar    %rsi
  400921:	74 15                	je     400938 <register_tm_clones+0x38>
  400923:	b8 00 00 00 00       	mov    $0x0,%eax
  400928:	48 85 c0             	test   %rax,%rax
  40092b:	74 0b                	je     400938 <register_tm_clones+0x38>
  40092d:	5d                   	pop    %rbp
  40092e:	bf 90 20 60 00       	mov    $0x602090,%edi
  400933:	ff e0                	jmpq   *%rax
  400935:	0f 1f 00             	nopl   (%rax)
  400938:	5d                   	pop    %rbp
  400939:	c3                   	retq   
  40093a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400940 <__do_global_dtors_aux>:
  400940:	80 3d 81 17 20 00 00 	cmpb   $0x0,0x201781(%rip)        # 6020c8 <completed.7594>
  400947:	75 11                	jne    40095a <__do_global_dtors_aux+0x1a>
  400949:	55                   	push   %rbp
  40094a:	48 89 e5             	mov    %rsp,%rbp
  40094d:	e8 6e ff ff ff       	callq  4008c0 <deregister_tm_clones>
  400952:	5d                   	pop    %rbp
  400953:	c6 05 6e 17 20 00 01 	movb   $0x1,0x20176e(%rip)        # 6020c8 <completed.7594>
  40095a:	f3 c3                	repz retq 
  40095c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400960 <frame_dummy>:
  400960:	bf 20 1e 60 00       	mov    $0x601e20,%edi
  400965:	48 83 3f 00          	cmpq   $0x0,(%rdi)
  400969:	75 05                	jne    400970 <frame_dummy+0x10>
  40096b:	eb 93                	jmp    400900 <register_tm_clones>
  40096d:	0f 1f 00             	nopl   (%rax)
  400970:	b8 00 00 00 00       	mov    $0x0,%eax
  400975:	48 85 c0             	test   %rax,%rax
  400978:	74 f1                	je     40096b <frame_dummy+0xb>
  40097a:	55                   	push   %rbp
  40097b:	48 89 e5             	mov    %rsp,%rbp
  40097e:	ff d0                	callq  *%rax
  400980:	5d                   	pop    %rbp
  400981:	e9 7a ff ff ff       	jmpq   400900 <register_tm_clones>

0000000000400986 <usage>:
  400986:	48 83 ec 08          	sub    $0x8,%rsp
  40098a:	48 89 f9             	mov    %rdi,%rcx
  40098d:	ba 08 0e 40 00       	mov    $0x400e08,%edx
  400992:	be 01 00 00 00       	mov    $0x1,%esi
  400997:	48 8b 3d 22 17 20 00 	mov    0x201722(%rip),%rdi        # 6020c0 <stderr@@GLIBC_2.2.5>
  40099e:	b8 00 00 00 00       	mov    $0x0,%eax
  4009a3:	e8 b8 fe ff ff       	callq  400860 <__fprintf_chk@plt>
  4009a8:	48 8b 0d 11 17 20 00 	mov    0x201711(%rip),%rcx        # 6020c0 <stderr@@GLIBC_2.2.5>
  4009af:	ba 1c 00 00 00       	mov    $0x1c,%edx
  4009b4:	be 01 00 00 00       	mov    $0x1,%esi
  4009b9:	bf f0 0e 40 00       	mov    $0x400ef0,%edi
  4009be:	e8 8d fe ff ff       	callq  400850 <fwrite@plt>
  4009c3:	48 8b 0d f6 16 20 00 	mov    0x2016f6(%rip),%rcx        # 6020c0 <stderr@@GLIBC_2.2.5>
  4009ca:	ba 1f 00 00 00       	mov    $0x1f,%edx
  4009cf:	be 01 00 00 00       	mov    $0x1,%esi
  4009d4:	bf 28 0e 40 00       	mov    $0x400e28,%edi
  4009d9:	e8 72 fe ff ff       	callq  400850 <fwrite@plt>
  4009de:	48 8b 0d db 16 20 00 	mov    0x2016db(%rip),%rcx        # 6020c0 <stderr@@GLIBC_2.2.5>
  4009e5:	ba 21 00 00 00       	mov    $0x21,%edx
  4009ea:	be 01 00 00 00       	mov    $0x1,%esi
  4009ef:	bf 48 0e 40 00       	mov    $0x400e48,%edi
  4009f4:	e8 57 fe ff ff       	callq  400850 <fwrite@plt>
  4009f9:	48 83 c4 08          	add    $0x8,%rsp
  4009fd:	c3                   	retq   

00000000004009fe <convert_to_hex_value>:
  4009fe:	48 83 ec 18          	sub    $0x18,%rsp
  400a02:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  400a09:	00 00 
  400a0b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  400a10:	31 c0                	xor    %eax,%eax
  400a12:	48 8d 54 24 04       	lea    0x4(%rsp),%rdx
  400a17:	be 0d 0f 40 00       	mov    $0x400f0d,%esi
  400a1c:	e8 ef fd ff ff       	callq  400810 <__isoc99_sscanf@plt>
  400a21:	0f b6 44 24 04       	movzbl 0x4(%rsp),%eax
  400a26:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  400a2b:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
  400a32:	00 00 
  400a34:	74 05                	je     400a3b <convert_to_hex_value+0x3d>
  400a36:	e8 a5 fd ff ff       	callq  4007e0 <__stack_chk_fail@plt>
  400a3b:	48 83 c4 18          	add    $0x18,%rsp
  400a3f:	c3                   	retq   

0000000000400a40 <convert_to_byte_string>:
  400a40:	55                   	push   %rbp
  400a41:	48 89 e5             	mov    %rsp,%rbp
  400a44:	41 57                	push   %r15
  400a46:	41 56                	push   %r14
  400a48:	41 55                	push   %r13
  400a4a:	41 54                	push   %r12
  400a4c:	53                   	push   %rbx
  400a4d:	48 83 ec 38          	sub    $0x38,%rsp
  400a51:	49 89 fe             	mov    %rdi,%r14
  400a54:	48 89 75 a8          	mov    %rsi,-0x58(%rbp)
  400a58:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  400a5f:	00 00 
  400a61:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  400a65:	31 c0                	xor    %eax,%eax
  400a67:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  400a6e:	bf 00 04 00 00       	mov    $0x400,%edi
  400a73:	e8 88 fd ff ff       	callq  400800 <malloc@plt>
  400a78:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  400a7c:	48 85 c0             	test   %rax,%rax
  400a7f:	0f 84 6a 01 00 00    	je     400bef <convert_to_byte_string+0x1af>
  400a85:	48 89 e3             	mov    %rsp,%rbx
  400a88:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  400a8e:	c7 45 b4 00 04 00 00 	movl   $0x400,-0x4c(%rbp)
  400a95:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  400a9b:	e9 25 01 00 00       	jmpq   400bc5 <convert_to_byte_string+0x185>
  400aa0:	44 0f b6 23          	movzbl (%rbx),%r12d
  400aa4:	41 0f b6 d4          	movzbl %r12b,%edx
  400aa8:	b8 2f 00 00 00       	mov    $0x2f,%eax
  400aad:	29 d0                	sub    %edx,%eax
  400aaf:	75 13                	jne    400ac4 <convert_to_byte_string+0x84>
  400ab1:	0f b6 4b 01          	movzbl 0x1(%rbx),%ecx
  400ab5:	b8 2a 00 00 00       	mov    $0x2a,%eax
  400aba:	29 c8                	sub    %ecx,%eax
  400abc:	75 06                	jne    400ac4 <convert_to_byte_string+0x84>
  400abe:	0f b6 43 02          	movzbl 0x2(%rbx),%eax
  400ac2:	f7 d8                	neg    %eax
  400ac4:	85 c0                	test   %eax,%eax
  400ac6:	75 09                	jne    400ad1 <convert_to_byte_string+0x91>
  400ac8:	41 83 c5 01          	add    $0x1,%r13d
  400acc:	e9 f4 00 00 00       	jmpq   400bc5 <convert_to_byte_string+0x185>
  400ad1:	b8 2a 00 00 00       	mov    $0x2a,%eax
  400ad6:	29 d0                	sub    %edx,%eax
  400ad8:	75 13                	jne    400aed <convert_to_byte_string+0xad>
  400ada:	0f b6 53 01          	movzbl 0x1(%rbx),%edx
  400ade:	b8 2f 00 00 00       	mov    $0x2f,%eax
  400ae3:	29 d0                	sub    %edx,%eax
  400ae5:	75 06                	jne    400aed <convert_to_byte_string+0xad>
  400ae7:	0f b6 43 02          	movzbl 0x2(%rbx),%eax
  400aeb:	f7 d8                	neg    %eax
  400aed:	85 c0                	test   %eax,%eax
  400aef:	75 3c                	jne    400b2d <convert_to_byte_string+0xed>
  400af1:	45 85 ed             	test   %r13d,%r13d
  400af4:	7f 2e                	jg     400b24 <convert_to_byte_string+0xe4>
  400af6:	b9 10 0f 40 00       	mov    $0x400f10,%ecx
  400afb:	ba 13 0f 40 00       	mov    $0x400f13,%edx
  400b00:	be 01 00 00 00       	mov    $0x1,%esi
  400b05:	48 8b 3d b4 15 20 00 	mov    0x2015b4(%rip),%rdi        # 6020c0 <stderr@@GLIBC_2.2.5>
  400b0c:	e8 4f fd ff ff       	callq  400860 <__fprintf_chk@plt>
  400b11:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  400b15:	e8 96 fc ff ff       	callq  4007b0 <free@plt>
  400b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  400b1f:	e9 d7 00 00 00       	jmpq   400bfb <convert_to_byte_string+0x1bb>
  400b24:	41 83 ed 01          	sub    $0x1,%r13d
  400b28:	e9 98 00 00 00       	jmpq   400bc5 <convert_to_byte_string+0x185>
  400b2d:	45 85 ed             	test   %r13d,%r13d
  400b30:	0f 85 8f 00 00 00    	jne    400bc5 <convert_to_byte_string+0x185>
  400b36:	e8 35 fd ff ff       	callq  400870 <__ctype_b_loc@plt>
  400b3b:	48 8b 00             	mov    (%rax),%rax
  400b3e:	4d 0f be e4          	movsbq %r12b,%r12
  400b42:	42 f6 44 60 01 10    	testb  $0x10,0x1(%rax,%r12,2)
  400b48:	74 12                	je     400b5c <convert_to_byte_string+0x11c>
  400b4a:	48 0f be 53 01       	movsbq 0x1(%rbx),%rdx
  400b4f:	f6 44 50 01 10       	testb  $0x10,0x1(%rax,%rdx,2)
  400b54:	74 06                	je     400b5c <convert_to_byte_string+0x11c>
  400b56:	80 7b 02 00          	cmpb   $0x0,0x2(%rbx)
  400b5a:	74 2e                	je     400b8a <convert_to_byte_string+0x14a>
  400b5c:	48 89 d9             	mov    %rbx,%rcx
  400b5f:	ba 70 0e 40 00       	mov    $0x400e70,%edx
  400b64:	be 01 00 00 00       	mov    $0x1,%esi
  400b69:	48 8b 3d 50 15 20 00 	mov    0x201550(%rip),%rdi        # 6020c0 <stderr@@GLIBC_2.2.5>
  400b70:	b8 00 00 00 00       	mov    $0x0,%eax
  400b75:	e8 e6 fc ff ff       	callq  400860 <__fprintf_chk@plt>
  400b7a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  400b7e:	e8 2d fc ff ff       	callq  4007b0 <free@plt>
  400b83:	b8 00 00 00 00       	mov    $0x0,%eax
  400b88:	eb 71                	jmp    400bfb <convert_to_byte_string+0x1bb>
  400b8a:	48 89 df             	mov    %rbx,%rdi
  400b8d:	e8 6c fe ff ff       	callq  4009fe <convert_to_hex_value>
  400b92:	41 89 c4             	mov    %eax,%r12d
  400b95:	44 39 7d b4          	cmp    %r15d,-0x4c(%rbp)
  400b99:	75 1b                	jne    400bb6 <convert_to_byte_string+0x176>
  400b9b:	d1 65 b4             	shll   -0x4c(%rbp)
  400b9e:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  400ba1:	48 63 f0             	movslq %eax,%rsi
  400ba4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  400ba8:	e8 73 fc ff ff       	callq  400820 <realloc@plt>
  400bad:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  400bb1:	48 85 c0             	test   %rax,%rax
  400bb4:	74 40                	je     400bf6 <convert_to_byte_string+0x1b6>
  400bb6:	49 63 c7             	movslq %r15d,%rax
  400bb9:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  400bbd:	44 88 24 01          	mov    %r12b,(%rcx,%rax,1)
  400bc1:	45 8d 7f 01          	lea    0x1(%r15),%r15d
  400bc5:	48 89 da             	mov    %rbx,%rdx
  400bc8:	be 2b 0f 40 00       	mov    $0x400f2b,%esi
  400bcd:	4c 89 f7             	mov    %r14,%rdi
  400bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  400bd5:	e8 e6 fb ff ff       	callq  4007c0 <__isoc99_fscanf@plt>
  400bda:	85 c0                	test   %eax,%eax
  400bdc:	0f 8f be fe ff ff    	jg     400aa0 <convert_to_byte_string+0x60>
  400be2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  400be6:	44 89 38             	mov    %r15d,(%rax)
  400be9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  400bed:	eb 0c                	jmp    400bfb <convert_to_byte_string+0x1bb>
  400bef:	b8 00 00 00 00       	mov    $0x0,%eax
  400bf4:	eb 05                	jmp    400bfb <convert_to_byte_string+0x1bb>
  400bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  400bfb:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  400bff:	64 48 33 34 25 28 00 	xor    %fs:0x28,%rsi
  400c06:	00 00 
  400c08:	74 05                	je     400c0f <convert_to_byte_string+0x1cf>
  400c0a:	e8 d1 fb ff ff       	callq  4007e0 <__stack_chk_fail@plt>
  400c0f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  400c13:	5b                   	pop    %rbx
  400c14:	41 5c                	pop    %r12
  400c16:	41 5d                	pop    %r13
  400c18:	41 5e                	pop    %r14
  400c1a:	41 5f                	pop    %r15
  400c1c:	5d                   	pop    %rbp
  400c1d:	c3                   	retq   

0000000000400c1e <main>:
  400c1e:	41 54                	push   %r12
  400c20:	55                   	push   %rbp
  400c21:	53                   	push   %rbx
  400c22:	48 83 ec 10          	sub    $0x10,%rsp
  400c26:	89 fd                	mov    %edi,%ebp
  400c28:	48 89 f3             	mov    %rsi,%rbx
  400c2b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  400c32:	00 00 
  400c34:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  400c39:	31 c0                	xor    %eax,%eax
  400c3b:	4c 8b 25 5e 14 20 00 	mov    0x20145e(%rip),%r12        # 6020a0 <stdin@@GLIBC_2.2.5>
  400c42:	eb 73                	jmp    400cb7 <main+0x99>
  400c44:	3c 68                	cmp    $0x68,%al
  400c46:	74 06                	je     400c4e <main+0x30>
  400c48:	3c 69                	cmp    $0x69,%al
  400c4a:	74 14                	je     400c60 <main+0x42>
  400c4c:	eb 57                	jmp    400ca5 <main+0x87>
  400c4e:	48 8b 3b             	mov    (%rbx),%rdi
  400c51:	e8 30 fd ff ff       	callq  400986 <usage>
  400c56:	b8 00 00 00 00       	mov    $0x0,%eax
  400c5b:	e9 fe 00 00 00       	jmpq   400d5e <main+0x140>
  400c60:	be 2e 0f 40 00       	mov    $0x400f2e,%esi
  400c65:	48 8b 3d 3c 14 20 00 	mov    0x20143c(%rip),%rdi        # 6020a8 <optarg@@GLIBC_2.2.5>
  400c6c:	e8 bf fb ff ff       	callq  400830 <fopen@plt>
  400c71:	49 89 c4             	mov    %rax,%r12
  400c74:	48 85 c0             	test   %rax,%rax
  400c77:	75 3e                	jne    400cb7 <main+0x99>
  400c79:	48 8b 0d 28 14 20 00 	mov    0x201428(%rip),%rcx        # 6020a8 <optarg@@GLIBC_2.2.5>
  400c80:	ba d0 0e 40 00       	mov    $0x400ed0,%edx
  400c85:	be 01 00 00 00       	mov    $0x1,%esi
  400c8a:	48 8b 3d 2f 14 20 00 	mov    0x20142f(%rip),%rdi        # 6020c0 <stderr@@GLIBC_2.2.5>
  400c91:	b8 00 00 00 00       	mov    $0x0,%eax
  400c96:	e8 c5 fb ff ff       	callq  400860 <__fprintf_chk@plt>
  400c9b:	b8 01 00 00 00       	mov    $0x1,%eax
  400ca0:	e9 b9 00 00 00       	jmpq   400d5e <main+0x140>
  400ca5:	48 8b 3b             	mov    (%rbx),%rdi
  400ca8:	e8 d9 fc ff ff       	callq  400986 <usage>
  400cad:	b8 01 00 00 00       	mov    $0x1,%eax
  400cb2:	e9 a7 00 00 00       	jmpq   400d5e <main+0x140>
  400cb7:	ba 30 0f 40 00       	mov    $0x400f30,%edx
  400cbc:	48 89 de             	mov    %rbx,%rsi
  400cbf:	89 ef                	mov    %ebp,%edi
  400cc1:	e8 7a fb ff ff       	callq  400840 <getopt@plt>
  400cc6:	3c ff                	cmp    $0xff,%al
  400cc8:	0f 85 76 ff ff ff    	jne    400c44 <main+0x26>
  400cce:	48 8d 74 24 04       	lea    0x4(%rsp),%rsi
  400cd3:	4c 89 e7             	mov    %r12,%rdi
  400cd6:	e8 65 fd ff ff       	callq  400a40 <convert_to_byte_string>
  400cdb:	48 85 c0             	test   %rax,%rax
  400cde:	74 72                	je     400d52 <main+0x134>
  400ce0:	c6 44 24 03 0a       	movb   $0xa,0x3(%rsp)
  400ce5:	48 63 54 24 04       	movslq 0x4(%rsp),%rdx
  400cea:	48 89 c6             	mov    %rax,%rsi
  400ced:	bf 01 00 00 00       	mov    $0x1,%edi
  400cf2:	e8 d9 fa ff ff       	callq  4007d0 <write@plt>
  400cf7:	48 85 c0             	test   %rax,%rax
  400cfa:	79 1b                	jns    400d17 <main+0xf9>
  400cfc:	48 8b 0d bd 13 20 00 	mov    0x2013bd(%rip),%rcx        # 6020c0 <stderr@@GLIBC_2.2.5>
  400d03:	ba 0d 00 00 00       	mov    $0xd,%edx
  400d08:	be 01 00 00 00       	mov    $0x1,%esi
  400d0d:	bf 36 0f 40 00       	mov    $0x400f36,%edi
  400d12:	e8 39 fb ff ff       	callq  400850 <fwrite@plt>
  400d17:	ba 01 00 00 00       	mov    $0x1,%edx
  400d1c:	48 8d 74 24 03       	lea    0x3(%rsp),%rsi
  400d21:	bf 01 00 00 00       	mov    $0x1,%edi
  400d26:	e8 a5 fa ff ff       	callq  4007d0 <write@plt>
  400d2b:	48 85 c0             	test   %rax,%rax
  400d2e:	79 29                	jns    400d59 <main+0x13b>
  400d30:	48 8b 0d 89 13 20 00 	mov    0x201389(%rip),%rcx        # 6020c0 <stderr@@GLIBC_2.2.5>
  400d37:	ba 0d 00 00 00       	mov    $0xd,%edx
  400d3c:	be 01 00 00 00       	mov    $0x1,%esi
  400d41:	bf 36 0f 40 00       	mov    $0x400f36,%edi
  400d46:	e8 05 fb ff ff       	callq  400850 <fwrite@plt>
  400d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  400d50:	eb 0c                	jmp    400d5e <main+0x140>
  400d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  400d57:	eb 05                	jmp    400d5e <main+0x140>
  400d59:	b8 00 00 00 00       	mov    $0x0,%eax
  400d5e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  400d63:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
  400d6a:	00 00 
  400d6c:	74 05                	je     400d73 <main+0x155>
  400d6e:	e8 6d fa ff ff       	callq  4007e0 <__stack_chk_fail@plt>
  400d73:	48 83 c4 10          	add    $0x10,%rsp
  400d77:	5b                   	pop    %rbx
  400d78:	5d                   	pop    %rbp
  400d79:	41 5c                	pop    %r12
  400d7b:	c3                   	retq   
  400d7c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400d80 <__libc_csu_init>:
  400d80:	41 57                	push   %r15
  400d82:	41 56                	push   %r14
  400d84:	41 89 ff             	mov    %edi,%r15d
  400d87:	41 55                	push   %r13
  400d89:	41 54                	push   %r12
  400d8b:	4c 8d 25 7e 10 20 00 	lea    0x20107e(%rip),%r12        # 601e10 <__frame_dummy_init_array_entry>
  400d92:	55                   	push   %rbp
  400d93:	48 8d 2d 7e 10 20 00 	lea    0x20107e(%rip),%rbp        # 601e18 <__init_array_end>
  400d9a:	53                   	push   %rbx
  400d9b:	49 89 f6             	mov    %rsi,%r14
  400d9e:	49 89 d5             	mov    %rdx,%r13
  400da1:	4c 29 e5             	sub    %r12,%rbp
  400da4:	48 83 ec 08          	sub    $0x8,%rsp
  400da8:	48 c1 fd 03          	sar    $0x3,%rbp
  400dac:	e8 cf f9 ff ff       	callq  400780 <_init>
  400db1:	48 85 ed             	test   %rbp,%rbp
  400db4:	74 20                	je     400dd6 <__libc_csu_init+0x56>
  400db6:	31 db                	xor    %ebx,%ebx
  400db8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  400dbf:	00 
  400dc0:	4c 89 ea             	mov    %r13,%rdx
  400dc3:	4c 89 f6             	mov    %r14,%rsi
  400dc6:	44 89 ff             	mov    %r15d,%edi
  400dc9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  400dcd:	48 83 c3 01          	add    $0x1,%rbx
  400dd1:	48 39 eb             	cmp    %rbp,%rbx
  400dd4:	75 ea                	jne    400dc0 <__libc_csu_init+0x40>
  400dd6:	48 83 c4 08          	add    $0x8,%rsp
  400dda:	5b                   	pop    %rbx
  400ddb:	5d                   	pop    %rbp
  400ddc:	41 5c                	pop    %r12
  400dde:	41 5d                	pop    %r13
  400de0:	41 5e                	pop    %r14
  400de2:	41 5f                	pop    %r15
  400de4:	c3                   	retq   
  400de5:	90                   	nop
  400de6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400ded:	00 00 00 

0000000000400df0 <__libc_csu_fini>:
  400df0:	f3 c3                	repz retq 

Disassembly of section .fini:

0000000000400df4 <_fini>:
  400df4:	48 83 ec 08          	sub    $0x8,%rsp
  400df8:	48 83 c4 08          	add    $0x8,%rsp
  400dfc:	c3                   	retq   
