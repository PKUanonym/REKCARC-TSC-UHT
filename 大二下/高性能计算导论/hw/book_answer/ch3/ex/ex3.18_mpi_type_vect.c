/* File:
 *    Ex3_18_mpi_type_vect.c
 *  
 * Description:
 *    Read in an array and distribute it using a block cyclic distribution.
 *    The subarray assigned to each process is printed.  Then the complete 
 *    array is *    printed.
 *
 * Compile:    
 *    mpicc -g -Wall -o ex3.18_mpi_type_vect ex3.18_mpi_type_vect.c
 * Run:        
 *    mpiexec -n <number of processes> ./ex3.18_mpi_type_vect 
 *
 * Input:
 *    order of array, block size
 * Output:
 *    Each process' components and the complete array
 *
 * Note: The order of the array must be evenly divisible by the product
 *       block_size*comm_sz
 *
 * IPP:  Exercise 3.18
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int my_rank, comm_sz;
MPI_Comm comm;

void Get_n_block_sz(int* block_size_p, int* n_p, int* local_n_p);
void Read_vector(char prompt[], int block_size, double local_vec[], int n, 
      int local_n, MPI_Datatype vect_mpi_t);
void Check_for_error(int local_ok, char fname[], char message[]);
void Print_subvectors(char title[], double local_vec[], int local_n);
void Print_vector(double local_vec[], int block_size, int local_n, int n, 
      char title[], MPI_Datatype vect_mpi_t);


int main(void) {
   double* local_x;
   int block_size, n, local_n;
   MPI_Datatype vect_mpi_t;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
   
   Get_n_block_sz(&block_size, &n, &local_n);
   local_x = malloc(local_n*sizeof(double));

   
   MPI_Type_vector(local_n/block_size, block_size, 
         block_size*comm_sz, MPI_DOUBLE, &vect_mpi_t);
   MPI_Type_commit(&vect_mpi_t);

   Read_vector("x", block_size, local_x, n, local_n, vect_mpi_t);
   Print_subvectors("x", local_x, local_n);
   Print_vector(local_x, block_size, local_n, n, "x", vect_mpi_t);

   free(local_x);
   MPI_Type_free(&vect_mpi_t);

   MPI_Finalize();
   return 0;
}

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
void Get_n_block_sz(
           int*      block_size_p /* out */,
           int*      n_p          /* out */,
           int*      local_n_p    /* out */) {
   int local_ok = 1;
   
   if (my_rank == 0) {
      printf("Enter the order of the vector\n");
      scanf("%d", n_p);
      printf("Enter the size of the blocks for block-cyclic dist\n");
      scanf("%d", block_size_p);
   }
   MPI_Bcast(block_size_p, 1, MPI_INT, 0, comm);
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   
   if (*n_p <= 0 || *block_size_p <=0 || *n_p % (*block_size_p*comm_sz) != 0) 
      local_ok = 0;
   Check_for_error(local_ok, "Get_dims",
      "n must be positive and evenly divisible by block_size*comm_sz");
      
   *local_n_p = *n_p/comm_sz;
}  /* Get_dims */


