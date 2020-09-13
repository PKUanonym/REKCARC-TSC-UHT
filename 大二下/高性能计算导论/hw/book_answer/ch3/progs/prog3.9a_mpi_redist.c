/* File:     prog3.9a_mpi_redist.c
 *
 * Purpose:  Convert data that has a block distribution to data that has
 *           a cyclic distribution and vice versa
 *
 * Compile:  mpicc -g -Wall -o prog3.9a_mpi_redist prog3.9a_mpi_redist.c
 * Run:      mpiexec -n <comm_sz> ./prog3.9a_mpi_redist <vector order>
 *
 * Input:    None unless DEBUG flag is set, in which case, the vector
 * Output:   Vector after conversion from block to cyclic and after
 *           conversion from cyclic to block.  If DEBUG flag is set
 *           local vector on each process before and after each
 *           conversion
 *
 * Notes:
 * 1.  Order of vector should be evenly divisible by comm_sz^2.
 * 2.  This version of the program uses a derived datatype to
 *     gather the vector onto process 0 when it has a cyclic
 *     distribution.
 * 3.  This version of the program uses MPI_Alltoall to and
 *     a derived datatype to redistribute the data.
 */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

const int RMAX = 100;

int my_rank, comm_sz;
MPI_Comm comm;
MPI_Datatype cyclic_mpi_t;
MPI_Datatype alltoall_mpi_t;


void Usage(char prog_name[]);
int Get_n(int argc, char* argv[]);
void Build_cyclic_type(int n, int loc_n);
void Build_alltoall_type(int n, int loc_n);
void Read_vector(double loc_vec_blk[], int n, int loc_n);
void Gen_vector(double loc_vec_blk[], int n, int loc_n);
void Block_to_cyclic(double loc_vec_blk[], double loc_vec_cyc[], 
      int n, int loc_n);
void Cyclic_to_block(double loc_vec_blk[], double loc_vec_cyc[], 
      int n, int loc_n);
void Print_loc_vecs(char title[], double loc_vec[], int loc_n);
void Print_loc_vecs_int(char title[], int loc_vec[], int loc_n);
void Print_vec_blk(char title[], double loc_vec_blk[], int n, int loc_n);
void Print_vec_cyc(char title[], double loc_vec_blk[], int n, int loc_n);


/*-------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   double *loc_vec_blk, *loc_vec_cyc;
   int n, loc_n;
   double start, finish, elapsed, my_elapsed;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   n = Get_n(argc, argv);
   loc_n = n/comm_sz;
   loc_vec_blk = malloc(loc_n*sizeof(double));
   loc_vec_cyc = malloc(loc_n*sizeof(double));
   Build_cyclic_type(n, loc_n);
   Build_alltoall_type(n, loc_n);

#  ifdef DEBUG
   Read_vector(loc_vec_blk, n, loc_n);
#  else
   Gen_vector(loc_vec_blk, n, loc_n);
#  endif

   Print_loc_vecs("Input vector", loc_vec_blk, loc_n);

   MPI_Barrier(comm);
   start = MPI_Wtime();
   Block_to_cyclic(loc_vec_blk, loc_vec_cyc, n, loc_n);
   finish = MPI_Wtime();
   my_elapsed = finish - start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

   Print_loc_vecs("Cyclic vector", loc_vec_cyc, loc_n);
   Print_vec_cyc("Cyclic vector", loc_vec_cyc, n, loc_n);
   if (my_rank == 0)
      printf("Time to convert block to cyclic = %e seconds\n", elapsed);

   MPI_Barrier(comm);
   start = MPI_Wtime();
   Cyclic_to_block(loc_vec_blk, loc_vec_cyc, n, loc_n);
   finish = MPI_Wtime();
   my_elapsed = finish - start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

   Print_loc_vecs("Block vector", loc_vec_blk, loc_n);
   Print_vec_blk("Block vector", loc_vec_blk, n, loc_n);
   if (my_rank == 0)
      printf("Time to convert cyclic to block = %e seconds\n", elapsed);

   free(loc_vec_blk);
   free(loc_vec_cyc);
   MPI_Type_free(&cyclic_mpi_t);
   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
void Usage(char prog_name[]) {
   fprintf(stderr, "usage:  mpiexec -n <comm_sz> %s <order>\n",
         prog_name);
   fprintf(stderr, "           comm_sz^2 should evenly divide order\n");
}  /* Usage */


/*-------------------------------------------------------------------*/
int Get_n(int argc, char* argv[]) {
   int n;

   if (my_rank == 0) {
      if (argc != 2) {
         n = 0;
         Usage(argv[0]);
      } else {
         n = strtol(argv[1], NULL, 10);
         if (n % (comm_sz*comm_sz) != 0) {
            n = 0;
            Usage(argv[0]);
         }
      }
   }
   MPI_Bcast(&n, 1, MPI_INT, 0, comm);

   if (n == 0) {
      MPI_Finalize();
      exit(0);
   }

   return n;
}  /* Get_n */


/*-------------------------------------------------------------------*/
void Build_cyclic_type(int n, int loc_n) {
   MPI_Datatype vect_mpi_t;

   MPI_Type_vector(loc_n, 1, comm_sz, MPI_DOUBLE, &vect_mpi_t);
   MPI_Type_create_resized(vect_mpi_t, 0, sizeof(double), &cyclic_mpi_t);
   MPI_Type_free(&vect_mpi_t);
   MPI_Type_commit(&cyclic_mpi_t);

}  /* Build_cyclic_type */


