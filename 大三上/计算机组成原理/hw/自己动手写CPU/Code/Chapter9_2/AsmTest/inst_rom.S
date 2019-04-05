   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori $1,$0,0x1234    # $1 = 0x00001234
   sw  $1,0x0($0)      # [0x0] = 0x00001234

   ori $1,$0,0x5678    # $1 = 0x00005678
   sc  $1,0x0($0)      # $1 = 0x0
   lw  $1,0x0($0)      # $1 = 0x00001234
   nop

   ori $1,$0,0x0       # $1 = 0x0
   ll  $1,0x0($0)      # $1 = 0x00001234
   nop
   addi $1,$1,0x1      # $1 = 0x00001235
   sc  $1,0x0($0)      # $1 = 0x1
   lw  $1,0x0($0)      # $1 = 0x00001235               
    
_loop:
   j _loop
   nop
