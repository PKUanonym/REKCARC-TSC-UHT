/* File:     pth_do_nothing.c
 * Purpose:  Estimate the overhead associated with starting threads.
 *
 * Compile:  gcc -g -Wall -o pth_do_nothing pth_do_nothing.c -lpthreads
 *           timer.h needs to be available
 * Run:      ./pth_do_nothing <number of threads>
 *
 * Input:    None
 * Output:   Time elapsed from starting first thread to joining
 *           last.
 *
 * IPP:      Section 4.5 (pp. 167 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "timer.h"

const int MAX_THREADS = 1024;


/* Thread function */
void *Thread_function(void* ignore);

/* No use of shared variables */
void Usage(char* prog_name);

int main(int argc, char* argv[]) {
   int        thread_count;
   long       thread;  /* Use long in case of a 64-bit system */
   pthread_t* thread_handles;
   double start, finish, elapsed;

   /* Get number of threads from command line */
   if (argc != 2) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);  
   if (thread_count <= 0 || thread_count > MAX_THREADS) Usage(argv[0]);

   thread_handles = (pthread_t*) malloc (thread_count*sizeof(pthread_t)); 

   GET_TIME(start);
   for (thread = 0; thread < thread_count; thread++)  
      pthread_create(&thread_handles[thread], NULL,
          Thread_function, NULL);  

   for (thread = 0; thread < thread_count; thread++) 
      pthread_join(thread_handles[thread], NULL); 
   GET_TIME(finish);
   elapsed = finish - start;

   printf("The elapsed time is %e seconds\n", elapsed);

   free(thread_handles);
   return 0;
}  /* main */

/*-------------------------------------------------------------------*/
void Usage(char* prog_name) {
   fprintf(stderr, "usage: %s <number of threads>\n", prog_name);
   fprintf(stderr, "0 < number of threads <= %d\n", MAX_THREADS);
   exit(0);
}  /* Usage */

/*-------------------------------------------------------------------*/
void* Thread_function(void* ignore) {
   return NULL;
}  /* Thread_function */
