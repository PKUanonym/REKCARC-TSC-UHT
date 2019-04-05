	.org 0x0
.global _start
   .set noat
_start:
   lui  $1,0x0101
   ori  $1,$1,0x0101
   ori  $2,$1,0x1100        # $2 = $1 | 0x1100 = 0x01011101
   or   $1,$1,$2            # $1 = $1 | $2 = 0x01011101
   andi $3,$1,0x00fe        # $3 = $1 & 0x00fe = 0x00000000
   and  $1,$3,$1            # $1 = $3 & $1 = 0x00000000
   xori $4,$1,0xff00        # $4 = $1 ^ 0xff00 = 0x0000ff00
   xor  $1,$4,$1            # $1 = $4 ^ $1 = 0x0000ff00
   nor  $1,$4,$1            # $1 = $4 ~^ $1 = 0xffff00ff   nor is "not or"
