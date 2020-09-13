/* File:     
 *     ex4.7_pth_pc_both.c
 *
 * Purpose:  
 *     Implement pthread producer-consumer synchronization 
 *	   using a mutex.  In this version each thread
 *	   is both a producer and a consumer.
 *
 * Input:
 *     none
 *
 * Output:
 *     messages received by each thread
 *
 * Compile:  gcc -g -Wall -o ex4.7_pth_pc_both ex4.7_pth_pc_both.c -lpthread
 *
 * Usage:
 *     ex4.7_pth_pc_both <number of threads>
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

const int MAX_STRING = 99;

int thread_count;
int msg = 0;     /* Is there a message available            */
int receiver;    /* Which thread should receive the message */
char* message;   /* Contents of the message                 */
pthread_mutex_t mutex;

void Usage(char* progname);

/* Thread function */
void* Thread_work(void* rank);

/*-----------------------------------------------------------------*/

int main(int argc, char* argv[]) {
	long thread;
	pthread_t* thread_handles;
	message = malloc(MAX_STRING*sizeof(char));
	
	if(argc != 2) Usage(argv[0]);
	
	thread_count = strtol(argv[1], NULL, 10);
	
	/* allocate array for thread handles */
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
 *
 * Function:    Thread_work
 * Purpose:     Each thread creates a message, makes it available
 *              to another thread, and prints the message it
 *              received
 * In arg:      rank
 * Global var:  mutex, msg, message
 */

void *Thread_work(void* rank) {
	long my_rank = (long) rank;
	int send = 0, recv = 0;
	
	while(1) {
		pthread_mutex_lock(&mutex);
		if(msg) {
			if (my_rank == receiver && !recv) {
				printf("Th %ld > Received: %s\n", 
                                      my_rank, message);
				msg = 0;
				recv = 1;
			}
		} else {
			if (!send) {
				sprintf(message, "hello from rank %ld", 
                                      my_rank);
				msg = 1;
				send = 1;
				receiver = (my_rank+1) % thread_count;
			}
		}
		pthread_mutex_unlock(&mutex);
		if (send && recv) break;
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
