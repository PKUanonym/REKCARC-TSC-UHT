/* File:     mpi_tsp_dyn.c
 *
 * Purpose:  Use iterative depth-first search and MPI to solve an 
 *           instance of the travelling salesman problem.  This version 
 *           partitions the search tree using breadth-first search.
 *           Then each process searches its assigned subtree.  Processes
 *           that run out of work request work from other processes.
 *           Processes receiving work requests fulfill requests if
 *           they have sufficient work or send reject messages if
 *           they don't.  This version attempts to reuse deallocated 
 *           tours.  The best tour structure is broadcast using a 
 *           custom non-blocking broadcast.  Termination is detected
 *           using the "total energy" scheme.  This version uses the
 *           "new_frac" implementation of fractions.  All energy is
 *           represented by the log of the denominator (numerator is
 *           1) except total returned energy on 0, which is
 *           represented by a frac_t.
 *
 * Compile:  mpicc -g -Wall -o mpi_tsp_dyn mpi_tsp_dyn.c frac.c
 *           Needs frac.h
 *        
 * Usage:    mpiexec -n <proc count> mpi_tsp_dyn <matrix_file> 
 *              <min split size> <split cut off>
 *
 * Input:    From a user-specified file, the number of cities
 *           followed by the costs of travelling between the
 *           cities organized as a matrix:  the cost of
 *           travelling from city i to city j is the ij entry.
 *           Costs are nonnegative ints.  Diagonal entries are 0.
 * Output:   The best tour found by the program and the cost
 *           of the tour.
 *
 * Notes:
 * 1.  Costs and cities are non-negative ints.
 * 2.  Program assumes the cost of travelling from a city to
 *     itself is zero, and the cost of travelling from one
 *     city to another city is positive.
 * 3.  Note that costs may not be symmetric:  the cost of travelling
 *     from A to B, may, in general, be different from the cost
 *     of travelling from B to A.
 * 4.  Salesperson's home town is 0.
 * 5.  The digraph is stored as an adjacency matrix, which is
 *     a one-dimensional array:  digraph[i][j] is computed as
 *     digraph[i*n + j]
 * 6.  Define STATS at compile time to get some info on broadcasts
 *     of best tour costs.
 *
 * IPP:  Section 6.2.12 (pp. 327 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#include "frac.h"

const int INFINITY = 1000000;
const int NO_CITY = -1;
const int FALSE = 0;
const int TRUE = 1;
const int MAX_STRING = 1000;
const int TOUR_TAG = 1;
const int WORK_REQ_TAG = 2;
const int FULFILL_REQ_TAG = 3;
const int REJECT_REQ_TAG = 4;
const int TERM_TAG = 5;
const int ENERGY_TAG = 6;
const int INIT_COST_MSGS = 100;

typedef int city_t;
typedef int cost_t;

typedef struct {
   city_t* cities; /* Cities in partial tour           */
   int count;      /* Number of cities in partial tour */
   cost_t cost;    /* Cost of partial tour             */
} tour_struct;
typedef tour_struct* tour_t;
#define City_count(tour) (tour->count)
#define Tour_cost(tour) (tour->cost)
#define Last_city(tour) (tour->cities[(tour->count)-1])
#define Tour_city(tour,i) (tour->cities[(i)])

typedef struct {
   tour_t* list;
   int list_sz;
   int list_alloc;
}  stack_struct;
typedef stack_struct* my_stack_t;

/* head refers to the first element in the queue
 * tail refers to the first available slot
 */
typedef struct {
   tour_t* list;
   int list_alloc;
   int head;
   int tail;
   int full;
}  queue_struct;
typedef queue_struct* my_queue_t;
#define Queue_elt(queue,i) \
   (queue->list[(queue->head + (i)) % queue->list_alloc])


typedef struct {
   cost_t* msgs;
   MPI_Request* reqs;
   int alloc;
   int avail;
} cost_msg_struct;
typedef cost_msg_struct* cost_msg_t;
#define Cost_msg(cost_msgs, offset) (cost_msgs->msgs[(offset)])
#define Cost_req(cost_msgs, offset, dest) \
   (cost_msgs->reqs[(offset)*comm_sz + (dest)])


/* Global Vars: */
int n;  /* Number of cities in the problem */
int my_rank;
int comm_sz;
MPI_Comm comm;
cost_t* digraph;
#define Cost(city1, city2) (digraph[city1*n + city2])
city_t home_town = 0;
tour_t loc_best_tour;
cost_t best_tour_cost;
MPI_Datatype tour_arr_mpi_t;  // For storing the list of cities
cost_msg_t cost_msgs;
int min_split_sz;
int split_cutoff;
unsigned my_energy;        // log base 2 of denominator -- numerator is 1
unsigned total_energy;     // this is the total_energy -- an unsigned int
frac_t total_energy_recd;  // Only used by process 0
int work_req_dest;
MPI_Request work_req_req;
char* work_buf;  /* For sending and receiving a split stack.  Note
                  * that the program never simultaneously uses the
                  * buffer for sending and receiving */
int work_buf_alloc;

#ifdef STATS
/* For stats */
int best_costs_bcast = 0;
int best_costs_received = 0;
int msgs_cancelled = 0;
int work_reqs_fulfilled = 0;
int work_reqs_sent = 0;
int total_reqs_fulfilled = 0;
#endif

void Usage(char* prog_name);
void Read_digraph(FILE* digraph_file);
void Print_digraph(void);
void Check_for_error(int local_ok, char message[], MPI_Comm comm);

void Par_tree_search(void);
void Partition_tree(my_stack_t stack);
void Build_init_stack(my_stack_t stack, city_t tour_list[], int my_count);
void Get_global_best_tour(void);
void Create_tour_fr_list(city_t list[], tour_t tour);
void Set_init_tours(int init_tour_count, int counts[], int displacements[],
      int* my_count_p, int** tour_list_p);
void Build_initial_queue(int** queue_list_p, int queue_size,
      int *init_tour_count_p);
void Print_tour(tour_t tour, char* title);
int  Best_tour(tour_t tour); 
void Update_best_tour(tour_t tour);
void Copy_tour(tour_t tour1, tour_t tour2);
void Add_city(tour_t tour, city_t);
void Remove_last_city(tour_t tour);
int  Feasible(tour_t tour, city_t city);
int  Visited(tour_t tour, city_t city);
void Init_tour(tour_t tour, cost_t cost);
tour_t Alloc_tour(my_stack_t avail);
void Free_tour(tour_t tour, my_stack_t avail);

void Init_cost_msgs(void);
int Get_cost_msg(cost_t tour_cost);
void Free_cost_msgs(void);
void Look_for_best_tours(void);
void Bcast_tour_cost(cost_t tour_cost);

my_stack_t Init_stack(void);
void Push(my_stack_t stack, tour_t tour);  // Push pointer
void Push_copy(my_stack_t stack, tour_t tour, my_stack_t avail); 
tour_t Pop(my_stack_t stack);
int  Empty_stack(my_stack_t stack);
void Free_stack(my_stack_t stack);
void Print_stack(my_stack_t stack, char title[]);

/* Circular queue */
my_queue_t Init_queue(int size);
tour_t Dequeue(my_queue_t queue);
void Enqueue(my_queue_t queue, tour_t tour);
int Empty_queue(my_queue_t queue);
void Free_queue(my_queue_t queue);
void Print_queue(my_queue_t queue, char title[]);
int Get_upper_bd_queue_sz(void);
long long Fact(int k);

/* Termination */
int Terminated(my_stack_t stack, my_stack_t avail);
int Short_tour_count(my_stack_t stack);
void Fulfill_request(my_stack_t stack, int tour_count,
      my_stack_t avail);
void Send_work(my_stack_t stack, int dest, int tour_count,
      my_stack_t avail);
void Split_stack(my_stack_t stack, int tour_count, int* pack_size_p,
      my_stack_t avail);
void Send_rejects(void);
void Send_energy(void);
void Send_work_request(void);
void Check_for_work(int* work_request_sent_p, int* work_avail_p);
void Receive_work(my_stack_t stack, my_stack_t avail);
int Term_msg(void);
void Bcast_term_msg(void);
void Cleanup_msg_queue(void);

#include <unistd.h>
void Debug_info(void);

