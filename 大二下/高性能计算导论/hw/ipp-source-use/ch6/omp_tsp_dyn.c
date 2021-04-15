/* File:     omp_tsp_dyn.c
 * Purpose:  Use iterative depth-first search and OpenMP to solve an 
 *           instance of the travelling salesman problem.  This version 
 *           partitions the search tree using breadth-first search.
 *           Then each thread searches its assigned subtree.  When
 *           a thread runs out of work it goes into a condition wait
 *           until either another thread gives it work or all the work
 *           is completed.  This version attempts to reuse deallocated tours.
 *
 * Compile:  gcc -g -Wall -fopenmp -o omp_tsp_dyn omp_tsp_dyn.c
 * Usage:    omp_tsp_dyn <thread count> <matrix_file> <min split size>
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
 *
 * IPP:  Section 6.2.9  (pp. 316 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

#undef TERM_DEBUG

const int INFINITY = 1000000;
const int NO_CITY = -1;
const int FALSE = 0;
const int TRUE = 1;
const int MAX_STRING = 1000;

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
   my_stack_t stack;
   long* queue;        // List of terminated threads
   int queue_alloc;
   int head;
   int tail;
   int full;
   volatile int queue_count;  // Number of terminated threads
// int queue_count;  // Number of terminated threads
   omp_lock_t lock;
   volatile int wake_one_thread;
   volatile int wake_all_threads;
// int wake_one_thread;
// int wake_all_threads;
} term_struct;
typedef term_struct* term_t;

/* Global Vars: */
int n;  /* Number of cities in the problem */
int thread_count;
cost_t* digraph;
#define Cost(city1, city2) (digraph[city1*n + city2])
city_t home_town = 0;
tour_t best_tour;
my_queue_t queue;
int queue_size;
int init_tour_count;
int min_split_sz;
term_t term;

/* Statistics */
int stack_splits = 0;

void Usage(char* prog_name);
void Read_digraph(FILE* digraph_file);
void Print_digraph(void);

void Par_tree_search(void);
void Partition_tree(int my_rank, my_stack_t stack);
void Set_init_tours(int my_rank, int* my_first_tour_p,
      int* my_last_tour_p);
void Build_initial_queue(void);
void Print_tour(int my_rank, tour_t tour, char* title);
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

int  Terminated(my_stack_t* stack_p, int my_rank);
void Init_term(void);
void Free_term(void);
my_stack_t Split_stack(my_stack_t stack, int my_rank);
void Wake_one_thread(void);
int Term_queue_empty(void);
void Term_enqueue(int my_rank);
void Term_wait(int my_rank);
void Print_term_queue(int my_rank, char title[]);

my_stack_t Init_stack(void);
void Push(my_stack_t stack, tour_t tour);  // Push pointer
void Push_copy(my_stack_t stack, tour_t tour, my_stack_t avail); 
tour_t Pop(my_stack_t stack);
int  Empty_stack(my_stack_t stack);
void Free_stack(my_stack_t stack);
void Print_stack(my_stack_t stack, int my_rank, char title[]);

/* Circular queue */
my_queue_t Init_queue(int size);
tour_t Dequeue(my_queue_t queue);
void Enqueue(my_queue_t queue, tour_t tour);
int Empty_queue(my_queue_t queue);
void Free_queue(my_queue_t queue);
void Print_queue(my_queue_t queue, int my_rank, char title[]);
int Get_upper_bd_queue_sz(void);
long long Fact(int k);


