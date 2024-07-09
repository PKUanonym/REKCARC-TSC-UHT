
/home/lenovo/Desktop/bomb590/bomb:     file format elf32-i386


Disassembly of section .init:

08048770 <_init>:
 8048770:	53                   	push   %ebx
 8048771:	83 ec 08             	sub    $0x8,%esp
 8048774:	e8 47 02 00 00       	call   80489c0 <__x86.get_pc_thunk.bx>
 8048779:	81 c3 87 38 00 00    	add    $0x3887,%ebx
 804877f:	8b 83 fc ff ff ff    	mov    -0x4(%ebx),%eax
 8048785:	85 c0                	test   %eax,%eax
 8048787:	74 05                	je     804878e <_init+0x1e>
 8048789:	e8 f2 00 00 00       	call   8048880 <__gmon_start__@plt>
 804878e:	83 c4 08             	add    $0x8,%esp
 8048791:	5b                   	pop    %ebx
 8048792:	c3                   	ret    

Disassembly of section .plt:

080487a0 <read@plt-0x10>:
 80487a0:	ff 35 04 c0 04 08    	pushl  0x804c004
 80487a6:	ff 25 08 c0 04 08    	jmp    *0x804c008
 80487ac:	00 00                	add    %al,(%eax)
	...

080487b0 <read@plt>:
 80487b0:	ff 25 0c c0 04 08    	jmp    *0x804c00c
 80487b6:	68 00 00 00 00       	push   $0x0
 80487bb:	e9 e0 ff ff ff       	jmp    80487a0 <_init+0x30>

080487c0 <fflush@plt>:
 80487c0:	ff 25 10 c0 04 08    	jmp    *0x804c010
 80487c6:	68 08 00 00 00       	push   $0x8
 80487cb:	e9 d0 ff ff ff       	jmp    80487a0 <_init+0x30>

080487d0 <fgets@plt>:
 80487d0:	ff 25 14 c0 04 08    	jmp    *0x804c014
 80487d6:	68 10 00 00 00       	push   $0x10
 80487db:	e9 c0 ff ff ff       	jmp    80487a0 <_init+0x30>

080487e0 <signal@plt>:
 80487e0:	ff 25 18 c0 04 08    	jmp    *0x804c018
 80487e6:	68 18 00 00 00       	push   $0x18
 80487eb:	e9 b0 ff ff ff       	jmp    80487a0 <_init+0x30>

080487f0 <sleep@plt>:
 80487f0:	ff 25 1c c0 04 08    	jmp    *0x804c01c
 80487f6:	68 20 00 00 00       	push   $0x20
 80487fb:	e9 a0 ff ff ff       	jmp    80487a0 <_init+0x30>

08048800 <alarm@plt>:
 8048800:	ff 25 20 c0 04 08    	jmp    *0x804c020
 8048806:	68 28 00 00 00       	push   $0x28
 804880b:	e9 90 ff ff ff       	jmp    80487a0 <_init+0x30>

08048810 <__stack_chk_fail@plt>:
 8048810:	ff 25 24 c0 04 08    	jmp    *0x804c024
 8048816:	68 30 00 00 00       	push   $0x30
 804881b:	e9 80 ff ff ff       	jmp    80487a0 <_init+0x30>

08048820 <strcpy@plt>:
 8048820:	ff 25 28 c0 04 08    	jmp    *0x804c028
 8048826:	68 38 00 00 00       	push   $0x38
 804882b:	e9 70 ff ff ff       	jmp    80487a0 <_init+0x30>

08048830 <gethostname@plt>:
 8048830:	ff 25 2c c0 04 08    	jmp    *0x804c02c
 8048836:	68 40 00 00 00       	push   $0x40
 804883b:	e9 60 ff ff ff       	jmp    80487a0 <_init+0x30>

08048840 <getenv@plt>:
 8048840:	ff 25 30 c0 04 08    	jmp    *0x804c030
 8048846:	68 48 00 00 00       	push   $0x48
 804884b:	e9 50 ff ff ff       	jmp    80487a0 <_init+0x30>

08048850 <puts@plt>:
 8048850:	ff 25 34 c0 04 08    	jmp    *0x804c034
 8048856:	68 50 00 00 00       	push   $0x50
 804885b:	e9 40 ff ff ff       	jmp    80487a0 <_init+0x30>

08048860 <__memmove_chk@plt>:
 8048860:	ff 25 38 c0 04 08    	jmp    *0x804c038
 8048866:	68 58 00 00 00       	push   $0x58
 804886b:	e9 30 ff ff ff       	jmp    80487a0 <_init+0x30>

08048870 <__memcpy_chk@plt>:
 8048870:	ff 25 3c c0 04 08    	jmp    *0x804c03c
 8048876:	68 60 00 00 00       	push   $0x60
 804887b:	e9 20 ff ff ff       	jmp    80487a0 <_init+0x30>

08048880 <__gmon_start__@plt>:
 8048880:	ff 25 40 c0 04 08    	jmp    *0x804c040
 8048886:	68 68 00 00 00       	push   $0x68
 804888b:	e9 10 ff ff ff       	jmp    80487a0 <_init+0x30>

08048890 <exit@plt>:
 8048890:	ff 25 44 c0 04 08    	jmp    *0x804c044
 8048896:	68 70 00 00 00       	push   $0x70
 804889b:	e9 00 ff ff ff       	jmp    80487a0 <_init+0x30>

080488a0 <__libc_start_main@plt>:
 80488a0:	ff 25 48 c0 04 08    	jmp    *0x804c048
 80488a6:	68 78 00 00 00       	push   $0x78
 80488ab:	e9 f0 fe ff ff       	jmp    80487a0 <_init+0x30>

080488b0 <write@plt>:
 80488b0:	ff 25 4c c0 04 08    	jmp    *0x804c04c
 80488b6:	68 80 00 00 00       	push   $0x80
 80488bb:	e9 e0 fe ff ff       	jmp    80487a0 <_init+0x30>

080488c0 <strcasecmp@plt>:
 80488c0:	ff 25 50 c0 04 08    	jmp    *0x804c050
 80488c6:	68 88 00 00 00       	push   $0x88
 80488cb:	e9 d0 fe ff ff       	jmp    80487a0 <_init+0x30>

080488d0 <__isoc99_sscanf@plt>:
 80488d0:	ff 25 54 c0 04 08    	jmp    *0x804c054
 80488d6:	68 90 00 00 00       	push   $0x90
 80488db:	e9 c0 fe ff ff       	jmp    80487a0 <_init+0x30>

080488e0 <fopen@plt>:
 80488e0:	ff 25 58 c0 04 08    	jmp    *0x804c058
 80488e6:	68 98 00 00 00       	push   $0x98
 80488eb:	e9 b0 fe ff ff       	jmp    80487a0 <_init+0x30>

080488f0 <__errno_location@plt>:
 80488f0:	ff 25 5c c0 04 08    	jmp    *0x804c05c
 80488f6:	68 a0 00 00 00       	push   $0xa0
 80488fb:	e9 a0 fe ff ff       	jmp    80487a0 <_init+0x30>

08048900 <__printf_chk@plt>:
 8048900:	ff 25 60 c0 04 08    	jmp    *0x804c060
 8048906:	68 a8 00 00 00       	push   $0xa8
 804890b:	e9 90 fe ff ff       	jmp    80487a0 <_init+0x30>

08048910 <socket@plt>:
 8048910:	ff 25 64 c0 04 08    	jmp    *0x804c064
 8048916:	68 b0 00 00 00       	push   $0xb0
 804891b:	e9 80 fe ff ff       	jmp    80487a0 <_init+0x30>

08048920 <__fprintf_chk@plt>:
 8048920:	ff 25 68 c0 04 08    	jmp    *0x804c068
 8048926:	68 b8 00 00 00       	push   $0xb8
 804892b:	e9 70 fe ff ff       	jmp    80487a0 <_init+0x30>

08048930 <gethostbyname@plt>:
 8048930:	ff 25 6c c0 04 08    	jmp    *0x804c06c
 8048936:	68 c0 00 00 00       	push   $0xc0
 804893b:	e9 60 fe ff ff       	jmp    80487a0 <_init+0x30>

08048940 <strtol@plt>:
 8048940:	ff 25 70 c0 04 08    	jmp    *0x804c070
 8048946:	68 c8 00 00 00       	push   $0xc8
 804894b:	e9 50 fe ff ff       	jmp    80487a0 <_init+0x30>

08048950 <connect@plt>:
 8048950:	ff 25 74 c0 04 08    	jmp    *0x804c074
 8048956:	68 d0 00 00 00       	push   $0xd0
 804895b:	e9 40 fe ff ff       	jmp    80487a0 <_init+0x30>

08048960 <close@plt>:
 8048960:	ff 25 78 c0 04 08    	jmp    *0x804c078
 8048966:	68 d8 00 00 00       	push   $0xd8
 804896b:	e9 30 fe ff ff       	jmp    80487a0 <_init+0x30>

08048970 <__ctype_b_loc@plt>:
 8048970:	ff 25 7c c0 04 08    	jmp    *0x804c07c
 8048976:	68 e0 00 00 00       	push   $0xe0
 804897b:	e9 20 fe ff ff       	jmp    80487a0 <_init+0x30>

08048980 <__sprintf_chk@plt>:
 8048980:	ff 25 80 c0 04 08    	jmp    *0x804c080
 8048986:	68 e8 00 00 00       	push   $0xe8
 804898b:	e9 10 fe ff ff       	jmp    80487a0 <_init+0x30>

Disassembly of section .text:

08048990 <_start>:
 8048990:	31 ed                	xor    %ebp,%ebp
 8048992:	5e                   	pop    %esi
 8048993:	89 e1                	mov    %esp,%ecx
 8048995:	83 e4 f0             	and    $0xfffffff0,%esp
 8048998:	50                   	push   %eax
 8048999:	54                   	push   %esp
 804899a:	52                   	push   %edx
 804899b:	68 d0 a3 04 08       	push   $0x804a3d0
 80489a0:	68 60 a3 04 08       	push   $0x804a360
 80489a5:	51                   	push   %ecx
 80489a6:	56                   	push   %esi
 80489a7:	68 8d 8a 04 08       	push   $0x8048a8d
 80489ac:	e8 ef fe ff ff       	call   80488a0 <__libc_start_main@plt>
 80489b1:	f4                   	hlt    
 80489b2:	66 90                	xchg   %ax,%ax
 80489b4:	66 90                	xchg   %ax,%ax
 80489b6:	66 90                	xchg   %ax,%ax
 80489b8:	66 90                	xchg   %ax,%ax
 80489ba:	66 90                	xchg   %ax,%ax
 80489bc:	66 90                	xchg   %ax,%ax
 80489be:	66 90                	xchg   %ax,%ax

080489c0 <__x86.get_pc_thunk.bx>:
 80489c0:	8b 1c 24             	mov    (%esp),%ebx
 80489c3:	c3                   	ret    
 80489c4:	66 90                	xchg   %ax,%ax
 80489c6:	66 90                	xchg   %ax,%ax
 80489c8:	66 90                	xchg   %ax,%ax
 80489ca:	66 90                	xchg   %ax,%ax
 80489cc:	66 90                	xchg   %ax,%ax
 80489ce:	66 90                	xchg   %ax,%ax

080489d0 <deregister_tm_clones>:
 80489d0:	b8 e3 c7 04 08       	mov    $0x804c7e3,%eax
 80489d5:	2d e0 c7 04 08       	sub    $0x804c7e0,%eax
 80489da:	83 f8 06             	cmp    $0x6,%eax
 80489dd:	77 01                	ja     80489e0 <deregister_tm_clones+0x10>
 80489df:	c3                   	ret    
 80489e0:	b8 00 00 00 00       	mov    $0x0,%eax
 80489e5:	85 c0                	test   %eax,%eax
 80489e7:	74 f6                	je     80489df <deregister_tm_clones+0xf>
 80489e9:	55                   	push   %ebp
 80489ea:	89 e5                	mov    %esp,%ebp
 80489ec:	83 ec 18             	sub    $0x18,%esp
 80489ef:	c7 04 24 e0 c7 04 08 	movl   $0x804c7e0,(%esp)
 80489f6:	ff d0                	call   *%eax
 80489f8:	c9                   	leave  
 80489f9:	c3                   	ret    
 80489fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

08048a00 <register_tm_clones>:
 8048a00:	b8 e0 c7 04 08       	mov    $0x804c7e0,%eax
 8048a05:	2d e0 c7 04 08       	sub    $0x804c7e0,%eax
 8048a0a:	c1 f8 02             	sar    $0x2,%eax
 8048a0d:	89 c2                	mov    %eax,%edx
 8048a0f:	c1 ea 1f             	shr    $0x1f,%edx
 8048a12:	01 d0                	add    %edx,%eax
 8048a14:	d1 f8                	sar    %eax
 8048a16:	75 01                	jne    8048a19 <register_tm_clones+0x19>
 8048a18:	c3                   	ret    
 8048a19:	ba 00 00 00 00       	mov    $0x0,%edx
 8048a1e:	85 d2                	test   %edx,%edx
 8048a20:	74 f6                	je     8048a18 <register_tm_clones+0x18>
 8048a22:	55                   	push   %ebp
 8048a23:	89 e5                	mov    %esp,%ebp
 8048a25:	83 ec 18             	sub    $0x18,%esp
 8048a28:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048a2c:	c7 04 24 e0 c7 04 08 	movl   $0x804c7e0,(%esp)
 8048a33:	ff d2                	call   *%edx
 8048a35:	c9                   	leave  
 8048a36:	c3                   	ret    
 8048a37:	89 f6                	mov    %esi,%esi
 8048a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

08048a40 <__do_global_dtors_aux>:
 8048a40:	80 3d 04 c8 04 08 00 	cmpb   $0x0,0x804c804
 8048a47:	75 13                	jne    8048a5c <__do_global_dtors_aux+0x1c>
 8048a49:	55                   	push   %ebp
 8048a4a:	89 e5                	mov    %esp,%ebp
 8048a4c:	83 ec 08             	sub    $0x8,%esp
 8048a4f:	e8 7c ff ff ff       	call   80489d0 <deregister_tm_clones>
 8048a54:	c6 05 04 c8 04 08 01 	movb   $0x1,0x804c804
 8048a5b:	c9                   	leave  
 8048a5c:	f3 c3                	repz ret 
 8048a5e:	66 90                	xchg   %ax,%ax

08048a60 <frame_dummy>:
 8048a60:	a1 10 bf 04 08       	mov    0x804bf10,%eax
 8048a65:	85 c0                	test   %eax,%eax
 8048a67:	74 1f                	je     8048a88 <frame_dummy+0x28>
 8048a69:	b8 00 00 00 00       	mov    $0x0,%eax
 8048a6e:	85 c0                	test   %eax,%eax
 8048a70:	74 16                	je     8048a88 <frame_dummy+0x28>
 8048a72:	55                   	push   %ebp
 8048a73:	89 e5                	mov    %esp,%ebp
 8048a75:	83 ec 18             	sub    $0x18,%esp
 8048a78:	c7 04 24 10 bf 04 08 	movl   $0x804bf10,(%esp)
 8048a7f:	ff d0                	call   *%eax
 8048a81:	c9                   	leave  
 8048a82:	e9 79 ff ff ff       	jmp    8048a00 <register_tm_clones>
 8048a87:	90                   	nop
 8048a88:	e9 73 ff ff ff       	jmp    8048a00 <register_tm_clones>

