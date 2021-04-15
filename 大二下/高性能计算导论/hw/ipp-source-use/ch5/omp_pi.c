/* File:     omp_pi.c
 * Purpose:  Estimate pi using OpenMP and the formula
 *
 *              pi = 4*[1 - 1/3 + 1/5 - 1/7 + 1/9 - . . . ]
 *
 * Compile:  gcc -g -Wall -fopenmp -o omp_pi omp_pi.c -lm              
 * Run:      omp_pi <thread_count> <n>
 *           thread_count is the number of threads
 *           n is the number of terms of the series to use
 *
 * Input:    none            
 * Output:   The estimate of pi and the value of pi computed by the
 *           arctan function in the math library
 *
 * Notes:
 *    1.  The radius of convergence is only 1.  So the series converges
 *        *very* slowly.
 *
 * IPP:   Section 5.5.4 (pp. 229 and ff.)
 */        

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h> 

void Usage(char* prog_name);

int main(int argc, char* argv[]) {
   long long n, i;
   int thread_count;
   double factor;
   double sum = 0.0;

   if (argc != 3) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   n = strtoll(argv[2], NULL, 10);
   if (thread_count < 1 || n < 1) Usage(argv[0]);

#  pragma omp parallel for num_threads(thread_count) \
      reduction(+: sum) private(factor)
   for (i = 0; i < n; i++) {
      factor = (i % 2 == 0) ? 1.0 : -1.0; 
      sum += factor/(2*i+1);
#     ifdef DEBUG
      printf("Thread %d > i = %lld, my_sum = %f\n", my_rank, i, my_sum);
#     endif
   }

   sum = 4.0*sum;
   printf("With n = %lld terms and %d threads,\n", n, thread_count);
   printf("   Our estimate of pi = %.14f\n", sum);
   printf("                   pi = %.14f\n", 4.0*atan(1.0));
   return 0;
}  /* main */

/*------------------------------------------------------------------
 * Function:  Usage
 * Purpose:   Print a message explaining how to run the program
 * In arg:    prog_name
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage: %s <thread_count> <n>\n", prog_name);  /* Change */
   fprintf(stderr, "   thread_count is the number of threads >= 1\n");  /* Change */
   fprintf(stderr, "   n is the number of terms and should be >= 1\n");
   exit(0);
}  /* Usage */
