/* File:     pth_nbody_basic.c
 *
 * Purpose:  Use Pthreads to parallelize a 2-dimensional n-body solver 
 *           that uses the basic algorithm. 
 *
 * Compile:  gcc -g -Wall -o pth_nbody_basic pth_nbody_basic.c -lm -lpthread
 *           To turn off output (e.g., when timing), define NO_OUTPUT
 *           To get verbose output, define DEBUG
 *           Needs timer.h
 *
 * Run:      ./pth_nbody_basic <number of threads> <number of particles>
 *              <number of timesteps>  <size of timestep> 
 *              <output frequency> <g|i>
 *              'g': generate initial conditions using a random number
 *                   generator
 *              'i': read initial conditions from stdin
 *           A stepsize of 0.01 is good for the automatically generated
 *           data.
 *
 * Input:    If 'g' is specified on the command line, none.  
 *           If 'i', mass, initial position and initial velocity of 
 *              each particle
 * Output:   If the output frequency is k, then position and velocity of 
 *              each particle at every kth timestep
 *
 * Force:    The force on particle i due to particle k is given by
 *
 *    -G m_i m_k (s_i - s_k)/|s_i - s_k|^3
 *
 * Here, m_j is the mass of particle j, s_j is its position vector
 * (at time t), and G is the gravitational constant (see below).  
 *
 * Note that the force on particle k due to particle i is 
 * -(force on i due to k).  So we can approximately halve the number 
 * of force computations, although this version doesn't exploit this.
 *
 * Integration:  We use Euler's method:
 *
 *    v_i(t+1) = v_i(t) + h v'_i(t)
 *    s_i(t+1) = s_i(t) + h v_i(t)
 *
 * Here, v_i(u) is the velocity of the ith particle at time u and
 * s_i(u) is its position.
 *
 * IPP:  Section 6.1.8 (pp. 289 and ff.)
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <pthread.h>
#include "timer.h"

#define DIM 2  /* Two-dimensional system */
#define X 0    /* x-coordinate subscript */
#define Y 1    /* y-coordinate subscript */

const double G = 6.673e-11;  /* Gravitational constant. */
                             /* Units are m^3/(kg*s^2)  */

const int BLOCK = 0;         /* Block partition of loop iterations  */
const int CYCLIC = 1;        /* Cyclic partition of loop iterations */

typedef double vect_t[DIM];  /* Vector type for position, etc. */

struct particle_s {
   double m;  /* Mass     */
   vect_t s;  /* Position */
   vect_t v;  /* Velocity */
};

/* Global, and hence shared, variables */
int thread_count;        /* Number of threads                             */
int n;                   /* Number of particles                           */
int n_steps;             /* Number of time steps                          */
double delta_t;          /* Size of each time step                        */
int output_freq;         /* Number of steps between output                */
struct particle_s* curr; /* Array containing states of particles          */
vect_t* forces;          /* Array containing total force on each particle */
int b_thread_count = 0;  /* Number of threads that have entered barrier   */
pthread_mutex_t b_mutex; /* Mutex used by barrier                         */
pthread_cond_t b_cond_var;  /* Condition variable used by barrier         */

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], char* g_i_p);
void Get_init_cond(void);
void Gen_init_cond(void);
void Output_state(double time);
void Loop_schedule(int my_rank, int thread_count, int n, int sched,
      int* first_p, int* last_p, int* incr_p);
void* Thread_work(void* rank);
void Compute_force(int part);
void Update_part(int part);
void Barrier_init(void);
void Barrier(void);
void Barrier_destroy(void);

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   char g_i;                   /* _G_enerate or _i_nput init conds */
   double start, finish;       /* For timing                       */
   long thread;                
   pthread_t* thread_handles;

   Get_args(argc, argv, &g_i);
   curr = malloc(n*sizeof(struct particle_s));
   forces = malloc(n*sizeof(vect_t));
   if (g_i == 'i')
      Get_init_cond();
   else
      Gen_init_cond();

   thread_handles = malloc(thread_count*sizeof(pthread_t));
   Barrier_init();

   GET_TIME(start);
#  ifndef NO_OUTPUT
   Output_state(0.0);
#  endif
   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], NULL,
          Thread_work, (void*) thread);

   for (thread = 0; thread < thread_count; thread++)
      pthread_join(thread_handles[thread], NULL);

   GET_TIME(finish);
   printf("Elapsed time = %e seconds\n", finish-start);

   Barrier_destroy();
   free(thread_handles);
   free(curr);
   free(forces);
   return 0;
}  /* main */

