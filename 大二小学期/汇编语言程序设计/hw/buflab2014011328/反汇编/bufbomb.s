
bufbomb:     file format elf32-i386


Disassembly of section .init:

080487e0 <_init>:
 80487e0:	53                   	push   %ebx
 80487e1:	83 ec 08             	sub    $0x8,%esp
 80487e4:	e8 c7 02 00 00       	call   8048ab0 <__x86.get_pc_thunk.bx>
 80487e9:	81 c3 17 38 00 00    	add    $0x3817,%ebx
 80487ef:	8b 83 fc ff ff ff    	mov    -0x4(%ebx),%eax
 80487f5:	85 c0                	test   %eax,%eax
 80487f7:	74 05                	je     80487fe <_init+0x1e>
 80487f9:	e8 32 01 00 00       	call   8048930 <__gmon_start__@plt>
 80487fe:	83 c4 08             	add    $0x8,%esp
 8048801:	5b                   	pop    %ebx
 8048802:	c3                   	ret    

Disassembly of section .plt:

08048810 <strcmp@plt-0x10>:
 8048810:	ff 35 04 c0 04 08    	pushl  0x804c004
 8048816:	ff 25 08 c0 04 08    	jmp    *0x804c008
 804881c:	00 00                	add    %al,(%eax)
	...

08048820 <strcmp@plt>:
 8048820:	ff 25 0c c0 04 08    	jmp    *0x804c00c
 8048826:	68 00 00 00 00       	push   $0x0
 804882b:	e9 e0 ff ff ff       	jmp    8048810 <_init+0x30>

08048830 <read@plt>:
 8048830:	ff 25 10 c0 04 08    	jmp    *0x804c010
 8048836:	68 08 00 00 00       	push   $0x8
 804883b:	e9 d0 ff ff ff       	jmp    8048810 <_init+0x30>

08048840 <srandom@plt>:
 8048840:	ff 25 14 c0 04 08    	jmp    *0x804c014
 8048846:	68 10 00 00 00       	push   $0x10
 804884b:	e9 c0 ff ff ff       	jmp    8048810 <_init+0x30>

08048850 <printf@plt>:
 8048850:	ff 25 18 c0 04 08    	jmp    *0x804c018
 8048856:	68 18 00 00 00       	push   $0x18
 804885b:	e9 b0 ff ff ff       	jmp    8048810 <_init+0x30>

08048860 <strdup@plt>:
 8048860:	ff 25 1c c0 04 08    	jmp    *0x804c01c
 8048866:	68 20 00 00 00       	push   $0x20
 804886b:	e9 a0 ff ff ff       	jmp    8048810 <_init+0x30>

08048870 <memcpy@plt>:
 8048870:	ff 25 20 c0 04 08    	jmp    *0x804c020
 8048876:	68 28 00 00 00       	push   $0x28
 804887b:	e9 90 ff ff ff       	jmp    8048810 <_init+0x30>

08048880 <bzero@plt>:
 8048880:	ff 25 24 c0 04 08    	jmp    *0x804c024
 8048886:	68 30 00 00 00       	push   $0x30
 804888b:	e9 80 ff ff ff       	jmp    8048810 <_init+0x30>

08048890 <signal@plt>:
 8048890:	ff 25 28 c0 04 08    	jmp    *0x804c028
 8048896:	68 38 00 00 00       	push   $0x38
 804889b:	e9 70 ff ff ff       	jmp    8048810 <_init+0x30>

080488a0 <alarm@plt>:
 80488a0:	ff 25 2c c0 04 08    	jmp    *0x804c02c
 80488a6:	68 40 00 00 00       	push   $0x40
 80488ab:	e9 60 ff ff ff       	jmp    8048810 <_init+0x30>

080488b0 <_IO_getc@plt>:
 80488b0:	ff 25 30 c0 04 08    	jmp    *0x804c030
 80488b6:	68 48 00 00 00       	push   $0x48
 80488bb:	e9 50 ff ff ff       	jmp    8048810 <_init+0x30>

080488c0 <htons@plt>:
 80488c0:	ff 25 34 c0 04 08    	jmp    *0x804c034
 80488c6:	68 50 00 00 00       	push   $0x50
 80488cb:	e9 40 ff ff ff       	jmp    8048810 <_init+0x30>

080488d0 <fwrite@plt>:
 80488d0:	ff 25 38 c0 04 08    	jmp    *0x804c038
 80488d6:	68 58 00 00 00       	push   $0x58
 80488db:	e9 30 ff ff ff       	jmp    8048810 <_init+0x30>

080488e0 <bcopy@plt>:
 80488e0:	ff 25 3c c0 04 08    	jmp    *0x804c03c
 80488e6:	68 60 00 00 00       	push   $0x60
 80488eb:	e9 20 ff ff ff       	jmp    8048810 <_init+0x30>

080488f0 <strcpy@plt>:
 80488f0:	ff 25 40 c0 04 08    	jmp    *0x804c040
 80488f6:	68 68 00 00 00       	push   $0x68
 80488fb:	e9 10 ff ff ff       	jmp    8048810 <_init+0x30>

08048900 <getpid@plt>:
 8048900:	ff 25 44 c0 04 08    	jmp    *0x804c044
 8048906:	68 70 00 00 00       	push   $0x70
 804890b:	e9 00 ff ff ff       	jmp    8048810 <_init+0x30>

08048910 <gethostname@plt>:
 8048910:	ff 25 48 c0 04 08    	jmp    *0x804c048
 8048916:	68 78 00 00 00       	push   $0x78
 804891b:	e9 f0 fe ff ff       	jmp    8048810 <_init+0x30>

08048920 <puts@plt>:
 8048920:	ff 25 4c c0 04 08    	jmp    *0x804c04c
 8048926:	68 80 00 00 00       	push   $0x80
 804892b:	e9 e0 fe ff ff       	jmp    8048810 <_init+0x30>

08048930 <__gmon_start__@plt>:
 8048930:	ff 25 50 c0 04 08    	jmp    *0x804c050
 8048936:	68 88 00 00 00       	push   $0x88
 804893b:	e9 d0 fe ff ff       	jmp    8048810 <_init+0x30>

08048940 <exit@plt>:
 8048940:	ff 25 54 c0 04 08    	jmp    *0x804c054
 8048946:	68 90 00 00 00       	push   $0x90
 804894b:	e9 c0 fe ff ff       	jmp    8048810 <_init+0x30>

08048950 <srand@plt>:
 8048950:	ff 25 58 c0 04 08    	jmp    *0x804c058
 8048956:	68 98 00 00 00       	push   $0x98
 804895b:	e9 b0 fe ff ff       	jmp    8048810 <_init+0x30>

08048960 <mmap@plt>:
 8048960:	ff 25 5c c0 04 08    	jmp    *0x804c05c
 8048966:	68 a0 00 00 00       	push   $0xa0
 804896b:	e9 a0 fe ff ff       	jmp    8048810 <_init+0x30>

08048970 <strlen@plt>:
 8048970:	ff 25 60 c0 04 08    	jmp    *0x804c060
 8048976:	68 a8 00 00 00       	push   $0xa8
 804897b:	e9 90 fe ff ff       	jmp    8048810 <_init+0x30>

08048980 <__libc_start_main@plt>:
 8048980:	ff 25 64 c0 04 08    	jmp    *0x804c064
 8048986:	68 b0 00 00 00       	push   $0xb0
 804898b:	e9 80 fe ff ff       	jmp    8048810 <_init+0x30>

08048990 <write@plt>:
 8048990:	ff 25 68 c0 04 08    	jmp    *0x804c068
 8048996:	68 b8 00 00 00       	push   $0xb8
 804899b:	e9 70 fe ff ff       	jmp    8048810 <_init+0x30>

080489a0 <getopt@plt>:
 80489a0:	ff 25 6c c0 04 08    	jmp    *0x804c06c
 80489a6:	68 c0 00 00 00       	push   $0xc0
 80489ab:	e9 60 fe ff ff       	jmp    8048810 <_init+0x30>

080489b0 <strcasecmp@plt>:
 80489b0:	ff 25 70 c0 04 08    	jmp    *0x804c070
 80489b6:	68 c8 00 00 00       	push   $0xc8
 80489bb:	e9 50 fe ff ff       	jmp    8048810 <_init+0x30>

080489c0 <__isoc99_sscanf@plt>:
 80489c0:	ff 25 74 c0 04 08    	jmp    *0x804c074
 80489c6:	68 d0 00 00 00       	push   $0xd0
 80489cb:	e9 40 fe ff ff       	jmp    8048810 <_init+0x30>

080489d0 <memset@plt>:
 80489d0:	ff 25 78 c0 04 08    	jmp    *0x804c078
 80489d6:	68 d8 00 00 00       	push   $0xd8
 80489db:	e9 30 fe ff ff       	jmp    8048810 <_init+0x30>

080489e0 <__errno_location@plt>:
 80489e0:	ff 25 7c c0 04 08    	jmp    *0x804c07c
 80489e6:	68 e0 00 00 00       	push   $0xe0
 80489eb:	e9 20 fe ff ff       	jmp    8048810 <_init+0x30>

080489f0 <rand@plt>:
 80489f0:	ff 25 80 c0 04 08    	jmp    *0x804c080
 80489f6:	68 e8 00 00 00       	push   $0xe8
 80489fb:	e9 10 fe ff ff       	jmp    8048810 <_init+0x30>

08048a00 <munmap@plt>:
 8048a00:	ff 25 84 c0 04 08    	jmp    *0x804c084
 8048a06:	68 f0 00 00 00       	push   $0xf0
 8048a0b:	e9 00 fe ff ff       	jmp    8048810 <_init+0x30>

08048a10 <sprintf@plt>:
 8048a10:	ff 25 88 c0 04 08    	jmp    *0x804c088
 8048a16:	68 f8 00 00 00       	push   $0xf8
 8048a1b:	e9 f0 fd ff ff       	jmp    8048810 <_init+0x30>

08048a20 <socket@plt>:
 8048a20:	ff 25 8c c0 04 08    	jmp    *0x804c08c
 8048a26:	68 00 01 00 00       	push   $0x100
 8048a2b:	e9 e0 fd ff ff       	jmp    8048810 <_init+0x30>

08048a30 <random@plt>:
 8048a30:	ff 25 90 c0 04 08    	jmp    *0x804c090
 8048a36:	68 08 01 00 00       	push   $0x108
 8048a3b:	e9 d0 fd ff ff       	jmp    8048810 <_init+0x30>

08048a40 <gethostbyname@plt>:
 8048a40:	ff 25 94 c0 04 08    	jmp    *0x804c094
 8048a46:	68 10 01 00 00       	push   $0x110
 8048a4b:	e9 c0 fd ff ff       	jmp    8048810 <_init+0x30>

08048a50 <connect@plt>:
 8048a50:	ff 25 98 c0 04 08    	jmp    *0x804c098
 8048a56:	68 18 01 00 00       	push   $0x118
 8048a5b:	e9 b0 fd ff ff       	jmp    8048810 <_init+0x30>

08048a60 <close@plt>:
 8048a60:	ff 25 9c c0 04 08    	jmp    *0x804c09c
 8048a66:	68 20 01 00 00       	push   $0x120
 8048a6b:	e9 a0 fd ff ff       	jmp    8048810 <_init+0x30>

08048a70 <calloc@plt>:
 8048a70:	ff 25 a0 c0 04 08    	jmp    *0x804c0a0
 8048a76:	68 28 01 00 00       	push   $0x128
 8048a7b:	e9 90 fd ff ff       	jmp    8048810 <_init+0x30>

Disassembly of section .text:

08048a80 <_start>:
 8048a80:	31 ed                	xor    %ebp,%ebp
 8048a82:	5e                   	pop    %esi
 8048a83:	89 e1                	mov    %esp,%ecx
 8048a85:	83 e4 f0             	and    $0xfffffff0,%esp
 8048a88:	50                   	push   %eax
 8048a89:	54                   	push   %esp
 8048a8a:	52                   	push   %edx
 8048a8b:	68 d0 a2 04 08       	push   $0x804a2d0
 8048a90:	68 70 a2 04 08       	push   $0x804a270
 8048a95:	51                   	push   %ecx
 8048a96:	56                   	push   %esi
 8048a97:	68 f8 90 04 08       	push   $0x80490f8
 8048a9c:	e8 df fe ff ff       	call   8048980 <__libc_start_main@plt>
 8048aa1:	f4                   	hlt    
 8048aa2:	66 90                	xchg   %ax,%ax
 8048aa4:	66 90                	xchg   %ax,%ax
 8048aa6:	66 90                	xchg   %ax,%ax
 8048aa8:	66 90                	xchg   %ax,%ax
 8048aaa:	66 90                	xchg   %ax,%ax
 8048aac:	66 90                	xchg   %ax,%ax
 8048aae:	66 90                	xchg   %ax,%ax

08048ab0 <__x86.get_pc_thunk.bx>:
 8048ab0:	8b 1c 24             	mov    (%esp),%ebx
 8048ab3:	c3                   	ret    
 8048ab4:	66 90                	xchg   %ax,%ax
 8048ab6:	66 90                	xchg   %ax,%ax
 8048ab8:	66 90                	xchg   %ax,%ax
 8048aba:	66 90                	xchg   %ax,%ax
 8048abc:	66 90                	xchg   %ax,%ax
 8048abe:	66 90                	xchg   %ax,%ax

08048ac0 <deregister_tm_clones>:
 8048ac0:	b8 17 d1 04 08       	mov    $0x804d117,%eax
 8048ac5:	2d 14 d1 04 08       	sub    $0x804d114,%eax
 8048aca:	83 f8 06             	cmp    $0x6,%eax
 8048acd:	76 1a                	jbe    8048ae9 <deregister_tm_clones+0x29>
 8048acf:	b8 00 00 00 00       	mov    $0x0,%eax
 8048ad4:	85 c0                	test   %eax,%eax
 8048ad6:	74 11                	je     8048ae9 <deregister_tm_clones+0x29>
 8048ad8:	55                   	push   %ebp
 8048ad9:	89 e5                	mov    %esp,%ebp
 8048adb:	83 ec 14             	sub    $0x14,%esp
 8048ade:	68 14 d1 04 08       	push   $0x804d114
 8048ae3:	ff d0                	call   *%eax
 8048ae5:	83 c4 10             	add    $0x10,%esp
 8048ae8:	c9                   	leave  
 8048ae9:	f3 c3                	repz ret 
 8048aeb:	90                   	nop
 8048aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

08048af0 <register_tm_clones>:
 8048af0:	b8 14 d1 04 08       	mov    $0x804d114,%eax
 8048af5:	2d 14 d1 04 08       	sub    $0x804d114,%eax
 8048afa:	c1 f8 02             	sar    $0x2,%eax
 8048afd:	89 c2                	mov    %eax,%edx
 8048aff:	c1 ea 1f             	shr    $0x1f,%edx
 8048b02:	01 d0                	add    %edx,%eax
 8048b04:	d1 f8                	sar    %eax
 8048b06:	74 1b                	je     8048b23 <register_tm_clones+0x33>
 8048b08:	ba 00 00 00 00       	mov    $0x0,%edx
 8048b0d:	85 d2                	test   %edx,%edx
 8048b0f:	74 12                	je     8048b23 <register_tm_clones+0x33>
 8048b11:	55                   	push   %ebp
 8048b12:	89 e5                	mov    %esp,%ebp
 8048b14:	83 ec 10             	sub    $0x10,%esp
 8048b17:	50                   	push   %eax
 8048b18:	68 14 d1 04 08       	push   $0x804d114
 8048b1d:	ff d2                	call   *%edx
 8048b1f:	83 c4 10             	add    $0x10,%esp
 8048b22:	c9                   	leave  
 8048b23:	f3 c3                	repz ret 
 8048b25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8048b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

