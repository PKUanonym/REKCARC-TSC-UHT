/* File:     cyclic_derived.c
 * Purpose:  Build a derived datatype that can be used in collective
 *           communications of arrays that have a cyclic distribution.
 *           The program reads in an array of ints on 0, distributes it
 *           among the processes, prints the contents of each process'
 *           array, and gathers the array onto 0 and prints it.
 *
 * Compile:  mpicc -g -Wall -o cyclic_derived cyclic_derived.c
 *
 * Run:      mpiexec -n <number of processes> ./cyclic_derived <n>
 *           The global array size, n, should be evenly divisible
 *           by the number of processes.
 *
 * Input:    n element array of ints
 * Output:   The contents of the array on each process
 *           The array after it has been gathered on process 0
 *
 * IPP:  Exercise 6.9 (p. 343)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

/* These aren't modified after initialization. */
/* So it's probably safe to make them global.  */          
int my_rank, comm_sz;
MPI_Comm comm;
MPI_Datatype cyclic_mpi_t;

/* Used as temporary storage on process 0 */
int* scratch = NULL;

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], int* n_p);
void Build_cyclic_mpi_type(int loc_n);
void Get_array(int loc_array[], int n, int loc_n);
void Local_print(int loc_array[], int loc_n);
void Print_loc_arrays(int loc_array[], int n, int loc_n);
void Print_array(int loc_array[], int n, int loc_n);

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int n;                      /* Total number of elements           */
   int loc_n;                  /* Number of elements on each process */
   int* loc_array;             /* Storage on each process for loc_n ints */

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   Get_args(argc, argv, &n);
   loc_n = n/comm_sz;         /* n should be evenly divisible by comm_sz */

   loc_array = malloc(loc_n*sizeof(int));
   if (my_rank == 0) scratch = malloc(n*sizeof(int));
   
   Build_cyclic_mpi_type(loc_n);

   Get_array(loc_array, n, loc_n);
// Local_print(loc_array, loc_n);
// if (my_rank == 0) printf("\n");
   Print_loc_arrays(loc_array, n, loc_n);
   if (my_rank == 0) printf("\n");
   Print_array(loc_array, n, loc_n);

   MPI_Type_free(&cyclic_mpi_t);
   free(loc_array);
   if (my_rank == 0) free(scratch);

   MPI_Finalize();

   return 0;
}  /* main */


/*---------------------------------------------------------------------
 * Function: Usage
 * Purpose:  Print instructions for command-line and exit
 * In arg:   
 *    prog_name:  the name of the program as typed on the command-line
 */
void Usage(char* prog_name) {
   
   fprintf(stderr, "usage: mpiexec -n <number of processes> %s <n>\n", 
         prog_name);
   fprintf(stderr, "   n = number of elements in global array\n");
   fprintf(stderr, "   n should be evenly divisible by comm_sz\n");
    
}  /* Usage */


/*---------------------------------------------------------------------
 * Function:  Get_args
 * Purpose:   Get command line args
 * In args:
 *    argc:            number of command line args
 *    argv:            command line args
 * Out arg:
 *    n_p:             pointer to n, the global number of elements
 */
void Get_args(int argc, char* argv[], int* n_p) {

   if (my_rank == 0) {
      if (argc != 2) {
         Usage(argv[0]);
         *n_p = 0;
      } else {
         *n_p = strtol(argv[1], NULL, 10);
      }
   }
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);

   if (*n_p <= 0) {
      MPI_Finalize();
      exit(0);
   }
}  /* Get_args */

/*---------------------------------------------------------------------
 * Function:         Build_cyclic_mpi_type
 * Purpose:          Build an MPI derived datatype that can be used with
 *                   cyclically distributed data.
 * In arg:
 *    loc_n:         The number of elements assigned to each process
 * Global out:
 *    cyclic_mpi_t:  An MPI datatype that can be used with cyclically
 *                   distributed data
 */
