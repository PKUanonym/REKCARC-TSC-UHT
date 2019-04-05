   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori $1,$0,0xf
   mtc0 $1,$11,0x0  #Ð´compare¼Ä´æÆ÷£¬¿ªÊ¼¼ÆÊ±
   lui $1,0x1000
   ori $1,$1,0x401
   mtc0 $1,$12,0x0  #½«0x401Ð´Èçstatus¼Ä´æÆ÷
   mfc0 $2,$12,0x0  #¶Ástatus¼Ä´æÆ÷£¬$2=0x401

_loop:
   j _loop
   nop
   
   
