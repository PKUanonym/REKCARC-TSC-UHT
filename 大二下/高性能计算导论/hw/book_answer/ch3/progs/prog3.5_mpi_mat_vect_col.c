/*
 * File:     prog3.5_mpi_mat_vect_col.c
 *
 * Purpose:  Implement matrix vector multiplication when the matrix
 *           has a block column distribution
 *
 * Compile:  mpicc -g -Wall -o prog3.5_mpi_mat_vect_col prog3.5_mat_vect_col.c
 * Run:      mpiexec -n <comm_sz> ./prog3.5_mpi_mat_vect_col
 *
 * Input:    order of matrix, matrix, vector
 * Output:   product of matrix and vector.  If DEBUG is defined, the 
 *           order, the input matrix and the input vector
 *
 * Notes:
 * 1.  The matrix should be square and its order should be evenly divisible
 *     by comm_sz
 * 2.  The program stores the local matrices as one-dimensional arrays
 *     in row-major order
 * 3.  The program uses a derived datatype for matrix input and output
 *
 * Author:   Jinyoung Choi
 *
 * IPP:      Programming Assignment 3.5
 */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void Check_for_error(int local_ok, char fname[], char message[], 
      MPI_Comm comm);
void Get_dims(int* m_p, int* local_m_p, int* n_p, int* local_n_p,
      int my_rank, int comm_sz, MPI_Comm comm);
void Allocate_arrays(double** local_A_pp, double** local_x_pp, 
      double** local_y_pp, int m, int local_m, int local_n, 
      MPI_Comm comm);
void Build_derived_type(int m, int local_m, int n, int local_n,
      MPI_Datatype* block_col_mpi_t_p);
void Read_matrix(char prompt[], double local_A[], int m, int local_n, 
      int n, MPI_Datatype block_col_mpi_t, int my_rank, MPI_Comm comm);
void Print_matrix(char title[], double local_A[], int m, int local_n, 
      int n, MPI_Datatype block_col_mpi_t, int my_rank, MPI_Comm comm);
void Read_vector(char prompt[], double local_vec[], int n, int local_n, 
      int my_rank, MPI_Comm comm);
void Print_vector(char title[], double local_vec[], int n,
      int local_n, int my_rank, MPI_Comm comm);
void Mat_vect_mult(double local_A[], double local_x[], 
      double local_y[], int local_m, int m, int n, int local_n, 
      int comm_sz, MPI_Comm comm);

/*-------------------------------------------------------------------*/
int main(void) {
   double* local_A;
   double* local_x;
   double* local_y;
   
   int m,n;
   int local_m, local_n;
   
   int my_rank, comm_sz;
   MPI_Comm comm;
   MPI_Datatype block_col_mpi_t;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
   
   Get_dims(&m, &local_m, &n, &local_n, my_rank, comm_sz, comm);
   Allocate_arrays(&local_A, &local_x, &local_y, m, local_m, local_n, comm);
   Build_derived_type(m, local_m, n, local_n, &block_col_mpi_t);
   Read_matrix("A", local_A, m, local_n, n, block_col_mpi_t, my_rank, comm);
#  ifdef DEBUG
   Print_matrix("A", local_A, m, local_n, n, block_col_mpi_t, my_rank, comm);
#  endif
   
   Read_vector("x", local_x, n, local_n, my_rank, comm);
#  ifdef DEBUG
   Print_vector("x", local_x, n, local_m, my_rank, comm);
#  endif
   
   Mat_vect_mult(local_A, local_x, local_y, local_m, m, n, 
         local_n, comm_sz, comm);   
   
   Print_vector("y", local_y, m, local_m, my_rank, comm);
   
   free(local_A);
   free(local_x);
   free(local_y);
   MPI_Type_free(&block_col_mpi_t);
   MPI_Finalize();
   return 0;
}  /* main */

/*-------------------------------------------------------------------*/
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


/*-------------------------------------------------------------------*/
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
      printf("Enter the order of the matrix\n");
      scanf("%d", m_p);
   }
   MPI_Bcast(m_p, 1, MPI_INT, 0, comm);
   *n_p = *m_p;
   if (*m_p <= 0 || *m_p % comm_sz != 0) local_ok = 0;
   Check_for_error(local_ok, "Get_dims",
               "m and n must be positive and evenly divisible by comm_sz", 
               comm);
   
   *local_m_p = *m_p/comm_sz;
   *local_n_p = *n_p/comm_sz;
}  /* Get_dims */