08048a8d <main>:
 8048a8d:	55                   	push   %ebp
 8048a8e:	89 e5                	mov    %esp,%ebp
 8048a90:	53                   	push   %ebx
 8048a91:	83 e4 f0             	and    $0xfffffff0,%esp
 8048a94:	83 ec 10             	sub    $0x10,%esp
 8048a97:	8b 45 08             	mov    0x8(%ebp),%eax
 8048a9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 8048a9d:	83 f8 01             	cmp    $0x1,%eax
 8048aa0:	75 0c                	jne    8048aae <main+0x21>
 8048aa2:	a1 e4 c7 04 08       	mov    0x804c7e4,%eax
 8048aa7:	a3 0c c8 04 08       	mov    %eax,0x804c80c
 8048aac:	eb 74                	jmp    8048b22 <main+0x95>
 8048aae:	83 f8 02             	cmp    $0x2,%eax
 8048ab1:	75 49                	jne    8048afc <main+0x6f>
 8048ab3:	c7 44 24 04 f0 a3 04 	movl   $0x804a3f0,0x4(%esp)
 8048aba:	08 
 8048abb:	8b 43 04             	mov    0x4(%ebx),%eax
 8048abe:	89 04 24             	mov    %eax,(%esp)
 8048ac1:	e8 1a fe ff ff       	call   80488e0 <fopen@plt>
 8048ac6:	a3 0c c8 04 08       	mov    %eax,0x804c80c
 8048acb:	85 c0                	test   %eax,%eax
 8048acd:	75 53                	jne    8048b22 <main+0x95>
 8048acf:	8b 43 04             	mov    0x4(%ebx),%eax
 8048ad2:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048ad6:	8b 03                	mov    (%ebx),%eax
 8048ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048adc:	c7 44 24 04 f2 a3 04 	movl   $0x804a3f2,0x4(%esp)
 8048ae3:	08 
 8048ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048aeb:	e8 10 fe ff ff       	call   8048900 <__printf_chk@plt>
 8048af0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048af7:	e8 94 fd ff ff       	call   8048890 <exit@plt>
 8048afc:	8b 03                	mov    (%ebx),%eax
 8048afe:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048b02:	c7 44 24 04 0f a4 04 	movl   $0x804a40f,0x4(%esp)
 8048b09:	08 
 8048b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048b11:	e8 ea fd ff ff       	call   8048900 <__printf_chk@plt>
 8048b16:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048b1d:	e8 6e fd ff ff       	call   8048890 <exit@plt>
 8048b22:	e8 bc 06 00 00       	call   80491e3 <initialize_bomb>
 8048b27:	c7 04 24 74 a4 04 08 	movl   $0x804a474,(%esp)
 8048b2e:	e8 1d fd ff ff       	call   8048850 <puts@plt>
 8048b33:	c7 04 24 b0 a4 04 08 	movl   $0x804a4b0,(%esp)
 8048b3a:	e8 11 fd ff ff       	call   8048850 <puts@plt>
 8048b3f:	e8 a5 09 00 00       	call   80494e9 <read_line>
 8048b44:	89 04 24             	mov    %eax,(%esp)
 8048b47:	e8 b4 00 00 00       	call   8048c00 <phase_1>
 8048b4c:	e8 96 0a 00 00       	call   80495e7 <phase_defused>
 8048b51:	c7 04 24 dc a4 04 08 	movl   $0x804a4dc,(%esp)
 8048b58:	e8 f3 fc ff ff       	call   8048850 <puts@plt>
 8048b5d:	e8 87 09 00 00       	call   80494e9 <read_line>
 8048b62:	89 04 24             	mov    %eax,(%esp)
 8048b65:	e8 ba 00 00 00       	call   8048c24 <phase_2>
 8048b6a:	e8 78 0a 00 00       	call   80495e7 <phase_defused>
 8048b6f:	c7 04 24 29 a4 04 08 	movl   $0x804a429,(%esp)
 8048b76:	e8 d5 fc ff ff       	call   8048850 <puts@plt>
 8048b7b:	e8 69 09 00 00       	call   80494e9 <read_line>
 8048b80:	89 04 24             	mov    %eax,(%esp)
 8048b83:	e8 f1 00 00 00       	call   8048c79 <phase_3>
 8048b88:	e8 5a 0a 00 00       	call   80495e7 <phase_defused>
 8048b8d:	c7 04 24 47 a4 04 08 	movl   $0x804a447,(%esp)
 8048b94:	e8 b7 fc ff ff       	call   8048850 <puts@plt>
 8048b99:	e8 4b 09 00 00       	call   80494e9 <read_line>
 8048b9e:	89 04 24             	mov    %eax,(%esp)
 8048ba1:	e8 7c 02 00 00       	call   8048e22 <phase_4>
 8048ba6:	e8 3c 0a 00 00       	call   80495e7 <phase_defused>
 8048bab:	c7 04 24 08 a5 04 08 	movl   $0x804a508,(%esp)
 8048bb2:	e8 99 fc ff ff       	call   8048850 <puts@plt>
 8048bb7:	e8 2d 09 00 00       	call   80494e9 <read_line>
 8048bbc:	89 04 24             	mov    %eax,(%esp)
 8048bbf:	e8 c3 02 00 00       	call   8048e87 <phase_5>
 8048bc4:	e8 1e 0a 00 00       	call   80495e7 <phase_defused>
 8048bc9:	c7 04 24 56 a4 04 08 	movl   $0x804a456,(%esp)
 8048bd0:	e8 7b fc ff ff       	call   8048850 <puts@plt>
 8048bd5:	e8 0f 09 00 00       	call   80494e9 <read_line>
 8048bda:	89 04 24             	mov    %eax,(%esp)
 8048bdd:	e8 2f 03 00 00       	call   8048f11 <phase_6>
 8048be2:	e8 00 0a 00 00       	call   80495e7 <phase_defused>
 8048be7:	b8 00 00 00 00       	mov    $0x0,%eax
 8048bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048bef:	c9                   	leave  
 8048bf0:	c3                   	ret    
 8048bf1:	66 90                	xchg   %ax,%ax
 8048bf3:	66 90                	xchg   %ax,%ax
 8048bf5:	66 90                	xchg   %ax,%ax
 8048bf7:	66 90                	xchg   %ax,%ax
 8048bf9:	66 90                	xchg   %ax,%ax
 8048bfb:	66 90                	xchg   %ax,%ax
 8048bfd:	66 90                	xchg   %ax,%ax
 8048bff:	90                   	nop

08048c00 <phase_1>:
 8048c00:	55                   	push   %ebp
 8048c01:	89 e5                	mov    %esp,%ebp
 8048c03:	83 ec 18             	sub    $0x18,%esp
 8048c06:	c7 44 24 04 2c a5 04 	movl   $0x804a52c,0x4(%esp)
 8048c0d:	08 
 8048c0e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c11:	89 04 24             	mov    %eax,(%esp)
 8048c14:	e8 59 05 00 00       	call   8049172 <strings_not_equal>
 8048c19:	85 c0                	test   %eax,%eax
 8048c1b:	74 05                	je     8048c22 <phase_1+0x22>
 8048c1d:	e8 36 08 00 00       	call   8049458 <explode_bomb>
 8048c22:	c9                   	leave  
 8048c23:	c3                   	ret    

08048c24 <phase_2>:
 8048c24:	55                   	push   %ebp
 8048c25:	89 e5                	mov    %esp,%ebp
 8048c27:	56                   	push   %esi
 8048c28:	53                   	push   %ebx
 8048c29:	83 ec 30             	sub    $0x30,%esp
 8048c2c:	8d 45 e0             	lea    -0x20(%ebp),%eax
 8048c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048c33:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c36:	89 04 24             	mov    %eax,(%esp)
 8048c39:	e8 5c 08 00 00       	call   804949a <read_six_numbers>
 8048c3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048c42:	75 06                	jne    8048c4a <phase_2+0x26>
 8048c44:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
 8048c48:	74 20                	je     8048c6a <phase_2+0x46>
 8048c4a:	e8 09 08 00 00       	call   8049458 <explode_bomb>
 8048c4f:	90                   	nop
 8048c50:	eb 18                	jmp    8048c6a <phase_2+0x46>
 8048c52:	8b 43 f8             	mov    -0x8(%ebx),%eax
 8048c55:	03 43 fc             	add    -0x4(%ebx),%eax
 8048c58:	39 03                	cmp    %eax,(%ebx)
 8048c5a:	74 05                	je     8048c61 <phase_2+0x3d>
 8048c5c:	e8 f7 07 00 00       	call   8049458 <explode_bomb>
 8048c61:	83 c3 04             	add    $0x4,%ebx
 8048c64:	39 f3                	cmp    %esi,%ebx
 8048c66:	75 ea                	jne    8048c52 <phase_2+0x2e>
 8048c68:	eb 08                	jmp    8048c72 <phase_2+0x4e>
 8048c6a:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 8048c6d:	8d 75 f8             	lea    -0x8(%ebp),%esi
 8048c70:	eb e0                	jmp    8048c52 <phase_2+0x2e>
 8048c72:	83 c4 30             	add    $0x30,%esp
 8048c75:	5b                   	pop    %ebx
 8048c76:	5e                   	pop    %esi
 8048c77:	5d                   	pop    %ebp
 8048c78:	c3                   	ret    

08048c79 <phase_3>:
 8048c79:	55                   	push   %ebp
 8048c7a:	89 e5                	mov    %esp,%ebp
 8048c7c:	83 ec 38             	sub    $0x38,%esp
 8048c7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8048c82:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048c86:	8d 45 ef             	lea    -0x11(%ebp),%eax
 8048c89:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048c8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
 8048c90:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048c94:	c7 44 24 04 82 a5 04 	movl   $0x804a582,0x4(%esp)
 8048c9b:	08 
 8048c9c:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c9f:	89 04 24             	mov    %eax,(%esp)
 8048ca2:	e8 29 fc ff ff       	call   80488d0 <__isoc99_sscanf@plt>
 8048ca7:	83 f8 02             	cmp    $0x2,%eax
 8048caa:	7f 05                	jg     8048cb1 <phase_3+0x38>
 8048cac:	e8 a7 07 00 00       	call   8049458 <explode_bomb>
 8048cb1:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
 8048cb5:	0f 87 ef 00 00 00    	ja     8048daa <phase_3+0x131>
 8048cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048cbe:	ff 24 85 94 a5 04 08 	jmp    *0x804a594(,%eax,4)
 8048cc5:	b8 6a 00 00 00       	mov    $0x6a,%eax
 8048cca:	81 7d f4 eb 01 00 00 	cmpl   $0x1eb,-0xc(%ebp)
 8048cd1:	0f 84 dd 00 00 00    	je     8048db4 <phase_3+0x13b>
 8048cd7:	e8 7c 07 00 00       	call   8049458 <explode_bomb>
 8048cdc:	b8 6a 00 00 00       	mov    $0x6a,%eax
 8048ce1:	e9 ce 00 00 00       	jmp    8048db4 <phase_3+0x13b>
 8048ce6:	b8 69 00 00 00       	mov    $0x69,%eax
 8048ceb:	81 7d f4 c8 01 00 00 	cmpl   $0x1c8,-0xc(%ebp)
 8048cf2:	0f 84 bc 00 00 00    	je     8048db4 <phase_3+0x13b>
 8048cf8:	e8 5b 07 00 00       	call   8049458 <explode_bomb>
 8048cfd:	b8 69 00 00 00       	mov    $0x69,%eax
 8048d02:	e9 ad 00 00 00       	jmp    8048db4 <phase_3+0x13b>
 8048d07:	b8 76 00 00 00       	mov    $0x76,%eax
 8048d0c:	81 7d f4 47 01 00 00 	cmpl   $0x147,-0xc(%ebp)
 8048d13:	0f 84 9b 00 00 00    	je     8048db4 <phase_3+0x13b>
 8048d19:	e8 3a 07 00 00       	call   8049458 <explode_bomb>
 8048d1e:	b8 76 00 00 00       	mov    $0x76,%eax
 8048d23:	e9 8c 00 00 00       	jmp    8048db4 <phase_3+0x13b>
 8048d28:	b8 70 00 00 00       	mov    $0x70,%eax
 8048d2d:	81 7d f4 c2 02 00 00 	cmpl   $0x2c2,-0xc(%ebp)
 8048d34:	74 7e                	je     8048db4 <phase_3+0x13b>
 8048d36:	e8 1d 07 00 00       	call   8049458 <explode_bomb>
 8048d3b:	b8 70 00 00 00       	mov    $0x70,%eax
 8048d40:	eb 72                	jmp    8048db4 <phase_3+0x13b>
 8048d42:	b8 6f 00 00 00       	mov    $0x6f,%eax
 8048d47:	81 7d f4 df 02 00 00 	cmpl   $0x2df,-0xc(%ebp)
 8048d4e:	74 64                	je     8048db4 <phase_3+0x13b>
 8048d50:	e8 03 07 00 00       	call   8049458 <explode_bomb>
 8048d55:	b8 6f 00 00 00       	mov    $0x6f,%eax
 8048d5a:	eb 58                	jmp    8048db4 <phase_3+0x13b>
 8048d5c:	b8 71 00 00 00       	mov    $0x71,%eax
 8048d61:	81 7d f4 2b 03 00 00 	cmpl   $0x32b,-0xc(%ebp)
 8048d68:	74 4a                	je     8048db4 <phase_3+0x13b>
 8048d6a:	e8 e9 06 00 00       	call   8049458 <explode_bomb>
 8048d6f:	b8 71 00 00 00       	mov    $0x71,%eax
 8048d74:	eb 3e                	jmp    8048db4 <phase_3+0x13b>
 8048d76:	b8 6a 00 00 00       	mov    $0x6a,%eax
 8048d7b:	81 7d f4 de 00 00 00 	cmpl   $0xde,-0xc(%ebp)
 8048d82:	74 30                	je     8048db4 <phase_3+0x13b>
 8048d84:	e8 cf 06 00 00       	call   8049458 <explode_bomb>
 8048d89:	b8 6a 00 00 00       	mov    $0x6a,%eax
 8048d8e:	eb 24                	jmp    8048db4 <phase_3+0x13b>
 8048d90:	b8 63 00 00 00       	mov    $0x63,%eax
 8048d95:	81 7d f4 f1 00 00 00 	cmpl   $0xf1,-0xc(%ebp)
 8048d9c:	74 16                	je     8048db4 <phase_3+0x13b>
 8048d9e:	e8 b5 06 00 00       	call   8049458 <explode_bomb>
 8048da3:	b8 63 00 00 00       	mov    $0x63,%eax
 8048da8:	eb 0a                	jmp    8048db4 <phase_3+0x13b>
 8048daa:	e8 a9 06 00 00       	call   8049458 <explode_bomb>
 8048daf:	b8 75 00 00 00       	mov    $0x75,%eax
 8048db4:	3a 45 ef             	cmp    -0x11(%ebp),%al
 8048db7:	74 05                	je     8048dbe <phase_3+0x145>
 8048db9:	e8 9a 06 00 00       	call   8049458 <explode_bomb>
 8048dbe:	c9                   	leave  
 8048dbf:	c3                   	ret    

