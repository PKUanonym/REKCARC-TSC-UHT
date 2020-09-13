/* File:     mpi_mat_vect_mult.c
 *
 * Purpose:  Implement parallel matrix-vector multiplication using
 *           one-dimensional arrays to store the vectors and the
 *           matrix.  Vectors use block distributions and the
 *           matrix is distributed by block rows.
 *
 * Compile:  mpicc -g -Wall -o mpi_mat_vect_mult mpi_mat_vect_mult.c
 * Run:      mpiexec -n <number of processes> ./mpi_mat_vect_mult
 *
 * Input:    Dimensions of the matrix (m = number of rows, n
 *              = number of columns)
 *           m x n matrix A
 *           n-dimensional vector x
 * Output:   Product vector y = Ax
 *
 * Errors:   If an error is detected (m or n negative, m or n not evenly
 *           divisible by the number of processes, malloc fails), the
 *           program prints a message and all processes quit.
 *
 * Notes:     
 *    1. Number of processes should evenly divide both m and n
 *    2. Define DEBUG for verbose output
 *
 * IPP:      Section 3.4.9 (pp. 113 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void Check_for_error(int local_ok, char fname[], char message[], 
      MPI_Comm comm);
void Get_dims(int* m_p, int* local_m_p, int* n_p, int* local_n_p,
      int my_rank, int comm_sz, MPI_Comm comm);
void Allocate_arrays(double** local_A_pp, double** local_x_pp, 
      double** local_y_pp, int local_m, int n, int local_n, 
      MPI_Comm comm);
void Read_matrix(char prompt[], double local_A[], int m, int local_m, 
      int n, int my_rank, MPI_Comm comm);
void Read_vector(char prompt[], double local_vec[], int n, int local_n, 
      int my_rank, MPI_Comm comm);
void Print_matrix(char title[], double local_A[], int m, int local_m, 
      int n, int my_rank, MPI_Comm comm);
void Print_vector(char title[], double local_vec[], int n,
      int local_n, int my_rank, MPI_Comm comm);
void Mat_vect_mult(double local_A[], double local_x[], 
      double local_y[], int local_m, int n, int local_n, 
      MPI_Comm comm);

/*-------------------------------------------------------------------*/
int main(void) {
   double* local_A;
   double* local_x;
   double* local_y;
   int m, local_m, n, local_n;
   int my_rank, comm_sz;
   MPI_Comm comm;

   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   Get_dims(&m, &local_m, &n, &local_n, my_rank, comm_sz, comm);
   Allocate_arrays(&local_A, &local_x, &local_y, local_m, n, local_n, comm);
   Read_matrix("A", local_A, m, local_m, n, my_rank, comm);
#  ifdef DEBUG
   Print_matrix("A", local_A, m, local_m, n, my_rank, comm);
#  endif
   Read_vector("x", local_x, n, local_n, my_rank, comm);
#  ifdef DEBUG
   Print_vector("x", local_x, n, local_n, my_rank, comm);
#  endif

   Mat_vect_mult(local_A, local_x, local_y, local_m, n, local_n, comm);

   Print_vector("y", local_y, m, local_m, my_rank, comm);

   free(local_A);
   free(local_x);
   free(local_y);
   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------
 * Function:  Check_for_error
 * Purpose:   Check whether any process has found an error.  If so,
 *            print message and terminate all processes.  Otherwise,
 *            continue execution.
 * In args:   local_ok:  1 if calling process has found an error, 0
 *               otherwise
 *            fname:     name of function calling Check_for_error
 *            message:   message to print if there's an error
 *            comm:      communicator containing processes calling
 *                       Check_for_error:  should be MPI_COMM_WORLD.
 *
 * Note:
 *    The communicator containing the processes calling Check_for_error
 *    should be MPI_COMM_WORLD.
 */
void Check_for_error(
      int       local_ok   /* in */, 
      char      fname[]    /* in */,
      char      message[]  /* in */, 
      MPI_Comm  comm       /* in */) {
   int ok;

   MPI_Allreduce(&local_ok, &ok, 1, MPI_INT, MPI_MIN, comm);
   if (ok == 0) {
      int my_rank;
      MPI_Comm_rank(comm, &my_rank);
      if (my_rank == 0) {
         fprintf(stderr, "Proc %d > In %s, %s\n", my_rank, fname, 
               message);
         fflush(stderr);
      }
      MPI_Finalize();
      exit(-1);
   }
}  /* Check_for_error */


/*-------------------------------------------------------------------
 * Function:  Get_dims
 * Purpose:   Get the dimensions of the matrix and the vectors from
 *            stdin.
 * In args:   my_rank:   calling processes rank in comm
 *            comm_sz:   number of processes in comm
 *            comm:      communicator containing all processes calling
 *                       Get_dims
 * Out args:  m_p:       global number of rows of A and components in y
 *            local_m_p: local number of rows of A and components of y
 *            n_p:       global number of cols of A and components of x
 *            local_n_p: local number of components of x
 *
 * Errors:    if either m or n isn't positive or if m or n isn't evenly
 *            divisible by comm_sz, the program prints an error message
 *            and quits.
 * Note:
 *    All processes in comm should call Get_dims
 */
void Get_dims(
      int*      m_p        /* out */, 
      int*      local_m_p  /* out */,
      int*      n_p        /* out */,
      int*      local_n_p  /* out */,
      int       my_rank    /* in  */,
      int       comm_sz    /* in  */,
      MPI_Comm  comm       /* in  */) {
   int local_ok = 1;

   if (my_rank == 0) {
      printf("Enter the number of rows\n");
      scanf("%d", m_p);
      printf("Enter the number of columns\n");
      scanf("%d", n_p);
   }
   MPI_Bcast(m_p, 1, MPI_INT, 0, comm);
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   if (*m_p <= 0 || *n_p <= 0 || *m_p % comm_sz != 0 
         || *n_p % comm_sz != 0) local_ok = 0;
   Check_for_error(local_ok, "Get_dims",
      "m and n must be positive and evenly divisible by comm_sz", 
      comm);

   *local_m_p = *m_p/comm_sz;
   *local_n_p = *n_p/comm_sz;
}  /* Get_dims */

/*-------------------------------------------------------------------
 * Function:   Allocate_arrays
 * Purpose:    Allocate storage for local parts of A, x, and y
 * In args:    local_m:    local number of rows of A and components of y
 *             n:          global and local number of cols of A and global
 *                         number of components of x
 *             local_n:    local number of components of x
 *             comm:       communicator containing all calling processes
 * Out args:   local_A_pp: local storage for matrix (m/comm_sz rows, n cols)
 *             local_x_pp: local storage for x (n/comm_sz components)
 *             local_y_pp: local_storage for y (m/comm_sz components) 
 *
 * Errors:     if a malloc fails, the program prints a message and all
 *             processes quit
 * Note:
 *    Communicator should be MPI_COMM_WORLD because of call to 
 * Check_for_errors
 */
void Allocate_arrays(
      double**  local_A_pp  /* out */, 
      double**  local_x_pp  /* out */, 
      double**  local_y_pp  /* out */, 
      int       local_m     /* in  */, 
      int       n           /* in  */,   
      int       local_n     /* in  */, 
      MPI_Comm  comm        /* in  */) {

   int local_ok = 1;

   *local_A_pp = malloc(local_m*n*sizeof(double));
   *local_x_pp = malloc(local_n*sizeof(double));
   *local_y_pp = malloc(local_m*sizeof(double));

   if (*local_A_pp == NULL || local_x_pp == NULL ||
         local_y_pp == NULL) local_ok = 0;
   Check_for_error(local_ok, "Allocate_arrays",
         "Can't allocate local arrays", comm);
}  /* Allocate_arrays */

/*-------------------------------------------------------------------
 * Function:  Read_matrix
 * Purpose:   Read in the matrix and distribute among the processes
 *            using a block row distribution
 * In args:   prompt:  description of matrix (e.g., "A")
 *            m:       global number of rows of A
 *            local_m: local number of rows of A
 *            n:       global and local number of cols of A
 *            my_rank: process rank in communicator comm
 *            comm:    communicator containing processes calling
 *                     Read_matrix
 * Out args:  local_A: the local matrix
 *
 * Errors:    if malloc of temporary storage fails on process 0, the 
 *            program prints a message and all processes quit
 * Note:
 * 1. Communicator should be MPI_COMM_WORLD because of call to 
 *    Check_for_errors
 * 2. local_m and n should be the same on each process
 */
void Read_matrix(
      char      prompt[]   /* in  */, 
      double    local_A[]  /* out */, 
      int       m          /* in  */, 
      int       local_m    /* in  */, 
      int       n          /* in  */,
      int       my_rank    /* in  */,
      MPI_Comm  comm       /* in  */) {
   double* A = NULL;
   int local_ok = 1;
   int i, j;

   if (my_rank == 0) {
      A = malloc(m*n*sizeof(double));
      if (A == NULL) local_ok = 0;
      Check_for_error(local_ok, "Read_matrix",
            "Can't allocate temporary matrix", comm);
      printf("Enter the matrix %s\n", prompt);
      for (i = 0; i < m; i++)
         for (j = 0; j < n; j++)
            scanf("%lf", &A[i*n+j]);
      MPI_Scatter(A, local_m*n, MPI_DOUBLE, 
            local_A, local_m*n, MPI_DOUBLE, 0, comm);
      free(A);
   } else {
      Check_for_error(local_ok, "Read_matrix",
            "Can't allocate temporary matrix", comm);
      MPI_Scatter(A, local_m*n, MPI_DOUBLE, 
            local_A, local_m*n, MPI_DOUBLE, 0, comm);
   }
}  /* Read_matrix */

/*-------------------------------------------------------------------
 * Function:  Read_vector
 * Purpose:   Read a vector from stdin and distribute among the
 *            processes using a block distribution
 * In args:   prompt:  description of vector (e.g., "x")
 *            n:       global order of vector
 *            local_n: local order of vector (n/comm_sz)
 *
 * Errors:    if malloc of temporary storage fails on process 0, the 
 *            program prints a message and all processes quit
 * Notes:
 * 1. Communicator should be MPI_COMM_WORLD because of call to 
 *    Check_for_errors
 * 2. local_n should be the same on all processes
 */
void Read_vector(
      char      prompt[]     /* in  */, 
      double    local_vec[]  /* out */, 
      int       n            /* in  */,
      int       local_n      /* in  */,
      int       my_rank      /* in  */,
      MPI_Comm  comm         /* in  */) {
   double* vec = NULL;
   int i, local_ok = 1;

   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      if (vec == NULL) local_ok = 0;
      Check_for_error(local_ok, "Read_vector",
            "Can't allocate temporary vector", comm);
      printf("Enter the vector %s\n", prompt);
      for (i = 0; i < n; i++)
         scanf("%lf", &vec[i]);
      MPI_Scatter(vec, local_n, MPI_DOUBLE,
            local_vec, local_n, MPI_DOUBLE, 0, comm);
      free(vec);
   } else {
      Check_for_error(local_ok, "Read_vector",
            "Can't allocate temporary vector", comm);
      MPI_Scatter(vec, local_n, MPI_DOUBLE,
            local_vec, local_n, MPI_DOUBLE, 0, comm);
   }
}  /* Read_vector */

