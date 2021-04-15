/* File:     pth_msg.c
 *
 * Purpose:  Illustrate a synchronization problem with pthreads:  create 
 *           some threads, each of which creates and prints a message.
 *
 * Input:    none
 * Output:   message from each thread
 *
 * Compile:  gcc -g -Wall -o pth_msg pth_msg.c -lpthread
 * Usage:    pth_msg <thread_count>
 *
 * IPP:      Section 4.7 (pp. 172 and ff.)
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

const int MAX_THREADS = 1024;
const int MSG_MAX = 100;

/* Global variables:  accessible to all threads */
int thread_count;
char** messages;

void Usage(char* prog_name);
void *Send_msg(void* rank);  /* Thread function */

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long       thread;
   pthread_t* thread_handles; 

   if (argc != 2) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   if (thread_count <= 0 || thread_count > MAX_THREADS) Usage(argv[0]);

   thread_handles = (pthread_t*) malloc (thread_count*sizeof(pthread_t));
   messages = (char**) malloc(thread_count*sizeof(char*));
   for (thread = 0; thread < thread_count; thread++)
      messages[thread] = NULL;

   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], (pthread_attr_t*) NULL,
          Send_msg, (void*) thread);

   for (thread = 0; thread < thread_count; thread++) {
      pthread_join(thread_handles[thread], NULL);
   }

   for (thread = 0; thread < thread_count; thread++)
      free(messages[thread]);
   free(messages);

   free(thread_handles);
   return 0;
}  /* main */


/*--------------------------------------------------------------------
 * Function:    Usage
 * Purpose:     Print command line for function and terminate
 * In arg:      prog_name
 */
void Usage(char* prog_name) {

   fprintf(stderr, "usage: %s <number of threads>\n", prog_name);
   exit(0);
}  /* Usage */


/*-------------------------------------------------------------------
 * Function:       Send_msg
 * Purpose:        Create a message and ``send'' it by copying it
 *                 into the global messages array.  Receive a message
 *                 and print it.
 * In arg:         rank
 * Global in:      thread_count
 * Global in/out:  messages
 * Return val:     Ignored
 * Note:           The my_msg buffer is freed in main
 */
void *Send_msg(void* rank) {
   long my_rank = (long) rank;
   long dest = (my_rank + 1) % thread_count;
   long source = (my_rank + thread_count - 1) % thread_count;
   char* my_msg = (char*) malloc(MSG_MAX*sizeof(char));

   sprintf(my_msg, "Hello to %ld from %ld", dest, my_rank);
   messages[dest] = my_msg;

   if (messages[my_rank] != NULL) 
      printf("Thread %ld > %s\n", my_rank, messages[my_rank]);
   else
      printf("Thread %ld > No message from %ld\n", my_rank, source);

   return NULL;
}  /* Send_msg */
