   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori $1,$0,0x100     # $1 = 0x100
   jr $1
   nop

   .org 0x40
   ori $1,$0,0xf0f0    # $1 = 0x0000f0f0
   ori $1,$0,0xffff    # $1 = 0x0000ffff
   ori $1,$0,0x0f0f    # $1 = 0x00000f0f
   mfc0 $4,$14,0x0     
   addi $4,$4,0x4      
   mtc0 $4,$14,0x0
   eret
   nop

   .org 0x100
   ori $1,$0,0x1000    # $1 = 0x00001000
   ori $2,$0,0x1000    # $2 = 0x00001000
   teq $1,$2           # trap happen
   ori $1,$0,0x2000    # $1 = 0x00002000
   tne $1,$2           # trap happen
   ori $1,$0,0x3000    # $1 = 0x00003000
   teqi $1,0x3000      # trap happen
   ori $1,$0,0x4000    # $1 = 0x00004000
   tnei $1,0x2000      # trap happen
   ori $1,$0,0x5000    # $1 = 0x00005000
   tge $1,$2           # trap happen
   ori $1,$0,0x6000    # $1 = 0x00006000
   tgei $1,0x4000      # trap happen
   ori $1,$0,0x7000    # $1 = 0x00007000
   tgeiu $1,0x7000     # trap happen
   ori $1,$0,0x8000    # $1 = 0x00008000
   tgeu $1,$2          # trap happen
   ori $1,$0,0x9000    # $1 = 0x00009000
   tlt $1,$2           # not trap
   ori $1,$0,0xa000    # $1 = 0x0000a000
   tlti $1,0x9000      # not trap
   ori $1,$0,0xb000    # $1 = 0x0000b000
   tltiu $1,0xb000     # trap happen ecause $1=0xb000 < 0xffffb000
   ori $1,$0,0xc000    # $1 = 0x0000c000
   tltu $2,$1          # trap happen
   ori $1,$0,0xd000    # $1 = 0x0000d000
_loop:
   j _loop
   nop
   
   
