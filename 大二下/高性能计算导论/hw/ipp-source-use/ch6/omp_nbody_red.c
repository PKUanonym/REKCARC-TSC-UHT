/* File:     omp_nbody_red.c
 *
 * Purpose:  Use OpenMP to parallelize a 2-dimensional n-body solver 
 *           that uses the reduced algorithm.  This version uses one 
 *           array per thread to store locally computed forces.
 *           These forces are then added into a shared array.  It
 *           uses a block schedule for each of the parallel for
 *           except the loop that computes forces, which uses
 *           a cyclic distribution.
 *
 * Compile:  gcc -g -Wall -fopenmp -o omp_nbody_red omp_nbody_red.c -lm
 *           To turn off output (e.g., when timing), define NO_OUTPUT
 *           To get verbose output, define DEBUG
 *
 * Run:      ./omp_nbody_red <number of threads> <number of particles>
 *              <number of timesteps>  <size of timestep> 
 *              <output frequency> <g|i>
 *              'g': generate initial conditions using a random number
 *                   generator
 *              'i': read initial conditions from stdin
 *            0.01 seems to work well as a timestep for the automatically
 *            generated data.
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
 * of force computations.
 *
 * Integration:  We use Euler's method:
 *
 *    v_i(t+1) = v_i(t) + h v'_i(t)
 *    s_i(t+1) = s_i(t) + h v_i(t)
 *
 * Here, v_i(u) is the velocity of the ith particle at time u and
 * s_i(u) is its position.
 *
 * IPP:  Section 6.1.6 (pp. 284 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <omp.h>

#define DIM 2  /* Two-dimensional system */
#define X 0    /* x-coordinate subscript */
#define Y 1    /* y-coordinate subscript */

const double G = 6.673e-11;  /* Gravitational constant. */
                             /* Units are m^3/(kg*s^2)  */

typedef double vect_t[DIM];  /* Vector type for position, etc. */

struct particle_s {
   double m;  /* Mass     */
   vect_t s;  /* Position */
   vect_t v;  /* Velocity */
};

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], int* thread_count_p, int* n_p, 
      int* n_steps_p, double* delta_t_p, int* output_freq_p, char* g_i_p);
void Get_init_cond(struct particle_s curr[], int n);
void Gen_init_cond(struct particle_s curr[], int n);
void Output_state(double time, struct particle_s curr[], int n);
void Compute_force(int part, vect_t forces[], struct particle_s curr[], 
      int n);
void Update_part(int part, vect_t forces[], struct particle_s curr[], 
      int n, double delta_t);

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int n;                      /* Number of particles              */
   int n_steps;                /* Number of timesteps              */
   int step;                   /* Current step                     */
   int part;                   /* Current particle                 */
   int output_freq;            /* Frequency of output              */
   double delta_t;             /* Size of timestep                 */
   double t;                   /* Current Time                     */
   struct particle_s* curr;    /* Current state of system          */
   vect_t* forces;             /* Forces on each particle          */
   int thread_count;           /* Number of threads                */
   char g_i;                   /* _G_enerate or _i_nput init conds */
   double start, finish;       /* For timing                       */
   vect_t* loc_forces;         /* Forces computed by each thread   */

   Get_args(argc, argv, &thread_count, &n, &n_steps, &delta_t, 
         &output_freq, &g_i);
   curr = malloc(n*sizeof(struct particle_s));
   forces = malloc(n*sizeof(vect_t));
   loc_forces = malloc(thread_count*n*sizeof(vect_t));
   if (g_i == 'i')
      Get_init_cond(curr, n);
   else
      Gen_init_cond(curr, n);

   start = omp_get_wtime();
#  ifndef NO_OUTPUT
   Output_state(0, curr, n);