08048b30 <__do_global_dtors_aux>:
 8048b30:	80 3d 84 d1 04 08 00 	cmpb   $0x0,0x804d184
 8048b37:	75 13                	jne    8048b4c <__do_global_dtors_aux+0x1c>
 8048b39:	55                   	push   %ebp
 8048b3a:	89 e5                	mov    %esp,%ebp
 8048b3c:	83 ec 08             	sub    $0x8,%esp
 8048b3f:	e8 7c ff ff ff       	call   8048ac0 <deregister_tm_clones>
 8048b44:	c6 05 84 d1 04 08 01 	movb   $0x1,0x804d184
 8048b4b:	c9                   	leave  
 8048b4c:	f3 c3                	repz ret 
 8048b4e:	66 90                	xchg   %ax,%ax

08048b50 <frame_dummy>:
 8048b50:	b8 10 bf 04 08       	mov    $0x804bf10,%eax
 8048b55:	8b 10                	mov    (%eax),%edx
 8048b57:	85 d2                	test   %edx,%edx
 8048b59:	75 05                	jne    8048b60 <frame_dummy+0x10>
 8048b5b:	eb 93                	jmp    8048af0 <register_tm_clones>
 8048b5d:	8d 76 00             	lea    0x0(%esi),%esi
 8048b60:	ba 00 00 00 00       	mov    $0x0,%edx
 8048b65:	85 d2                	test   %edx,%edx
 8048b67:	74 f2                	je     8048b5b <frame_dummy+0xb>
 8048b69:	55                   	push   %ebp
 8048b6a:	89 e5                	mov    %esp,%ebp
 8048b6c:	83 ec 14             	sub    $0x14,%esp
 8048b6f:	50                   	push   %eax
 8048b70:	ff d2                	call   *%edx
 8048b72:	83 c4 10             	add    $0x10,%esp
 8048b75:	c9                   	leave  
 8048b76:	e9 75 ff ff ff       	jmp    8048af0 <register_tm_clones>

08048b7b <smoke>:
 8048b7b:	55                   	push   %ebp
 8048b7c:	89 e5                	mov    %esp,%ebp
 8048b7e:	83 ec 08             	sub    $0x8,%esp
 8048b81:	83 ec 0c             	sub    $0xc,%esp
 8048b84:	68 f0 a2 04 08       	push   $0x804a2f0
 8048b89:	e8 92 fd ff ff       	call   8048920 <puts@plt>
 8048b8e:	83 c4 10             	add    $0x10,%esp
 8048b91:	83 ec 0c             	sub    $0xc,%esp
 8048b94:	6a 00                	push   $0x0
 8048b96:	e8 e5 08 00 00       	call   8049480 <validate>
 8048b9b:	83 c4 10             	add    $0x10,%esp
 8048b9e:	83 ec 0c             	sub    $0xc,%esp
 8048ba1:	6a 00                	push   $0x0
 8048ba3:	e8 98 fd ff ff       	call   8048940 <exit@plt>

08048ba8 <fizz>:
 8048ba8:	55                   	push   %ebp
 8048ba9:	89 e5                	mov    %esp,%ebp
 8048bab:	83 ec 08             	sub    $0x8,%esp
 8048bae:	8b 55 08             	mov    0x8(%ebp),%edx
 8048bb1:	a1 98 d1 04 08       	mov    0x804d198,%eax
 8048bb6:	39 c2                	cmp    %eax,%edx
 8048bb8:	75 22                	jne    8048bdc <fizz+0x34>
 8048bba:	83 ec 08             	sub    $0x8,%esp
 8048bbd:	ff 75 08             	pushl  0x8(%ebp)
 8048bc0:	68 0b a3 04 08       	push   $0x804a30b
 8048bc5:	e8 86 fc ff ff       	call   8048850 <printf@plt>
 8048bca:	83 c4 10             	add    $0x10,%esp
 8048bcd:	83 ec 0c             	sub    $0xc,%esp
 8048bd0:	6a 01                	push   $0x1
 8048bd2:	e8 a9 08 00 00       	call   8049480 <validate>
 8048bd7:	83 c4 10             	add    $0x10,%esp
 8048bda:	eb 13                	jmp    8048bef <fizz+0x47>
 8048bdc:	83 ec 08             	sub    $0x8,%esp
 8048bdf:	ff 75 08             	pushl  0x8(%ebp)
 8048be2:	68 2c a3 04 08       	push   $0x804a32c
 8048be7:	e8 64 fc ff ff       	call   8048850 <printf@plt>
 8048bec:	83 c4 10             	add    $0x10,%esp
 8048bef:	83 ec 0c             	sub    $0xc,%esp
 8048bf2:	6a 00                	push   $0x0
 8048bf4:	e8 47 fd ff ff       	call   8048940 <exit@plt>

08048bf9 <bang>:
 8048bf9:	55                   	push   %ebp
 8048bfa:	89 e5                	mov    %esp,%ebp
 8048bfc:	83 ec 08             	sub    $0x8,%esp
 8048bff:	a1 a0 d1 04 08       	mov    0x804d1a0,%eax
 8048c04:	89 c2                	mov    %eax,%edx
 8048c06:	a1 98 d1 04 08       	mov    0x804d198,%eax
 8048c0b:	39 c2                	cmp    %eax,%edx
 8048c0d:	75 25                	jne    8048c34 <bang+0x3b>
 8048c0f:	a1 a0 d1 04 08       	mov    0x804d1a0,%eax
 8048c14:	83 ec 08             	sub    $0x8,%esp
 8048c17:	50                   	push   %eax
 8048c18:	68 4c a3 04 08       	push   $0x804a34c
 8048c1d:	e8 2e fc ff ff       	call   8048850 <printf@plt>
 8048c22:	83 c4 10             	add    $0x10,%esp
 8048c25:	83 ec 0c             	sub    $0xc,%esp
 8048c28:	6a 02                	push   $0x2
 8048c2a:	e8 51 08 00 00       	call   8049480 <validate>
 8048c2f:	83 c4 10             	add    $0x10,%esp
 8048c32:	eb 16                	jmp    8048c4a <bang+0x51>
 8048c34:	a1 a0 d1 04 08       	mov    0x804d1a0,%eax
 8048c39:	83 ec 08             	sub    $0x8,%esp
 8048c3c:	50                   	push   %eax
 8048c3d:	68 71 a3 04 08       	push   $0x804a371
 8048c42:	e8 09 fc ff ff       	call   8048850 <printf@plt>
 8048c47:	83 c4 10             	add    $0x10,%esp
 8048c4a:	83 ec 0c             	sub    $0xc,%esp
 8048c4d:	6a 00                	push   $0x0
 8048c4f:	e8 ec fc ff ff       	call   8048940 <exit@plt>

08048c54 <test>:
 8048c54:	55                   	push   %ebp
 8048c55:	89 e5                	mov    %esp,%ebp
 8048c57:	83 ec 18             	sub    $0x18,%esp
 8048c5a:	e8 7b 04 00 00       	call   80490da <uniqueval>
 8048c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048c62:	e8 66 00 00 00       	call   8048ccd <getbuf>
 8048c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048c6a:	e8 6b 04 00 00       	call   80490da <uniqueval>
 8048c6f:	89 c2                	mov    %eax,%edx
 8048c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048c74:	39 c2                	cmp    %eax,%edx
 8048c76:	74 12                	je     8048c8a <test+0x36>
 8048c78:	83 ec 0c             	sub    $0xc,%esp
 8048c7b:	68 90 a3 04 08       	push   $0x804a390
 8048c80:	e8 9b fc ff ff       	call   8048920 <puts@plt>
 8048c85:	83 c4 10             	add    $0x10,%esp
 8048c88:	eb 41                	jmp    8048ccb <test+0x77>
 8048c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048c8d:	a1 98 d1 04 08       	mov    0x804d198,%eax
 8048c92:	39 c2                	cmp    %eax,%edx
 8048c94:	75 22                	jne    8048cb8 <test+0x64>
 8048c96:	83 ec 08             	sub    $0x8,%esp
 8048c99:	ff 75 f4             	pushl  -0xc(%ebp)
 8048c9c:	68 b9 a3 04 08       	push   $0x804a3b9
 8048ca1:	e8 aa fb ff ff       	call   8048850 <printf@plt>
 8048ca6:	83 c4 10             	add    $0x10,%esp
 8048ca9:	83 ec 0c             	sub    $0xc,%esp
 8048cac:	6a 03                	push   $0x3
 8048cae:	e8 cd 07 00 00       	call   8049480 <validate>
 8048cb3:	83 c4 10             	add    $0x10,%esp
 8048cb6:	eb 13                	jmp    8048ccb <test+0x77>
 8048cb8:	83 ec 08             	sub    $0x8,%esp
 8048cbb:	ff 75 f4             	pushl  -0xc(%ebp)
 8048cbe:	68 d6 a3 04 08       	push   $0x804a3d6
 8048cc3:	e8 88 fb ff ff       	call   8048850 <printf@plt>
 8048cc8:	83 c4 10             	add    $0x10,%esp
 8048ccb:	c9                   	leave  
 8048ccc:	c3                   	ret    

08048ccd <getbuf>:
 8048ccd:	55                   	push   %ebp
 8048cce:	89 e5                	mov    %esp,%ebp
 8048cd0:	83 ec 28             	sub    $0x28,%esp
 8048cd3:	83 ec 0c             	sub    $0xc,%esp
 8048cd6:	8d 45 d8             	lea    -0x28(%ebp),%eax
 8048cd9:	50                   	push   %eax
 8048cda:	e8 3e 01 00 00       	call   8048e1d <Gets>
 8048cdf:	83 c4 10             	add    $0x10,%esp
 8048ce2:	b8 01 00 00 00       	mov    $0x1,%eax
 8048ce7:	c9                   	leave  
 8048ce8:	c3                   	ret    

08048ce9 <getbufn>:
 8048ce9:	55                   	push   %ebp
 8048cea:	89 e5                	mov    %esp,%ebp
 8048cec:	81 ec 08 02 00 00    	sub    $0x208,%esp
 8048cf2:	83 ec 0c             	sub    $0xc,%esp
 8048cf5:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 8048cfb:	50                   	push   %eax
 8048cfc:	e8 1c 01 00 00       	call   8048e1d <Gets>
 8048d01:	83 c4 10             	add    $0x10,%esp
 8048d04:	b8 01 00 00 00       	mov    $0x1,%eax
 8048d09:	c9                   	leave  
 8048d0a:	c3                   	ret    

08048d0b <testn>:
 8048d0b:	55                   	push   %ebp
 8048d0c:	89 e5                	mov    %esp,%ebp
 8048d0e:	83 ec 18             	sub    $0x18,%esp
 8048d11:	c7 45 f0 ef be ad de 	movl   $0xdeadbeef,-0x10(%ebp)
 8048d18:	e8 cc ff ff ff       	call   8048ce9 <getbufn>
 8048d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048d23:	3d ef be ad de       	cmp    $0xdeadbeef,%eax
 8048d28:	74 12                	je     8048d3c <testn+0x31>
 8048d2a:	83 ec 0c             	sub    $0xc,%esp
 8048d2d:	68 90 a3 04 08       	push   $0x804a390
 8048d32:	e8 e9 fb ff ff       	call   8048920 <puts@plt>
 8048d37:	83 c4 10             	add    $0x10,%esp
 8048d3a:	eb 41                	jmp    8048d7d <testn+0x72>
 8048d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048d3f:	a1 98 d1 04 08       	mov    0x804d198,%eax
 8048d44:	39 c2                	cmp    %eax,%edx
 8048d46:	75 22                	jne    8048d6a <testn+0x5f>
 8048d48:	83 ec 08             	sub    $0x8,%esp
 8048d4b:	ff 75 f4             	pushl  -0xc(%ebp)
 8048d4e:	68 f4 a3 04 08       	push   $0x804a3f4
 8048d53:	e8 f8 fa ff ff       	call   8048850 <printf@plt>
 8048d58:	83 c4 10             	add    $0x10,%esp
 8048d5b:	83 ec 0c             	sub    $0xc,%esp
 8048d5e:	6a 04                	push   $0x4
 8048d60:	e8 1b 07 00 00       	call   8049480 <validate>
 8048d65:	83 c4 10             	add    $0x10,%esp
 8048d68:	eb 13                	jmp    8048d7d <testn+0x72>
 8048d6a:	83 ec 08             	sub    $0x8,%esp
 8048d6d:	ff 75 f4             	pushl  -0xc(%ebp)
 8048d70:	68 14 a4 04 08       	push   $0x804a414
 8048d75:	e8 d6 fa ff ff       	call   8048850 <printf@plt>
 8048d7a:	83 c4 10             	add    $0x10,%esp
 8048d7d:	c9                   	leave  
 8048d7e:	c3                   	ret    

08048d7f <save_char>:
 8048d7f:	55                   	push   %ebp
 8048d80:	89 e5                	mov    %esp,%ebp
 8048d82:	83 ec 04             	sub    $0x4,%esp
 8048d85:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d88:	88 45 fc             	mov    %al,-0x4(%ebp)
 8048d8b:	a1 a4 d1 04 08       	mov    0x804d1a4,%eax
 8048d90:	3d ff 03 00 00       	cmp    $0x3ff,%eax
 8048d95:	7f 6c                	jg     8048e03 <save_char+0x84>
 8048d97:	8b 15 a4 d1 04 08    	mov    0x804d1a4,%edx
 8048d9d:	89 d0                	mov    %edx,%eax
 8048d9f:	01 c0                	add    %eax,%eax
 8048da1:	01 c2                	add    %eax,%edx
 8048da3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 8048da7:	c0 f8 04             	sar    $0x4,%al
 8048daa:	0f be c0             	movsbl %al,%eax
 8048dad:	83 e0 0f             	and    $0xf,%eax
 8048db0:	0f b6 80 c8 c0 04 08 	movzbl 0x804c0c8(%eax),%eax
 8048db7:	88 82 00 d2 04 08    	mov    %al,0x804d200(%edx)
 8048dbd:	8b 15 a4 d1 04 08    	mov    0x804d1a4,%edx
 8048dc3:	89 d0                	mov    %edx,%eax
 8048dc5:	01 c0                	add    %eax,%eax
 8048dc7:	01 d0                	add    %edx,%eax
 8048dc9:	8d 50 01             	lea    0x1(%eax),%edx
 8048dcc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 8048dd0:	83 e0 0f             	and    $0xf,%eax
 8048dd3:	0f b6 80 c8 c0 04 08 	movzbl 0x804c0c8(%eax),%eax
 8048dda:	88 82 00 d2 04 08    	mov    %al,0x804d200(%edx)
 8048de0:	8b 15 a4 d1 04 08    	mov    0x804d1a4,%edx
 8048de6:	89 d0                	mov    %edx,%eax
 8048de8:	01 c0                	add    %eax,%eax
 8048dea:	01 d0                	add    %edx,%eax
 8048dec:	83 c0 02             	add    $0x2,%eax
 8048def:	c6 80 00 d2 04 08 20 	movb   $0x20,0x804d200(%eax)
 8048df6:	a1 a4 d1 04 08       	mov    0x804d1a4,%eax
 8048dfb:	83 c0 01             	add    $0x1,%eax
 8048dfe:	a3 a4 d1 04 08       	mov    %eax,0x804d1a4
 8048e03:	c9                   	leave  
 8048e04:	c3                   	ret    

08048e05 <save_term>:
 8048e05:	55                   	push   %ebp
 8048e06:	89 e5                	mov    %esp,%ebp
 8048e08:	8b 15 a4 d1 04 08    	mov    0x804d1a4,%edx
 8048e0e:	89 d0                	mov    %edx,%eax
 8048e10:	01 c0                	add    %eax,%eax
 8048e12:	01 d0                	add    %edx,%eax
 8048e14:	c6 80 00 d2 04 08 00 	movb   $0x0,0x804d200(%eax)
 8048e1b:	5d                   	pop    %ebp
 8048e1c:	c3                   	ret    

