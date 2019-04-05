# SPIM S20 MIPS simulator.
# The default trap handler for spim.
#
# Copyright (C) 1990-2000 James Larus, larus@cs.wisc.edu.
# ALL RIGHTS RESERVED.
#
# SPIM is distributed under the following conditions:
#
# You may make copies of SPIM for your own use and modify those copies.
#
# All copies of SPIM must retain my name and copyright notice.
#
# You may not sell SPIM or distributed SPIM in conjunction with a commerical
# product or service without the expressed written consent of James Larus.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE.
#

# $Header: $


# Define the exception handling code.  This must go first!

	.kdata
__m1_:	.asciiz "  Exception "
__m2_:	.asciiz " occurred and ignored\n"
__e0_:	.asciiz "  [Interrupt] "
__e1_:	.asciiz	""
__e2_:	.asciiz	""
__e3_:	.asciiz	""
__e4_:	.asciiz	"  [Unaligned address in inst/data fetch] "
__e5_:	.asciiz	"  [Unaligned address in store] "
__e6_:	.asciiz	"  [Bad address in text read] "
__e7_:	.asciiz	"  [Bad address in data/stack read] "
__e8_:	.asciiz	"  [Error in syscall] "
__e9_:	.asciiz	"  [Breakpoint] "
__e10_:	.asciiz	"  [Reserved instruction] "
__e11_:	.asciiz	""
__e12_:	.asciiz	"  [Arithmetic overflow] "
__e13_:	.asciiz	"  [Inexact floating point result] "
__e14_:	.asciiz	"  [Invalid floating point result] "
__e15_:	.asciiz	"  [Divide by 0] "
__e16_:	.asciiz	"  [Floating point overflow] "
__e17_:	.asciiz	"  [Floating point underflow] "
__excp:	.word __e0_,__e1_,__e2_,__e3_,__e4_,__e5_,__e6_,__e7_,__e8_,__e9_
	.word __e10_,__e11_,__e12_,__e13_,__e14_,__e15_,__e16_,__e17_
s1:	.word 0
s2:	.word 0

	.ktext 0x80000080
	.set noat
	# Because we are running in the kernel, we can use $k0/$k1 without
	# saving their old values.
	move $k1 $at	# Save $at
	.set at
	sw $v0 s1	# Not re-entrent and we can't trust $sp
	sw $a0 s2
	mfc0 $k0 $13	# Cause
        sgt $v0 $k0 0x44 # ignore interrupt exceptions
        bgtz $v0 ret
        addu $0 $0 0
	li $v0 4	# syscall 4 (print_str)
	la $a0 __m1_
	syscall
	li $v0 1	# syscall 1 (print_int)
        srl $a0 $k0 2	# shift Cause reg
	syscall
	li $v0 4	# syscall 4 (print_str)
	lw $a0 __excp($k0)
	syscall
#jdz I commented out the 2 lines below to force an
#immediate exit on any exception rather than try to recover
#	bne $k0 0x18 ok_pc # Bad PC requires special checks
	mfc0 $a0, $14	# EPC
	and $a0, $a0, 0x3 # Is EPC word-aligned?
#	beq $a0, 0, ok_pc
	li $v0 10	# Exit on really bad PC (out of text)
	syscall

ok_pc:
	li $v0 4	# syscall 4 (print_str)
	la $a0 __m2_
	syscall
	mtc0 $0, $13	# Clear Cause register
ret:	lw $v0 s1
	lw $a0 s2
	mfc0 $k0 $14	# EPC
	.set noat
	move $at $k1	# Restore $at
	.set at
	rfe		# Return from exception handler
	addiu $k0 $k0 4 # Return to next instruction
	jr $k0


# Standard startup code.  Invoke the routine main with no arguments.

	.text
	.globl __start
__start:
	lw $a0, 0($sp)	# argc
	addiu $a1, $sp, 4 # argv
	addiu $a2, $a1, 4 # envp
	sll $v0, $a0, 2
	addu $a2, $a2, $v0
	jal main
	li $v0 10
	syscall		# syscall 10 (exit)


	#  From here down is the standard library which is linked into all
	#  programs. It contains the assembly for the built-in library
	#  functions (Print, Read, Alloc)
	#  Where possible built-ins are frameless (don't set up fp, etc.)
	#  Each expects args to be in $sp + 4, +8, etc.
	#  Return value (if any) assigned to v0
	#  May trash a0-a3 registers, uses no others


	#  Library function ptr = Alloc(int size)
	#  -----------------------------------------
	#  Used for New and NewArray.
	#  Allocates space in heap and returns address in $v0
	.globl _Alloc
