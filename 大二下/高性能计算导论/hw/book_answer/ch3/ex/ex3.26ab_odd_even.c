/* File:    ex3.26ab_odd_even.c
 *
 * Purpose: Use odd-even transposition sort to sort a list of ints.
 *          This version checks whether the list is sorted after each
 *          pass.
 *
 * Compile: gcc -g -Wall -o ex3.26ab_odd_even ex3.26ab_odd_even.c
 * Run:     odd_even <n> <g|i> [p]
 *             n:   number of elements in list
 *            'g':  generate list using a random number generator
 *            'i':  user input list
 *            'p':  print the sorted list
 *
 * Input:   list (if 'i' is on the command line)
 * Output:  Unsorted list (if DEBUG is defined), sorted list (if 'p' is on 
 *          the command line)
 *
 * IPP:     Exercise 3.26 a and b
 */
#include <stdio.h>
#include <stdlib.h>
#include "timer.h"

/* Keys in the random list in the range 0 <= key < RMAX */
const int RMAX = 100;

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], int* n_p, char* g_i_p, 
      char* print_p);
void Generate_list(int a[], int n);
void Print_list(int a[], int n, char* title);
void Read_list(int a[], int n);
void Odd_even_sort(int a[], int n);
int Is_sorted(int a[], int n);

/*-----------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int  n;
   char g_i, print;
   int* a;
   double start, finish;

   Get_args(argc, argv, &n, &g_i, &print);
   a = (int*) malloc(n*sizeof(int));
   if (g_i == 'g') {
      Generate_list(a, n);
#     ifdef DEBUG
      Print_list(a, n, "Before sort");
#     endif
   } else {
      Read_list(a, n);
   }

   GET_TIME(start);
   Odd_even_sort(a, n);
   GET_TIME(finish);

   if (print == 'p')
      Print_list(a, n, "After sort");

   printf("Elapsed time = %e seconds\n", finish-start);
   
   free(a);
   return 0;
}  /* main */


/*-----------------------------------------------------------------
 * Function:  Usage
 * Purpose:   Summary of how to run program
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage:   %s <n> <g|i> [p]\n", prog_name);
   fprintf(stderr, "   n:   number of elements in list\n");
   fprintf(stderr, "  'g':  generate list using a random number generator\n");
   fprintf(stderr, "  'i':  user input list\n");
   fprintf(stderr, "  'p':  print sorted list\n");
}  /* Usage */


/*-----------------------------------------------------------------
 * Function:  Get_args
 * Purpose:   Get and check command line arguments
 * In args:   argc, argv
 * Out args:  n_p, g_i_p, print_p
 */
void Get_args(int argc, char* argv[], int* n_p, char* g_i_p,
      char* print_p) {
   if (argc < 3 || argc > 4) {
      Usage(argv[0]);
      exit(0);
   }
   *n_p = atoi(argv[1]);
   *g_i_p = argv[2][0];

   if (argc == 4)
      *print_p = 'p';
   else
      *print_p = 'n';

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

   srandom(0);
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
 * Function:     Odd_even_sort
 * Purpose:      Sort list using odd-even transposition sort
 * In args:      n
 * In/out args:  a
 */
void Odd_even_sort(int a[], int n) {
   int phase, i, temp;
#  ifdef DEBUG
   char title[100];
#  endif

   for (phase = 0; phase < n; phase++) {
      if (Is_sorted(a, n) == 1) return;
      if (phase % 2 == 0) { /* Even phase */
         for (i = 1; i < n; i += 2) 
            if (a[i-1] > a[i]) {
               temp = a[i];
               a[i] = a[i-1];
               a[i-1] = temp;
            }
      } else { /* Odd phase */
         for (i = 1; i < n-1; i += 2)
            if (a[i] > a[i+1]) {
               temp = a[i];
               a[i] = a[i+1];
               a[i+1] = temp;
            }
      }
#     ifdef DEBUG
      sprintf(title, "After phase %d", phase);
      Print_list(a, n, title);
#     endif
   }
}  /* Odd_even_sort */


/*-----------------------------------------------------------------
 * Function:     Is_sorted
 * Purpose:      Check whether a list is sorted
 * In args:      a, n
 * Ret val:      0 if not sorted, 1 if sorted
 */
int Is_sorted(int a[], int n) {
   int i;
   
   for (i = 1; i < n; i++)
      if (a[i-1] > a[i]) return 0;
   return 1;
}