08048dc0 <func4>:
 8048dc0:	55                   	push   %ebp
 8048dc1:	89 e5                	mov    %esp,%ebp
 8048dc3:	56                   	push   %esi
 8048dc4:	53                   	push   %ebx
 8048dc5:	83 ec 10             	sub    $0x10,%esp
 8048dc8:	8b 55 08             	mov    0x8(%ebp),%edx
 8048dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8048dd1:	89 d9                	mov    %ebx,%ecx
 8048dd3:	29 c1                	sub    %eax,%ecx
 8048dd5:	89 ce                	mov    %ecx,%esi
 8048dd7:	c1 ee 1f             	shr    $0x1f,%esi
 8048dda:	01 f1                	add    %esi,%ecx
 8048ddc:	d1 f9                	sar    %ecx
 8048dde:	01 c1                	add    %eax,%ecx
 8048de0:	39 d1                	cmp    %edx,%ecx
 8048de2:	7e 17                	jle    8048dfb <func4+0x3b>
 8048de4:	83 e9 01             	sub    $0x1,%ecx
 8048de7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8048deb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048def:	89 14 24             	mov    %edx,(%esp)
 8048df2:	e8 c9 ff ff ff       	call   8048dc0 <func4>
 8048df7:	01 c0                	add    %eax,%eax
 8048df9:	eb 20                	jmp    8048e1b <func4+0x5b>
 8048dfb:	b8 00 00 00 00       	mov    $0x0,%eax
 8048e00:	39 d1                	cmp    %edx,%ecx
 8048e02:	7d 17                	jge    8048e1b <func4+0x5b>
 8048e04:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 8048e08:	83 c1 01             	add    $0x1,%ecx
 8048e0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048e0f:	89 14 24             	mov    %edx,(%esp)
 8048e12:	e8 a9 ff ff ff       	call   8048dc0 <func4>
 8048e17:	8d 44 00 01          	lea    0x1(%eax,%eax,1),%eax
 8048e1b:	83 c4 10             	add    $0x10,%esp
 8048e1e:	5b                   	pop    %ebx
 8048e1f:	5e                   	pop    %esi
 8048e20:	5d                   	pop    %ebp
 8048e21:	c3                   	ret    

08048e22 <phase_4>:
 8048e22:	55                   	push   %ebp
 8048e23:	89 e5                	mov    %esp,%ebp
 8048e25:	83 ec 28             	sub    $0x28,%esp
 8048e28:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8048e2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048e2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
 8048e32:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048e36:	c7 44 24 04 cd a7 04 	movl   $0x804a7cd,0x4(%esp)
 8048e3d:	08 
 8048e3e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048e41:	89 04 24             	mov    %eax,(%esp)
 8048e44:	e8 87 fa ff ff       	call   80488d0 <__isoc99_sscanf@plt>
 8048e49:	83 f8 02             	cmp    $0x2,%eax
 8048e4c:	75 06                	jne    8048e54 <phase_4+0x32>
 8048e4e:	83 7d f0 0e          	cmpl   $0xe,-0x10(%ebp)
 8048e52:	76 05                	jbe    8048e59 <phase_4+0x37>
 8048e54:	e8 ff 05 00 00       	call   8049458 <explode_bomb>
 8048e59:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 8048e60:	00 
 8048e61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8048e68:	00 
 8048e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048e6c:	89 04 24             	mov    %eax,(%esp)
 8048e6f:	e8 4c ff ff ff       	call   8048dc0 <func4>
 8048e74:	85 c0                	test   %eax,%eax
 8048e76:	75 06                	jne    8048e7e <phase_4+0x5c>
 8048e78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8048e7c:	74 07                	je     8048e85 <phase_4+0x63>
 8048e7e:	66 90                	xchg   %ax,%ax
 8048e80:	e8 d3 05 00 00       	call   8049458 <explode_bomb>
 8048e85:	c9                   	leave  
 8048e86:	c3                   	ret    

08048e87 <phase_5>:
 8048e87:	55                   	push   %ebp
 8048e88:	89 e5                	mov    %esp,%ebp
 8048e8a:	53                   	push   %ebx
 8048e8b:	83 ec 24             	sub    $0x24,%esp
 8048e8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048e91:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 8048e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048e9a:	31 c0                	xor    %eax,%eax
 8048e9c:	89 1c 24             	mov    %ebx,(%esp)
 8048e9f:	e8 ac 02 00 00       	call   8049150 <string_length>
 8048ea4:	83 f8 06             	cmp    $0x6,%eax
 8048ea7:	74 49                	je     8048ef2 <phase_5+0x6b>
 8048ea9:	e8 aa 05 00 00       	call   8049458 <explode_bomb>
 8048eae:	66 90                	xchg   %ax,%ax
 8048eb0:	eb 40                	jmp    8048ef2 <phase_5+0x6b>
 8048eb2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 8048eb6:	83 e2 0f             	and    $0xf,%edx
 8048eb9:	0f b6 92 b4 a5 04 08 	movzbl 0x804a5b4(%edx),%edx
 8048ec0:	88 54 05 ed          	mov    %dl,-0x13(%ebp,%eax,1)
 8048ec4:	83 c0 01             	add    $0x1,%eax
 8048ec7:	83 f8 06             	cmp    $0x6,%eax
 8048eca:	75 e6                	jne    8048eb2 <phase_5+0x2b>
 8048ecc:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
 8048ed0:	c7 44 24 04 8b a5 04 	movl   $0x804a58b,0x4(%esp)
 8048ed7:	08 
 8048ed8:	8d 45 ed             	lea    -0x13(%ebp),%eax
 8048edb:	89 04 24             	mov    %eax,(%esp)
 8048ede:	e8 8f 02 00 00       	call   8049172 <strings_not_equal>
 8048ee3:	85 c0                	test   %eax,%eax
 8048ee5:	74 12                	je     8048ef9 <phase_5+0x72>
 8048ee7:	e8 6c 05 00 00       	call   8049458 <explode_bomb>
 8048eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8048ef0:	eb 07                	jmp    8048ef9 <phase_5+0x72>
 8048ef2:	b8 00 00 00 00       	mov    $0x0,%eax
 8048ef7:	eb b9                	jmp    8048eb2 <phase_5+0x2b>
 8048ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048efc:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
 8048f03:	74 05                	je     8048f0a <phase_5+0x83>
 8048f05:	e8 06 f9 ff ff       	call   8048810 <__stack_chk_fail@plt>
 8048f0a:	83 c4 24             	add    $0x24,%esp
 8048f0d:	5b                   	pop    %ebx
 8048f0e:	5d                   	pop    %ebp
 8048f0f:	90                   	nop
 8048f10:	c3                   	ret    

08048f11 <phase_6>:
 8048f11:	55                   	push   %ebp
 8048f12:	89 e5                	mov    %esp,%ebp
 8048f14:	56                   	push   %esi
 8048f15:	53                   	push   %ebx
 8048f16:	83 ec 40             	sub    $0x40,%esp
 8048f19:	8d 45 c8             	lea    -0x38(%ebp),%eax
 8048f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048f20:	8b 45 08             	mov    0x8(%ebp),%eax
 8048f23:	89 04 24             	mov    %eax,(%esp)
 8048f26:	e8 6f 05 00 00       	call   804949a <read_six_numbers>
 8048f2b:	be 00 00 00 00       	mov    $0x0,%esi
 8048f30:	8b 44 b5 c8          	mov    -0x38(%ebp,%esi,4),%eax
 8048f34:	83 e8 01             	sub    $0x1,%eax
 8048f37:	83 f8 05             	cmp    $0x5,%eax
 8048f3a:	76 05                	jbe    8048f41 <phase_6+0x30>
 8048f3c:	e8 17 05 00 00       	call   8049458 <explode_bomb>
 8048f41:	83 c6 01             	add    $0x1,%esi
 8048f44:	83 fe 06             	cmp    $0x6,%esi
 8048f47:	74 1b                	je     8048f64 <phase_6+0x53>
 8048f49:	89 f3                	mov    %esi,%ebx
 8048f4b:	8b 44 9d c8          	mov    -0x38(%ebp,%ebx,4),%eax
 8048f4f:	39 44 b5 c4          	cmp    %eax,-0x3c(%ebp,%esi,4)
 8048f53:	75 05                	jne    8048f5a <phase_6+0x49>
 8048f55:	e8 fe 04 00 00       	call   8049458 <explode_bomb>
 8048f5a:	83 c3 01             	add    $0x1,%ebx
 8048f5d:	83 fb 05             	cmp    $0x5,%ebx
 8048f60:	7e e9                	jle    8048f4b <phase_6+0x3a>
 8048f62:	eb cc                	jmp    8048f30 <phase_6+0x1f>
 8048f64:	8d 45 c8             	lea    -0x38(%ebp),%eax
 8048f67:	8d 5d e0             	lea    -0x20(%ebp),%ebx
 8048f6a:	b9 07 00 00 00       	mov    $0x7,%ecx
 8048f6f:	89 ca                	mov    %ecx,%edx
 8048f71:	2b 10                	sub    (%eax),%edx
 8048f73:	89 10                	mov    %edx,(%eax)
 8048f75:	83 c0 04             	add    $0x4,%eax
 8048f78:	39 d8                	cmp    %ebx,%eax
 8048f7a:	75 f3                	jne    8048f6f <phase_6+0x5e>
 8048f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
 8048f81:	eb 1d                	jmp    8048fa0 <phase_6+0x8f>
 8048f83:	8b 52 08             	mov    0x8(%edx),%edx
 8048f86:	83 c0 01             	add    $0x1,%eax
 8048f89:	39 c8                	cmp    %ecx,%eax
 8048f8b:	75 f6                	jne    8048f83 <phase_6+0x72>
 8048f8d:	eb 05                	jmp    8048f94 <phase_6+0x83>
 8048f8f:	ba 74 c1 04 08       	mov    $0x804c174,%edx
 8048f94:	89 54 b5 e0          	mov    %edx,-0x20(%ebp,%esi,4)
 8048f98:	83 c3 01             	add    $0x1,%ebx
 8048f9b:	83 fb 06             	cmp    $0x6,%ebx
 8048f9e:	74 17                	je     8048fb7 <phase_6+0xa6>
 8048fa0:	89 de                	mov    %ebx,%esi
 8048fa2:	8b 4c 9d c8          	mov    -0x38(%ebp,%ebx,4),%ecx
 8048fa6:	83 f9 01             	cmp    $0x1,%ecx
 8048fa9:	7e e4                	jle    8048f8f <phase_6+0x7e>
 8048fab:	b8 01 00 00 00       	mov    $0x1,%eax
 8048fb0:	ba 74 c1 04 08       	mov    $0x804c174,%edx
 8048fb5:	eb cc                	jmp    8048f83 <phase_6+0x72>
 8048fb7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 8048fba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8048fbd:	8d 75 f8             	lea    -0x8(%ebp),%esi
 8048fc0:	89 d9                	mov    %ebx,%ecx
 8048fc2:	8b 10                	mov    (%eax),%edx
 8048fc4:	89 51 08             	mov    %edx,0x8(%ecx)
 8048fc7:	83 c0 04             	add    $0x4,%eax
 8048fca:	39 f0                	cmp    %esi,%eax
 8048fcc:	74 04                	je     8048fd2 <phase_6+0xc1>
 8048fce:	89 d1                	mov    %edx,%ecx
 8048fd0:	eb f0                	jmp    8048fc2 <phase_6+0xb1>
 8048fd2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
 8048fd9:	be 05 00 00 00       	mov    $0x5,%esi
 8048fde:	8b 43 08             	mov    0x8(%ebx),%eax
 8048fe1:	8b 00                	mov    (%eax),%eax
 8048fe3:	39 03                	cmp    %eax,(%ebx)
 8048fe5:	7d 05                	jge    8048fec <phase_6+0xdb>
 8048fe7:	e8 6c 04 00 00       	call   8049458 <explode_bomb>
 8048fec:	8b 5b 08             	mov    0x8(%ebx),%ebx
 8048fef:	83 ee 01             	sub    $0x1,%esi
 8048ff2:	75 ea                	jne    8048fde <phase_6+0xcd>
 8048ff4:	83 c4 40             	add    $0x40,%esp
 8048ff7:	5b                   	pop    %ebx
 8048ff8:	5e                   	pop    %esi
 8048ff9:	5d                   	pop    %ebp
 8048ffa:	c3                   	ret    

08048ffb <fun7>:
 8048ffb:	55                   	push   %ebp
 8048ffc:	89 e5                	mov    %esp,%ebp
 8048ffe:	53                   	push   %ebx
 8048fff:	83 ec 14             	sub    $0x14,%esp
 8049002:	8b 55 08             	mov    0x8(%ebp),%edx
 8049005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8049008:	85 d2                	test   %edx,%edx
 804900a:	74 37                	je     8049043 <fun7+0x48>
 804900c:	8b 1a                	mov    (%edx),%ebx
 804900e:	39 cb                	cmp    %ecx,%ebx
 8049010:	7e 13                	jle    8049025 <fun7+0x2a>
 8049012:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8049016:	8b 42 04             	mov    0x4(%edx),%eax
 8049019:	89 04 24             	mov    %eax,(%esp)
 804901c:	e8 da ff ff ff       	call   8048ffb <fun7>
 8049021:	01 c0                	add    %eax,%eax
 8049023:	eb 23                	jmp    8049048 <fun7+0x4d>
 8049025:	b8 00 00 00 00       	mov    $0x0,%eax
 804902a:	39 cb                	cmp    %ecx,%ebx
 804902c:	74 1a                	je     8049048 <fun7+0x4d>
 804902e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8049032:	8b 42 08             	mov    0x8(%edx),%eax
 8049035:	89 04 24             	mov    %eax,(%esp)
 8049038:	e8 be ff ff ff       	call   8048ffb <fun7>
 804903d:	8d 44 00 01          	lea    0x1(%eax,%eax,1),%eax
 8049041:	eb 05                	jmp    8049048 <fun7+0x4d>
 8049043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049048:	83 c4 14             	add    $0x14,%esp
 804904b:	5b                   	pop    %ebx
 804904c:	5d                   	pop    %ebp
 804904d:	c3                   	ret    

0804904e <secret_phase>:
 804904e:	55                   	push   %ebp
 804904f:	89 e5                	mov    %esp,%ebp
 8049051:	53                   	push   %ebx
 8049052:	83 ec 14             	sub    $0x14,%esp
 8049055:	e8 8f 04 00 00       	call   80494e9 <read_line>
 804905a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8049061:	00 
 8049062:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8049069:	00 
 804906a:	89 04 24             	mov    %eax,(%esp)
 804906d:	e8 ce f8 ff ff       	call   8048940 <strtol@plt>
 8049072:	89 c3                	mov    %eax,%ebx
 8049074:	8d 40 ff             	lea    -0x1(%eax),%eax
 8049077:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 804907c:	76 05                	jbe    8049083 <secret_phase+0x35>
 804907e:	e8 d5 03 00 00       	call   8049458 <explode_bomb>
 8049083:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8049087:	c7 04 24 c0 c0 04 08 	movl   $0x804c0c0,(%esp)
 804908e:	e8 68 ff ff ff       	call   8048ffb <fun7>
 8049093:	83 f8 01             	cmp    $0x1,%eax
 8049096:	74 05                	je     804909d <secret_phase+0x4f>
 8049098:	e8 bb 03 00 00       	call   8049458 <explode_bomb>
 804909d:	c7 04 24 5c a5 04 08 	movl   $0x804a55c,(%esp)
 80490a4:	e8 a7 f7 ff ff       	call   8048850 <puts@plt>
 80490a9:	e8 39 05 00 00       	call   80495e7 <phase_defused>
 80490ae:	83 c4 14             	add    $0x14,%esp
 80490b1:	5b                   	pop    %ebx
 80490b2:	5d                   	pop    %ebp
 80490b3:	c3                   	ret    
 80490b4:	66 90                	xchg   %ax,%ax
 80490b6:	66 90                	xchg   %ax,%ax
 80490b8:	66 90                	xchg   %ax,%ax
 80490ba:	66 90                	xchg   %ax,%ax
 80490bc:	66 90                	xchg   %ax,%ax
 80490be:	66 90                	xchg   %ax,%ax

