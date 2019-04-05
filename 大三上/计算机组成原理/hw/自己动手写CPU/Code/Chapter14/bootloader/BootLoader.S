   .set noat
   .set noreorder
   .set nomacro
   
    .org 0x0
   .text
   .align 4
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

   lui $1,0x2000
   ori $1,$1,0x0008
   lui $2,0xffff
   ori $2,$2,0xffff
   sw  $2,0x0($1)

   lui $1,0x2000
   ori $1,$1,0x000c
   lui $2,0x0000
   ori $2,$2,0x0000
   sw  $2,0x0($1)


_waiting_sdram_init_done:
   lui $1,0x2000
   ori $1,$1,0x0000
   lw  $4,0x0($1)
   srl $4,$4,0x10
   
   andi $4,$4,0x0001
   beq $4,$0,_waiting_sdram_init_done
   nop



   li $1,0x1
   la $2,_BootBeginInfoStr
   la $3,_BootBeginInfoStrLen
   lb $5,0x0($3)
1:
   lb $4,0x0($2)
   jal _print
   addi $2,$2,0x1
   bne $5,$0,1b 
   subu $5,$5,$1


   li $5,0x4
   lui $1,0x3000
   ori $1,$1,0x0300
   lw  $1,0x0($1)             # $1: rom length 
   nop   

   lui $2,0x0000              # $2: destination address
   lui $3,0x3000            
   ori $3,$3,0x0304           # $3: source address
1:
   lw $4,0x0($3)
   nop
   sw $4,0x0($2)
   addi $2,$2,0x4
   addi $3,$3,0x4
   nop 
   bgez $1,1b
   subu $1,$1,$5

   li $1,0x1
   la $2,_BootEndInfoStr
   la $3,_BootEndInfoStrLen
   lb $5,0x0($3)
1:
   lb $4,0x0($2)
   jal _print
   addi $2,$2,0x1
   bne $5,$0,1b 
   sub $5,$5,$1

   jr $0
   nop 

_print:
   lui $6,0x1000
   ori $6,$6,0x0
   sb $4,0x0($6)
_waiting_transmit_done:
   lui $6,0x1000
   ori $6,$6,0x0005
   lb  $7,0x0($6)    # get line status register

   andi $7,$7,0x20
   beq $7,$0,_waiting_transmit_done
   nop
   jr $31
   nop

   
   .data
_BootBeginInfoStr:
   .ascii "Loading OS into SDRAM...\n"
_BootBeginInfoStrLen:
   .byte 26
_BootEndInfoStr:
   .ascii "Load OS into SDRAM DONE!!!\n"
_BootEndInfoStrLen:
   .byte 28