#  endif
#  pragma omp parallel num_threads(thread_count) default(none) \
      shared(curr,forces,thread_count,delta_t,n,n_steps, \
            output_freq,loc_forces) \
      private(step, part, t)
   {
      int my_rank = omp_get_thread_num();
      int thread;

      for (step = 1; step <= n_steps; step++) {
         t = step*delta_t;
//       memset(loc_forces + my_rank*n, 0, n*sizeof(vect_t));
#        pragma omp for
         for (part = 0; part < thread_count*n; part++)
            loc_forces[part][X] = loc_forces[part][Y] = 0.0;
#        ifdef DEBUG
#        pragma omp single
         {
            printf("Step %d, after memset loc_forces = \n", step);
            for (part = 0; part < thread_count*n; part++)
               printf("%d %e %e\n", part, loc_forces[part][X], 
                  loc_forces[part][Y]);
            printf("\n");
         }
#        endif
         /* Particle n-1 will have all forces computed after call to
          * Compute_force(n-2, . . .) */
#        pragma omp for schedule(static,1)
         for (part = 0; part < n-1; part++)
            Compute_force(part, loc_forces + my_rank*n, curr, n);
#        pragma omp for 
         for (part = 0; part < n; part++) {
            forces[part][X] = forces[part][Y] = 0.0;
            for (thread = 0; thread < thread_count; thread++) {
               forces[part][X] += loc_forces[thread*n + part][X];
               forces[part][Y] += loc_forces[thread*n + part][Y];
            }
         }
#        pragma omp for
         for (part = 0; part < n; part++)
            Update_part(part, forces, curr, n, delta_t);
#        ifndef NO_OUTPUT
         if (step % output_freq == 0) {
#           pragma omp single
            Output_state(t, curr, n);
         }
#        endif
      }  /* for step */
   }  /* pragma omp parallel */
   finish = omp_get_wtime();
   printf("Elapsed time = %e seconds\n", finish-start);

   free(curr);
   free(forces);
   free(loc_forces);
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
 * Out args:
 *    thread_count_p:  pointer to thread_count
 *    n_p:             pointer to n, the number of particles
 *    n_steps_p:       pointer to n_steps, the number of timesteps
 *    delta_t_p:       pointer to delta_t, the size of each timestep
 *    output_freq_p:   pointer to output_freq, which is the number of
 *                     timesteps between steps whose output is printed
 *    g_i_p:           pointer to char which is 'g' if the init conds
 *                     should be generated by the program and 'i' if
 *                     they should be read from stdin
 */
void Get_args(int argc, char* argv[], int* thread_count_p, int* n_p, 
      int* n_steps_p, double* delta_t_p, int* output_freq_p, 
      char* g_i_p) {
   if (argc != 7) Usage(argv[0]);
   *thread_count_p = strtol(argv[1], NULL, 10);
   *n_p = strtol(argv[2], NULL, 10);
   *n_steps_p = strtol(argv[3], NULL, 10);
   *delta_t_p = strtod(argv[4], NULL);
   *output_freq_p = strtol(argv[5], NULL, 10);
   *g_i_p = argv[6][0];

   if (*thread_count_p <= 0 || *n_p <= 0 || *n_steps_p < 0 ||
       *delta_t_p <= 0) Usage(argv[0]);
   if (*g_i_p != 'g' && *g_i_p != 'i') Usage(argv[0]);

#  ifdef DEBUG
   printf("thread_count = %d\n", *thread_count_p);
   printf("n = %d\n", *n_p);
   printf("n_steps = %d\n", *n_steps_p);
   printf("delta_t = %e\n", *delta_t_p);
   printf("output_freq = %d\n", *output_freq_p);
   printf("g_i = %c\n", *g_i_p);
#  endif
}  /* Get_args */

/*---------------------------------------------------------------------
 * Function:  Get_init_cond
 * Purpose:   Read in initial conditions:  mass, position and velocity
 *            for each particle
 * In args:  
 *    n:      number of particles
 * Out args:
 *    curr:   array of n structs, each struct stores the mass (scalar),
 *            position (vector), and velocity (vector) of a particle
 */