080490c0 <sig_handler>:
 80490c0:	55                   	push   %ebp
 80490c1:	89 e5                	mov    %esp,%ebp
 80490c3:	83 ec 18             	sub    $0x18,%esp
 80490c6:	c7 04 24 c4 a5 04 08 	movl   $0x804a5c4,(%esp)
 80490cd:	e8 7e f7 ff ff       	call   8048850 <puts@plt>
 80490d2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 80490d9:	e8 12 f7 ff ff       	call   80487f0 <sleep@plt>
 80490de:	c7 44 24 04 49 a7 04 	movl   $0x804a749,0x4(%esp)
 80490e5:	08 
 80490e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80490ed:	e8 0e f8 ff ff       	call   8048900 <__printf_chk@plt>
 80490f2:	a1 00 c8 04 08       	mov    0x804c800,%eax
 80490f7:	89 04 24             	mov    %eax,(%esp)
 80490fa:	e8 c1 f6 ff ff       	call   80487c0 <fflush@plt>
 80490ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8049106:	e8 e5 f6 ff ff       	call   80487f0 <sleep@plt>
 804910b:	c7 04 24 51 a7 04 08 	movl   $0x804a751,(%esp)
 8049112:	e8 39 f7 ff ff       	call   8048850 <puts@plt>
 8049117:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 804911e:	e8 6d f7 ff ff       	call   8048890 <exit@plt>

08049123 <invalid_phase>:
 8049123:	55                   	push   %ebp
 8049124:	89 e5                	mov    %esp,%ebp
 8049126:	83 ec 18             	sub    $0x18,%esp
 8049129:	8b 45 08             	mov    0x8(%ebp),%eax
 804912c:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049130:	c7 44 24 04 59 a7 04 	movl   $0x804a759,0x4(%esp)
 8049137:	08 
 8049138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804913f:	e8 bc f7 ff ff       	call   8048900 <__printf_chk@plt>
 8049144:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 804914b:	e8 40 f7 ff ff       	call   8048890 <exit@plt>

08049150 <string_length>:
 8049150:	55                   	push   %ebp
 8049151:	89 e5                	mov    %esp,%ebp
 8049153:	8b 55 08             	mov    0x8(%ebp),%edx
 8049156:	80 3a 00             	cmpb   $0x0,(%edx)
 8049159:	74 10                	je     804916b <string_length+0x1b>
 804915b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049160:	83 c0 01             	add    $0x1,%eax
 8049163:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 8049167:	75 f7                	jne    8049160 <string_length+0x10>
 8049169:	eb 05                	jmp    8049170 <string_length+0x20>
 804916b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049170:	5d                   	pop    %ebp
 8049171:	c3                   	ret    

08049172 <strings_not_equal>:
 8049172:	55                   	push   %ebp
 8049173:	89 e5                	mov    %esp,%ebp
 8049175:	57                   	push   %edi
 8049176:	56                   	push   %esi
 8049177:	53                   	push   %ebx
 8049178:	83 ec 04             	sub    $0x4,%esp
 804917b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804917e:	8b 75 0c             	mov    0xc(%ebp),%esi
 8049181:	89 1c 24             	mov    %ebx,(%esp)
 8049184:	e8 c7 ff ff ff       	call   8049150 <string_length>
 8049189:	89 c7                	mov    %eax,%edi
 804918b:	89 34 24             	mov    %esi,(%esp)
 804918e:	e8 bd ff ff ff       	call   8049150 <string_length>
 8049193:	ba 01 00 00 00       	mov    $0x1,%edx
 8049198:	39 c7                	cmp    %eax,%edi
 804919a:	75 3d                	jne    80491d9 <strings_not_equal+0x67>
 804919c:	0f b6 03             	movzbl (%ebx),%eax
 804919f:	84 c0                	test   %al,%al
 80491a1:	74 23                	je     80491c6 <strings_not_equal+0x54>
 80491a3:	3a 06                	cmp    (%esi),%al
 80491a5:	74 0b                	je     80491b2 <strings_not_equal+0x40>
 80491a7:	eb 24                	jmp    80491cd <strings_not_equal+0x5b>
 80491a9:	3a 06                	cmp    (%esi),%al
 80491ab:	90                   	nop
 80491ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 80491b0:	75 22                	jne    80491d4 <strings_not_equal+0x62>
 80491b2:	83 c3 01             	add    $0x1,%ebx
 80491b5:	83 c6 01             	add    $0x1,%esi
 80491b8:	0f b6 03             	movzbl (%ebx),%eax
 80491bb:	84 c0                	test   %al,%al
 80491bd:	75 ea                	jne    80491a9 <strings_not_equal+0x37>
 80491bf:	ba 00 00 00 00       	mov    $0x0,%edx
 80491c4:	eb 13                	jmp    80491d9 <strings_not_equal+0x67>
 80491c6:	ba 00 00 00 00       	mov    $0x0,%edx
 80491cb:	eb 0c                	jmp    80491d9 <strings_not_equal+0x67>
 80491cd:	ba 01 00 00 00       	mov    $0x1,%edx
 80491d2:	eb 05                	jmp    80491d9 <strings_not_equal+0x67>
 80491d4:	ba 01 00 00 00       	mov    $0x1,%edx
 80491d9:	89 d0                	mov    %edx,%eax
 80491db:	83 c4 04             	add    $0x4,%esp
 80491de:	5b                   	pop    %ebx
 80491df:	5e                   	pop    %esi
 80491e0:	5f                   	pop    %edi
 80491e1:	5d                   	pop    %ebp
 80491e2:	c3                   	ret    

080491e3 <initialize_bomb>:
 80491e3:	55                   	push   %ebp
 80491e4:	89 e5                	mov    %esp,%ebp
 80491e6:	56                   	push   %esi
 80491e7:	53                   	push   %ebx
 80491e8:	81 ec 60 20 00 00    	sub    $0x2060,%esp
 80491ee:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 80491f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80491f7:	31 c0                	xor    %eax,%eax
 80491f9:	c7 44 24 04 c0 90 04 	movl   $0x80490c0,0x4(%esp)
 8049200:	08 
 8049201:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049208:	e8 d3 f5 ff ff       	call   80487e0 <signal@plt>
 804920d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
 8049214:	00 
 8049215:	8d 85 b4 df ff ff    	lea    -0x204c(%ebp),%eax
 804921b:	89 04 24             	mov    %eax,(%esp)
 804921e:	e8 0d f6 ff ff       	call   8048830 <gethostname@plt>
 8049223:	85 c0                	test   %eax,%eax
 8049225:	75 16                	jne    804923d <initialize_bomb+0x5a>
 8049227:	a1 e0 c5 04 08       	mov    0x804c5e0,%eax
 804922c:	bb 00 00 00 00       	mov    $0x0,%ebx
 8049231:	8d b5 b4 df ff ff    	lea    -0x204c(%ebp),%esi
 8049237:	85 c0                	test   %eax,%eax
 8049239:	75 1a                	jne    8049255 <initialize_bomb+0x72>
 804923b:	eb 36                	jmp    8049273 <initialize_bomb+0x90>
 804923d:	c7 04 24 fc a5 04 08 	movl   $0x804a5fc,(%esp)
 8049244:	e8 07 f6 ff ff       	call   8048850 <puts@plt>
 8049249:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049250:	e8 3b f6 ff ff       	call   8048890 <exit@plt>
 8049255:	89 74 24 04          	mov    %esi,0x4(%esp)
 8049259:	89 04 24             	mov    %eax,(%esp)
 804925c:	e8 5f f6 ff ff       	call   80488c0 <strcasecmp@plt>
 8049261:	85 c0                	test   %eax,%eax
 8049263:	74 0e                	je     8049273 <initialize_bomb+0x90>
 8049265:	83 c3 01             	add    $0x1,%ebx
 8049268:	8b 04 9d e0 c5 04 08 	mov    0x804c5e0(,%ebx,4),%eax
 804926f:	85 c0                	test   %eax,%eax
 8049271:	75 e2                	jne    8049255 <initialize_bomb+0x72>
 8049273:	8d 85 f4 df ff ff    	lea    -0x200c(%ebp),%eax
 8049279:	89 04 24             	mov    %eax,(%esp)
 804927c:	e8 46 0e 00 00       	call   804a0c7 <init_driver>
 8049281:	85 c0                	test   %eax,%eax
 8049283:	79 2a                	jns    80492af <initialize_bomb+0xcc>
 8049285:	8d 85 f4 df ff ff    	lea    -0x200c(%ebp),%eax
 804928b:	89 44 24 08          	mov    %eax,0x8(%esp)
 804928f:	c7 44 24 04 6a a7 04 	movl   $0x804a76a,0x4(%esp)
 8049296:	08 
 8049297:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804929e:	e8 5d f6 ff ff       	call   8048900 <__printf_chk@plt>
 80492a3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 80492aa:	e8 e1 f5 ff ff       	call   8048890 <exit@plt>
 80492af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80492b2:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
 80492b9:	74 05                	je     80492c0 <initialize_bomb+0xdd>
 80492bb:	e8 50 f5 ff ff       	call   8048810 <__stack_chk_fail@plt>
 80492c0:	81 c4 60 20 00 00    	add    $0x2060,%esp
 80492c6:	5b                   	pop    %ebx
 80492c7:	5e                   	pop    %esi
 80492c8:	5d                   	pop    %ebp
 80492c9:	c3                   	ret    

080492ca <initialize_bomb_solve>:
 80492ca:	55                   	push   %ebp
 80492cb:	89 e5                	mov    %esp,%ebp
 80492cd:	5d                   	pop    %ebp
 80492ce:	c3                   	ret    

080492cf <blank_line>:
 80492cf:	55                   	push   %ebp
 80492d0:	89 e5                	mov    %esp,%ebp
 80492d2:	56                   	push   %esi
 80492d3:	53                   	push   %ebx
 80492d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80492d7:	eb 16                	jmp    80492ef <blank_line+0x20>
 80492d9:	e8 92 f6 ff ff       	call   8048970 <__ctype_b_loc@plt>
 80492de:	83 c3 01             	add    $0x1,%ebx
 80492e1:	89 f2                	mov    %esi,%edx
 80492e3:	0f be f2             	movsbl %dl,%esi
 80492e6:	8b 00                	mov    (%eax),%eax
 80492e8:	f6 44 70 01 20       	testb  $0x20,0x1(%eax,%esi,2)
 80492ed:	74 10                	je     80492ff <blank_line+0x30>
 80492ef:	0f b6 33             	movzbl (%ebx),%esi
 80492f2:	89 f0                	mov    %esi,%eax
 80492f4:	84 c0                	test   %al,%al
 80492f6:	75 e1                	jne    80492d9 <blank_line+0xa>
 80492f8:	b8 01 00 00 00       	mov    $0x1,%eax
 80492fd:	eb 05                	jmp    8049304 <blank_line+0x35>
 80492ff:	b8 00 00 00 00       	mov    $0x0,%eax
 8049304:	5b                   	pop    %ebx
 8049305:	5e                   	pop    %esi
 8049306:	5d                   	pop    %ebp
 8049307:	c3                   	ret    

08049308 <skip>:
 8049308:	55                   	push   %ebp
 8049309:	89 e5                	mov    %esp,%ebp
 804930b:	53                   	push   %ebx
 804930c:	83 ec 14             	sub    $0x14,%esp
 804930f:	a1 0c c8 04 08       	mov    0x804c80c,%eax
 8049314:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049318:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
 804931f:	00 
 8049320:	a1 08 c8 04 08       	mov    0x804c808,%eax
 8049325:	8d 04 80             	lea    (%eax,%eax,4),%eax
 8049328:	c1 e0 04             	shl    $0x4,%eax
 804932b:	05 20 c8 04 08       	add    $0x804c820,%eax
 8049330:	89 04 24             	mov    %eax,(%esp)
 8049333:	e8 98 f4 ff ff       	call   80487d0 <fgets@plt>
 8049338:	89 c3                	mov    %eax,%ebx
 804933a:	85 c0                	test   %eax,%eax
 804933c:	74 0c                	je     804934a <skip+0x42>
 804933e:	89 04 24             	mov    %eax,(%esp)
 8049341:	e8 89 ff ff ff       	call   80492cf <blank_line>
 8049346:	85 c0                	test   %eax,%eax
 8049348:	75 c5                	jne    804930f <skip+0x7>
 804934a:	89 d8                	mov    %ebx,%eax
 804934c:	83 c4 14             	add    $0x14,%esp
 804934f:	5b                   	pop    %ebx
 8049350:	5d                   	pop    %ebp
 8049351:	c3                   	ret    

08049352 <send_msg>:
 8049352:	55                   	push   %ebp
 8049353:	89 e5                	mov    %esp,%ebp
 8049355:	57                   	push   %edi
 8049356:	53                   	push   %ebx
 8049357:	81 ec 30 40 00 00    	sub    $0x4030,%esp
 804935d:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 8049363:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049366:	31 c0                	xor    %eax,%eax
 8049368:	8b 15 08 c8 04 08    	mov    0x804c808,%edx
 804936e:	8d 5c 92 fb          	lea    -0x5(%edx,%edx,4),%ebx
 8049372:	c1 e3 04             	shl    $0x4,%ebx
 8049375:	81 c3 20 c8 04 08    	add    $0x804c820,%ebx
 804937b:	89 df                	mov    %ebx,%edi
 804937d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049382:	f2 ae                	repnz scas %es:(%edi),%al
 8049384:	f7 d1                	not    %ecx
 8049386:	83 c1 63             	add    $0x63,%ecx
 8049389:	81 f9 00 20 00 00    	cmp    $0x2000,%ecx
 804938f:	76 20                	jbe    80493b1 <send_msg+0x5f>
 8049391:	c7 44 24 04 34 a6 04 	movl   $0x804a634,0x4(%esp)
 8049398:	08 
 8049399:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80493a0:	e8 5b f5 ff ff       	call   8048900 <__printf_chk@plt>
 80493a5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 80493ac:	e8 df f4 ff ff       	call   8048890 <exit@plt>
 80493b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 80493b5:	b8 84 a7 04 08       	mov    $0x804a784,%eax
 80493ba:	b9 8c a7 04 08       	mov    $0x804a78c,%ecx
 80493bf:	0f 44 c1             	cmove  %ecx,%eax
 80493c2:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
 80493c6:	89 54 24 18          	mov    %edx,0x18(%esp)
 80493ca:	89 44 24 14          	mov    %eax,0x14(%esp)
 80493ce:	a1 c0 c5 04 08       	mov    0x804c5c0,%eax
 80493d3:	89 44 24 10          	mov    %eax,0x10(%esp)
 80493d7:	c7 44 24 0c 95 a7 04 	movl   $0x804a795,0xc(%esp)
 80493de:	08 
 80493df:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 80493e6:	00 
 80493e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 80493ee:	00 
 80493ef:	8d 9d f4 bf ff ff    	lea    -0x400c(%ebp),%ebx
 80493f5:	89 1c 24             	mov    %ebx,(%esp)
 80493f8:	e8 83 f5 ff ff       	call   8048980 <__sprintf_chk@plt>
 80493fd:	8d 85 f4 df ff ff    	lea    -0x200c(%ebp),%eax
 8049403:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049407:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 804940e:	00 
 804940f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8049413:	c7 04 24 c0 c1 04 08 	movl   $0x804c1c0,(%esp)
 804941a:	e8 af 0e 00 00       	call   804a2ce <driver_post>
 804941f:	85 c0                	test   %eax,%eax
 8049421:	79 1a                	jns    804943d <send_msg+0xeb>
 8049423:	8d 85 f4 df ff ff    	lea    -0x200c(%ebp),%eax
 8049429:	89 04 24             	mov    %eax,(%esp)
 804942c:	e8 1f f4 ff ff       	call   8048850 <puts@plt>
 8049431:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8049438:	e8 53 f4 ff ff       	call   8048890 <exit@plt>
 804943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049440:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
 8049447:	74 05                	je     804944e <send_msg+0xfc>
 8049449:	e8 c2 f3 ff ff       	call   8048810 <__stack_chk_fail@plt>
 804944e:	81 c4 30 40 00 00    	add    $0x4030,%esp
 8049454:	5b                   	pop    %ebx
 8049455:	5f                   	pop    %edi
 8049456:	5d                   	pop    %ebp
 8049457:	c3                   	ret    

