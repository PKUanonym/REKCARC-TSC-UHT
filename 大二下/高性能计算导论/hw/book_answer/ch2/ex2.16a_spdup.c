/* File:     ex2.16a_spdup.c
 * Purpose:  Given hypothetical serial and parallel run-times, compute
 *           speedups and efficiencies.
 *
 * Compile:  gcc -g -Wall -o ex2.16a_spdup.c -lm
 * Run:      ./ex2.16a_spdup 
 *
 * Input:    None
 * Output:   Speedups and Efficiencies for various values of n and p
 *
 * IPP:      Exercise 2.16a
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double T_serial(int n);
double T_parallel(int n, int p);
void Print_table(char title[], double vals[], int p_count, int min_p, 
      int n_count, int min_n);

int main(void) {
   int min_n = 10, max_n = 320, n_count = 6, n = 10, j;
   int min_p = 1, max_p = 128, p_count = 8, p = 1, i;
   double *spdups, *effs, t_s, t_p;

   spdups = malloc(p_count*n_count*sizeof(double));
   effs = malloc(p_count*n_count*sizeof(double));

   for (i = 0, p = min_p; i < p_count; i++, p *= 2)
      for (j = 0, n = min_n; j < n_count; j++, n *= 2) {
         t_s = T_serial(n);
         t_p = T_parallel(n, p);
         spdups[i*n_count + j] = t_s/t_p;
         effs[i*n_count + j] = spdups[i*n_count + j]/p;
      }

   Print_table("Speedups", spdups, p_count, min_p, n_count, min_n);
   Print_table("Efficiencies", effs, p_count, min_p, n_count, min_n);

   free(spdups);
   free(effs);
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
double T_serial(int n) {
   return (double) n*n;
}  /* T_serial */


/*-------------------------------------------------------------------*/
double T_parallel(int n, int p) {
   return ((double) n*n)/p + log2(p);
}  /* T_parallel */


/*-------------------------------------------------------------------*/
void Print_table(char title[], double vals[], int p_count, int min_p, 
      int n_count, int min_n) {
   int i, j, p, n;

   printf("%s:\n        ", title);
   for (j = 0, n = min_n; j < n_count; j++, n *= 2)
      printf("%d          ", n);
   printf("\n");
   for (i = 0, p = min_p; i < p_count; i++, p *= 2) {
      printf("%d\t", p);
      for (j = 0, n = min_n; j < n_count; j++, n *= 2) {
         printf("%.2e    ", vals[i*n_count + j]);
      }
      printf("\n");
   }
   printf("\n\n");
} /* Print_table */