/*-------------------------------------------------------------------
 * Function:  Print_matrix
 * Purpose:   Print a matrix distributed by block rows to stdout
 * In args:   title:    name of matrix
 *            local_A:  calling process' part of matrix
 *            m:        global number of rows
 *            local_m:  local number of rows (m/comm_sz)
 *            n:        global (and local) number of cols
 *            my_rank:  calling process' rank in comm
 *            comm:     communicator containing all processes
 * Errors:    if malloc of local storage on process 0 fails, all
 *            processes quit.            
 * Notes:
 * 1.  comm should be MPI_COMM_WORLD because of call to Check_for_errors
 * 2.  local_m should be the same on all the processes
 */
void Print_matrix(
      char      title[]    /* in */,
      double    local_A[]  /* in */, 
      int       m          /* in */, 
      int       local_m    /* in */, 
      int       n          /* in */,
      int       my_rank    /* in */,
      MPI_Comm  comm       /* in */) {
   double* A = NULL;
   int i, j, local_ok = 1;

   if (my_rank == 0) {
      A = malloc(m*n*sizeof(double));
      if (A == NULL) local_ok = 0;
      Check_for_error(local_ok, "Print_matrix",
            "Can't allocate temporary matrix", comm);
      MPI_Gather(local_A, local_m*n, MPI_DOUBLE,
            A, local_m*n, MPI_DOUBLE, 0, comm);
      printf("\nThe matrix %s\n", title);
      for (i = 0; i < m; i++) {
         for (j = 0; j < n; j++)
            printf("%f ", A[i*n+j]);
         printf("\n");
      }
      printf("\n");
      free(A);
   } else {
      Check_for_error(local_ok, "Print_matrix",
            "Can't allocate temporary matrix", comm);
      MPI_Gather(local_A, local_m*n, MPI_DOUBLE,
            A, local_m*n, MPI_DOUBLE, 0, comm);
   }
}  /* Print_matrix */

