/* File:
 *    ex3.17_mpi_type_contig.c
 *
 * Description:
 *    Read two vectors, find their sum and print the result.
 *    Use MPI_Type_contiguous to build datatype used in 
 *    reading and printing the vectors
 *
 * Compile:    
 *    mpicc -g -Wall -o ex3.17_mpi_type_contig ex3.17_mpi_type_contig
 * Usage:        
 *    mpiexec -n <number of processes> ./ex3.17_mpi_type_contig
 *
 * Input:
 *    Order of the vectors, and the two vectors to be added
 *
 * Output
 *    The input vectors and their sum
 *
 * Note:  The order of the vectors should be evenly divisible by the
 *        number of processes
 *
 * IPP:   Exercise 3.17
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int my_rank, comm_sz;
MPI_Comm comm;

void Check_for_error(int local_ok, char fname[], char message[]);
void Read_n(int* n_p, int* local_n_p);
void Allocate_vectors(double** local_x_pp, double** local_y_pp,
      double** local_z_pp, int local_n);
void Read_vector(double local_a[], int local_n, int n, char vec_name[],
      MPI_Datatype cont_mpi_t);
void Print_vector(double local_b[], int local_n, int n, char title[],
      MPI_Datatype cont_mpi_t);
void Par_vector_sum(double local_x[], double local_y[], 
      double local_z[], int local_n);

/*-------------------------------------------------------------------*/
int main(void) {
   int n, local_n;
   double *local_x, *local_y, *local_z;
   MPI_Datatype cont_mpi_t;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
   
   Read_n(&n, &local_n);
   Allocate_vectors(&local_x, &local_y, &local_z, local_n);
   
   MPI_Type_contiguous(local_n, MPI_DOUBLE, &cont_mpi_t);
   MPI_Type_commit(&cont_mpi_t);
   
   Read_vector(local_x, local_n, n, "x", cont_mpi_t);
   Print_vector(local_x, local_n, n, "x is", cont_mpi_t);
   Read_vector(local_y, local_n, n, "y", cont_mpi_t);
   Print_vector(local_y, local_n, n, "y is", cont_mpi_t);
   
   Par_vector_sum(local_x, local_y, local_z, local_n);
   Print_vector(local_z, local_n, n, "The sum is", cont_mpi_t);
   
   free(local_x);
   free(local_y);
   free(local_z);
   MPI_Type_free(&cont_mpi_t);
   
   MPI_Finalize();
   
   return 0;
}  /* main */

/*-------------------------------------------------------------------*/
void Check_for_error(
                int       local_ok   /* in */, 
                char      fname[]    /* in */,
                char      message[]  /* in */) {
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
void Read_n(
         int*      n_p        /* out */, 
         int*      local_n_p  /* out */) {
   int local_ok = 1;
   char *fname = "Read_n";
   
   if (my_rank == 0) {
      printf("What's the order of the vectors?\n");
      scanf("%d", n_p);
   }
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   if (*n_p < 0 || *n_p % comm_sz != 0) local_ok = 0;
   Check_for_error(local_ok, fname,
               "n should be > 0 and evenly divisible by comm_sz");
   *local_n_p = *n_p/comm_sz;
}  /* Read_n */


/*-------------------------------------------------------------------*/
void Allocate_vectors(
                 double**   local_x_pp  /* out */, 
                 double**   local_y_pp  /* out */,
                 double**   local_z_pp  /* out */, 
                 int        local_n     /* in  */) {
   int local_ok = 1;
   char* fname = "Allocate_vectors";
   
   *local_x_pp = malloc(local_n*sizeof(double));
   *local_y_pp = malloc(local_n*sizeof(double));
   *local_z_pp = malloc(local_n*sizeof(double));
   
   if (*local_x_pp == NULL || *local_y_pp == NULL || 
      *local_z_pp == NULL) local_ok = 0;
   Check_for_error(local_ok, fname, "Can't allocate local vector(s)");
}  /* Allocate_vectors */


/*-------------------------------------------------------------------*/
void Read_vector(
             double        local_a[]   /* out */, 
             int           local_n     /* in  */, 
             int           n           /* in  */,
             char          vec_name[]  /* in  */,
             MPI_Datatype  cont_mpi_t  /* in  */) {
   
   double* a = NULL;
   int i;
   int local_ok = 1;
   char* fname = "Read_vector";
   
   if (my_rank == 0) {
      a = malloc(n*sizeof(double));
      if (a == NULL) local_ok = 0;
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      printf("Enter the vector %s\n", vec_name);
      for (i = 0; i < n; i++)
         scanf("%lf", &a[i]);
            
      MPI_Scatter(a, 1, cont_mpi_t, local_a, 1, cont_mpi_t, 0, comm);
      
      free(a);
   } else {
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      MPI_Scatter(a, 1, cont_mpi_t, local_a, 1, cont_mpi_t, 0, comm);

   }
}  /* Read_vector */  


/*-------------------------------------------------------------------*/
void Print_vector(
              double        local_b[]   /* in */, 
              int           local_n     /* in */, 
              int           n           /* in */, 
              char          title[]     /* in */, 
              MPI_Datatype  cont_mpi_t  /* in */) {
   
   double* b = NULL;
   int i;
   int local_ok = 1;
   char* fname = "Print_vector";
   
   if (my_rank == 0) {
      b = malloc(n*sizeof(double));
      if (b == NULL) local_ok = 0;
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      
      MPI_Gather(local_b, 1, cont_mpi_t, b, 1, cont_mpi_t, 0, comm);
      
      printf("%s\n", title);
      for (i = 0; i < n; i++)
         printf("%f ", b[i]);
      printf("\n");
      free(b);
   } else {
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      MPI_Gather(local_b, 1, cont_mpi_t, b, 1, cont_mpi_t, 0, comm);

   }
}  /* Print_vector */


/*-------------------------------------------------------------------*/
void Par_vector_sum(
                   double  local_x[]  /* in  */, 
                   double  local_y[]  /* in  */, 
                   double  local_z[]  /* out */, 
                   int     local_n    /* in  */) {
   int local_i;
   
   for (local_i = 0; local_i < local_n; local_i++)
      local_z[local_i] = local_x[local_i] + local_y[local_i];
}  /* Parallel_vector_sum */
