/* File:  
 *    ex4.19_pth_tokenize_r.c
 *
 * Purpose:
 *    Try to use threads to tokenize text input.  Fix problems
 *    with original pth_tokenize.c by replacing str_tok with
 *    a handwritten threadsafe function.
 *
 * Input:
 *    Lines of text
 * Output:
 *    For each line of input:
 *       the line read by the program, and the tokens identified by 
 *       my_strtok
 * Usage:
 *    pth_tokenize <thread_count> < <input>
 * Algorithm:
 *    For each line of input, next thread reads the line and
 *    "tokenizes" it.
 *
 * IPP:  Exercise 4.19
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>

const int MAX = 1000;

int thread_count;
sem_t* sems;

void Usage(char* prog_name);
char *my_strtok(char* seps, char** next_string_p);
int separator(char* current, char* seps);
void *Tokenize(void* rank);  /* Thread function */

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long       thread;
   pthread_t* thread_handles; 

   if (argc != 2)
      Usage(argv[0]);
   thread_count = atoi(argv[1]);

   thread_handles = (pthread_t*) malloc (thread_count*sizeof(pthread_t));
   sems = (sem_t*) malloc(thread_count*sizeof(sem_t));
   sem_init(&sems[0], 0, 1);
   for (thread = 1; thread < thread_count; thread++);
      sem_init(&sems[thread], 0, 0);

   printf("Enter text\n");
   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], (pthread_attr_t*) NULL,
          Tokenize, (void*) thread);

   for (thread = 0; thread < thread_count; thread++) {
      pthread_join(thread_handles[thread], NULL);
   }

   for (thread=0; thread < thread_count; thread++)
      sem_destroy(&sems[thread]);

   free(sems);

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
 * Function:    my_strtok
 * Purpose:     return the next token in the string
 * In arg:      seps, characters that can separate successive
 *                 tokens
 * In/out arg:  next_string_p
 *                 on input: pointer to separator or start of 
 *                    next token in input.
 *                 on output:  pointer to separator marking
 *                    end of returned string.
 * Return val:  pointer to copy of next token in in_string
 *                 or NULL if no new token
 *
 */
char *my_strtok(char* seps, char** next_string_p) {
   char* token;
   int   length = 0;
   char* start;
   char* current = *next_string_p;

   /* Find beginning of next token */
   while (separator(current, seps))
      if ((*current == '\0') || (*current == '\n'))
         return NULL;
      else
         current++;
   start = current;

   /* Find end of token */
   while (!separator(current, seps)) {
      length++;
      current++;
   }

   /* Create storage for token and copy current token */
   token = (char*) malloc((length+1)*sizeof(char));
   strncpy(token, start, length);
   token[length] = '\0';

   /* Update pointer to start of new separator */
   *next_string_p = current;

   return token;
}  /* my_strtok */

/*-------------------------------------------------------------------
 * Function:    separator
 * Purpose:     determine whether the current character is a
 *                 separator or \0
 * In args:     current:  pointer to current character
 *              seps:  list of characters to checkrank
 */
int separator(char* current, char* seps) {
   int len = strlen(seps);
   int i;

   if (*current == '\0') return 1;
   for (i = 0; i < len; i++)
      if (*current == seps[i]) return 1;
   return 0;
}  /* separator */


/*-------------------------------------------------------------------
 * Function:    Tokenize
 * Purpose:     Tokenize lines of input
 * In arg:      rank
 * Global vars: thread_count (in), sems (in/out)
 * Return val:  Ignored
 */
void *Tokenize(void* rank) {
   long my_rank = (long) rank;
   int count;
   int next = (my_rank + 1) % thread_count;
   char *fg_rv;
   char my_line[MAX+1];
   char *my_string;
   char *next_string;

   // my_line = (char*) malloc((MAX+1)*sizeof(char));

   /* Force sequential reading of the input */
   sem_wait(&sems[my_rank]);
   fg_rv = fgets(my_line, MAX, stdin);
   sem_post(&sems[next]);
   while (fg_rv != NULL) {
      printf("Thread %ld > my line = %s", my_rank, my_line);

      count = 0;
      next_string = my_line;
      my_string = my_strtok(" \t\n", &next_string);
      while ( my_string != NULL ) {
         count++;
         printf("Thread %ld > string %d = %s\n", my_rank, count, my_string);
         free (my_string);
         my_string = my_strtok(" \t\n", &next_string);
      }
      // if (my_line != NULL) free(my_line);

      // my_line = (char*) malloc((MAX+1)*sizeof(char));
      sem_wait(&sems[my_rank]);
      fg_rv = fgets(my_line, MAX, stdin);
      sem_post(&sems[next]);
   }

   return NULL;
}  /* Tokenize */
