#ifndef __KERN_SCHEDULE_SCHED_H__
#define __KERN_SCHEDULE_SCHED_H__

#include <proc.h>

void schedule(void);
void wakeup_proc(struct proc_struct *proc);

#endif /* !__KERN_SCHEDULE_SCHED_H__ */