08048e1d <Gets>:
 8048e1d:	55                   	push   %ebp
 8048e1e:	89 e5                	mov    %esp,%ebp
 8048e20:	83 ec 18             	sub    $0x18,%esp
 8048e23:	8b 45 08             	mov    0x8(%ebp),%eax
 8048e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048e29:	c7 05 a4 d1 04 08 00 	movl   $0x0,0x804d1a4
 8048e30:	00 00 00 
 8048e33:	eb 1d                	jmp    8048e52 <Gets+0x35>
 8048e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e38:	8d 50 01             	lea    0x1(%eax),%edx
 8048e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8048e3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048e41:	88 10                	mov    %dl,(%eax)
 8048e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048e46:	0f be c0             	movsbl %al,%eax
 8048e49:	50                   	push   %eax
 8048e4a:	e8 30 ff ff ff       	call   8048d7f <save_char>
 8048e4f:	83 c4 04             	add    $0x4,%esp
 8048e52:	a1 94 d1 04 08       	mov    0x804d194,%eax
 8048e57:	83 ec 0c             	sub    $0xc,%esp
 8048e5a:	50                   	push   %eax
 8048e5b:	e8 50 fa ff ff       	call   80488b0 <_IO_getc@plt>
 8048e60:	83 c4 10             	add    $0x10,%esp
 8048e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048e66:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 8048e6a:	74 06                	je     8048e72 <Gets+0x55>
 8048e6c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
 8048e70:	75 c3                	jne    8048e35 <Gets+0x18>
 8048e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e75:	8d 50 01             	lea    0x1(%eax),%edx
 8048e78:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8048e7b:	c6 00 00             	movb   $0x0,(%eax)
 8048e7e:	e8 82 ff ff ff       	call   8048e05 <save_term>
 8048e83:	8b 45 08             	mov    0x8(%ebp),%eax
 8048e86:	c9                   	leave  
 8048e87:	c3                   	ret    

08048e88 <usage>:
 8048e88:	55                   	push   %ebp
 8048e89:	89 e5                	mov    %esp,%ebp
 8048e8b:	83 ec 08             	sub    $0x8,%esp
 8048e8e:	83 ec 08             	sub    $0x8,%esp
 8048e91:	ff 75 08             	pushl  0x8(%ebp)
 8048e94:	68 30 a4 04 08       	push   $0x804a430
 8048e99:	e8 b2 f9 ff ff       	call   8048850 <printf@plt>
 8048e9e:	83 c4 10             	add    $0x10,%esp
 8048ea1:	83 ec 0c             	sub    $0xc,%esp
 8048ea4:	68 4e a4 04 08       	push   $0x804a44e
 8048ea9:	e8 72 fa ff ff       	call   8048920 <puts@plt>
 8048eae:	83 c4 10             	add    $0x10,%esp
 8048eb1:	83 ec 0c             	sub    $0xc,%esp
 8048eb4:	68 64 a4 04 08       	push   $0x804a464
 8048eb9:	e8 62 fa ff ff       	call   8048920 <puts@plt>
 8048ebe:	83 c4 10             	add    $0x10,%esp
 8048ec1:	83 ec 0c             	sub    $0xc,%esp
 8048ec4:	68 80 a4 04 08       	push   $0x804a480
 8048ec9:	e8 52 fa ff ff       	call   8048920 <puts@plt>
 8048ece:	83 c4 10             	add    $0x10,%esp
 8048ed1:	83 ec 0c             	sub    $0xc,%esp
 8048ed4:	68 bc a4 04 08       	push   $0x804a4bc
 8048ed9:	e8 42 fa ff ff       	call   8048920 <puts@plt>
 8048ede:	83 c4 10             	add    $0x10,%esp
 8048ee1:	83 ec 0c             	sub    $0xc,%esp
 8048ee4:	6a 00                	push   $0x0
 8048ee6:	e8 55 fa ff ff       	call   8048940 <exit@plt>

08048eeb <bushandler>:
 8048eeb:	55                   	push   %ebp
 8048eec:	89 e5                	mov    %esp,%ebp
 8048eee:	83 ec 08             	sub    $0x8,%esp
 8048ef1:	83 ec 0c             	sub    $0xc,%esp
 8048ef4:	68 e4 a4 04 08       	push   $0x804a4e4
 8048ef9:	e8 22 fa ff ff       	call   8048920 <puts@plt>
 8048efe:	83 c4 10             	add    $0x10,%esp
 8048f01:	83 ec 0c             	sub    $0xc,%esp
 8048f04:	68 04 a5 04 08       	push   $0x804a504
 8048f09:	e8 12 fa ff ff       	call   8048920 <puts@plt>
 8048f0e:	83 c4 10             	add    $0x10,%esp
 8048f11:	83 ec 0c             	sub    $0xc,%esp
 8048f14:	6a 00                	push   $0x0
 8048f16:	e8 25 fa ff ff       	call   8048940 <exit@plt>

08048f1b <seghandler>:
 8048f1b:	55                   	push   %ebp
 8048f1c:	89 e5                	mov    %esp,%ebp
 8048f1e:	83 ec 08             	sub    $0x8,%esp
 8048f21:	83 ec 0c             	sub    $0xc,%esp
 8048f24:	68 1c a5 04 08       	push   $0x804a51c
 8048f29:	e8 f2 f9 ff ff       	call   8048920 <puts@plt>
 8048f2e:	83 c4 10             	add    $0x10,%esp
 8048f31:	83 ec 0c             	sub    $0xc,%esp
 8048f34:	68 04 a5 04 08       	push   $0x804a504
 8048f39:	e8 e2 f9 ff ff       	call   8048920 <puts@plt>
 8048f3e:	83 c4 10             	add    $0x10,%esp
 8048f41:	83 ec 0c             	sub    $0xc,%esp
 8048f44:	6a 00                	push   $0x0
 8048f46:	e8 f5 f9 ff ff       	call   8048940 <exit@plt>

08048f4b <illegalhandler>:
 8048f4b:	55                   	push   %ebp
 8048f4c:	89 e5                	mov    %esp,%ebp
 8048f4e:	83 ec 08             	sub    $0x8,%esp
 8048f51:	83 ec 0c             	sub    $0xc,%esp
 8048f54:	68 44 a5 04 08       	push   $0x804a544
 8048f59:	e8 c2 f9 ff ff       	call   8048920 <puts@plt>
 8048f5e:	83 c4 10             	add    $0x10,%esp
 8048f61:	83 ec 0c             	sub    $0xc,%esp
 8048f64:	68 04 a5 04 08       	push   $0x804a504
 8048f69:	e8 b2 f9 ff ff       	call   8048920 <puts@plt>
 8048f6e:	83 c4 10             	add    $0x10,%esp
 8048f71:	83 ec 0c             	sub    $0xc,%esp
 8048f74:	6a 00                	push   $0x0
 8048f76:	e8 c5 f9 ff ff       	call   8048940 <exit@plt>

08048f7b <launch>:
 8048f7b:	55                   	push   %ebp
 8048f7c:	89 e5                	mov    %esp,%ebp
 8048f7e:	83 ec 58             	sub    $0x58,%esp
 8048f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048f88:	8d 45 b0             	lea    -0x50(%ebp),%eax
 8048f8b:	25 f0 3f 00 00       	and    $0x3ff0,%eax
 8048f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048f93:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f99:	01 d0                	add    %edx,%eax
 8048f9b:	8d 50 0f             	lea    0xf(%eax),%edx
 8048f9e:	b8 10 00 00 00       	mov    $0x10,%eax
 8048fa3:	83 e8 01             	sub    $0x1,%eax
 8048fa6:	01 d0                	add    %edx,%eax
 8048fa8:	b9 10 00 00 00       	mov    $0x10,%ecx
 8048fad:	ba 00 00 00 00       	mov    $0x0,%edx
 8048fb2:	f7 f1                	div    %ecx
 8048fb4:	6b c0 10             	imul   $0x10,%eax,%eax
 8048fb7:	29 c4                	sub    %eax,%esp
 8048fb9:	89 e0                	mov    %esp,%eax
 8048fbb:	83 c0 0f             	add    $0xf,%eax
 8048fbe:	c1 e8 04             	shr    $0x4,%eax
 8048fc1:	c1 e0 04             	shl    $0x4,%eax
 8048fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048fc7:	83 ec 04             	sub    $0x4,%esp
 8048fca:	ff 75 f4             	pushl  -0xc(%ebp)
 8048fcd:	68 f4 00 00 00       	push   $0xf4
 8048fd2:	ff 75 f0             	pushl  -0x10(%ebp)
 8048fd5:	e8 f6 f9 ff ff       	call   80489d0 <memset@plt>
 8048fda:	83 c4 10             	add    $0x10,%esp
 8048fdd:	83 ec 0c             	sub    $0xc,%esp
 8048fe0:	68 6f a5 04 08       	push   $0x804a56f
 8048fe5:	e8 66 f8 ff ff       	call   8048850 <printf@plt>
 8048fea:	83 c4 10             	add    $0x10,%esp
 8048fed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048ff1:	74 07                	je     8048ffa <launch+0x7f>
 8048ff3:	e8 13 fd ff ff       	call   8048d0b <testn>
 8048ff8:	eb 05                	jmp    8048fff <launch+0x84>
 8048ffa:	e8 55 fc ff ff       	call   8048c54 <test>
 8048fff:	a1 9c d1 04 08       	mov    0x804d19c,%eax
 8049004:	85 c0                	test   %eax,%eax
 8049006:	75 1a                	jne    8049022 <launch+0xa7>
 8049008:	83 ec 0c             	sub    $0xc,%esp
 804900b:	68 04 a5 04 08       	push   $0x804a504
 8049010:	e8 0b f9 ff ff       	call   8048920 <puts@plt>
 8049015:	83 c4 10             	add    $0x10,%esp
 8049018:	c7 05 9c d1 04 08 00 	movl   $0x0,0x804d19c
 804901f:	00 00 00 
 8049022:	c9                   	leave  
 8049023:	c3                   	ret    

08049024 <launcher>:
 8049024:	55                   	push   %ebp
 8049025:	89 e5                	mov    %esp,%ebp
 8049027:	83 ec 18             	sub    $0x18,%esp
 804902a:	8b 45 08             	mov    0x8(%ebp),%eax
 804902d:	a3 a8 d1 04 08       	mov    %eax,0x804d1a8
 8049032:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049035:	a3 ac d1 04 08       	mov    %eax,0x804d1ac
 804903a:	83 ec 08             	sub    $0x8,%esp
 804903d:	6a 00                	push   $0x0
 804903f:	6a 00                	push   $0x0
 8049041:	68 32 01 00 00       	push   $0x132
 8049046:	6a 07                	push   $0x7
 8049048:	68 00 00 10 00       	push   $0x100000
 804904d:	68 00 60 58 55       	push   $0x55586000
 8049052:	e8 09 f9 ff ff       	call   8048960 <mmap@plt>
 8049057:	83 c4 20             	add    $0x20,%esp
 804905a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804905d:	81 7d f4 00 60 58 55 	cmpl   $0x55586000,-0xc(%ebp)
 8049064:	74 21                	je     8049087 <launcher+0x63>
 8049066:	a1 40 d1 04 08       	mov    0x804d140,%eax
 804906b:	50                   	push   %eax
 804906c:	6a 47                	push   $0x47
 804906e:	6a 01                	push   $0x1
 8049070:	68 7c a5 04 08       	push   $0x804a57c
 8049075:	e8 56 f8 ff ff       	call   80488d0 <fwrite@plt>
 804907a:	83 c4 10             	add    $0x10,%esp
 804907d:	83 ec 0c             	sub    $0xc,%esp
 8049080:	6a 01                	push   $0x1
 8049082:	e8 b9 f8 ff ff       	call   8048940 <exit@plt>
 8049087:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804908a:	05 f8 ff 0f 00       	add    $0xffff8,%eax
 804908f:	a3 c0 d1 04 08       	mov    %eax,0x804d1c0
 8049094:	8b 15 c0 d1 04 08    	mov    0x804d1c0,%edx
 804909a:	89 e0                	mov    %esp,%eax
 804909c:	89 d4                	mov    %edx,%esp
 804909e:	89 c2                	mov    %eax,%edx
 80490a0:	89 15 b0 d1 04 08    	mov    %edx,0x804d1b0
 80490a6:	8b 15 ac d1 04 08    	mov    0x804d1ac,%edx
 80490ac:	a1 a8 d1 04 08       	mov    0x804d1a8,%eax
 80490b1:	83 ec 08             	sub    $0x8,%esp
 80490b4:	52                   	push   %edx
 80490b5:	50                   	push   %eax
 80490b6:	e8 c0 fe ff ff       	call   8048f7b <launch>
 80490bb:	83 c4 10             	add    $0x10,%esp
 80490be:	a1 b0 d1 04 08       	mov    0x804d1b0,%eax
 80490c3:	89 c4                	mov    %eax,%esp
 80490c5:	83 ec 08             	sub    $0x8,%esp
 80490c8:	68 00 00 10 00       	push   $0x100000
 80490cd:	ff 75 f4             	pushl  -0xc(%ebp)
 80490d0:	e8 2b f9 ff ff       	call   8048a00 <munmap@plt>
 80490d5:	83 c4 10             	add    $0x10,%esp
 80490d8:	c9                   	leave  
 80490d9:	c3                   	ret    

080490da <uniqueval>:
 80490da:	55                   	push   %ebp
 80490db:	89 e5                	mov    %esp,%ebp
 80490dd:	83 ec 08             	sub    $0x8,%esp
 80490e0:	e8 1b f8 ff ff       	call   8048900 <getpid@plt>
 80490e5:	83 ec 0c             	sub    $0xc,%esp
 80490e8:	50                   	push   %eax
 80490e9:	e8 52 f7 ff ff       	call   8048840 <srandom@plt>
 80490ee:	83 c4 10             	add    $0x10,%esp
 80490f1:	e8 3a f9 ff ff       	call   8048a30 <random@plt>
 80490f6:	c9                   	leave  
 80490f7:	c3                   	ret    

