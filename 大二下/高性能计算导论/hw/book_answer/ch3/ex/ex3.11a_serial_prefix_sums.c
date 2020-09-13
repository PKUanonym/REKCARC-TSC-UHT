/* File:  
 *    ex3.11a_serial_prefix_sums.c
 *
 * Purpose:  
 *    Compute the prefix sums of an input vector
 *
 * Compile:
 *    gcc -g -Wall -o ex3.11a_serial_prefix_sums ex3.11a_serial_prefix_sums.c
 * Run:
 *    ./ex3.11a_serial_prefix_sums <order of vector>
 *
 * Input:
 *    A vector
 * Output:
 *    The prefix sums of the vector
 *
 * IPP:   Exercise 3.11a
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void Read_vector(char prompt[], double vect[], int n);
void Print_vector(char title[], double vect[], int n);
void Compute_prefix_sums(double vect[], double prefix_sums[], int n);

int main(int argc, char* argv[]) {
   double *vect, *prefix_sums;
   int n;

   if (argc != 2) {
      fprintf(stderr, "usage:  %s <order of vector>\n", argv[0]);
      exit(0);
   }
   n = strtol(argv[1], NULL, 10);
   vect = malloc(n*sizeof(double));
   prefix_sums = malloc(n*sizeof(double));

   Read_vector("Enter the vector", vect, n);
   Print_vector("Input vector", vect, n);
   Compute_prefix_sums(vect, prefix_sums, n);
   Print_vector("Prefix sums", prefix_sums, n);

   free(vect);
   free(prefix_sums);
   return 0;
}  /* main */

/*-------------------------------------------------------------------*/
void Read_vector(char prompt[], double vect[], int n) {
   int i;

   printf("%s\n", prompt);
   for (i = 0; i < n; i++)
      scanf("%lf", &vect[i]);
}  /* Read_vector */

/*-------------------------------------------------------------------*/
void Print_vector(char title[], double vect[], int n) {
   int i;

   printf("%s\n   ", title);
   for (i = 0; i < n; i++)
      printf("%.2f ", vect[i]);
   printf("\n");
}  /* Print_vector */

/*-------------------------------------------------------------------*/
void Compute_prefix_sums(double vect[], double prefix_sums[], int n) {
   int i;

   prefix_sums[0] = vect[0];
   for (i = 1; i < n; i++)
      prefix_sums[i] = prefix_sums[i-1] + vect[i];
}  /* Compute_prefix_sums */
