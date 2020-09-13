/* File:     prog3.9b_mpi_redist.c
 *
 * Purpose:  Convert data that has a block distribution to data that has
 *           a cyclic distribution and vice versa
 *
 * Compile:  mpicc -g -Wall -o prog3.9b_mpi_redist prog3.9b_mpi_redist.c
 * Run:      mpiexec -n <comm_sz> ./prog3.9b_mpi_redist <vector order>
 *
 * Input:    None unless DEBUG flag is set, in which case, the vector
 * Output:   Vector after conversion from block to cyclic and after
 *           conversion from cyclic to block.  If DEBUG flag is set
 *           local vector on each process before and after each
 *           conversion
 *
 * Notes:
 * 1.  Order of vector should be evenly divisible by comm_sz
 * 2.  This version of the program uses a derived datatype to
 *     gather the vector onto process 0 when it has a cyclic
 *     distribution.
 * 3.  This version of the program uses nonblocking sends and
 *     receives to redistribute the data.
 * 4.  Calculation of sources, destinations, and derived datatypes 
 *     is not included in the time to redistribute the data.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

#define MPI_TYPE_NULL ((MPI_Datatype) 0)
const int RMAX = 100;

int my_rank, comm_sz;
MPI_Comm comm;
MPI_Datatype cyclic_mpi_t;

struct redist_s {
   int* offsets;  /* Where is the first elt going to each process */
   int* counts;   /* How much data goes to each process   */
   MPI_Datatype* types;
};

void Usage(char prog_name[]);
int Get_n(int argc, char* argv[]);
struct redist_s* Alloc_redist_s();
void Dealloc_redist_s(struct redist_s* redist_p);
void Build_cyclic_type(int n, int loc_n);
void Build_redist(struct redist_s* blk_src_p, struct redist_s* blk_dest_p, 
      int n, int loc_n);
void Read_vector(double loc_vec_blk[], int n, int loc_n);
void Gen_vector(double loc_vec_blk[], int n, int loc_n);
void Change_dist(double loc_vec_blk[], double loc_vec_cyc[], 
      struct redist_s* src_p, struct redist_s* dest_p, 
      int old_stride, int new_stride);
void Print_loc_vecs(char title[], double loc_vec[], int loc_n);
void Print_loc_vecs_int(char title[], int loc_vec[], int loc_n);
void Print_vec_blk(char title[], double loc_vec_blk[], int n, int loc_n);
void Print_vec_cyc(char title[], double loc_vec_blk[], int n, int loc_n);