/*-------------------------------------------------------------------*/
void Allocate_arrays(
   double**  local_A_pp  /* out */, 
   double**  local_x_pp  /* out */, 
   double**  local_y_pp  /* out */, 
   int       m           /* in  */,   
   int       local_m     /* in  */, 
   int       local_n     /* in  */, 
   MPI_Comm  comm        /* in  */) {
   
   int local_ok = 1;
   
   *local_A_pp = malloc(m*local_n*sizeof(double));
   *local_x_pp = malloc(local_n*sizeof(double));
   *local_y_pp = malloc(local_m*sizeof(double));
   
   if (*local_A_pp == NULL || local_x_pp == NULL ||
      local_y_pp == NULL) local_ok = 0;
   Check_for_error(local_ok, "Allocate_arrays",
               "Can't allocate local arrays", comm);
}  /* Allocate_arrays */


/*-------------------------------------------------------------------*/
void Build_derived_type(int m, int local_m, int n, int local_n,
      MPI_Datatype* block_col_mpi_t_p) {
   MPI_Datatype vect_mpi_t;

   /* m blocks each containing local_n elements */
   /* The start of each block is n doubles beyond the preceding block */
   MPI_Type_vector(m, local_n, n, MPI_DOUBLE, &vect_mpi_t);

   /* Resize the new type so that it has the extent of local_n doubles */
   MPI_Type_create_resized(vect_mpi_t, 0, local_n*sizeof(double),
         block_col_mpi_t_p);
   MPI_Type_commit(block_col_mpi_t_p);
}  /* Build_derived_type */


/*-------------------------------------------------------------------*/
void Read_matrix(
             char          prompt[]         /* in  */, 
             double        local_A[]        /* out */, 
             int           m                /* in  */, 
             int           local_n          /* in  */, 
             int           n                /* in  */,
             MPI_Datatype  block_col_mpi_t  /* in  */,
             int           my_rank          /* in  */,
             MPI_Comm      comm             /* in  */) {
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
      
      MPI_Scatter(A, 1, block_col_mpi_t, local_A, m*local_n, MPI_DOUBLE,
            0, comm);
      free(A);
   } else {
      Check_for_error(local_ok, "Read_matrix",
                  "Can't allocate temporary matrix", comm);
      MPI_Scatter(A, 1, block_col_mpi_t, local_A, m*local_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Read_matrix */


/*-------------------------------------------------------------------*/
void Print_matrix(char title[], double local_A[], int m, int local_n, 
      int n, MPI_Datatype block_col_mpi_t, int my_rank, MPI_Comm comm) {
   double* A = NULL;
   int local_ok = 1;
   int i, j;

   if (my_rank == 0) {
      A = malloc(m*n*sizeof(double));
      if (A == NULL) local_ok = 0;
      Check_for_error(local_ok, "Print_matrix",
                  "Can't allocate temporary matrix", comm);

      MPI_Gather(local_A, m*local_n, MPI_DOUBLE, A, 1, block_col_mpi_t,
            0, comm);

      printf("The matrix %s\n", title);
      for (i = 0; i < m; i++) {
         for (j = 0; j < n; j++)
            printf("%.2f ", A[i*n+j]);
         printf("\n");
      }
      
      free(A);
   } else {
      Check_for_error(local_ok, "Print_matrix",
                  "Can't allocate temporary matrix", comm);
      MPI_Gather(local_A, m*local_n, MPI_DOUBLE, A, 1, block_col_mpi_t,
            0, comm);
   }
}  /* Print_matrix */


/*-------------------------------------------------------------------*/
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


/*-------------------------------------------------------------------*/
void Mat_vect_mult(
               double    local_A[]  /* in  */, 
               double    local_x[]  /* in  */, 
               double    local_y[]  /* out */,
               int       local_m    /* in  */, 
               int       m          /* in  */,
               int       n         /* in  */,
               int       local_n    /* in  */, 
               int       comm_sz,
               MPI_Comm  comm       /* in  */) {
   
   double* my_y;
   int* recv_counts;
   int i, loc_j;
   int local_ok = 1;
   
   recv_counts = malloc(comm_sz*sizeof(int));
   my_y = malloc(n*sizeof(double));
   if ( recv_counts == NULL || my_y == NULL) local_ok = 0;
   Check_for_error(local_ok, "Mat_vect_mult",
               "Can't allocate temporary arrays", comm);
      
   for (i = 0; i < m ; i++) {
      my_y[i] = 0.0;
      for (loc_j = 0; loc_j < local_n ; loc_j++)
         my_y[i] += local_A[i*local_n + loc_j]*local_x[loc_j];
   }
   
   for (i = 0; i < comm_sz; i++) {
      recv_counts[i] = local_m;
   }
   
   MPI_Reduce_scatter(my_y, local_y, recv_counts, MPI_DOUBLE, MPI_SUM, comm);
   
   free(my_y);
}  /* Mat_vect_mult */


/*-------------------------------------------------------------------*/
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