_Alloc:

        lw $a0, 4($sp)        # get number of bytes
        li $v0, 9             # 9 is code for srbk sys call
        syscall
        beqz $v0, _AFail
        jr $ra
    _AFail:
        .data
        _memErrStr:  .asciiz "Allocate failed: out of memory"
        .text
        la $a0, _memErrStr    # print error message
        li $v0, 4
        syscall
        li $v0, 10            # 10 is code for exit syscall
        syscall


	#  Library function PrintInt(int n)
	#  --------------------------------
	#  Prints number given as argument to console
	.globl _PrintInt
  _PrintInt:
        lw $a0, 4($sp)        # syscall expects arg in a0
        li $v0, 1             # 1 is code for print int syscall
        syscall
        jr $ra

	#  Library function PrintBool(bool b)
	#  ----------------------------------
	#  Prints true/false value given to console
	.globl _PrintBool
  _PrintBool:
        .data
        _trueStr:  .asciiz "true" # string constants for true/false
        _falseStr: .asciiz "false"
        .text
        lw $a0, 4($sp)
        li $v0, 4                # 4 is print string syscall
        beqz $a0 _PBFalse
        la $a0, _trueStr
        syscall
        jr $ra
    _PBFalse:
        la $a0, _falseStr
        syscall
        jr $ra

	#  Library function PrintString(address str)
	#  -----------------------------------------
	#  Prints string located at the address to console
	.globl _PrintString
  _PrintString:
        lw $a0, 4($sp)        # syscall expects arg in a0
        li $v0, 4             # 4 is code for print string syscall
        syscall
        jr $ra

	#  Library function n = ReadInteger()
	#  ----------------------------------
	#  Reads a number from the console and returns it in $v0
	.globl _ReadInteger
  _ReadInteger:
        li $v0, 5             # 5 is code for read int syscall
        syscall
        jr $ra

	#  Library function s = ReadLine()
	#  -------------------------------
	#  Reads a line from the console into heap-allocated buffer and
	#  returns its address in $v0
	.globl _ReadLine
  _ReadLine:
        li $a0, 64       # allocate space, fixed size 64
        li $v0, 9        # make sbrk syscall
        syscall
        move $a0, $v0    # copy return value from sbrk as 1st arg
        li $a1, 64       # push size of buffer
        li $v0, 8        # read_string syscall
        syscall
        move $v0, $a0    # put result in v0
                         # now go find \n and terminate over it
    _RLLoopTop:
        lb $a1, ($a0)           # use a1 to hold next char
        beqz $a1, _RLLoopDone  # halt if find null terminator
        addi $a1, $a1, -10      # subtract ASCII newline
        beqz $a1, _RLLoopDone  # halt if find newline
        addi $a0, $a0, 1        # advance by one
        j _RLLoopTop
   _RLLoopDone:
        sb $a1, ($a0)           # store 0 over newline
        jr $ra


	#  Library function if (StringEqual(addr s, addr t)) ...
	#  ----------------------------------------------------
	#  Compares two strings for equality (case-sensitive)
	#  returns true/false in $v0
	.globl _StringEqual
 _StringEqual:
        lw $a0, 4($sp)
        lw $a2, 8($sp)
    _SELoopTop:
        lb $a1, ($a0)              # load next 2 chars
        lb $a3, ($a2)              #
        bne $a1, $a3, _SEnoMatch   # return false if chars don't match
        beqz $a1, _SEmatch         # return true if at null terminator
        addi $a0, $a0, 1           # advance both by one
        addi $a2, $a2, 1
        j _SELoopTop
    _SEnoMatch:
        li $v0, 0
        jr $ra
    _SEmatch:
        li $v0, 1
        jr $ra


	#  Library function Halt()
	#  -----------------------
	#  Exits process
	.globl _Halt
  _Halt:
	li $v0, 10			  # 10 is code for exit syscall
	syscall

