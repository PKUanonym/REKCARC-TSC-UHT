/* File:  
 *    pth_cond_bar.c
 *
 * Purpose:
 *    Use condition wait barriers to synchronize threads.
 *
 * Compile:
 *    gcc -g -Wall -o pth_cond_bar pth_cond_bar.c -lpthread
 *    timer.h must be available
 *
 * Usage:
 *    ./pth_cond_bar <thread_count>
 *
 * Input:
 *    none
 * Output:
 *    Time for BARRIER_COUNT barriers
 *
 * Note:    
 *    Verbose output can be enabled with the compile flag -DDEBUG
 *
 * IPP:   Section 4.8.3 (pp. 179 and ff.)
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "timer.h"

#define BARRIER_COUNT 100

int thread_count;
int barrier_thread_count = 0;
pthread_mutex_t barrier_mutex;
pthread_cond_t ok_to_proceed;

void Usage(char* prog_name);
void *Thread_work(void* rank);

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long       thread;
   pthread_t* thread_handles; 
   double start, finish;

   if (argc != 2)
      Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);

   thread_handles = malloc (thread_count*sizeof(pthread_t));
   pthread_mutex_init(&barrier_mutex, NULL);
   pthread_cond_init(&ok_to_proceed, NULL);

   GET_TIME(start);
   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], NULL,
          Thread_work, (void*) thread);

   for (thread = 0; thread < thread_count; thread++) {
      pthread_join(thread_handles[thread], NULL);
   }
   GET_TIME(finish);
   printf("Elapsed time = %e seconds\n", finish - start);

   pthread_mutex_destroy(&barrier_mutex);
   pthread_cond_destroy(&ok_to_proceed);
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
 * Function:    Thread_work
 * Purpose:     Run BARRIER_COUNT barriers
 * In arg:      rank
 * Global var:  thread_count, barrier_thread_count, barrier_mutex,
 *              ok_to_proceed
 * Return val:  Ignored
 */
void *Thread_work(void* rank) {
#  ifdef DEBUG
   long my_rank = (long) rank; 
#  endif
   int i;

   for (i = 0; i < BARRIER_COUNT; i++) {
      pthread_mutex_lock(&barrier_mutex);
      barrier_thread_count++;
      if (barrier_thread_count == thread_count) {
         barrier_thread_count = 0;
#        ifdef DEBUG
         printf("Thread %ld > Signalling other threads in barrier %d\n", 
               my_rank, i);
         fflush(stdout);
#        endif
         pthread_cond_broadcast(&ok_to_proceed);
      } else {
         // Wait unlocks mutex and puts thread to sleep.
         //    Put wait in while loop in case some other
         // event awakens thread.
         while (pthread_cond_wait(&ok_to_proceed,
                   &barrier_mutex) != 0);
         // Mutex is relocked at this point.
#        ifdef DEBUG
         printf("Thread %ld > Awakened in barrier %d\n", my_rank, i);
         fflush(stdout);
#        endif
      }
      pthread_mutex_unlock(&barrier_mutex);
#     ifdef DEBUG
      if (my_rank == 0) {
         printf("All threads completed barrier %d\n", i);
         fflush(stdout);
      }
#     endif
   }

   return NULL;
}  /* Thread_work */
