/* File:     tsp_iter2.c
 *
 * Purpose:  Use iterative depth-first search to solve an instance of the 
 *           travelling salesman problem.  This version pushes an entire
 *           copy of a tour onto the stack and it stores ``freed''
 *           tours in an "avail" stack.
 *
 * Compile:  gcc -g -Wall -o tsp_iter2 tsp_iter2.c
 * Usage:    tsp_iterative <matrix_file>
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
 * IPP:  Section 6.2.2 (pp. 304 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "timer.h"

const int INFINITY = 1000000;
const int NO_CITY = -1;
const int FALSE = 0;
const int TRUE = 1;

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
}  stack_struct;
typedef stack_struct* my_stack_t;

/* Global Vars:  Except for best_tour, and avail, all are constant after initialization */
int n;  /* Number of cities in the problem */
cost_t* digraph;
city_t home_town = 0;
tour_t best_tour;
#define Cost(city1, city2) (digraph[city1*n + city2])
my_stack_t avail;

void Usage(char* prog_name);
void Read_digraph(FILE* digraph_file);
void Print_digraph(void);

void Iterative_dfs(tour_t tour);
void Print_tour(tour_t tour, char* title);
int  Best_tour(tour_t tour); 
void Update_best_tour(tour_t tour);
void Copy_tour(tour_t tour1, tour_t tour2);
void Add_city(tour_t tour, city_t);
void Remove_last_city(tour_t tour);
int  Feasible(tour_t tour, city_t city);
int  Visited(tour_t tour, city_t city);
void Init_tour(tour_t tour, cost_t cost);
tour_t Alloc_tour(void);
void Free_tour(tour_t tour);

my_stack_t Init_stack(void);
void Push_avail(tour_t tour);
void Push(my_stack_t stack, tour_t tour);
tour_t Pop(my_stack_t stack);
int  Empty(my_stack_t stack);
void Free_stack(my_stack_t stack);
void Free_avail(void);

/*------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   FILE* digraph_file;
   tour_t tour;
   double start, finish;

   if (argc != 2) Usage(argv[0]);
   digraph_file = fopen(argv[1], "r");
   if (digraph_file == NULL) {
      fprintf(stderr, "Can't open %s\n", argv[1]);
      Usage(argv[0]);
   }
   Read_digraph(digraph_file);
   fclose(digraph_file);
#  ifdef DEBUG
   Print_digraph();
#  endif   
   avail = Init_stack();

   best_tour = Alloc_tour();
   Init_tour(best_tour, INFINITY);
#  ifdef DEBUG
   Print_tour(best_tour, "Best tour");
   printf("City count = %d\n",  City_count(best_tour));
   printf("Cost = %d\n\n", Tour_cost(best_tour));
#  endif
   tour = Alloc_tour();
   Init_tour(tour, 0);
#  ifdef DEBUG
   Print_tour(tour, "Starting tour");
   printf("City count = %d\n",  City_count(tour));
   printf("Cost = %d\n\n", Tour_cost(tour));
#  endif

   GET_TIME(start);
   Iterative_dfs(tour);
   GET_TIME(finish);
   Free_tour(tour);
   
   Print_tour(best_tour, "Best tour");
   printf("Cost = %d\n", best_tour->cost);
   printf("Elapsed time = %e seconds\n", finish-start);

   free(best_tour->cities);
   free(best_tour);
   Free_avail();
   free(digraph);
   return 0;
}  /* main */

/*------------------------------------------------------------------
 * Function:  Init_tour
 * Purpose:   Initialize the data member of allocated tour
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
   fprintf(stderr, "usage: %s <digraph file>\n", prog_name);
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
 * Function:    Iterative_dfs
 * Purpose:     Use a stack variable to implement an iterative version
 *              of depth-first search
 * In arg:     
 *    tour:     partial tour of cities visited so far (just city 0)
 * Globals in:
 *    n:        total number of cities in the problem
 * Notes:
 * 1  The input tour is modified during execution of search,
 *    but returned to its original state before returning.
 * 2. The Update_best_tour function will modify the global var
 *    best_tour
 */