080490f8 <main>:
 80490f8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 80490fc:	83 e4 f0             	and    $0xfffffff0,%esp
 80490ff:	ff 71 fc             	pushl  -0x4(%ecx)
 8049102:	55                   	push   %ebp
 8049103:	89 e5                	mov    %esp,%ebp
 8049105:	53                   	push   %ebx
 8049106:	51                   	push   %ecx
 8049107:	83 ec 20             	sub    $0x20,%esp
 804910a:	89 cb                	mov    %ecx,%ebx
 804910c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 8049113:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 804911a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
 8049121:	83 ec 08             	sub    $0x8,%esp
 8049124:	68 1b 8f 04 08       	push   $0x8048f1b
 8049129:	6a 0b                	push   $0xb
 804912b:	e8 60 f7 ff ff       	call   8048890 <signal@plt>
 8049130:	83 c4 10             	add    $0x10,%esp
 8049133:	83 ec 08             	sub    $0x8,%esp
 8049136:	68 eb 8e 04 08       	push   $0x8048eeb
 804913b:	6a 07                	push   $0x7
 804913d:	e8 4e f7 ff ff       	call   8048890 <signal@plt>
 8049142:	83 c4 10             	add    $0x10,%esp
 8049145:	83 ec 08             	sub    $0x8,%esp
 8049148:	68 4b 8f 04 08       	push   $0x8048f4b
 804914d:	6a 04                	push   $0x4
 804914f:	e8 3c f7 ff ff       	call   8048890 <signal@plt>
 8049154:	83 c4 10             	add    $0x10,%esp
 8049157:	a1 60 d1 04 08       	mov    0x804d160,%eax
 804915c:	a3 94 d1 04 08       	mov    %eax,0x804d194
 8049161:	e9 8f 00 00 00       	jmp    80491f5 <main+0xfd>
 8049166:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
 804916a:	83 e8 67             	sub    $0x67,%eax
 804916d:	83 f8 0e             	cmp    $0xe,%eax
 8049170:	77 72                	ja     80491e4 <main+0xec>
 8049172:	8b 04 85 14 a6 04 08 	mov    0x804a614(,%eax,4),%eax
 8049179:	ff e0                	jmp    *%eax
 804917b:	8b 43 04             	mov    0x4(%ebx),%eax
 804917e:	8b 00                	mov    (%eax),%eax
 8049180:	83 ec 0c             	sub    $0xc,%esp
 8049183:	50                   	push   %eax
 8049184:	e8 ff fc ff ff       	call   8048e88 <usage>
 8049189:	83 c4 10             	add    $0x10,%esp
 804918c:	eb 67                	jmp    80491f5 <main+0xfd>
 804918e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8049195:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%ebp)
 804919c:	eb 57                	jmp    80491f5 <main+0xfd>
 804919e:	a1 80 d1 04 08       	mov    0x804d180,%eax
 80491a3:	83 ec 0c             	sub    $0xc,%esp
 80491a6:	50                   	push   %eax
 80491a7:	e8 b4 f6 ff ff       	call   8048860 <strdup@plt>
 80491ac:	83 c4 10             	add    $0x10,%esp
 80491af:	a3 88 d1 04 08       	mov    %eax,0x804d188
 80491b4:	a1 88 d1 04 08       	mov    0x804d188,%eax
 80491b9:	83 ec 0c             	sub    $0xc,%esp
 80491bc:	50                   	push   %eax
 80491bd:	e8 64 10 00 00       	call   804a226 <gencookie>
 80491c2:	83 c4 10             	add    $0x10,%esp
 80491c5:	a3 98 d1 04 08       	mov    %eax,0x804d198
 80491ca:	eb 29                	jmp    80491f5 <main+0xfd>
 80491cc:	c7 05 8c d1 04 08 01 	movl   $0x1,0x804d18c
 80491d3:	00 00 00 
 80491d6:	eb 1d                	jmp    80491f5 <main+0xfd>
 80491d8:	c7 05 90 d1 04 08 01 	movl   $0x1,0x804d190
 80491df:	00 00 00 
 80491e2:	eb 11                	jmp    80491f5 <main+0xfd>
 80491e4:	8b 43 04             	mov    0x4(%ebx),%eax
 80491e7:	8b 00                	mov    (%eax),%eax
 80491e9:	83 ec 0c             	sub    $0xc,%esp
 80491ec:	50                   	push   %eax
 80491ed:	e8 96 fc ff ff       	call   8048e88 <usage>
 80491f2:	83 c4 10             	add    $0x10,%esp
 80491f5:	83 ec 04             	sub    $0x4,%esp
 80491f8:	68 c4 a5 04 08       	push   $0x804a5c4
 80491fd:	ff 73 04             	pushl  0x4(%ebx)
 8049200:	ff 33                	pushl  (%ebx)
 8049202:	e8 99 f7 ff ff       	call   80489a0 <getopt@plt>
 8049207:	83 c4 10             	add    $0x10,%esp
 804920a:	88 45 e7             	mov    %al,-0x19(%ebp)
 804920d:	80 7d e7 ff          	cmpb   $0xff,-0x19(%ebp)
 8049211:	0f 85 4f ff ff ff    	jne    8049166 <main+0x6e>
 8049217:	a1 88 d1 04 08       	mov    0x804d188,%eax
 804921c:	85 c0                	test   %eax,%eax
 804921e:	75 27                	jne    8049247 <main+0x14f>
 8049220:	8b 43 04             	mov    0x4(%ebx),%eax
 8049223:	8b 00                	mov    (%eax),%eax
 8049225:	83 ec 08             	sub    $0x8,%esp
 8049228:	50                   	push   %eax
 8049229:	68 cc a5 04 08       	push   $0x804a5cc
 804922e:	e8 1d f6 ff ff       	call   8048850 <printf@plt>
 8049233:	83 c4 10             	add    $0x10,%esp
 8049236:	8b 43 04             	mov    0x4(%ebx),%eax
 8049239:	8b 00                	mov    (%eax),%eax
 804923b:	83 ec 0c             	sub    $0xc,%esp
 804923e:	50                   	push   %eax
 804923f:	e8 44 fc ff ff       	call   8048e88 <usage>
 8049244:	83 c4 10             	add    $0x10,%esp
 8049247:	e8 ef 00 00 00       	call   804933b <initialize_bomb>
 804924c:	a1 88 d1 04 08       	mov    0x804d188,%eax
 8049251:	83 ec 08             	sub    $0x8,%esp
 8049254:	50                   	push   %eax
 8049255:	68 f8 a5 04 08       	push   $0x804a5f8
 804925a:	e8 f1 f5 ff ff       	call   8048850 <printf@plt>
 804925f:	83 c4 10             	add    $0x10,%esp
 8049262:	a1 98 d1 04 08       	mov    0x804d198,%eax
 8049267:	83 ec 08             	sub    $0x8,%esp
 804926a:	50                   	push   %eax
 804926b:	68 04 a6 04 08       	push   $0x804a604
 8049270:	e8 db f5 ff ff       	call   8048850 <printf@plt>
 8049275:	83 c4 10             	add    $0x10,%esp
 8049278:	a1 98 d1 04 08       	mov    0x804d198,%eax
 804927d:	83 ec 0c             	sub    $0xc,%esp
 8049280:	50                   	push   %eax
 8049281:	e8 ba f5 ff ff       	call   8048840 <srandom@plt>
 8049286:	83 c4 10             	add    $0x10,%esp
 8049289:	e8 a2 f7 ff ff       	call   8048a30 <random@plt>
 804928e:	25 f0 0f 00 00       	and    $0xff0,%eax
 8049293:	05 00 01 00 00       	add    $0x100,%eax
 8049298:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804929b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804929e:	83 ec 08             	sub    $0x8,%esp
 80492a1:	6a 04                	push   $0x4
 80492a3:	50                   	push   %eax
 80492a4:	e8 c7 f7 ff ff       	call   8048a70 <calloc@plt>
 80492a9:	83 c4 10             	add    $0x10,%esp
 80492ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
 80492af:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80492b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 80492b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 80492bf:	eb 29                	jmp    80492ea <main+0x1f2>
 80492c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80492c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 80492cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80492ce:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 80492d1:	e8 5a f7 ff ff       	call   8048a30 <random@plt>
 80492d6:	25 f0 00 00 00       	and    $0xf0,%eax
 80492db:	ba 80 00 00 00       	mov    $0x80,%edx
 80492e0:	29 c2                	sub    %eax,%edx
 80492e2:	89 d0                	mov    %edx,%eax
 80492e4:	89 03                	mov    %eax,(%ebx)
 80492e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 80492ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80492ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80492f0:	7c cf                	jl     80492c1 <main+0x1c9>
 80492f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80492f9:	eb 29                	jmp    8049324 <main+0x22c>
 80492fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80492fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 8049305:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049308:	01 d0                	add    %edx,%eax
 804930a:	8b 10                	mov    (%eax),%edx
 804930c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804930f:	01 d0                	add    %edx,%eax
 8049311:	83 ec 08             	sub    $0x8,%esp
 8049314:	50                   	push   %eax
 8049315:	ff 75 f4             	pushl  -0xc(%ebp)
 8049318:	e8 07 fd ff ff       	call   8049024 <launcher>
 804931d:	83 c4 10             	add    $0x10,%esp
 8049320:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8049324:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049327:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 804932a:	7c cf                	jl     80492fb <main+0x203>
 804932c:	b8 00 00 00 00       	mov    $0x0,%eax
 8049331:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8049334:	59                   	pop    %ecx
 8049335:	5b                   	pop    %ebx
 8049336:	5d                   	pop    %ebp
 8049337:	8d 61 fc             	lea    -0x4(%ecx),%esp
 804933a:	c3                   	ret    

0804933b <initialize_bomb>:
 804933b:	55                   	push   %ebp
 804933c:	89 e5                	mov    %esp,%ebp
 804933e:	81 ec 18 24 00 00    	sub    $0x2418,%esp
 8049344:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804934b:	a1 90 d1 04 08       	mov    0x804d190,%eax
 8049350:	85 c0                	test   %eax,%eax
 8049352:	74 0d                	je     8049361 <initialize_bomb+0x26>
 8049354:	83 ec 0c             	sub    $0xc,%esp
 8049357:	6a ff                	push   $0xffffffff
 8049359:	e8 db 0b 00 00       	call   8049f39 <init_timeout>
 804935e:	83 c4 10             	add    $0x10,%esp
 8049361:	a1 8c d1 04 08       	mov    0x804d18c,%eax
 8049366:	85 c0                	test   %eax,%eax
 8049368:	0f 84 10 01 00 00    	je     804947e <initialize_bomb+0x143>
 804936e:	83 ec 08             	sub    $0x8,%esp
 8049371:	68 00 04 00 00       	push   $0x400
 8049376:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
 804937c:	50                   	push   %eax
 804937d:	e8 8e f5 ff ff       	call   8048910 <gethostname@plt>
 8049382:	83 c4 10             	add    $0x10,%esp
 8049385:	85 c0                	test   %eax,%eax
 8049387:	74 1a                	je     80493a3 <initialize_bomb+0x68>
 8049389:	83 ec 0c             	sub    $0xc,%esp
 804938c:	68 ac a6 04 08       	push   $0x804a6ac
 8049391:	e8 8a f5 ff ff       	call   8048920 <puts@plt>
 8049396:	83 c4 10             	add    $0x10,%esp
 8049399:	83 ec 0c             	sub    $0xc,%esp
 804939c:	6a 08                	push   $0x8
 804939e:	e8 9d f5 ff ff       	call   8048940 <exit@plt>
 80493a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80493aa:	eb 2e                	jmp    80493da <initialize_bomb+0x9f>
 80493ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80493af:	8b 04 85 00 c1 04 08 	mov    0x804c100(,%eax,4),%eax
 80493b6:	83 ec 08             	sub    $0x8,%esp
 80493b9:	8d 95 f0 fb ff ff    	lea    -0x410(%ebp),%edx
 80493bf:	52                   	push   %edx
 80493c0:	50                   	push   %eax
 80493c1:	e8 ea f5 ff ff       	call   80489b0 <strcasecmp@plt>
 80493c6:	83 c4 10             	add    $0x10,%esp
 80493c9:	85 c0                	test   %eax,%eax
 80493cb:	75 09                	jne    80493d6 <initialize_bomb+0x9b>
 80493cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 80493d4:	eb 12                	jmp    80493e8 <initialize_bomb+0xad>
 80493d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80493da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80493dd:	8b 04 85 00 c1 04 08 	mov    0x804c100(,%eax,4),%eax
 80493e4:	85 c0                	test   %eax,%eax
 80493e6:	75 c4                	jne    80493ac <initialize_bomb+0x71>
 80493e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 80493ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80493f3:	75 52                	jne    8049447 <initialize_bomb+0x10c>
 80493f5:	83 ec 08             	sub    $0x8,%esp
 80493f8:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
 80493fe:	50                   	push   %eax
 80493ff:	68 e4 a6 04 08       	push   $0x804a6e4
 8049404:	e8 47 f4 ff ff       	call   8048850 <printf@plt>
 8049409:	83 c4 10             	add    $0x10,%esp
 804940c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8049413:	eb 1a                	jmp    804942f <initialize_bomb+0xf4>
 8049415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049418:	8b 04 85 00 c1 04 08 	mov    0x804c100(,%eax,4),%eax
 804941f:	83 ec 0c             	sub    $0xc,%esp
 8049422:	50                   	push   %eax
 8049423:	e8 f8 f4 ff ff       	call   8048920 <puts@plt>
 8049428:	83 c4 10             	add    $0x10,%esp
 804942b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804942f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049432:	8b 04 85 00 c1 04 08 	mov    0x804c100(,%eax,4),%eax
 8049439:	85 c0                	test   %eax,%eax
 804943b:	75 d8                	jne    8049415 <initialize_bomb+0xda>
 804943d:	83 ec 0c             	sub    $0xc,%esp
 8049440:	6a 08                	push   $0x8
 8049442:	e8 f9 f4 ff ff       	call   8048940 <exit@plt>
 8049447:	83 ec 0c             	sub    $0xc,%esp
 804944a:	8d 85 f0 db ff ff    	lea    -0x2410(%ebp),%eax
 8049450:	50                   	push   %eax
 8049451:	e8 21 0b 00 00       	call   8049f77 <init_driver>
 8049456:	83 c4 10             	add    $0x10,%esp
 8049459:	85 c0                	test   %eax,%eax
 804945b:	79 21                	jns    804947e <initialize_bomb+0x143>
 804945d:	83 ec 08             	sub    $0x8,%esp
 8049460:	8d 85 f0 db ff ff    	lea    -0x2410(%ebp),%eax
 8049466:	50                   	push   %eax
 8049467:	68 1f a7 04 08       	push   $0x804a71f
 804946c:	e8 df f3 ff ff       	call   8048850 <printf@plt>
 8049471:	83 c4 10             	add    $0x10,%esp
 8049474:	83 ec 0c             	sub    $0xc,%esp
 8049477:	6a 08                	push   $0x8
 8049479:	e8 c2 f4 ff ff       	call   8048940 <exit@plt>
 804947e:	c9                   	leave  
 804947f:	c3                   	ret    

