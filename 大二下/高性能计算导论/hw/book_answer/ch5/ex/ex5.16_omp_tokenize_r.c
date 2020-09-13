/* File:  
 *    ex5.16_omp_tokenize_r.c
 *
 * Purpose:
 *    Use threads to tokenize text input.  This version fixes problems 
 *    with the original tokenize program by replacing str_tok with
 *    a handwritten threadsafe function.
 *
 * Compile:
 *    gcc -g -Wall -fopenmp -o ex5.16_omp_tokenize_r ex5.16_omp_tokenize_r.c
 *
 * Usage:
 *    ./ex5.16_omp_tokenize_r <thread_count> < <input>
 *
 * Input:
 *    Lines of text
 *
 * Output:
 *    For each line of input the line read by the program, and the 
 *    tokens identified by my_strtok
 *
 * Algorithm:
 *    For each line of input, next thread reads the line and
 *    "tokenizes" it.
 *
 * IPP:  Exercise 5.16
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

const int MAX_LINES = 1000;
const int MAX_LINE = 80;

void Usage(char* prog_name);
void Get_text(char* lines[], int* line_count_p);
void Tokenize(char* lines[], int line_count, int thread_count); 
char *my_strtok(char* seps, char** next_string_p);
int separator(char* current, char* seps) ;

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int thread_count, i;
   char* lines[1000];
   int line_count;

   if (argc != 2) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);

   printf("Enter text\n");
   Get_text(lines, &line_count);
   Tokenize(lines, line_count, thread_count);

   for (i = 0; i < line_count; i++)
      if (lines[i] != NULL) free(lines[i]);

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

/*--------------------------------------------------------------------
 * Function:  Get_text
 * Purpose:   Read text and store as an array of strings, one per line
 *            of input text
 * Out args:  lines, line_count_p
 */
void Get_text(char* lines[], int* line_count_p) {
   char* line = malloc(MAX_LINE*sizeof(char));
   int i = 0;
   char* fg_rv;

   fg_rv = fgets(line, MAX_LINE, stdin);
   while (fg_rv != NULL) {
      lines[i++] = line;
      line = malloc(MAX_LINE*sizeof(char));
      fg_rv = fgets(line, MAX_LINE, stdin);
   }
   *line_count_p = i;
}  /* Get_text */

/*-------------------------------------------------------------------
 * Function:    Tokenize
 * Purpose:     Tokenize lines of input
 * In args:     line_count, thread_count
 * In/out arg:  lines
 */
void Tokenize(
      char*  lines[]       /* in/out */, 
      int    line_count    /* in     */, 
      int    thread_count  /* in     */) {
   int my_rank, i, j;
   char *my_token, *next_string;

#  pragma omp parallel num_threads(thread_count) \
      default(none) private(my_rank, i, j, my_token, next_string) \
      shared(lines, line_count)
   {
      my_rank = omp_get_thread_num();
#     pragma omp for schedule(static, 1)
      for (i = 0; i < line_count; i++) {
         printf("Thread %d > line %d = %s\n", my_rank, i, lines[i]);
         j = 0; 
         next_string = lines[i];
         my_token = my_strtok(" \t\n", &next_string);
         while ( my_token != NULL ) {
            printf("Thread %d > token %d = %s\n", my_rank, j, my_token);
            my_token = my_strtok(" \t\n", &next_string);
            j++;
         } 
         if (lines[i] != NULL) 
            printf("Thread %d > After tokenizing, my line = %s\n",
                  my_rank, lines[i]);
      } /* for i */
   }  /* omp parallel */

}  /* Tokenize */


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





