/*
 * File:     ex3.28_mpi_odd_even.c
 * Purpose:  Implement parallel odd-even sort of an array of 
 *           nonegative ints.  This version swaps pointers 
 *           after the merges instead of copying the temporary
 *           array into the permanent array.
 *
 * Input:
 *    A:     elements of array (with DEBUG set)
 * Output:
 *    A:     elements of A after sorting (with DEBUG set)
 *    elapsed time for sort
 *
 * Compile:  mpicc -g -Wall -o mpi_odd_even mpi_odd_even.c
 * Run:
 *    mpiexec -n <p> mpi_odd_even <global_n>
 *       - p: the number of processes
 *       - global_n: number of elements in global list
 *
 * Notes:
 * 1.  global_n must be evenly divisible by p
 * 2.  Except for debug output, process 0 does all I/O
 * 3.  Optional -DDEBUG compile flag for verbose output
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

const int RMAX = 1000000;

/* Local functions */
void Usage(char* program);
void Print_list(int local_A[], int local_n, int rank);
void Merge_low(int** local_A_p, int temp_B[], int** temp_C_p, 
         int local_n);
void Merge_high(int** local_A_p, int temp_B[], int** temp_C_p, 
        int local_n);
void Generate_list(int local_A[], int local_n, int my_rank);
int  Compare(const void* a_p, const void* b_p);

/* Functions involving communication */
void Get_args(int argc, char* argv[], int* global_n_p, int* local_n_p, 
         int my_rank, int p, MPI_Comm comm);
void Sort(int local_A[], int local_n, int my_rank, 
         int p, MPI_Comm comm);
void Odd_even_iter(int** temp_A_p, int temp_B[], int** temp_C_p,
         int local_n, int phase, int even_partner, int odd_partner,
         int my_rank, int p, MPI_Comm comm);
void Print_local_lists(int local_A[], int local_n, 
         int my_rank, int p, MPI_Comm comm);
void Print_global_list(int local_A[], int local_n, int my_rank,
         int p, MPI_Comm comm);
void Read_list(int local_A[], int local_n, int my_rank, int p,
         MPI_Comm comm);


/*-------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int my_rank, p;
   int *local_A;
   int global_n;
   int local_n;
   double start, finish, elapsed, my_elapsed;
   MPI_Comm comm;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &p);
   MPI_Comm_rank(comm, &my_rank);

   Get_args(argc, argv, &global_n, &local_n, my_rank, p, comm);
   local_A = (int*) malloc(local_n*sizeof(int));
#  ifdef DEBUG
   Read_list(local_A, local_n, my_rank, p, comm);
#  else
   Generate_list(local_A, local_n, my_rank);
#  endif

#  ifdef DEBUG
   Print_local_lists(local_A, local_n, my_rank, p, comm);
#  endif

   MPI_Barrier(comm);
   start = MPI_Wtime();
   Sort(local_A, local_n, my_rank, p, comm);
   finish = MPI_Wtime();
   my_elapsed = finish-start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

#  ifdef DEBUG
   if (my_rank == 0) printf("Sort finished,  local lists:\n");
   Print_local_lists(local_A, local_n, my_rank, p, comm);
   if (my_rank == 0) printf("\n");
   fflush(stdout);

   Print_global_list(local_A, local_n, my_rank, p, comm);
#  endif
   if (my_rank == 0)
      printf("%e\n", elapsed);

   free(local_A);

   MPI_Finalize();

   return 0;
}  /* main */


/*-------------------------------------------------------------------
 * Function:   Generate_list
 * Purpose:    Fill list with random ints
 * Input Args: local_n, my_rank
 * Output Arg: local_A
 */
void Generate_list(int local_A[], int local_n, int my_rank) {
   int i;

    srandom(my_rank+1);
    for (i = 0; i < local_n; i++)
       local_A[i] = random() % RMAX;

}  /* Generate_list */


/*-------------------------------------------------------------------
 * Function:  Usage
 * Purpose:   Print command line to start program
 * In arg:    program:  name of executable
 * Note:      Purely local, run only by process 0;
 */
void Usage(char* program) {
   fprintf(stderr, "usage:  mpirun -np <p> %s <global_n>\n",
       program);
   fprintf(stderr, "   - p: the number of processes \n");
   fprintf(stderr, "   - global_n: number of elements in global list");
   fprintf(stderr, " (must be evenly divisible by p)\n");
   fflush(stderr);
}  /* Usage */


/*-------------------------------------------------------------------
 * Function:    Get_args
 * Purpose:     Get and check command line arguments
 * Input args:  argc, argv, my_rank, p, comm
 * Output args: global_n_p, local_n_p
 */
void Get_args(int argc, char* argv[], int* global_n_p, int* local_n_p, 
         int my_rank, int p, MPI_Comm comm) {

   if (my_rank == 0) {
      if (argc != 2) {
         Usage(argv[0]);
         *global_n_p = -1;  /* Bad args, quit */
      } else {
         *global_n_p = atoi(argv[1]);
         if (*global_n_p % p != 0) {
            Usage(argv[0]);
            *global_n_p = -1;
         }
     }
   }  /* my_rank == 0 */

   MPI_Bcast(global_n_p, 1, MPI_INT, 0, comm);

   if (*global_n_p <= 0) {
      MPI_Finalize();
      exit(-1);
   }

   *local_n_p = *global_n_p/p;
#  ifdef DEBUG
   printf("Proc %d > global_n = %d, local_n = %d\n",
      my_rank, *global_n_p, *local_n_p);
   fflush(stdout);
#  endif

}  /* Get_args */