/*------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   FILE* digraph_file = NULL;  /* Make compiler shut up */
   double start, finish;
   int local_ok = 1;
   char usage[MAX_STRING];

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

// Debug_info();

   sprintf(usage, "usage: mpiexec -n <p> %s <digraph file> <min split sz> <split cutoff>\n",
         argv[0]);

   if (my_rank == 0 && argc != 4) local_ok = 0;
   Check_for_error(local_ok, usage, comm);
   if (my_rank == 0) {
      digraph_file = fopen(argv[1], "r");
      if (digraph_file == NULL) local_ok = 0;
   }
   Check_for_error(local_ok, "Can't open digraph file", comm);
   Read_digraph(digraph_file);
   if (my_rank == 0) fclose(digraph_file);
   if (my_rank == 0) 
      min_split_sz = strtol(argv[2], NULL, 10);
   MPI_Bcast(&min_split_sz, 1, MPI_INT, 0, comm);
   if (min_split_sz <= 0) local_ok = 0;
   Check_for_error(local_ok, "Min split size must be positive", comm);
   if (my_rank == 0) 
      split_cutoff = strtol(argv[3], NULL, 10);
   MPI_Bcast(&split_cutoff, 1, MPI_INT, 0, comm);
   if (split_cutoff <= 0) local_ok = 0;
   Check_for_error(local_ok, "Split cutoff must be positive", comm);
#  ifdef DEBUG
   if (my_rank == 0) Print_digraph();
#  endif

   loc_best_tour = Alloc_tour(NULL);
   Init_tour(loc_best_tour, INFINITY);
#  ifdef DEBUG
   Print_tour(-1, loc_best_tour, "Local Best tour");
   printf("City count = %d\n",  City_count(loc_best_tour));
   printf("Cost = %d\n\n", Tour_cost(loc_best_tour));
#  endif
   best_tour_cost = INFINITY;
   Init_cost_msgs();

   MPI_Type_contiguous(n+1, MPI_INT, &tour_arr_mpi_t);
   MPI_Type_commit(&tour_arr_mpi_t);
   my_energy = 0;  // Log base 2 of denominator = 0
   total_energy = comm_sz;  // This is the real total energy
   if (my_rank == 0) total_energy_recd = Alloc_frac();

#  ifdef TERM_DEBUG
   printf("Proc %d > At start my_energy = 1/2^%u\n", 
         my_rank, my_energy);
   if (my_rank == 0) {
      Print_frac(total_energy_recd, my_rank, 
            "At start total_energy_recd = ");
      printf("Proc %d > At start total energy = %u\n", my_rank, total_energy);
   }
#  endif
   work_req_dest = my_rank;
   work_buf = malloc(n*n/2*(2+split_cutoff)*sizeof(int));
   work_buf_alloc = n*n/2*(2+split_cutoff)*sizeof(int);

   start = MPI_Wtime();
   Par_tree_search();
   finish = MPI_Wtime();
   
   if (my_rank == 0) {
      Print_tour(loc_best_tour, "Best tour");
      printf("Cost = %d\n", loc_best_tour->cost);
      printf("Elapsed time = %e seconds\n", finish-start);
   }

#  ifdef STATS
// printf("Proc %d > bcasts = %d, costs received = %d, msgs cancelled= %d\n",
//       my_rank, best_costs_bcast, best_costs_received, msgs_cancelled);
// printf("Proc %d > work requests fulfilled = %d, work requests = %d\n",
//       my_rank, work_reqs_fulfilled, work_reqs_sent);
   MPI_Reduce(&work_reqs_fulfilled, &total_reqs_fulfilled, 1, MPI_INT,
         MPI_SUM, 0, comm);
   if (my_rank == 0)
      printf("Total requests fulfilled = %d\n", total_reqs_fulfilled);
#  endif
   MPI_Type_free(&tour_arr_mpi_t);
   Free_cost_msgs();
   if (my_rank == 0) Free_frac(total_energy_recd);
   free(loc_best_tour->cities);
   free(loc_best_tour);
   free(digraph);
   free(work_buf);

   MPI_Finalize();
   return 0;
}  /* main */

/*---------------------------------------------------------------------
 * Function: Debug_info
 * Purpose:  Print PID's of running MPI processes so that debuggers can be
 *           attached
 */      
void Debug_info(void) {
   int my_rank;
   pid_t pid;
   char c;
   MPI_Comm comm = MPI_COMM_WORLD;

   MPI_Comm_rank(comm, &my_rank);
   pid = getpid();
   printf("Process %d > pid = %d\n", my_rank, pid);
   fflush(stdout);
   if (my_rank == 0) {
      printf("Hit enter to continue\n");
      scanf("%c", &c);
   }
   MPI_Barrier(comm);
}  /* Debug_info */

/*------------------------------------------------------------------
 * Function:  Init_tour
 * Purpose:   Initialize the data members of allocated tour
 * In args:   
 *    cost:   initial cost of tour
 * Global in:
 *    n:      number of cities in TSP
 * Out arg:   
 *    tour
 * Local function
 */
void Init_tour(tour_t tour, cost_t cost) {
   int i;

   tour->cities[0] = 0;
   for (i = 1; i <= n; i++) {
      tour->cities[i] = NO_CITY;
   }
   tour->cost = cost;
   tour->count = 1;
}  /* Init_tour */


/*------------------------------------------------------------------
 * Function:  Read_digraph
 * Purpose:   Read in the number of cities and the digraph of costs
 * In arg:    digraph_file
 * Globals out:
 *    n:        the number of cities
 *    digraph:  the matrix file
 */
void Read_digraph(FILE* digraph_file) {
   int i, j, local_ok = 1;

   if (my_rank == 0) fscanf(digraph_file, "%d", &n);
   MPI_Bcast(&n, 1, MPI_INT, 0, comm);
   if (n <= 0) local_ok = 0;
   Check_for_error(local_ok, "Number of vertices must be positive", comm);

   digraph = malloc(n*n*sizeof(cost_t));

   if (my_rank == 0) {
      for (i = 0; i < n; i++)
         for (j = 0; j < n; j++) {
            fscanf(digraph_file, "%d", &digraph[i*n + j]);
            if (i == j && digraph[i*n + j] != 0) {
               fprintf(stderr, "Diagonal entries must be zero\n");
               local_ok = 0;;
            } else if (i != j && digraph[i*n + j] <= 0) {
               fprintf(stderr, "Off-diagonal entries must be positive\n");
               fprintf(stderr, "diagraph[%d,%d] = %d\n", i, j, digraph[i*n+j]);
               local_ok = 0;
            }
         }
   }
   Check_for_error(local_ok, "Error in digraph file", comm);
   MPI_Bcast(digraph, n*n, MPI_INT, 0, comm);
}  /* Read_digraph */


/*------------------------------------------------------------------
 * Function:  Print_digraph
 * Purpose:   Print the number of cities and the digraphrix of costs
 * Globals in:
 *    n:        number of cities
 *    digraph:  digraph of costs
 * Local function
 */
void Print_digraph(void) {
   int i, j;

   printf("Order = %d\n", n);
   printf("Matrix = \n");
   for (i = 0; i < n; i++) {
      for (j = 0; j < n; j++)
         printf("%2d ", digraph[i*n+j]);
      printf("\n");
   }
   printf("\n");
}  /* Print_digraph */


/*------------------------------------------------------------------
 * Function:    Par_tree_search
 * Purpose:     Use multiple threads to search a tree
 * In arg:     
 *    rank:     thread rank
 * Globals in:
 *    n:        total number of cities in the problem
 * Notes:
 * 1. The Update_best_tour function will modify the global vars
 *    loc_best_tour and best_tour_cost
 */
