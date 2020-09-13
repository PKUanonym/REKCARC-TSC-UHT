/* File:      prog5.2_omp_pi_monte_carlo.c
 * Purpose:   Estimate pi using OpenMP and a monte carlo method
 * 
 * Compile:   gcc -g -Wall -fopenmp -o prog5.2_omp_pi_monte_carlo 
 *                  prog5.2_omp_pi_monte_carlo.c my_rand.c
 *            *needs my_rand.c, my_rand.h
 *
 * Run:       ./prog5.2_omp_pi_monte_carlo <number of threads>
 *                  <number of tosses>
 *
 * Input:     None
 * Output:    Estimate of pi
 *
 * Note:      The estimated value of pi depends on both the number of 
 *            threads and the number of "tosses".  
 */

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "my_rand.h"

/* Serial function */
void Get_args(char* argv[], int* thread_count_p, 
      long long int* number_of_tosses_p);
void Usage(char* prog_name);

/* Parallel function */
long long int Count_hits(long long int number_of_tosses, int thread_count);

/*---------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   double pi_estimate;
   int thread_count;
   long long int number_in_circle;
   long long int number_of_tosses;
   
   if (argc != 3) Usage(argv[0]);
   Get_args(argv, &thread_count, &number_of_tosses);
   
   number_in_circle = Count_hits(number_of_tosses, thread_count);

   pi_estimate = 4*number_in_circle/((double) number_of_tosses);
   printf("Estimated pi: %e\n", pi_estimate);

   return 0;
}

/*---------------------------------------------------------------------
 * Function:      Count_hits
 * Purpose:       Calculate number of hits in the unit circle
 * In arg:        number_of_tosses, thread_count
 * Return val:    number_in_circle
 */

long long int Count_hits(long long int number_of_tosses, int thread_count) {

   long long int number_in_circle = 0;
   
#  pragma omp parallel num_threads(thread_count) \
      default(none) reduction(+: number_in_circle) \
      shared(number_of_tosses, thread_count)
   {
      int my_rank = omp_get_thread_num();
      unsigned seed = my_rank + 1;
      long long int toss;
      double x, y, distance_squared;

#     pragma omp for
      for(toss = 0; toss < number_of_tosses; toss++) {
         x = 2*my_drand(&seed) - 1;
         y = 2*my_drand(&seed) - 1;
         distance_squared = x*x + y*y;
         if (distance_squared <= 1) number_in_circle++;
#        ifdef DEBUG
         printf("Th %d > toss = %lld, x = %.3f, y = %.3f, dist = %.3f\n",
            my_rank, toss, x, y, distance_squared);
#        endif
      }
   }  /* pragma omp parallel */

#  ifdef DEBUG
   printf("Total number in circle = %lld\n", number_in_circle);
#  endif
   
   return number_in_circle;
}  /* Count_hits */

/*---------------------------------------------------------------------
 * Function:  Usage 
 * Purpose:   Print a message showing how to run program and quit
 * In arg:    prog_name:  the name of the program from the command line
 */

void Usage(char prog_name[] /* in */) {
   fprintf(stderr, "usage: %s ", prog_name); 
   fprintf(stderr, "<number of threads> <total number of tosses>\n");
   exit(0);
}  /* Usage */

/*------------------------------------------------------------------
 * Function:    Get_args
 * Purpose:     Get the command line args
 * In args:     argv
 * Out args:    thread_count_p, number_of_tosses_p
 */

void Get_args(
           char*           argv[]              /* in  */,
           int*            thread_count_p      /* out */,
           long long int*  number_of_tosses_p  /* out */) {
   
   *thread_count_p = strtol(argv[1], NULL, 10);  
   *number_of_tosses_p = strtoll(argv[2], NULL, 10);
}  /* Get_args */