/*-------------------------------------------------------------------
 * Function:   Read_list
 * Purpose:    process 0 reads the list from stdin and scatters it
 *             to the other processes.
 * In args:    local_n, my_rank, p, comm
 * Out arg:    local_A
 */
void Read_list(int local_A[], int local_n, int my_rank, int p,
         MPI_Comm comm) {
   int i;
   int *temp = NULL;

   if (my_rank == 0) {
      temp = (int*) malloc(p*local_n*sizeof(int));
      printf("Enter the elements of the list\n");
      for (i = 0; i < p*local_n; i++)
         scanf("%d", &temp[i]);
   } 

   MPI_Scatter(temp, local_n, MPI_INT, local_A, local_n, MPI_INT,
       0, comm);

   if (my_rank == 0)
      free(temp);
}  /* Read_list */


/*-------------------------------------------------------------------
 * Function:   Print_global_list
 * Purpose:    Print the contents of the global list A
 * Input args:  
 *    n, the number of elements 
 *    A, the list
 * Note:       Purely local, called only by process 0
 */
void Print_global_list(int local_A[], int local_n, int my_rank, int p, 
      MPI_Comm comm) {
   int* A = NULL;
   int i, n;

   if (my_rank == 0) {
      n = p*local_n;
      A = (int*) malloc(n*sizeof(int));
      MPI_Gather(local_A, local_n, MPI_INT, A, local_n, MPI_INT, 0,
            comm);
      printf("Global list:\n");
      for (i = 0; i < n; i++)
         printf("%d ", A[i]);
      printf("\n\n");
      free(A);
   } else {
      MPI_Gather(local_A, local_n, MPI_INT, A, local_n, MPI_INT, 0,
            comm);
   }

}  /* Print_global_list */

/*-------------------------------------------------------------------
 * Function:    Compare
 * Purpose:     Compare 2 ints, return -1, 0, or 1, respectively, when
 *              the first int is less than, equal, or greater than
 *              the second.  Used by qsort.
 */
int Compare(const void* a_p, const void* b_p) {
   int a = *((int*)a_p);
   int b = *((int*)b_p);

   if (a < b)
      return -1;
   else if (a == b)
      return 0;
   else /* a > b */
      return 1;
}  /* Compare */


/*-------------------------------------------------------------------
 * Function:    Sort
 * Purpose:     Sort local list, use odd-even sort to sort
 *              global list.
 * Input args:  local_n, my_rank, p, comm
 * In/out args: local_A 
 */
void Sort(int local_A[], int local_n, int my_rank, 
         int p, MPI_Comm comm) {
   int phase;
   int *temp_A = local_A, *temp_B, *temp_C, *t_C;
   int even_partner;  /* phase is even or left-looking */
   int odd_partner;   /* phase is odd or right-looking */

   /* Temporary storage used in merge-split */
   temp_B = (int*) malloc(local_n*sizeof(int));
   t_C = (int*) malloc(local_n*sizeof(int));
   temp_C = t_C;

   /* Find partners:  negative rank => do nothing during phase */
   if (my_rank % 2 != 0) {
      even_partner = my_rank - 1;
      odd_partner = my_rank + 1;
      if (odd_partner == p) odd_partner = MPI_PROC_NULL;  // Idle during odd phase
   } else {
      even_partner = my_rank + 1;
      if (even_partner == p) even_partner = MPI_PROC_NULL;  // Idle during even phase
      odd_partner = my_rank-1;  
   }

   /* Sort local list using built-in quick sort */
   qsort(local_A, local_n, sizeof(int), Compare);

#  ifdef DEBUG
   printf("Proc %d > Before loop, temp_A = %p, temp_B = %p, temp_C = %p\n", 
         my_rank, temp_A, temp_B, temp_C);
   fflush(stdout);
   MPI_Barrier(comm);
#  endif

   for (phase = 0; phase < p; phase++) {
      Odd_even_iter(&temp_A, temp_B, &temp_C, local_n, phase, 
             even_partner, odd_partner, my_rank, p, comm);
#     ifdef DEBUG
      if (my_rank == 0) printf("\nAfter phase %d:\n", phase);
      if (my_rank == 0) printf("   temp_A:\n");
      Print_local_lists(temp_A, local_n, my_rank, p, comm);
      if (my_rank == 0) printf("   temp_B:\n");
      Print_local_lists(temp_B, local_n, my_rank, p, comm);
      if (my_rank == 0) printf("   temp_C:\n");
      Print_local_lists(temp_C, local_n, my_rank, p, comm);
#     endif
   }
#  ifdef DEBUG
   printf("Proc %d > After phase %d, t_A = %p, t_B = %p, t_C = %p\n", 
         my_rank, phase, temp_A, temp_B, temp_C);
   fflush(stdout);
   MPI_Barrier(comm);
#  endif
   if (local_A != temp_A) memcpy(local_A, temp_A, local_n*sizeof(int));

   free(temp_B);
   free(t_C);
}  /* Sort */