/*------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   FILE* digraph_file;
   double start, finish;

   if (argc != 4) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   if (thread_count <= 0) {
      fprintf(stderr, "Thread count must be positive\n");
      Usage(argv[0]);
   }
   digraph_file = fopen(argv[2], "r");
   if (digraph_file == NULL) {
      fprintf(stderr, "Can't open %s\n", argv[2]);
      Usage(argv[0]);
   }
   min_split_sz = strtol(argv[3], NULL, 10);
   if (min_split_sz <= 0) {
      fprintf(stderr, "Min split size should be positive\n");
      Usage(argv[0]);
   }
   Read_digraph(digraph_file);
   fclose(digraph_file);
#  ifdef DEBUG
   Print_digraph();
#  endif   

   Init_term();

   best_tour = Alloc_tour(NULL);
   Init_tour(best_tour, INFINITY);
#  ifdef DEBUG
   Print_tour(-1, best_tour, "Best tour");
   printf("City count = %d\n",  City_count(best_tour));
   printf("Cost = %d\n\n", Tour_cost(best_tour));
#  endif

   start = omp_get_wtime();
#  pragma omp parallel num_threads(thread_count)
   Par_tree_search();
   finish = omp_get_wtime();
   
   Print_tour(-1, best_tour, "Best tour");
   printf("Cost = %d\n", best_tour->cost);
   printf("Elapsed time = %e seconds\n", finish-start);

#  ifdef STATS
   printf("Stack splits = %d\n", stack_splits);
#  endif

   free(best_tour->cities);
   free(best_tour);
   free(digraph);
   Free_term();
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
 * Function:  Usage
 * Purpose:   Inform user how to start program and exit
 * In arg:    prog_name
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage: %s <thread_count> <digraph file> <min split size>\n",
         prog_name);
   exit(0);
}  /* Usage */

/*------------------------------------------------------------------
 * Function:  Read_digraph
 * Purpose:   Read in the number of cities and the digraph of costs
 * In arg:    digraph_file
 * Globals out:
 *    n:        the number of cities
 *    digraph:  the matrix file
 */
void Read_digraph(FILE* digraph_file) {
   int i, j;

   fscanf(digraph_file, "%d", &n);
   if (n <= 0) {
      fprintf(stderr, "Number of vertices in digraph must be positive\n");
      exit(-1);
   }
   digraph = malloc(n*n*sizeof(cost_t));

   for (i = 0; i < n; i++)
      for (j = 0; j < n; j++) {
         fscanf(digraph_file, "%d", &digraph[i*n + j]);
         if (i == j && digraph[i*n + j] != 0) {
            fprintf(stderr, "Diagonal entries must be zero\n");
            exit(-1);
         } else if (i != j && digraph[i*n + j] <= 0) {
            fprintf(stderr, "Off-diagonal entries must be positive\n");
            fprintf(stderr, "diagraph[%d,%d] = %d\n", i, j, digraph[i*n+j]);
            exit(-1);
         }
      }
}  /* Read_digraph */


/*------------------------------------------------------------------
 * Function:  Print_digraph
 * Purpose:   Print the number of cities and the digraphrix of costs
 * Globals in:
 *    n:        number of cities
 *    digraph:  digraph of costs
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
 * Globals in:
 *    n:        total number of cities in the problem
 * Notes:
 * 1. The Update_best_tour function will modify the global var
 *    best_tour
 */