void Iterative_dfs(tour_t tour) {
   city_t nbr;
   my_stack_t stack;
   tour_t curr_tour;

   stack = Init_stack();
   Push(stack, tour);
   while (!Empty(stack)) {
      curr_tour = Pop(stack);
#     ifdef DEBUG
      printf("Popped tour = %p and %p\n", curr_tour, curr_tour->cities);
      Print_tour(curr_tour, "Popped");
      printf("\n");
#     endif
      if (City_count(curr_tour) == n) {
         if (Best_tour(curr_tour))
            Update_best_tour(curr_tour);
      } else {
         for (nbr = n-1; nbr >= 1; nbr--) 
            if (Feasible(curr_tour, nbr)) {
               Add_city(curr_tour, nbr);
               Push(stack, curr_tour);
               Remove_last_city(curr_tour);
            }
      }
      Free_tour(curr_tour);
   }
   Free_stack(stack);
}  /* Iterative_dfs */

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
 *    The input tour hasn't had the home_town added as the last
 *    city before the call to Update_best_tour.  So we call
 *    Add_city(best_tour, hometown) before returning.
 */
void Update_best_tour(tour_t tour) {
   Copy_tour(tour, best_tour);
   Add_city(best_tour, home_town);
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
 */
void Print_tour(tour_t tour, char* title) {
   int i;

   printf("%s:\n", title);
   for (i = 0; i < City_count(tour); i++)
      printf("%d ", Tour_city(tour,i));
   printf("\n");
}  /* Print_tour */

/*------------------------------------------------------------------
 * Function:  Alloc_tour
 * Purpose:   Allocate memory for a tour and its members
 * Global in: n, number of cities
 * Ret val:   Pointer to a tour_struct with storage allocated for its
 *            members
 */
tour_t Alloc_tour(void) {
   tour_t tmp;

   if (!Empty(avail))
      return Pop(avail);
   else {
      tmp = malloc(sizeof(tour_struct));
      tmp->cities = malloc((n+1)*sizeof(city_t));
      return tmp;
   }
}  /* Alloc_tour */

/*------------------------------------------------------------------
 * Function:  Free_tour
 * Purpose:   Push a tour onto the avail stack
 * In arg:    tour
 */
void Free_tour(tour_t tour) {
   Push_avail(tour);
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

   return stack;
}  /* Init_stack */


/*------------------------------------------------------------------
 * Function:    Push_avail
 * Purpose:     Store a tour in the available list
 * In arg:      tour
 * In/out Global:  
 */
void Push_avail(tour_t tour) {
   if (avail->list_sz == n*n) {
      fprintf(stderr, "Available stack overflow!\n");
      free(tour->cities);
      free(tour);
   } else {
#     ifdef DEBUG
      printf("In Push_avail, loc = %d, pushing %p and %p\n",
            avail->list_sz, tour, tour->cities);
      Print_tour(tour, "About to be pushed onto avail");
      printf("\n");
#     endif
      avail->list[avail->list_sz] = tour;
      (avail->list_sz)++;
   }
}  /* Push_avail */

/*------------------------------------------------------------------
 * Function:    Push
 * Purpose:     Add a new tour to the top of the stack
 * In arg:      tour
 * In/out arg:  stack
 * Error:       If the stack is full, print an error and exit
 */
void Push(my_stack_t stack, tour_t tour) {
   tour_t tmp;
   if (stack->list_sz == n*n) {
      fprintf(stderr, "Stack overflow!\n");
      exit(-1);
   }
   tmp = Alloc_tour();
   Copy_tour(tour, tmp);
   stack->list[stack->list_sz] = tmp;
   (stack->list_sz)++;
}  /* Push */


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
 * Function:  Empty
 * Purpose:   Determine whether the stack is empty
 * In arg:    stack
 * Ret val:   TRUE if empty, FALSE otherwise
 */
int  Empty(my_stack_t stack) {
   if (stack->list_sz == 0)
      return TRUE;
   else
      return FALSE;
}  /* Empty */


/*------------------------------------------------------------------
 * Function:  Free_stack
 * Purpose:   Free stack and its members
 * Out arg:   stack
 * Note:      Assumes stack is empty
 */
void Free_stack(my_stack_t stack) {
   free(stack->list);
   free(stack);
}  /* Free_stack */

/*------------------------------------------------------------------
 * Function:  Free_avail
 * Purpose:   Free the stack of available tours
 * Out arg:   avail
 */
void Free_avail(void) {
   int i;
   tour_t tmp;
#  ifdef DEBUG
   printf("In Free_avail, list_sz = %d\n", avail->list_sz);
#  endif
   for (i = 0; i < avail->list_sz; i++) {
      tmp = avail->list[i];
      if (tmp != NULL) {
#        ifdef DEBUG
         printf("In Free_avail, i = %d, attempting to free %p and %p\n",
               i, tmp->cities, tmp);
#        endif
         free(tmp->cities);
         free(tmp);
      }
   }
   free(avail->list);
   free(avail);
}  /* Free_avail */
