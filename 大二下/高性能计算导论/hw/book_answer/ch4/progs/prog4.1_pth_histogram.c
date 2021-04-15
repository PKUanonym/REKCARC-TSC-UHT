/* File:      prog4.1_pth_histogram.c
 *
 * Purpose:   Build a histogram from some random data using pthreads.
 *            This is a modified version of the program histogram.c
 * 
 * Compile:   gcc -g -Wall -o prog4.1_pth_histogram prog4.1_pth_histogram.c 
 *                  -lpthread
 * Run:       ./histogram <number of thread> <bin_count> 
 *            <min_meas> <max_meas> <data_count>
 *
 * Input:     None
 * Output:    A histogram with X's showing the number of measurements
 *            in each bin
 *
 * Notes:
 * 1.  Actual measurements y are in the range min_meas <= y < max_meas
 * 2.  bin_counts[i] stores the number of measurements x in the range
 *     bin_maxes[i-1] <= x < bin_maxes[i] (bin_maxes[-1] = min_meas)
 * 3.  DEBUG compile flag gives verbose output
 * 4.  The program will terminate if either the number of command line
 *     arguments is incorrect or if the search for a bin for a 
 *     measurement fails.
 *
 * IPP:  Programming assignment 4.1
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include "timer.h"

/* Global variables */
int thread_count;
int data_count, bin_count;
int* bin_counts;
int* loc_bin_counts;
float min_meas;
float *bin_maxes, *data;
pthread_mutex_t bar_mutex;
pthread_cond_t bar_cond;
int bar_count = 0;


/* Serial functions */
void Usage(char prog_name[]);
void Get_args(char* argv[], float* max_meas_p);
void Gen_data(float max_meas);
void Gen_bins(float max_meas);
int Which_bin(float data);
void Print_histo(void);

/* Parallel functions */
void *Thread_work(void* rank);
void Barrier(void);
           
/*---------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long thread;
   pthread_t* thread_handles;
   float max_meas;

   /* Check and get command line args */
   if (argc != 6) Usage(argv[0]); 
   Get_args(argv, &max_meas);

   /* Allocate arrays needed */
   bin_maxes = malloc(bin_count*sizeof(float));
   bin_counts = malloc(bin_count*sizeof(int));
   loc_bin_counts = malloc(thread_count*bin_count*sizeof(int));
   data = malloc(data_count*sizeof(float));
   
   /* Generate the data */
   Gen_data(max_meas);
   
   /* Create bins for storing counts */
   Gen_bins(max_meas);
   memset(loc_bin_counts, 0, thread_count*bin_count*sizeof(int));

   /* Allocate storage for thread handles. */
   thread_handles = malloc(thread_count*sizeof(pthread_t));
   
   /* Initialize the mutex and condition variable */
   pthread_mutex_init(&bar_mutex, NULL);
   pthread_cond_init(&bar_cond, NULL);

   /* Start the threads */
   for(thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], NULL, Thread_work, 
                      (void*) thread);
   
   /* Wait for threads to complete */
   for(thread = 0; thread < thread_count; thread++)
      pthread_join(thread_handles[thread], NULL);

#  ifdef DEBUG
   int i;
   printf("bin_counts = ");
   for (i = 0; i < bin_count; i++)
      printf("%d ", bin_counts[i]);
   printf("\n");
#  endif
      
   /* Print the histogram */
   Print_histo();

   free(data);
   free(bin_maxes);
   free(bin_counts);
   pthread_mutex_destroy(&bar_mutex);
   pthread_cond_destroy(&bar_cond);
   return 0;

}  /* main */

/*---------------------------------------------------------------------
 * Function:      Thread_work 
 * Purpose:      Determine which bin a measurement belongs to and
 *         count number of values in each bin in parallel
 * In arg:      rank: rank of thread
 * Global in vars:   thread_count: number of threads
 *         data_count: number of measurements
 *         data:the actual measurements
 * Global out vars:   bin_counts: the number of element in each bin
 */

void *Thread_work(void* rank) {
   long my_rank = (long) rank;
   int i, j, bin, start, finish, offset = my_rank*bin_count;
   
   /* Calculate amount of work in data for each thread */
   Get_my_start_finish(my_rank, data_count, thread_count, &start, & finish);
   
   /* Count number of values in each bin */
   for (i = start; i < finish; i++) {
      bin = Which_bin(data[i]);
      loc_bin_counts[bin]++;
   }

   /* Calculate number of bins each thread should sum */
   Get_my_start_finish(my_rank, bin_count, thread_count, &start, &finish);
   for (i = start; i < finish; i++)
      for (j = 0; j < thread_work; j++)
         bin_counts[i] += loc_bin_counts[j*bin_counts + i];
   
   return NULL;
}  /* Thread_work */

/*---------------------------------------------------------------------
 * Function:  Get_my_start_finish
 * Purpose:   Determine which elements are assigned to this thread
 *            in a block partition
 * In args:   my_rank, thread_count
 *            count:  number of elements being partitioned
 * Out args:  start_p:  my first element
 *            finish_p:  my last element
 */
void Get_my_start_finish(long my_rank, int count, int thread_count,
      int* start_p, int* finish_p) {

   int loc_count = count / thread_count;
   int fraction = count % thread_count;

   if (my_rank < fraction) {
      start = (loc_count+1) * my_rank;
      finish = start + 1 + loc_count;
   } else {
      start = ((loc_count+1)*fraction)+
                    ((my_rank-fraction)*loc_count);
      finish = start + loc_count;
   }
}  /* Get_my_start_finish */


/*---------------------------------------------------------------------
 * Function:  Usage 
 * Purpose:   Print a message showing how to run program and quit
 * In arg:    prog_name:  the name of the program from the command line
 */