void Par_tree_search(void) {
   city_t nbr;
   my_stack_t stack;  // Stack for searching
   my_stack_t avail;  // Stack for unused tours
   tour_t curr_tour;

   avail = Init_stack();
   stack = Init_stack();
   Partition_tree(stack);

   while (!Terminated(stack, avail)) {
      curr_tour = Pop(stack);
#     ifdef DEBUG
      Print_tour(curr_tour, "Popped");
#     endif
      if (City_count(curr_tour) == n) {
         if (Best_tour(curr_tour)) {
#           ifdef DEBUG
            Print_tour(curr_tour, "Best tour");
#           endif
            Update_best_tour(curr_tour);
         }
      } else {
         for (nbr = n-1; nbr >= 1; nbr--) 
            if (Feasible(curr_tour, nbr)) {
               Add_city(curr_tour, nbr);
               Push_copy(stack, curr_tour, avail);
               Remove_last_city(curr_tour);
            }
      }
      Free_tour(curr_tour, avail);
   }
#  ifdef DEBUG
   printf("Proc %d > Done searching\n", my_rank);
#  endif
   Free_stack(stack);
   Free_stack(avail);
   MPI_Barrier(comm);
#  ifdef DEBUG
   printf("Proc %d > Passed barrier\n", my_rank);
#  endif
   Get_global_best_tour();
#  ifdef DEBUG
   printf("Proc %d > Returning to main\n", my_rank);
#  endif

   Cleanup_msg_queue();

}  /* Par_tree_search */

/*------------------------------------------------------------------
 * Function:  Get_global_best_tour
 * Purpose:   Get global best tour to process 0
 */
void Get_global_best_tour(void) {
   struct {
      int cost;
      int rank;
   } loc_data, global_data;
   loc_data.cost = Tour_cost(loc_best_tour);
   loc_data.rank = my_rank;

   /* Both 0 and the owner of the best tour need global_data */
   MPI_Allreduce(&loc_data, &global_data, 1, MPI_2INT, MPI_MINLOC, comm);
#  ifdef DEBUG
   printf("Proc %d > Returned from reduce, rank = %d, cost = %d\n", my_rank,
         global_data.rank, global_data.cost);
#  endif
   if (global_data.rank == 0) return;
   if (my_rank == 0) {
      MPI_Recv(loc_best_tour->cities, n+1, MPI_INT, global_data.rank,
            0, comm, MPI_STATUS_IGNORE);
      loc_best_tour->cost = global_data.cost;
      loc_best_tour->count = n+1;
   } else if (my_rank == global_data.rank) {
      MPI_Send(loc_best_tour->cities, n+1, MPI_INT, 0, 0, comm);
   } 
}  /* Get_global_best_tour */

/*------------------------------------------------------------------
 * Function:  Partition_tree
 * Purpose:   Assign each thread its initial collection of subtrees
 * In arg:    
 *    my_rank
 * Out args:   
 *    stack:  stack will store each thread's initial tours
 *
 */
void Partition_tree(my_stack_t stack) {
   int my_count, local_ok = 1;
   int queue_size = 0, init_tour_count;  /* queue_size = 0 to make compiler shutup */
   city_t *queue_list = NULL;
   city_t *tour_list;
   int counts[comm_sz];  /* For scatter */
   int displacements[comm_sz];  /* For scatter */

   if (my_rank == 0) {
      queue_size = Get_upper_bd_queue_sz();
#     ifdef DEBUG
      printf("Proc %d > queue_size = %d\n", my_rank, queue_size);
#     endif
      if (queue_size == 0) local_ok = 0;
   }
   Check_for_error(local_ok, "Too many processes", comm);

   if (my_rank == 0) 
      Build_initial_queue(&queue_list, queue_size, &init_tour_count);
   MPI_Bcast(&init_tour_count, 1, MPI_INT, 0, comm);

   Set_init_tours(init_tour_count, counts, displacements, 
         &my_count, &tour_list);

   MPI_Scatterv(queue_list, counts, displacements, tour_arr_mpi_t,
         tour_list, my_count, tour_arr_mpi_t, 0, comm);
   
   Build_init_stack(stack, tour_list, my_count);

#  ifdef DEBUG
   Print_stack(stack, "After set up");
#  endif
   if (my_rank == 0) free(queue_list);
   free(tour_list);

}  /* Partition_tree */

/*------------------------------------------------------------------
 * Function:   Build_init_stack
 * Purpose:    Push the initial tours onto the stack
 * In args:
 *    tour_list
 *    my_count
 * Out arg:
 *    stack
 * Global in:
 *    n
 */
void Build_init_stack(my_stack_t stack, city_t tour_list[], int my_count) {
   int i;
   tour_t tour = Alloc_tour(NULL);

   for (i = my_count-1; i >= 0; i--) {
      Create_tour_fr_list(tour_list + i*(n+1), tour);
      Push_copy(stack, tour, NULL);
   }
   Free_tour(tour, NULL);
}  /* Build_init_stack */

/*------------------------------------------------------------------
 * Function:  Create_tour_fr_list
 * Purpose:   Given a list of cities, create a tour struct
 * In arg
 *    tour_list
 * Out arg
 *    tour
 * Globals in:
 *    n
 *    digraph
 * Note:     Assumes tour has been allocated and copies data into it
 */
void Create_tour_fr_list(city_t list[], tour_t tour) {
   int count = 1, cost = 0;
   city_t city1, city2;

   memcpy(tour->cities, list, (n+1)*sizeof(city_t));

   city1 = 0;
   while (count <= n && list[count] != NO_CITY) {
      city2 = list[count];
      count++;
      cost += Cost(city1, city2);
      city1 = city2;
   }
   tour->count = count;
   tour->cost = cost;
}  /* Create_tour_fr_list */

/*------------------------------------------------------------------
 * Function:   Set_init_tours
 * Purpose:    Determine which tours in the initial queue should be
 *             assigned to each process
 * In arg:
 *    init_tour_count
 * Out args:
 *    counts
 *    displacements
 *    my_count_p
 *    my_last_tour_p
 *    tour_list_p
 * Globals in:
 *    my_rank
 *    comm_sz
 *
 * Note:  A block partition is used.
 */
void Set_init_tours(int init_tour_count, int counts[], int displacements[],
      int* my_count_p, city_t** tour_list_p) {
   int quotient, remainder, i;

   quotient = init_tour_count/comm_sz;
   remainder = init_tour_count % comm_sz;
   for (i = 0; i < remainder; i++) 
      counts[i] = quotient+1;
   for (i = remainder; i  < comm_sz; i++)
      counts[i] = quotient;
   *my_count_p = counts[my_rank];
   displacements[0] = 0;
   for (i = 1; i < comm_sz; i++)
      displacements[i] = displacements[i-1] + counts[i-1];

   *tour_list_p = malloc((*my_count_p)*(n+1)*sizeof(int));
}   /* Set_init_tours */


/*------------------------------------------------------------------
 * Function:  Build_initial_queue
 * Purpose:   Build queue of tours to be divided among processes/threads
 * Global Scratch:
 *    queue_size
 * Out args
 *    init_tour_count_p
 *    queue_list_p
 *
 * Note:  Only called by one process/thread
 */
void Build_initial_queue(city_t** queue_list_p, int queue_size, 
      int* init_tour_count_p) {
   my_queue_t queue;
   int curr_sz = 0, i;
   city_t nbr;
   tour_t tour = Alloc_tour(NULL);
   city_t* queue_list;

   Init_tour(tour, 0);
   queue = Init_queue(2*queue_size);

   /* Breadth-first search */
   Enqueue(queue, tour);  // Enqueues a copy
// printf("Freeing %p\n", tour);
   Free_tour(tour, NULL);
   curr_sz++;
   while (curr_sz < comm_sz) {
      tour = Dequeue(queue);
//    printf("Dequeued %p\n", tour);
      curr_sz--;
      for (nbr = 1; nbr < n; nbr++)
         if (!Visited(tour, nbr)) {
            Add_city(tour, nbr);
            Enqueue(queue, tour);
            curr_sz++;
            Remove_last_city(tour);
         }
//    printf("Freeing %p\n", tour);
      Free_tour(tour, NULL);
   }  /* while */

   *init_tour_count_p = curr_sz; 

#  ifdef DEBUG
   Print_queue(queue, "Initial queue");
#  endif

   /* Copy the city lists from queue into queue_list */
   queue_list = malloc((*init_tour_count_p)*(n+1)*sizeof(int));
   for (i = 0; i < *init_tour_count_p; i++)
      memcpy(queue_list + i*(n+1), Queue_elt(queue,i)->cities, 
            (n+1)*sizeof(int));
   *queue_list_p = queue_list;
   Free_queue(queue);
}  /* Build_initial_queue */

/*------------------------------------------------------------------
 * Function:    Best_tour
 * Purpose:     Determine whether addition of the hometown to the 
 *              n-city input tour will lead to a best tour.
 * In arg:
 *    tour:     tour visiting all n cities
 * Ret val:
 *    TRUE if best tour, FALSE otherwise
 */
