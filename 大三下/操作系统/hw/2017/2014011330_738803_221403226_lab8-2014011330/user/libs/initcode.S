.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp

    # load argc and argv
    movl (%esp), %ebx
    lea 0x4(%esp), %ecx


    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp

    # save argc and argv on stack
    pushl %ecx
    pushl %ebx

    # call user-program function
    call umain
1:  jmp 1b

    