void Usage(char prog_name[] /* in */) {
   fprintf(stderr, "usage: %s ", prog_name); 
   fprintf(stderr, "<number of threads> ");
   fprintf(stderr, "<bin_count> <min_meas> <max_meas> <data_count>\n");
   exit(0);
}  /* Usage */


/*---------------------------------------------------------------------
 * Function:       Get_args
 * Purpose:       Get the command line arguments
 * In arg:       argv:  strings from command line
 * Out args:       max_meas_p:   maximum measurement
 * Global out vars: thread_count: number of threads
 *          bin_count: number of bins
 *          min_meas: minimum measurement
 *          data_count:   number of measurements
 */
void Get_args(char* argv[], float* max_meas_p) {
   thread_count = strtol(argv[1], NULL, 10);
   bin_count = strtol(argv[2], NULL, 10);
   min_meas = strtof(argv[3], NULL);
   *max_meas_p = strtof(argv[4], NULL);
   data_count = strtol(argv[5], NULL, 10);

#   ifdef DEBUG
   printf("thread_count = %d\n", thread_count);
   printf("bin_count = %d\n", bin_count);
   printf("min_meas = %f, max_meas = %f\n", min_meas, *max_meas_p);
   printf("data_count = %d\n", data_count);
#   endif
}  /* Get_args */


/*---------------------------------------------------------------------
 * Function:      Gen_data
 * Purpose:      Generate random floats in the range min_meas <= 
 *                         x < max_meas
 * In args:      max_meas:    the maximum possible value for the data
 * Global in vars:   min_meas:    the minimum possible value for the data
 *         data_count:  the number of measurements
 * Global out vars:   data:   the actual measurements
 */
void Gen_data(float max_meas) {
   int i;

   srandom(0);
   for (i = 0; i < data_count; i++)
      data[i] = min_meas + (max_meas - min_meas)*random()/((double) RAND_MAX);

#  ifdef DEBUG
   printf("data = ");
   for (i = 0; i < data_count; i++)
      printf("%4.3f ", data[i]);
   printf("\n");
#  endif
}  /* Gen_data */


/*---------------------------------------------------------------------
 * Function:      Gen_bins
 * Purpose:           Compute max value for each bin, and store 0 as the
 *         number of values in each bin
 * In args:      max_meas:   the maximum possible measurement
 * Global in vars:   bin_count:  the number of bins
 *         min_meas:   the minimum possible measurement
 * Global out vars:   bin_maxes:  the maximum possible value for each bin
 *         bin_counts: the number of data values in each bin
 */
void Gen_bins(float max_meas) {
   float bin_width;
   int   i;

   bin_width = (max_meas - min_meas)/bin_count;

   for (i = 0; i < bin_count; i++) {
      bin_maxes[i] = min_meas + (i+1)*bin_width;
      bin_counts[i] = 0;
   }

#  ifdef DEBUG
   printf("bin_maxes = ");
   for (i = 0; i < bin_count; i++)
      printf("%4.3f ", bin_maxes[i]);
   printf("\n");
#  endif
}  /* Gen_bins */


/*---------------------------------------------------------------------
 * Function:      Which_bin
 * Purpose:      Use binary search to determine which bin a measurement 
 *            belongs to
 * Global in vars:   data: the current measurement
 *         bin_maxes:  list of max bin values
 *         bin_count:  number of bins
 *         min_meas:   the minimum possible measurement
 * Return:      the number of the bin to which data belongs
 * Notes:      
 * 1.  The bin to which data belongs satisfies
 *
 *            bin_maxes[i-1] <= data < bin_maxes[i] 
 *
 *     where, bin_maxes[-1] = min_meas
 * 2.  If the search fails, the function prints a message and exits
 */
int Which_bin(float data/* in */) {
   int bottom = 0, top =  bin_count-1;
   int mid;
   float bin_max, bin_min;

   while (bottom <= top) {
      mid = (bottom + top)/2;
      bin_max = bin_maxes[mid];
      bin_min = (mid == 0) ? min_meas: bin_maxes[mid-1];
      if (data >= bin_max) 
         bottom = mid+1;
      else if (data < bin_min)
         top = mid-1;
      else
         return mid;
   }

   /* Whoops! */
   fprintf(stderr, "Data = %f doesn't belong to a bin!\n", data);
   fprintf(stderr, "Quitting\n");
   exit(-1);
}  /* Which_bin */


/*---------------------------------------------------------------------
 * Function:      Print_histo
 * Purpose:      Print a histogram.  The number of elements in each
 *         bin is shown by an array of X's.
 * In args:      bin_maxes:   the max value for each bin
 * Global in vars:   bin_counts:  the number of elements in each bin
 *         bin_count:   the number of bins
 *         min_meas:    the minimum possible measurment 
 */
void Print_histo(void) {
   int i, j;
   float bin_max, bin_min;

   for (i = 0; i < bin_count; i++) {
      bin_max = bin_maxes[i];
      bin_min = (i == 0) ? min_meas: bin_maxes[i-1];
      printf("%.3f-%.3f:\t", bin_min, bin_max);
      for (j = 0; j < bin_counts[i]; j++)
         printf("X");
      printf("\n");
   }
}  /* Print_histo */


/*---------------------------------------------------------------------
 * Function:  Barrier
 * Purpose:   Block threads until all have arrived at this point
 */
void Barrier(void) {
   pthread_mutex_lock(&bar_mutex);
   if (bar_count == thread_count - 1) {
      bar_count = 0;
      pthread_cond_broadcast(&bar_cond);
   } else {
      while (pthread_cond_wait(&bar_cond, &bar_mutex) != 0);
   }
   pthread_mutex_unlock(&bar_mutex);
}  /* Barrier */
