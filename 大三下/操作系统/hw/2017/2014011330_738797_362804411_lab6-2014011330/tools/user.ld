/* Simple linker script for ucore user-level programs.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS {
    /* Load programs at this address: "." means the current address */
    . = 0x800020;

    .text : {
        *(.text .stub .text.* .gnu.linkonce.t.*)
    }

    PROVIDE(etext = .); /* Define the 'etext' symbol to this value */

    .rodata : {
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    /* Adjust the address for the data segment to the next page */
    . = ALIGN(0x1000);

    .data : {
        *(.data)
    }

    PROVIDE(edata = .);

    .bss : {
        *(.bss)
    }

    PROVIDE(end = .);


    /* Place debugging symbols so that they can be found by
     * the kernel debugger.
     * Specifically, the four words at 0x200000 mark the beginning of
     * the stabs, the end of the stabs, the beginning of the stabs
     * string table, and the end of the stabs string table, respectively.
     */

    .stab_info 0x200000 : {
        LONG(__STAB_BEGIN__);
        LONG(__STAB_END__);
        LONG(__STABSTR_BEGIN__);
        LONG(__STABSTR_END__);
    }

    .stab : {
        __STAB_BEGIN__ = DEFINED(__STAB_BEGIN__) ? __STAB_BEGIN__ : .;
        *(.stab);
        __STAB_END__ = DEFINED(__STAB_END__) ? __STAB_END__ : .;
        BYTE(0)     /* Force the linker to allocate space
                   for this section */
    }

    .stabstr : {
        __STABSTR_BEGIN__ = DEFINED(__STABSTR_BEGIN__) ? __STABSTR_BEGIN__ : .;
        *(.stabstr);
        __STABSTR_END__ = DEFINED(__STABSTR_END__) ? __STABSTR_END__ : .;
        BYTE(0)     /* Force the linker to allocate space
                   for this section */
    }

    /DISCARD/ : {
        *(.eh_frame .note.GNU-stack .comment)
    }
}
