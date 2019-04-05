#include <stdio.h>
#include <ulib.h>

#define ARRAYSIZE (1024*1024)

uint32_t bigarray[ARRAYSIZE];

int
main(void) {
    cprintf("Making sure bss works right...\n");
    int i;
    for (i = 0; i < ARRAYSIZE; i ++) {
        if (bigarray[i] != 0) {
            panic("bigarray[%d] isn't cleared!\n", i);
        }
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
        bigarray[i] = i;
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
        if (bigarray[i] != i) {
            panic("bigarray[%d] didn't hold its value!\n", i);
        }
    }

    cprintf("Yes, good.  Now doing a wild write off the end...\n");
    cprintf("testbss may pass.\n");

    bigarray[ARRAYSIZE + 1024] = 0;
    asm volatile ("int $0x14");
    panic("FAIL: T.T\n");
}

