#include <stdio.h>
#include <ulib.h>

int
main(void) {
    asm volatile("int $14");
    panic("FAIL: T.T\n");
}