/*---------------------------------------------------------------------
 * Function: Usage
 * Purpose:  Print instructions for command-line and exit
 * In arg:   
 *    prog_name:  the name of the program as typed on the command-line
 */
void Usage(char* prog_name) {
   fprintf(stderr, "usage: %s <number of threads> <number of particles>\n",
         prog_name);
   fprintf(stderr, "   <number of timesteps>  <size of timestep>\n");
   fprintf(stderr, "   <output frequency> <g|i>\n");
   fprintf(stderr, "   'g': program should generate init conds\n");
   fprintf(stderr, "   'i': program should get init conds from stdin\n");
    
   exit(0);
}  /* Usage */


/*---------------------------------------------------------------------
 * Function:  Get_args
 * Purpose:   Get command line args
 * In args:
 *    argc:            number of command line args
 *    argv:            command line args
 * Global vars (all out):
 *    thread_count:    number of threads
 *    n:               number of particles
 *    n_steps:         number of timesteps
 *    delta_t:         the size of each timestep
 *    output_freq:     the number of timesteps between steps whose 
 *                     output is printed
 * Out args:
 *    g_i_p:           pointer to char which is 'g' if the init conds
 *                     should be generated by the program and 'i' if
 *                     they should be read from stdin
 */
void Get_args(int argc, char* argv[], char* g_i_p) {
   if (argc != 7) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   n = strtol(argv[2], NULL, 10);
   n_steps = strtol(argv[3], NULL, 10);
   delta_t = strtod(argv[4], NULL);
   output_freq = strtol(argv[5], NULL, 10);
   *g_i_p = argv[6][0];

   if (thread_count <= 0 || n <= 0 || n_steps < 0 ||
       delta_t <= 0) Usage(argv[0]);
   if (*g_i_p != 'g' && *g_i_p != 'i') Usage(argv[0]);

#  ifdef DDEBUG
   printf("thread_count = %d\n", thread_count);
   printf("n = %d\n", n);
   printf("n_steps = %d\n", n_steps);
   printf("delta_t = %e\n", delta_t);
   printf("output_freq = %d\n", output_freq);
   printf("g_i = %c\n", *g_i_p);
#  endif
}  /* Get_args */

/*---------------------------------------------------------------------
 * Function:  Get_init_cond
 * Purpose:   Read in initial conditions:  mass, position and velocity
 *            for each particle
 * Global vars:  
 *    n (in):      number of particles 
 *    curr (out):  array of n structs, each struct stores the mass (scalar),
 *      position (vector), and velocity (vector) of a particle 
 */
void Get_init_cond(void) {
   int part;

   printf("For each particle, enter (in order):\n");
   printf("   its mass, its x-coord, its y-coord, ");
   printf("its x-velocity, its y-velocity\n");
   for (part = 0; part < n; part++) {
      scanf("%lf", &curr[part].m);
      scanf("%lf", &curr[part].s[X]);
      scanf("%lf", &curr[part].s[Y]);
      scanf("%lf", &curr[part].v[X]);
      scanf("%lf", &curr[part].v[Y]);
   }
}  /* Get_init_cond */

/*---------------------------------------------------------------------
 * Function:  Gen_init_cond
 * Purpose:   Generate initial conditions:  mass, position and velocity
 *            for each particle
 * Global vars:  
 *    n (in):      number of particles (in)
 *    curr (out):  array of n structs, each struct stores the mass (scalar),
 *       position (vector), and velocity (vector) of a particle
 *
 * Note:      The initial conditions place all particles at
 *            equal intervals on the nonnegative x-axis with 
 *            identical masses, and identical initial speeds
 *            parallel to the y-axis.  However, some of the
 *            velocities are in the positive y-direction and
 *            some are negative.
 */
void Gen_init_cond(void) {
   int part;
   double mass = 5.0e24;
   double gap = 1.0e5;
   double speed = 3.0e4;

   srandom(1);
   for (part = 0; part < n; part++) {
      curr[part].m = mass;
      curr[part].s[X] = part*gap;
      curr[part].s[Y] = 0.0;
      curr[part].v[X] = 0.0;
//    if (random()/((double) RAND_MAX) >= 0.5)
      if (part % 2 == 0)
         curr[part].v[Y] = speed;
      else
         curr[part].v[Y] = -speed;
   }
}  /* Gen_init_cond */

