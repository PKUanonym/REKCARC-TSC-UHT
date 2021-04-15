/* File:  
 *    ex3.11c_mpi_prefix_sums.c
 *
 * Purpose:  
 *    Compute the prefix sums of an input vector using butterfly
 *    structured communication.
 *
 * Compile:
 *    gcc -g -Wall -o ex3.11c_mpi_prefix_sums ex3.11c_mpi_prefix_sums.c
 * Run:
 *    mpiexec -n <comm_sz> ./ex3.11c_mpi_prefix_sums <order of vector>
 *
 * Input:
 *    A vector
 * Output:
 *    The prefix sums of the vector
 *
 * Notes:  
 * 1.  The order of the vector should be evenly divisible by comm_sz
 * 2.  The number of MPI processes should be a power of 2
 *
 * IPP:   Exercise 3.11c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

void Check_for_error(int local_ok, char fname[], char message[]);
void Get_n(int argc, char* argv[], int* n_p, int* local_n_p);
void Read_vector(char prompt[], double loc_vect[], int n, int loc_n);
void Print_vector(char title[], double loc_vect[], int n, int loc_n);
void Compute_prefix_sums(double loc_vect[], double loc_prefix_sums[], 
      int n, int loc_n);

int my_rank, comm_sz;
MPI_Comm comm;

int main(int argc, char* argv[]) {
   double *loc_vect, *loc_prefix_sums;
   int n, loc_n;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_rank(comm, &my_rank);
   MPI_Comm_size(comm, &comm_sz);

   Get_n(argc, argv, &n, &loc_n);
   loc_vect = malloc(loc_n*sizeof(double));
   loc_prefix_sums = malloc(loc_n*sizeof(double));

   Read_vector("Enter the vector", loc_vect, n, loc_n);
   Print_vector("Input vector", loc_vect, n, loc_n);
   Compute_prefix_sums(loc_vect, loc_prefix_sums, n, loc_n);
   Print_vector("Prefix sums", loc_prefix_sums, n, loc_n);

   free(loc_vect);
   free(loc_prefix_sums);

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
void Get_n(int argc, char* argv[], int* n_p, int* local_n_p) {
   int local_ok = 1;
   
   if (my_rank == 0){
      if (argc != 2)
         *n_p = 0;
      else
         *n_p = strtol(argv[1], NULL, 10);
   }
   
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   if (*n_p <= 0 || *n_p % comm_sz != 0) local_ok = 0;
   Check_for_error(local_ok, "Get_n", 
         "n should be > 0 and evenly divisible by comm_sz");
   
   *local_n_p = *n_p / comm_sz;
}  /* Get_n */


/*-------------------------------------------------------------------*/
void Read_vector(char prompt[], double loc_vect[], int n, int loc_n) {
   int i;
   double* tmp = NULL;

   if (my_rank == 0) {
      tmp = malloc(n*sizeof(double));
      printf("%s\n", prompt);
      for (i = 0; i < n; i++)
         scanf("%lf", &tmp[i]);
      MPI_Scatter(tmp, loc_n, MPI_DOUBLE, loc_vect, loc_n, MPI_DOUBLE, 0,
            comm);
      free(tmp);
   } else {
      MPI_Scatter(tmp, loc_n, MPI_DOUBLE, loc_vect, loc_n, MPI_DOUBLE, 0,
            comm);
   }
}  /* Read_vector */

/*-------------------------------------------------------------------*/
void Print_vector(char title[], double loc_vect[], int n, int loc_n) {
   int i;
   double* tmp = NULL;

   if (my_rank == 0) {
      tmp = malloc(n*sizeof(double));
      MPI_Gather(loc_vect, loc_n, MPI_DOUBLE, tmp, loc_n, MPI_DOUBLE, 0,
            comm);
      printf("%s\n   ", title);
      for (i = 0; i < n; i++)
         printf("%.2f ", tmp[i]);
      printf("\n");
      free(tmp);
   } else {
      MPI_Gather(loc_vect, loc_n, MPI_DOUBLE, tmp, loc_n, MPI_DOUBLE, 0,
            comm);
   }
}  /* Print_vector */

/*-------------------------------------------------------------------
 * Function:  Compute_prefix_sums
 * Purpose:   Compute the prefix sums for the components assigned to
 *            this process
 * In args:   loc_vect, n, loc_n
 * Out args:  loc_prefix_sums
 */
void Compute_prefix_sums(double loc_vect[], double loc_prefix_sums[], int n, 
      int loc_n) {
   int loc_i, partner;
   unsigned mask;
   double sum, tmp;
#  ifdef DEBUG
   char title[100];
#  endif


   /* First compute prefix sums of my local vector */
   loc_prefix_sums[0] = loc_vect[0];
   for (loc_i = 1; loc_i < loc_n; loc_i++)
      loc_prefix_sums[loc_i] = loc_prefix_sums[loc_i-1] + loc_vect[loc_i];
#  ifdef DEBUG
   Print_vector("After local prefix sums", loc_prefix_sums, n, loc_n);  
#  endif

   /* Now use butterfly structured communications */
   sum = loc_prefix_sums[loc_n-1];
   mask = 1;
   while (mask < comm_sz) {
      partner = my_rank ^ mask;
      MPI_Sendrecv(&sum, 1, MPI_DOUBLE, partner, 0,
            &tmp, 1, MPI_DOUBLE, partner, 0,
            comm, MPI_STATUS_IGNORE);
      sum += tmp;
      if (my_rank > partner) 
         for (loc_i = 0; loc_i < loc_n; loc_i++)
            loc_prefix_sums[loc_i] += tmp;
#     ifdef DEBUG
      sprintf(title, "After mask = %u, tmp", mask);
      Print_vector(title, &tmp, comm_sz, 1);
      sprintf(title, "After mask = %u, sum", mask);
      Print_vector(title, &sum, comm_sz, 1);
      sprintf(title, "After mask = %u, loc_prefix_sums", mask);
      Print_vector(title, loc_prefix_sums, n, loc_n);
#     endif
      mask <<= 1;
   }

}  /* Compute_prefix_sums */
