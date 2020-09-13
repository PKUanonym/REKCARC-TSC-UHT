/* File:     ex6.9_mpi_cyclic_allgather.c
 *
 * Purpose:  Compare the performance of MPI_Allgather on a vector of
 *           doubles, when the vector has
 *
 *              1.  A block distribution, and
 *              2.  A cyclic distribution.
 *
 * Compile:  mpicc -g -Wall -I. -o ex6.9_mpi_cyclic_allgather 
 *                 ex6.9_mpi_cyclic_allgather.c
 * Run:      mpiexec -n <comm_sz> ./ex6.9_mpi_cyclic_allgather <m> <iters>
 *              m:  number of elements in local vector
 *              iters:  number of times to execute allgather
 *
 * Input:    none
 * Output:   Average time for block and cyclic allgathers.
 *           With DEBUG compiled, the gathered vector is also printed.
 *
 * IPP:      Exercise 6.9
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h> /* For memset */
#include <mpi.h>

/* Global vars, unchanged after begin set */
int my_rank;
int comm_sz;
MPI_Comm comm;

void Get_args(int argc, char* argv[], int* m_p, int* iters_p);
MPI_Datatype Build_cyclic_type(int n, int local_n);
void Print_loc_array(double x[], int n);

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int m, iters;
   int n, local_n, i;
   double* local_x;
   double* x;
   MPI_Datatype cyclic_mpi_t;
   double start, finish, my_elapsed, elapsed;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   Get_args(argc, argv, &m, &iters);
   local_n = m;
   n = m*comm_sz;
   local_x = malloc(local_n*sizeof(x));
   x = malloc(n*sizeof(x));
   for (i = 0; i < local_n; i++)
      local_x[i] = my_rank;

   cyclic_mpi_t = Build_cyclic_type(n, local_n);

   /* Block allgathers */
   MPI_Barrier(comm);
   start = MPI_Wtime();
   for (i = 0; i < iters; i++) {
      MPI_Allgather(local_x, local_n, MPI_DOUBLE, 
            x, local_n, MPI_DOUBLE, comm);
#     ifdef DEBUG
      if (my_rank == 0) {
         Print_loc_array(x, n);
         memset(x, '0', sizeof(double)*n);
      }
#     endif
   }
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);
   if (my_rank == 0)
      printf("Average elapsed time for block Allgather = %e seconds\n", 
            elapsed/iters);

   /* Cyclic allgathers */
   MPI_Barrier(comm);
   start = MPI_Wtime();
   for (i = 0; i < iters; i++) {
      MPI_Allgather(local_x, local_n, MPI_DOUBLE, 
            x, 1, cyclic_mpi_t, comm);
#     ifdef DEBUG
      if (my_rank == 0) {
         Print_loc_array(x, n);
         memset(x, '0', sizeof(double)*n);
      }
#     endif
   }
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);
   if (my_rank == 0)
      printf("Average elapsed time for cyclic Allgather = %e seconds\n", 
            elapsed/iters);

   MPI_Type_free(&cyclic_mpi_t);
   free(x);
   free(local_x);
   MPI_Finalize();
   return 0;
}  /* main */

/*--------------------------------------------------------------------*/
/* Only called by Process 0 */
void Usage(char prog_name[]) {
   fprintf(stderr, "usage:  mpiexec -n <comm_sz> %s <m> <iters>\n",
         prog_name);
   fprintf(stderr, "   m = number of elements per process\n");
   fprintf(stderr, "   iters = number of iterations in timings\n");
}  /* Usage */


/*--------------------------------------------------------------------*/
void Get_args(
      int       argc     /* in  */,
      char*     argv[]   /* in  */,
      int*      m_p      /* out */, 
      int*      iters_p  /* out */) {
   
   if (my_rank == 0) {
      if (argc != 3) {
         *m_p = 0;
         Usage(argv[0]);
      } else {
         *m_p = strtol(argv[1], NULL, 10);
         *iters_p = strtol(argv[2], NULL, 10);
         if (*m_p <= 0 || *iters_p <= 0) {
            *m_p = 0;
            Usage(argv[0]);
         }
      }
   }
   MPI_Bcast(m_p, 1, MPI_INT, 0, comm);
   if (*m_p == 0) {
      MPI_Finalize();
      exit(0);
   }
   MPI_Bcast(iters_p, 1, MPI_INT, 0, comm);

#  ifdef DEBUG
   printf("Proc %d > m = %d, iters = %d\n", my_rank, *m_p, *iters_p);
#  endif

}  /* Get_args */

/*--------------------------------------------------------------------*/
MPI_Datatype Build_cyclic_type(int n, int local_n) {
   MPI_Datatype temp_mpi_t, temp1_mpi_t;
   MPI_Aint lb, extent;

   MPI_Type_vector(local_n, 1, comm_sz, MPI_DOUBLE, &temp_mpi_t);
   MPI_Type_get_extent(MPI_DOUBLE, &lb, &extent);
   MPI_Type_create_resized(temp_mpi_t, lb, extent, &temp1_mpi_t);
   MPI_Type_commit(&temp1_mpi_t);

   return temp1_mpi_t;

}  /* Build_cyclic_type */

/*--------------------------------------------------------------------*/
void Print_loc_array(double x[], int n) {
   int j;

   printf("x = ");
   for (j = 0; j < n; j++)
      printf("%2.0f ", x[j]);
   printf("\n");
   fflush(stdout);
}  /* Print_loc_array */
