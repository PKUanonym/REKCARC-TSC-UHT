/* File:      prog4.2_pth_pi_monte_carlo.c
 * Purpose:   Estimate pi using pthreads and monte carlo method
 * 
 * Compile:   gcc -g -Wall -o prog4.2_pth_pi_monte_carlo 
 *		   prog4.2_pth_pi_monte_carlo.c my_rand.c -lpthread
 *	      needs my_rand.c, my_rand.h
 * Run:       ./prog4.2_pth_pi_monte_carlo <number of threads>
 *		   <number of tosses>
 * Input:     None
 * Output:    Estimate of pi
 *
 * Note:      The estimated value of pi depends on both the number of 
 *            threads and the number of "tosses".  
 *
 * IPP:       Programming assignment 4.2
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "my_rand.h"


/* Global variables */
int thread_count;
long long int number_in_circle = 0;
long long int number_of_tosses;

/* mutex */
pthread_mutex_t mutex;

/* Serial function */
void Get_args(int argc, char* argv[]);
void Usage(char* prog_name);

/* Parallel function */
void *Thread_work(void* rank);

/*---------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
	long thread;
	pthread_t* thread_handles;
	double pi_estimate;
	
	if (argc != 3) Usage(argv[0]);
	Get_args(argc, argv);
	
	thread_handles = malloc(thread_count*sizeof(pthread_t));
	pthread_mutex_init(&mutex, NULL);
	
	for(thread = 0; thread < thread_count; thread++) {
		pthread_create(&thread_handles[thread], NULL, 
                      Thread_work, (void*) thread);
	}
		
	for(thread = 0; thread < thread_count; thread++) {
		pthread_join(thread_handles[thread], NULL);
	}
	
	pi_estimate = 4*number_in_circle/((double) number_of_tosses);
	printf("Estimated pi: %e\n", pi_estimate);

	pthread_mutex_destroy(&mutex);
	return 0;
}

/*---------------------------------------------------------------------
 * Function:		Thread_work 
 * Purpose:		Calculate number in circle using monte carlo method
 * In arg:		rank
 * Global in vars:	number_of_tosses, thread_count
 * Global out vars:	number_in_circle
 */

void *Thread_work(void* rank) {
	long my_rank = (long) rank;
	long long int toss;
	long long int local_number_in_circle = 0;
	long long int local_tosses = number_of_tosses/thread_count;
	long long int start = local_tosses*my_rank;
	long long int finish = start+local_tosses;
	double x, y, distance_squared;
        unsigned seed = my_rank+1;  /* must be nonzero */
	
	for(toss = start; toss < finish; toss++) {
		x = 2*my_drand(&seed) - 1;
		y = 2*my_drand(&seed) - 1;
		distance_squared = x*x + y*y;
#               ifdef DEBUG
                printf("Th %ld > x = %f, y = %f, dist = %f\n", my_rank,
                   x, y, distance_squared);
#               endif
		if (distance_squared <= 1)
			local_number_in_circle++;
	}

#       ifdef DEBUG
        printf("Th %ld > in circle = %lld\n", my_rank,
              local_number_in_circle);
#       endif
	pthread_mutex_lock(&mutex);
	number_in_circle += local_number_in_circle;
	pthread_mutex_unlock(&mutex);
	
	return NULL;
}

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
 * In args:     argc, argv
 * Globals out: thread_count, n
 */

void Get_args(int argc, char* argv[]) {
	thread_count = strtol(argv[1], NULL, 10);  
	number_of_tosses = strtoll(argv[2], NULL, 10);
}  /* Get_args */

