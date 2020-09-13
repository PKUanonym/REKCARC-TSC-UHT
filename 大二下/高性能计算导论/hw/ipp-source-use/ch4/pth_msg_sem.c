/* File:     pth_msg_sem.c
 *
 * Purpose:  Illustrate a synchronization problem with pthreads:  create 
 *           some threads, each of which creates a message and "sends" it
 *           to another thread, by copying it into that thread's buffer.
 *           This version uses semaphores to solve the synchronization
 *           problem.
 *
 * Input:    none
 * Output:   message from each thread
 *
 * Compile:  gcc -g -Wall -o pth_msg_sem pth_msg_sem.c -lpthread
 * Usage:    ./pth_msg_sem <thread_count>
 *
 * Note:     MacOS X (as of 10.6) doesn't have a working implementation
 *           of unnamed semaphores.  See pth_msg_sem_mac.c for an
 *           alternative implementation.
 *
 * IPP:      Section 4.7 (pp. 174 and ff.)
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>  /* Semaphores are not part of Pthreads */

const int MAX_THREADS = 1024;
const int MSG_MAX = 100;

/* Global variables:  accessible to all threads */
int thread_count;
char** messages;
sem_t* semaphores;

void Usage(char* prog_name);
void *Send_msg(void* rank);  /* Thread function */

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long       thread;
   pthread_t* thread_handles; 

   if (argc != 2) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   if (thread_count <= 0 || thread_count > MAX_THREADS) Usage(argv[0]);

   thread_handles = malloc (thread_count*sizeof(pthread_t));
   messages = malloc(thread_count*sizeof(char*));
   semaphores = malloc(thread_count*sizeof(sem_t));
   for (thread = 0; thread < thread_count; thread++) {
      messages[thread] = NULL;
      /* Initialize all semaphores to 0 -- i.e., locked */
      sem_init(&semaphores[thread], 0, 0);
   }

   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], (pthread_attr_t*) NULL,
          Send_msg, (void*) thread);

   for (thread = 0; thread < thread_count; thread++) {
      pthread_join(thread_handles[thread], NULL);
   }

   for (thread = 0; thread < thread_count; thread++) {
      free(messages[thread]);
      sem_destroy(&semaphores[thread]);
   }
   free(messages);
   free(semaphores);
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
 * Function:       Send_msg
 * Purpose:        Create a message and ``send'' it by copying it
 *                 into the global messages array.  Receive a message
 *                 and print it.
 * In arg:         rank
 * Global in:      thread_count
 * Global in/out:  messages, semaphores
 * Return val:     Ignored
 * Note:           The my_msg buffer is freed in main
 */
void *Send_msg(void* rank) {
   long my_rank = (long) rank;
   long dest = (my_rank + 1) % thread_count;
   char* my_msg = (char*) malloc(MSG_MAX*sizeof(char));

   sprintf(my_msg, "Hello to %ld from %ld", dest, my_rank);
   messages[dest] = my_msg;
   sem_post(&semaphores[dest]);  /* "Unlock" the semaphore of dest */

   sem_wait(&semaphores[my_rank]);  /* Wait for our semaphore to be unlocked */
   printf("Thread %ld > %s\n", my_rank, messages[my_rank]);

   return NULL;
}  /* Send_msg */