int Best_tour(tour_t tour) {
   cost_t cost_so_far = Tour_cost(tour);
   city_t last_city = Last_city(tour);

   Look_for_best_tours();

   if (cost_so_far + Cost(last_city, home_town) < best_tour_cost)
      return TRUE;
   else
      return FALSE;
}  /* Best_tour */

/*------------------------------------------------------------------
 * Function:   Look_for_best_tours
 * Purpose:    Examine the message queue for tour costs received from
 *             other processes.  If a tour cost that's less than the
 *             current best cost on this process, best_tour_cost will
 *             be updated.
 * Global In/out:
 *    best_tour_cost
 * Note:
 *    Tour costs are probed for and received as long as there are
 *    messages with TOUR_TAG.
 */
void Look_for_best_tours(void) {
   int done = FALSE, msg_avail, tour_cost;
   MPI_Status status;

   while(!done) {
      MPI_Iprobe(MPI_ANY_SOURCE, TOUR_TAG, comm, &msg_avail, 
            &status);
      if (msg_avail) {
         MPI_Recv(&tour_cost, 1, MPI_INT, status.MPI_SOURCE, TOUR_TAG,
               comm, MPI_STATUS_IGNORE);
#        ifdef STATS
         best_costs_received++;
//       printf("Proc %d > received cost %d\n", my_rank, tour_cost);
#        endif
         if (tour_cost < best_tour_cost) best_tour_cost = tour_cost;
      } else {
         done = TRUE;
      }
   }  /* while */
}  /* Look_for_best_tours */


/*------------------------------------------------------------------
 * Function:    Update_best_tour
 * Purpose:     Replace the existing best tour with the input tour +
 *              hometown
 * In arg:
 *    tour:     tour that's visited all n-cities
 * Global out:
 *    loc_best_tour:  the current best tour on this process
 *    best_tour_cost
 * Note: 
 * 1. The input tour hasn't had the home_town added as the last
 *    city before the call to Update_loc_best_tour.  So we call
 *    Add_city(loc_best_tour, hometown) before returning.
 * 2. This function will only be called if tour has lower cost
 *    than any tour local or nonlocal that has been received up
 *    to this point.  Hence it updates best_tour_cost and broadcasts
 *    the best_tour_cost.
 */
void Update_best_tour(tour_t tour) {
   Copy_tour(tour, loc_best_tour);
   Add_city(loc_best_tour, home_town);
   best_tour_cost = Tour_cost(loc_best_tour);
   Bcast_tour_cost(best_tour_cost);
#  ifdef STATS
// Print_tour(loc_best_tour, "Best tour");
// printf("Proc %d > cost = %d\n", my_rank, best_tour_cost);
#  endif
}  /* Update_best_tour */


/*------------------------------------------------------------------
 * Function:  Init_cost_msgs
 * Purpose:   Initialize the cost_msgs struct
 * Global in:
 *    comm_sz
 * Global out:
 *    cost_msgs
 */
void Init_cost_msgs(void) {

   cost_msgs = malloc(sizeof(cost_msg_struct));
   cost_msgs->msgs = malloc(INIT_COST_MSGS*sizeof(cost_t));
   cost_msgs->reqs = malloc(INIT_COST_MSGS*comm_sz*sizeof(MPI_Request));
   cost_msgs->alloc = INIT_COST_MSGS;
   cost_msgs->avail = 0;

}  /* Init_cost_msgs */
 
/*------------------------------------------------------------------
 * Function:  Get_cost_msg
 * Purpose:   Return buffer space and requests for the broadcast of
 *            a tour's cost
 * Ret val:
 *    offset into msgs array for buffering cost.  Note that this
 *       offset*comm_sz also gives the offset into a block of
 *       requests
 * In/out global:
 *    cost_msgs:  the tour cost is copied into the msgs array
 */
int Get_cost_msg(cost_t tour_cost) {
   int offset, msgs_completed;

   if (cost_msgs->avail >= 0 && cost_msgs->avail < cost_msgs->alloc) {
      offset = cost_msgs->avail;
      (cost_msgs->avail)++;
      Cost_msg(cost_msgs,offset) = tour_cost;
      return offset;
   } else {  // No available buffer:  look for one.
      for (offset = 0; offset < cost_msgs->alloc; offset++) {
         MPI_Testall(comm_sz, cost_msgs->reqs + offset*comm_sz, 
               &msgs_completed, MPI_STATUSES_IGNORE);
         if (msgs_completed) {
            Cost_msg(cost_msgs,offset) = tour_cost;
            return offset;
         }
      }
   } 
   
   // Can't find any available buffer:  realloc
   cost_msgs->msgs = 
      realloc(cost_msgs->msgs, 2*(cost_msgs->alloc)*sizeof(cost_t));
   cost_msgs->reqs = 
      realloc(cost_msgs->reqs, 
            2*(cost_msgs->alloc)*comm_sz*sizeof(MPI_Request));
   offset = cost_msgs->alloc;
   cost_msgs->alloc *= 2;

   Cost_msg(cost_msgs,offset) = tour_cost;
   cost_msgs->avail = offset+1;
   return offset;
}  /* Get_cost_msg */

/*------------------------------------------------------------------
 * Function:  Free_cost_msgs
 * Purpose:   Complete/cancel any outstanding communications and
 *            free the data structures
 * in Global:
 *    comm_sz
 * in/out Global:
 *    cost_msgs
 */
void Free_cost_msgs(void) {
   int msg, dest, msg_completed;

   for (msg = 0; msg < cost_msgs->avail; msg++) 
      for (dest = 0; dest < comm_sz; dest++)
         if (dest != my_rank) 
            if (Cost_req(cost_msgs, msg, dest) != MPI_REQUEST_NULL) {
               MPI_Test(&Cost_req(cost_msgs, msg, dest), &msg_completed,
                     MPI_STATUS_IGNORE);
               if (!msg_completed) {
                  MPI_Cancel(&Cost_req(cost_msgs, msg, dest));
#                 ifdef STATS
                  msgs_cancelled++;
#                 endif
                  MPI_Wait(&Cost_req(cost_msgs, msg, dest), MPI_STATUS_IGNORE);
               }
            }

   free(cost_msgs->msgs);
   free(cost_msgs->reqs);
}  /* Free_cost_msgs */


/*------------------------------------------------------------------
 * Function:   Bcast_tour_cost
 * Purpose:    Asynchronous broadcast of tour cost
 *
 * Note:
 *    MPI_Bcast is a point of synchronization for the processes.
 *    So it can't be used.
 */
void Bcast_tour_cost(int tour_cost) {
   int offset = Get_cost_msg(tour_cost);
   int dest;

   for (dest = 0; dest < comm_sz; dest++)
      if (dest != my_rank)
         MPI_Isend(&Cost_msg(cost_msgs,offset), 1, MPI_INT, dest,
               TOUR_TAG, comm, &Cost_req(cost_msgs, offset, dest));
#  ifdef STATS
   best_costs_bcast++;
#  endif
}  /* Bcast_tour_cost */


/*------------------------------------------------------------------
 * Function:   Copy_tour
 * Purpose:    Copy tour1 into tour2
 * In arg:
 *    tour1
 * Out arg:
 *    tour2
 */
void Copy_tour(tour_t tour1, tour_t tour2) {
// int i;

   memcpy(tour2->cities, tour1->cities, (n+1)*sizeof(city_t));
// for (i = 0; i <= n; i++)
//   tour2->cities[i] =  tour1->cities[i];
   tour2->count = tour1->count;
   tour2->cost = tour1->cost;
}  /* Copy_tour */

/*------------------------------------------------------------------
 * Function:  Add_city
 * Purpose:   Add city to the end of tour
 * In arg:
 *    city
 * In/out arg:
 *    tour
 * Note: This should only be called if tour->count >= 1.
 */
void Add_city(tour_t tour, city_t new_city) {
   city_t old_last_city = Last_city(tour);
   tour->cities[tour->count] = new_city;
   (tour->count)++;
   tour->cost += Cost(old_last_city,new_city);
}  /* Add_city */

/*------------------------------------------------------------------
 * Function:  Remove_last_city
 * Purpose:   Remove last city from end of tour
 * In/out arg:
 *    tour
 * Note:
 *    Function assumes there are at least two cities on the tour --
 *    i.e., the hometown in tour->cities[0] won't be removed.
 */
