/* File:      ex5.10_omp_atomic.c
 * Purpose:   Determine whether several atomic directives in OpenMP
 *            are treated as a single critical section
 *
 * Compile:   gcc -g -Wall -fopenmp -o ex5.10_omp_atomic 
 *                  ex5.10_omp_atomic.c -lm
 * Run:       ./ex5.10_omp_atomic <thread_count> <n>
 *
 * Input:     None
 * Output:    Parallel runtime
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

void Usage(char prog_name[]);

int main(int argc, char* argv[]) {
   int thread_count, n;
   double start, finish;
   
   if (argc != 3) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   n = strtol(argv[2], NULL, 10);
   
   start = omp_get_wtime();
#  pragma omp parallel num_threads(thread_count)
   {
      int i;
      double my_sum = 0.0;
      
      for(i = 0; i < n; i++) {
#        pragma omp atomic
         my_sum += sin(i);
      }
#     ifdef DEBUG
      printf("my_sum = %f\n", my_sum);
#     endif
   }
   finish = omp_get_wtime();

   printf("Thread_count = %d, n = %d, Time = %e seconds\n", 
         thread_count, n, finish-start);
   return 0;
}  /* main */

/*---------------------------------------------------------------------
 * Function:  Usage 
 * Purpose:   Print a message showing how to run program and quit
 * In arg:    prog_name:  the name of the program from the command line
 */

void Usage(char prog_name[]) {
   fprintf(stderr, "usage: %s <thread_count> <n>\n", prog_name);
   exit(0);
}  /* Usage */

