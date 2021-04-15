/*
 * File:     prog3.8_mpi_mergesort.c
 * Purpose:  Implement merge sort of an array of nonnegative ints
 *
 * Compile:
 *    mpicc -g -Wall -o prog3.8_mpi_mergesort prog3.8_mpi_mergesort.c
 *
 * Usage:
 *    mpiexec -n <p> prog3.8_mpi_mergesort <g|i> <global_n> 
 *       - p: the number of processes
 *       - 'g': generate random, distributed list
 *       - 'i': user will input list on process 0
 *       - global_n: number of elements in global list
 *
 * Input:
 *    A:     elements of array (optional)
 * Output:
 *    A:     elements of A after sorting
 *
 * Notes:
 * 1.  global_n must be evenly divisible by p
 * 2.  Except for debug output, process 0 does all I/O
 * 3.  p should be a power of 2
 * 4.  Optional -DDEBUG compile flag for verbose output
 *
 * IPP:   Programming Assignment 3.8
 */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define RMAX 100

/* Local functions */
void Usage(char* program);
void Init_list(int local_A[], int n);
void Print_global_list(int global_A[], int global_n);
void Print_list(int local_A[], int local_n, int rank);
void Merge(int local_A[], int local_B[], int* local_n_p);
void Generate_list(int local_A[], int local_n, int my_rank);
int  Compare(const void* a_p, const void* b_p);

/* Functions involving communication */
void Get_args(int argc, char* argv[], int* global_n_p, int* local_n_p, 
         char* gi_p, int my_rank, int p, MPI_Comm comm);
void Sort(int local_A[], int global_n, int* local_n_p, int my_rank, 
         int p, MPI_Comm comm);
void Print_local_lists(int local_A[], int local_n, unsigned bitmask,
         int my_rank, int p, MPI_Comm comm);
void Read_list(int local_A[], int local_n, int my_rank, int p,
         MPI_Comm comm);


/*-------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int my_rank, p;
   char g_i;
   int *local_A;
   int global_n;
   int local_n;
   MPI_Comm comm;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &p);
   MPI_Comm_rank(comm, &my_rank);

   Get_args(argc, argv, &global_n, &local_n, &g_i, my_rank, p, comm);
   local_A = (int*) malloc(global_n*sizeof(int));
   Init_list(local_A, global_n);
   if (g_i == 'g') {
      Generate_list(local_A, local_n, my_rank);
      Print_local_lists(local_A, local_n, 0, my_rank, p, comm);
   } else {
      Read_list(local_A, local_n, my_rank, p, comm);
#     ifdef DEBUG
      Print_local_lists(local_A, local_n, 0, my_rank, p, comm);
#     endif
   }

   Sort(local_A, global_n, &local_n, my_rank, p, comm);

   if (my_rank == 0)
      Print_global_list(local_A, global_n);

   free(local_A);

   MPI_Finalize();

   return 0;
}  /* main */

/*-------------------------------------------------------------------
 * Function:   Init_list
 * Purpose:    Initialize list A to list of -1's
 * Input arg:  n
 * Output arg: A
 * Note:       Purely local, run by each process
 */
void Init_list(int A[], int n) {
   int i;

   for (i = 0; i < n; i++)
      A[i] = -1;

}  /* Init_list */


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
   fprintf(stderr, "usage:  mpiexec -n <p> %s <g|i> <global_n>\n",
       program);
   fprintf(stderr, "   - p: the number of processes (a power of 2)\n");
   fprintf(stderr, "   - 'g': generate random, distributed list\n");
   fprintf(stderr, "   - 'i': user will input list on process 0\n");
   fprintf(stderr, "   - global_n: number of elements in global list");
   fprintf(stderr, " (must be evenly divisible by p)\n");
   fflush(stderr);
}  /* Usage */


/*-------------------------------------------------------------------
 * Function:    Get_args
 * Purpose:     Get and check command line arguments
 * Input args:  argc, argv, my_rank, p, comm
 * Output args: global_n_p, local_n_p, gi_p
 */
