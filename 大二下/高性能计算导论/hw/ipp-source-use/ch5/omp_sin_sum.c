/* File:    omp_sin_sum.c
 * Purpose: Compute a sum in which each term is the value of a function
 *          applied to a nonnegative integer i and evaluation of the 
 *          function requires work proportional to i.
 *
 * Compile: gcc -g -Wall -fopenmp -I. -o omp_sin_sum omp_sin_sum.c
 * Usage:   ./omp_sin_sum <number of threads> <number of terms>
 *
 * Input:   none
 * Output:  sum of n terms and elapsed time to compute the sum
 *
 * Notes:
 * 1.  The computed sum is
 *
 *        sin(0) + sin(1) + . . . + sin(n(n+3)/2)
 *
 * 2.  The function f(i) is
 *
 *        sin(i(i+1)/2) + sin(i(i+1)/2 + 1) + . . . + sin(i(i+1)/2 + i)
 *
 * 3.  The parallel for directive uses a runtime schedule clause. So
 *     the environment variable OMP_SCHEDULE should be either 
 *     "static,n/thread_count" for a block schedule or "static,1" 
 *     for a cyclic schedule
 * 4.  Uses the OpenMP library function omp_get_wtime to take timings.
 * 5.  DEBUG flag will print which iterations were assigned to each
 *     thread.
 *
 * IPP:  Section 5.7 (pp. 236 and ff.)
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#ifdef DEBUG
int*    iterations;
#endif

void Usage(char* prog_name);
double Sum(long n, int thread_count);
double Check_sum(long n, int thread_count);
double f(long i);
void Print_iters(int iterations[], long n);

int main(int argc, char* argv[]) {
   double  global_result;        /* Store result in global_result */
   long    n;                    /* Number of terms               */
   int     thread_count;
   double  start, finish;
   double  error, check;

   if (argc != 3) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   n = strtol(argv[2], NULL, 10);
#  ifdef DEBUG
   iterations = malloc((n+1)*sizeof(int));
#  endif

   start = omp_get_wtime();
   global_result = Sum(n, thread_count);
   finish = omp_get_wtime();

   check = Check_sum(n, thread_count);
   error = fabs(global_result - check);

   printf("Result = %.14e\n", global_result);
   printf("Check = %.14e\n", check);
   printf("With n = %ld terms, the error is %.14e\n", n, error);
   printf("Elapsed time = %e seconds\n", finish-start);
#  ifdef DEBUG
   Print_iters(iterations, n);
   free(iterations);
#  endif

   return 0;
}  /* main */

/*--------------------------------------------------------------------
 * Function:    Usage
 * Purpose:     Print command line for function and terminate
 * In arg:      prog_name
 */
void Usage(char* prog_name) {

   fprintf(stderr, "usage: %s <number of threads> <number of terms>\n", 
         prog_name);
   exit(0);
}  /* Usage */

/*------------------------------------------------------------------
 * Function:    f
 * Purpose:     Compute value of function in which work is
 *              proportional to the size of the first arg.
 * Input arg:   i, n
 * Return val:  
 */
double f(long i) {
   long j;
   long start = i*(i+1)/2;
   long finish = start + i;
   double return_val = 0.0;

   for (j = start; j <= finish; j++) {
      return_val += sin(j);
   }
   return return_val;
}  /* f */

/*------------------------------------------------------------------
 * Function:    Sum
 * Purpose:     Find the sum of the terms f(0), f(1), . . ., f(n),
 *              where evaluating f requires work proportional to
 *              its argument
 * Input args:  
 *    n: number of terms
 *    thread_count:  number of threads
 * Return val:
 *    approx:  f(0) + f(1) + . . . + f(n)
 */
double Sum(long n, int thread_count) {
   double approx = 0.0;
   long i;

#  pragma omp parallel for num_threads(thread_count) \
      reduction(+: approx) schedule(runtime)
   for (i = 0; i <= n; i++) {
     approx += f(i);
#    ifdef DEBUG
     iterations[i] = omp_get_thread_num();
#    endif
   }

   return approx;
}  /* Sum */

/*------------------------------------------------------------------
 */
double Check_sum(long n, int thread_count) {
   long i;
   long finish = n*(n+3)/2;
   double check = 0.0;

#  pragma omp parallel for num_threads(thread_count) \
      default(none) shared(n, finish) private(i) \
      reduction(+: check)
   for (i = 0; i <= finish; i++) {
      check += sin(i);
   }
   return check;
}  /* Check_sum */

/*------------------------------------------------------------------
 * Function:  Print_iters
 * Purpose:   Print which thread was assigned which iteration.
 * Input args:  
 *    iterations:  iterations[i] = thread assigned iteration i
 *    n:           size of iterations array
 */
void Print_iters(int iterations[], long n) {
   int i, start_iter, stop_iter, which_thread;

   printf("\n");
   printf("Thread\t\tIterations\n");
   printf("------\t\t----------\n");
   which_thread = iterations[0];
   start_iter = stop_iter = 0;
   for (i = 0; i <= n; i++)
      if (iterations[i] == which_thread)
         stop_iter = i;
      else {
         printf("%4d  \t\t%d -- %d\n", which_thread, start_iter,
               stop_iter);
         which_thread = iterations[i];
         start_iter = stop_iter = i;
      }
   printf("%4d  \t\t%d -- %d\n", which_thread, start_iter,
               stop_iter);
}  /* Print_iters */