void Remove_last_city(tour_t tour) {
   city_t old_last_city = Last_city(tour);
   city_t new_last_city;
   
   tour->cities[tour->count-1] = NO_CITY;
   (tour->count)--;
   new_last_city = Last_city(tour);
   tour->cost -= Cost(new_last_city,old_last_city);
}  /* Remove_last_city */

/*------------------------------------------------------------------
 * Function:  Feasible
 * Purpose:   Check whether nbr could possibly lead to a better
 *            solution if it is added to the current tour.  The
 *            function checks whether nbr has already been visited
 *            in the current tour, and, if not, whether adding the
 *            edge from the current city to nbr will result in
 *            a cost less than the current best cost.
 * In args:   All
 * Global in:
 *    best_tour_cost
 * Return:    TRUE if the nbr can be added to the current tour.
 *            FALSE otherwise
 */
int Feasible(tour_t tour, city_t city) {
   city_t last_city = Last_city(tour);

   if (!Visited(tour, city) && 
        Tour_cost(tour) + Cost(last_city,city) < best_tour_cost)
      return TRUE;
   else
      return FALSE;
}  /* Feasible */


/*------------------------------------------------------------------
 * Function:   Visited
 * Purpose:    Use linear search to determine whether city has already
 *             been visited on the current tour.
 * In args:    All
 * Return val: TRUE if city has already been visited.
 *             FALSE otherwise
 */
int Visited(tour_t tour, city_t city) {
   int i;

   for (i = 0; i < City_count(tour); i++)
      if ( Tour_city(tour,i) == city ) return TRUE;
   return FALSE;
}  /* Visited */


/*------------------------------------------------------------------
 * Function:  Print_tour
 * Purpose:   Print a tour
 * In args:   All
 * Notes:      
 * 1.  Copying the tour to a string makes it less likely that the 
 *     output will be broken up by another process/thread
 * 2.  Passing a negative value for my_rank will cause the rank
 *     to be omitted from the output
 */
void Print_tour(tour_t tour, char* title) {
   int i;
   char string[MAX_STRING];

   if (my_rank >= 0)
      sprintf(string, "Proc %d > %s %p: ", my_rank, title, tour);
   else
      sprintf(string, "%s: ", title);
   for (i = 0; i < City_count(tour); i++)
      sprintf(string + strlen(string), "%d ", Tour_city(tour,i));
   printf("%s\n\n", string);
}  /* Print_tour */

/*------------------------------------------------------------------
 * Function:  Alloc_tour
 * Purpose:   Allocate memory for a tour and its members
 * In/out arg:
 *    avail:  stack storing unused tours
 * Global in: n, number of cities
 * Ret val:   Pointer to a tour_struct with storage allocated for its
 *            members
 */
tour_t Alloc_tour(my_stack_t avail) {
   tour_t tmp;

   if (avail == NULL || Empty_stack(avail)) {
      tmp = malloc(sizeof(tour_struct));
      tmp->cities = malloc((n+1)*sizeof(city_t));
      return tmp;
   } else {
      return Pop(avail);
   }
}  /* Alloc_tour */

/*------------------------------------------------------------------
 * Function:  Free_tour
 * Purpose:   Free a tour
 * In/out arg:
 *    avail
 * Out arg:   
 *    tour
 */
void Free_tour(tour_t tour, my_stack_t avail) {
   if (avail == NULL) {
      free(tour->cities);
      free(tour);
   } else {
      Push(avail, tour);
   }
}  /* Free_tour */

/*------------------------------------------------------------------
 * Function: Init_stack
 * Purpose:  Allocate storage for a new stack and initialize members
 * Out arg:  stack_p
 */
my_stack_t Init_stack(void) {
   int i;

   my_stack_t stack = malloc(sizeof(stack_struct));
   stack->list = malloc(n*n*sizeof(tour_t));
   for (i = 0; i < n*n; i++)
      stack->list[i] = NULL;
   stack->list_sz = 0;
   stack->list_alloc = n*n;

   return stack;
}  /* Init_stack */


/*------------------------------------------------------------------
 * Function:    Push
 * Purpose:     Push a tour pointer onto the stack
 * In arg:      tour
 * In/out arg:  stack
 */
void Push(my_stack_t stack, tour_t tour) {
   if (stack->list_sz == stack->list_alloc) {
      fprintf(stderr, "Stack overflow in Push!\n");
      free(tour->cities);
      free(tour);
   } else {
#     ifdef DEBUG
      printf("In Push, list_sz = %d, pushing %p and %p\n",
            stack->list_sz, tour, tour->cities);
      Print_tour(tour, "About to be pushed onto stack");
      printf("\n");
#     endif
      stack->list[stack->list_sz] = tour;
      (stack->list_sz)++;
   }
}  /* Push */

/*------------------------------------------------------------------
 * Function:    Push_copy
 * Purpose:     Push a copy of tour onto the top of the stack
 * In arg:      tour
 * In/out arg:  
 *    stack
 *    avail
 * Error:       If the stack is full, print an error and exit
 */
void Push_copy(my_stack_t stack, tour_t tour, my_stack_t avail) {
   tour_t tmp;

   if (stack->list_sz == stack->list_alloc) {
      fprintf(stderr, "Stack overflow!\n");
      exit(-1);
   }
   tmp = Alloc_tour(avail);
   Copy_tour(tour, tmp);
   stack->list[stack->list_sz] = tmp;
   (stack->list_sz)++;
}  /* Push_copy */


/*------------------------------------------------------------------
 * Function:  Pop
 * Purpose:   Reduce the size of the stack by returning the top
 * In arg:    stack
 * Ret val:   The tour on the top of the stack
 * Error:     If the stack is empty, print a message and exit
 */
tour_t Pop(my_stack_t stack) {
   tour_t tmp;

   if (stack->list_sz == 0) {
      fprintf(stderr, "Trying to pop empty stack!\n");
      exit(-1);
   }
   tmp = stack->list[stack->list_sz-1];
   stack->list[stack->list_sz-1] = NULL;
   (stack->list_sz)--;
   return tmp;
}  /* Pop */


/*------------------------------------------------------------------
 * Function:  Empty_stack
 * Purpose:   Determine whether the stack is empty
 * In arg:    stack
 * Ret val:   TRUE if empty, FALSE otherwise
 */
int  Empty_stack(my_stack_t stack) {
   if (stack->list_sz == 0)
      return TRUE;
   else
      return FALSE;
}  /* Empty_stack */


/*------------------------------------------------------------------
 * Function:  Free_stack
 * Purpose:   Free a stack and its members
 * Out arg:   stack
 */
void Free_stack(my_stack_t stack) {
   int i;

   for (i = 0; i < stack->list_sz; i++) {
      free(stack->list[i]->cities);
      free(stack->list[i]);
   }
   free(stack->list);
   free(stack);
}  /* Free_stack */

/*------------------------------------------------------------------
 * Function:  Print_stack
 * Purpose:   Print contents of stack for debugging
 * In args:   all
 */
void Print_stack(my_stack_t stack, char title[]) {
   char string[MAX_STRING];
   int i, j;

   printf("Proc %d > %s\n", my_rank, title);
   for (i = 0; i < stack->list_sz; i++) {
      sprintf(string, "Proc %d > ", my_rank);
      for (j = 0; j < stack->list[i]->count; j++)
         sprintf(string + strlen(string), "%d ", stack->list[i]->cities[j]);
      printf("%s\n", string);
   }

}  /* Print_stack */

/*------------------------------------------------------------------
 * Function:  Init_queue
 * Purpose:   Allocate storage for and initialize data members in
 *            new queue
 * In arg:    size, the size of the new queue
 * Ret val:   new queue
 */
my_queue_t Init_queue(int size) {
   my_queue_t new_queue = malloc(sizeof(queue_struct));
   new_queue->list = malloc(size*sizeof(tour_t));
   new_queue->list_alloc = size;
   new_queue->head = new_queue->tail = new_queue->full = 0;

   return new_queue;
}  /* Init_queue */


/*------------------------------------------------------------------
 * Function:   Dequeue
 * Purpose:    Remove the tour at the head of the queue and return 
 *             it
 * In/out arg: queue
 * Ret val:    tour at head of queue
 */
