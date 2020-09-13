/*
 * File:     prog3.6_mpi_mat_vect_submat.c
 *
 * Purpose:  Implement matrix vector multiplication when the matrix
 *           has a submatrix distribution
 *
 * Compile:  mpicc -g -Wall -o prog3.6_mpi_mat_vect_submat 
 *                 prog3.6_mat_vect_submat.c -lm
 * Run:      mpiexec -n <comm_sz> ./prog3.6_mpi_mat_vect_submat
 *
 * Input:    order of matrix, matrix, vector
 * Output:   product of matrix and vector.  If DEBUG is defined, the 
 *           order, the input matrix and the input vector
 *
 * Notes:
 * 1.  comm_sz should be a perfect square
 * 2.  The matrix should be square and its order should be evenly divisible
 *     by the square root of comm_sz.
 * 3.  The program stores the local matrices as one-dimensional arrays
 *     in row-major order
 * 4.  The program uses a derived datatype for matrix input and output.
 *     It also uses the MPI collectives MPI_Scatterv and MPI_Gatherv
 *     for distributing and collecting, respectively, the matrix.
 * 5.  The program uses the MPI topology functions to build communicators
 *     corresponding to the process rows and process columns
 *
 * IPP:      Programming Assignment 3.6
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <mpi.h>

int my_rank, comm_sz;
int row_comm_sz, col_comm_sz, diag_comm_sz;
int my_row_rank, my_col_rank, my_diag_rank;
MPI_Comm comm, row_comm, col_comm, diag_comm;
int diag, which_row_comm, which_col_comm;
MPI_Datatype submat_mpi_t;
int *distrib_counts, *distrib_disps;

void Build_comms(void);
void Build_diag_comm(void);
void Check_for_error(int loc_ok, char fname[], char message[]);
void Get_dims(int* m_p, int* loc_m_p, int* n_p, int* loc_n_p);
void Allocate_arrays(double** loc_A_pp, double** loc_x_pp, 
      double** loc_y_pp, int m, int loc_m, int n, int loc_n);
void Init_distrib_data(int m, int loc_m, int n, int loc_n);
void Read_matrix(char prompt[], double loc_A[], int m, int loc_m,
      int n, int loc_n);
void Print_matrix(char title[], double loc_A[], int m, int loc_m,
      int n, int loc_n);
void Read_vector(char prompt[], double loc_vec[], int n, int loc_n);
void Print_vector(char title[], double loc_vec[], int n, int loc_n);
void Mat_vect_mult(double loc_A[], double loc_x[], 
      double loc_y[], int m, int loc_m, int n, int loc_n);
void Print_loc_vects(char title[], double loc_vec[], int loc_n);


/*-------------------------------------------------------------------*/
int main(void) {
   double* loc_A;
   double* loc_x;
   double* loc_y;
   
   int m,n;
   int loc_m, loc_n;
   
   MPI_Init(NULL, NULL);
   Build_comms();
   Build_diag_comm();
#  ifdef DEBUG
   printf("Proc %d > row_comm_sz = %d, col_comm_sz = %d\n",
         my_rank, row_comm_sz, col_comm_sz);
   fflush(stdout);
#  endif
   
   Get_dims(&m, &loc_m, &n, &loc_n);
   Allocate_arrays(&loc_A, &loc_x, &loc_y, m, loc_m, n, loc_n);
   Init_distrib_data(m, loc_m, n, loc_n);

   Read_matrix("A", loc_A, m, loc_m, n, loc_n);
#  ifdef DEBUG
   Print_matrix("A", loc_A, m, loc_m, n, loc_n);
#  endif
   
   Read_vector("x", loc_x, n, loc_n);
#  ifdef DEBUG
   Print_vector("x", loc_x, n, loc_n);
#  endif
   
   Mat_vect_mult(loc_A, loc_x, loc_y, m, loc_m, n, loc_n);
   
   Print_vector("y", loc_y, m, loc_m);
   
   free(loc_A);
   free(loc_x);
   free(loc_y);
   free(distrib_counts);
   free(distrib_disps);
   MPI_Type_free(&submat_mpi_t);
   MPI_Comm_free(&comm);
   MPI_Comm_free(&row_comm);
   MPI_Comm_free(&col_comm);
   if (diag) MPI_Comm_free(&diag_comm);
   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
void Check_for_error(
   int       loc_ok   /* in */, 
   char      fname[]    /* in */,
   char      message[]  /* in */) {
   
   int ok;
   
   MPI_Allreduce(&loc_ok, &ok, 1, MPI_INT, MPI_MIN, comm);
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
      int*      loc_m_p  /* out */,
      int*      n_p        /* out */,
      int*      loc_n_p  /* out */) {
   
   int loc_ok = 1;
   
   if (my_rank == 0) {
      printf("Enter the order of the matrix\n");
      scanf("%d", m_p);
   }
   MPI_Bcast(m_p, 1, MPI_INT, 0, comm);
   *n_p = *m_p;
   if (*m_p <= 0 || *m_p % col_comm_sz != 0) loc_ok = 0;
   Check_for_error(loc_ok, "Get_dims",
         "order must be positive and evenly divisible by sqrt(comm_sz)");

   *loc_m_p = *m_p/col_comm_sz;
   *loc_n_p = *n_p/row_comm_sz;
}  /* Get_dims */


/*-------------------------------------------------------------------*/
void Allocate_arrays(
   double**  loc_A_pp  /* out */, 
   double**  loc_x_pp  /* out */, 
   double**  loc_y_pp  /* out */, 
   int       m           /* in  */,   
   int       loc_m     /* in  */, 
   int       n           /* in  */,
   int       loc_n     /* in  */) {
   
   int loc_ok = 1;
   
   *loc_A_pp = malloc(loc_m*loc_n*sizeof(double));
   *loc_x_pp = malloc(loc_n*sizeof(double));
   *loc_y_pp = malloc(loc_m*sizeof(double));
   
   if (*loc_A_pp == NULL || loc_x_pp == NULL ||
      loc_y_pp == NULL) loc_ok = 0;
   Check_for_error(loc_ok, "Allocate_arrays",
               "Can't allocate local arrays");
}  /* Allocate_arrays */


/*-------------------------------------------------------------------*/
void Build_comms(void) {
   MPI_Comm grid_comm;
   int dim_sizes[2];
   int wrap_around[] = {0,0};
   int reorder = 1;
   int loc_ok = 1;
   int coords[2];
   int free_coords[2];

   /* Build communicator for entire grid */
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   int q = sqrt(comm_sz);
   if (comm_sz != q*q) loc_ok = 0;
   Check_for_error(loc_ok, "Build_comms", "comm_sz not a perfect square");
   dim_sizes[0] = dim_sizes[1] = q;
   MPI_Cart_create(MPI_COMM_WORLD, 2, dim_sizes, wrap_around, reorder,
         &grid_comm);
   comm = grid_comm;
   MPI_Comm_size(grid_comm, &comm_sz);
   MPI_Comm_rank(grid_comm, &my_rank);

   /* Build a communicator for each process row */
   free_coords[0] = 0;
   free_coords[1] = 1;
   MPI_Cart_sub(grid_comm, free_coords, &row_comm);
   MPI_Comm_size(row_comm, &row_comm_sz);
   MPI_Comm_rank(row_comm, &my_row_rank);

   /* Build a communicator for each process col */
   free_coords[0] = 1;
   free_coords[1] = 0;
   MPI_Cart_sub(grid_comm, free_coords, &col_comm);
   MPI_Comm_size(col_comm, &col_comm_sz);
   MPI_Comm_rank(col_comm, &my_col_rank);

   /* Record grid info */
   if (my_row_rank == my_col_rank) 
      diag = 1;
   else
      diag = 0;
   MPI_Cart_coords(comm, my_rank, 2, coords);
   which_row_comm = coords[0];
   which_col_comm = coords[1];
}  /* Build_comms */   


/*-------------------------------------------------------------------*/
void Build_diag_comm(void) {
   int process_ranks[row_comm_sz], q;
   MPI_Group group, diag_group;

   /* Make a list of the processes in comm that are on the diagonal */
   for (q = 0; q < row_comm_sz; q++)
      process_ranks[q] = q*(row_comm_sz + 1);

   /* Get the group underlying comm */
   MPI_Comm_group(comm, &group);

   /* Create the new group */
   MPI_Group_incl(group, row_comm_sz, process_ranks, &diag_group);

   /* Create the communicator */
   MPI_Comm_create(comm, diag_group, &diag_comm);

   if (diag) {
      MPI_Comm_size(diag_comm, &diag_comm_sz);
      MPI_Comm_rank(diag_comm, &my_diag_rank);
   } else {
      diag_comm_sz = row_comm_sz;
      my_diag_rank = -1;
   }
}  /* Build_diag_comm */


/*-------------------------------------------------------------------
 * Function:  Init_distrib_data
 * Purpose:   
 * 1. Build the derived datatype, submat_mpi_t, that's used 
 *    for matrix input and output.  It's essentially a vector 
 *    type consisting of loc_m blocks of loc_n doubles, and 
 *    each block has a stride of n doubles beyond the previous 
 *    block.  However, its extent is artificially reduced
 *    to the size of a single block of loc_n doubles.
 * 2. The number of blocks sent to (received from) each 
 *    process is 1.  So distrib_counts[proc] = 1, for
 *    each proc.
 * 3. Within a process row the offset of the start of a submatrix
 *    in process column p_c will be p_c*loc_n doubles beyond the 
 *    first submatrix in the process row.  Since submat_mpi_t 
 *    has extent loc_n doubles, this is the same as p_c submat_mpi_t's.
 *
 *    The first submatrix in process row p_r will have p_r*row_comm_sz
 *    submatrices preceding it.  Each of these submatrices consists
 *    of loc_m*loc_n doubles.  Hence the first submatrix in process
 *    row p_r will have p_r*row_comm_sz*loc_m*loc_n doubles preceding it.  
 *    Since the extent of a submat_mpi_t is loc_n doubles, this is the 
 *    same as p_r*row_comm_sz*loc_m submat_mpi_t's.
 *
 *    Thus, the global offset of the submatrix stored by process 
 *    (p_r, p_c) will be
 *
 *          p_r*row_comm_sz*loc_m + p_c submat_mpi_t's
 */
void Init_distrib_data(int m, int loc_m, int n, int loc_n) {
   int p_r, p_c, proc;
   MPI_Datatype vect_mpi_t;
#  ifdef DIST_DEBUG
   char print_str1[1000];
   char print_str2[1000];
#  endif

   MPI_Type_vector(loc_m, loc_n, n, MPI_DOUBLE, &vect_mpi_t);
   MPI_Type_create_resized(vect_mpi_t, 0, loc_n*sizeof(double), 
         &submat_mpi_t);
   MPI_Type_commit(&submat_mpi_t);
   MPI_Type_free(&vect_mpi_t);

   distrib_counts = malloc(comm_sz*sizeof(int));
   distrib_disps = malloc(comm_sz*sizeof(int));

   for (p_r = 0; p_r < col_comm_sz; p_r++)
      for (p_c = 0; p_c < row_comm_sz; p_c++) {
         proc = p_r*row_comm_sz + p_c;
         distrib_counts[proc] = 1;        
         distrib_disps[proc] = p_r*row_comm_sz*loc_m + p_c;
      }

#  ifdef DIST_DEBUG
   if (my_rank == 0) {
      sprintf(print_str1, "Proc %d > counts = ", my_rank);
      sprintf(print_str2, "Proc %d > disps = ", my_rank);
      for (proc = 0; proc < comm_sz; proc++) {
         sprintf(print_str1 + strlen(print_str1), "%d ", 
               distrib_counts[proc]);
         sprintf(print_str2 + strlen(print_str2), "%d ", 
               distrib_disps[proc]);
      }
      printf("%s\n", print_str1);
      printf("%s\n", print_str2);
   }
#  endif
}  /* Init_distrib_data */


/*-------------------------------------------------------------------*/
void Read_matrix(
             char          prompt[]       /* in  */, 
             double        loc_A[]        /* out */, 
             int           m              /* in  */, 
             int           loc_m          /* in  */, 
             int           n              /* in  */,
             int           loc_n          /* in  */) {
   double* A = NULL;
   int loc_ok = 1;
   int i, j;

   if (my_rank == 0) {
      A = malloc(m*n*sizeof(double));
      if (A == NULL) loc_ok = 0;
      Check_for_error(loc_ok, "Read_matrix",
                  "Can't allocate temporary matrix");

      printf("Enter the matrix %s\n", prompt);
      for (i = 0; i < m; i++)
         for (j = 0; j < n; j++)
            scanf("%lf", &A[i*n+j]);
      
      MPI_Scatterv(A, distrib_counts, distrib_disps, submat_mpi_t,
            loc_A, loc_m*loc_n, MPI_DOUBLE, 0, comm);
      free(A);
   } else {
      Check_for_error(loc_ok, "Read_matrix",
                  "Can't allocate temporary matrix");
      MPI_Scatterv(A, distrib_counts, distrib_disps, submat_mpi_t,
            loc_A, loc_m*loc_n, MPI_DOUBLE, 0, comm);
   }
}  /* Read_matrix */


/*-------------------------------------------------------------------*/
void Print_matrix(char title[], double loc_A[], int m, int loc_m, 
      int n, int loc_n) {
   double* A = NULL;
   int loc_ok = 1;
   int i, j;

   if (my_rank == 0) {
      A = malloc(m*n*sizeof(double));
      if (A == NULL) loc_ok = 0;
      Check_for_error(loc_ok, "Print_matrix",
                  "Can't allocate temporary matrix");

      MPI_Gatherv(loc_A, loc_m*loc_n, MPI_DOUBLE, 
            A, distrib_counts, distrib_disps, submat_mpi_t,
            0, comm);

      printf("The matrix %s\n", title);
      for (i = 0; i < m; i++) {
         for (j = 0; j < n; j++)
            printf("%.2f ", A[i*n+j]);
         printf("\n");
      }
      
      free(A);
   } else {
      Check_for_error(loc_ok, "Print_matrix",
                  "Can't allocate temporary matrix");
      MPI_Gatherv(loc_A, loc_m*loc_n, MPI_DOUBLE, 
            A, distrib_counts, distrib_disps, submat_mpi_t,
            0, comm);
   }
}  /* Print_matrix */


/*-------------------------------------------------------------------*/
void Read_vector(
             char      prompt[]     /* in  */, 
             double    loc_vec[]  /* out */, 
             int       n            /* in  */,
             int       loc_n      /* in  */) {
   double* vec = NULL;
   int i, loc_ok = 1;
   
   if (my_diag_rank == 0) {
      vec = malloc(n*sizeof(double));
      if (vec == NULL) loc_ok = 0;
      Check_for_error(loc_ok, "Read_vector",
                  "Can't allocate temporary vector");
      printf("Enter the vector %s\n", prompt);
      for (i = 0; i < n; i++)
         scanf("%lf", &vec[i]);
      MPI_Scatter(vec, loc_n, MPI_DOUBLE,
            loc_vec, loc_n, MPI_DOUBLE, 0, diag_comm);
      free(vec);
   } else {
      Check_for_error(loc_ok, "Read_vector",
                  "Can't allocate temporary vector");
      if (diag) 
         MPI_Scatter(vec, loc_n, MPI_DOUBLE,
               loc_vec, loc_n, MPI_DOUBLE, 0, diag_comm);
   }
}  /* Read_vector */


/*-------------------------------------------------------------------*/
void Mat_vect_mult(
      double    loc_A[]      /* in  */, 
      double    loc_x[]      /* in  */, 
      double    loc_y[]      /* out */,
      int       m            /* in  */,
      int       loc_m        /* in  */, 
      int       n            /* in  */,
      int       loc_n        /* in  */) {

   int loc_i, loc_j;
   double sub_y[loc_m];
#  ifdef DEBUG
   Print_loc_vects("Before Broadcast, loc_A = ", loc_A, loc_m*loc_n);
   MPI_Barrier(comm);
#  endif

   /* Broadcast loc_x across each column of processes */
   MPI_Bcast(loc_x, loc_n, MPI_DOUBLE, which_col_comm, col_comm);
#  ifdef DEBUG
   Print_loc_vects("After Broadcast, loc_x = ", loc_x, loc_n);
   MPI_Barrier(comm);
#  endif

   /* Multiply my submatrix by my part of x */
   for (loc_i = 0; loc_i < loc_m; loc_i++) {
      sub_y[loc_i] = 0.0;
      for (loc_j = 0; loc_j < loc_n; loc_j++)
         sub_y[loc_i] += loc_A[loc_i*loc_n + loc_j]*
            loc_x[loc_j];
   }
#  ifdef DEBUG
   Print_loc_vects("After Local multiplies, sub_y = ", sub_y, loc_n);
   MPI_Barrier(comm);
#  endif

   /* Now add up the partial sums in my process row and
    *  store the result in the diagonal */
   MPI_Reduce(sub_y, loc_y, loc_m, MPI_DOUBLE, MPI_SUM, 
         which_row_comm, row_comm);
}  /* Mat_vect_mult */


/*-------------------------------------------------------------------*/
void Print_vector(
              char      title[]     /* in */, 
              double    loc_vec[] /* in */, 
              int       n           /* in */,
              int       loc_n     /* in */) {
   double* vec = NULL;
   int i, loc_ok = 1;
   
   if (my_diag_rank == 0) {
      vec = malloc(n*sizeof(double));
      if (vec == NULL) loc_ok = 0;
      Check_for_error(loc_ok, "Print_vector",
                  "Can't allocate temporary vector");
      MPI_Gather(loc_vec, loc_n, MPI_DOUBLE,
               vec, loc_n, MPI_DOUBLE, 0, diag_comm);
      printf("\nThe vector %s\n", title);
      for (i = 0; i < n; i++)
         printf("%f ", vec[i]);
      printf("\n");
      free(vec);
   }  else {
      Check_for_error(loc_ok, "Print_vector",
                  "Can't allocate temporary vector");
      if (diag)  
         MPI_Gather(loc_vec, loc_n, MPI_DOUBLE,
                          vec, loc_n, MPI_DOUBLE, 0, diag_comm);
   }
}  /* Print_vector */


/*-------------------------------------------------------------------
 * Note:  Assumes all the processes in comm have a subvector
 */
void Print_loc_vects(char title[], double loc_vec[], int loc_n) {
   double temp_vect[loc_n];
   int q, i;

   if (my_rank == 0) {
      printf("%s:\n", title);
      printf("Proc %d > ", my_rank);
      for (i = 0; i < loc_n; i++)
         printf("%.2f ", loc_vec[i]);
      printf("\n");
      for (q = 1; q < comm_sz; q++) {
         MPI_Recv(temp_vect, loc_n, MPI_DOUBLE, q, 0, comm,
               MPI_STATUS_IGNORE);
         printf("Proc %d > ", q);
         for (i = 0; i < loc_n; i++)
            printf("%.2f ", temp_vect[i]);
         printf("\n");
      }
      printf("\n");
   } else {
      MPI_Send(loc_vec, loc_n, MPI_DOUBLE, 0, 0, comm);
   }
}  /* Print_loc_vects */
