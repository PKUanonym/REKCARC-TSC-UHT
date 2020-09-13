/* File:     ex6.11_mpi_in_place.c
 *
 * Purpose:  Compare the performance of MPI_Allgather using MPI_IN_PLACE
 *           with the performance of MPI_Allgather using separate
 *           send and receive buffers.
 *
 * Compile:  mpicc -g -Wall -o ex6.11_mpi_in_place ex6.11_mpi_in_place.c
 * Run:      mpiexec -n <p> <per process> <iters>
 *              per process = number of elements per process
 *              iters = number of iterations of allgather to use
 *
 * Input:    None
 * Output:   Elapsed total time for each of the two allgathers.  If DEBUG
 *           is set, results of each allgather on each process.
 *
 * IPP:      Exercise 6.11
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

int comm_sz, my_rank;
MPI_Comm comm;

void Get_input(int argc, char* argv[], int* per_proc_p, int* iters_p);
void Two_buffers(int z[], int x[], int n, int per_proc, int iters);
void In_place(int x[], int n, int per_proc, int iters);

int main(int argc, char* argv[]) {
   int *x, *y, *z;
   int per_proc, n, iters, i;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   Get_input(argc, argv, &per_proc, &iters);

   n = comm_sz*per_proc;
   x = malloc(n*sizeof(int));
   y = x + my_rank*per_proc;
   z = malloc(per_proc*sizeof(int));
   for (i = 0; i < per_proc; i++) {
      z[i] = my_rank + 2;
   }

   Two_buffers(z, x, n, per_proc, iters);

   printf("\n");
   for (i = 0; i < per_proc; i++) {
      y[i] = my_rank + 1;
   }
   In_place(x, n, per_proc, iters);

   free(x);
   free(z);

   MPI_Finalize();
   return 0;
}  /* main */

/*---------------------------------------------------------------------
 * Get_input
 */
void Get_input(int argc, char* argv[], int* per_proc_p, int* iters_p) {

   if (my_rank == 0) {
      if (argc != 3) {
         fprintf(stderr, "usage:  mpiexec -n <p> %s <per process> <iters>\n",
               argv[0]);
         *per_proc_p = *iters_p = 0;
      } else {
         *per_proc_p = strtol(argv[1],NULL,10);
         *iters_p = strtol(argv[2],NULL,10);
      }
   }

   MPI_Bcast(per_proc_p, 1, MPI_INT, 0, comm);
   MPI_Bcast(iters_p, 1, MPI_INT, 0, comm);

   if (*per_proc_p == 0) {
      MPI_Finalize();
      exit(0);
   }
}  /* Get_input */


/*---------------------------------------------------------------------
 * Two_buffers
 */
void Two_buffers(int z[], int x[], int n, int per_proc, int iters) {
   int i, j;
   double start, finish, elapsed, my_elapsed;
#  ifdef DEBUG
   char string[1000];
#  endif

   MPI_Barrier(comm);
   start = MPI_Wtime();
   for (i = 0; i < iters; i++) {
      MPI_Allgather(z, per_proc, MPI_INT,
         x, per_proc, MPI_INT, comm);
#     ifdef DEBUG
      sprintf(string, "Proc %d > ", my_rank);
      for (j = 0; j < n; j++)
         sprintf(string + strlen(string), "%d ", x[j]);
      printf("%s\n", string);
#     endif
   }
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

   if (my_rank == 0)
      printf("Elapsed for two buffers = %e secs\n", elapsed);
}  /* Two_buffers */


/*---------------------------------------------------------------------
 * In_place
 */
void In_place(int x[], int n, int per_proc, int iters) {
   int i, j;
   double start, finish, elapsed, my_elapsed;
#  ifdef DEBUG
   char string[1000];
#  endif

   MPI_Barrier(comm);
   start = MPI_Wtime();
   for (i = 0; i < iters; i++) {
      MPI_Allgather(MPI_IN_PLACE, per_proc, MPI_INT,
         x, per_proc, MPI_INT, comm);
#     ifdef DEBUG
      sprintf(string, "Proc %d > ", my_rank);
      for (j = 0; j < n; j++)
         sprintf(string + strlen(string), "%d ", x[j]);
      printf("%s\n", string);
#     endif
   }
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

   if (my_rank == 0)
      printf("Elapsed for in place = %e secs\n", elapsed);
}  /* In_place */