/*-------------------------------------------------------------------
 * Function:  Print_vector
 * Purpose:   Print a vector with a block distribution
 * In args:   title:      name of vector
 *            local_vec:  calling process' part of vector
 *            n:          global number of components
 *            local_n:    local number of components (n/comm_sz)
 *            my_rank:    calling process' rank in comm
 *            comm:       communicator containing all processes
 * Errors:    if malloc of local storage on process 0 fails, all
 *            processes quit.            
 * Notes:
 * 1.  comm should be MPI_COMM_WORLD because of call to Check_for_errors
 * 2.  local_n should be the same on all the processes
 */
void Print_vector(
      char      title[]     /* in */, 
      double    local_vec[] /* in */, 
      int       n           /* in */,
      int       local_n     /* in */,
      int       my_rank     /* in */,
      MPI_Comm  comm        /* in */) {
   double* vec = NULL;
   int i, local_ok = 1;

   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      if (vec == NULL) local_ok = 0;
      Check_for_error(local_ok, "Print_vector",
            "Can't allocate temporary vector", comm);
      MPI_Gather(local_vec, local_n, MPI_DOUBLE,
            vec, local_n, MPI_DOUBLE, 0, comm);
      printf("\nThe vector %s\n", title);
      for (i = 0; i < n; i++)
         printf("%f ", vec[i]);
      printf("\n");
      free(vec);
   }  else {
      Check_for_error(local_ok, "Print_vector",
            "Can't allocate temporary vector", comm);
      MPI_Gather(local_vec, local_n, MPI_DOUBLE,
            vec, local_n, MPI_DOUBLE, 0, comm);
   }
}  /* Print_vector */

