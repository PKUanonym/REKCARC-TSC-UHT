/* File:    pth_msg_sem_mac.c
 *
 * Purpose: Each thread ``sends a message'' to another thread and prints the
 *          message it receives.  This version uses named semaphores, since
 *          unnamed semaphores aren't available in MacOS X (as of 10.6).
 *
 * Compile: gcc -g -Wall -o pth_msg_sem_mac pth_msg_sem_mac.c -lpthread
 * Usage:   ./pth_msg_sem_mac <thread_count>
 *
 * Input:   none
 * Output:  message from each thread
 *
 * Note:    I'm grateful to Prof Gregory Benson of the University of
 *          San Francisco for showing me how to use semaphores with
 *          MacOS X.
 *
 * IPP:     Section 4.7 (pp. 174 and ff.)
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <fcntl.h>

const int MAX_THREADS = 1024;
const int MSG_MAX = 100;

/* Global variable:  accessible to all threads */
int thread_count;
char** messages;
char** snames;
sem_t** sems;

void Usage(char* prog_name);
void *Send_msg(void* rank);  /* Thread function */

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long       thread;
   pthread_t* thread_handles;

   if (argc != 2) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   if (thread_count <= 0 || thread_count > MAX_THREADS) Usage(argv[0]);

   thread_handles = (pthread_t*) malloc (thread_count*sizeof(pthread_t));
   messages = (char**) malloc(thread_count*sizeof(char*));
   for (thread = 0; thread < thread_count; thread++)
      messages[thread] = NULL;

   sems = (sem_t**) malloc (thread_count*sizeof(sem_t *));
   snames = (char **) malloc (thread_count*sizeof(char *));

   /* Initialize semaphores to 0:  they start "locked".  So     */
   /* executing a sem_wait will block until they're "unlocked". */
   for (thread = 0; thread < thread_count; thread++) {
      snames[thread] = malloc(10*sizeof(char));
      sprintf(snames[thread], "/sem%ld", thread);
      sems[thread] = sem_open(snames[thread], O_CREAT, 0777, 0);
   }

   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], NULL,
          Send_msg, (void*) thread);

   for (thread = 0; thread < thread_count; thread++) {
      pthread_join(thread_handles[thread], NULL);
   }

   for (thread = 0; thread < thread_count; thread++) {
      sem_unlink(snames[thread]);
      sem_close(sems[thread]);
      free(messages[thread]);
      free(snames[thread]);
   }

   free(sems);
   free(messages);
   free(thread_handles);
   return 0;
}  /* main */


/*--------------------------------------------------------------------
 * Function:    Usage
 * Purpose:     Print command line for function and terminate
 * In arg:      prog_name
 */
void Usage(char* prog_name) {

   fprintf(stderr, "usage: %s <number of threads>\n", prog_name);
   exit(0);
}  /* Usage */


/*-------------------------------------------------------------------
 * Function:    Send_msg
 * Purpose:     The function started by calls to pthread_create
 * In arg:      rank
 * Global var:  thread_count, sems
 * Return val:  Ignored
 */
void *Send_msg(void* rank) {
   long my_rank = (long) rank;
   long dest = (my_rank + 1) % thread_count;
   long source = (my_rank - 1 + thread_count) % thread_count;
   char* my_msg = malloc(MSG_MAX*sizeof(char));

   sprintf(my_msg, "Hello to %ld from %ld", dest, my_rank);
   messages[dest] = my_msg;
   /* Notify destination thread that it can proceed */
   sem_post(sems[dest]);

   /* Wait for source thread to say OK */
   sem_wait(sems[my_rank]);
   if (messages[my_rank] != NULL)
      printf("Thread %ld > %s\n", my_rank, messages[my_rank]);
   else
      printf("Thread %ld > No message from %ld\n", my_rank, source);

   return NULL;
}  /* hello */
