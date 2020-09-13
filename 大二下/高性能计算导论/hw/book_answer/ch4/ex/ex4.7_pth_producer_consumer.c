/* File:     
 *     ex4.7_pth_producer_comsumer.c
 *
 * Purpose:  
 *     Implement producer-consumer synchronization with two threads using 
 *        a mutex
 *
 * Input:
 *     None
 *
 * Output:
 *     message
 *
 * Compile:  gcc -g -Wall -o ex4.7_pth_producer_consumer 
 *              ex4.7_pth_producer_consumer.c -lpthread
 * Usage:
 *     ex4.7_pth_producer_consumer
 *
 * Notes:  
 *	- rank 1 create a message
 *	- rank 0 print out message
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
	
	if(argc != 1) Usage(argv[0]);
	
	thread_count = 2;
	
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
        free(message);
	free(thread_handles);
	
	return 0;
}
/*-------------------------------------------------------------------
 * Function:    Thread_work
 * Purpose:     Producer rank 1: create msg
 *		Consumer rank 0: print out msg
 * In arg:      rank
 * Global var:  mutex, msg, message
 */

void *Thread_work(void* rank) {
	long my_rank = (long) rank;
	
	while(1) {
		pthread_mutex_lock(&mutex);
		if (my_rank == 1) {
			if (msg) {
				printf("Th %ld > message = %s\n", 
                                      my_rank, message);
				pthread_mutex_unlock(&mutex);
				break;
			}
		} else {
			sprintf(message, "hello world");
			printf("Th %ld > created message\n", my_rank);
			msg = 1;
			pthread_mutex_unlock(&mutex);
			break;
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
	fprintf(stderr, "Usage: %s \n", progname);
	exit(0);
}
