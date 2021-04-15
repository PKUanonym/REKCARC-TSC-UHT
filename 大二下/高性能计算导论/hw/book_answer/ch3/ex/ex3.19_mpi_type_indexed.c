/* File:       
 *    ex3.19_mpi_type_indexed.c
 *
 * Description:
 *    Send the upper triangular part of a square matrix from
 *    process 0 to process 1.  Use MPI_Type_indexed to create
 *    a derived datatype that can be used in the communication
 *
 * Compile:    
 *    mpicc -g -Wall -o ex3.19_mpi_type_indexed ex3.19_mpi_type_indexed.c
 * Usage:        
 *    mpiexec -n 2 ./ex3.19_mpi_type_indexed
 *
 * Input:
 *    Order of matrix and matrix
 *
 * Output:
 *    Upper triangular part of the input matrix
 *
 * Notes:
 * 1.  The program must be run with at least two processes.
 * 2.  If more than two processes are used, processes with
 *     rank >= 2 do nothing.
 *
 * IPP:  Exercise 3.19
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

int my_rank, comm_sz;
MPI_Comm comm;

void Check_for_error(int local_ok, char fname[], char message[]);
void Get_n(int* n_p);
void Read_loc_mat(double loc_mat[], int n);
void Build_indexed_type(int n, MPI_Datatype* indexed_mpi_t_p);
void Print_loc_mat(char title[], double loc_mat[], int n);


int main(void) {
   int n;
   double *loc_mat;
   MPI_Datatype indexed_mpi_t;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   if (comm_sz < 2) 
      Check_for_error(0, "main", "comm size must be >= 2");
   
   Get_n(&n);
   loc_mat = malloc(n*n*sizeof(double));
   
   Build_indexed_type(n, &indexed_mpi_t);
   if (my_rank == 0) {
      Read_loc_mat(loc_mat, n);
#     ifdef DEBUG
      Print_loc_mat("Read matrix", loc_mat, n);
#     endif
      MPI_Send(loc_mat, 1, indexed_mpi_t, 1, 0, comm);
   } else if (my_rank ==1){
      memset(loc_mat, 0, n*n*sizeof(double));
      MPI_Recv(loc_mat, 1, indexed_mpi_t, 0, 0, comm, MPI_STATUS_IGNORE);
      Print_loc_mat("Received matrix", loc_mat, n);
   }
   
   free(loc_mat);
   MPI_Type_free(&indexed_mpi_t);
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
void Get_n(int*    n_p          /* out */) {
   
   if (my_rank == 0) {
      printf("Enter the order of the matrix\n");
      scanf("%d", n_p);
   }
   
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   
   if (*n_p <= 0) 
      Check_for_error(0, "Get_n", "n must be positive");
   
}  /* Get_n */


/*-------------------------------------------------------------------*/
void Build_indexed_type(
      int            n                /* in  */, 
      MPI_Datatype*  indexed_mpi_t_p  /* out */) {
   int i;
   int* array_of_block_lens;
   int* array_of_disps;
   
   array_of_block_lens = malloc(n*sizeof(int));
   array_of_disps = malloc(n*sizeof(int));
   
   for (i = 0; i < n ; i++) {
      array_of_block_lens[i] = n-i;
      array_of_disps[i] = i*(n+1);
   }
   
   MPI_Type_indexed(n, array_of_block_lens, array_of_disps, MPI_DOUBLE, 
         indexed_mpi_t_p);
   MPI_Type_commit(indexed_mpi_t_p);

   free(array_of_block_lens);
   free(array_of_disps);
}  /* Build_indexed_type */
   

/*-------------------------------------------------------------------*/
void Read_loc_mat(
             double    loc_mat[]  /* out */, 
             int       n          /* in  */) {
   int i,j;
   
   printf("Enter the matrix\n");
   for (i = 0; i < n; i++)
      for (j = 0; j < n; j++)
         scanf("%lf", &loc_mat[i*n + j]);
}  /* Read_loc_mat */


/*-------------------------------------------------------------------*/
void Print_loc_mat(
             char      title[]    /* in */,
             double    loc_mat[]  /* in */, 
             int       n          /* in */) {
   int i,j;
   
   printf("Proc %d > %s\n", my_rank, title);
   for (i = 0; i < n; i++) {
      for (j = 0; j < n; j++)
         printf("%.2f ", loc_mat[i*n + j]);
      printf("\n");
   }
   printf("\n");
}  /* Print_loc_mat */