08049458 <explode_bomb>:
 8049458:	55                   	push   %ebp
 8049459:	89 e5                	mov    %esp,%ebp
 804945b:	83 ec 18             	sub    $0x18,%esp
 804945e:	c7 04 24 a1 a7 04 08 	movl   $0x804a7a1,(%esp)
 8049465:	e8 e6 f3 ff ff       	call   8048850 <puts@plt>
 804946a:	c7 04 24 aa a7 04 08 	movl   $0x804a7aa,(%esp)
 8049471:	e8 da f3 ff ff       	call   8048850 <puts@plt>
 8049476:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 804947d:	e8 d0 fe ff ff       	call   8049352 <send_msg>
 8049482:	c7 04 24 58 a6 04 08 	movl   $0x804a658,(%esp)
 8049489:	e8 c2 f3 ff ff       	call   8048850 <puts@plt>
 804948e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049495:	e8 f6 f3 ff ff       	call   8048890 <exit@plt>

0804949a <read_six_numbers>:
 804949a:	55                   	push   %ebp
 804949b:	89 e5                	mov    %esp,%ebp
 804949d:	83 ec 28             	sub    $0x28,%esp
 80494a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 80494a3:	8d 50 14             	lea    0x14(%eax),%edx
 80494a6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
 80494aa:	8d 50 10             	lea    0x10(%eax),%edx
 80494ad:	89 54 24 18          	mov    %edx,0x18(%esp)
 80494b1:	8d 50 0c             	lea    0xc(%eax),%edx
 80494b4:	89 54 24 14          	mov    %edx,0x14(%esp)
 80494b8:	8d 50 08             	lea    0x8(%eax),%edx
 80494bb:	89 54 24 10          	mov    %edx,0x10(%esp)
 80494bf:	8d 50 04             	lea    0x4(%eax),%edx
 80494c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80494c6:	89 44 24 08          	mov    %eax,0x8(%esp)
 80494ca:	c7 44 24 04 c1 a7 04 	movl   $0x804a7c1,0x4(%esp)
 80494d1:	08 
 80494d2:	8b 45 08             	mov    0x8(%ebp),%eax
 80494d5:	89 04 24             	mov    %eax,(%esp)
 80494d8:	e8 f3 f3 ff ff       	call   80488d0 <__isoc99_sscanf@plt>
 80494dd:	83 f8 05             	cmp    $0x5,%eax
 80494e0:	7f 05                	jg     80494e7 <read_six_numbers+0x4d>
 80494e2:	e8 71 ff ff ff       	call   8049458 <explode_bomb>
 80494e7:	c9                   	leave  
 80494e8:	c3                   	ret    

080494e9 <read_line>:
 80494e9:	55                   	push   %ebp
 80494ea:	89 e5                	mov    %esp,%ebp
 80494ec:	57                   	push   %edi
 80494ed:	56                   	push   %esi
 80494ee:	53                   	push   %ebx
 80494ef:	83 ec 1c             	sub    $0x1c,%esp
 80494f2:	e8 11 fe ff ff       	call   8049308 <skip>
 80494f7:	85 c0                	test   %eax,%eax
 80494f9:	75 6c                	jne    8049567 <read_line+0x7e>
 80494fb:	a1 e4 c7 04 08       	mov    0x804c7e4,%eax
 8049500:	39 05 0c c8 04 08    	cmp    %eax,0x804c80c
 8049506:	75 18                	jne    8049520 <read_line+0x37>
 8049508:	c7 04 24 d3 a7 04 08 	movl   $0x804a7d3,(%esp)
 804950f:	e8 3c f3 ff ff       	call   8048850 <puts@plt>
 8049514:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 804951b:	e8 70 f3 ff ff       	call   8048890 <exit@plt>
 8049520:	c7 04 24 f1 a7 04 08 	movl   $0x804a7f1,(%esp)
 8049527:	e8 14 f3 ff ff       	call   8048840 <getenv@plt>
 804952c:	85 c0                	test   %eax,%eax
 804952e:	74 0c                	je     804953c <read_line+0x53>
 8049530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8049537:	e8 54 f3 ff ff       	call   8048890 <exit@plt>
 804953c:	a1 e4 c7 04 08       	mov    0x804c7e4,%eax
 8049541:	a3 0c c8 04 08       	mov    %eax,0x804c80c
 8049546:	e8 bd fd ff ff       	call   8049308 <skip>
 804954b:	85 c0                	test   %eax,%eax
 804954d:	75 18                	jne    8049567 <read_line+0x7e>
 804954f:	c7 04 24 d3 a7 04 08 	movl   $0x804a7d3,(%esp)
 8049556:	e8 f5 f2 ff ff       	call   8048850 <puts@plt>
 804955b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8049562:	e8 29 f3 ff ff       	call   8048890 <exit@plt>
 8049567:	8b 15 08 c8 04 08    	mov    0x804c808,%edx
 804956d:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 8049570:	c1 e3 04             	shl    $0x4,%ebx
 8049573:	81 c3 20 c8 04 08    	add    $0x804c820,%ebx
 8049579:	89 df                	mov    %ebx,%edi
 804957b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049580:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049585:	f2 ae                	repnz scas %es:(%edi),%al
 8049587:	f7 d1                	not    %ecx
 8049589:	83 e9 01             	sub    $0x1,%ecx
 804958c:	83 f9 4e             	cmp    $0x4e,%ecx
 804958f:	7e 35                	jle    80495c6 <read_line+0xdd>
 8049591:	c7 04 24 fc a7 04 08 	movl   $0x804a7fc,(%esp)
 8049598:	e8 b3 f2 ff ff       	call   8048850 <puts@plt>
 804959d:	a1 08 c8 04 08       	mov    0x804c808,%eax
 80495a2:	8d 50 01             	lea    0x1(%eax),%edx
 80495a5:	89 15 08 c8 04 08    	mov    %edx,0x804c808
 80495ab:	6b c0 50             	imul   $0x50,%eax,%eax
 80495ae:	05 20 c8 04 08       	add    $0x804c820,%eax
 80495b3:	be 17 a8 04 08       	mov    $0x804a817,%esi
 80495b8:	b9 04 00 00 00       	mov    $0x4,%ecx
 80495bd:	89 c7                	mov    %eax,%edi
 80495bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 80495c1:	e8 92 fe ff ff       	call   8049458 <explode_bomb>
 80495c6:	8d 04 92             	lea    (%edx,%edx,4),%eax
 80495c9:	c1 e0 04             	shl    $0x4,%eax
 80495cc:	c6 84 01 1f c8 04 08 	movb   $0x0,0x804c81f(%ecx,%eax,1)
 80495d3:	00 
 80495d4:	83 c2 01             	add    $0x1,%edx
 80495d7:	89 15 08 c8 04 08    	mov    %edx,0x804c808
 80495dd:	89 d8                	mov    %ebx,%eax
 80495df:	83 c4 1c             	add    $0x1c,%esp
 80495e2:	5b                   	pop    %ebx
 80495e3:	5e                   	pop    %esi
 80495e4:	5f                   	pop    %edi
 80495e5:	5d                   	pop    %ebp
 80495e6:	c3                   	ret    

080495e7 <phase_defused>:
 80495e7:	55                   	push   %ebp
 80495e8:	89 e5                	mov    %esp,%ebp
 80495ea:	81 ec 88 00 00 00    	sub    $0x88,%esp
 80495f0:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 80495f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80495f9:	31 c0                	xor    %eax,%eax
 80495fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8049602:	e8 4b fd ff ff       	call   8049352 <send_msg>
 8049607:	83 3d 08 c8 04 08 06 	cmpl   $0x6,0x804c808
 804960e:	75 7a                	jne    804968a <phase_defused+0xa3>
 8049610:	8d 45 a4             	lea    -0x5c(%ebp),%eax
 8049613:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049617:	8d 45 a0             	lea    -0x60(%ebp),%eax
 804961a:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804961e:	8d 45 9c             	lea    -0x64(%ebp),%eax
 8049621:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049625:	c7 44 24 04 27 a8 04 	movl   $0x804a827,0x4(%esp)
 804962c:	08 
 804962d:	c7 04 24 10 c9 04 08 	movl   $0x804c910,(%esp)
 8049634:	e8 97 f2 ff ff       	call   80488d0 <__isoc99_sscanf@plt>
 8049639:	83 f8 03             	cmp    $0x3,%eax
 804963c:	75 34                	jne    8049672 <phase_defused+0x8b>
 804963e:	c7 44 24 04 30 a8 04 	movl   $0x804a830,0x4(%esp)
 8049645:	08 
 8049646:	8d 45 a4             	lea    -0x5c(%ebp),%eax
 8049649:	89 04 24             	mov    %eax,(%esp)
 804964c:	e8 21 fb ff ff       	call   8049172 <strings_not_equal>
 8049651:	85 c0                	test   %eax,%eax
 8049653:	75 1d                	jne    8049672 <phase_defused+0x8b>
 8049655:	c7 04 24 7c a6 04 08 	movl   $0x804a67c,(%esp)
 804965c:	e8 ef f1 ff ff       	call   8048850 <puts@plt>
 8049661:	c7 04 24 a4 a6 04 08 	movl   $0x804a6a4,(%esp)
 8049668:	e8 e3 f1 ff ff       	call   8048850 <puts@plt>
 804966d:	e8 dc f9 ff ff       	call   804904e <secret_phase>
 8049672:	c7 04 24 dc a6 04 08 	movl   $0x804a6dc,(%esp)
 8049679:	e8 d2 f1 ff ff       	call   8048850 <puts@plt>
 804967e:	c7 04 24 08 a7 04 08 	movl   $0x804a708,(%esp)
 8049685:	e8 c6 f1 ff ff       	call   8048850 <puts@plt>
 804968a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804968d:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
 8049694:	74 05                	je     804969b <phase_defused+0xb4>
 8049696:	e8 75 f1 ff ff       	call   8048810 <__stack_chk_fail@plt>
 804969b:	c9                   	leave  
 804969c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 80496a0:	c3                   	ret    
 80496a1:	66 90                	xchg   %ax,%ax
 80496a3:	66 90                	xchg   %ax,%ax
 80496a5:	66 90                	xchg   %ax,%ax
 80496a7:	66 90                	xchg   %ax,%ax
 80496a9:	66 90                	xchg   %ax,%ax
 80496ab:	66 90                	xchg   %ax,%ax
 80496ad:	66 90                	xchg   %ax,%ax
 80496af:	90                   	nop

080496b0 <sigalrm_handler>:
 80496b0:	55                   	push   %ebp
 80496b1:	89 e5                	mov    %esp,%ebp
 80496b3:	83 ec 18             	sub    $0x18,%esp
 80496b6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 80496bd:	00 
 80496be:	c7 44 24 08 84 a8 04 	movl   $0x804a884,0x8(%esp)
 80496c5:	08 
 80496c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 80496cd:	00 
 80496ce:	a1 e0 c7 04 08       	mov    0x804c7e0,%eax
 80496d3:	89 04 24             	mov    %eax,(%esp)
 80496d6:	e8 45 f2 ff ff       	call   8048920 <__fprintf_chk@plt>
 80496db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80496e2:	e8 a9 f1 ff ff       	call   8048890 <exit@plt>

080496e7 <rio_readlineb>:
 80496e7:	55                   	push   %ebp
 80496e8:	89 e5                	mov    %esp,%ebp
 80496ea:	57                   	push   %edi
 80496eb:	56                   	push   %esi
 80496ec:	53                   	push   %ebx
 80496ed:	83 ec 4c             	sub    $0x4c,%esp
 80496f0:	89 55 d0             	mov    %edx,-0x30(%ebp)
 80496f3:	83 f9 01             	cmp    $0x1,%ecx
 80496f6:	0f 86 c8 00 00 00    	jbe    80497c4 <rio_readlineb+0xdd>
 80496fc:	89 c3                	mov    %eax,%ebx
 80496fe:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 8049701:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 8049708:	8d 78 0c             	lea    0xc(%eax),%edi
 804970b:	eb 38                	jmp    8049745 <rio_readlineb+0x5e>
 804970d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049714:	00 
 8049715:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8049719:	8b 03                	mov    (%ebx),%eax
 804971b:	89 04 24             	mov    %eax,(%esp)
 804971e:	e8 8d f0 ff ff       	call   80487b0 <read@plt>
 8049723:	89 43 04             	mov    %eax,0x4(%ebx)
 8049726:	85 c0                	test   %eax,%eax
 8049728:	79 0f                	jns    8049739 <rio_readlineb+0x52>
 804972a:	e8 c1 f1 ff ff       	call   80488f0 <__errno_location@plt>
 804972f:	83 38 04             	cmpl   $0x4,(%eax)
 8049732:	74 11                	je     8049745 <rio_readlineb+0x5e>
 8049734:	e9 9d 00 00 00       	jmp    80497d6 <rio_readlineb+0xef>
 8049739:	85 c0                	test   %eax,%eax
 804973b:	90                   	nop
 804973c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8049740:	74 6a                	je     80497ac <rio_readlineb+0xc5>
 8049742:	89 7b 08             	mov    %edi,0x8(%ebx)
 8049745:	8b 73 04             	mov    0x4(%ebx),%esi
 8049748:	85 f6                	test   %esi,%esi
 804974a:	7e c1                	jle    804970d <rio_readlineb+0x26>
 804974c:	85 f6                	test   %esi,%esi
 804974e:	0f 95 c0             	setne  %al
 8049751:	0f b6 c0             	movzbl %al,%eax
 8049754:	89 45 cc             	mov    %eax,-0x34(%ebp)
 8049757:	8b 4b 08             	mov    0x8(%ebx),%ecx
 804975a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8049761:	00 
 8049762:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049766:	89 4d c8             	mov    %ecx,-0x38(%ebp)
 8049769:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 804976d:	8d 55 e7             	lea    -0x19(%ebp),%edx
 8049770:	89 14 24             	mov    %edx,(%esp)
 8049773:	e8 f8 f0 ff ff       	call   8048870 <__memcpy_chk@plt>
 8049778:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 804977b:	8b 55 cc             	mov    -0x34(%ebp),%edx
 804977e:	01 d1                	add    %edx,%ecx
 8049780:	89 4b 08             	mov    %ecx,0x8(%ebx)
 8049783:	29 d6                	sub    %edx,%esi
 8049785:	89 73 04             	mov    %esi,0x4(%ebx)
 8049788:	83 fa 01             	cmp    $0x1,%edx
 804978b:	75 14                	jne    80497a1 <rio_readlineb+0xba>
 804978d:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 8049791:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 8049795:	8b 55 d0             	mov    -0x30(%ebp),%edx
 8049798:	88 42 ff             	mov    %al,-0x1(%edx)
 804979b:	3c 0a                	cmp    $0xa,%al
 804979d:	75 17                	jne    80497b6 <rio_readlineb+0xcf>
 804979f:	eb 2a                	jmp    80497cb <rio_readlineb+0xe4>
 80497a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
 80497a5:	75 36                	jne    80497dd <rio_readlineb+0xf6>
 80497a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 80497aa:	eb 03                	jmp    80497af <rio_readlineb+0xc8>
 80497ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 80497af:	83 f8 01             	cmp    $0x1,%eax
 80497b2:	75 17                	jne    80497cb <rio_readlineb+0xe4>
 80497b4:	eb 2e                	jmp    80497e4 <rio_readlineb+0xfd>
 80497b6:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 80497ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 80497bd:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
 80497c0:	74 09                	je     80497cb <rio_readlineb+0xe4>
 80497c2:	eb 81                	jmp    8049745 <rio_readlineb+0x5e>
 80497c4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 80497cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80497ce:	c6 00 00             	movb   $0x0,(%eax)
 80497d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 80497d4:	eb 13                	jmp    80497e9 <rio_readlineb+0x102>
 80497d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80497db:	eb 0c                	jmp    80497e9 <rio_readlineb+0x102>
 80497dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80497e2:	eb 05                	jmp    80497e9 <rio_readlineb+0x102>
 80497e4:	b8 00 00 00 00       	mov    $0x0,%eax
 80497e9:	83 c4 4c             	add    $0x4c,%esp
 80497ec:	5b                   	pop    %ebx
 80497ed:	5e                   	pop    %esi
 80497ee:	5f                   	pop    %edi
 80497ef:	5d                   	pop    %ebp
 80497f0:	c3                   	ret    

