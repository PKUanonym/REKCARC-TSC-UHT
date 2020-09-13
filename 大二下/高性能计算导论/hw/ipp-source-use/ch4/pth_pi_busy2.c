/* File:     pth_pi_busy2.c
 * Purpose:  Estimate pi using the series
 *
 *              pi = 4*[1 - 1/3 + 1/5 - 1/7 + 1/9 - . . . ]
 *
 *           This is the second version that uses busy-waiting.  The
 *           critical section now follows the main loop.
 *
 * Compile:  gcc -g -Wall -o pth_pi_busy2 pth_pi_busy2.c -lm -lpthread
 *           Note the header file timer.h needs to be available
 * Run:      ./pth_pi_busy2 <number of threads> <n>
 *           n is the number of terms of the Maclaurin series to use
 *           n should be evenly divisible by the number of threads
 *
 * Input:    none
 * Output:   Estimate of pi as computed by multiple threads, estimate
 *           as computed by one threads, and 4*arctan(1).
 *           This version also prints the elapsed time required for
 *           the multi-threaded and single-threaded calculations.
 *
 * Notes:
 *    1.  The radius of convergence for the series is only 1.  So the 
 *        series converges quite slowly.
 *    2.  This version is likely to become buggy with compiler optimization
 *        turned on.
 *
 * IPP:   Section 4.5 (p. 168)
 */        

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>
#include "timer.h"

const int MAX_THREADS = 1024;

long thread_count;
long long n;
int flag;
double sum;

void* Thread_sum(void* rank);

/* Only executed by main thread */
void Get_args(int argc, char* argv[]);
void Usage(char* prog_name);
double Serial_pi(long long n);

int main(int argc, char* argv[]) {
   long       thread;  /* Use long in case of a 64-bit system */
   pthread_t* thread_handles;
   double start, finish, elapsed;

   /* Get number of threads and number of terms from command line */
   Get_args(argc, argv);

   thread_handles = (pthread_t*) malloc (thread_count*sizeof(pthread_t)); 
   
   GET_TIME(start);
   sum = 0.0;
   flag = 0;
   for (thread = 0; thread < thread_count; thread++)  
      pthread_create(&thread_handles[thread], NULL,
          Thread_sum, (void*)thread);  

   for (thread = 0; thread < thread_count; thread++) 
      pthread_join(thread_handles[thread], NULL); 
   GET_TIME(finish);
   elapsed = finish - start;

   sum = 4.0*sum;
   printf("With n = %lld terms,\n", n);
   printf("   Multi-threaded estimate of pi  = %.15f\n", sum);
   printf("   Elapsed time = %e seconds\n", elapsed);

   GET_TIME(start);
   sum = Serial_pi(n);
   GET_TIME(finish)
   elapsed = finish - start;
   printf("   Single-threaded estimate of pi = %.15f\n", sum);
   printf("   Elapsed time = %e seconds\n", elapsed);
   printf("   Math library estimate of pi    = %.15f\n", 
       4.0*atan(1.0));
   
   free(thread_handles);
   return 0;
}  /* main */

/*------------------------------------------------------------------
 * Function:       Thread_sum
 * Purpose:        Add in the terms computed by the thread running this 
 * In arg:         rank
 * Ret val:        ignored
 * Globals in:     n, thread_count
 * Global in/out:  sum 
 */
void* Thread_sum(void* rank) {
   long my_rank = (long) rank;
   double factor, my_sum = 0.0;
   long long i;
   long long my_n = n/thread_count;
   long long my_first_i = my_n*my_rank;
   long long my_last_i = my_first_i + my_n;

   if (my_first_i % 2 == 0)
      factor = 1.0;
   else
      factor = -1.0;

   for (i = my_first_i; i < my_last_i; i++, factor = -factor) 
      my_sum += factor/(2*i+1);  
   
   while (flag != my_rank);
   sum += my_sum;  
   flag = (flag+1) % thread_count;

   return NULL;
}  /* Thread_sum */

/*------------------------------------------------------------------
 * Function:   Serial_pi
 * Purpose:    Estimate pi using 1 thread
 * In arg:     n
 * Return val: Estimate of pi using n terms of Maclaurin series
 */
double Serial_pi(long long n) {
   double sum = 0.0;
   long long i;
   double factor = 1.0;

   for (i = 0; i < n; i++, factor = -factor) {
      sum += factor/(2*i+1);
   }
   return 4.0*sum;

}  /* Serial_pi */

/*------------------------------------------------------------------
 * Function:    Get_args
 * Purpose:     Get the command line args
 * In args:     argc, argv
 * Globals out: thread_count, n
 */
void Get_args(int argc, char* argv[]) {
   if (argc != 3) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);  
   if (thread_count <= 0 || thread_count > MAX_THREADS) Usage(argv[0]);
   n = strtoll(argv[2], NULL, 10);
   if (n <= 0) Usage(argv[0]);
}  /* Get_args */

/*------------------------------------------------------------------
 * Function:  Usage
 * Purpose:   Print a message explaining how to run the program
 * In arg:    prog_name
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage: %s <number of threads> <n>\n", prog_name);
   fprintf(stderr, "   n is the number of terms and should be >= 1\n");
   fprintf(stderr, "   n should be evenly divisible by the number of threads\n");
   exit(0);
}  /* Usage */
