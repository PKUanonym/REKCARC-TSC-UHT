/* File:       
 *    ex3.12a_mpi_ringpass_allreduce.c
 *
 * Purpose:
 *    Implement allreduce using a ringpass.  Compare its performance
 *    to a butterfly structured allreduce.
 *
 * Compile:    
 *    mpicc -g -Wall -o ex3.12a_mpi_ringpass_allreduce 
 *          ex3.12a_mpi_ringpass_allreduce.c
 * Run:        
 *    mpiexec -n <number of processes> ./ex3.12a_mpi_ringpass_allreduce
 *
 * Input:
 *    None
 * Output:
 *    Initial elements on each process
 *    Results of global sums and elapsed times
 *
 * Note:  The number of processes should be a power of 2
 *
 * IPP:  Exercise 3.12a
 */


#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

const int MAX_CONTRIB = 20;

int my_rank, comm_sz;
MPI_Comm comm;

void Print_results(char title[], int value);
int Global_sum_rp(int my_val);
int Global_sum_bf(int my_val);

int main(void) {
   int x, sum;
   double start, finish, my_elapsed, elapsed;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
      
   srandom(my_rank);
   x = random() % MAX_CONTRIB;
   
   Print_results("Process Values", x);

   MPI_Barrier(comm);
   start = MPI_Wtime();
   sum = Global_sum_rp(x);
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);
   if (my_rank == 0)
      printf("Elapsed time for ring pass = %e seconds\n", finish-start );
   Print_results("Process Sums using ring pass", sum);
   
   MPI_Barrier(comm);
   start = MPI_Wtime();
   sum = Global_sum_bf(x);
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);
   if (my_rank == 0)
      printf("Elapsed time for butterfly = %e seconds\n", finish-start );
   Print_results("Process Sums using butterfly", sum);

   MPI_Finalize();
   return 0;
}  /* main */

/*-------------------------------------------------------------------*/
void Print_results(char title[], int value) {
   int* vals = NULL;
   int q;
   
   if (my_rank == 0){
      vals = malloc(comm_sz*sizeof(int));
      MPI_Gather(&value, 1, MPI_INT, vals, 1, MPI_INT, 0, comm);
      printf("%s: \n", title);
      for (q = 0 ; q < comm_sz ; q++) {
         printf("proc %d > %d\n", q, vals[q]);
      }
      printf("\n");
      free(vals);
   } else {
      MPI_Gather(&value, 1, MPI_INT, vals, 1, MPI_INT, 0, comm);
   }
}  /* Print_results */

/*-------------------------------------------------------------------*/
int Global_sum_rp(int my_val) {
   int source, dest, i;
   int sum = my_val;
   int temp_val = my_val;
   
   source = (my_rank + comm_sz - 1) % comm_sz;
   dest = (my_rank + 1) % comm_sz;
   
   for (i = 1; i < comm_sz ; i++) {
      MPI_Sendrecv_replace(&temp_val, 1, MPI_INT, dest, 0, 
            source, 0, comm, MPI_STATUS_IGNORE);
      sum += temp_val;
   }
   
   return sum;
}  /* Global_sum_rp */


/*-------------------------------------------------------------------*/
int Global_sum_bf(int my_val) {
   int temp, sum = my_val;
   int partner;
   unsigned mask = 1;
   
   while (mask < comm_sz) {
      partner = my_rank ^ mask;
      MPI_Sendrecv(&sum,  1, MPI_INT, partner, 0,
                   &temp, 1, MPI_INT, partner, 0,
                   comm, MPI_STATUS_IGNORE);
      sum += temp;
      mask <<= 1;
   }
   return sum;
}  /* Global_sum_bf */
