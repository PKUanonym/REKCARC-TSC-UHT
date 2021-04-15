/* File:     mpi_tsp_static.c
 *
 * Purpose:  Use iterative depth-first search and MPI to solve an 
 *           instance of the travelling salesman problem.  This version 
 *           partitions the search tree using breadth-first search.
 *           Then each process searches its assigned subtree.  There
 *           is no reassignment of tree nodes.  This version also attempts
 *           to reuse deallocated tours.  The best tour structure
 *           is broadcast using a loop of MPI_Bsends.
 *
 * Compile:  mpicc -g -Wall -o mpi_tsp_stat mpi_tsp_stat.c 
 * Usage:    mpiexec -n <proc count> mpi_tsp_stat <matrix_file>
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
 * IPP:  Section 6.2.11 (pp. 319 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

const int INFINITY = 1000000;
const int NO_CITY = -1;
const int FALSE = 0;
const int TRUE = 1;
const int MAX_STRING = 1000;
const int TOUR_TAG = 1;
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
char* mpi_buffer;

#ifdef STATS
/* For stats */
int best_costs_bcast = 0;
int best_costs_received = 0;
#endif

void Usage(char* prog_name);
void Read_digraph(FILE* digraph_file);
void Print_digraph(void);
void Check_for_error(int local_ok, char message[], MPI_Comm  comm);

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

void Look_for_best_tours(void);
void Bcast_tour_cost(cost_t tour_cost);
void Cleanup_msg_queue(void);

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

/*------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   FILE* digraph_file;
   double start, finish;
   int local_ok = 1, one_msg_sz;
   char usage[MAX_STRING];
   char* ret_buf;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
   sprintf(usage, "usage: mpiexec -n <procs> %s <digraph file>\n",
         argv[0]);

   if (my_rank == 0 && argc != 2) local_ok = 0;
   Check_for_error(local_ok, usage, comm);
   if (my_rank == 0) {
      digraph_file = fopen(argv[1], "r");
      if (digraph_file == NULL) local_ok = 0;
   }
   Check_for_error(local_ok, "Can't open digraph file", comm);
   Read_digraph(digraph_file);
   if (my_rank == 0) fclose(digraph_file);
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

   MPI_Type_contiguous(n+1, MPI_INT, &tour_arr_mpi_t);
   MPI_Type_commit(&tour_arr_mpi_t);

   MPI_Pack_size(1, MPI_INT, comm, &one_msg_sz);
   mpi_buffer = 
      malloc(100*comm_sz*(one_msg_sz + MPI_BSEND_OVERHEAD)*sizeof(char));
   MPI_Buffer_attach(mpi_buffer,
         100*comm_sz*(one_msg_sz + MPI_BSEND_OVERHEAD));

   start = MPI_Wtime();
   Par_tree_search();
   finish = MPI_Wtime();
   Cleanup_msg_queue();
   MPI_Barrier(comm);
   MPI_Buffer_detach(&ret_buf, &one_msg_sz);
   
   if (my_rank == 0) {
      Print_tour(loc_best_tour, "Best tour");
      printf("Cost = %d\n", loc_best_tour->cost);
      printf("Elapsed time = %e seconds\n", finish-start);
   }

#  ifdef STATS
   printf("bcasts = %d, costs received = %d\n",
         best_costs_bcast, best_costs_received);
#  endif
   MPI_Type_free(&tour_arr_mpi_t);
   free(loc_best_tour->cities);
   free(loc_best_tour);
   free(digraph);

   MPI_Finalize();
   return 0;
}  /* main */

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

   while (!Empty_stack(stack)) {
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
   int queue_size, init_tour_count;
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
   Print_queue(queue, 0, "Initial queue");
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
#        endif
#        ifdef VERBOSE_STATS
         printf("Proc %d > received cost %d\n", my_rank, tour_cost);
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
#  ifdef VERBOSE_STATS
   Print_tour(loc_best_tour, "Best tour");
   printf("Proc %d > cost = %d\n", my_rank, best_tour_cost);
#  endif
}  /* Update_best_tour */

/*------------------------------------------------------------------
 * Function:   Bcast_tour_cost
 * Purpose:    Asynchronous broadcast of tour cost
 *
 * Note:
 *    MPI_Bcast is a point of synchronization for the processes.
 *    So it can't be used.
 */
void Bcast_tour_cost(int tour_cost) {
   int dest;

   for (dest = 0; dest < comm_sz; dest++)
      if (dest != my_rank)
         MPI_Bsend(&tour_cost, 1, MPI_INT, dest, TOUR_TAG, comm);
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
      Print_tour(-1, tour, "About to be pushed onto stack");
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


/*---------------------------------------------------------------------
 * Function:  Cleanup_msg_queue
 * Purpose:   See what messages are outstanding after termination and
 *            receive them.
 */
void Cleanup_msg_queue(void) {
   int msg_recd;
   MPI_Status status;
   char string1[MAX_STRING];
   int counts[2] = {0,0};
   char work_buf[100000];

   MPI_Iprobe(MPI_ANY_SOURCE, MPI_ANY_TAG, comm, &msg_recd, &status);
   while (msg_recd) {
      /* Just receive the message . . . */
      MPI_Recv(work_buf, 100000, MPI_BYTE, status.MPI_SOURCE, 
            status.MPI_TAG, comm, MPI_STATUS_IGNORE);
      if (status.MPI_TAG == TOUR_TAG)
         counts[1]++;
      else  // Unknown
         counts[0]++;
      MPI_Iprobe(MPI_ANY_SOURCE, MPI_ANY_TAG, comm, &msg_recd, &status);
   }
   sprintf(string1, "Messages not received:  unknown = %d, tour = %d", 
         counts[0], counts[1]);
// printf("Proc %d > %s\n", my_rank, string1);
}  /* Cleanup_msg_queue */

/*-------------------------------------------------------------------
 * Function:  Check_for_error
 * Purpose:   See if any process has found an error.  Terminate
 *            if there has been an error.
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