/*-------------------------------------------------------------------*/
void Read_vector(
             char          prompt[]     /* in  */, 
             int           block_size   /* in  */,
             double        local_vec[]  /* out */, 
             int           n            /* in  */,
             int           local_n      /* in  */,
             MPI_Datatype  vect_mpi_t   /* in  */) {
   double* vec = NULL;
   int i, j, local_ok = 1;
   int block, loc_block_count, big_block_sz, dest;
   
   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      if (vec == NULL) local_ok = 0;
      Check_for_error(local_ok, "Read_vector",
                  "Can't allocate temporary vector");

      printf("Enter the vector %s\n", prompt);
      for (i = 0; i < n; i++)
         scanf("%lf", &vec[i]);

#     ifdef DEBUG
      printf("Read in:  ");
      for (i = 0; i < n; i++)
         printf("%.2f ", vec[i]);
      printf("\n");
#     endif
         
      /* Copy Proc 0's data to its local_vec */
      loc_block_count = local_n/block_size;
      big_block_sz = comm_sz*block_size;
      j = 0;
      for (block = 0; block < loc_block_count ; block++)
         for (i = 0; i < block_size; i++)
            local_vec[j++] = vec[block*big_block_sz + i];

#     ifdef DEBUG
      printf("Copied to Proc 0:  ");
      for (i = 0; i < local_n; i++)
         printf("%.2f ", local_vec[i]);
      printf("\n");
#     endif

      /* Send nonlocal data to other processes */
      for (dest = 1; dest < comm_sz; dest++) {
#        ifdef DEBUG
         printf("Sending to %d first element %.2f\n",
               dest, vec[dest*block_size]);
#        endif
         MPI_Send(vec + dest*block_size, 1, vect_mpi_t, dest , 0, comm);
      }
      free(vec);

   } else {
      Check_for_error(local_ok, "Read_vector",
                  "Can't allocate temporary vector");
      MPI_Recv(local_vec, local_n, MPI_DOUBLE, 0, 0, comm, 
            MPI_STATUS_IGNORE);
   }
}  /* Read_vector */


/*-------------------------------------------------------------------*/
void Print_subvectors(char title[], double local_vec[], int local_n) {
   int i, src, local_ok = 1;
   double* vec = NULL;

   if (my_rank == 0) {
      vec = malloc(local_n*sizeof(double));
      if (vec == NULL) local_ok = 0;
      Check_for_error(local_ok, "Print_subvectors",
            "Can't allocate temporary vector");
      printf("\nContents of %s:\n", title);
      printf("Proc 0 > ");
      for (i = 0; i < local_n; i++)
         printf("%.2f ", local_vec[i]);
      printf("\n");
      for (src = 1; src < comm_sz; src++) {
         MPI_Recv(vec, local_n, MPI_DOUBLE, src, 0, comm, MPI_STATUS_IGNORE);
         printf("Proc %d > ", src);
         for (i = 0; i < local_n; i++)
            printf("%.2f ", vec[i]);
         printf("\n");
      }
      printf("\n");
      free(vec);
   } else {
      Check_for_error(local_ok, "Print_subvectors",
            "Can't allocate temporary vector");
      MPI_Send(local_vec, local_n, MPI_DOUBLE, 0, 0, comm);
   }
}  /* Print_subvectors */


/*-------------------------------------------------------------------*/
void Print_vector(double local_vec[], int block_size, int local_n, int n, 
      char title[], MPI_Datatype vect_mpi_t) {

   double* vec = NULL;
   int i, j, block, loc_block_count, big_block_sz, src_proc;
   int local_ok = 1;
   
   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      if (vec == NULL) local_ok = 0;
      Check_for_error(local_ok, "Print_vector",
                  "Can't allocate temporary vector");
      
      /* Copy proc 0's local_vec into vec */
      loc_block_count = local_n/block_size;
      big_block_sz = comm_sz*block_size;
      j = 0;
      for (block = 0; block < loc_block_count ; block++)
         for (i = 0; i < block_size; i++)
            vec[block*big_block_sz + i] = local_vec[j++];
      
      /* Receive other proc's local_vec */
      for (src_proc = 1; src_proc < comm_sz; src_proc++)
         MPI_Recv(vec + src_proc*block_size, 1, vect_mpi_t, 
               src_proc, 0, comm, MPI_STATUS_IGNORE);
      
      printf("%s\n", title);
      for (i = 0; i < n; i++)
         printf("%.2f ", vec[i]);
      printf("\n");
      free(vec);
   } else {
      Check_for_error(local_ok, "Print_vector",
                  "Can't allocate temporary vector");
      MPI_Send(local_vec, local_n, MPI_DOUBLE, 0, 0, comm);
   }
}  /* Print_vector */