080497f1 <submitr>:
 80497f1:	55                   	push   %ebp
 80497f2:	89 e5                	mov    %esp,%ebp
 80497f4:	57                   	push   %edi
 80497f5:	56                   	push   %esi
 80497f6:	53                   	push   %ebx
 80497f7:	81 ec 7c a0 00 00    	sub    $0xa07c,%esp
 80497fd:	8b 75 08             	mov    0x8(%ebp),%esi
 8049800:	8b 45 10             	mov    0x10(%ebp),%eax
 8049803:	89 85 b0 5f ff ff    	mov    %eax,-0xa050(%ebp)
 8049809:	8b 45 14             	mov    0x14(%ebp),%eax
 804980c:	89 85 ac 5f ff ff    	mov    %eax,-0xa054(%ebp)
 8049812:	8b 45 18             	mov    0x18(%ebp),%eax
 8049815:	89 85 a8 5f ff ff    	mov    %eax,-0xa058(%ebp)
 804981b:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
 804981e:	8b 45 20             	mov    0x20(%ebp),%eax
 8049821:	89 85 a4 5f ff ff    	mov    %eax,-0xa05c(%ebp)
 8049827:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 804982d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8049830:	31 c0                	xor    %eax,%eax
 8049832:	c7 85 c4 5f ff ff 00 	movl   $0x0,-0xa03c(%ebp)
 8049839:	00 00 00 
 804983c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049843:	00 
 8049844:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804984b:	00 
 804984c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049853:	e8 b8 f0 ff ff       	call   8048910 <socket@plt>
 8049858:	89 85 b4 5f ff ff    	mov    %eax,-0xa04c(%ebp)
 804985e:	85 c0                	test   %eax,%eax
 8049860:	79 54                	jns    80498b6 <submitr+0xc5>
 8049862:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049868:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 804986e:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049875:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 804987c:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049883:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 804988a:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049891:	c7 40 18 63 72 65 61 	movl   $0x61657263,0x18(%eax)
 8049898:	c7 40 1c 74 65 20 73 	movl   $0x73206574,0x1c(%eax)
 804989f:	c7 40 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%eax)
 80498a6:	66 c7 40 24 74 00    	movw   $0x74,0x24(%eax)
 80498ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80498b1:	e9 b2 06 00 00       	jmp    8049f68 <submitr+0x777>
 80498b6:	89 34 24             	mov    %esi,(%esp)
 80498b9:	e8 72 f0 ff ff       	call   8048930 <gethostbyname@plt>
 80498be:	85 c0                	test   %eax,%eax
 80498c0:	75 74                	jne    8049936 <submitr+0x145>
 80498c2:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 80498c8:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80498ce:	c7 40 04 72 3a 20 44 	movl   $0x44203a72,0x4(%eax)
 80498d5:	c7 40 08 4e 53 20 69 	movl   $0x6920534e,0x8(%eax)
 80498dc:	c7 40 0c 73 20 75 6e 	movl   $0x6e752073,0xc(%eax)
 80498e3:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 80498ea:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 80498f1:	c7 40 18 72 65 73 6f 	movl   $0x6f736572,0x18(%eax)
 80498f8:	c7 40 1c 6c 76 65 20 	movl   $0x2065766c,0x1c(%eax)
 80498ff:	c7 40 20 73 65 72 76 	movl   $0x76726573,0x20(%eax)
 8049906:	c7 40 24 65 72 20 61 	movl   $0x61207265,0x24(%eax)
 804990d:	c7 40 28 64 64 72 65 	movl   $0x65726464,0x28(%eax)
 8049914:	66 c7 40 2c 73 73    	movw   $0x7373,0x2c(%eax)
 804991a:	c6 40 2e 00          	movb   $0x0,0x2e(%eax)
 804991e:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049924:	89 04 24             	mov    %eax,(%esp)
 8049927:	e8 34 f0 ff ff       	call   8048960 <close@plt>
 804992c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049931:	e9 32 06 00 00       	jmp    8049f68 <submitr+0x777>
 8049936:	8d b5 c8 5f ff ff    	lea    -0xa038(%ebp),%esi
 804993c:	c7 85 c8 5f ff ff 00 	movl   $0x0,-0xa038(%ebp)
 8049943:	00 00 00 
 8049946:	c7 85 cc 5f ff ff 00 	movl   $0x0,-0xa034(%ebp)
 804994d:	00 00 00 
 8049950:	c7 85 d0 5f ff ff 00 	movl   $0x0,-0xa030(%ebp)
 8049957:	00 00 00 
 804995a:	c7 85 d4 5f ff ff 00 	movl   $0x0,-0xa02c(%ebp)
 8049961:	00 00 00 
 8049964:	66 c7 85 c8 5f ff ff 	movw   $0x2,-0xa038(%ebp)
 804996b:	02 00 
 804996d:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
 8049974:	00 
 8049975:	8b 50 0c             	mov    0xc(%eax),%edx
 8049978:	89 54 24 08          	mov    %edx,0x8(%esp)
 804997c:	8b 40 10             	mov    0x10(%eax),%eax
 804997f:	8b 00                	mov    (%eax),%eax
 8049981:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049985:	8d 85 cc 5f ff ff    	lea    -0xa034(%ebp),%eax
 804998b:	89 04 24             	mov    %eax,(%esp)
 804998e:	e8 cd ee ff ff       	call   8048860 <__memmove_chk@plt>
 8049993:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
 8049997:	66 c1 c8 08          	ror    $0x8,%ax
 804999b:	66 89 85 ca 5f ff ff 	mov    %ax,-0xa036(%ebp)
 80499a2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 80499a9:	00 
 80499aa:	89 74 24 04          	mov    %esi,0x4(%esp)
 80499ae:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 80499b4:	89 04 24             	mov    %eax,(%esp)
 80499b7:	e8 94 ef ff ff       	call   8048950 <connect@plt>
 80499bc:	85 c0                	test   %eax,%eax
 80499be:	79 66                	jns    8049a26 <submitr+0x235>
 80499c0:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 80499c6:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80499cc:	c7 40 04 72 3a 20 55 	movl   $0x55203a72,0x4(%eax)
 80499d3:	c7 40 08 6e 61 62 6c 	movl   $0x6c62616e,0x8(%eax)
 80499da:	c7 40 0c 65 20 74 6f 	movl   $0x6f742065,0xc(%eax)
 80499e1:	c7 40 10 20 63 6f 6e 	movl   $0x6e6f6320,0x10(%eax)
 80499e8:	c7 40 14 6e 65 63 74 	movl   $0x7463656e,0x14(%eax)
 80499ef:	c7 40 18 20 74 6f 20 	movl   $0x206f7420,0x18(%eax)
 80499f6:	c7 40 1c 74 68 65 20 	movl   $0x20656874,0x1c(%eax)
 80499fd:	c7 40 20 73 65 72 76 	movl   $0x76726573,0x20(%eax)
 8049a04:	66 c7 40 24 65 72    	movw   $0x7265,0x24(%eax)
 8049a0a:	c6 40 26 00          	movb   $0x0,0x26(%eax)
 8049a0e:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049a14:	89 04 24             	mov    %eax,(%esp)
 8049a17:	e8 44 ef ff ff       	call   8048960 <close@plt>
 8049a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a21:	e9 42 05 00 00       	jmp    8049f68 <submitr+0x777>
 8049a26:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 8049a2b:	89 df                	mov    %ebx,%edi
 8049a2d:	b8 00 00 00 00       	mov    $0x0,%eax
 8049a32:	89 d1                	mov    %edx,%ecx
 8049a34:	f2 ae                	repnz scas %es:(%edi),%al
 8049a36:	f7 d1                	not    %ecx
 8049a38:	89 8d a0 5f ff ff    	mov    %ecx,-0xa060(%ebp)
 8049a3e:	8b bd b0 5f ff ff    	mov    -0xa050(%ebp),%edi
 8049a44:	89 d1                	mov    %edx,%ecx
 8049a46:	f2 ae                	repnz scas %es:(%edi),%al
 8049a48:	89 8d 9c 5f ff ff    	mov    %ecx,-0xa064(%ebp)
 8049a4e:	8b bd ac 5f ff ff    	mov    -0xa054(%ebp),%edi
 8049a54:	89 d1                	mov    %edx,%ecx
 8049a56:	f2 ae                	repnz scas %es:(%edi),%al
 8049a58:	89 ce                	mov    %ecx,%esi
 8049a5a:	f7 d6                	not    %esi
 8049a5c:	8b bd a8 5f ff ff    	mov    -0xa058(%ebp),%edi
 8049a62:	89 d1                	mov    %edx,%ecx
 8049a64:	f2 ae                	repnz scas %es:(%edi),%al
 8049a66:	2b b5 9c 5f ff ff    	sub    -0xa064(%ebp),%esi
 8049a6c:	29 ce                	sub    %ecx,%esi
 8049a6e:	8b 8d a0 5f ff ff    	mov    -0xa060(%ebp),%ecx
 8049a74:	8d 44 49 fd          	lea    -0x3(%ecx,%ecx,2),%eax
 8049a78:	8d 44 06 7b          	lea    0x7b(%esi,%eax,1),%eax
 8049a7c:	3d 00 20 00 00       	cmp    $0x2000,%eax
 8049a81:	76 7f                	jbe    8049b02 <submitr+0x311>
 8049a83:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049a89:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049a8f:	c7 40 04 72 3a 20 52 	movl   $0x52203a72,0x4(%eax)
 8049a96:	c7 40 08 65 73 75 6c 	movl   $0x6c757365,0x8(%eax)
 8049a9d:	c7 40 0c 74 20 73 74 	movl   $0x74732074,0xc(%eax)
 8049aa4:	c7 40 10 72 69 6e 67 	movl   $0x676e6972,0x10(%eax)
 8049aab:	c7 40 14 20 74 6f 6f 	movl   $0x6f6f7420,0x14(%eax)
 8049ab2:	c7 40 18 20 6c 61 72 	movl   $0x72616c20,0x18(%eax)
 8049ab9:	c7 40 1c 67 65 2e 20 	movl   $0x202e6567,0x1c(%eax)
 8049ac0:	c7 40 20 49 6e 63 72 	movl   $0x72636e49,0x20(%eax)
 8049ac7:	c7 40 24 65 61 73 65 	movl   $0x65736165,0x24(%eax)
 8049ace:	c7 40 28 20 53 55 42 	movl   $0x42555320,0x28(%eax)
 8049ad5:	c7 40 2c 4d 49 54 52 	movl   $0x5254494d,0x2c(%eax)
 8049adc:	c7 40 30 5f 4d 41 58 	movl   $0x58414d5f,0x30(%eax)
 8049ae3:	c7 40 34 42 55 46 00 	movl   $0x465542,0x34(%eax)
 8049aea:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049af0:	89 04 24             	mov    %eax,(%esp)
 8049af3:	e8 68 ee ff ff       	call   8048960 <close@plt>
 8049af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049afd:	e9 66 04 00 00       	jmp    8049f68 <submitr+0x777>
 8049b02:	8d 95 d8 7f ff ff    	lea    -0x8028(%ebp),%edx
 8049b08:	b9 00 08 00 00       	mov    $0x800,%ecx
 8049b0d:	b8 00 00 00 00       	mov    $0x0,%eax
 8049b12:	89 d7                	mov    %edx,%edi
 8049b14:	f3 ab                	rep stos %eax,%es:(%edi)
 8049b16:	89 df                	mov    %ebx,%edi
 8049b18:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049b1d:	f2 ae                	repnz scas %es:(%edi),%al
 8049b1f:	f7 d1                	not    %ecx
 8049b21:	83 e9 01             	sub    $0x1,%ecx
 8049b24:	89 ce                	mov    %ecx,%esi
 8049b26:	0f 84 51 04 00 00    	je     8049f7d <submitr+0x78c>
 8049b2c:	89 d7                	mov    %edx,%edi
 8049b2e:	0f b6 03             	movzbl (%ebx),%eax
 8049b31:	3c 2a                	cmp    $0x2a,%al
 8049b33:	74 21                	je     8049b56 <submitr+0x365>
 8049b35:	8d 50 d3             	lea    -0x2d(%eax),%edx
 8049b38:	80 fa 01             	cmp    $0x1,%dl
 8049b3b:	76 19                	jbe    8049b56 <submitr+0x365>
 8049b3d:	3c 5f                	cmp    $0x5f,%al
 8049b3f:	74 15                	je     8049b56 <submitr+0x365>
 8049b41:	8d 50 d0             	lea    -0x30(%eax),%edx
 8049b44:	80 fa 09             	cmp    $0x9,%dl
 8049b47:	76 0d                	jbe    8049b56 <submitr+0x365>
 8049b49:	89 c2                	mov    %eax,%edx
 8049b4b:	83 e2 df             	and    $0xffffffdf,%edx
 8049b4e:	83 ea 41             	sub    $0x41,%edx
 8049b51:	80 fa 19             	cmp    $0x19,%dl
 8049b54:	77 07                	ja     8049b5d <submitr+0x36c>
 8049b56:	8d 57 01             	lea    0x1(%edi),%edx
 8049b59:	88 07                	mov    %al,(%edi)
 8049b5b:	eb 69                	jmp    8049bc6 <submitr+0x3d5>
 8049b5d:	3c 20                	cmp    $0x20,%al
 8049b5f:	75 08                	jne    8049b69 <submitr+0x378>
 8049b61:	8d 57 01             	lea    0x1(%edi),%edx
 8049b64:	c6 07 2b             	movb   $0x2b,(%edi)
 8049b67:	eb 5d                	jmp    8049bc6 <submitr+0x3d5>
 8049b69:	8d 50 e0             	lea    -0x20(%eax),%edx
 8049b6c:	80 fa 5f             	cmp    $0x5f,%dl
 8049b6f:	76 08                	jbe    8049b79 <submitr+0x388>
 8049b71:	3c 09                	cmp    $0x9,%al
 8049b73:	0f 85 82 04 00 00    	jne    8049ffb <submitr+0x80a>
 8049b79:	0f b6 c0             	movzbl %al,%eax
 8049b7c:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049b80:	c7 44 24 0c 90 a9 04 	movl   $0x804a990,0xc(%esp)
 8049b87:	08 
 8049b88:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
 8049b8f:	00 
 8049b90:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049b97:	00 
 8049b98:	8d 85 d8 df ff ff    	lea    -0x2028(%ebp),%eax
 8049b9e:	89 04 24             	mov    %eax,(%esp)
 8049ba1:	e8 da ed ff ff       	call   8048980 <__sprintf_chk@plt>
 8049ba6:	0f b6 85 d8 df ff ff 	movzbl -0x2028(%ebp),%eax
 8049bad:	88 07                	mov    %al,(%edi)
 8049baf:	0f b6 85 d9 df ff ff 	movzbl -0x2027(%ebp),%eax
 8049bb6:	88 47 01             	mov    %al,0x1(%edi)
 8049bb9:	8d 57 03             	lea    0x3(%edi),%edx
 8049bbc:	0f b6 85 da df ff ff 	movzbl -0x2026(%ebp),%eax
 8049bc3:	88 47 02             	mov    %al,0x2(%edi)
 8049bc6:	83 c3 01             	add    $0x1,%ebx
 8049bc9:	83 ee 01             	sub    $0x1,%esi
 8049bcc:	0f 84 ab 03 00 00    	je     8049f7d <submitr+0x78c>
 8049bd2:	89 d7                	mov    %edx,%edi
 8049bd4:	e9 55 ff ff ff       	jmp    8049b2e <submitr+0x33d>
 8049bd9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 8049bdd:	89 74 24 04          	mov    %esi,0x4(%esp)
 8049be1:	89 3c 24             	mov    %edi,(%esp)
 8049be4:	e8 c7 ec ff ff       	call   80488b0 <write@plt>
 8049be9:	85 c0                	test   %eax,%eax
 8049beb:	7f 0f                	jg     8049bfc <submitr+0x40b>
 8049bed:	e8 fe ec ff ff       	call   80488f0 <__errno_location@plt>
 8049bf2:	83 38 04             	cmpl   $0x4,(%eax)
 8049bf5:	75 15                	jne    8049c0c <submitr+0x41b>
 8049bf7:	b8 00 00 00 00       	mov    $0x0,%eax
 8049bfc:	01 c6                	add    %eax,%esi
 8049bfe:	29 c3                	sub    %eax,%ebx
 8049c00:	75 d7                	jne    8049bd9 <submitr+0x3e8>
 8049c02:	8b bd b0 5f ff ff    	mov    -0xa050(%ebp),%edi
 8049c08:	85 ff                	test   %edi,%edi
 8049c0a:	79 6a                	jns    8049c76 <submitr+0x485>
 8049c0c:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049c12:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049c18:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049c1f:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049c26:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049c2d:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049c34:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049c3b:	c7 40 18 77 72 69 74 	movl   $0x74697277,0x18(%eax)
 8049c42:	c7 40 1c 65 20 74 6f 	movl   $0x6f742065,0x1c(%eax)
 8049c49:	c7 40 20 20 74 68 65 	movl   $0x65687420,0x20(%eax)
 8049c50:	c7 40 24 20 73 65 72 	movl   $0x72657320,0x24(%eax)
 8049c57:	c7 40 28 76 65 72 00 	movl   $0x726576,0x28(%eax)
 8049c5e:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049c64:	89 04 24             	mov    %eax,(%esp)
 8049c67:	e8 f4 ec ff ff       	call   8048960 <close@plt>
 8049c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049c71:	e9 f2 02 00 00       	jmp    8049f68 <submitr+0x777>
 8049c76:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049c7c:	89 85 d8 df ff ff    	mov    %eax,-0x2028(%ebp)
 8049c82:	c7 85 dc df ff ff 00 	movl   $0x0,-0x2024(%ebp)
 8049c89:	00 00 00 
 8049c8c:	8d 85 e4 df ff ff    	lea    -0x201c(%ebp),%eax
 8049c92:	89 85 e0 df ff ff    	mov    %eax,-0x2020(%ebp)
 8049c98:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049c9d:	8d 95 d8 5f ff ff    	lea    -0xa028(%ebp),%edx
 8049ca3:	8d 85 d8 df ff ff    	lea    -0x2028(%ebp),%eax
 8049ca9:	e8 39 fa ff ff       	call   80496e7 <rio_readlineb>
 8049cae:	85 c0                	test   %eax,%eax
 8049cb0:	7f 7e                	jg     8049d30 <submitr+0x53f>
 8049cb2:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049cb8:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049cbe:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049cc5:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049ccc:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049cd3:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049cda:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049ce1:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049ce8:	c7 40 1c 20 66 69 72 	movl   $0x72696620,0x1c(%eax)
 8049cef:	c7 40 20 73 74 20 68 	movl   $0x68207473,0x20(%eax)
 8049cf6:	c7 40 24 65 61 64 65 	movl   $0x65646165,0x24(%eax)
 8049cfd:	c7 40 28 72 20 66 72 	movl   $0x72662072,0x28(%eax)
 8049d04:	c7 40 2c 6f 6d 20 73 	movl   $0x73206d6f,0x2c(%eax)
 8049d0b:	c7 40 30 65 72 76 65 	movl   $0x65767265,0x30(%eax)
 8049d12:	66 c7 40 34 72 00    	movw   $0x72,0x34(%eax)
 8049d18:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049d1e:	89 04 24             	mov    %eax,(%esp)
 8049d21:	e8 3a ec ff ff       	call   8048960 <close@plt>
 8049d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d2b:	e9 38 02 00 00       	jmp    8049f68 <submitr+0x777>
 8049d30:	8d 85 d8 bf ff ff    	lea    -0x4028(%ebp),%eax
 8049d36:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049d3a:	8d 85 c4 5f ff ff    	lea    -0xa03c(%ebp),%eax
 8049d40:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049d44:	8d 85 d8 9f ff ff    	lea    -0x6028(%ebp),%eax
 8049d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049d4e:	c7 44 24 04 97 a9 04 	movl   $0x804a997,0x4(%esp)
 8049d55:	08 
 8049d56:	8d 85 d8 5f ff ff    	lea    -0xa028(%ebp),%eax
 8049d5c:	89 04 24             	mov    %eax,(%esp)
 8049d5f:	e8 6c eb ff ff       	call   80488d0 <__isoc99_sscanf@plt>
 8049d64:	8b 85 c4 5f ff ff    	mov    -0xa03c(%ebp),%eax
 8049d6a:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049d6f:	0f 84 db 00 00 00    	je     8049e50 <submitr+0x65f>
 8049d75:	8d 95 d8 bf ff ff    	lea    -0x4028(%ebp),%edx
 8049d7b:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049d7f:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049d83:	c7 44 24 0c a8 a8 04 	movl   $0x804a8a8,0xc(%esp)
 8049d8a:	08 
 8049d8b:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
 8049d92:	ff 
 8049d93:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d9a:	00 
 8049d9b:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049da1:	89 04 24             	mov    %eax,(%esp)
 8049da4:	e8 d7 eb ff ff       	call   8048980 <__sprintf_chk@plt>
 8049da9:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049daf:	89 04 24             	mov    %eax,(%esp)
 8049db2:	e8 a9 eb ff ff       	call   8048960 <close@plt>
 8049db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049dbc:	e9 a7 01 00 00       	jmp    8049f68 <submitr+0x777>
 8049dc1:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049dc6:	8d 95 d8 5f ff ff    	lea    -0xa028(%ebp),%edx
 8049dcc:	8d 85 d8 df ff ff    	lea    -0x2028(%ebp),%eax
 8049dd2:	e8 10 f9 ff ff       	call   80496e7 <rio_readlineb>
 8049dd7:	85 c0                	test   %eax,%eax
 8049dd9:	7f 75                	jg     8049e50 <submitr+0x65f>
 8049ddb:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049de1:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049de7:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049dee:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049df5:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049dfc:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049e03:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049e0a:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049e11:	c7 40 1c 20 68 65 61 	movl   $0x61656820,0x1c(%eax)
 8049e18:	c7 40 20 64 65 72 73 	movl   $0x73726564,0x20(%eax)
 8049e1f:	c7 40 24 20 66 72 6f 	movl   $0x6f726620,0x24(%eax)
 8049e26:	c7 40 28 6d 20 73 65 	movl   $0x6573206d,0x28(%eax)
 8049e2d:	c7 40 2c 72 76 65 72 	movl   $0x72657672,0x2c(%eax)
 8049e34:	c6 40 30 00          	movb   $0x0,0x30(%eax)
 8049e38:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049e3e:	89 04 24             	mov    %eax,(%esp)
 8049e41:	e8 1a eb ff ff       	call   8048960 <close@plt>
 8049e46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e4b:	e9 18 01 00 00       	jmp    8049f68 <submitr+0x777>
 8049e50:	80 bd d8 5f ff ff 0d 	cmpb   $0xd,-0xa028(%ebp)
 8049e57:	0f 85 64 ff ff ff    	jne    8049dc1 <submitr+0x5d0>
 8049e5d:	80 bd d9 5f ff ff 0a 	cmpb   $0xa,-0xa027(%ebp)
 8049e64:	0f 85 57 ff ff ff    	jne    8049dc1 <submitr+0x5d0>
 8049e6a:	80 bd da 5f ff ff 00 	cmpb   $0x0,-0xa026(%ebp)
 8049e71:	0f 85 4a ff ff ff    	jne    8049dc1 <submitr+0x5d0>
 8049e77:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049e7c:	8d 95 d8 5f ff ff    	lea    -0xa028(%ebp),%edx
 8049e82:	8d 85 d8 df ff ff    	lea    -0x2028(%ebp),%eax
 8049e88:	e8 5a f8 ff ff       	call   80496e7 <rio_readlineb>
 8049e8d:	85 c0                	test   %eax,%eax
 8049e8f:	7f 7c                	jg     8049f0d <submitr+0x71c>
 8049e91:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049e97:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049e9d:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049ea4:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049eab:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049eb2:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049eb9:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049ec0:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049ec7:	c7 40 1c 20 73 74 61 	movl   $0x61747320,0x1c(%eax)
 8049ece:	c7 40 20 74 75 73 20 	movl   $0x20737574,0x20(%eax)
 8049ed5:	c7 40 24 6d 65 73 73 	movl   $0x7373656d,0x24(%eax)
 8049edc:	c7 40 28 61 67 65 20 	movl   $0x20656761,0x28(%eax)
 8049ee3:	c7 40 2c 66 72 6f 6d 	movl   $0x6d6f7266,0x2c(%eax)
 8049eea:	c7 40 30 20 73 65 72 	movl   $0x72657320,0x30(%eax)
 8049ef1:	c7 40 34 76 65 72 00 	movl   $0x726576,0x34(%eax)
 8049ef8:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049efe:	89 04 24             	mov    %eax,(%esp)
 8049f01:	e8 5a ea ff ff       	call   8048960 <close@plt>
 8049f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049f0b:	eb 5b                	jmp    8049f68 <submitr+0x777>
 8049f0d:	8d 85 d8 5f ff ff    	lea    -0xa028(%ebp),%eax
 8049f13:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049f17:	8b b5 a4 5f ff ff    	mov    -0xa05c(%ebp),%esi
 8049f1d:	89 34 24             	mov    %esi,(%esp)
 8049f20:	e8 fb e8 ff ff       	call   8048820 <strcpy@plt>
 8049f25:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049f2b:	89 04 24             	mov    %eax,(%esp)
 8049f2e:	e8 2d ea ff ff       	call   8048960 <close@plt>
 8049f33:	0f b6 06             	movzbl (%esi),%eax
 8049f36:	ba 4f 00 00 00       	mov    $0x4f,%edx
 8049f3b:	29 c2                	sub    %eax,%edx
 8049f3d:	75 1f                	jne    8049f5e <submitr+0x76d>
 8049f3f:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049f45:	0f b6 40 01          	movzbl 0x1(%eax),%eax
 8049f49:	ba 4b 00 00 00       	mov    $0x4b,%edx
 8049f4e:	29 c2                	sub    %eax,%edx
 8049f50:	75 0c                	jne    8049f5e <submitr+0x76d>
 8049f52:	8b 85 a4 5f ff ff    	mov    -0xa05c(%ebp),%eax
 8049f58:	0f b6 50 02          	movzbl 0x2(%eax),%edx
 8049f5c:	f7 da                	neg    %edx
 8049f5e:	85 d2                	test   %edx,%edx
 8049f60:	0f 95 c0             	setne  %al
 8049f63:	0f b6 c0             	movzbl %al,%eax
 8049f66:	f7 d8                	neg    %eax
 8049f68:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 8049f6b:	65 33 0d 14 00 00 00 	xor    %gs:0x14,%ecx
 8049f72:	0f 84 0a 01 00 00    	je     804a082 <submitr+0x891>
 8049f78:	e9 00 01 00 00       	jmp    804a07d <submitr+0x88c>
 8049f7d:	8d 85 d8 7f ff ff    	lea    -0x8028(%ebp),%eax
 8049f83:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 8049f87:	8b 85 a8 5f ff ff    	mov    -0xa058(%ebp),%eax
 8049f8d:	89 44 24 18          	mov    %eax,0x18(%esp)
 8049f91:	8b 85 ac 5f ff ff    	mov    -0xa054(%ebp),%eax
 8049f97:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049f9b:	8b 85 b0 5f ff ff    	mov    -0xa050(%ebp),%eax
 8049fa1:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049fa5:	c7 44 24 0c d8 a8 04 	movl   $0x804a8d8,0xc(%esp)
 8049fac:	08 
 8049fad:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049fb4:	00 
 8049fb5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049fbc:	00 
 8049fbd:	8d bd d8 5f ff ff    	lea    -0xa028(%ebp),%edi
 8049fc3:	89 3c 24             	mov    %edi,(%esp)
 8049fc6:	e8 b5 e9 ff ff       	call   8048980 <__sprintf_chk@plt>
 8049fcb:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fd0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049fd5:	f2 ae                	repnz scas %es:(%edi),%al
 8049fd7:	f7 d1                	not    %ecx
 8049fd9:	83 e9 01             	sub    $0x1,%ecx
 8049fdc:	0f 84 94 fc ff ff    	je     8049c76 <submitr+0x485>
 8049fe2:	89 cb                	mov    %ecx,%ebx
 8049fe4:	8d b5 d8 5f ff ff    	lea    -0xa028(%ebp),%esi
 8049fea:	89 8d b0 5f ff ff    	mov    %ecx,-0xa050(%ebp)
 8049ff0:	8b bd b4 5f ff ff    	mov    -0xa04c(%ebp),%edi
 8049ff6:	e9 de fb ff ff       	jmp    8049bd9 <submitr+0x3e8>
 8049ffb:	8b 8d a4 5f ff ff    	mov    -0xa05c(%ebp),%ecx
 804a001:	89 cf                	mov    %ecx,%edi
 804a003:	be 24 a9 04 08       	mov    $0x804a924,%esi
 804a008:	b8 43 00 00 00       	mov    $0x43,%eax
 804a00d:	f6 c1 01             	test   $0x1,%cl
 804a010:	74 16                	je     804a028 <submitr+0x837>
 804a012:	0f b6 05 24 a9 04 08 	movzbl 0x804a924,%eax
 804a019:	88 01                	mov    %al,(%ecx)
 804a01b:	8d 79 01             	lea    0x1(%ecx),%edi
 804a01e:	be 25 a9 04 08       	mov    $0x804a925,%esi
 804a023:	b8 42 00 00 00       	mov    $0x42,%eax
 804a028:	f7 c7 02 00 00 00    	test   $0x2,%edi
 804a02e:	74 0f                	je     804a03f <submitr+0x84e>
 804a030:	0f b7 16             	movzwl (%esi),%edx
 804a033:	66 89 17             	mov    %dx,(%edi)
 804a036:	83 c7 02             	add    $0x2,%edi
 804a039:	83 c6 02             	add    $0x2,%esi
 804a03c:	83 e8 02             	sub    $0x2,%eax
 804a03f:	89 c1                	mov    %eax,%ecx
 804a041:	c1 e9 02             	shr    $0x2,%ecx
 804a044:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 804a046:	ba 00 00 00 00       	mov    $0x0,%edx
 804a04b:	a8 02                	test   $0x2,%al
 804a04d:	74 0b                	je     804a05a <submitr+0x869>
 804a04f:	0f b7 16             	movzwl (%esi),%edx
 804a052:	66 89 17             	mov    %dx,(%edi)
 804a055:	ba 02 00 00 00       	mov    $0x2,%edx
 804a05a:	a8 01                	test   $0x1,%al
 804a05c:	74 07                	je     804a065 <submitr+0x874>
 804a05e:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
 804a062:	88 04 17             	mov    %al,(%edi,%edx,1)
 804a065:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 804a06b:	89 04 24             	mov    %eax,(%esp)
 804a06e:	e8 ed e8 ff ff       	call   8048960 <close@plt>
 804a073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a078:	e9 eb fe ff ff       	jmp    8049f68 <submitr+0x777>
 804a07d:	e8 8e e7 ff ff       	call   8048810 <__stack_chk_fail@plt>
 804a082:	81 c4 7c a0 00 00    	add    $0xa07c,%esp
 804a088:	5b                   	pop    %ebx
 804a089:	5e                   	pop    %esi
 804a08a:	5f                   	pop    %edi
 804a08b:	5d                   	pop    %ebp
 804a08c:	c3                   	ret    

