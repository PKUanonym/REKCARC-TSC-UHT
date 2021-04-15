/* File:     mpi_many_msgs.c
 * Purpose:  Compare the time needed to send n messages consisting of
 *           a single double each with the time needed to send one message
 *           consisting of n doubles.
 *
 * Compile:  mpicc -g -Wall -O2 -o mpi_many_msgs mpi_many_msgs.c
 * Run:      mpiexec -n 2 mpi_many_msgs <number of doubles>
 *
 * Input:    none
 * Output:   Elapsed time for n messages of size 1 double and elapsed
 *           time for 1 message of n doubles
 *
 * IPP:      Section 3.5 (pp. 116 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int      my_rank;
int      comm_sz;
MPI_Comm comm;

void Get_arg(int argc, char* argv[], int* n_p);

int main(int argc, char* argv[]) {
   double*     x;
   int         i, n;
   MPI_Status  status;
   double      start, finish;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   Get_arg(argc, argv, &n);

   x = malloc(n*sizeof(double));

   if (my_rank == 0)
      for (i = 0; i < n; i++) x[i] = i;
   else /* my_rank == 1 */
      for (i = 0; i < n; i++) x[i] = -1;

   MPI_Barrier(comm);
   start = MPI_Wtime();
   if (my_rank == 0) 
      for (i = 0; i < n; i++)
         MPI_Send(&x[i], 1, MPI_DOUBLE, 1, 0, comm);
   else /* my_rank == 1 */
      for (i = 0; i < n; i++)
         MPI_Recv(&x[i], 1, MPI_DOUBLE, 0, 0, comm, &status);
   finish = MPI_Wtime();
   printf("Proc %d > First comm took %e seconds\n", my_rank,
         finish-start);
   fflush(stdout);

   MPI_Barrier(comm);
   start = MPI_Wtime();
   if (my_rank == 0)
      MPI_Send(x, n, MPI_DOUBLE, 1, 0, comm);
   else  /* my_rank == 1 */
      MPI_Recv(x, n, MPI_DOUBLE, 0, 0, comm, &status);
   finish = MPI_Wtime();
   printf("Proc %d > Second comm took %e seconds\n", my_rank,
         finish-start);
   fflush(stdout);

   free(x);
   MPI_Finalize();
   return 0;
}  /* main */

/*-------------------------------------------------------------------*/
void Get_arg(
      int   argc   /* in  */, 
      char* argv[] /* out */, 
      int*  n_p    /* out */) {

   if (my_rank == 0) {
      if (argc != 2 || comm_sz != 2) {
         fprintf(stderr, "usage:  mpiexec -n 2 %s <number of doubles>\n",
               argv[0]);
         *n_p = 0;
      } else {
         *n_p = strtol(argv[1], NULL, 10);
      }
   }
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   if (*n_p <= 0 || comm_sz != 2) {
      MPI_Finalize();
      exit(0);
   }
}  /* Get_arg */
