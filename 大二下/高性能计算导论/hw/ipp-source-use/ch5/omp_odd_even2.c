/* File:    omp_odd_even2.c
 *
 * Purpose: Use odd-even transposition sort to sort a list of ints.
 *
 * Compile: gcc -g -Wall -fopenmp -I. -o omp_odd_even2 omp_odd_even2.c
 * Usage:   ./omp_odd_even2 <thread count> <n> <g|i>
 *             n:   number of elements in list
 *            'g':  generate list using a random number generator
 *            'i':  user input list
 *
 * Input:   list (optional)
 * Output:  elapsed time for sort
 *
 * Note:
 * 1.  DEBUG flag prints the contents of the list
 * 2.  This version forks and joins the threads only once.
 * 3.  Uses the OpenMP library function omp_get_wtime for timing.
 *     This function returns the number of seconds since some time 
 *     in the past.
 *
 * IPP:  Section 5.6.2 (pp. 235 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#ifdef DEBUG
const int RMAX = 100;
#else
const int RMAX = 10000000;
#endif

int thread_count;

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], int* n_p, char* g_i_p);
void Generate_list(int a[], int n);
void Print_list(int a[], int n, char* title);
void Read_list(int a[], int n);
void Odd_even(int a[], int n);

/*-----------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int  n;
   char g_i;
   int* a;
   double start, finish;

   Get_args(argc, argv, &n, &g_i);
   a = malloc(n*sizeof(int));
   if (g_i == 'g') {
      Generate_list(a, n);
#     ifdef DEBUG
      Print_list(a, n, "Before sort");
#     endif
   } else {
      Read_list(a, n);
   }

   start = omp_get_wtime();
   Odd_even(a, n);
   finish = omp_get_wtime();

#  ifdef DEBUG
   Print_list(a, n, "After sort");
#  endif
   
   printf("Elapsed time = %e seconds\n", finish - start);

   free(a);
   return 0;
}  /* main */


/*-----------------------------------------------------------------
 * Function:  Usage
 * Purpose:   Summary of how to run program
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage:   %s <thread count> <n> <g|i>\n", prog_name);
   fprintf(stderr, "   n:   number of elements in list\n");
   fprintf(stderr, "  'g':  generate list using a random number generator\n");
   fprintf(stderr, "  'i':  user input list\n");
}  /* Usage */


/*-----------------------------------------------------------------
 * Function:  Get_args
 * Purpose:   Get and check command line arguments
 * In args:   argc, argv
 * Out args:  n_p, g_i_p
 */
void Get_args(int argc, char* argv[], int* n_p, char* g_i_p) {
   if (argc != 4 ) {
      Usage(argv[0]);
      exit(0);
   }
   thread_count = strtol(argv[1], NULL, 10);
   *n_p = strtol(argv[2], NULL, 10);
   *g_i_p = argv[3][0];

   if (*n_p <= 0 || (*g_i_p != 'g' && *g_i_p != 'i') ) {
      Usage(argv[0]);
      exit(0);
   }
}  /* Get_args */


/*-----------------------------------------------------------------
 * Function:  Generate_list
 * Purpose:   Use random number generator to generate list elements
 * In args:   n
 * Out args:  a
 */
void Generate_list(int a[], int n) {
   int i;

   srandom(1);
   for (i = 0; i < n; i++)
      a[i] = random() % RMAX;
}  /* Generate_list */


/*-----------------------------------------------------------------
 * Function:  Print_list
 * Purpose:   Print the elements in the list
 * In args:   a, n
 */
void Print_list(int a[], int n, char* title) {
   int i;

   printf("%s:\n", title);
   for (i = 0; i < n; i++)
      printf("%d ", a[i]);
   printf("\n\n");
}  /* Print_list */


/*-----------------------------------------------------------------
 * Function:  Read_list
 * Purpose:   Read elements of list from stdin
 * In args:   n
 * Out args:  a
 */
void Read_list(int a[], int n) {
   int i;

   printf("Please enter the elements of the list\n");
   for (i = 0; i < n; i++)
      scanf("%d", &a[i]);
}  /* Read_list */


/*-----------------------------------------------------------------
 * Function:     Odd_even
 * Purpose:      Sort list using odd-even transposition sort
 * In args:      n
 * In/out args:  a
 */
void Odd_even(int a[], int n) {
   int phase, i, tmp;

#  pragma omp parallel num_threads(thread_count) \
      default(none) shared(a, n) private(i, tmp, phase)
   for (phase = 0; phase < n; phase++) {
      if (phase % 2 == 0)
#        pragma omp for 
         for (i = 1; i < n; i += 2) {
            if (a[i-1] > a[i]) {
               tmp = a[i-1];
               a[i-1] = a[i];
               a[i] = tmp;
            }
         }
      else
#        pragma omp for 
         for (i = 1; i < n-1; i += 2) {
            if (a[i] > a[i+1]) {
               tmp = a[i+1];
               a[i+1] = a[i];
               a[i] = tmp;
            }
         }
   }
}  /* Odd_even */