08049480 <validate>:
 8049480:	55                   	push   %ebp
 8049481:	89 e5                	mov    %esp,%ebp
 8049483:	81 ec 18 40 00 00    	sub    $0x4018,%esp
 8049489:	a1 88 d1 04 08       	mov    0x804d188,%eax
 804948e:	85 c0                	test   %eax,%eax
 8049490:	75 15                	jne    80494a7 <validate+0x27>
 8049492:	83 ec 0c             	sub    $0xc,%esp
 8049495:	68 34 a7 04 08       	push   $0x804a734
 804949a:	e8 81 f4 ff ff       	call   8048920 <puts@plt>
 804949f:	83 c4 10             	add    $0x10,%esp
 80494a2:	e9 36 01 00 00       	jmp    80495dd <validate+0x15d>
 80494a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 80494ab:	78 06                	js     80494b3 <validate+0x33>
 80494ad:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
 80494b1:	7e 15                	jle    80494c8 <validate+0x48>
 80494b3:	83 ec 0c             	sub    $0xc,%esp
 80494b6:	68 60 a7 04 08       	push   $0x804a760
 80494bb:	e8 60 f4 ff ff       	call   8048920 <puts@plt>
 80494c0:	83 c4 10             	add    $0x10,%esp
 80494c3:	e9 15 01 00 00       	jmp    80495dd <validate+0x15d>
 80494c8:	c7 05 9c d1 04 08 01 	movl   $0x1,0x804d19c
 80494cf:	00 00 00 
 80494d2:	8b 45 08             	mov    0x8(%ebp),%eax
 80494d5:	8b 04 85 00 d1 04 08 	mov    0x804d100(,%eax,4),%eax
 80494dc:	8d 50 ff             	lea    -0x1(%eax),%edx
 80494df:	8b 45 08             	mov    0x8(%ebp),%eax
 80494e2:	89 14 85 00 d1 04 08 	mov    %edx,0x804d100(,%eax,4)
 80494e9:	8b 45 08             	mov    0x8(%ebp),%eax
 80494ec:	8b 04 85 00 d1 04 08 	mov    0x804d100(,%eax,4),%eax
 80494f3:	85 c0                	test   %eax,%eax
 80494f5:	7e 15                	jle    804950c <validate+0x8c>
 80494f7:	83 ec 0c             	sub    $0xc,%esp
 80494fa:	68 86 a7 04 08       	push   $0x804a786
 80494ff:	e8 1c f4 ff ff       	call   8048920 <puts@plt>
 8049504:	83 c4 10             	add    $0x10,%esp
 8049507:	e9 d1 00 00 00       	jmp    80495dd <validate+0x15d>
 804950c:	83 ec 0c             	sub    $0xc,%esp
 804950f:	68 91 a7 04 08       	push   $0x804a791
 8049514:	e8 07 f4 ff ff       	call   8048920 <puts@plt>
 8049519:	83 c4 10             	add    $0x10,%esp
 804951c:	a1 8c d1 04 08       	mov    0x804d18c,%eax
 8049521:	85 c0                	test   %eax,%eax
 8049523:	0f 84 a4 00 00 00    	je     80495cd <validate+0x14d>
 8049529:	83 ec 0c             	sub    $0xc,%esp
 804952c:	68 00 d2 04 08       	push   $0x804d200
 8049531:	e8 3a f4 ff ff       	call   8048970 <strlen@plt>
 8049536:	83 c4 10             	add    $0x10,%esp
 8049539:	83 c0 20             	add    $0x20,%eax
 804953c:	3d 00 20 00 00       	cmp    $0x2000,%eax
 8049541:	76 15                	jbe    8049558 <validate+0xd8>
 8049543:	83 ec 0c             	sub    $0xc,%esp
 8049546:	68 98 a7 04 08       	push   $0x804a798
 804954b:	e8 d0 f3 ff ff       	call   8048920 <puts@plt>
 8049550:	83 c4 10             	add    $0x10,%esp
 8049553:	e9 85 00 00 00       	jmp    80495dd <validate+0x15d>
 8049558:	a1 98 d1 04 08       	mov    0x804d198,%eax
 804955d:	83 ec 0c             	sub    $0xc,%esp
 8049560:	68 00 d2 04 08       	push   $0x804d200
 8049565:	50                   	push   %eax
 8049566:	ff 75 08             	pushl  0x8(%ebp)
 8049569:	68 cf a7 04 08       	push   $0x804a7cf
 804956e:	8d 85 f4 df ff ff    	lea    -0x200c(%ebp),%eax
 8049574:	50                   	push   %eax
 8049575:	e8 96 f4 ff ff       	call   8048a10 <sprintf@plt>
 804957a:	83 c4 20             	add    $0x20,%esp
 804957d:	a1 88 d1 04 08       	mov    0x804d188,%eax
 8049582:	8d 95 f4 bf ff ff    	lea    -0x400c(%ebp),%edx
 8049588:	52                   	push   %edx
 8049589:	6a 00                	push   $0x0
 804958b:	8d 95 f4 df ff ff    	lea    -0x200c(%ebp),%edx
 8049591:	52                   	push   %edx
 8049592:	50                   	push   %eax
 8049593:	e8 85 0b 00 00       	call   804a11d <driver_post>
 8049598:	83 c4 10             	add    $0x10,%esp
 804959b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804959e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80495a2:	75 12                	jne    80495b6 <validate+0x136>
 80495a4:	83 ec 0c             	sub    $0xc,%esp
 80495a7:	68 d8 a7 04 08       	push   $0x804a7d8
 80495ac:	e8 6f f3 ff ff       	call   8048920 <puts@plt>
 80495b1:	83 c4 10             	add    $0x10,%esp
 80495b4:	eb 17                	jmp    80495cd <validate+0x14d>
 80495b6:	83 ec 08             	sub    $0x8,%esp
 80495b9:	8d 85 f4 bf ff ff    	lea    -0x400c(%ebp),%eax
 80495bf:	50                   	push   %eax
 80495c0:	68 08 a8 04 08       	push   $0x804a808
 80495c5:	e8 86 f2 ff ff       	call   8048850 <printf@plt>
 80495ca:	83 c4 10             	add    $0x10,%esp
 80495cd:	83 ec 0c             	sub    $0xc,%esp
 80495d0:	68 46 a8 04 08       	push   $0x804a846
 80495d5:	e8 46 f3 ff ff       	call   8048920 <puts@plt>
 80495da:	83 c4 10             	add    $0x10,%esp
 80495dd:	c9                   	leave  
 80495de:	c3                   	ret    

080495df <sigalrm_handler>:
 80495df:	55                   	push   %ebp
 80495e0:	89 e5                	mov    %esp,%ebp
 80495e2:	83 ec 08             	sub    $0x8,%esp
 80495e5:	83 ec 08             	sub    $0x8,%esp
 80495e8:	6a 05                	push   $0x5
 80495ea:	68 50 a8 04 08       	push   $0x804a850
 80495ef:	e8 5c f2 ff ff       	call   8048850 <printf@plt>
 80495f4:	83 c4 10             	add    $0x10,%esp
 80495f7:	83 ec 0c             	sub    $0xc,%esp
 80495fa:	6a 01                	push   $0x1
 80495fc:	e8 3f f3 ff ff       	call   8048940 <exit@plt>

08049601 <rio_readinitb>:
 8049601:	55                   	push   %ebp
 8049602:	89 e5                	mov    %esp,%ebp
 8049604:	8b 45 08             	mov    0x8(%ebp),%eax
 8049607:	8b 55 0c             	mov    0xc(%ebp),%edx
 804960a:	89 10                	mov    %edx,(%eax)
 804960c:	8b 45 08             	mov    0x8(%ebp),%eax
 804960f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 8049616:	8b 45 08             	mov    0x8(%ebp),%eax
 8049619:	8d 50 0c             	lea    0xc(%eax),%edx
 804961c:	8b 45 08             	mov    0x8(%ebp),%eax
 804961f:	89 50 08             	mov    %edx,0x8(%eax)
 8049622:	5d                   	pop    %ebp
 8049623:	c3                   	ret    

08049624 <rio_read>:
 8049624:	55                   	push   %ebp
 8049625:	89 e5                	mov    %esp,%ebp
 8049627:	83 ec 18             	sub    $0x18,%esp
 804962a:	eb 5f                	jmp    804968b <rio_read+0x67>
 804962c:	8b 45 08             	mov    0x8(%ebp),%eax
 804962f:	8d 50 0c             	lea    0xc(%eax),%edx
 8049632:	8b 45 08             	mov    0x8(%ebp),%eax
 8049635:	8b 00                	mov    (%eax),%eax
 8049637:	83 ec 04             	sub    $0x4,%esp
 804963a:	68 00 20 00 00       	push   $0x2000
 804963f:	52                   	push   %edx
 8049640:	50                   	push   %eax
 8049641:	e8 ea f1 ff ff       	call   8048830 <read@plt>
 8049646:	83 c4 10             	add    $0x10,%esp
 8049649:	89 c2                	mov    %eax,%edx
 804964b:	8b 45 08             	mov    0x8(%ebp),%eax
 804964e:	89 50 04             	mov    %edx,0x4(%eax)
 8049651:	8b 45 08             	mov    0x8(%ebp),%eax
 8049654:	8b 40 04             	mov    0x4(%eax),%eax
 8049657:	85 c0                	test   %eax,%eax
 8049659:	79 13                	jns    804966e <rio_read+0x4a>
 804965b:	e8 80 f3 ff ff       	call   80489e0 <__errno_location@plt>
 8049660:	8b 00                	mov    (%eax),%eax
 8049662:	83 f8 04             	cmp    $0x4,%eax
 8049665:	74 24                	je     804968b <rio_read+0x67>
 8049667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804966c:	eb 7f                	jmp    80496ed <rio_read+0xc9>
 804966e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049671:	8b 40 04             	mov    0x4(%eax),%eax
 8049674:	85 c0                	test   %eax,%eax
 8049676:	75 07                	jne    804967f <rio_read+0x5b>
 8049678:	b8 00 00 00 00       	mov    $0x0,%eax
 804967d:	eb 6e                	jmp    80496ed <rio_read+0xc9>
 804967f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049682:	8d 50 0c             	lea    0xc(%eax),%edx
 8049685:	8b 45 08             	mov    0x8(%ebp),%eax
 8049688:	89 50 08             	mov    %edx,0x8(%eax)
 804968b:	8b 45 08             	mov    0x8(%ebp),%eax
 804968e:	8b 40 04             	mov    0x4(%eax),%eax
 8049691:	85 c0                	test   %eax,%eax
 8049693:	7e 97                	jle    804962c <rio_read+0x8>
 8049695:	8b 45 10             	mov    0x10(%ebp),%eax
 8049698:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804969b:	8b 45 08             	mov    0x8(%ebp),%eax
 804969e:	8b 40 04             	mov    0x4(%eax),%eax
 80496a1:	3b 45 10             	cmp    0x10(%ebp),%eax
 80496a4:	73 09                	jae    80496af <rio_read+0x8b>
 80496a6:	8b 45 08             	mov    0x8(%ebp),%eax
 80496a9:	8b 40 04             	mov    0x4(%eax),%eax
 80496ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80496af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 80496b2:	8b 45 08             	mov    0x8(%ebp),%eax
 80496b5:	8b 40 08             	mov    0x8(%eax),%eax
 80496b8:	83 ec 04             	sub    $0x4,%esp
 80496bb:	52                   	push   %edx
 80496bc:	50                   	push   %eax
 80496bd:	ff 75 0c             	pushl  0xc(%ebp)
 80496c0:	e8 ab f1 ff ff       	call   8048870 <memcpy@plt>
 80496c5:	83 c4 10             	add    $0x10,%esp
 80496c8:	8b 45 08             	mov    0x8(%ebp),%eax
 80496cb:	8b 50 08             	mov    0x8(%eax),%edx
 80496ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496d1:	01 c2                	add    %eax,%edx
 80496d3:	8b 45 08             	mov    0x8(%ebp),%eax
 80496d6:	89 50 08             	mov    %edx,0x8(%eax)
 80496d9:	8b 45 08             	mov    0x8(%ebp),%eax
 80496dc:	8b 40 04             	mov    0x4(%eax),%eax
 80496df:	2b 45 f4             	sub    -0xc(%ebp),%eax
 80496e2:	89 c2                	mov    %eax,%edx
 80496e4:	8b 45 08             	mov    0x8(%ebp),%eax
 80496e7:	89 50 04             	mov    %edx,0x4(%eax)
 80496ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496ed:	c9                   	leave  
 80496ee:	c3                   	ret    

080496ef <rio_readlineb>:
 80496ef:	55                   	push   %ebp
 80496f0:	89 e5                	mov    %esp,%ebp
 80496f2:	83 ec 18             	sub    $0x18,%esp
 80496f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 80496f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80496fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8049702:	eb 56                	jmp    804975a <rio_readlineb+0x6b>
 8049704:	83 ec 04             	sub    $0x4,%esp
 8049707:	6a 01                	push   $0x1
 8049709:	8d 45 eb             	lea    -0x15(%ebp),%eax
 804970c:	50                   	push   %eax
 804970d:	ff 75 08             	pushl  0x8(%ebp)
 8049710:	e8 0f ff ff ff       	call   8049624 <rio_read>
 8049715:	83 c4 10             	add    $0x10,%esp
 8049718:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804971b:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 804971f:	75 19                	jne    804973a <rio_readlineb+0x4b>
 8049721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049724:	8d 50 01             	lea    0x1(%eax),%edx
 8049727:	89 55 f0             	mov    %edx,-0x10(%ebp)
 804972a:	0f b6 55 eb          	movzbl -0x15(%ebp),%edx
 804972e:	88 10                	mov    %dl,(%eax)
 8049730:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
 8049734:	3c 0a                	cmp    $0xa,%al
 8049736:	75 1e                	jne    8049756 <rio_readlineb+0x67>
 8049738:	eb 28                	jmp    8049762 <rio_readlineb+0x73>
 804973a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 804973e:	75 0f                	jne    804974f <rio_readlineb+0x60>
 8049740:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 8049744:	75 07                	jne    804974d <rio_readlineb+0x5e>
 8049746:	b8 00 00 00 00       	mov    $0x0,%eax
 804974b:	eb 1e                	jmp    804976b <rio_readlineb+0x7c>
 804974d:	eb 13                	jmp    8049762 <rio_readlineb+0x73>
 804974f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049754:	eb 15                	jmp    804976b <rio_readlineb+0x7c>
 8049756:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804975a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804975d:	3b 45 10             	cmp    0x10(%ebp),%eax
 8049760:	72 a2                	jb     8049704 <rio_readlineb+0x15>
 8049762:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049765:	c6 00 00             	movb   $0x0,(%eax)
 8049768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804976b:	c9                   	leave  
 804976c:	c3                   	ret    

0804976d <rio_writen>:
 804976d:	55                   	push   %ebp
 804976e:	89 e5                	mov    %esp,%ebp
 8049770:	83 ec 18             	sub    $0x18,%esp
 8049773:	8b 45 10             	mov    0x10(%ebp),%eax
 8049776:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049779:	8b 45 0c             	mov    0xc(%ebp),%eax
 804977c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804977f:	eb 45                	jmp    80497c6 <rio_writen+0x59>
 8049781:	83 ec 04             	sub    $0x4,%esp
 8049784:	ff 75 f4             	pushl  -0xc(%ebp)
 8049787:	ff 75 ec             	pushl  -0x14(%ebp)
 804978a:	ff 75 08             	pushl  0x8(%ebp)
 804978d:	e8 fe f1 ff ff       	call   8048990 <write@plt>
 8049792:	83 c4 10             	add    $0x10,%esp
 8049795:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049798:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 804979c:	7f 1c                	jg     80497ba <rio_writen+0x4d>
 804979e:	e8 3d f2 ff ff       	call   80489e0 <__errno_location@plt>
 80497a3:	8b 00                	mov    (%eax),%eax
 80497a5:	83 f8 04             	cmp    $0x4,%eax
 80497a8:	75 09                	jne    80497b3 <rio_writen+0x46>
 80497aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80497b1:	eb 07                	jmp    80497ba <rio_writen+0x4d>
 80497b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80497b8:	eb 15                	jmp    80497cf <rio_writen+0x62>
 80497ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80497bd:	29 45 f4             	sub    %eax,-0xc(%ebp)
 80497c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80497c3:	01 45 ec             	add    %eax,-0x14(%ebp)
 80497c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80497ca:	75 b5                	jne    8049781 <rio_writen+0x14>
 80497cc:	8b 45 10             	mov    0x10(%ebp),%eax
 80497cf:	c9                   	leave  
 80497d0:	c3                   	ret    