0804a08d <init_timeout>:
 804a08d:	55                   	push   %ebp
 804a08e:	89 e5                	mov    %esp,%ebp
 804a090:	53                   	push   %ebx
 804a091:	83 ec 14             	sub    $0x14,%esp
 804a094:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804a097:	85 db                	test   %ebx,%ebx
 804a099:	74 26                	je     804a0c1 <init_timeout+0x34>
 804a09b:	c7 44 24 04 b0 96 04 	movl   $0x80496b0,0x4(%esp)
 804a0a2:	08 
 804a0a3:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 804a0aa:	e8 31 e7 ff ff       	call   80487e0 <signal@plt>
 804a0af:	85 db                	test   %ebx,%ebx
 804a0b1:	b8 00 00 00 00       	mov    $0x0,%eax
 804a0b6:	0f 48 d8             	cmovs  %eax,%ebx
 804a0b9:	89 1c 24             	mov    %ebx,(%esp)
 804a0bc:	e8 3f e7 ff ff       	call   8048800 <alarm@plt>
 804a0c1:	83 c4 14             	add    $0x14,%esp
 804a0c4:	5b                   	pop    %ebx
 804a0c5:	5d                   	pop    %ebp
 804a0c6:	c3                   	ret    

0804a0c7 <init_driver>:
 804a0c7:	55                   	push   %ebp
 804a0c8:	89 e5                	mov    %esp,%ebp
 804a0ca:	57                   	push   %edi
 804a0cb:	56                   	push   %esi
 804a0cc:	53                   	push   %ebx
 804a0cd:	83 ec 4c             	sub    $0x4c,%esp
 804a0d0:	8b 75 08             	mov    0x8(%ebp),%esi
 804a0d3:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 804a0d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 804a0dc:	31 c0                	xor    %eax,%eax
 804a0de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804a0e5:	00 
 804a0e6:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
 804a0ed:	e8 ee e6 ff ff       	call   80487e0 <signal@plt>
 804a0f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804a0f9:	00 
 804a0fa:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 804a101:	e8 da e6 ff ff       	call   80487e0 <signal@plt>
 804a106:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804a10d:	00 
 804a10e:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 804a115:	e8 c6 e6 ff ff       	call   80487e0 <signal@plt>
 804a11a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 804a121:	00 
 804a122:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804a129:	00 
 804a12a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 804a131:	e8 da e7 ff ff       	call   8048910 <socket@plt>
 804a136:	89 c3                	mov    %eax,%ebx
 804a138:	85 c0                	test   %eax,%eax
 804a13a:	79 4e                	jns    804a18a <init_driver+0xc3>
 804a13c:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 804a142:	c7 46 04 72 3a 20 43 	movl   $0x43203a72,0x4(%esi)
 804a149:	c7 46 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%esi)
 804a150:	c7 46 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%esi)
 804a157:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 804a15e:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 804a165:	c7 46 18 63 72 65 61 	movl   $0x61657263,0x18(%esi)
 804a16c:	c7 46 1c 74 65 20 73 	movl   $0x73206574,0x1c(%esi)
 804a173:	c7 46 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%esi)
 804a17a:	66 c7 46 24 74 00    	movw   $0x74,0x24(%esi)
 804a180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a185:	e9 2b 01 00 00       	jmp    804a2b5 <init_driver+0x1ee>
 804a18a:	c7 04 24 a8 a9 04 08 	movl   $0x804a9a8,(%esp)
 804a191:	e8 9a e7 ff ff       	call   8048930 <gethostbyname@plt>
 804a196:	85 c0                	test   %eax,%eax
 804a198:	75 68                	jne    804a202 <init_driver+0x13b>
 804a19a:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 804a1a0:	c7 46 04 72 3a 20 44 	movl   $0x44203a72,0x4(%esi)
 804a1a7:	c7 46 08 4e 53 20 69 	movl   $0x6920534e,0x8(%esi)
 804a1ae:	c7 46 0c 73 20 75 6e 	movl   $0x6e752073,0xc(%esi)
 804a1b5:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 804a1bc:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 804a1c3:	c7 46 18 72 65 73 6f 	movl   $0x6f736572,0x18(%esi)
 804a1ca:	c7 46 1c 6c 76 65 20 	movl   $0x2065766c,0x1c(%esi)
 804a1d1:	c7 46 20 73 65 72 76 	movl   $0x76726573,0x20(%esi)
 804a1d8:	c7 46 24 65 72 20 61 	movl   $0x61207265,0x24(%esi)
 804a1df:	c7 46 28 64 64 72 65 	movl   $0x65726464,0x28(%esi)
 804a1e6:	66 c7 46 2c 73 73    	movw   $0x7373,0x2c(%esi)
 804a1ec:	c6 46 2e 00          	movb   $0x0,0x2e(%esi)
 804a1f0:	89 1c 24             	mov    %ebx,(%esp)
 804a1f3:	e8 68 e7 ff ff       	call   8048960 <close@plt>
 804a1f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a1fd:	e9 b3 00 00 00       	jmp    804a2b5 <init_driver+0x1ee>
 804a202:	8d 7d d4             	lea    -0x2c(%ebp),%edi
 804a205:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 804a20c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 804a213:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 804a21a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 804a221:	66 c7 45 d4 02 00    	movw   $0x2,-0x2c(%ebp)
 804a227:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
 804a22e:	00 
 804a22f:	8b 50 0c             	mov    0xc(%eax),%edx
 804a232:	89 54 24 08          	mov    %edx,0x8(%esp)
 804a236:	8b 40 10             	mov    0x10(%eax),%eax
 804a239:	8b 00                	mov    (%eax),%eax
 804a23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a23f:	8d 45 d8             	lea    -0x28(%ebp),%eax
 804a242:	89 04 24             	mov    %eax,(%esp)
 804a245:	e8 16 e6 ff ff       	call   8048860 <__memmove_chk@plt>
 804a24a:	66 c7 45 d6 3b 6e    	movw   $0x6e3b,-0x2a(%ebp)
 804a250:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 804a257:	00 
 804a258:	89 7c 24 04          	mov    %edi,0x4(%esp)
 804a25c:	89 1c 24             	mov    %ebx,(%esp)
 804a25f:	e8 ec e6 ff ff       	call   8048950 <connect@plt>
 804a264:	85 c0                	test   %eax,%eax
 804a266:	79 37                	jns    804a29f <init_driver+0x1d8>
 804a268:	c7 44 24 10 a8 a9 04 	movl   $0x804a9a8,0x10(%esp)
 804a26f:	08 
 804a270:	c7 44 24 0c 68 a9 04 	movl   $0x804a968,0xc(%esp)
 804a277:	08 
 804a278:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
 804a27f:	ff 
 804a280:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804a287:	00 
 804a288:	89 34 24             	mov    %esi,(%esp)
 804a28b:	e8 f0 e6 ff ff       	call   8048980 <__sprintf_chk@plt>
 804a290:	89 1c 24             	mov    %ebx,(%esp)
 804a293:	e8 c8 e6 ff ff       	call   8048960 <close@plt>
 804a298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a29d:	eb 16                	jmp    804a2b5 <init_driver+0x1ee>
 804a29f:	89 1c 24             	mov    %ebx,(%esp)
 804a2a2:	e8 b9 e6 ff ff       	call   8048960 <close@plt>
 804a2a7:	66 c7 06 4f 4b       	movw   $0x4b4f,(%esi)
 804a2ac:	c6 46 02 00          	movb   $0x0,0x2(%esi)
 804a2b0:	b8 00 00 00 00       	mov    $0x0,%eax
 804a2b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 804a2b8:	65 33 0d 14 00 00 00 	xor    %gs:0x14,%ecx
 804a2bf:	74 05                	je     804a2c6 <init_driver+0x1ff>
 804a2c1:	e8 4a e5 ff ff       	call   8048810 <__stack_chk_fail@plt>
 804a2c6:	83 c4 4c             	add    $0x4c,%esp
 804a2c9:	5b                   	pop    %ebx
 804a2ca:	5e                   	pop    %esi
 804a2cb:	5f                   	pop    %edi
 804a2cc:	5d                   	pop    %ebp
 804a2cd:	c3                   	ret    

