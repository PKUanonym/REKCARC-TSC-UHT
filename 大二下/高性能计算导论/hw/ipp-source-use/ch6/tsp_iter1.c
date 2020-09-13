/* File:     tsp_iter1.c
 * Purpose:  Use iterative depth-first search to solve an instance of the 
 *           travelling salesman problem.  This version attempts to
 *           doesn't make copies of the tours when they're pushed onto
 *           the stack.  It also uses macros for push and pop.
 *
 * Compile:  gcc -g -Wall -o tsp_iter1 tsp_iter1.c
 *           Needs timer.h
 * Usage:    tsp_iter1 <matrix_file>
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
 * IPP:  Section 6.2.2 (pp. 303 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "timer.h"

const int INFINITY = 1000000;
const int NO_CITY = -1;
const int UNUSED = -2;
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

/* Each time a recursive call is made, a new city is added to the 
 * current tour.  The stack stores the cities. */
typedef struct {
   city_t* list;
   int list_sz;
}  stack_struct;
typedef stack_struct* my_stack_t;
#define EMPTY(stack) (stack->list_sz == 0?  TRUE: FALSE)
#define PUSH(stack,city) {stack->list[stack->list_sz] = city; \
                          (stack->list_sz)++;}

/* Global Vars:  Except for best_tour, all are constant after initialization */
int n;  /* Number of cities in the problem */
city_t home_town = 0;
tour_t best_tour;
cost_t* digraph;
#define Cost(city1, city2) (digraph[city1*n + city2])

void Usage(char* prog_name);
void Read_digraph(FILE* digraph_file);
void Print_digraph(void);

void Iterative_dfs(void);
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
void Push(my_stack_t stack, city_t city);
city_t Pop(my_stack_t stack);
int  Empty(my_stack_t stack);
void Free_stack(my_stack_t stack);

/*------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   FILE* digraph_file;
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

   best_tour = Alloc_tour();
   Init_tour(best_tour, INFINITY);
#  ifdef DEBUG
   Print_tour(best_tour, "Best tour");
   printf("City count = %d\n",  City_count(best_tour));
   printf("Cost = %d\n\n", Tour_cost(best_tour));
#  endif

   GET_TIME(start);
   Iterative_dfs();
   GET_TIME(finish);
   
   Print_tour(best_tour, "Best tour");
   printf("Cost = %d\n", best_tour->cost);
   printf("Elapsed time = %e seconds\n", finish-start);

   Free_tour(best_tour);
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
 * 1. The Update_best_tour function will modify the global var
 *    best_tour
 */
void Iterative_dfs(void) {
   city_t nbr, city;
   my_stack_t stack;
   tour_t curr_tour;

   curr_tour = Alloc_tour();
   Init_tour(curr_tour, 0);
#  ifdef DEBUG
   Print_tour(curr_tour, "Starting tour");
   printf("City count = %d\n",  City_count(curr_tour));
   printf("Cost = %d\n\n", Tour_cost(curr_tour));
#  endif

   stack = Init_stack();
   PUSH(stack, NO_CITY);
   for (city = n-1; city >= 1; city--)
      PUSH(stack, city);
   while (!EMPTY(stack)) {
      // Next two statements pop stack;
      city = stack->list[stack->list_sz-1];
      (stack->list_sz)--;
      if (city == NO_CITY) // End of child list, back up
         Remove_last_city(curr_tour);
      else if (Feasible(curr_tour, city)) { // Only check cost (visited checked
                                            //    when city was pushed)
         Add_city(curr_tour, city);
#        ifdef DEBUG
         Print_tour(curr_tour, "New tour");
         printf("\n");
#        endif
         if (City_count(curr_tour) == n) {
            if (Best_tour(curr_tour))
               Update_best_tour(curr_tour);
            Remove_last_city(curr_tour);
         } else {
            PUSH(stack, NO_CITY);
            for (nbr = n-1; nbr >= 1; nbr--)
               if (!Visited(curr_tour, nbr)) 
                  PUSH(stack, nbr);
         }
      }/* if Feasible */
   }  /* while !Empty */
   Free_stack(stack);
   Free_tour(curr_tour);
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

// for (i = 0; i <= n; i++)
//   tour2->cities[i] =  tour1->cities[i];
   memcpy(tour2->cities, tour1->cities, (n+1)*sizeof(city_t));
   tour2->count = tour1->count;
   tour2->cost = tour1->cost;
}  /* Copy_tour */

/*------------------------------------------------------------------
 * Function:  Add_city
 * Purpose:   Add city to the end of tour
 * In arg:
 *    new_city
 * In/out arg:
 *    tour
 */
void Add_city(tour_t tour, city_t new_city) {
   if (City_count(tour) != 0) {
      city_t old_last_city = Last_city(tour);
      tour->cost += Cost(old_last_city,new_city);
   }
   tour->cities[tour->count] = new_city;  
   (tour->count)++;
}  /* Add_city */

/*------------------------------------------------------------------
 * Function:  Remove_last_city
 * Purpose:   Remove last city from end of tour
 * In/out arg:
 *    tour
 * Note:      Function assumes at least one city in tour
 */
void Remove_last_city(tour_t tour) {
   city_t old_last_city = Last_city(tour);
   city_t new_last_city;
   
   tour->cities[tour->count-1] = NO_CITY;
   (tour->count)--;
   if (City_count(tour) > 0) {
      new_last_city = Last_city(tour);
      tour->cost -= Cost(new_last_city,old_last_city);
   } else {
      tour->cost = 0;
   }
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

   if (Tour_cost(tour) + Cost(last_city,city) < Tour_cost(best_tour))
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

   for (i = 1; i < City_count(tour); i++)
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
   tour_t tmp = malloc(sizeof(tour_struct));
   tmp->cities = malloc((n+1)*sizeof(city_t));
   return tmp;
}  /* Alloc_tour */

/*------------------------------------------------------------------
 * Function:  Free_tour
 * Purpose:   Free tour and its member variables
 * Out arg:   tour
 */
void Free_tour(tour_t tour) {
   free(tour->cities);
   free(tour);
}  /* Free_tour */

/*------------------------------------------------------------------
 * Function: Init_stack
 * Purpose:  Allocate storage for a new stack and initialize members
 * Out arg:  stack_p
 */
my_stack_t Init_stack(void) {
   int i;

   my_stack_t stack = malloc(sizeof(stack_struct));
   stack->list = malloc(n*n*sizeof(city_t));
   for (i = 0; i < n*n; i++)
      stack->list[i] = UNUSED;
   stack->list_sz = 0;

   return stack;
}  /* Init_stack */


/*------------------------------------------------------------------
 * Function:    Push
 * Purpose:     Add a new city to the top of the stack
 * In arg:      city
 * In/out arg:  stack
 * Error:       If the stack is full, print an error and exit
 */
void Push(my_stack_t stack, city_t city) {
   if (stack->list_sz == n*n) {
      fprintf(stderr, "Stack overflow!\n");
      exit(-1);
   }
   stack->list[stack->list_sz] = city;
   (stack->list_sz)++;
}  /* Push */


/*------------------------------------------------------------------
 * Function:  Pop
 * Purpose:   Reduce the size of the stack by returning the top
 * In arg:    stack
 * Ret val:   The tour on the top of the stack
 * Error:     If the stack is empty, print a message and exit
 */
city_t Pop(my_stack_t stack) {
   city_t tmp;

   if (stack->list_sz == 0) {
      fprintf(stderr, "Trying to pop empty stack!\n");
      exit(-1);
   }
   tmp = stack->list[stack->list_sz-1];
   stack->list[stack->list_sz-1] = UNUSED;
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

