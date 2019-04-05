#include <stdio.h>
#include <ulib.h>

int
main(void) {
    int pid, ret;
    cprintf("I am the parent. Forking the child...\n");
    if ((pid = fork()) == 0) {
        cprintf("I am the child. spinning ...\n");
        while (1);
    }
    cprintf("I am the parent. Running the child...\n");

    yield();
    yield();
    yield();

    cprintf("I am the parent.  Killing the child...\n");

    assert((ret = kill(pid)) == 0);
    cprintf("kill returns %d\n", ret);

    assert((ret = waitpid(pid, NULL)) == 0);
    cprintf("wait returns %d\n", ret);

    cprintf("spin may pass.\n");
    return 0;
}

