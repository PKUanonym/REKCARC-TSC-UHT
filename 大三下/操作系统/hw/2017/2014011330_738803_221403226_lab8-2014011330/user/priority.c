#include <ulib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TOTAL 5
/* to get enough accuracy, MAX_TIME (the running time of each process) should >1000 mseconds. */
#define MAX_TIME  1000
#define SLEEP_TIME 400
unsigned int acc[TOTAL];
int status[TOTAL];
int pids[TOTAL];

static void
spin_delay(void)
{
     int i;
     volatile int j;
     for (i = 0; i != 200; ++ i)
     {
          j = !j;
     }
}

int
main(void) {
     int i,time;
     cprintf("priority process will sleep %d ticks\n",SLEEP_TIME);
     sleep(SLEEP_TIME);
     memset(pids, 0, sizeof(pids));
     lab6_set_priority(TOTAL + 1);

     for (i = 0; i < TOTAL; i ++) {
          acc[i]=0;
          if ((pids[i] = fork()) == 0) {
               lab6_set_priority(i + 1);
               acc[i] = 0;
               while (1) {
                    spin_delay();
                    ++ acc[i];
                    if(acc[i]%4000==0) {
                        if((time=gettime_msec())>SLEEP_TIME+MAX_TIME) {
                            cprintf("child pid %d, acc %d, time %d\n",getpid(),acc[i],time);
                            exit(acc[i]);
                        }
                    }
               }
               
          }
          if (pids[i] < 0) {
               goto failed;
          }
     }

     cprintf("main: fork ok,now need to wait pids.\n");

     for (i = 0; i < TOTAL; i ++) {
         status[i]=0;
         waitpid(pids[i],&status[i]);
         cprintf("main: pid %d, acc %d, time %d\n",pids[i],status[i],gettime_msec()); 
     }
     cprintf("main: wait pids over\n");
     cprintf("stride sched correct result:");
     for (i = 0; i < TOTAL; i ++)
     {
         cprintf(" %d", (status[i] * 2 / status[0] + 1) / 2);
     }
     cprintf("\n");

     return 0;

failed:
     for (i = 0; i < TOTAL; i ++) {
          if (pids[i] > 0) {
               kill(pids[i]);
          }
     }
     panic("FAIL: T.T\n");
}