/*-------------------------------------------------------------------
 * Function:  Mat_vect_mult
 * Purpose:   Multiply a matrix A by a vector x.  The matrix is distributed
 *            by block rows and the vectors are distributed by blocks
 * In args:   local_A:  calling process' rows of matrix A
 *            local_x:  calling process' components of vector x
 *            local_m:  calling process' number of rows 
 *            n:        global (and local) number of columns
 *            local_n:  calling process' number of components of x
 *            comm:     communicator containing all calling processes
 * Errors:    if malloc of local storage on any process fails, all
 *            processes quit.            
 * Notes:
 * 1.  comm should be MPI_COMM_WORLD because of call to Check_for_errors
 * 2.  local_m and local_n should be the same on all the processes
 */
void Mat_vect_mult(
      double    local_A[]  /* in  */, 
      double    local_x[]  /* in  */, 
      double    local_y[]  /* out */,
      int       local_m    /* in  */, 
      int       n          /* in  */,
      int       local_n    /* in  */,
      MPI_Comm  comm       /* in  */) {
   double* x;
   int local_i, j;
   int local_ok = 1;

   x = malloc(n*sizeof(double));
   if (x == NULL) local_ok = 0;
   Check_for_error(local_ok, "Mat_vect_mult",
         "Can't allocate temporary vector", comm);
   MPI_Allgather(local_x, local_n, MPI_DOUBLE,
         x, local_n, MPI_DOUBLE, comm);

   for (local_i = 0; local_i < local_m; local_i++) {
      local_y[local_i] = 0.0;
      for (j = 0; j < n; j++)
         local_y[local_i] += local_A[local_i*n+j]*x[j];
   }
   free(x);
}  /* Mat_vect_mult */