080497d1 <urlencode>:
 80497d1:	55                   	push   %ebp
 80497d2:	89 e5                	mov    %esp,%ebp
 80497d4:	83 ec 18             	sub    $0x18,%esp
 80497d7:	83 ec 0c             	sub    $0xc,%esp
 80497da:	ff 75 08             	pushl  0x8(%ebp)
 80497dd:	e8 8e f1 ff ff       	call   8048970 <strlen@plt>
 80497e2:	83 c4 10             	add    $0x10,%esp
 80497e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80497e8:	e9 08 01 00 00       	jmp    80498f5 <urlencode+0x124>
 80497ed:	8b 45 08             	mov    0x8(%ebp),%eax
 80497f0:	0f b6 00             	movzbl (%eax),%eax
 80497f3:	3c 2a                	cmp    $0x2a,%al
 80497f5:	74 5a                	je     8049851 <urlencode+0x80>
 80497f7:	8b 45 08             	mov    0x8(%ebp),%eax
 80497fa:	0f b6 00             	movzbl (%eax),%eax
 80497fd:	3c 2d                	cmp    $0x2d,%al
 80497ff:	74 50                	je     8049851 <urlencode+0x80>
 8049801:	8b 45 08             	mov    0x8(%ebp),%eax
 8049804:	0f b6 00             	movzbl (%eax),%eax
 8049807:	3c 2e                	cmp    $0x2e,%al
 8049809:	74 46                	je     8049851 <urlencode+0x80>
 804980b:	8b 45 08             	mov    0x8(%ebp),%eax
 804980e:	0f b6 00             	movzbl (%eax),%eax
 8049811:	3c 5f                	cmp    $0x5f,%al
 8049813:	74 3c                	je     8049851 <urlencode+0x80>
 8049815:	8b 45 08             	mov    0x8(%ebp),%eax
 8049818:	0f b6 00             	movzbl (%eax),%eax
 804981b:	3c 2f                	cmp    $0x2f,%al
 804981d:	76 0a                	jbe    8049829 <urlencode+0x58>
 804981f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049822:	0f b6 00             	movzbl (%eax),%eax
 8049825:	3c 39                	cmp    $0x39,%al
 8049827:	76 28                	jbe    8049851 <urlencode+0x80>
 8049829:	8b 45 08             	mov    0x8(%ebp),%eax
 804982c:	0f b6 00             	movzbl (%eax),%eax
 804982f:	3c 40                	cmp    $0x40,%al
 8049831:	76 0a                	jbe    804983d <urlencode+0x6c>
 8049833:	8b 45 08             	mov    0x8(%ebp),%eax
 8049836:	0f b6 00             	movzbl (%eax),%eax
 8049839:	3c 5a                	cmp    $0x5a,%al
 804983b:	76 14                	jbe    8049851 <urlencode+0x80>
 804983d:	8b 45 08             	mov    0x8(%ebp),%eax
 8049840:	0f b6 00             	movzbl (%eax),%eax
 8049843:	3c 60                	cmp    $0x60,%al
 8049845:	76 20                	jbe    8049867 <urlencode+0x96>
 8049847:	8b 45 08             	mov    0x8(%ebp),%eax
 804984a:	0f b6 00             	movzbl (%eax),%eax
 804984d:	3c 7a                	cmp    $0x7a,%al
 804984f:	77 16                	ja     8049867 <urlencode+0x96>
 8049851:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049854:	8d 50 01             	lea    0x1(%eax),%edx
 8049857:	89 55 0c             	mov    %edx,0xc(%ebp)
 804985a:	8b 55 08             	mov    0x8(%ebp),%edx
 804985d:	0f b6 12             	movzbl (%edx),%edx
 8049860:	88 10                	mov    %dl,(%eax)
 8049862:	e9 8a 00 00 00       	jmp    80498f1 <urlencode+0x120>
 8049867:	8b 45 08             	mov    0x8(%ebp),%eax
 804986a:	0f b6 00             	movzbl (%eax),%eax
 804986d:	3c 20                	cmp    $0x20,%al
 804986f:	75 0e                	jne    804987f <urlencode+0xae>
 8049871:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049874:	8d 50 01             	lea    0x1(%eax),%edx
 8049877:	89 55 0c             	mov    %edx,0xc(%ebp)
 804987a:	c6 00 2b             	movb   $0x2b,(%eax)
 804987d:	eb 72                	jmp    80498f1 <urlencode+0x120>
 804987f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049882:	0f b6 00             	movzbl (%eax),%eax
 8049885:	3c 1f                	cmp    $0x1f,%al
 8049887:	76 0a                	jbe    8049893 <urlencode+0xc2>
 8049889:	8b 45 08             	mov    0x8(%ebp),%eax
 804988c:	0f b6 00             	movzbl (%eax),%eax
 804988f:	84 c0                	test   %al,%al
 8049891:	79 0a                	jns    804989d <urlencode+0xcc>
 8049893:	8b 45 08             	mov    0x8(%ebp),%eax
 8049896:	0f b6 00             	movzbl (%eax),%eax
 8049899:	3c 09                	cmp    $0x9,%al
 804989b:	75 4d                	jne    80498ea <urlencode+0x119>
 804989d:	8b 45 08             	mov    0x8(%ebp),%eax
 80498a0:	0f b6 00             	movzbl (%eax),%eax
 80498a3:	0f b6 c0             	movzbl %al,%eax
 80498a6:	83 ec 04             	sub    $0x4,%esp
 80498a9:	50                   	push   %eax
 80498aa:	68 74 a8 04 08       	push   $0x804a874
 80498af:	8d 45 ec             	lea    -0x14(%ebp),%eax
 80498b2:	50                   	push   %eax
 80498b3:	e8 58 f1 ff ff       	call   8048a10 <sprintf@plt>
 80498b8:	83 c4 10             	add    $0x10,%esp
 80498bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 80498be:	8d 50 01             	lea    0x1(%eax),%edx
 80498c1:	89 55 0c             	mov    %edx,0xc(%ebp)
 80498c4:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
 80498c8:	88 10                	mov    %dl,(%eax)
 80498ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 80498cd:	8d 50 01             	lea    0x1(%eax),%edx
 80498d0:	89 55 0c             	mov    %edx,0xc(%ebp)
 80498d3:	0f b6 55 ed          	movzbl -0x13(%ebp),%edx
 80498d7:	88 10                	mov    %dl,(%eax)
 80498d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 80498dc:	8d 50 01             	lea    0x1(%eax),%edx
 80498df:	89 55 0c             	mov    %edx,0xc(%ebp)
 80498e2:	0f b6 55 ee          	movzbl -0x12(%ebp),%edx
 80498e6:	88 10                	mov    %dl,(%eax)
 80498e8:	eb 07                	jmp    80498f1 <urlencode+0x120>
 80498ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80498ef:	eb 1a                	jmp    804990b <urlencode+0x13a>
 80498f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 80498f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80498f8:	8d 50 ff             	lea    -0x1(%eax),%edx
 80498fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 80498fe:	85 c0                	test   %eax,%eax
 8049900:	0f 85 e7 fe ff ff    	jne    80497ed <urlencode+0x1c>
 8049906:	b8 00 00 00 00       	mov    $0x0,%eax
 804990b:	c9                   	leave  
 804990c:	c3                   	ret    

