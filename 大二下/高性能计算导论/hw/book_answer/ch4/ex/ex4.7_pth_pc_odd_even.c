/* File:     
 *     ex4.7_pth_pc_odd_even.c
 *
 * Purpose:  
 *     Use a mutex to implement producer-consumer synchronization 
 *	   with an even number of threads.  Even-ranked threads
 *	   are producers; odd-ranked threads are consumers.
 *
 * Input:
 *     None
 *
 * Output:
 *     Messages printed by odd-ranked threads
 *
 * Compile:  gcc -g -Wall -o ex4.7_pth_pc_odd_even 
 *              ex4.7_pth_pc_odd_even.c -lpthread
 *
 * Usage:
 *     ex4.7_pth_pc_odd_even <number of threads>
 *
 * Notes:  
 *	- Each even-ranked thread creates a message
 *	- Each odd-ranked thread print out the message
 *      - Number of threads should be even
 *      - The thread that prints a given message is non-deterministic
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

const int MAX_STRING = 99;

int thread_count;
int msg = 0;
char* message;
pthread_mutex_t mutex;

void Usage(char* progname);

/* Thread function */
void* Thread_work(void* rank);

/*-----------------------------------------------------------------*/

int main(int argc, char* argv[]) {
	long thread;
	pthread_t* thread_handles;
	message = malloc(MAX_STRING*sizeof(char));
	
	if(argc != 2)
		Usage(argv[0]);
	
	thread_count = strtol(argv[1], NULL, 10);
	
	/* allocate array for threads */
	thread_handles = malloc(thread_count*sizeof(pthread_t));
	
	/* initialize mutex */
	pthread_mutex_init(&mutex, NULL);
	
	/* start threads */
	for(thread = 0; thread < thread_count; thread++) {
		pthread_create(&thread_handles[thread], NULL, Thread_work, 
					   (void*) thread);
	}
	
	/* wait for threads to complete */
	for(thread = 0; thread < thread_count; thread++) {
		pthread_join(thread_handles[thread], NULL);
	}
	
	pthread_mutex_destroy(&mutex);
	free(thread_handles);
	
	return 0;
}
/*-------------------------------------------------------------------
 * Function:    Thread_work
 * Purpose:     Producers: threads with even ranks create msgs
 *		Consumers: threads with odd ranks print out msgs
 * In arg:      rank
 * Global var:  mutex, msg, message
 */

void *Thread_work(void* rank) {
	long my_rank = (long) rank;
	
	while(1) {
		pthread_mutex_lock(&mutex);
		if (my_rank % 2 == 1) {
			if (msg) {
				printf("Th %ld > message: %s\n", my_rank, 
                                      message);
				msg = 0;
				pthread_mutex_unlock(&mutex);
				break;
			}
		} else {
			if (!msg) {
				sprintf(message, "hello from %ld", 
                                      my_rank);
				msg = 1;
				pthread_mutex_unlock(&mutex);
				break;
			}
		}
		pthread_mutex_unlock(&mutex);
	}
	
	return NULL;
}


/*--------------------------------------------------------------------
 * Function:    Usage
 * Purpose:     Print command line for function and terminate
 * In arg:      prog_name
 */

void Usage(char* progname)
{
	fprintf(stderr, "Usage: %s <number of threads>\n", progname);
	exit(0);
}