/*-------------------------------------------------------------------
 * Function:    Odd_even_iter
 * Purpose:     One iteration of Odd-even transposition sort
 * In args:     local_n, phase, my_rank, p, comm
 * In/out args: local_A_p
 * Scratch:     temp_B, temp_C_p
 */
void Odd_even_iter(int** temp_A_p, int temp_B[], int** temp_C_p,
        int local_n, int phase, int even_partner, int odd_partner,
        int my_rank, int p, MPI_Comm comm) {
   MPI_Status status;

   if (phase % 2 == 0) {
      if (even_partner >= 0) {
         MPI_Sendrecv(*temp_A_p, local_n, MPI_INT, even_partner, 0, 
            temp_B, local_n, MPI_INT, even_partner, 0, comm,
            &status);
         if (my_rank % 2 != 0)
            Merge_high(temp_A_p, temp_B, temp_C_p, local_n);
         else
            Merge_low(temp_A_p, temp_B, temp_C_p, local_n);
      }
   } else { /* odd phase */
      if (odd_partner >= 0) {
         MPI_Sendrecv(*temp_A_p, local_n, MPI_INT, odd_partner, 0, 
            temp_B, local_n, MPI_INT, odd_partner, 0, comm,
            &status);
         if (my_rank % 2 != 0)
            Merge_low(temp_A_p, temp_B, temp_C_p, local_n);
         else
            Merge_high(temp_A_p, temp_B, temp_C_p, local_n);
      }
   }
}  /* Odd_even_iter */


/*-------------------------------------------------------------------
 * Function:    Merge_low
 * Purpose:     Merge the smallest local_n elements in my_keys
 *              and recv_keys into temp_keys.  Then copy temp_keys
 *              back into my_keys.
 * In args:     local_n, recv_keys
 * In/out args: my_keys
 * Scratch:     temp_keys
 */
void Merge_low(
      int**  my_keys_p,     /* in/out    */
      int    recv_keys[],   /* in        */
      int**  temp_keys_p,   /* scratch   */
      int    local_n        /* = n/p, in */) {
   int m_i, r_i, t_i;
   int* my_keys = *my_keys_p;
   int* temp_keys = *temp_keys_p;
   
   m_i = r_i = t_i = 0;
   while (t_i < local_n) {
      if (my_keys[m_i] <= recv_keys[r_i]) {
         temp_keys[t_i] = my_keys[m_i];
         t_i++; m_i++;
      } else {
         temp_keys[t_i] = recv_keys[r_i];
         t_i++; r_i++;
      }
   }

   *my_keys_p = temp_keys;
   *temp_keys_p = my_keys;
}  /* Merge_low */

/*-------------------------------------------------------------------
 * Function:    Merge_high
 * Purpose:     Merge the largest local_n elements in local_A 
 *              and temp_B into temp_C.  Then copy temp_C
 *              back into local_A.
 * In args:     local_n, temp_B
 * In/out args: local_A
 * Scratch:     temp_C
 */
void Merge_high(int** local_A_p, int temp_B[], int** temp_C_p, 
        int local_n) {
   int ai, bi, ci;
   int* my_keys = *local_A_p;
   int* temp_keys = *temp_C_p;
   
   ai = local_n-1;
   bi = local_n-1;
   ci = local_n-1;
   while (ci >= 0) {
      if (my_keys[ai] >= temp_B[bi]) {
         temp_keys[ci] = my_keys[ai];
         ci--; ai--;
      } else {
         temp_keys[ci] = temp_B[bi];
         ci--; bi--;
      }
   }

   *local_A_p = temp_keys;
   *temp_C_p = my_keys;
}  /* Merge_high */


/*-------------------------------------------------------------------
 * Only called by process 0
 */
void Print_list(int local_A[], int local_n, int rank) {
   int i;
   printf("%d: ", rank);
   for (i = 0; i < local_n; i++)
      printf("%d ", local_A[i]);
   printf("\n");
}  /* Print_list */


/*-------------------------------------------------------------------
 * Function:   Print_local_lists
 * Purpose:    Print each process' current list contents
 * Input args: all
 * Notes:
 * 1.  Assumes all participating processes are contributing local_n 
 *     elements
 */
void Print_local_lists(int local_A[], int local_n, 
         int my_rank, int p, MPI_Comm comm) {
   int*       A;
   int        q;
   MPI_Status status;

   if (my_rank == 0) {
      A = (int*) malloc(local_n*sizeof(int));
      Print_list(local_A, local_n, my_rank);
      for (q = 1; q < p; q++) {
         MPI_Recv(A, local_n, MPI_INT, q, 0, comm, &status);
         Print_list(A, local_n, q);
      }
      free(A);
   } else {
      MPI_Send(local_A, local_n, MPI_INT, 0, 0, comm);
   }
}  /* Print_local_lists */