tour_t Dequeue(my_queue_t queue) {
   tour_t tmp;

   if (Empty_queue(queue)) {
      fprintf(stderr, "Attempting to dequeue from empty queue\n");
      exit(-1);
   }
   tmp = queue->list[queue->head];
   queue->head = (queue->head + 1) % queue->list_alloc;
   return tmp;
}  /* Dequeue */

/*------------------------------------------------------------------
 * Function:   Enqueue
 * Purpose:    Add a new tour to the tail of the queue
 * In arg:     tour
 * In/out arg: queue
 */
void Enqueue(my_queue_t queue, tour_t tour) {
   tour_t tmp;

   if (queue->full == TRUE) {
      fprintf(stderr, "Attempting to enqueue a full queue\n");
      fprintf(stderr, "list_alloc = %d, head = %d, tail = %d\n",
            queue->list_alloc, queue->head, queue->tail);
      exit(-1);
   }
   tmp = Alloc_tour(NULL);
   Copy_tour(tour, tmp);
// printf("Enqueuing %p\n", tmp);
   queue->list[queue->tail] = tmp;
   queue->tail = (queue->tail + 1) % queue->list_alloc; 
   if (queue->tail == queue->head)
      queue->full = TRUE;

}  /* Enqueue */

/*------------------------------------------------------------------
 * Function:  Empty_queue
 * Purpose:   Determine whether the queue is empty
 * Ret val:   TRUE if queue is empty, FALSE otherwise
 */
int Empty_queue(my_queue_t queue) {
   if (queue->full == TRUE)
      return FALSE;
   else if (queue->head != queue->tail)
      return FALSE;
   else
      return TRUE;
}  /* Empty_queue */

/*------------------------------------------------------------------
 * Function:    Free_queue
 * Purpose:     Free storage used for queue
 * Out arg:     queue
 */
void Free_queue(my_queue_t queue) {
// int i;
// 
// for (i = queue->head; i != queue->tail; i = (i+1) % queue->list_alloc) {
//    free(queue->list[i]->cities);
//    free(queue->list[i]);
// }
   free(queue->list);
   free(queue);
}  /* Free_queue */

/*------------------------------------------------------------------
 * Function:  Print_queue
 * Purpose:   Print contents of queue for debugging
 * In args:   all
 */
void Print_queue(my_queue_t queue, char title[]) {
   char string[MAX_STRING];
   int i, j;

   printf("Proc %d > %s\n", my_rank, title);
   for (i = queue->head; i != queue->tail; i = (i+1) % queue->list_alloc) {
      sprintf(string, "Proc %d > %p = ", my_rank, queue->list[i]);
      for (j = 0; j < queue->list[i]->count; j++)
         sprintf(string + strlen(string), "%d ", queue->list[i]->cities[j]);
      printf("%s\n", string);
   }

}  /* Print_queue */

/*------------------------------------------------------------------
 * Function:    Get_upper_bd_queue_sz
 * Purpose:     Determine the number of tours needed so that 
 *              each thread/process gets at least one and a level
 *              of the tree is fully expanded.  Used as upper
 *              bound when building initial queue and used as
 *              test to see if there are too many threads for
 *              the problem size
 * Globals In:
 *    comm_sz:  number of threads
 *    n:             number of cities
 *
 */
int Get_upper_bd_queue_sz(void) {
   int fact = n-1;
   int size = n-1;

   while (size < comm_sz) {
      fact++;
      size *= fact;
   }

   if (size > Fact(n-1)) {
      fprintf(stderr, "You really shouldn't use so many threads for");
      fprintf(stderr, "such a small problem\n");
      size = 0;
   }
   return size;
}  /* Get_upper_bd_queue_sz */

/*------------------------------------------------------------------
 * Function:    Fact
 * Purpose:     Compute k!
 * In arg:      k
 * Ret val:     k!
 */
long long Fact(int k) {
   long long tmp = 1;
   int i;

   for (i = 2; i <= k; i++)
      tmp *= i;
   return tmp;
}  /* Fact */


/*------------------------------------------------------------------
 * Function:  Terminated
 * Purpose:   Determine whether the program has terminated.  If it
 *            hasn't try to fulfill requests for work if process
 *            has any.  Otherwise look for work until some is
 *            received or the program terminates.
 * In/out args:  stack, avail
 */
int Terminated(my_stack_t stack, my_stack_t avail) {
   int work_request_sent;
   int work_avail;
   int tour_count = Short_tour_count(stack);

#  ifdef TERM_DEBUG
// Print_stack(stack, "In Terminated");
#  endif
   if (tour_count > min_split_sz) {
      Fulfill_request(stack, tour_count, avail);
      return FALSE;
   } else { /* Not enough work to fulfill a request */
      Send_rejects();
      if (!Empty_stack(stack)) {
         return FALSE;
      } else {  /* Empty stack */
         Send_energy();
         if (comm_sz == 1) return TRUE;
         work_request_sent = FALSE;
#        ifdef TERM_DEBUG
         printf("Proc %d > Entering while(1) loop in Terminated\n",
               my_rank);
#        endif
         while (1) {
            Send_rejects();
            Look_for_best_tours();  // Get them out of the message queue
            if (Term_msg()) {
#              ifdef TERM_DEBUG
               printf("Proc %d > Terminating\n", my_rank);
               if (my_rank == 0) {
                  Print_frac(total_energy_recd, my_rank, 
                        "Terminating, total_energy_recd = ");
               }
#              endif
               return TRUE;
            } else if (!work_request_sent) {
               Send_work_request();
               work_request_sent = TRUE;
#              ifdef TERM_DEBUG
               printf("Proc %d > Sent work request to %d\n",
                     my_rank, work_req_dest);
               fflush(stdout);
#              endif
            } else {
               Check_for_work(&work_request_sent, &work_avail);
               if (work_avail) {
                  Receive_work(stack, avail);
#                 ifdef TERM_DEBUG
                  printf("Proc %d > Received work from %d\n",
                        my_rank, work_req_dest);
                  Print_stack(stack, "Received stack");
                  printf("Proc %d > my_energy = 1/2^%u after receiving from %d\n"
                        my_rank, my_energy);
#                 endif
                  return FALSE;
               }
            }
         }  /* while */
      } /* Empty stack */
   }  /* Not enough work */
} /* Terminated */

/*---------------------------------------------------------------------
 * Function:  Short_tour_count
 * Purpose:   Count the number of tours on the stack with length <
 *            split_cutoff
 * In arg:    stack
 * In global: split_cutoff
 * Ret val:   number of tours with length < split_cutoff
 */
int Short_tour_count(my_stack_t stack) {
   int tour = 0;

   for (tour = 0; tour < stack->list_sz; tour++)
      if (stack->list[tour]->count >= split_cutoff)
         break;
   return tour;
}  /* Short_tour_count */

/*---------------------------------------------------------------------
 * Function:  Fulfill_request
 * Purpose:   See if there are requests for work from other processes.
 *            If there are, fulfill one and send rejects to the others.
 *            Otherwise, just return
 * In arg:    tour_count:  the number of tours in stack with < 
 *            split_cutoff cities
 * In/out arg:  stack, avail
 */
void Fulfill_request(my_stack_t stack, int tour_count,
      my_stack_t avail) {
   int request_recd, buf = 0, dest;
   MPI_Status status;

   MPI_Iprobe(MPI_ANY_SOURCE, WORK_REQ_TAG, comm, &request_recd,
         &status);
   if (!request_recd) return;
   dest = status.MPI_SOURCE;
   MPI_Recv(&buf, 0, MPI_INT, dest, WORK_REQ_TAG, comm, MPI_STATUS_IGNORE);
   Send_work(stack, dest, tour_count, avail);

   Send_rejects();
}  /* Fulfill_request */

/*---------------------------------------------------------------------
 * Function:  Send_work
 * Purpose:   Split the current process' stack and send work to
 *            dest process
 * In args:     dest, tour_count = number of tours in stack with fewer
 *                 than split_cutoff cities
 * In/out arg:  stack
 */
