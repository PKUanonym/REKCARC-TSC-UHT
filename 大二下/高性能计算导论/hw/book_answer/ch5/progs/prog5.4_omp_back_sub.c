/* File:     prog5.4_omp_back_sub.c
 *
 * Purpose:  Implement parallel back substitution with OpenMP
 *
 * Compile:  gcc -g -Wall -fopenmp -o omp_back_sub omp_back_sub.c -lm
 * Run:      ./omp_back_sub <number of threads> <n>
 *
 * Input:    None
 * Output:   Max error in solution.  If DEBUG flag is set,
 *           matrix, right-hand side, and actual solution.
 *
 * Notes:
 * 1.  The diagonal of the coefficient matrix is n/10.  The remaining
 *     entries are random positive floats between 0 and 1.
 * 2.  Solution to system is x[i] = 1.
 *
 * Answers to questions in Programming Assignment 5.4
 * (a), (b)  See documentation for function Row_solve, below.
 * (c), (d)  See documentation for function Col_solve, below.
 * (f) On one of our systems with four threads the best performance 
 *     was obtained with a static partition and chunksize = 
 *     n/thread_count, although both guided and dynamic did well 
 *     with large chunksizes.
 *
 * IPP:      Programming Assignment 5.4
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <omp.h>

void Get_args(int argc, char* argv[], int* thread_count_p, int* n_p);
void Init(double A[], double b[], double x[], int n);
void Row_solve(double A[], double b[], double x[], int n, int thread_count);
void Col_solve(double A[], double b[], double x[], int n, int thread_count);
double Find_error(double x[], int n);
void Print_mat(char title[], double A[], int n);
void Print_vect(char title[], double x[], int n);

int main(int argc, char* argv[]) {
   int n, thread_count;
   double *A, *b, *x;
   double start, finish;

   Get_args(argc, argv, &thread_count, &n);

   A = malloc(n*n*sizeof(double));
   b = malloc(n*sizeof(double));
   x = malloc(n*sizeof(double));

   Init(A, b, x, n);
#  ifdef DEBUG
   Print_mat("A = ", A, n);
   Print_vect("b = ", b, n);
#  endif

   memset(x, 0, n*sizeof(double));
   start = omp_get_wtime();
   Row_solve(A, b, x, n, thread_count);
   finish = omp_get_wtime();
   printf("Elapsed time for row solve = %e seconds\n", finish-start);
   printf("Max error in row solve = %e\n", Find_error(x,n));
#  ifdef DEBUG
   Print_vect("Row sol =", x, n);
#  endif

   memset(x, 0, n*sizeof(double));
   start = omp_get_wtime();
   Col_solve(A, b, x, n, thread_count);
   finish = omp_get_wtime();
   printf("Elapsed time for row solve = %e seconds\n", finish-start);
   printf("Max error in col solve = %e\n", Find_error(x,n));
#  ifdef DEBUG
   Print_vect("Col sol =", x, n);
#  endif

   free(A);
   free(b);
   free(x);

   return 0;
}  /* main */

/*--------------------------------------------------------------------*/
void Get_args(int argc, char* argv[], int* thread_count_p, int* n_p) {
   if (argc != 3) {
      fprintf(stderr, "usage: %s <thread_count> <n>\n", argv[0]);
      exit(0);
   }
   *thread_count_p = strtol(argv[1], NULL, 10);
   *n_p = strtol(argv[2], NULL, 10);
}  /* Get_args */


/*--------------------------------------------------------------------*/
void Init(double A[], double b[], double x[], int n) {
   int i, j;

   for (i = 0; i < n; i++)
      x[i] = 1.0;

   srandom(1);
   memset(A, 0, n*n*sizeof(double));
   for (i = 0; i < n; i++) {
      A[i*n+i] = n/10.0;
      for (j = i+1; j < n; j++)
         A[i*n + j] = random()/((double) RAND_MAX);
   }

   for (i = 0; i < n; i++) {
      b[i] = 0;
      for (j = i; j < n; j++)
         b[i] += A[i*n + j]*x[j];
   }

   memset(x, 0, n*sizeof(double));
}  /* Init */


