/* File:       
 *    ex3.13_mpi_vect_sum_dot.c
 *
 * Description:
 *    Implement a vector sum and a dot product allowing vectors whose
 *    order isn't evenly divisible by comm_sz
 *
 * Compile:    
 *    mpicc -g -Wall -o ex3.13_mpi_vect_sum_dot ex3.13_mpi_vect_sum_dot.c
 * Run:        
 *    mpiexec -n <number of processes> ./ex3.13_mpi_vect_sum_dot
 *
 * Input:
 *    Order of the vectors
 *    Vectors
 * Output:
 *    Vector sum and dot product
 *
 * IPP:   Exercise 3.13
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int my_rank, comm_sz;
MPI_Comm comm;

void Check_for_error(int local_ok, char fname[], char message[]);
void Read_n(int* n_p, int* local_n_p);
void Allocate_vects(double** local_x_pp, double** local_y_pp,
   double** local_z_pp, int local_n);
void Init_counts_displs(int counts[], int displs[], int n);
void Read_vect(double local_a[], int local_n, int n, char vec_name[]);
void Print_vect(double local_b[], int local_n, int n, char title[]);
void Par_vect_sum(double local_x[], double local_y[], 
                   double local_z[], int local_n);
double Par_dot_prod(double local_vec1[], double local_vec2[], int local_n);

int main(void) {
   int n, local_n;
   double *local_x, *local_y, *local_z;
   double dot_product;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
   
   Read_n(&n, &local_n);

   Allocate_vects(&local_x, &local_y, &local_z, local_n);
   
   Read_vect(local_x, local_n, n, "x");
   Print_vect(local_x, local_n, n, "x is");
   Read_vect(local_y, local_n, n, "y");
   Print_vect(local_y, local_n, n, "y is");
   
   Par_vect_sum(local_x, local_y, local_z, local_n);
   Print_vect(local_z, local_n, n, "The sum is");
   
   dot_product = Par_dot_prod(local_x, local_y, local_n);
   if (my_rank == 0)
      printf("Dot product input vectors is %f\n", dot_product);
   
   free(local_x);
   free(local_y);
   free(local_z);
   
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
   int quotient, remainder;
   int local_ok = 1;
   char *fname = "Read_n";
   
   if (my_rank == 0) {
      printf("What's the order of the vectors?\n");
      scanf("%d", n_p);
   }
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   if (*n_p <= 0) local_ok = 0;
   Check_for_error(local_ok, fname, "n should be > 0");
   
   quotient = *n_p/comm_sz;
   remainder = *n_p % comm_sz;
   
   if (my_rank < remainder) {
      *local_n_p = quotient +1;
   } else {
      *local_n_p = quotient;
   }
}  /* Read_n */

/*-------------------------------------------------------------------*/
void Allocate_vects(
                 double**   local_x_pp  /* out */, 
                 double**   local_y_pp  /* out */,
                 double**   local_z_pp  /* out */, 
                 int        local_n     /* in  */) {
   int local_ok = 1;
   char* fname = "Allocate_vects";
   
   *local_x_pp = malloc(local_n*sizeof(double));
   *local_y_pp = malloc(local_n*sizeof(double));
   *local_z_pp = malloc(local_n*sizeof(double));
   
   if (*local_x_pp == NULL || *local_y_pp == NULL || 
      *local_z_pp == NULL) local_ok = 0;
   Check_for_error(local_ok, fname, "Can't allocate local vector(s)");
}  /* Allocate_vects */


/*-------------------------------------------------------------------*/
void Init_counts_displs(int counts[], int displs[], int n) {
   int offset, q, quotient, remainder;
   
   quotient = n/comm_sz;
   remainder = n % comm_sz;
   offset = 0;
   for (q = 0; q < comm_sz; q++) {
      if (q < remainder) 
         counts[q] = quotient+1;
      else 
         counts[q] = quotient;
      displs[q] = offset;
      offset += counts[q];
   }
}  /* Init_counts_displs */