void Send_work(my_stack_t stack, int dest, int tour_count, 
      my_stack_t avail) {
   int pack_size;

#  ifdef TERM_DEBUG
   printf("Proc %d > my_energy = 1/2^%u before send to %d\n",
         my_rank, my_energy, dest);
#  endif
   Split_stack(stack, tour_count, &pack_size, avail);
#  ifdef TERM_DEBUG
   printf("Proc %d > Sending work to %d, pack_size = %d\n", 
         my_rank, dest, pack_size);
#  endif

   MPI_Send(work_buf, pack_size, MPI_PACKED, dest, FULFILL_REQ_TAG, 
         comm);

#  ifdef TERM_DEBUG
   printf("Proc %d > my_energy = 1/2^%u after send to %d\n",
         my_rank, my_energy, dest);
#  endif

#  ifdef STATS
   work_reqs_fulfilled++;
#  endif

}  /* Send_work */

/*------------------------------------------------------------------
 * Function:    Split_stack
 * Purpose:     Pack tour_count tours into send_work_buf.  The tours
 *              that are packed alternate with those that are retained.
 * In arg:      tour_count = number of tours in stack with fewer
 *                 than split_cutoff cities.
 * Out arg:     pack_size
 * In/out arg:  stack
 * Out global:  send_work_buf
 */
void Split_stack(my_stack_t stack, int tour_count, int* pack_size_p,
      my_stack_t avail) {
   int new_src, new_dest, old_src = 0, old_dest;
   int tours_to_be_sent = tour_count/2;
   int pack_size = 0;

#  ifdef TERM_DEBUG
   printf("Proc %d > Splitting stack, tours_to_be_sent = %d, stack = %p, stack->list_sz = %d\n",
         my_rank, tours_to_be_sent, stack, stack->list_sz);
   fflush(stdout);
#  endif

   MPI_Pack(&tours_to_be_sent, 1, MPI_INT, work_buf, work_buf_alloc, 
         &pack_size, comm);

   old_dest = 1;
   new_src = 1;
   for (new_dest = 0; new_dest < tours_to_be_sent; new_dest++) {
      old_src = new_src+1;
#     ifdef TERM_DEBUG
      printf("Proc %d > Packing stack->list[%d] = %p, pack_size = %d\n",
         my_rank, new_src, stack->list[new_src], pack_size);
      fflush(stdout);
#     endif
      MPI_Pack(&stack->list[new_src]->count, 1, MPI_INT, 
            work_buf, work_buf_alloc, &pack_size, comm);
      MPI_Pack(&stack->list[new_src]->cost, 1, MPI_INT, 
            work_buf, work_buf_alloc, &pack_size, comm);
      MPI_Pack(stack->list[new_src]->cities, stack->list[new_src]->count, 
            MPI_INT, work_buf, work_buf_alloc, &pack_size, comm);
      Free_tour(stack->list[new_src], avail);
      if (old_src < stack->list_sz) 
         stack->list[old_dest++] = stack->list[old_src];
      new_src += 2;
   }

   old_src++;
   for ( ; old_src < stack->list_sz; old_src++, old_dest++)
      stack->list[old_dest] = stack->list[old_src];
   stack->list_sz = old_dest;
#  ifdef DEBUG
   printf("Proc %d > new stack size = %d\n", my_rank, stack->list_sz);
   fflush(stdout);
#  endif
      
   my_energy++;
   MPI_Pack(&my_energy, 1, MPI_UNSIGNED,
         work_buf, work_buf_alloc, &pack_size, comm);

#  ifdef TERM_DEBUG
   Print_stack(stack, "Updated old stack");
#  endif

   *pack_size_p = pack_size;
}  /* Split_stack */

/*---------------------------------------------------------------------
 * Function:  Send_rejects
 * Purpose:   Send a reject message to each process that's requested
 *            work
 */
void Send_rejects(void) {
   int req_recd, buf = 0;
   MPI_Status status;

   MPI_Iprobe(MPI_ANY_SOURCE, WORK_REQ_TAG, comm, &req_recd,
         &status);
   while (req_recd) {
      MPI_Recv(&buf, 0, MPI_INT, status.MPI_SOURCE, WORK_REQ_TAG,
            comm, MPI_STATUS_IGNORE);
      MPI_Send(&buf, 0, MPI_INT, status.MPI_SOURCE, REJECT_REQ_TAG, 
            comm);
#     ifdef TERM_DEBUG
      printf("Proc %d > Sent reject to %d\n", my_rank, status.MPI_SOURCE);
#     endif
      MPI_Iprobe(MPI_ANY_SOURCE, WORK_REQ_TAG, comm, &req_recd,
            &status);
   }
}  /* Send_rejects */


/*---------------------------------------------------------------------
 * Function:  Send_energy
 * Purpose:   Send my_energy to process 0 and set it to 0.  If current 
 *            process = 0, simply add my_energy into total_energy_recd
 * In/out global: my_energy 
 */
void Send_energy(void) {
   if (my_rank == 0)  {
      Add(total_energy_recd, my_energy);
#     ifdef TERM_DEBUG
      printf("Proc %d > added my_energy = 1/2^%u to total_energy_recd\n",
            my_rank, my_energy);
      Print_frac(total_energy_recd, my_rank, 
            "In Send_energy, total_energy_recd = ");
#     endif
   }  else {
#     ifdef TERM_DEBUG
      printf("Proc %d > Out of work, sending 1/2^%u to 0\n",
            my_rank, my_energy);
#     endif
      MPI_Send(&my_energy, 1, MPI_UNSIGNED, 0, ENERGY_TAG, comm);
   }
}  /* Send_energy */


/*---------------------------------------------------------------------
 * Function:  Send_work_request
 * Purpose:   Increment work_req_dest and send a request for work to 
 *            this destination.
 * In/out global:  work_req_dest
 * Note:      This assumes at least two processes
 */
void Send_work_request(void) {
   int buf = 0;
   work_req_dest = (work_req_dest + 1) % comm_sz;
   if (work_req_dest == my_rank) 
      work_req_dest = (work_req_dest + 1) % comm_sz;
   MPI_Send(&buf, 0, MPI_INT, work_req_dest, WORK_REQ_TAG, comm);
#  ifdef STATS
   work_reqs_sent++;
#  endif
}  /* Send_work_request */

/*---------------------------------------------------------------------
 * Function:  Check for work
 * Purpose:   Check the message queue to see if we've received
 *            work from work_req_dest.  If so, return with work_avail
 *            = TRUE (work_request_sent is a "don't care" in this
 *            case).  If not, check for a reject from work_req_dest.
 *            If we there's one in the queue, receive it, and 
 *            return with work_request_sent = TRUE and work_avail 
 *            = FALSE.  In case of TERM_DEBUG, check to see if there's
 *            some other message from work_request_dest in the queue.
 *            If so, print a message.   Even if TERM_DEBUG is off
 *            return with work_request_sent = TRUE and work_avail 
 *            = FALSE.  
 * In/out args:  work_request_sent_p (TRUE on entry)
 * Out arg:      work_avail_p
 * Note:
 * 1.  It appears that the sequence of Iprobes is important:  if the current
 *     process probes for a message from work_req_dest, it's possible 
 *     work_req_dest may have sent (say) a request for work to curr proc,
 *     which will be placed in the message queue *ahead* of a reject
 *     or a work fulfillment, and the work fulfillment may never be
 *     received.
 */
void Check_for_work(int* work_request_sent_p, int* work_avail_p) {
   int msg_recd, buf = 0;
   MPI_Status status;

   MPI_Iprobe(work_req_dest, FULFILL_REQ_TAG, comm, &msg_recd, &status);
   if (msg_recd) { /* We got work! */
#     ifdef TERM_DEBUG
      printf("Proc %d > Probed for any message, received work\n",
            my_rank);
#     endif
      *work_avail_p = TRUE;
   } else { /* We didn't get work */
      MPI_Iprobe(work_req_dest, REJECT_REQ_TAG, comm, &msg_recd, &status);
      if (msg_recd) {  /* We got a reject */
         MPI_Recv(&buf, 0, MPI_INT, work_req_dest, REJECT_REQ_TAG, comm,
               MPI_STATUS_IGNORE);
#        ifdef TERM_DEBUG
         printf("Proc %d > Probed for work from %d, got reject\n",
               my_rank, work_req_dest);
#        endif
         *work_request_sent_p = FALSE;
         *work_avail_p = FALSE;
      } else { /* We didn't get anything from work_req_dest */
#        ifdef TERM_DEBUG
         printf("Proc %d > Probed for work from %d, got nothing\n", 
               my_rank, work_req_dest);
         MPI_Iprobe(work_req_dest, MPI_ANY_TAG, comm, &msg_recd, &status);
         printf("Proc %d > Probed for work from %d, got tag %d\n",
               my_rank, work_req_dest, status.MPI_TAG);
#        endif
         *work_request_sent_p = TRUE;  // Not necessary
         *work_avail_p = FALSE;
      }  
   }  /* Didn't get work */ 
}  /* Check_for_work */


