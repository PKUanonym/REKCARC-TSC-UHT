/* File:     ex3.7_mpi_coll_one_proc.c
 *
 * Purpose:  Test some MPI collective communications when the communicator
 *           contains 1 process.
 *
 * Compile:  mpicc -g -Wall -o ex3.7_mpi_coll_one_proc ex3.7_mpi_coll_one_proc.c
 * Run:      mpiexec -n 1 ./ex3.7_mpi_coll_one_proc
 *
 * Input:    none
 * Output:   Results of various ops
 *
 * Note:     This program should only be run with one process
 *
 * IPP:      Exercise 3.7
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"

const int n = 4;

void Set_buf(int x[], int n);
void Print_buf(char title[], int x[], int n);

int main(void) {
   int p, my_rank;
   MPI_Comm comm;
   int x[n], y[n];

   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &p);
   MPI_Comm_rank(comm, &my_rank);
   if (p > 1) {
      if (my_rank == 0)
         fprintf(stderr, "Only run with one process\n");
      MPI_Finalize();
      exit(0);
   }


   Set_buf(x, n);
   MPI_Bcast(x, n, MPI_INT, 0, comm);
   Print_buf("After bcast x = ", x, n);

   Set_buf(x, n);
   memset(y, 0, n*sizeof(int));
   MPI_Gather(x, n, MPI_INT, y, n, MPI_INT, 0, comm);
   Print_buf("After gather y = ", y, n);

   memset(y, 0, n*sizeof(int));
   Set_buf(x, n);
   MPI_Scatter(x, n, MPI_INT, y, n, MPI_INT, 0, comm);
   Print_buf("After scatter y = ", y, n);

   Set_buf(x, n);
   memset(y, 0, n*sizeof(int));
   MPI_Allgather(x, n, MPI_INT, y, n, MPI_INT, comm);
   Print_buf("After Allgather y = ", y, n);

   Set_buf(x, n);
   memset(y, 0, n*sizeof(int));
   MPI_Reduce(x, y, n, MPI_INT, MPI_SUM, 0, comm);
   Print_buf("After reduce y = ", y, n);

   Set_buf(x, n);
   memset(y, 0, n*sizeof(int));
   MPI_Allreduce(x, y, n, MPI_INT, MPI_SUM, comm);
   Print_buf("After Allreduce y = ", y, n);

   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
void Set_buf(int x[], int n) {
   int i;

   for (i = 0; i < n; i++)
      x[i] = i+1;
}  /* Set_buf */


/*-------------------------------------------------------------------*/
void Print_buf(char title[], int x[], int n) {
   int i;

   printf("%s ", title);
   for (i = 0; i < n; i++)
      printf("%d ", x[i]);
   printf("\n");
}  /* Print_buf */