/*---------------------------------------------------------------------
 * Function:  Loop_sched
 * Purpose:   Return the parameters for a block or a cyclic schedule
 *            for a for loop
 * In args:   
 *    my_rank:       rank of calling thread
 *    thread_count:  number of threads
 *    n:             number of loop iterations 
 *    sched:         schedule:  BLOCK or CYCLIC
 * Out args:
 *    first_p:       pointer to first loop index
 *    last_p:        pointer to value greater than last index
 *    incr_p:        loop increment
 */
void Loop_schedule(int my_rank, int thread_count, int n, int sched,
      int* first_p, int* last_p, int* incr_p) {
   if (sched == CYCLIC) {
      *first_p = my_rank;
      *last_p = n;
      *incr_p = thread_count;
   } else {  /* sched == BLOCK */
      int quotient = n/thread_count;
      int remainder = n % thread_count;
      int my_iters;
      *incr_p = 1;
      if (my_rank < remainder) {
         my_iters = quotient + 1;
         *first_p = my_rank*my_iters;
      } else {
         my_iters = quotient;
         *first_p = my_rank*my_iters + remainder;
      }
      *last_p = *first_p + my_iters;
   }

}  /* Loop_schedule */


/*---------------------------------------------------------------------
 * Function:  Thread_work
 * Purpose:   Execute an individual thread's contribution to finding
 *            the positions and velocities of the particles.
 * In arg:    
 *    rank:   thread's rank (0, 1, . . . , thread_count-1)
 * Global vars:
 *    thread_count (in):
 *    
 */
void* Thread_work(void* rank) {
   long my_rank = (long) rank;
   int step;    /* Current step      */
   int part;    /* Current particle  */
   double t;    /* Current Time      */
   int first;   /* My first particle */
   int last;    /* My last particle  */
   int incr;    /* Loop increment    */

   Loop_schedule(my_rank, thread_count, n, BLOCK, &first, &last, &incr);
   for (step = 1; step <= n_steps; step++) {
      t = step*delta_t;
      /* Particle n-1 will have all forces computed after call to
       * Compute_force(n-2, . . .) */
      for (part = first; part < last; part += incr)
         Compute_force(part);
      Barrier();
      for (part = first; part < last; part += incr)
         Update_part(part);
      Barrier();
#     ifndef NO_OUTPUT
      if (step % output_freq == 0 && my_rank == 0) {
         Output_state(t);
      }
#     endif
   }  /* for step */

   return NULL;
}  /* Thread_work */

/*---------------------------------------------------------------------
 * Function:  Output_state
 * Purpose:   Print the current state of the system
 * In arg:
 *    t:      current time
 * Global vars (all in):
 *    curr:   array with n elements, curr[i] stores the state (mass,
 *            position and velocity) of the ith particle
 *    n:      number of particles
 */
void Output_state(double time) {
   int part;
   printf("%.2f\n", time);
   for (part = 0; part < n; part++) {
//    printf("%.3e ", curr[part].m);
      printf("%3d %10.3e ", part, curr[part].s[X]);
      printf("  %10.3e ", curr[part].s[Y]);
      printf("  %10.3e ", curr[part].v[X]);
      printf("  %10.3e\n", curr[part].v[Y]);
   }
   printf("\n");
}  /* Output_state */


/*---------------------------------------------------------------------
 * Function:  Compute_force
 * Purpose:   Compute the total force on particle part.  This
 *            version does *not* exploit the symmetry (force on 
 *            particle i due to particle k) = -(force on particle 
 *            k due to particle i).
 * In arg:   
 *    part:   the particle on which we're computing the total force
 * Global vars:
 *    curr (in):  current state of the system:  curr[i] stores the mass,
 *       position and velocity of the ith particle
 *    n (in):     number of particles
 *    forces (out): forces[i] stores the total force on the ith particle
 *
 * Note: This function uses the force due to gravitation.  So 
 * the force on particle i due to particle k is given by
 *
 *    m_i m_k (s_k - s_i)/|s_k - s_i|^2
 *
 * Here, m_j is the mass of particle j and s_k is its position vector
 * (at time t). 
 */
