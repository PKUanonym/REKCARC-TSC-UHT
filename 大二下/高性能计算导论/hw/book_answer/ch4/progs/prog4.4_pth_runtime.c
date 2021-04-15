/* File:     prog4.4_pth_runtime.c
 *
 * Purpose:  Find  the average time the system uses to create and
 *			 terminate a thread
 * 
 * Compile:  gcc -g -Wall -o prog4.4_pth_runtime 
 *           prog4.4_pth_runtime.c -lpthread
 *           needs timer.h
 * Usage:    ./prog4.4_pth_runtime <number of threads>
 * Input:    number of threads to create and terminate
 * Output:   Elapsed average runtime
 *
 * Note:     On the system we used for testing (two dual-core Opterons
 *           running Linux 2.6) the time needed to start and terminate 
 *           1, 2, 3, or 4 threads took from 1.4e-5 to 1.9e-5 seconds.  
 *           Each additional thread beyond 4 added about 2 microseconds. 
 *
 * IPP:      Programming assignment 4.4
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "timer.h"

/* Global variables */
int thread_count;

/* Serial functions */
void Usage(char prog_name[]);

/* Parallel functions */
void *Thread_work(void* rank);

/*--------------------------------------------------------------*/

int main(int argc, char* argv[]) {
	long thread;
	pthread_t* thread_handles;
	double start, finish, elapsed;
	int i, n = 10000;
	
	if(argc != 2) Usage(argv[0]);
	
	thread_count = strtol(argv[1], NULL, 10);
	thread_handles = malloc(thread_count*sizeof(pthread_t));
	
	/* create thread & thread termination : n times */
	GET_TIME(start);
	for(i = 0; i < n; i++) {
		for(thread = 0; thread < thread_count; thread++) {
			pthread_create(&thread_handles[thread], NULL, Thread_work, (void*) thread);
		}
		
		for(thread = 0; thread < thread_count; thread++) {
			pthread_join(thread_handles[thread], NULL);
		}
	}
	GET_TIME(finish);
	
	elapsed = ((finish - start)/thread_count)/n;
	
	printf("Runtime for creating and terminating %d threads: %e\n", thread_count, elapsed);
	
	free(thread_handles);
	
	return 0;
} /* maim */

/*---------------------------------------------------------------------
 * Function:  Thread_work
 * Purpose:   creating thread for timing purpose
 */

void *Thread_work(void* rank) {
    
    return NULL;
	
}  /* Thread_work */

/*---------------------------------------------------------------------
 * Function:  Usage 
 * Purpose:   Print a message showing how to run program and quit
 * In arg:    prog_name:  the name of the program from the command line
 */

void Usage(char prog_name[]) {
	fprintf(stderr, "usage: %s ", prog_name); 
	fprintf(stderr, "<number of threads>\n");
	exit(0);
}  /* Usage */

