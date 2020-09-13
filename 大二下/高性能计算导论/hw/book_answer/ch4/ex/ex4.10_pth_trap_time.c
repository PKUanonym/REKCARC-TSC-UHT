/* File:     ex4.10_pth_trap_time.c
 *            
 * Purpose:  Compute a definite integral using the
 *           trapezoidal rule and Pthreads. This is a modified
 *           version of the solution to programming assignment 
 *           4.3, prog4.3_pth_trap.c
 *
 * Input:    a, b, n
 * Output:   Estimate of the integral from a to b of f(x)
 *           using the trapezoidal rule and n trapezoids.
 *
 * Compile:  gcc -g -Wall -o prog4.3_pth_trap prog4.3_pth_trap.c -lpthread
 * Usage:    ./prog4.3pth_trap <number of threads> <method>
 *
 * Algorithm:
 *    1.  Each thread calculates "its" interval of
 *        integration.
 *    2.  Each thread estimates the integral of f(x)
 *        over its interval using the trapezoidal rule.
 *    3.  Each thread adds in its calculation into the
 *        the global total
 *    4.  main prints result and elapsed time
 *
 * Note:  
 *    1.  f(x) is hardwired
 *    2.  Assumes the number of threads evenly divides the number of
 *        trapezoids.
 *    3.  method 1 (default): uses mutex
 *        method 2: uses semaphore
 *        method 3: uses busy-wait
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include "timer.h"

/* The global variables are shared among all the threads. */
int     thread_count;
double  a, b, h;
int     n, local_n;
int     method;

/* Critical section lock variables */
int flag;
sem_t sem;
pthread_mutex_t mutex;
pthread_mutex_t time_mutex;


/* For timing */
double  total;
double  elapsed;
pthread_barrier_t barrier_p;

void *Thread_work(void* rank);
double Trap(double local_a, double local_b, int local_n,
         double h);    /* Calculate local integral  */
double f(double x); /* function we're integrating */

/*--------------------------------------------------------------*/
int main(int argc, char** argv) {
   long        i;
   pthread_t*  thread_handles;  
   
   total = 0.0;
   if (argc != 3) {
      fprintf(stderr, "usage: %s <number of threads> <method>\n", argv[0]);
      exit(0);
   }
   thread_count = strtol(argv[1], NULL, 10);
   method = strtol(argv[2], NULL, 10);
   
   printf("Enter a, b, n\n");
   scanf("%lf %lf %d", &a, &b, &n);
   h = (b-a)/n;
   local_n = n/thread_count;
   
   /* Allocate storage for thread handles. */
   thread_handles = malloc (thread_count*sizeof(pthread_t));
   
   /* Initialize the mutex, semaphore, busy-wait */
   flag = 0;
   pthread_mutex_init(&mutex, NULL);
   pthread_mutex_init(&time_mutex, NULL);
   pthread_barrier_init(&barrier_p, NULL, thread_count);
   sem_init(&sem, 0, 1);
   
    /* Start the threads. */
   for (i = 0; i < thread_count; i++) {
      pthread_create(&thread_handles[i], NULL, Thread_work, 
                  (void*) i);
   }
   
   /* Wait for threads to complete. */
   for (i = 0; i < thread_count; i++) {
      pthread_join(thread_handles[i], NULL);
   }
   
   printf("With n = %d trapezoids, our estimate\n",
         n);
   printf("of the integral from %f to %f = %19.15e\n",
         a, b, total);
   
   printf("Elasped time is %e\n", elapsed);
   
   pthread_barrier_destroy(&barrier_p);
   pthread_mutex_destroy(&time_mutex);
   pthread_mutex_destroy(&mutex);
   sem_destroy(&sem);
   free(thread_handles);
   
   return 0;
} /*  main  */

/*--------------------------------------------------------------*/
void *Thread_work(void* rank) {
   double      local_a;   /* Left endpoint my thread   */
   double      local_b;   /* Right endpoint my thread  */
   double      my_int;    /* Integral over my interval */
   long        my_rank = (long) rank;
   double start, finish, my_elapsed;
   /* Length of each process' interval of integration = */
   /* local_n*h.  So my interval starts at:             */
   local_a = a + my_rank*local_n*h;
   local_b = local_a + local_n*h;
   
   pthread_barrier_wait(&barrier_p);
   GET_TIME(start);
   my_int = Trap(local_a, local_b, local_n, h);

   switch (method) {
      case 2:
         sem_wait(&sem);
         total += my_int;
         sem_post(&sem);
         break;
      case 3:
         while(flag != my_rank);
         total += my_int;
         flag = (flag+1) % thread_count;
         break;
      default:
         pthread_mutex_lock(&mutex);
         total += my_int;
         pthread_mutex_unlock(&mutex);
         break;
   }

   GET_TIME(finish);
   my_elapsed = finish - start;
   
   pthread_mutex_lock(&time_mutex);
   if(my_elapsed > elapsed) elapsed = my_elapsed;
   pthread_mutex_unlock(&time_mutex);

   return NULL;
   
}  /* Thread_work */

/*--------------------------------------------------------------*/
double Trap(
         double  local_a   /* in */,
         double  local_b   /* in */,
         int     local_n   /* in */,
         double  h         /* in */) {
   
    double integral;   /* Store result in integral  */
    double x;
    int i;
   
    integral = (f(local_a) + f(local_b))/2.0;
    x = local_a;
    for (i = 1; i <= local_n-1; i++) {
        x = local_a + i*h;
        integral += f(x);
    }
    integral = integral*h;
    return integral;
} /*  Trap  */


/*--------------------------------------------------------------*/
double f(double x) {
    double return_val;
   
    return_val = x*x;
    return return_val;
} /* f */
