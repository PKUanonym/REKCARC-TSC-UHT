   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   lui $1,0x1000
   ori $1,$1,0x0003
   ori $2,$0,0x80
   sb  $2,0x0($1)

   lui $1,0x1000
   ori $1,$1,0x0001
   ori $2,$0,0x00
   sb  $2,0x0($1)    # MSB of divisor latch 

   lui $1,0x1000
   ori $1,$1,0x0000
   ori $2,$0,0xB0
   sb  $2,0x0($1)    # LSB of divisor latch 

   lui $1,0x1000
   ori $1,$1,0x0003
   ori $2,$0,0x03
   sb  $2,0x0($1)    # 8bit, no parity, 1 stop bit
   
   ori $3,$0,0x0   

_loop1:
   addi $3,$3,0x1
   lui $1,0x1000
   ori $1,$1,0x0000
   sb  $3,0x0($1)    # transmit $3

_loop2:
   lui $1,0x1000
   ori $1,$1,0x0005
   lb  $2,0x0($1)    # get line status register
   andi $2,$2,0x20
   beq $2,$0,_loop2
   nop
   j _loop1
   nop
   
   

   


   
   
