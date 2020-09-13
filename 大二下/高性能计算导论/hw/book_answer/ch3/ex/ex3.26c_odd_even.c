/* File:    ex3.26c_odd_even.c
 *
 * Purpose: Use odd-even transposition sort to sort a list of ints.
 *          This version determines whether the version that checks
 *          whether the list is sorted after each pass improves
 *          performance
 *
 * Compile: gcc -g -Wall -o ex3.26c_odd_even ex3.26c_odd_even.c
 * Run:     odd_even <n> <iters>
 *             n:      number of elements in list
 *             iters:  number of random lists to check
 *
 * Input:   None
 * Output:  if DEBUG is defined original list and sorted list 
 *
 * Basic algorithm:
 *    faster_with_check = 0
 *    for each iter {
 *       Generate list
 *       Time regular odd-even sort on list
 *       Time odd-even sort that checks whether list is sorted after
 *          each pass
 *       If check is faster add 1 faster_with_check
 *    }
 *    Print faster_with_check
 *
 * IPP:   Exercise 3.26c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "timer.h"

/* Keys in the random list in the range 0 <= key < RMAX */
#ifdef DEBUG
const int RMAX = 100;
#else
const int RMAX = 1000000;
#endif

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], int* n_p, int* iters_p);
void Generate_list(int a[], int n);
void Print_list(int a[], int n, char* title);
void Read_list(int a[], int n);
void Odd_even_sort(int a[], int n);
void Odd_even_sort_with_check(int a[], int n);
int Is_sorted(int a[], int n);

/*-----------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int  n, iters, test;
   int* orig;
   int* a;
   int faster_with_check = 0;
   double start, finish, elapsed, elapsed_wc;

   Get_args(argc, argv, &n, &iters);
   orig = (int*) malloc(n*sizeof(int));
   a = (int*) malloc(n*sizeof(int));
   srandom(1);

   for (test = 0; test < iters; test++) {
      Generate_list(orig, n);
#     ifdef DEBUG
      Print_list(orig, n, "Before sort");
#     endif

      memcpy(a, orig, n*sizeof(int));
      GET_TIME(start);
      Odd_even_sort(a, n);
      GET_TIME(finish);
      elapsed = finish-start;

#     ifdef DEBUG
      Print_list(a, n, "After basic sort");
      printf("Elapsed time for basic sort = %e seconds\n", elapsed);
#     endif

      memcpy(a, orig, n*sizeof(int));
      GET_TIME(start);
      Odd_even_sort_with_check(a, n);
      GET_TIME(finish);
      elapsed_wc = finish-start;

#     ifdef DEBUG
      Print_list(a, n, "After sort with check");
      printf("Elapsed time for sort with check= %e seconds\n", elapsed_wc);
#     endif

      if (elapsed_wc < elapsed) faster_with_check++;
   }

   printf("Out of %d sorts, %d were faster with checks\n",
         iters, faster_with_check);
   
   free(orig);
   free(a);
   return 0;
}  /* main */


/*-----------------------------------------------------------------
 * Function:  Usage
 * Purpose:   Summary of how to run program
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage:   %s <n> <iters>\n", prog_name);
   fprintf(stderr, "   n:      number of elements in list\n");
   fprintf(stderr, "   iters:  number of lists to test\n");
}  /* Usage */


/*-----------------------------------------------------------------
 * Function:  Get_args
 * Purpose:   Get and check command line arguments
 * In args:   argc, argv
 * Out args:  n_p, iters_p
 */
void Get_args(int argc, char* argv[], int* n_p, int* iters_p) {
   if (argc != 3) {
      Usage(argv[0]);
      exit(0);
   }
   *n_p = atoi(argv[1]);
   *iters_p = atoi(argv[2]);

   if (*n_p <= 0 || *iters_p <= 0) {
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

/*-----------------------------------------------------------------
 * Function:     Odd_even_sort_with_check
 * Purpose:      Sort list using odd-even transposition sort
 * In args:      n
 * In/out args:  a
 */
void Odd_even_sort_with_check(int a[], int n) {
   int phase, i, temp;
#  ifdef DEBUG
// char title[100];
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
//    sprintf(title, "After phase %d", phase);
//    Print_list(a, n, title);
#     endif
   }
}  /* Odd_even_sort */


/*-----------------------------------------------------------------
 * Function:     Odd_even_sort
 * Purpose:      Sort list using odd-even transposition sort
 * In args:      n
 * In/out args:  a
 */
void Odd_even_sort(int a[], int n) {
   int phase, i, temp;
#  ifdef DEBUG
// char title[100];
#  endif

   for (phase = 0; phase < n; phase++) {
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
//    sprintf(title, "After phase %d", phase);
//    Print_list(a, n, title);
#     endif
   }
}  /* Odd_even_sort */