/*-------------------------------------------------------------------*/
void Read_vect(
             double    local_a[]   /* out */, 
             int       local_n     /* in  */, 
             int       n           /* in  */,
             char      vec_name[]  /* in  */) {
   
   int* counts = NULL;
   int* displs = NULL;
   
   double* a = NULL;
   int i;
   int local_ok = 1;
   char* fname = "Read_vector";
   
   if (my_rank == 0) {
      counts = malloc(comm_sz*sizeof(int));
      displs = malloc(comm_sz*sizeof(int));
      
      if (counts == NULL || displs == NULL) local_ok = 0;
      Check_for_error(local_ok, fname, "Can't allocate temporary counts");

      Init_counts_displs(counts, displs, n);
            
      a = malloc(n*sizeof(double));

      if (a == NULL) local_ok = 0;
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");

      printf("Enter the vector %s\n", vec_name);
      for (i = 0; i < n; i++)
         scanf("%lf", &a[i]);
      MPI_Scatterv(a, counts, displs, MPI_DOUBLE, 
            local_a, local_n, MPI_DOUBLE, 0, comm);
      
      free(a);
      free(displs);
      free(counts);
   } else {
      Check_for_error(local_ok, fname, "Can't allocate temporary counts");
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      MPI_Scatterv(a, counts, displs, MPI_DOUBLE, 
            local_a, local_n, MPI_DOUBLE, 0, comm);
   }
}  /* Read_vect */  


/*-------------------------------------------------------------------*/
void Print_vect(
              double    local_b[]  /* in */, 
              int       local_n    /* in */, 
              int       n          /* in */, 
              char      title[]    /* in */) {
   
   int* counts = NULL;
   int* displs = NULL;
   
   double* b = NULL;
   int i;
   int local_ok = 1;
   char* fname = "Print_vector";
   
   if (my_rank == 0) {
      counts = malloc(comm_sz*sizeof(int));
      displs = malloc(comm_sz*sizeof(int));
      if (counts == NULL || displs == NULL) local_ok = 0;
      Check_for_error(local_ok, fname, "Can't allocate temporary counts");
      Init_counts_displs(counts, displs, n);
      
      b = malloc(n*sizeof(double));
      if (b == NULL) local_ok = 0;
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      
      MPI_Gatherv(local_b, local_n, MPI_DOUBLE, b, counts, displs, 
            MPI_DOUBLE, 0, comm);
      
      printf("%s\n", title);
      for (i = 0; i < n; i++)
         printf("%f ", b[i]);
      printf("\n");
      free(displs);
      free(counts);
      free(b);
   } else {
      Check_for_error(local_ok, fname, "Can't allocate temporary counts");
      Check_for_error(local_ok, fname, "Can't allocate temporary vector");
      MPI_Gatherv(local_b, local_n, MPI_DOUBLE, b, counts, displs, 
            MPI_DOUBLE, 0, comm);
   }
}  /* Print_vect */

/*-------------------------------------------------------------------*/
void Par_vect_sum(
                   double  local_x[]  /* in  */, 
                   double  local_y[]  /* in  */, 
                   double  local_z[]  /* out */, 
                   int     local_n    /* in  */) {
   int local_i;
   
   for (local_i = 0; local_i < local_n; local_i++)
      local_z[local_i] = local_x[local_i] + local_y[local_i];
}  /* Par_vect_sum */

/*-------------------------------------------------------------------*/
double Par_dot_prod(double local_vec1[], double local_vec2[], 
      int local_n) {

   int local_i;
   double loc_dot_prod = 0, dot_prod;

   for (local_i = 0; local_i < local_n; local_i++)
      loc_dot_prod += local_vec1[local_i] * local_vec2[local_i];

   MPI_Reduce(&loc_dot_prod, &dot_prod, 1, MPI_DOUBLE, MPI_SUM, 0, comm);
   
   return dot_prod;
}  /* Par_dot_prod */