void Par_tree_search(void) {
   int my_rank = omp_get_thread_num();
   city_t nbr;
   my_stack_t stack;  // Stack for searching
   my_stack_t avail;  // Stack for unused tours
   tour_t curr_tour;

   avail = Init_stack();
   stack = Init_stack();
   Partition_tree(my_rank, stack);

   while (!Terminated(&stack, my_rank)) {
      curr_tour = Pop(stack);
#     ifdef PTSDEBUG
      Print_tour(my_rank, curr_tour, "Popped");
#     endif
      if (City_count(curr_tour) == n) {
         if (Best_tour(curr_tour)) {
#           ifdef PTSDEBUG
            Print_tour(my_rank, curr_tour, "Best tour");
#           endif
#           pragma omp critical
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
   Free_stack(avail);
#  pragma omp barrier
#  pragma omp master
   Free_queue(queue);

}  /* Par_tree_search */


/*------------------------------------------------------------------
 * Function:  Partition_tree
 * Purpose:   Assign each thread its initial collection of subtrees
 * In arg:    
 *    my_rank
 * Out args:   
 *    stack:  stack will store each thread's initial tours
 *
 * Global scratch:  
 *    queue_size
 *    queue
 *
 */
void Partition_tree(int my_rank, my_stack_t stack) {
   int my_first_tour, my_last_tour, i;

#  pragma omp master
   queue_size = Get_upper_bd_queue_sz();

#  pragma omp barrier
#  ifdef DEBUG
   printf("Th %d > queue_size = %d\n", my_rank, queue_size);
#  endif
   if (queue_size == 0) exit(-1);

#  pragma omp master
   Build_initial_queue();
#  pragma omp barrier
   Set_init_tours(my_rank, &my_first_tour, &my_last_tour);
#  ifdef DEBUG
   printf("Th %d > init_tour_count = %d, first = %d, last = %d\n", 
         my_rank, init_tour_count, my_first_tour, my_last_tour);
#  endif
   for (i = my_last_tour; i >= my_first_tour; i--) {
#     ifdef DEBUG
      Print_tour(my_rank, Queue_elt(queue,i), "About to push");
#     endif
      Push(stack, Queue_elt(queue,i));
   }
#  ifdef PTSDEBUG
   Print_stack(stack, my_rank, "After set up");
#  endif

}  /* Partition_tree */

/*------------------------------------------------------------------
 * Function:   Set_init_tours
 * Purpose:    Determine which tours in the initial queue should be
 *             assigned to this thread
 * In arg:
 *    my_rank
 * Out args:
 *    my_first_tour_p
 *    my_last_tour_p
 * Globals in:
 *    thread_count
 *    init_tour_count:  the number of tours in the initial queue
 *
 * Note:  A block partition is used.
 */
void Set_init_tours(int my_rank, int* my_first_tour_p,
      int* my_last_tour_p) {
   int quotient, remainder, my_count;

   quotient = init_tour_count/thread_count;
   remainder = init_tour_count % thread_count;
   if (my_rank < remainder) {
      my_count = quotient+1;
      *my_first_tour_p = my_rank*my_count;
   } else {
      my_count = quotient;
      *my_first_tour_p = my_rank*my_count + remainder;
   }
   *my_last_tour_p = *my_first_tour_p + my_count - 1;
}   /* Set_init_tours */


/*------------------------------------------------------------------
 * Function:  Build_initial_queue
 * Purpose:   Build queue of tours to be divided among processes/threads
 * Global Scratch:
 *    queue
 * Global Out
 *    init_queue_size
 *
 * Note:  Only called by one process/thread
 */
void Build_initial_queue(void) {
   int curr_sz = 0;
   city_t nbr;
   tour_t tour = Alloc_tour(NULL);

   Init_tour(tour, 0);
   queue = Init_queue(2*queue_size);

   /* Breadth-first search */
   Enqueue(queue, tour);  // Enqueues a copy
// printf("Freeing %p\n", tour);
   Free_tour(tour, NULL);
   curr_sz++;
   while (curr_sz < thread_count) {
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
   init_tour_count = curr_sz; 

#  ifdef DEBUG
   Print_queue(queue, 0, "Initial queue");
#  endif
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

   if (cost_so_far + Cost(last_city, home_town) < Tour_cost(best_tour))
      return TRUE;
   else
      return FALSE;
}  /* Best_tour */


/*------------------------------------------------------------------
 * Function:    Update_best_tour
 * Purpose:     Replace the existing best tour with the input tour +
 *              hometown
 * In arg:
 *    tour:     tour that's visited all n-cities
 * Global out:
 *    best_tour:  the current best tour
 * Note: 
 * 1. The input tour hasn't had the home_town added as the last
 *    city before the call to Update_best_tour.  So we call
 *    Add_city(best_tour, hometown) before returning.
 * 2. The call to Best_tour is necessary.  Without, we can get
 *    the following race:
 *
 *       best_tour_cost = 1000
 *       Time       Th 0                 Th 1
 *       ----       ----                 ----
 *        0         tour->cost = 10     
 *        1         Best_tour ret true   tour->cost = 20
 *        2                              Best_tour ret true
 *        3         Enter crit sect
 *        4         best_tour_cost = 10  Wait on crit sect
 *        5         Leave crit sect
 *        6                              Enter crit sect
 *        7                              best_tour_cost = 20
 *        8                              Leave crit sect
 *
 */
void Update_best_tour(tour_t tour) {
   if (Best_tour(tour)) {
      Copy_tour(tour, best_tour);
      Add_city(best_tour, home_town);
   } 
}  /* Update_best_tour */


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
 *    best_tour
 * Return:    TRUE if the nbr can be added to the current tour.
 *            FALSE otherwise
 */
int Feasible(tour_t tour, city_t city) {
   city_t last_city = Last_city(tour);

   if (!Visited(tour, city) && 
        Tour_cost(tour) + Cost(last_city,city) < Tour_cost(best_tour))
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
void Print_tour(int my_rank, tour_t tour, char* title) {
   int i;
   char string[MAX_STRING];

   if (my_rank >= 0)
      sprintf(string, "Th %d > %s %p: ", my_rank, title, tour);
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
//    fprintf(stderr, "Stack overflow in Push!\n");
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
 *
 * Note:      As long as min_split_sz is >= 2, splitting the
 *            stack can't empty the stack.  So the member
 *            list_sz will only be set to 0 by the thread
 *            that owns the stack.
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
void Print_stack(my_stack_t stack, int my_rank, char title[]) {
   char string[MAX_STRING];
   int i, j;

   printf("Th %d > %s\n", my_rank, title);
   for (i = 0; i < stack->list_sz; i++) {
      sprintf(string, "Th %d > ", my_rank);
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
void Print_queue(my_queue_t queue, int my_rank, char title[]) {
   char string[MAX_STRING];
   int i, j;

   printf("Th %d > %s\n", my_rank, title);
   for (i = queue->head; i != queue->tail; i = (i+1) % queue->list_alloc) {
      sprintf(string, "Th %d > %p = ", my_rank, queue->list[i]);
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
 *    thread_count:  number of threads
 *    n:             number of cities
 *
 */
int Get_upper_bd_queue_sz(void) {
   int fact = n-1;
   int size = n-1;

   while (size < thread_count) {
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
 * Purpose:   Determine whether there is any remaining work.  If there
 *            is, and there is no local work wait on work from another
 *            thread.
 * In/out arg:  stack
 * In/out global:  term
 */
int  Terminated(my_stack_t* stack_p, int my_rank) {
   my_stack_t stack = *stack_p;
   int got_lock;
#  ifdef TERM_DEBUG
// printf("Th %d > Enter Terminated, stack size = %d\n", my_rank,
//       stack->list_sz);
#  endif

   if (stack->list_sz >= min_split_sz && term->queue_count > 0 &&
         term->stack == NULL) {  
             /* Lots of tours in stack */
      got_lock = omp_test_lock(&term->lock);
      if (got_lock == TRUE) {
         if (term->queue_count > 0 && term->stack == NULL) {
#           ifdef TERM_DEBUG
            printf("Th %d > about to split stack\n", my_rank);
#           endif
            term->stack = Split_stack(stack, my_rank);
#           ifdef STATS
            stack_splits++;
#           endif
            Wake_one_thread();
         }
         omp_unset_lock(&term->lock);
      }
      return FALSE;
   } else if (!Empty_stack(stack)) {  /* At least one tour in stack */
      return FALSE;
   } else {  /* my stack is empty */
      omp_set_lock(&term->lock);
      if (term->queue_count == thread_count-1) { /* Last thread running */
         term->queue_count++;
         term->wake_all_threads = 1;
         omp_unset_lock(&term->lock);
         Free_stack(stack);
         return TRUE;
      } else { /* Threads still running, wait for work */
         Free_stack(stack);
         Term_enqueue(my_rank);
#        ifdef TERM_DEBUG
         printf("Th %d > Entering wait\n", my_rank);
         Print_term_queue(my_rank, "Before wait");
         fflush(stdout);
#        endif
         omp_unset_lock(&term->lock);
         Term_wait(my_rank);
         omp_set_lock(&term->lock);
         if (term->queue_count < thread_count) {
            if (term->stack != NULL) {
#              ifdef TERM_DEBUG
               printf("Th %d > Getting new stack = %p\n", 
                     my_rank, term->stack);
#              endif
               *stack_p = stack = term->stack;
#              ifdef TERM_DEBUG
//             Print_stack(stack, my_rank, "New stack");
#              endif
               term->wake_one_thread = -1;
               term->stack = NULL;
               omp_unset_lock(&term->lock);
               return FALSE;
            } else { /* Uh oh . . .  */
               term->wake_one_thread = -1;
               omp_unset_lock(&term->lock);
               fprintf(stderr, "Th %d > Awakened with no work avail!\n",
                     my_rank);
               exit(-1);
            }
         } else { /* All threads done */
            omp_unset_lock(&term->lock);
            return TRUE;
         }
      } /* else wait for work */
   }  /* else my stack is empty */
}  /* Terminated */   


/*------------------------------------------------------------------
 * Function:  Init_term
 * Purpose:   Initialize global term struct
 * Out global:  term
 */
void Init_term(void) {
   term = malloc(sizeof(term_struct));
   term->stack = NULL;
   term->queue = malloc((thread_count+1)*sizeof(long));
   term->queue_alloc = thread_count+1;
   term->head = term->tail = 0;
   term->full = FALSE;
   term->queue_count = 0;
   term->wake_one_thread = -1;
   term->wake_all_threads = 0;
   omp_init_lock(&term->lock);
}  /* Init_term */


/*------------------------------------------------------------------
 * Function:  Free_term
 * Purpose:   Free the global term data structure
 * Out global:  term
 */
void Free_term(void) {
   omp_destroy_lock(&term->lock);
   free(term->queue);
   free(term);
}  /* Free_term */

/*------------------------------------------------------------------
 * Function:  Split_stack
 * Purpose:   Return a pointer to a new stack, nonempty stack
 *            created by taking half the records on the input stack
 * In/out arg:  stack
 * Ret val:     new stack
 */
my_stack_t Split_stack(my_stack_t stack, int my_rank) {
   int new_src, new_dest, old_src, old_dest;
   my_stack_t new_stack = Init_stack();

#  ifdef TERM_DEBUG
// Print_stack(stack, my_rank, "Original old stack");
#  endif

   new_dest = 0;
   old_dest = 1;
   for (new_src = 1; new_src < stack->list_sz; new_src += 2) {
      old_src = new_src+1;
      new_stack->list[new_dest++] = stack->list[new_src];
      if (old_src < stack->list_sz) 
         stack->list[old_dest++] = stack->list[old_src];
   }

   stack->list_sz = old_dest;
   new_stack->list_sz = new_dest;

#  ifdef TERM_DEBUG
// Print_stack(stack, my_rank, "Updated old stack");
// Print_stack(new_stack, my_rank, "New stack");
#  endif

   return new_stack;
}  /* Split_stack */


/*------------------------------------------------------------------
 * Function:   Wake_one_thread
 * Purpose:    Wake one of the threads that's busy waiting by dequeuing
 *             the term queue
 * In/out global:  term
 */
void Wake_one_thread(void) {
   if (Term_queue_empty()) {
      fprintf(stderr, "Trying to wake a thread when none are sleeping!\n");
      exit(-1);
   }
   int head = term->head;
   term->queue_count--;
   term->head = (term->head + 1) % term->queue_alloc;
   term->wake_one_thread = term->queue[head];
}  /* Wake_one_thread */

/*------------------------------------------------------------------
 * Function:       Term_enqueue(my_rank);
 * Purpose:        Add caller's rank to queue of waiting threads
 * In/out global:  term
 */
void Term_enqueue(int my_rank) {
   if (term->full == TRUE) {
      fprintf(stderr, "Term queue is full!\n");
      exit(-1);
   }
   term->queue[term->tail] = my_rank;
   term->tail = (term->tail+1) % term->queue_alloc;
   term->queue_count++;
   if (term->tail == term->head) term->full = TRUE;
}  /* Term_enqueue */

/*------------------------------------------------------------------
 * Function:  Term_wait
 * Purpose:   Busy wait until work becomes available or a thread
 *            indicates that there's no work left
 * In global: term
 */
void Term_wait(int my_rank) {
   while(term->wake_one_thread != my_rank &&
         term->wake_all_threads == FALSE);
}  /* Wait */


/*------------------------------------------------------------------
 * Function:  Term_queue_empty
 * Purpose:   Check whether term->queue is empty
 * In global: term
 */
int Term_queue_empty(void) {
   if (term->queue_count == 0)
      return TRUE;
   else
      return FALSE;
}  /* Term_queue_empty */


/*------------------------------------------------------------------
 * Function:  Print_term_queue
 * Purpose:   Print the contents of the term queue
 * In args:   all
 * In global: term
 */
void Print_term_queue(int my_rank, char title[]) {
   int i;
   char string[MAX_STRING];

   sprintf(string, "Th %d > %s, count = %d, queue = ", 
         my_rank, title, term->queue_count);
   for (i = term->head; i != term->tail; i = (i+1) % term->queue_alloc)
      sprintf(string + strlen(string), "%ld ", term->queue[i]);
   printf("%s\n", string); 
}  /* Print_term_queue */