void Get_init_cond(struct particle_s curr[], int n) {
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
 * In args:  
 *    n:      number of particles
 * Out args:
 *    curr:   array of n structs, each struct stores the mass (scalar),
 *            position (vector), and velocity (vector) of a particle
 *
 * Note:      The initial conditions place all particles at
 *            equal intervals on the nonnegative x-axis with 
 *            identical masses, and identical initial speeds
 *            parallel to the y-axis.  However, some of the
 *            velocities are in the positive y-direction and
 *            some are negative.
 */
void Gen_init_cond(struct particle_s curr[], int n) {
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
 * Function:  Output_state
 * Purpose:   Print the current state of the system
 * In args:
 *    curr:   array with n elements, curr[i] stores the state (mass,
 *            position and velocity) of the ith particle
 *    n:      number of particles
 */
void Output_state(double time, struct particle_s curr[], int n) {
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
 * Purpose:   Compute the total force on particle part.  Exploit
 *            the symmetry (force on particle i due to particle k) 
 *            = -(force on particle k due to particle i) to also
 *            calculate partial forces on other particles.
 * In args:   
 *    part:   the particle on which we're computing the total force
 *    curr:   current state of the system:  curr[i] stores the mass,
 *            position and velocity of the ith particle
 *    n:      number of particles
 * Out arg:
 *    forces: force[i] stores the total force on the ith particle
 *
 * Note: This function uses the force due to gravitation.  So 
 * the force on particle i due to particle k is given by
 *
 *    m_i m_k (s_k - s_i)/|s_k - s_i|^2
 *
 * Here, m_j is the mass of particle j and s_k is its position vector
 * (at time t). 
 */
void Compute_force(int part, vect_t forces[], struct particle_s curr[], 
      int n) {
   int k;
   double mg; 
   vect_t f_part_k;
   double len, len_3, fact;

#  ifdef DEBUG
   printf("Current total force on particle %d = (%.3e, %.3e)\n",
         part, forces[part][X], forces[part][Y]);
#  endif
   for (k = part+1; k < n; k++) {
      /* Compute force on part due to k */
      f_part_k[X] = curr[part].s[X] - curr[k].s[X];
      f_part_k[Y] = curr[part].s[Y] - curr[k].s[Y];
      len = sqrt(f_part_k[X]*f_part_k[X] + f_part_k[Y]*f_part_k[Y]);
      len_3 = len*len*len;
      mg = -G*curr[part].m*curr[k].m;
      fact = mg/len_3;
      f_part_k[X] *= fact;
      f_part_k[Y] *= fact;
#     ifdef DEBUG
      printf("Force on particle %d due to particle %d = (%.3e, %.3e)\n",
            part, k, f_part_k[X], f_part_k[Y]);
#     endif

      /* Add force into total forces */
      forces[part][X] += f_part_k[X];
      forces[part][Y] += f_part_k[Y];
      forces[k][X] -= f_part_k[X];
      forces[k][Y] -= f_part_k[Y];
   }
}  /* Compute_force */


/*---------------------------------------------------------------------
 * Function:  Update_part
 * Purpose:   Update the velocity and position for particle part
 * In args:
 *    part:    the particle we're updating
 *    forces:  forces[i] stores the total force on the ith particle
 *    n:       number of particles
 *
 * In/out arg:
 *    curr:    curr[i] stores the mass, position and velocity of the
 *             ith particle
 *
 * Note:  This version uses Euler's method to update both the velocity
 *    and the position.
 */
void Update_part(int part, vect_t forces[], struct particle_s curr[], 
      int n, double delta_t) {
   double fact = delta_t/curr[part].m;

#  ifdef DEBUG
   printf("Before update of %d:\n", part);
   printf("   Position  = (%.3e, %.3e)\n", curr[part].s[X], curr[part].s[Y]);
   printf("   Velocity  = (%.3e, %.3e)\n", curr[part].v[X], curr[part].v[Y]);
   printf("   Net force = (%.3e, %.3e)\n", forces[part][X], forces[part][Y]);
#  endif
   curr[part].s[X] += delta_t * curr[part].v[X];
   curr[part].s[Y] += delta_t * curr[part].v[Y];
   curr[part].v[X] += fact * forces[part][X];
   curr[part].v[Y] += fact * forces[part][Y];
#  ifdef DEBUG
   printf("Position of %d = (%.3e, %.3e), Velocity = (%.3e,%.3e)\n",
         part, curr[part].s[X], curr[part].s[Y],
               curr[part].v[X], curr[part].v[Y]);
#  endif
// curr[part].s[X] += delta_t * curr[part].v[X];
// curr[part].s[Y] += delta_t * curr[part].v[Y];
}  /* Update_part */
