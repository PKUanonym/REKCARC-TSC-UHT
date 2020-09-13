/* File:     omp_fibo.c
 *
 * Purpose:  Try to compute n Fibonacci numbers using OpenMP.  Show 
 *           what happens if we try to parallelize a loop
 *           with dependences among the iterations.  The program
 *           has a serious bug.
 *
 * Compile:  gcc -g -Wall -fopenmp -o omp_fibo omp_fibo.c 
 * Run:      ./omp_fibo <number of threads> <number of Fibonacci numbers>
 *
 * Input:    none
 * Output:   A list of Fibonacci numbers
 *
 * Note:     If your output seems to be OK, try increasing the number of
 *           threads and/or n.
 *
 * IPP:      Section 5.5.2 (pp. 227 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

void Usage(char prog_name[]);

int main(int argc, char* argv[]) {
   int thread_count, n, i;
   long long* fibo;

   if (argc != 3) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   n = strtol(argv[2], NULL, 10);

   fibo = malloc(n*sizeof(long long));
   fibo[0] = fibo[1] = 1;
#  pragma omp parallel for num_threads(thread_count)
   for (i = 2; i < n; i++)
      fibo[i] = fibo[i-1] + fibo[i-2];

   printf("The first n Fibonacci numbers:\n");
   for (i = 0; i < n; i++)
      printf("%d\t%lld\n", i, fibo[i]);

   free(fibo);
   return 0;
}  /* main */

void Usage(char prog_name[]) {
   fprintf(stderr, "usage:  %s <thread count> <number of Fibonacci numbers>\n",
         prog_name);
   exit(0);
}  /* Usage */
