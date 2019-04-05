#include <defs.h>
#include <mmu.h>
#include <memlayout.h>
#include <clock.h>
#include <trap.h>
#include <x86.h>
#include <stdio.h>
#include <assert.h>
#include <console.h>
#include <vmm.h>
#include <swap.h>
#include <kdebug.h>
#include <unistd.h>
#include <syscall.h>
#include <error.h>
#include <sched.h>
#include <sync.h>
#include <proc.h>
#include <sched.h>
#include <sem.h>

typedef struct foo {
	int a;
	char b;
} foo_t;

foo_t* gbl_foo = NULL;

foo_t* old_foo_ref = NULL;
foo_t* new_foo_ref = NULL;
int grace_period_count = 0;

semaphore_t foo_sem;

static void rcu_read_lock(foo_t* ref) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
		if (ref == old_foo_ref) {
			grace_period_count += 1;
		}
    }
}

static void rcu_read_unlock(foo_t* ref) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
		if (ref == old_foo_ref) {
			grace_period_count -= 1;
		}
    }
}

static int resync_rcu_trail() {
	return (grace_period_count != 0);
}

static void foo_read(int id) {
	cprintf("Foo_read %d starts.\n", id);
	rcu_read_lock(gbl_foo);
	// First get the pointer, in case it is modified during the execution
	foo_t* fp = gbl_foo;
	// If fp == NULL, it means gbl_foo has been deleted (don't care whether it is destroyed)
	if (fp != NULL) {
		// Sleep for some time.
		do_sleep(2);
		// If gbl_foo is deleted here, everything will be okay,
		// But old gbl_foo cannot be destroyed here! Someone is still reading it
		cprintf("[SAFE] foo_read: gbl_foo.a = %d, gbl_foo.b = %c\n", fp->a, fp->b);
	} else {
		panic("[DANGER] foo_read: attempt to read foo when foo is null.");
	}
	rcu_read_unlock(fp);
	cprintf("Foo_read %d ends.\n", id);
}

// Update the gbl_foo to new_fp and free the old_fp.
// However, the free process could happen when Line36 is running.
// Thus, we need to do the update but delay the destroy of old_foo.
// Until all foo_reads exits the critical area.
static void foo_update(int id) {
	cprintf("Foo_update %d starts.\n", id);
	// foo_sem is a mutex for gbl_foo
	down(&(foo_sem));
	foo_t* old_fp = gbl_foo;
	gbl_foo = new_foo_ref;
	up(&(foo_sem));
	cprintf("Foo_update waiting for %d graceful period to finish.\n", grace_period_count);
	// spin when process left in grace period
	while (resync_rcu_trail()) schedule();
	kfree(old_fp);
	cprintf("Foo_update %d ends.\n", id);
}

void check_rcu() {
	sem_init(&(foo_sem), 1);
	old_foo_ref = (foo_t*) kmalloc(sizeof(foo_t));
	old_foo_ref->a = 5;
	old_foo_ref->b = 'O';
	new_foo_ref = (foo_t*) kmalloc(sizeof(foo_t));
	new_foo_ref->a = 6;
	new_foo_ref->b = 'N';

	gbl_foo = old_foo_ref;

	int r1k = kernel_thread(foo_read, (void *)1, 0);
	int r2k = kernel_thread(foo_read, (void *)2, 0);
	int w1k = kernel_thread(foo_update, (void *)1, 0);
	int r3k = kernel_thread(foo_read, (void *)3, 0);
	int r4k = kernel_thread(foo_read, (void *)4, 0);

	do_wait(r1k, NULL);
	do_wait(r2k, NULL);
	do_wait(w1k, NULL);
	do_wait(r3k, NULL);
	do_wait(r4k, NULL);

	cprintf("check_rcu() passed\n");
}
