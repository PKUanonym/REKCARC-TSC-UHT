/* File:       
 *    ex3.12b_mpi_ringpass_prefix.c
 *
 * Purpose:
 *    Implement prefix sums using a ringpass.  
 *
 * Compile:    
 *    mpicc -g -Wall -o ex3.12b_mpi_ringpass_prefix
 *          ex3.12b_mpi_ringpass_prefix.c
 * Run:        
 *    mpiexec -n <number of processes> ./ex3.12b_mpi_ringpass_prefix
 *
 * Input:
 *    None
 * Output:
 *    Initial elements on each process
 *    Prefix sums
 *
 * IPP:  Exercise 3.12b
 */


#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

const int MAX_CONTRIB = 20;

int my_rank, comm_sz;
MPI_Comm comm;

void Print_results(char title[], int value);
int Prefix_sums(int my_val);

int main(void) {
   int my_x, my_sum;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
      
   srandom(my_rank);
   my_x = random() % MAX_CONTRIB;
   
   Print_results("Process Values", my_x);

   my_sum = Prefix_sums(my_x);
   Print_results("Prefix Sums", my_sum);
   
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
int Prefix_sums(int my_val) {
   int source, dest, i;
   int my_sum = my_val;
   int temp_val = my_val;
   
   source = (my_rank + comm_sz - 1) % comm_sz;
   dest = (my_rank + 1) % comm_sz;
   
   for (i = 1; i < comm_sz; i++) {
      if (i > dest) temp_val = 0; 
#     ifdef DEBUG
      printf("Proc %d > i = %d, sending %d\n", my_rank, i, temp_val);
#     endif
      MPI_Sendrecv_replace(&temp_val, 1, MPI_INT, dest, 0, 
            source, 0, comm, MPI_STATUS_IGNORE);
#     ifdef DEBUG
      printf("Proc %d > i = %d, received %d\n", my_rank, i, temp_val);
#     endif
      my_sum += temp_val;
   }
   
   return my_sum;
}  /* Prefix_sums */