/*---------------------------------------------------------------------
 * Function:  Receive_work
 * Purpose:   Receive work from work_req_dest
 * In/out args:  stack, avail
 * In global:  work_req_dest
 */
void Receive_work(my_stack_t stack, my_stack_t avail) {
   int unpack_size = 0, i, stack_sz;
   tour_t tour;

   MPI_Recv(work_buf, work_buf_alloc, MPI_PACKED, work_req_dest,
         FULFILL_REQ_TAG, comm, MPI_STATUS_IGNORE);
   
   /* Get the number of tours */
   MPI_Unpack(work_buf, work_buf_alloc, &unpack_size,
         &stack_sz, 1, MPI_INT, comm);

   for (i = 0; i < stack_sz; i++) {
      tour = Alloc_tour(avail);
      MPI_Unpack(work_buf, work_buf_alloc, &unpack_size,
            &tour->count, 1, MPI_INT, comm);
      MPI_Unpack(work_buf, work_buf_alloc, &unpack_size,
            &tour->cost, 1, MPI_INT, comm);
      MPI_Unpack(work_buf, work_buf_alloc, &unpack_size,
             tour->cities, tour->count, MPI_INT, comm);
      Push(stack, tour);
   }

   MPI_Unpack(work_buf, work_buf_alloc, &unpack_size,
         &my_energy, 1, MPI_UNSIGNED, comm);

#  ifdef TERM_DEBUG
   printf("Proc %d > received energy = 1/2^%u from %d\n",
         my_rank, my_energy, work_req_dest);
#  endif
}  /* Receive_work */

/*---------------------------------------------------------------------
 * Function:  Term_msg
 * Purpose:   If I'm process 0, first receive any messages with tag =
 *            ENERGY_TAG and add them into total_energy_recd.  When
 *            done receiving messages if total_energy_recd = comm_sz, send
 *            a termination message to every process and return TRUE.
 *            Otherwise just return FALSE.  
 *
 *            If I'm not process 0, check message queue for a TERM_TAG
 *            message.  If one is in the queue, receive it and return
 *            TRUE.  If one is not in the queue, return FALSE.
 * Global in: total_energy (on process 0 only)
 * Global in/out:  total_energy_recd (on process 0 only)
 */
int Term_msg(void) {
   int msg_recd, buf = 0;
   MPI_Status status;
   unsigned recd_frac;

   if (my_rank == 0) {
      MPI_Iprobe(MPI_ANY_SOURCE, ENERGY_TAG, comm, &msg_recd, &status);
      while (msg_recd) {
         MPI_Recv(&recd_frac, 1, MPI_UNSIGNED, status.MPI_SOURCE,
               ENERGY_TAG, comm, MPI_STATUS_IGNORE);
         Add(total_energy_recd, recd_frac);
#        ifdef TERM_DEBUG
         printf("Proc %d > Received energy = 1/2^%u from %d\n", 
               my_rank, recd_frac, status.MPI_SOURCE);
         Print_frac(total_energy_recd, my_rank, "total_energy_recd");
         Debug_print_frac(total_energy_recd);
         fflush(stdout);
#        endif
         MPI_Iprobe(MPI_ANY_SOURCE, ENERGY_TAG, comm, &msg_recd, &status);
      }
      if (Equals(total_energy_recd, total_energy)) {
#        ifdef TERM_DEBUG
         printf("Proc %d > sending term_msg\n", my_rank);
         Print_frac(total_energy_recd, my_rank, "total_energy_recd = ");
         printf("Proc %d > total_energy = %u\n", my_rank, total_energy);
#        endif
         Bcast_term_msg();
         return TRUE;
      } else {
         return FALSE;
      }
   } else { /* my_rank != 0 */
      MPI_Iprobe(0, TERM_TAG, comm, &msg_recd, &status);
      if (msg_recd) {
         MPI_Recv(&buf, 0, MPI_INT, 0, TERM_TAG, comm, MPI_STATUS_IGNORE);
         return TRUE;
      } else {
         return FALSE;
      }
   }

}  /* Term_msg */

/*---------------------------------------------------------------------
 * Function:  Bcast_term_msg
 * Purpose:   Process 0 sends a termination message to every process
 */
void Bcast_term_msg(void) {
   int dest, buf = 0;

   for (dest = 1; dest < comm_sz; dest++) 
      MPI_Send(&buf, 0, MPI_INT, dest, TERM_TAG, comm);
   
}  /* Bcast_term_msg */


/*---------------------------------------------------------------------
 * Function:  Cleanup_msg_queue
 * Purpose:   See what messages are outstanding after termination and
 *            receive them.
 */
void Cleanup_msg_queue(void) {
   int msg_recd;
   MPI_Status status;
#  ifdef VERBOSE
   char string[MAX_STRING];
#  endif
   char string1[MAX_STRING];
   int counts[7] = {0,0,0,0,0,0,0};

   MPI_Iprobe(MPI_ANY_SOURCE, MPI_ANY_TAG, comm, &msg_recd, &status);
   while (msg_recd) {
      /* Just receive the message . . . */
      MPI_Recv(work_buf, work_buf_alloc, MPI_BYTE, 
            status.MPI_SOURCE, status.MPI_TAG, comm, MPI_STATUS_IGNORE);
#     ifdef VERBOSE
      sprintf(string, "Proc %d > Cleanup:  from %d received a ", my_rank,
            status.MPI_SOURCE);
#     endif
      switch (status.MPI_TAG) {
         case 1: //TOUR_TAG:
#           ifdef VERBOSE
            sprintf(string + strlen(string), "tour");
#           endif
            counts[1]++;
            break;
         case 2:  //WORK_REQ_TAG:
#           ifdef VERBOSE
            sprintf(string + strlen(string), "work request");
#           endif
            counts[2]++;
            break;
         case 3: //FULFILL_REQ_TAG:
#           ifdef VERBOSE
            sprintf(string + strlen(string), "work!");
#           endif
            counts[3]++;
            break;
         case 4:  //REJECT_REQ_TAG:  
#           ifdef VERBOSE
            sprintf(string + strlen(string), "reject");
#           endif
            counts[4]++;
            break;
         case 5:  //TERM_TAG:
#           ifdef VERBOSE
            sprintf(string + strlen(string), "termination notice!");
#           endif
            counts[5]++;
            break;
         case 6:  //ENERGY_TAG;
#           ifdef VERBOSE
            sprintf(string + strlen(string), "energy!");
#           endif
            counts[6]++;
            break;
         default:
#           ifdef VERBOSE
            sprintf(string + strlen(string), "unknown message type");
#           endif
            counts[0]++;
            break;
      }
#     ifdef VERBOSE
      printf("%s\n", string);
#     endif
      MPI_Iprobe(MPI_ANY_SOURCE, MPI_ANY_TAG, comm, &msg_recd, &status);
   }
   sprintf(string1, "Unknown = %d, Tour = %d, Req = %d,Fulfil = %d, Reject = %d, Term = %d, Energy = %d",
         counts[0], counts[1], counts[2], 
         counts[3], counts[4], counts[5], counts[6]);
// printf("Proc %d > %s\n", my_rank, string1);
}  /* Cleanup_msg_queue */

/*---------------------------------------------------------------------
 * Function:  Check_for_error
 * Purpose:   Determine whether any process has encountered an error.
 *            If one has, terminate.
 */
void Check_for_error(
      int       local_ok   /* in */, 
      char      message[]  /* in */, 
      MPI_Comm  comm       /* in */) {
   int ok;

   MPI_Allreduce(&local_ok, &ok, 1, MPI_INT, MPI_MIN, comm);
   if (ok == 0) {
      int my_rank;
      MPI_Comm_rank(comm, &my_rank);
      if (my_rank == 0) {
         fprintf(stderr, "Proc %d > %s\n", my_rank, message);
         fflush(stderr);
      }
      MPI_Finalize();
      exit(-1);
   }
}  /* Check_for_error */