/*--------------------------------------------------------------------
 * Function:  Row_solve
 * Purpose:   Solve a triangular system using the row-oriented algorithm
 * In args:   A, b, n, thread_count
 * Out arg:   x
 *
 * Notes:
 * 1. The outer loop can't be parallelized because of a loop-carried 
 *    dependence:  
 *       x[i] depends on x[j] for j = i+1, i+2, . . . , n-1
 * 2. The inner loop can be parallelized:  it's just a reduction.  
 *    Note the use of the single directives.  These insure that
 *    initialization of tmp and the assignment to x[i] are only
 *    executed by one thread.  Also, since they have implicit
 *    barriers, they insure that no thread can start executing
 *    the inner for loop until the initialization is completed,
 *    and no thread can start a subsequent iteration of the outer
 *    for loop until x[i] has been computed.
 * 3. Note that an array can't be a reduction variable.  So the
 *    use of tmp is necessary.
 */
void Row_solve(double A[], double b[], double x[], int n, int thread_count) {
   int i, j;
   double tmp;

#  pragma omp parallel num_threads(thread_count) \
      default(none) private(i, j) shared(A, b, n, x, tmp) 
   for (i = n-1; i >= 0; i--) {
#     pragma omp single
      tmp = b[i];
#     pragma omp for reduction(+: tmp) schedule(runtime)
      for (j = i+1; j < n; j++)
         tmp += -A[i*n+j]*x[j];
#     pragma omp single
      {
         x[i] = tmp/A[i*n+i];
#        ifdef DEBUG
         printf("x[%d] = %.1f\n", i, x[i]);
#        endif
      }
   }
}  /* Row_solve */


/*--------------------------------------------------------------------
 * Function:  Col_solve
 * Purpose:   Solve a triangular system using the column-oriented algorithm
 * In args:   A, b, n, thread_count
 * Out arg:   x
 *
 * Notes:
 * 1.  The (second) outer loop has a loop-carried dependence.  The
 *     value of x[j] in the current iteration will, in general, have
 *     been changed in previous iterations.  There will also be
 *     a race condition in the updates to x[i]:  if the iterations
 *     are partitioned among the threads, multiple threads may try
 *     to update x[i] simultaneously with their values of x[j].
 * 2.  The iterations in the inner loop, however, are indepdendent,
 *     as long as all the threads are working with the same x[j]
 *     Once again, note the use of the single directive.
 */
void Col_solve(double A[], double b[], double x[], int n, int thread_count) {
   int i, j;

#  pragma omp parallel num_threads(thread_count) \
     default(none) private(i,j) shared(A, b, x, n)
   {
#     pragma omp for 
      for (i = 0; i < n; i++)
         x[i] = b[i];

      for (j = n-1; j >= 0; j--) {
#        pragma omp single
         x[j] /= A[j*n+j];
#        pragma omp for schedule(runtime)
         for (i = 0; i < j; i++)
            x[i] += -A[i*n + j]*x[j];
      }
   }
}  /* Col_solve */


/*--------------------------------------------------------------------*/
double Find_error(double x[], int n) {
   int i;
   double error = 0.0, tmp;

   for (i = 0; i < n; i++) {
      tmp = fabs(x[i] - 1.0);
      if (tmp > error) error = tmp;
   }
   return error;
}  /* Find_error */


/*--------------------------------------------------------------------*/
void Print_mat(char title[], double A[], int n) {
   int i, j;

   printf("%s:\n", title);
   for (i = 0; i < n; i++) {
      for (j = 0; j < n; j++)
         printf("%4.1f ", A[i*n+j]);
      printf("\n");
   }
   printf("\n");
}  /* Print_mat */


/*--------------------------------------------------------------------*/
void Print_vect(char title[], double x[], int n) {
   int i;

   printf("%s ", title);
   for (i = 0; i < n; i++)
      printf("%.1f ", x[i]);
   printf("\n");
}  /* Print_vect */