0804990d <submitr>:
 804990d:	55                   	push   %ebp
 804990e:	89 e5                	mov    %esp,%ebp
 8049910:	57                   	push   %edi
 8049911:	56                   	push   %esi
 8049912:	53                   	push   %ebx
 8049913:	81 ec 3c a0 00 00    	sub    $0xa03c,%esp
 8049919:	c7 85 b8 7f ff ff 00 	movl   $0x0,-0x8048(%ebp)
 8049920:	00 00 00 
 8049923:	83 ec 04             	sub    $0x4,%esp
 8049926:	6a 00                	push   $0x0
 8049928:	6a 01                	push   $0x1
 804992a:	6a 02                	push   $0x2
 804992c:	e8 ef f0 ff ff       	call   8048a20 <socket@plt>
 8049931:	83 c4 10             	add    $0x10,%esp
 8049934:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8049937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 804993b:	79 51                	jns    804998e <submitr+0x81>
 804993d:	8b 45 20             	mov    0x20(%ebp),%eax
 8049940:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049946:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 804994d:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049954:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 804995b:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049962:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049969:	c7 40 18 63 72 65 61 	movl   $0x61657263,0x18(%eax)
 8049970:	c7 40 1c 74 65 20 73 	movl   $0x73206574,0x1c(%eax)
 8049977:	c7 40 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%eax)
 804997e:	66 c7 40 24 74 00    	movw   $0x74,0x24(%eax)
 8049984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049989:	e9 a3 05 00 00       	jmp    8049f31 <submitr+0x624>
 804998e:	83 ec 0c             	sub    $0xc,%esp
 8049991:	ff 75 08             	pushl  0x8(%ebp)
 8049994:	e8 a7 f0 ff ff       	call   8048a40 <gethostbyname@plt>
 8049999:	83 c4 10             	add    $0x10,%esp
 804999c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 804999f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80499a3:	75 2e                	jne    80499d3 <submitr+0xc6>
 80499a5:	83 ec 04             	sub    $0x4,%esp
 80499a8:	ff 75 08             	pushl  0x8(%ebp)
 80499ab:	68 7c a8 04 08       	push   $0x804a87c
 80499b0:	ff 75 20             	pushl  0x20(%ebp)
 80499b3:	e8 58 f0 ff ff       	call   8048a10 <sprintf@plt>
 80499b8:	83 c4 10             	add    $0x10,%esp
 80499bb:	83 ec 0c             	sub    $0xc,%esp
 80499be:	ff 75 e4             	pushl  -0x1c(%ebp)
 80499c1:	e8 9a f0 ff ff       	call   8048a60 <close@plt>
 80499c6:	83 c4 10             	add    $0x10,%esp
 80499c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80499ce:	e9 5e 05 00 00       	jmp    8049f31 <submitr+0x624>
 80499d3:	83 ec 08             	sub    $0x8,%esp
 80499d6:	6a 10                	push   $0x10
 80499d8:	8d 45 c8             	lea    -0x38(%ebp),%eax
 80499db:	50                   	push   %eax
 80499dc:	e8 9f ee ff ff       	call   8048880 <bzero@plt>
 80499e1:	83 c4 10             	add    $0x10,%esp
 80499e4:	66 c7 45 c8 02 00    	movw   $0x2,-0x38(%ebp)
 80499ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80499ed:	8b 40 0c             	mov    0xc(%eax),%eax
 80499f0:	89 c2                	mov    %eax,%edx
 80499f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80499f5:	8b 40 10             	mov    0x10(%eax),%eax
 80499f8:	8b 00                	mov    (%eax),%eax
 80499fa:	83 ec 04             	sub    $0x4,%esp
 80499fd:	52                   	push   %edx
 80499fe:	8d 55 c8             	lea    -0x38(%ebp),%edx
 8049a01:	83 c2 04             	add    $0x4,%edx
 8049a04:	52                   	push   %edx
 8049a05:	50                   	push   %eax
 8049a06:	e8 d5 ee ff ff       	call   80488e0 <bcopy@plt>
 8049a0b:	83 c4 10             	add    $0x10,%esp
 8049a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049a11:	0f b7 c0             	movzwl %ax,%eax
 8049a14:	83 ec 0c             	sub    $0xc,%esp
 8049a17:	50                   	push   %eax
 8049a18:	e8 a3 ee ff ff       	call   80488c0 <htons@plt>
 8049a1d:	83 c4 10             	add    $0x10,%esp
 8049a20:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
 8049a24:	83 ec 04             	sub    $0x4,%esp
 8049a27:	6a 10                	push   $0x10
 8049a29:	8d 45 c8             	lea    -0x38(%ebp),%eax
 8049a2c:	50                   	push   %eax
 8049a2d:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049a30:	e8 1b f0 ff ff       	call   8048a50 <connect@plt>
 8049a35:	83 c4 10             	add    $0x10,%esp
 8049a38:	85 c0                	test   %eax,%eax
 8049a3a:	79 2e                	jns    8049a6a <submitr+0x15d>
 8049a3c:	83 ec 04             	sub    $0x4,%esp
 8049a3f:	ff 75 08             	pushl  0x8(%ebp)
 8049a42:	68 a8 a8 04 08       	push   $0x804a8a8
 8049a47:	ff 75 20             	pushl  0x20(%ebp)
 8049a4a:	e8 c1 ef ff ff       	call   8048a10 <sprintf@plt>
 8049a4f:	83 c4 10             	add    $0x10,%esp
 8049a52:	83 ec 0c             	sub    $0xc,%esp
 8049a55:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049a58:	e8 03 f0 ff ff       	call   8048a60 <close@plt>
 8049a5d:	83 c4 10             	add    $0x10,%esp
 8049a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a65:	e9 c7 04 00 00       	jmp    8049f31 <submitr+0x624>
 8049a6a:	83 ec 0c             	sub    $0xc,%esp
 8049a6d:	ff 75 1c             	pushl  0x1c(%ebp)
 8049a70:	e8 fb ee ff ff       	call   8048970 <strlen@plt>
 8049a75:	83 c4 10             	add    $0x10,%esp
 8049a78:	89 45 dc             	mov    %eax,-0x24(%ebp)
 8049a7b:	83 ec 0c             	sub    $0xc,%esp
 8049a7e:	ff 75 10             	pushl  0x10(%ebp)
 8049a81:	e8 ea ee ff ff       	call   8048970 <strlen@plt>
 8049a86:	83 c4 10             	add    $0x10,%esp
 8049a89:	89 c3                	mov    %eax,%ebx
 8049a8b:	83 ec 0c             	sub    $0xc,%esp
 8049a8e:	ff 75 14             	pushl  0x14(%ebp)
 8049a91:	e8 da ee ff ff       	call   8048970 <strlen@plt>
 8049a96:	83 c4 10             	add    $0x10,%esp
 8049a99:	01 c3                	add    %eax,%ebx
 8049a9b:	83 ec 0c             	sub    $0xc,%esp
 8049a9e:	ff 75 18             	pushl  0x18(%ebp)
 8049aa1:	e8 ca ee ff ff       	call   8048970 <strlen@plt>
 8049aa6:	83 c4 10             	add    $0x10,%esp
 8049aa9:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
 8049aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
 8049aaf:	89 d0                	mov    %edx,%eax
 8049ab1:	01 c0                	add    %eax,%eax
 8049ab3:	01 d0                	add    %edx,%eax
 8049ab5:	01 c8                	add    %ecx,%eax
 8049ab7:	83 e8 80             	sub    $0xffffff80,%eax
 8049aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
 8049abd:	81 7d d8 00 20 00 00 	cmpl   $0x2000,-0x28(%ebp)
 8049ac4:	76 7c                	jbe    8049b42 <submitr+0x235>
 8049ac6:	8b 45 20             	mov    0x20(%ebp),%eax
 8049ac9:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049acf:	c7 40 04 72 3a 20 52 	movl   $0x52203a72,0x4(%eax)
 8049ad6:	c7 40 08 65 73 75 6c 	movl   $0x6c757365,0x8(%eax)
 8049add:	c7 40 0c 74 20 73 74 	movl   $0x74732074,0xc(%eax)
 8049ae4:	c7 40 10 72 69 6e 67 	movl   $0x676e6972,0x10(%eax)
 8049aeb:	c7 40 14 20 74 6f 6f 	movl   $0x6f6f7420,0x14(%eax)
 8049af2:	c7 40 18 20 6c 61 72 	movl   $0x72616c20,0x18(%eax)
 8049af9:	c7 40 1c 67 65 2e 20 	movl   $0x202e6567,0x1c(%eax)
 8049b00:	c7 40 20 49 6e 63 72 	movl   $0x72636e49,0x20(%eax)
 8049b07:	c7 40 24 65 61 73 65 	movl   $0x65736165,0x24(%eax)
 8049b0e:	c7 40 28 20 53 55 42 	movl   $0x42555320,0x28(%eax)
 8049b15:	c7 40 2c 4d 49 54 52 	movl   $0x5254494d,0x2c(%eax)
 8049b1c:	c7 40 30 5f 4d 41 58 	movl   $0x58414d5f,0x30(%eax)
 8049b23:	c7 40 34 42 55 46 00 	movl   $0x465542,0x34(%eax)
 8049b2a:	83 ec 0c             	sub    $0xc,%esp
 8049b2d:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049b30:	e8 2b ef ff ff       	call   8048a60 <close@plt>
 8049b35:	83 c4 10             	add    $0x10,%esp
 8049b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049b3d:	e9 ef 03 00 00       	jmp    8049f31 <submitr+0x624>
 8049b42:	83 ec 08             	sub    $0x8,%esp
 8049b45:	68 00 20 00 00       	push   $0x2000
 8049b4a:	8d 85 bc 9f ff ff    	lea    -0x6044(%ebp),%eax
 8049b50:	50                   	push   %eax
 8049b51:	e8 2a ed ff ff       	call   8048880 <bzero@plt>
 8049b56:	83 c4 10             	add    $0x10,%esp
 8049b59:	83 ec 08             	sub    $0x8,%esp
 8049b5c:	8d 85 bc 9f ff ff    	lea    -0x6044(%ebp),%eax
 8049b62:	50                   	push   %eax
 8049b63:	ff 75 1c             	pushl  0x1c(%ebp)
 8049b66:	e8 66 fc ff ff       	call   80497d1 <urlencode>
 8049b6b:	83 c4 10             	add    $0x10,%esp
 8049b6e:	85 c0                	test   %eax,%eax
 8049b70:	79 4b                	jns    8049bbd <submitr+0x2b0>
 8049b72:	8b 45 20             	mov    0x20(%ebp),%eax
 8049b75:	bb d0 a8 04 08       	mov    $0x804a8d0,%ebx
 8049b7a:	ba 43 00 00 00       	mov    $0x43,%edx
 8049b7f:	8b 0b                	mov    (%ebx),%ecx
 8049b81:	89 08                	mov    %ecx,(%eax)
 8049b83:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
 8049b87:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
 8049b8b:	8d 78 04             	lea    0x4(%eax),%edi
 8049b8e:	83 e7 fc             	and    $0xfffffffc,%edi
 8049b91:	29 f8                	sub    %edi,%eax
 8049b93:	29 c3                	sub    %eax,%ebx
 8049b95:	01 c2                	add    %eax,%edx
 8049b97:	83 e2 fc             	and    $0xfffffffc,%edx
 8049b9a:	89 d0                	mov    %edx,%eax
 8049b9c:	c1 e8 02             	shr    $0x2,%eax
 8049b9f:	89 de                	mov    %ebx,%esi
 8049ba1:	89 c1                	mov    %eax,%ecx
 8049ba3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 8049ba5:	83 ec 0c             	sub    $0xc,%esp
 8049ba8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049bab:	e8 b0 ee ff ff       	call   8048a60 <close@plt>
 8049bb0:	83 c4 10             	add    $0x10,%esp
 8049bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049bb8:	e9 74 03 00 00       	jmp    8049f31 <submitr+0x624>
 8049bbd:	83 ec 08             	sub    $0x8,%esp
 8049bc0:	8d 85 bc 9f ff ff    	lea    -0x6044(%ebp),%eax
 8049bc6:	50                   	push   %eax
 8049bc7:	ff 75 18             	pushl  0x18(%ebp)
 8049bca:	ff 75 14             	pushl  0x14(%ebp)
 8049bcd:	ff 75 10             	pushl  0x10(%ebp)
 8049bd0:	68 14 a9 04 08       	push   $0x804a914
 8049bd5:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049bdb:	50                   	push   %eax
 8049bdc:	e8 2f ee ff ff       	call   8048a10 <sprintf@plt>
 8049be1:	83 c4 20             	add    $0x20,%esp
 8049be4:	83 ec 0c             	sub    $0xc,%esp
 8049be7:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049bed:	50                   	push   %eax
 8049bee:	e8 7d ed ff ff       	call   8048970 <strlen@plt>
 8049bf3:	83 c4 10             	add    $0x10,%esp
 8049bf6:	83 ec 04             	sub    $0x4,%esp
 8049bf9:	50                   	push   %eax
 8049bfa:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049c00:	50                   	push   %eax
 8049c01:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049c04:	e8 64 fb ff ff       	call   804976d <rio_writen>
 8049c09:	83 c4 10             	add    $0x10,%esp
 8049c0c:	85 c0                	test   %eax,%eax
 8049c0e:	79 67                	jns    8049c77 <submitr+0x36a>
 8049c10:	8b 45 20             	mov    0x20(%ebp),%eax
 8049c13:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049c19:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049c20:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049c27:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049c2e:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049c35:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049c3c:	c7 40 18 77 72 69 74 	movl   $0x74697277,0x18(%eax)
 8049c43:	c7 40 1c 65 20 74 6f 	movl   $0x6f742065,0x1c(%eax)
 8049c4a:	c7 40 20 20 74 68 65 	movl   $0x65687420,0x20(%eax)
 8049c51:	c7 40 24 20 73 65 72 	movl   $0x72657320,0x24(%eax)
 8049c58:	c7 40 28 76 65 72 00 	movl   $0x726576,0x28(%eax)
 8049c5f:	83 ec 0c             	sub    $0xc,%esp
 8049c62:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049c65:	e8 f6 ed ff ff       	call   8048a60 <close@plt>
 8049c6a:	83 c4 10             	add    $0x10,%esp
 8049c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049c72:	e9 ba 02 00 00       	jmp    8049f31 <submitr+0x624>
 8049c77:	83 ec 08             	sub    $0x8,%esp
 8049c7a:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049c7d:	8d 85 bc df ff ff    	lea    -0x2044(%ebp),%eax
 8049c83:	50                   	push   %eax
 8049c84:	e8 78 f9 ff ff       	call   8049601 <rio_readinitb>
 8049c89:	83 c4 10             	add    $0x10,%esp
 8049c8c:	83 ec 04             	sub    $0x4,%esp
 8049c8f:	68 00 20 00 00       	push   $0x2000
 8049c94:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049c9a:	50                   	push   %eax
 8049c9b:	8d 85 bc df ff ff    	lea    -0x2044(%ebp),%eax
 8049ca1:	50                   	push   %eax
 8049ca2:	e8 48 fa ff ff       	call   80496ef <rio_readlineb>
 8049ca7:	83 c4 10             	add    $0x10,%esp
 8049caa:	85 c0                	test   %eax,%eax
 8049cac:	7f 7b                	jg     8049d29 <submitr+0x41c>
 8049cae:	8b 45 20             	mov    0x20(%ebp),%eax
 8049cb1:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049cb7:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049cbe:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049cc5:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049ccc:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049cd3:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049cda:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049ce1:	c7 40 1c 20 66 69 72 	movl   $0x72696620,0x1c(%eax)
 8049ce8:	c7 40 20 73 74 20 68 	movl   $0x68207473,0x20(%eax)
 8049cef:	c7 40 24 65 61 64 65 	movl   $0x65646165,0x24(%eax)
 8049cf6:	c7 40 28 72 20 66 72 	movl   $0x72662072,0x28(%eax)
 8049cfd:	c7 40 2c 6f 6d 20 73 	movl   $0x73206d6f,0x2c(%eax)
 8049d04:	c7 40 30 65 72 76 65 	movl   $0x65767265,0x30(%eax)
 8049d0b:	66 c7 40 34 72 00    	movw   $0x72,0x34(%eax)
 8049d11:	83 ec 0c             	sub    $0xc,%esp
 8049d14:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049d17:	e8 44 ed ff ff       	call   8048a60 <close@plt>
 8049d1c:	83 c4 10             	add    $0x10,%esp
 8049d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d24:	e9 08 02 00 00       	jmp    8049f31 <submitr+0x624>
 8049d29:	83 ec 0c             	sub    $0xc,%esp
 8049d2c:	8d 85 b8 5f ff ff    	lea    -0xa048(%ebp),%eax
 8049d32:	50                   	push   %eax
 8049d33:	8d 85 b8 7f ff ff    	lea    -0x8048(%ebp),%eax
 8049d39:	50                   	push   %eax
 8049d3a:	8d 85 bc 7f ff ff    	lea    -0x8044(%ebp),%eax
 8049d40:	50                   	push   %eax
 8049d41:	68 5e a9 04 08       	push   $0x804a95e
 8049d46:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049d4c:	50                   	push   %eax
 8049d4d:	e8 6e ec ff ff       	call   80489c0 <__isoc99_sscanf@plt>
 8049d52:	83 c4 20             	add    $0x20,%esp
 8049d55:	8b 85 b8 7f ff ff    	mov    -0x8048(%ebp),%eax
 8049d5b:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049d60:	74 36                	je     8049d98 <submitr+0x48b>
 8049d62:	8b 85 b8 7f ff ff    	mov    -0x8048(%ebp),%eax
 8049d68:	8d 95 b8 5f ff ff    	lea    -0xa048(%ebp),%edx
 8049d6e:	52                   	push   %edx
 8049d6f:	50                   	push   %eax
 8049d70:	68 70 a9 04 08       	push   $0x804a970
 8049d75:	ff 75 20             	pushl  0x20(%ebp)
 8049d78:	e8 93 ec ff ff       	call   8048a10 <sprintf@plt>
 8049d7d:	83 c4 10             	add    $0x10,%esp
 8049d80:	83 ec 0c             	sub    $0xc,%esp
 8049d83:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049d86:	e8 d5 ec ff ff       	call   8048a60 <close@plt>
 8049d8b:	83 c4 10             	add    $0x10,%esp
 8049d8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d93:	e9 99 01 00 00       	jmp    8049f31 <submitr+0x624>
 8049d98:	e9 94 00 00 00       	jmp    8049e31 <submitr+0x524>
 8049d9d:	83 ec 04             	sub    $0x4,%esp
 8049da0:	68 00 20 00 00       	push   $0x2000
 8049da5:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049dab:	50                   	push   %eax
 8049dac:	8d 85 bc df ff ff    	lea    -0x2044(%ebp),%eax
 8049db2:	50                   	push   %eax
 8049db3:	e8 37 f9 ff ff       	call   80496ef <rio_readlineb>
 8049db8:	83 c4 10             	add    $0x10,%esp
 8049dbb:	85 c0                	test   %eax,%eax
 8049dbd:	7f 72                	jg     8049e31 <submitr+0x524>
 8049dbf:	8b 45 20             	mov    0x20(%ebp),%eax
 8049dc2:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049dc8:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049dcf:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049dd6:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049ddd:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049de4:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049deb:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049df2:	c7 40 1c 20 68 65 61 	movl   $0x61656820,0x1c(%eax)
 8049df9:	c7 40 20 64 65 72 73 	movl   $0x73726564,0x20(%eax)
 8049e00:	c7 40 24 20 66 72 6f 	movl   $0x6f726620,0x24(%eax)
 8049e07:	c7 40 28 6d 20 73 65 	movl   $0x6573206d,0x28(%eax)
 8049e0e:	c7 40 2c 72 76 65 72 	movl   $0x72657672,0x2c(%eax)
 8049e15:	c6 40 30 00          	movb   $0x0,0x30(%eax)
 8049e19:	83 ec 0c             	sub    $0xc,%esp
 8049e1c:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049e1f:	e8 3c ec ff ff       	call   8048a60 <close@plt>
 8049e24:	83 c4 10             	add    $0x10,%esp
 8049e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e2c:	e9 00 01 00 00       	jmp    8049f31 <submitr+0x624>
 8049e31:	83 ec 08             	sub    $0x8,%esp
 8049e34:	68 9d a9 04 08       	push   $0x804a99d
 8049e39:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049e3f:	50                   	push   %eax
 8049e40:	e8 db e9 ff ff       	call   8048820 <strcmp@plt>
 8049e45:	83 c4 10             	add    $0x10,%esp
 8049e48:	85 c0                	test   %eax,%eax
 8049e4a:	0f 85 4d ff ff ff    	jne    8049d9d <submitr+0x490>
 8049e50:	83 ec 04             	sub    $0x4,%esp
 8049e53:	68 00 20 00 00       	push   $0x2000
 8049e58:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049e5e:	50                   	push   %eax
 8049e5f:	8d 85 bc df ff ff    	lea    -0x2044(%ebp),%eax
 8049e65:	50                   	push   %eax
 8049e66:	e8 84 f8 ff ff       	call   80496ef <rio_readlineb>
 8049e6b:	83 c4 10             	add    $0x10,%esp
 8049e6e:	85 c0                	test   %eax,%eax
 8049e70:	7f 79                	jg     8049eeb <submitr+0x5de>
 8049e72:	8b 45 20             	mov    0x20(%ebp),%eax
 8049e75:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049e7b:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049e82:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049e89:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049e90:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049e97:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049e9e:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049ea5:	c7 40 1c 20 73 74 61 	movl   $0x61747320,0x1c(%eax)
 8049eac:	c7 40 20 74 75 73 20 	movl   $0x20737574,0x20(%eax)
 8049eb3:	c7 40 24 6d 65 73 73 	movl   $0x7373656d,0x24(%eax)
 8049eba:	c7 40 28 61 67 65 20 	movl   $0x20656761,0x28(%eax)
 8049ec1:	c7 40 2c 66 72 6f 6d 	movl   $0x6d6f7266,0x2c(%eax)
 8049ec8:	c7 40 30 20 73 65 72 	movl   $0x72657320,0x30(%eax)
 8049ecf:	c7 40 34 76 65 72 00 	movl   $0x726576,0x34(%eax)
 8049ed6:	83 ec 0c             	sub    $0xc,%esp
 8049ed9:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049edc:	e8 7f eb ff ff       	call   8048a60 <close@plt>
 8049ee1:	83 c4 10             	add    $0x10,%esp
 8049ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049ee9:	eb 46                	jmp    8049f31 <submitr+0x624>
 8049eeb:	83 ec 08             	sub    $0x8,%esp
 8049eee:	8d 85 bc bf ff ff    	lea    -0x4044(%ebp),%eax
 8049ef4:	50                   	push   %eax
 8049ef5:	ff 75 20             	pushl  0x20(%ebp)
 8049ef8:	e8 f3 e9 ff ff       	call   80488f0 <strcpy@plt>
 8049efd:	83 c4 10             	add    $0x10,%esp
 8049f00:	83 ec 0c             	sub    $0xc,%esp
 8049f03:	ff 75 e4             	pushl  -0x1c(%ebp)
 8049f06:	e8 55 eb ff ff       	call   8048a60 <close@plt>
 8049f0b:	83 c4 10             	add    $0x10,%esp
 8049f0e:	83 ec 08             	sub    $0x8,%esp
 8049f11:	68 a0 a9 04 08       	push   $0x804a9a0
 8049f16:	ff 75 20             	pushl  0x20(%ebp)
 8049f19:	e8 02 e9 ff ff       	call   8048820 <strcmp@plt>
 8049f1e:	83 c4 10             	add    $0x10,%esp
 8049f21:	85 c0                	test   %eax,%eax
 8049f23:	75 07                	jne    8049f2c <submitr+0x61f>
 8049f25:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f2a:	eb 05                	jmp    8049f31 <submitr+0x624>
 8049f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8049f34:	5b                   	pop    %ebx
 8049f35:	5e                   	pop    %esi
 8049f36:	5f                   	pop    %edi
 8049f37:	5d                   	pop    %ebp
 8049f38:	c3                   	ret    

08049f39 <init_timeout>:
 8049f39:	55                   	push   %ebp
 8049f3a:	89 e5                	mov    %esp,%ebp
 8049f3c:	83 ec 08             	sub    $0x8,%esp
 8049f3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8049f43:	75 02                	jne    8049f47 <init_timeout+0xe>
 8049f45:	eb 2e                	jmp    8049f75 <init_timeout+0x3c>
 8049f47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8049f4b:	79 07                	jns    8049f54 <init_timeout+0x1b>
 8049f4d:	c7 45 08 05 00 00 00 	movl   $0x5,0x8(%ebp)
 8049f54:	83 ec 08             	sub    $0x8,%esp
 8049f57:	68 df 95 04 08       	push   $0x80495df
 8049f5c:	6a 0e                	push   $0xe
 8049f5e:	e8 2d e9 ff ff       	call   8048890 <signal@plt>
 8049f63:	83 c4 10             	add    $0x10,%esp
 8049f66:	8b 45 08             	mov    0x8(%ebp),%eax
 8049f69:	83 ec 0c             	sub    $0xc,%esp
 8049f6c:	50                   	push   %eax
 8049f6d:	e8 2e e9 ff ff       	call   80488a0 <alarm@plt>
 8049f72:	83 c4 10             	add    $0x10,%esp
 8049f75:	c9                   	leave  
 8049f76:	c3                   	ret    

