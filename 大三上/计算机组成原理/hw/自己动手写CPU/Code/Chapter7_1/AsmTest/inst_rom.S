   .org 0x0
   .set noat
   .global _start
_start:

   ######### add\addi\addiu\addu\sub\subu ##########

   ori  $1,$0,0x8000           # $1 = 0x8000
   sll  $1,$1,16               # $1 = 0x80000000
   ori  $1,$1,0x0010           # $1 = 0x80000010

   ori  $2,$0,0x8000           # $2 = 0x8000
   sll  $2,$2,16               # $2 = 0x80000000
   ori  $2,$2,0x0001           # $2 = 0x80000001

   ori  $3,$0,0x0000           # $3 = 0x00000000
   addu $3,$2,$1               # $3 = 0x00000011
   ori  $3,$0,0x0000           # $3 = 0x00000000
   add  $3,$2,$1               # overflow,$3 keep 0x00000000

   sub   $3,$1,$3              # $3 = 0x80000010         
   subu  $3,$3,$2              # $3 = 0xF

   addi $3,$3,2                # $3 = 0x11
   ori  $3,$0,0x0000           # $3 = 0x00000000
   addiu $3,$3,0x8000          # $3 = 0xffff8000

   #########     slt\sltu\slti\sltiu     ##########

   or   $1,$0,0xffff           # $1 = 0xffff
   sll  $1,$1,16               # $1 = 0xffff0000
   slt  $2,$1,$0               # $2 = 1
   sltu $2,$1,$0               # $2 = 0
   slti $2,$1,0x8000           # $2 = 1
   sltiu $2,$1,0x8000          # $2 = 1

   #########          clo\clz          ##########

   lui $1,0x0000          # $1 = 0x00000000
   clo $2,$1              # $2 = 0x00000000
   clz $2,$1              # $2 = 0x00000020

   lui $1,0xffff          # $1 = 0xffff0000
   ori $1,$1,0xffff       # $1 = 0xffffffff
   clz $2,$1              # $2 = 0x00000000
   clo $2,$1              # $2 = 0x00000020

   lui $1,0xa100          # $1 = 0xa1000000
   clz $2,$1              # $2 = 0x00000000
   clo $2,$1              # $2 = 0x00000001

   lui $1,0x1100          # $1 = 0x11000000
   clz $2,$1              # $2 = 0x00000003
   clo $2,$1              # $2 = 0x00000000

   ori  $1,$0,0xffff                  
   sll  $1,$1,16
   ori  $1,$1,0xfffb           # $1 = -5
   ori  $2,$0,6                # $2 = 6
   mul  $3,$1,$2               # $3 = -30 = 0xffffffe2
  
   mult $1,$2                  # hi = 0xffffffff
                               # lo = 0xffffffe2

   multu $1,$2                 # hi = 0x5
                               # lo = 0xffffffe2
   nop
   nop