/*-------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   double *loc_vec_blk, *loc_vec_cyc;
   struct redist_s *blk_src_p, *blk_dest_p;
   int n, loc_n;
   double start, finish, elapsed, my_elapsed;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   n = Get_n(argc, argv);
   loc_n = n/comm_sz;
   loc_vec_blk = malloc(loc_n*sizeof(double));
   memset(loc_vec_blk, 0, loc_n*sizeof(double));
   loc_vec_cyc = malloc(loc_n*sizeof(double));
   memset(loc_vec_blk, 0, loc_n*sizeof(double));
   blk_src_p = Alloc_redist_s();
   blk_dest_p = Alloc_redist_s();
   Build_cyclic_type(n, loc_n);
   Build_redist(blk_src_p, blk_dest_p, n, loc_n);

#  ifdef DEBUG
   Read_vector(loc_vec_blk, n, loc_n);
#  else
   Gen_vector(loc_vec_blk, n, loc_n);
#  endif

#  ifdef DEBUG
   Print_loc_vecs("Input vector", loc_vec_blk, loc_n);
#  endif

   MPI_Barrier(comm);
   start = MPI_Wtime();
   Change_dist(loc_vec_blk, loc_vec_cyc, blk_src_p, blk_dest_p, comm_sz, 1);
   finish = MPI_Wtime();
   my_elapsed = finish - start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

#  ifdef DEBUG
   Print_loc_vecs("Cyclic vector", loc_vec_cyc, loc_n);
   Print_vec_cyc("Cyclic vector", loc_vec_cyc, n, loc_n);
#  endif
   if (my_rank == 0)
      printf("Time to convert block to cyclic = %e seconds\n", elapsed);

   MPI_Barrier(comm);
   start = MPI_Wtime();
   Change_dist(loc_vec_cyc, loc_vec_blk, blk_dest_p, blk_src_p, 1, comm_sz);
   finish = MPI_Wtime();
   my_elapsed = finish - start;
   MPI_Reduce(&my_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, comm);

#  ifdef DEBUG
   Print_loc_vecs("Block vector", loc_vec_blk, loc_n);
   Print_vec_blk("Block vector", loc_vec_blk, n, loc_n);
#  endif
   if (my_rank == 0)
      printf("Time to convert cyclic to block = %e seconds\n", elapsed);

   free(loc_vec_blk);
   free(loc_vec_cyc);
   Dealloc_redist_s(blk_src_p);
   Dealloc_redist_s(blk_dest_p);
   MPI_Type_free(&cyclic_mpi_t);
   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
void Usage(char prog_name[]) {
   fprintf(stderr, "usage:  mpiexec -n <comm_sz> %s <order>\n",
         prog_name);
   fprintf(stderr, "           comm_sz should evenly divide order\n");
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
         if (n % comm_sz != 0) {
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
struct redist_s* Alloc_redist_s(void) {
   int i;

   struct redist_s* temp_p = malloc(sizeof(struct redist_s));
   temp_p->offsets = malloc(comm_sz*sizeof(int));
   temp_p->counts = malloc(comm_sz*sizeof(int));
   temp_p->types = malloc(comm_sz*sizeof(MPI_Datatype));

   for (i = 0; i < comm_sz; i++) {
      temp_p->offsets[i] = -1;
      temp_p->counts[i] = 0;
      temp_p->types[i] = MPI_TYPE_NULL;
   }

   return temp_p;
}  /* Alloc_redist_s */


/*-------------------------------------------------------------------*/
void Dealloc_redist_s(struct redist_s* redist_p) {
   int i;

   free(redist_p->offsets);
   free(redist_p->counts);
   for (i = 0; i < comm_sz; i++)
      if (redist_p->types[i] != MPI_TYPE_NULL)
         MPI_Type_free(&redist_p->types[i]);
   free(redist_p->types);
   free(redist_p);
}  /* Dealloc_redist_s */


/*-------------------------------------------------------------------*/
void Build_cyclic_type(int n, int loc_n) {
   MPI_Datatype vect_mpi_t;

   MPI_Type_vector(loc_n, 1, comm_sz, MPI_DOUBLE, &vect_mpi_t);
   MPI_Type_create_resized(vect_mpi_t, 0, sizeof(double), &cyclic_mpi_t);
   MPI_Type_free(&vect_mpi_t);
   MPI_Type_commit(&cyclic_mpi_t);

}  /* Build_cyclic_type */


