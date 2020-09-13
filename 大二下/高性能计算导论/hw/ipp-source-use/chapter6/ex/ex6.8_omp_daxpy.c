/* File:      ex6.8_omp_daxpy.c
 * Purpose:   Implement daxpy (y = ax + y, for vectors x, y, and scalar a)
 *            using OpenMP.  Compare schedule choices for the for loop
 *
 * Compile:   gcc -g -Wall -fopenmp -o ex6.8_omp_daxpy ex6.8_omp_daxpy.c
 * Run:       ./ex6.8_omp_daxpy <thread count> <vector order>
 *
 * Input:     None, unless DEBUG flag is set.  If DEBUG is set, then
 *            the vectors x and y, and the scalar a
 * Output:    If there was an error, the vector y. Otherwise, the run-time 
 *            of the daxpy.  If DEBUG is set, y is always printed.
 *
 * Notes:
 * 1.  To choose the scheduling of the for loop in the daxpy, set
 *     the environment variable OMP_SCHEDULE.  To compare block and
 *     block-cyclic schedules try 
 *
 *     $ export OMP_SCHEDULE="static"     # block schedule
 *     $ export OMP_SCHEDULE="static,<b>" # block-cyclic schedule with
 *                                        # blocksize b
 *
 * IPP:  Exercise 6.8
 */
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int thread_count;

void Usage(char prog_name[]);
void Get_args(char* argv[], int *n_p);
void Get_input(double *a_p, double x[], double y[], int n);
void Gen_input(double *a_p, double x[], double y[], int n);
void Read_vector(double x[], int n);
void Print_vector(double x[], int n);
void Check_y(double y[], int n);
void Daxpy(double a, double x[], double y[], int n);

int main(int argc, char* argv[]) {
   int n;
   double a, *x, *y;
   double start, finish;

   if (argc != 3) Usage(argv[0]);
   Get_args(argv, &n);
   x = malloc(n*sizeof(double));
   y = malloc(n*sizeof(double));

#  ifdef DEBUG
   Get_input(&a, x, y, n);
#  else
   Gen_input(&a, x, y, n);
#  endif

   start = omp_get_wtime();
   Daxpy(a, x, y, n);
   finish = omp_get_wtime();

#  ifdef DEBUG
   printf("y =\n");
   Print_vector(y, n);
#  else
   Check_y(y, n);
#  endif

   printf("Elapsed time = %e seconds\n", finish-start);

   free(x);
   free(y);

   return 0;
}  /* main */

/*---------------------------------------------------------------------
 */
void Usage(char prog_name[]) {
   fprintf(stderr, "usage: %s <thread_count> <vector order>\n",
         prog_name);
   exit(0);
}  /* Usage */


/*---------------------------------------------------------------------
 */
void Get_args(char* argv[], int *n_p) {
   thread_count = strtol(argv[1], NULL, 10);
   *n_p = strtol(argv[2], NULL, 10);
}  /* Get_args */


/*---------------------------------------------------------------------
 */
void Get_input(double *a_p, double x[], double y[], int n) {
   printf("Enter a\n");
   scanf("%lf", a_p);
   printf("Enter x\n");
   Read_vector(x, n);
   printf("Enter y\n");
   Read_vector(y, n);
}  /* Get_input */


/*---------------------------------------------------------------------
 */
void Gen_input(double *a_p, double x[], double y[], int n) {
   int i;

   *a_p = 10.0;
   for (i = 0; i < n; i++) {
      x[i] = random()/((double) RAND_MAX);
      y[i] = 1 - 10*x[i];
   }
}  /* Gen_input */


/*---------------------------------------------------------------------
 */
void Read_vector(double x[], int n) {
   int i;

   for (i = 0; i < n; i++)
      scanf("%lf", &x[i]);
}  /* Read_vector */


/*---------------------------------------------------------------------
 */
void Print_vector(double x[], int n){
   int i;

   for (i = 0; i < n; i++)
      printf("%.2f ", x[i]);
   printf("\n");
}  /* Print_vector */


/*---------------------------------------------------------------------
 */
void Check_y(double y[], int n) {
   int i, ok = 1;

   for (i = 0; i < n; i++)
      if (y[i] != 1.0) {
         ok = 0;
         break;
      }

   if (!ok) {
      printf("Error in y:\n");
      if (n < 10) Print_vector(y, n);
   }
}  /* Check_y */


/*---------------------------------------------------------------------
 */
void Daxpy(double a, double x[], double y[], int n) {
   int i;

#  pragma omp parallel for num_threads(thread_count) \
      schedule(runtime) default(none) private(i) \
      shared(a, x, y, n)
   for (i = 0; i < n; i++)
      y[i] += a*x[i];
}  /* Daxpy */