/*-------------------------------------------------------------------*/
void Build_alltoall_type(int n, int loc_n) {
   MPI_Datatype vect_mpi_t;

   MPI_Type_vector(loc_n/comm_sz, 1, comm_sz, MPI_DOUBLE, &vect_mpi_t);
   MPI_Type_create_resized(vect_mpi_t, 0, sizeof(double), &alltoall_mpi_t);
   MPI_Type_free(&vect_mpi_t);
   MPI_Type_commit(&alltoall_mpi_t);

}  /* Build_alltoall_type */


/*-------------------------------------------------------------------*/
void Read_vector(double loc_vec_blk[], int n, int loc_n) {
   double* vec = NULL;
   int i;

   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      printf("Enter the vector\n");
      for (i = 0; i < n; i++)
         scanf("%lf", &vec[i]);
      MPI_Scatter(vec, loc_n, MPI_DOUBLE, loc_vec_blk, loc_n, MPI_DOUBLE,
            0, comm);
      free(vec);
   }  else {
      MPI_Scatter(vec, loc_n, MPI_DOUBLE, loc_vec_blk, loc_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Read_vector */


/*-------------------------------------------------------------------*/
void Gen_vector(double loc_vec_blk[], int n, int loc_n) {
   double* vec = NULL;
   int i;

   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      for (i = 0; i < n; i++)
         vec[i] = (double) (i+1);
      MPI_Scatter(vec, loc_n, MPI_DOUBLE, loc_vec_blk, loc_n, MPI_DOUBLE,
            0, comm);
      free(vec);
   }  else {
      MPI_Scatter(vec, loc_n, MPI_DOUBLE, loc_vec_blk, loc_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Gen_vector */


/*-------------------------------------------------------------------*/
void Block_to_cyclic(double loc_vec_blk[], double loc_vec_cyc[], 
      int n, int loc_n) {

   MPI_Alltoall(loc_vec_blk, 1, alltoall_mpi_t, 
                loc_vec_cyc, loc_n/comm_sz, MPI_DOUBLE,
                comm);

}  /* Block_to_cyclic */


/*-------------------------------------------------------------------*/
void Cyclic_to_block(double loc_vec_blk[], double loc_vec_cyc[], 
      int n, int loc_n) {

   MPI_Alltoall(loc_vec_cyc, loc_n/comm_sz, MPI_DOUBLE, 
                loc_vec_blk, 1, alltoall_mpi_t,
                comm);

}  /* Cyclic_to_block */


/*-------------------------------------------------------------------*/
void Print_loc_vecs(char title[], double loc_vec[], int loc_n) {
   double* temp_vec;
   int i, proc;

   if (my_rank == 0) {
      temp_vec = malloc(loc_n*sizeof(double));
      printf("%s:\n", title);
      printf("Proc 0 > ");
      for (i = 0; i < loc_n; i++)
         printf("%.1f ", loc_vec[i]);
      printf("\n");
      for (proc = 1; proc < comm_sz; proc++) {
         MPI_Recv(temp_vec, loc_n, MPI_DOUBLE, proc, 0, comm, 
               MPI_STATUS_IGNORE);
         printf("Proc %d > ", proc);
         for (i = 0; i < loc_n; i++)
            printf("%.1f ", temp_vec[i]);
         printf("\n");
      }
      printf("\n");
      free(temp_vec);
   } else {
      MPI_Send(loc_vec, loc_n, MPI_DOUBLE, 0, 0, comm);
   }
}  /* Print_loc_vecs */

/*-------------------------------------------------------------------*/
void Print_loc_vecs_int(char title[], int loc_vec[], int loc_n) {
   int* temp_vec;
   int i, proc;

   if (my_rank == 0) {
      temp_vec = malloc(loc_n*sizeof(int));
      printf("%s:\n", title);
      printf("Proc 0 > ");
      for (i = 0; i < loc_n; i++)
         printf("%d ", loc_vec[i]);
      printf("\n");
      for (proc = 1; proc < comm_sz; proc++) {
         MPI_Recv(temp_vec, loc_n, MPI_INT, proc, 0, comm, 
               MPI_STATUS_IGNORE);
         printf("Proc %d > ", proc);
         for (i = 0; i < loc_n; i++)
            printf("%d ", temp_vec[i]);
         printf("\n");
      }
      printf("\n");
      free(temp_vec);
   } else {
      MPI_Send(loc_vec, loc_n, MPI_INT, 0, 0, comm);
   }
}  /* Print_loc_vecs_int */

/*-------------------------------------------------------------------*/
void Print_vec_blk(char title[], double loc_vec_blk[], int n, int loc_n) {
   double* vec;
   int i;

   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      MPI_Gather(loc_vec_blk, loc_n, MPI_DOUBLE, vec, loc_n, MPI_DOUBLE,
            0, comm);
      printf("%s: ", title);
      for (i = 0; i < n; i++)
         printf("%.1f ", vec[i]);
      printf("\n\n");
      free(vec);
   } else {
      MPI_Gather(loc_vec_blk, loc_n, MPI_DOUBLE, vec, loc_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Print_vec_blk */


/*-------------------------------------------------------------------*/
void Print_vec_cyc(char title[], double loc_vec_blk[], int n, int loc_n) {
   double* vec;
   int i;

   if (my_rank == 0) {
      vec = malloc(n*sizeof(double));
      MPI_Gather(loc_vec_blk, loc_n, MPI_DOUBLE, vec, 1, cyclic_mpi_t,
            0, comm);
      printf("%s: ", title);
      for (i = 0; i < n; i++)
         printf("%.1f ", vec[i]);
      printf("\n\n");
      free(vec);
   } else {
      MPI_Gather(loc_vec_blk, loc_n, MPI_DOUBLE, vec, loc_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Print_vec_cyc */