/*-------------------------------------------------------------------*/
void Build_redist(struct redist_s* blk_src_p, struct redist_s* blk_dest_p, 
      int n, int loc_n) {
   int src, dest, count, i, j, glbl_sub;
   MPI_Datatype temp_mpi_t;

   /* Data structures used by sender when converting block to cyclic */
   for (i = 0; i < comm_sz; i++) {
      glbl_sub = my_rank*loc_n + i;
      dest = glbl_sub % comm_sz;
      if (i < loc_n) {  /* If something to send to dest */
         blk_dest_p->offsets[dest] = i;
         blk_dest_p->counts[dest] = 1 + (loc_n - 1 - i)/comm_sz;
         MPI_Type_vector(blk_dest_p->counts[dest], 1, comm_sz,
               MPI_DOUBLE, &temp_mpi_t);
         blk_dest_p->types[dest] = temp_mpi_t;
         MPI_Type_commit(&blk_dest_p->types[dest]);
      }
   }
#  ifdef DEBUG
   Print_loc_vecs_int("block dest offsets", blk_dest_p->offsets, comm_sz);
   Print_loc_vecs_int("block dest counts", blk_dest_p->counts, comm_sz);
#  endif

   /* Data structures used by receiver when converting block to cyclic */
   for (i = j = 0; j < comm_sz; j++) {
      glbl_sub = my_rank + i*comm_sz;  /* Global subscript of element */
                                       /* with local subscript i      */
      src = glbl_sub/loc_n;            /* Who sends me this element   */
      if (i < loc_n) {                 /* Do I receive this element?  */
         blk_src_p->offsets[src] = i;
         /* Determine number of additional elements received from src   
          * Largest global subscript on src = src*loc_n + loc_n - 1     
          * Choose count so that 
          *
          *    glbl_sub + count*comm_sz <= src*loc_n + loc_n - 1      */ 
         count = (src*loc_n + loc_n - 1 - glbl_sub)/comm_sz;
         if (count >= 1) 
            count++;
         else 
            count = 1;
         blk_src_p->counts[src] = count;
         MPI_Type_contiguous(count, MPI_DOUBLE, &temp_mpi_t);
         blk_src_p->types[src] = temp_mpi_t;
         MPI_Type_commit(&blk_src_p->types[src]);
         i += count;
      } else {
         i++;
      }
   }
#  ifdef DEBUG
   Print_loc_vecs_int("block src offsets", blk_src_p->offsets, comm_sz);
   Print_loc_vecs_int("block src counts", blk_src_p->counts, comm_sz);
#  endif

}  /* Find_srcs_dests */


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
         vec[i] = i+1;
      MPI_Scatter(vec, loc_n, MPI_DOUBLE, loc_vec_blk, loc_n, MPI_DOUBLE,
            0, comm);
      free(vec);
   }  else {
      MPI_Scatter(vec, loc_n, MPI_DOUBLE, loc_vec_blk, loc_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Gen_vector */


/*-------------------------------------------------------------------*/
void Change_dist(double loc_vec_blk[], double loc_vec_cyc[], 
      struct redist_s* src_p, struct redist_s* dest_p, int old_stride, 
      int new_stride) {
   int src, dest, offset, count, offset_new, offset_old, i;
   MPI_Datatype type;
   MPI_Request requests[2*comm_sz];
   MPI_Status statuses[2*comm_sz];

   /* Post receives */
   for (src = 0; src < comm_sz; src++) {
      offset = src_p->offsets[src];
      count = src_p->counts[src];
      type = src_p->types[src];
      if (src == my_rank)
         requests[src] = MPI_REQUEST_NULL;
      else if (count == 0) 
         requests[src] = MPI_REQUEST_NULL;
      else
         MPI_Irecv(loc_vec_cyc+offset, 1, type, src, 0, comm,
               &requests[src]);
  } /* Post receives */

   /* Post sends */
   for (dest = 0; dest < comm_sz; dest++) {
      offset = dest_p->offsets[dest];
      count = dest_p->counts[dest];
      type = dest_p->types[dest];
      if (dest == my_rank)
         requests[comm_sz + dest] = MPI_REQUEST_NULL;
      else if (offset < 0) 
         requests[comm_sz + dest] = MPI_REQUEST_NULL;
      else
         MPI_Isend(loc_vec_blk+offset, 1, type, dest, 0, comm,
               &requests[comm_sz + dest]);
   } /* Post sends */

   /* Copy local data */
   offset_old = dest_p->offsets[my_rank];
   offset_new = src_p->offsets[my_rank];
   count = dest_p->counts[my_rank];
   for (i = 0; i < count; i++) {
      loc_vec_cyc[offset_new] = loc_vec_blk[offset_old];
      offset_old += old_stride;
      offset_new += new_stride;
   }

   /* Wait for communications to complete */
   MPI_Waitall(2*comm_sz, requests, statuses);
     
}  /* Change_dist */


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
      fflush(stdout);
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
      fflush(stdout);
      free(vec);
   } else {
      MPI_Gather(loc_vec_blk, loc_n, MPI_DOUBLE, vec, loc_n, MPI_DOUBLE,
            0, comm);
   }
}  /* Print_vec_cyc */