08049f77 <init_driver>:
 8049f77:	55                   	push   %ebp
 8049f78:	89 e5                	mov    %esp,%ebp
 8049f7a:	83 ec 28             	sub    $0x28,%esp
 8049f7d:	c7 45 f4 a3 a9 04 08 	movl   $0x804a9a3,-0xc(%ebp)
 8049f84:	c7 45 f0 26 47 00 00 	movl   $0x4726,-0x10(%ebp)
 8049f8b:	83 ec 08             	sub    $0x8,%esp
 8049f8e:	6a 01                	push   $0x1
 8049f90:	6a 0d                	push   $0xd
 8049f92:	e8 f9 e8 ff ff       	call   8048890 <signal@plt>
 8049f97:	83 c4 10             	add    $0x10,%esp
 8049f9a:	83 ec 08             	sub    $0x8,%esp
 8049f9d:	6a 01                	push   $0x1
 8049f9f:	6a 1d                	push   $0x1d
 8049fa1:	e8 ea e8 ff ff       	call   8048890 <signal@plt>
 8049fa6:	83 c4 10             	add    $0x10,%esp
 8049fa9:	83 ec 08             	sub    $0x8,%esp
 8049fac:	6a 01                	push   $0x1
 8049fae:	6a 1d                	push   $0x1d
 8049fb0:	e8 db e8 ff ff       	call   8048890 <signal@plt>
 8049fb5:	83 c4 10             	add    $0x10,%esp
 8049fb8:	83 ec 04             	sub    $0x4,%esp
 8049fbb:	6a 00                	push   $0x0
 8049fbd:	6a 01                	push   $0x1
 8049fbf:	6a 02                	push   $0x2
 8049fc1:	e8 5a ea ff ff       	call   8048a20 <socket@plt>
 8049fc6:	83 c4 10             	add    $0x10,%esp
 8049fc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8049fcc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8049fd0:	79 51                	jns    804a023 <init_driver+0xac>
 8049fd2:	8b 45 08             	mov    0x8(%ebp),%eax
 8049fd5:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049fdb:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049fe2:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049fe9:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049ff0:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049ff7:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049ffe:	c7 40 18 63 72 65 61 	movl   $0x61657263,0x18(%eax)
 804a005:	c7 40 1c 74 65 20 73 	movl   $0x73206574,0x1c(%eax)
 804a00c:	c7 40 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%eax)
 804a013:	66 c7 40 24 74 00    	movw   $0x74,0x24(%eax)
 804a019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a01e:	e9 f8 00 00 00       	jmp    804a11b <init_driver+0x1a4>
 804a023:	83 ec 0c             	sub    $0xc,%esp
 804a026:	ff 75 f4             	pushl  -0xc(%ebp)
 804a029:	e8 12 ea ff ff       	call   8048a40 <gethostbyname@plt>
 804a02e:	83 c4 10             	add    $0x10,%esp
 804a031:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804a034:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 804a038:	75 2e                	jne    804a068 <init_driver+0xf1>
 804a03a:	83 ec 04             	sub    $0x4,%esp
 804a03d:	ff 75 f4             	pushl  -0xc(%ebp)
 804a040:	68 7c a8 04 08       	push   $0x804a87c
 804a045:	ff 75 08             	pushl  0x8(%ebp)
 804a048:	e8 c3 e9 ff ff       	call   8048a10 <sprintf@plt>
 804a04d:	83 c4 10             	add    $0x10,%esp
 804a050:	83 ec 0c             	sub    $0xc,%esp
 804a053:	ff 75 ec             	pushl  -0x14(%ebp)
 804a056:	e8 05 ea ff ff       	call   8048a60 <close@plt>
 804a05b:	83 c4 10             	add    $0x10,%esp
 804a05e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a063:	e9 b3 00 00 00       	jmp    804a11b <init_driver+0x1a4>
 804a068:	83 ec 08             	sub    $0x8,%esp
 804a06b:	6a 10                	push   $0x10
 804a06d:	8d 45 d8             	lea    -0x28(%ebp),%eax
 804a070:	50                   	push   %eax
 804a071:	e8 0a e8 ff ff       	call   8048880 <bzero@plt>
 804a076:	83 c4 10             	add    $0x10,%esp
 804a079:	66 c7 45 d8 02 00    	movw   $0x2,-0x28(%ebp)
 804a07f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a082:	8b 40 0c             	mov    0xc(%eax),%eax
 804a085:	89 c2                	mov    %eax,%edx
 804a087:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804a08a:	8b 40 10             	mov    0x10(%eax),%eax
 804a08d:	8b 00                	mov    (%eax),%eax
 804a08f:	83 ec 04             	sub    $0x4,%esp
 804a092:	52                   	push   %edx
 804a093:	8d 55 d8             	lea    -0x28(%ebp),%edx
 804a096:	83 c2 04             	add    $0x4,%edx
 804a099:	52                   	push   %edx
 804a09a:	50                   	push   %eax
 804a09b:	e8 40 e8 ff ff       	call   80488e0 <bcopy@plt>
 804a0a0:	83 c4 10             	add    $0x10,%esp
 804a0a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804a0a6:	0f b7 c0             	movzwl %ax,%eax
 804a0a9:	83 ec 0c             	sub    $0xc,%esp
 804a0ac:	50                   	push   %eax
 804a0ad:	e8 0e e8 ff ff       	call   80488c0 <htons@plt>
 804a0b2:	83 c4 10             	add    $0x10,%esp
 804a0b5:	66 89 45 da          	mov    %ax,-0x26(%ebp)
 804a0b9:	83 ec 04             	sub    $0x4,%esp
 804a0bc:	6a 10                	push   $0x10
 804a0be:	8d 45 d8             	lea    -0x28(%ebp),%eax
 804a0c1:	50                   	push   %eax
 804a0c2:	ff 75 ec             	pushl  -0x14(%ebp)
 804a0c5:	e8 86 e9 ff ff       	call   8048a50 <connect@plt>
 804a0ca:	83 c4 10             	add    $0x10,%esp
 804a0cd:	85 c0                	test   %eax,%eax
 804a0cf:	79 2b                	jns    804a0fc <init_driver+0x185>
 804a0d1:	ff 75 f0             	pushl  -0x10(%ebp)
 804a0d4:	ff 75 f4             	pushl  -0xc(%ebp)
 804a0d7:	68 b4 a9 04 08       	push   $0x804a9b4
 804a0dc:	ff 75 08             	pushl  0x8(%ebp)
 804a0df:	e8 2c e9 ff ff       	call   8048a10 <sprintf@plt>
 804a0e4:	83 c4 10             	add    $0x10,%esp
 804a0e7:	83 ec 0c             	sub    $0xc,%esp
 804a0ea:	ff 75 ec             	pushl  -0x14(%ebp)
 804a0ed:	e8 6e e9 ff ff       	call   8048a60 <close@plt>
 804a0f2:	83 c4 10             	add    $0x10,%esp
 804a0f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804a0fa:	eb 1f                	jmp    804a11b <init_driver+0x1a4>
 804a0fc:	83 ec 0c             	sub    $0xc,%esp
 804a0ff:	ff 75 ec             	pushl  -0x14(%ebp)
 804a102:	e8 59 e9 ff ff       	call   8048a60 <close@plt>
 804a107:	83 c4 10             	add    $0x10,%esp
 804a10a:	8b 45 08             	mov    0x8(%ebp),%eax
 804a10d:	66 c7 00 4f 4b       	movw   $0x4b4f,(%eax)
 804a112:	c6 40 02 00          	movb   $0x0,0x2(%eax)
 804a116:	b8 00 00 00 00       	mov    $0x0,%eax
 804a11b:	c9                   	leave  
 804a11c:	c3                   	ret    

0804a11d <driver_post>:
 804a11d:	55                   	push   %ebp
 804a11e:	89 e5                	mov    %esp,%ebp
 804a120:	83 ec 18             	sub    $0x18,%esp
 804a123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 804a127:	74 26                	je     804a14f <driver_post+0x32>
 804a129:	83 ec 08             	sub    $0x8,%esp
 804a12c:	ff 75 0c             	pushl  0xc(%ebp)
 804a12f:	68 dd a9 04 08       	push   $0x804a9dd
 804a134:	e8 17 e7 ff ff       	call   8048850 <printf@plt>
 804a139:	83 c4 10             	add    $0x10,%esp
 804a13c:	8b 45 14             	mov    0x14(%ebp),%eax
 804a13f:	66 c7 00 4f 4b       	movw   $0x4b4f,(%eax)
 804a144:	c6 40 02 00          	movb   $0x0,0x2(%eax)
 804a148:	b8 00 00 00 00       	mov    $0x0,%eax
 804a14d:	eb 51                	jmp    804a1a0 <driver_post+0x83>
 804a14f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804a153:	74 3a                	je     804a18f <driver_post+0x72>
 804a155:	8b 45 08             	mov    0x8(%ebp),%eax
 804a158:	0f b6 00             	movzbl (%eax),%eax
 804a15b:	84 c0                	test   %al,%al
 804a15d:	74 30                	je     804a18f <driver_post+0x72>
 804a15f:	83 ec 04             	sub    $0x4,%esp
 804a162:	ff 75 14             	pushl  0x14(%ebp)
 804a165:	ff 75 0c             	pushl  0xc(%ebp)
 804a168:	68 f4 a9 04 08       	push   $0x804a9f4
 804a16d:	ff 75 08             	pushl  0x8(%ebp)
 804a170:	68 fb a9 04 08       	push   $0x804a9fb
 804a175:	68 26 47 00 00       	push   $0x4726
 804a17a:	68 a3 a9 04 08       	push   $0x804a9a3
 804a17f:	e8 89 f7 ff ff       	call   804990d <submitr>
 804a184:	83 c4 20             	add    $0x20,%esp
 804a187:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a18a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a18d:	eb 11                	jmp    804a1a0 <driver_post+0x83>
 804a18f:	8b 45 14             	mov    0x14(%ebp),%eax
 804a192:	66 c7 00 4f 4b       	movw   $0x4b4f,(%eax)
 804a197:	c6 40 02 00          	movb   $0x0,0x2(%eax)
 804a19b:	b8 00 00 00 00       	mov    $0x0,%eax
 804a1a0:	c9                   	leave  
 804a1a1:	c3                   	ret    

0804a1a2 <hash>:
 804a1a2:	55                   	push   %ebp
 804a1a3:	89 e5                	mov    %esp,%ebp
 804a1a5:	83 ec 10             	sub    $0x10,%esp
 804a1a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804a1af:	eb 1a                	jmp    804a1cb <hash+0x29>
 804a1b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a1b4:	6b c8 67             	imul   $0x67,%eax,%ecx
 804a1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1ba:	8d 50 01             	lea    0x1(%eax),%edx
 804a1bd:	89 55 08             	mov    %edx,0x8(%ebp)
 804a1c0:	0f b6 00             	movzbl (%eax),%eax
 804a1c3:	0f be c0             	movsbl %al,%eax
 804a1c6:	01 c8                	add    %ecx,%eax
 804a1c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804a1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1ce:	0f b6 00             	movzbl (%eax),%eax
 804a1d1:	84 c0                	test   %al,%al
 804a1d3:	75 dc                	jne    804a1b1 <hash+0xf>
 804a1d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a1d8:	c9                   	leave  
 804a1d9:	c3                   	ret    

0804a1da <check>:
 804a1da:	55                   	push   %ebp
 804a1db:	89 e5                	mov    %esp,%ebp
 804a1dd:	83 ec 10             	sub    $0x10,%esp
 804a1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 804a1e3:	c1 e8 1c             	shr    $0x1c,%eax
 804a1e6:	85 c0                	test   %eax,%eax
 804a1e8:	75 07                	jne    804a1f1 <check+0x17>
 804a1ea:	b8 00 00 00 00       	mov    $0x0,%eax
 804a1ef:	eb 33                	jmp    804a224 <check+0x4a>
 804a1f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804a1f8:	eb 1f                	jmp    804a219 <check+0x3f>
 804a1fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a1fd:	8b 55 08             	mov    0x8(%ebp),%edx
 804a200:	89 c1                	mov    %eax,%ecx
 804a202:	d3 ea                	shr    %cl,%edx
 804a204:	89 d0                	mov    %edx,%eax
 804a206:	0f b6 c0             	movzbl %al,%eax
 804a209:	83 f8 0a             	cmp    $0xa,%eax
 804a20c:	75 07                	jne    804a215 <check+0x3b>
 804a20e:	b8 00 00 00 00       	mov    $0x0,%eax
 804a213:	eb 0f                	jmp    804a224 <check+0x4a>
 804a215:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
 804a219:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
 804a21d:	7e db                	jle    804a1fa <check+0x20>
 804a21f:	b8 01 00 00 00       	mov    $0x1,%eax
 804a224:	c9                   	leave  
 804a225:	c3                   	ret    

0804a226 <gencookie>:
 804a226:	55                   	push   %ebp
 804a227:	89 e5                	mov    %esp,%ebp
 804a229:	83 ec 18             	sub    $0x18,%esp
 804a22c:	ff 75 08             	pushl  0x8(%ebp)
 804a22f:	e8 6e ff ff ff       	call   804a1a2 <hash>
 804a234:	83 c4 04             	add    $0x4,%esp
 804a237:	83 ec 0c             	sub    $0xc,%esp
 804a23a:	50                   	push   %eax
 804a23b:	e8 10 e7 ff ff       	call   8048950 <srand@plt>
 804a240:	83 c4 10             	add    $0x10,%esp
 804a243:	e8 a8 e7 ff ff       	call   80489f0 <rand@plt>
 804a248:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a24b:	83 ec 0c             	sub    $0xc,%esp
 804a24e:	ff 75 f4             	pushl  -0xc(%ebp)
 804a251:	e8 84 ff ff ff       	call   804a1da <check>
 804a256:	83 c4 10             	add    $0x10,%esp
 804a259:	85 c0                	test   %eax,%eax
 804a25b:	74 e6                	je     804a243 <gencookie+0x1d>
 804a25d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a260:	c9                   	leave  
 804a261:	c3                   	ret    
 804a262:	66 90                	xchg   %ax,%ax
 804a264:	66 90                	xchg   %ax,%ax
 804a266:	66 90                	xchg   %ax,%ax
 804a268:	66 90                	xchg   %ax,%ax
 804a26a:	66 90                	xchg   %ax,%ax
 804a26c:	66 90                	xchg   %ax,%ax
 804a26e:	66 90                	xchg   %ax,%ax

0804a270 <__libc_csu_init>:
 804a270:	55                   	push   %ebp
 804a271:	57                   	push   %edi
 804a272:	31 ff                	xor    %edi,%edi
 804a274:	56                   	push   %esi
 804a275:	53                   	push   %ebx
 804a276:	e8 35 e8 ff ff       	call   8048ab0 <__x86.get_pc_thunk.bx>
 804a27b:	81 c3 85 1d 00 00    	add    $0x1d85,%ebx
 804a281:	83 ec 0c             	sub    $0xc,%esp
 804a284:	8b 6c 24 20          	mov    0x20(%esp),%ebp
 804a288:	8d b3 0c ff ff ff    	lea    -0xf4(%ebx),%esi
 804a28e:	e8 4d e5 ff ff       	call   80487e0 <_init>
 804a293:	8d 83 08 ff ff ff    	lea    -0xf8(%ebx),%eax
 804a299:	29 c6                	sub    %eax,%esi
 804a29b:	c1 fe 02             	sar    $0x2,%esi
 804a29e:	85 f6                	test   %esi,%esi
 804a2a0:	74 23                	je     804a2c5 <__libc_csu_init+0x55>
 804a2a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 804a2a8:	83 ec 04             	sub    $0x4,%esp
 804a2ab:	ff 74 24 2c          	pushl  0x2c(%esp)
 804a2af:	ff 74 24 2c          	pushl  0x2c(%esp)
 804a2b3:	55                   	push   %ebp
 804a2b4:	ff 94 bb 08 ff ff ff 	call   *-0xf8(%ebx,%edi,4)
 804a2bb:	83 c7 01             	add    $0x1,%edi
 804a2be:	83 c4 10             	add    $0x10,%esp
 804a2c1:	39 f7                	cmp    %esi,%edi
 804a2c3:	75 e3                	jne    804a2a8 <__libc_csu_init+0x38>
 804a2c5:	83 c4 0c             	add    $0xc,%esp
 804a2c8:	5b                   	pop    %ebx
 804a2c9:	5e                   	pop    %esi
 804a2ca:	5f                   	pop    %edi
 804a2cb:	5d                   	pop    %ebp
 804a2cc:	c3                   	ret    
 804a2cd:	8d 76 00             	lea    0x0(%esi),%esi

0804a2d0 <__libc_csu_fini>:
 804a2d0:	f3 c3                	repz ret 

Disassembly of section .fini:

0804a2d4 <_fini>:
 804a2d4:	53                   	push   %ebx
 804a2d5:	83 ec 08             	sub    $0x8,%esp
 804a2d8:	e8 d3 e7 ff ff       	call   8048ab0 <__x86.get_pc_thunk.bx>
 804a2dd:	81 c3 23 1d 00 00    	add    $0x1d23,%ebx
 804a2e3:	83 c4 08             	add    $0x8,%esp
 804a2e6:	5b                   	pop    %ebx
 804a2e7:	c3                   	ret    
