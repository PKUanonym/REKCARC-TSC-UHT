   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori $1,$0,0x100
   jr $1

   .org 0x20
   mfc0 $1,$13,0x0
   
   andi $4,$1,0x0800     # if UART receive data interrupt
   bne $4,$0,_int2
   nop
   eret

   .org 0x100
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

   lui $1,0x1000
   ori $1,$1,0x0001
   ori $2,$0,0x01
   sb  $2,0x0($1)    # enable received data interrupt

   lui $1,0x1000
   ori $1,$1,0x0801  # enable uart interrupt
   mtc0 $1,$12,0x0
   
_loop:
   j _loop
   nop

_int2:
   
   lui $1,0x1000
   ori $1,$1,0x0005
   lb  $3,0x0($1)    # get line status register
   
   andi $3,$3,0x01
   beq $3,$0,_end
   nop

_sendback:
   lui $1,0x1000
   ori $1,$1,0x0000
   lb  $2,0x0($1)
   sb  $2,0x0($1)

_loop2:
   lui $1,0x1000
   ori $1,$1,0x0005
   lb  $2,0x0($1)    # get line status register

   andi $2,$2,0x20
   beq $2,$0,_loop2
   nop

   lui $1,0x1000
   ori $1,$1,0x0005
   lb  $3,0x0($1)
   andi $3,$3,0x01
   bne $3,$0,_sendback
   nop

_end:
   eret
   nop   
   

   


   
   