0804a2ce <driver_post>:
 804a2ce:	55                   	push   %ebp
 804a2cf:	89 e5                	mov    %esp,%ebp
 804a2d1:	53                   	push   %ebx
 804a2d2:	83 ec 24             	sub    $0x24,%esp
 804a2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 804a2d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
 804a2db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a2df:	74 2b                	je     804a30c <driver_post+0x3e>
 804a2e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a2e4:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a2e8:	c7 44 24 04 b4 a9 04 	movl   $0x804a9b4,0x4(%esp)
 804a2ef:	08 
 804a2f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804a2f7:	e8 04 e6 ff ff       	call   8048900 <__printf_chk@plt>
 804a2fc:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 804a301:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 804a305:	b8 00 00 00 00       	mov    $0x0,%eax
 804a30a:	eb 4c                	jmp    804a358 <driver_post+0x8a>
 804a30c:	85 c0                	test   %eax,%eax
 804a30e:	74 3a                	je     804a34a <driver_post+0x7c>
 804a310:	80 38 00             	cmpb   $0x0,(%eax)
 804a313:	74 35                	je     804a34a <driver_post+0x7c>
 804a315:	89 5c 24 18          	mov    %ebx,0x18(%esp)
 804a319:	8b 55 0c             	mov    0xc(%ebp),%edx
 804a31c:	89 54 24 14          	mov    %edx,0x14(%esp)
 804a320:	c7 44 24 10 cb a9 04 	movl   $0x804a9cb,0x10(%esp)
 804a327:	08 
 804a328:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804a32c:	c7 44 24 08 d1 a9 04 	movl   $0x804a9d1,0x8(%esp)
 804a333:	08 
 804a334:	c7 44 24 04 6e 3b 00 	movl   $0x3b6e,0x4(%esp)
 804a33b:	00 
 804a33c:	c7 04 24 a8 a9 04 08 	movl   $0x804a9a8,(%esp)
 804a343:	e8 a9 f4 ff ff       	call   80497f1 <submitr>
 804a348:	eb 0e                	jmp    804a358 <driver_post+0x8a>
 804a34a:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 804a34f:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 804a353:	b8 00 00 00 00       	mov    $0x0,%eax
 804a358:	83 c4 24             	add    $0x24,%esp
 804a35b:	5b                   	pop    %ebx
 804a35c:	5d                   	pop    %ebp
 804a35d:	c3                   	ret    
 804a35e:	66 90                	xchg   %ax,%ax

0804a360 <__libc_csu_init>:
 804a360:	55                   	push   %ebp
 804a361:	57                   	push   %edi
 804a362:	31 ff                	xor    %edi,%edi
 804a364:	56                   	push   %esi
 804a365:	53                   	push   %ebx
 804a366:	e8 55 e6 ff ff       	call   80489c0 <__x86.get_pc_thunk.bx>
 804a36b:	81 c3 95 1c 00 00    	add    $0x1c95,%ebx
 804a371:	83 ec 1c             	sub    $0x1c,%esp
 804a374:	8b 6c 24 30          	mov    0x30(%esp),%ebp
 804a378:	8d b3 0c ff ff ff    	lea    -0xf4(%ebx),%esi
 804a37e:	e8 ed e3 ff ff       	call   8048770 <_init>
 804a383:	8d 83 08 ff ff ff    	lea    -0xf8(%ebx),%eax
 804a389:	29 c6                	sub    %eax,%esi
 804a38b:	c1 fe 02             	sar    $0x2,%esi
 804a38e:	85 f6                	test   %esi,%esi
 804a390:	74 27                	je     804a3b9 <__libc_csu_init+0x59>
 804a392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 804a398:	8b 44 24 38          	mov    0x38(%esp),%eax
 804a39c:	89 2c 24             	mov    %ebp,(%esp)
 804a39f:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a3a3:	8b 44 24 34          	mov    0x34(%esp),%eax
 804a3a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a3ab:	ff 94 bb 08 ff ff ff 	call   *-0xf8(%ebx,%edi,4)
 804a3b2:	83 c7 01             	add    $0x1,%edi
 804a3b5:	39 f7                	cmp    %esi,%edi
 804a3b7:	75 df                	jne    804a398 <__libc_csu_init+0x38>
 804a3b9:	83 c4 1c             	add    $0x1c,%esp
 804a3bc:	5b                   	pop    %ebx
 804a3bd:	5e                   	pop    %esi
 804a3be:	5f                   	pop    %edi
 804a3bf:	5d                   	pop    %ebp
 804a3c0:	c3                   	ret    
 804a3c1:	eb 0d                	jmp    804a3d0 <__libc_csu_fini>
 804a3c3:	90                   	nop
 804a3c4:	90                   	nop
 804a3c5:	90                   	nop
 804a3c6:	90                   	nop
 804a3c7:	90                   	nop
 804a3c8:	90                   	nop
 804a3c9:	90                   	nop
 804a3ca:	90                   	nop
 804a3cb:	90                   	nop
 804a3cc:	90                   	nop
 804a3cd:	90                   	nop
 804a3ce:	90                   	nop
 804a3cf:	90                   	nop

0804a3d0 <__libc_csu_fini>:
 804a3d0:	f3 c3                	repz ret 

Disassembly of section .fini:

0804a3d4 <_fini>:
 804a3d4:	53                   	push   %ebx
 804a3d5:	83 ec 08             	sub    $0x8,%esp
 804a3d8:	e8 e3 e5 ff ff       	call   80489c0 <__x86.get_pc_thunk.bx>
 804a3dd:	81 c3 23 1c 00 00    	add    $0x1c23,%ebx
 804a3e3:	83 c4 08             	add    $0x8,%esp
 804a3e6:	5b                   	pop    %ebx
 804a3e7:	c3                   	ret    