void Build_cyclic_mpi_type(int loc_n) {
   MPI_Datatype temp_mpi_t;
   MPI_Aint lb, extent;

   MPI_Type_vector(loc_n, 1, comm_sz, MPI_INT, &temp_mpi_t);
   MPI_Type_get_extent(MPI_INT, &lb, &extent);
   MPI_Type_create_resized(temp_mpi_t, lb, extent, &cyclic_mpi_t);
   MPI_Type_commit(&cyclic_mpi_t);

}  /* Build_cyclic_mpi_type */


/*---------------------------------------------------------------------
 * Function:      Get_array
 * Purpose:       Read in array of ints on process 0 and distribute
 *                among processes using a cyclic distribution
 * In args:       n:  global number of elements
 *                loc_n:  number of elements sent to each process
 * Out arg:       loc_array:  elements assigned to this process
 * Globals in:    my_rank:  process rank
 *                cyclic_mpi_t:  derived datatype representing
 *                   data going to each process as it's stored
 *                   on process 0
 * Scratch:       scratch:  used to store array on process 0
 *                   when it's read in
 */
void Get_array(int loc_array[], int n, int loc_n) {
   int i;

   if (my_rank == 0) {
      printf("Enter the %d elements of the array\n", n);
      for (i = 0; i < n; i++)
         scanf("%d", &scratch[i]);
   }
   MPI_Scatter(scratch, 1, cyclic_mpi_t, loc_array, loc_n, MPI_INT, 0, comm);
}  /* Get_array */


/*---------------------------------------------------------------------
 * Function:      Local_print
 * Purpose:       Store local array as a string and each process
 *                prints its own array
 * In args:       loc_array:  elements assigned to this process
 *                loc_n:  number of elements sent to each process
 * Globals in:    my_rank:  process rank
 */
void Local_print(int loc_array[], int loc_n) {
   char string[10000];
   int i, offset;

   sprintf(string, "Proc %d > ", my_rank);
   for (i = 0; i < loc_n; i++) {
      offset = strlen(string);
      sprintf(string + offset, "%d ", loc_array[i]);
   }
   printf("%s\n", string);
}  /* Local_print */

/*---------------------------------------------------------------------
 * Function:      Print_loc_arrays
 * Purpose:       Gather local arrays from all processes onto 0
 *                and prints them out.
 * In args:       loc_array:  elements assigned to this process
 *                n:  global number of elements
 *                loc_n:  number of elements sent to each process
 * Globals in:    my_rank:  process rank
 *                cyclic_mpi_t:  derived datatype representing
 *                   data going to each process as it's stored
 *                   on process 0
 * Scratch:       scratch:  used to store contents of global
 *                   array on process 0
 */
void Print_loc_arrays(int loc_array[], int n, int loc_n)  {
   int proc, i;

   MPI_Gather(loc_array, loc_n, MPI_INT, scratch, loc_n, MPI_INT, 0, comm);
   if (my_rank == 0) {
      for (proc = 0; proc < comm_sz; proc++) {
         printf("Proc %d > ", proc);
         for (i = loc_n*proc; i < loc_n*(proc+1); i++)
            printf("%d ", scratch[i]);
         printf("\n");
      }
   }
}  /* Print_loc_arrays */


/*---------------------------------------------------------------------
 * Function:      Print_array
 * Purpose:       Print contents of global array.
 * In args:       loc_array:  elements assigned to this process
 *                n:  global number of elements
 *                loc_n:  number of elements sent to each process
 * Globals in:    my_rank:  process rank
 *                cyclic_mpi_t:  derived datatype representing
 *                   data going to each process as it's stored
 *                   on process 0
 * Scratch:       scratch:  used to store array on process 0
 *                   when it's read in
 */
void Print_array(int loc_array[], int n, int loc_n) {
   int i;

   MPI_Gather(loc_array, loc_n, MPI_INT, scratch, 1, cyclic_mpi_t, 0, comm);
   if (my_rank == 0) {
      printf("Array = ");
      for (i = 0; i < n; i++)
         printf("%d ", scratch[i]);
      printf("\n");
   }
}  /* Print_array */