void Get_args(int argc, char* argv[], int* global_n_p, int* local_n_p, 
         char* gi_p, int my_rank, int p, MPI_Comm comm) {

   if (my_rank == 0) {
      if (argc != 3) {
         Usage(argv[0]);
         *global_n_p = -1;  /* Bad args, quit */
      } else {
         *gi_p = argv[1][0];
         if (*gi_p != 'g' && *gi_p != 'i') {
            Usage(argv[0]);
            *global_n_p = -1;  /* Bad args, quit */
         } else {
            *global_n_p = atoi(argv[2]);
            if (*global_n_p % p != 0)
               Usage(argv[0]);
         }
      }
   }  /* my_rank == 0 */

   MPI_Bcast(gi_p, 1, MPI_CHAR, 0, comm);
   MPI_Bcast(global_n_p, 1, MPI_INT, 0, comm);

   if ( (*global_n_p <= 0) || (*global_n_p % p != 0) ) {
      MPI_Finalize();
      exit(-1);
   }

   *local_n_p = *global_n_p/p;
#  ifdef DEBUG
   printf("Proc %d > gi = %c, global_n = %d, local_n = %d\n",
      my_rank, *gi_p, *global_n_p, *local_n_p);
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
   int *temp;

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
void Print_global_list(int A[], int n) {
   int i;

   printf("The list is:\n   ");
   for (i = 0; i < n; i++) 
      printf("%d ", A[i]);
   printf("\n");
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
 * Purpose:     Sort local list, merge local list with other lists
 *              using tree structured communication
 * Input args:  global_n, my_rank, p, comm
 * In/out args: local_A, local_n_p
 * Notes:       local_n_p tracks the size of local_A, which doubles
 *              with each iteration
 */
void Sort(int local_A[], int global_n, int* local_n_p, int my_rank, 
         int p, MPI_Comm comm) {
   int        partner;
   int        done = 0;
   unsigned   bitmask = 1;
   MPI_Status status;

   /* Sort local list using built-in quick sort */
   qsort(local_A, *local_n_p, sizeof(int), Compare);

   while (!done && bitmask < p) {
      partner = my_rank ^ bitmask;
#     ifdef DEBUG
      printf("Proc %d > partner = %d, bitmask = %d\n", 
            my_rank, partner, bitmask);
#     endif
      if (my_rank < partner) {
         MPI_Recv(local_A + *local_n_p, *local_n_p, MPI_INT,
            partner, 0, comm, &status);
         /* Note that *local_n_p is updated by Merge */
         Merge(local_A, local_A + *local_n_p, local_n_p); 
#        ifdef DEBUG
         Print_local_lists(local_A, *local_n_p, bitmask, my_rank, p, comm);
#        endif
         bitmask <<= 1;
      } else {
         MPI_Send(local_A, *local_n_p, MPI_INT, partner, 0, comm);
         done = 1;
      }
  }  /* while */
}  /* Sort */


/*-------------------------------------------------------------------
 * Function:    Merge
 * Purpose:     Merge the sorted lists in local_A and local_B, each
 *              of which has size *local_n_p.  Sorted list returned
 *              returned in local_A, local_B overwritten, local_n_p
 *              doubled in size.
 * In/out args: all
 * Notes:
 * 1.  local_A is a pointer to a list of length
 *     at least 2*(*local_n_p)
 * 2.  local_B points to local_A+*local_n_p.  So it is overwritten
 *     when the sorted list is copied into local_A.
 * 3.  On return, local_n_p points to an int storing the new length
 *     of local_A -- twice the length of the input local_A.
 */
void Merge(int local_A[], int local_B[], int* local_n_p) {
   int ai, bi, ci, i;
   int *C;
   int csize = 2*(*local_n_p);
   
   C = (int*) malloc(csize*sizeof(int));
   ai = 0;
   bi = 0;
   ci = 0;
   while ((ai < *local_n_p) && (bi < *local_n_p)) {
      if (local_A[ai] <= local_B[bi]) {
         C[ci] = local_A[ai];
         ci++; ai++;
      } else {
         C[ci] = local_B[bi];
         ci++; bi++;
      }
   }

   if (ai >= *local_n_p)
      for (i = ci; i < csize; i++, bi++)
         C[i] = local_B[bi];
   else if (bi >= *local_n_p)
      for (i = ci; i < csize; i++, ai++)
         C[i] = local_A[ai];

   for (i = 0; i < csize; i++)
      local_A[i] = C[i];

   free(C);
   *local_n_p = 2*(*local_n_p);
   
}  /* merge */

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
 * 2.  bitmask is 0 if all the processes in comm are involved,
 *     otherwise set increment = 2*bitmask, and processes
 *        0, increment, 2*increment, 3*increment, . . .
 *     participate
 */
void Print_local_lists(int local_A[], int local_n, unsigned bitmask, 
         int my_rank, int p, MPI_Comm comm) {
   int*       A;
   int        q;
   MPI_Status status;
   int        increment;

   if (bitmask == 0)
      increment = 1;
   else
      increment = 2*bitmask;

   if (my_rank == 0) {
      A = (int*) malloc(local_n*sizeof(int));
      Print_list(local_A, local_n, my_rank);
      for (q = increment; q < p; q += increment) {
         MPI_Recv(A, local_n, MPI_INT, q, 0, comm, &status);
         Print_list(A, local_n, q);
      }
      free(A);
   } else {
      MPI_Send(local_A, local_n, MPI_INT, 0, 0, comm);
   }
}  /* Print_local_lists */