void Compute_force(int part) {
   int k;
   double mg; 
   vect_t f_part_k;
   double len, len_3, fact;

#  ifdef DDEBUG
   printf("Current total force on particle %d = (%.3e, %.3e)\n",
         part, forces[part][X], forces[part][Y]);
#  endif
   forces[part][X] = forces[part][Y] = 0.0;
   for (k = 0; k < n; k++) {
      if (k != part) {
         /* Compute force on part due to k */
         f_part_k[X] = curr[part].s[X] - curr[k].s[X];
         f_part_k[Y] = curr[part].s[Y] - curr[k].s[Y];
         len = sqrt(f_part_k[X]*f_part_k[X] + f_part_k[Y]*f_part_k[Y]);
         len_3 = len*len*len;
         mg = -G*curr[part].m*curr[k].m;
         fact = mg/len_3;
         f_part_k[X] *= fact;
         f_part_k[Y] *= fact;
#        ifdef DEBUG
         printf("Force on particle %d due to particle %d = (%.3e, %.3e)\n",
               part, k, f_part_k[X], f_part_k[Y]);
#        endif

         /* Add force in to total forces */
         forces[part][X] += f_part_k[X];
         forces[part][Y] += f_part_k[Y];
      }
   }
}  /* Compute_force */


/*---------------------------------------------------------------------
 * Function:  Update_part
 * Purpose:   Update the velocity and position for particle part
 * In arg:
 *    part:    the particle we're updating
 * Global vars:
 *    forces (in):   forces[i] stores the total force on the ith particle
 *    n (in):        number of particles
 *    curr (in/out): curr[i] stores the mass, position and velocity of the
 *                   ith particle
 *
 * Note:  This version uses Euler's method to update both the velocity
 *    and the position.
 */
void Update_part(int part) {
   double fact = delta_t/curr[part].m;

#  ifdef DDEBUG
   printf("Before update of %d:\n", part);
   printf("   Position  = (%.3e, %.3e)\n", curr[part].s[X], curr[part].s[Y]);
   printf("   Velocity  = (%.3e, %.3e)\n", curr[part].v[X], curr[part].v[Y]);
   printf("   Net force = (%.3e, %.3e)\n", forces[part][X], forces[part][Y]);
#  endif
   curr[part].s[X] += delta_t * curr[part].v[X];
   curr[part].s[Y] += delta_t * curr[part].v[Y];
   curr[part].v[X] += fact * forces[part][X];
   curr[part].v[Y] += fact * forces[part][Y];
#  ifdef DDEBUG
   printf("Position of %d = (%.3e, %.3e), Velocity = (%.3e,%.3e)\n",
         part, curr[part].s[X], curr[part].s[Y],
               curr[part].v[X], curr[part].v[Y]);
#  endif
// curr[part].s[X] += delta_t * curr[part].v[X];
// curr[part].s[Y] += delta_t * curr[part].v[Y];
}  /* Update_part */


/*---------------------------------------------------------------------
 * Function:    Barrier_init
 * Purpose:     Initialize data structures needed for Barrier
 * Global vars (all out):  
 *    b_thread_count:  number of threads in the barrier
 *    b_mutex:         mutex used by barrier
 *    b_cond_var:      condition variable used by barrier
 */
void Barrier_init(void) {
   b_thread_count = 0;
   pthread_mutex_init(&b_mutex, NULL);
   pthread_cond_init(&b_cond_var, NULL);
}  /* Barrier_init */

/*---------------------------------------------------------------------
 * Function:    Barrier
 * Purpose:     Block until all threads have entered the barrier
 * Global vars:  
 *    thread_count (in):       total number of threads
 *    b_thread_count (in/out): number of threads in the barrier
 *    b_mutex (in/out):        mutex used by barrier
 *    b_cond_var (in/out):     condition variable used by barrier
 */
void Barrier(void) {
      pthread_mutex_lock(&b_mutex);
      b_thread_count++;
      if (b_thread_count == thread_count) {
         b_thread_count = 0;
         pthread_cond_broadcast(&b_cond_var);
      } else {
         // Wait unlocks mutex and puts thread to sleep.
         //    Put wait in while loop in case some other
         // event awakens thread.
         while (pthread_cond_wait(&b_cond_var, &b_mutex) != 0);
         // Mutex is relocked at this point.
      }
      pthread_mutex_unlock(&b_mutex);

}  /* Barrier */

/*---------------------------------------------------------------------
 * Function:    Barrier_destroy
 * Purpose:     Destroy data structures needed for Barrier
 * Global vars (all out):  
 *    b_mutex:         mutex used by barrier
 *    b_cond_var:      condition variable used by barrier
 */
void Barrier_destroy(void) {
   pthread_mutex_destroy(&b_mutex);
   pthread_cond_destroy(&b_cond_var);
}  /* Barrier_destroy */
