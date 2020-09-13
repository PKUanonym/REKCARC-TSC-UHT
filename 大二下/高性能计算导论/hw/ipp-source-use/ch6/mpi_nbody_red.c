/* File:     mpi_nbody_red.c
 * Purpose:  Implement a 2-dimensional n-body solver that uses the 
 *           reduced algorithm.  In this version, we reduce storage 
 *           and communication over the original MPI version 
 *           and we slightly improve the organization of the loops 
 *           in Compute_proc_forces
 *
 * Compile:  mpicc -g -Wall -o mpi_nbody_red mpi_nbody_red.c -lm
 *           To turn off output (e.g., when timing), define NO_OUTPUT
 *           To get verbose output, define DEBUG
 *
 * Run:      mpiexec -n <number of processes> ./mpi_nbody_red
 *              <number of particles> <number of timesteps>  <size of timestep> 
 *              <output frequency> <g|i>
 *              'g': generate initial conditions using a random number
 *                   generator
 *              'i': read initial conditions from stdin
 *              number of particles should be evenly divisible by the number
 *                 of MPI processes
 *           A stepsize of 0.01 seems to work well with the automatically
 *           generated input.
 *
 * Input:    If 'g' is specified on the command line, none.  
 *           If 'i', mass, initial position and initial velocity of 
 *              each particle
 * Output:   If the output frequency is k, then position and velocity of 
 *              each particle at every kth timestep.  This value is
 *              ignored (but still necessary) if NO_OUTPUT is defined
 *
 *    for each timestep t {
 *       for each particle i I own
 *          compute F(i), the total force on i
 *       for each particle i I own
 *          update position and velocity of i using F(i) = ma
 *       Allgather positions
 *       if (output step) {
 *          Allgather velocities
 *          Output new positions and velocities
 *       }
 *    }
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
 * of force computations.  This version of the program attempts to
 * exploit this.
 *
 * Integration:  We use Euler's method:
 *
 *    v_i(t+1) = v_i(t) + h v'_i(t)
 *    s_i(t+1) = s_i(t) + h v_i(t)
 *
 * Here, v_i(u) is the velocity of the ith particle at time u and
 * s_i(u) is its position.
 *
 * Notes:
 * 1.  Each process stores the masses of all the particles:  the
 *     masses array had dimension n = number of particles.  This
 *     can be easily modified so that each process stores only
 *     n/p. 
 * 2.  This version uses a cyclic distribution of the particles.
 *
 * IPP:  Section 6.1.10 (pp. 292 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mpi.h>

#define DIM 2  /* Two-dimensional system */
#define X 0    /* x-coordinate subscript */
#define Y 1    /* y-coordinate subscript */

typedef double vect_t[DIM];  /* Vector type for position, etc. */

/* Global variables.  Except for vel all are unchanged after being set */
const double G = 6.673e-11;  /* Gravitational constant. */
                             /* Units are m^3/(kg*s^2)  */
int my_rank, comm_sz;
MPI_Comm comm;
MPI_Datatype vect_mpi_t;
MPI_Datatype cyclic_mpi_t;

/* Scratch arrays used by process 0 for I/O */
vect_t *vel = NULL;
vect_t *pos = NULL;

void Usage(char* prog_name);
void Get_args(int argc, char* argv[], int* n_p, int* n_steps_p, 
      double* delta_t_p, int* output_freq_p, char* g_i_p);
void Build_cyclic_mpi_type(int loc_n);
void Get_init_cond(double masses[], vect_t loc_pos[], 
      vect_t loc_vel[], int n, int loc_n);
void Gen_init_cond(double masses[], vect_t loc_pos[], 
      vect_t loc_vel[], int n, int loc_n);
void Output_state(double time, double masses[], vect_t loc_pos[],
      vect_t loc_vel[], int n, int loc_n);
void Compute_forces(double masses[], vect_t tmp_data[], 
      vect_t loc_forces[], vect_t loc_pos[], int n, int loc_n);
void Compute_proc_forces(double masses[], vect_t tmp_data[], 
      vect_t loc_forces[], vect_t pos1[], int loc_n1, int rk1, 
      int loc_n2, int rk2, int n, int p);
int Local_to_global(int loc_part, int proc_rk, int proc_count);
int Global_to_local(int gbl_part, int proc_rk, int proc_count);
int First_index(int gbl1, int proc_rk1, int proc_rk2, int proc_count);
void Compute_force_pair(double m1, double m2, vect_t pos1, vect_t pos2,
      vect_t force1, vect_t force2);
void Update_part(int loc_part, double masses[], vect_t loc_forces[], 
      vect_t loc_pos[], vect_t loc_vel[], int n, int loc_n, double delta_t);

/*--------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int n;                      /* Total number of particles     */
   int loc_n;                  /* Number of my particles        */
   int n_steps;                /* Number of timesteps           */
   int step;                   /* Current step                  */
   int output_freq;            /* Frequency of output           */
   double delta_t;             /* Size of timestep              */
   double t;                   /* Current Time                  */
   double* masses;             /* All the masses                */
   vect_t* loc_pos;            /* Positions of my particles     */
   vect_t* tmp_data;           /* Received positions and forces */
   vect_t* loc_vel;            /* Velocities of my particles    */
   vect_t* loc_forces;         /* Forces on my particles        */
   int loc_part;

   char g_i;                   /*_G_en or _i_nput init conds */
   double start, finish;       /* For timings                */

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);

   Get_args(argc, argv, &n, &n_steps, &delta_t, &output_freq, &g_i);
   loc_n = n/comm_sz;  /* n should be evenly divisible by comm_sz */
   masses = malloc(n*sizeof(double));
   tmp_data = malloc(2*loc_n*sizeof(vect_t));
   loc_forces = malloc(loc_n*sizeof(vect_t));
   loc_pos = malloc(loc_n*sizeof(vect_t));
   loc_vel = malloc(loc_n*sizeof(vect_t));
   if (my_rank == 0) {
      pos = malloc(n*sizeof(vect_t));
      vel = malloc(n*sizeof(vect_t));
   }
   MPI_Type_contiguous(DIM, MPI_DOUBLE, &vect_mpi_t);
   MPI_Type_commit(&vect_mpi_t);
   Build_cyclic_mpi_type(loc_n);

   if (g_i == 'i')
      Get_init_cond(masses, loc_pos, loc_vel, n, loc_n);
   else
      Gen_init_cond(masses, loc_pos, loc_vel, n, loc_n);

   start = MPI_Wtime();
#  ifndef NO_OUTPUT
   Output_state(0.0, masses, loc_pos, loc_vel, n, loc_n);
#  endif
   for (step = 1; step <= n_steps; step++) {
      t = step*delta_t;
      Compute_forces(masses, tmp_data, loc_forces, loc_pos, 
            n, loc_n);
      for (loc_part = 0; loc_part < loc_n; loc_part++)
         Update_part(loc_part, masses, loc_forces, loc_pos, loc_vel, 
               n, loc_n, delta_t);
#     ifndef NO_OUTPUT
      if (step % output_freq == 0)
         Output_state(t, masses, loc_pos, loc_vel, n, loc_n);
#     endif
   }
   
   finish = MPI_Wtime();
   if (my_rank == 0)
      printf("Elapsed time = %e seconds\n", finish-start);

   MPI_Type_free(&vect_mpi_t);
   MPI_Type_free(&cyclic_mpi_t);
   free(masses);
   free(tmp_data);
   free(loc_forces);
   free(loc_pos);
   free(loc_vel);
   if (my_rank == 0) {
      free(pos);
      free(vel);
   }

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
   
   fprintf(stderr, "usage: mpiexec -n <number of processes> %s\n", prog_name);
   fprintf(stderr, "   <number of particles> <number of timesteps>\n");
   fprintf(stderr, "   <size of timestep> <output frequency>\n");
   fprintf(stderr, "   <g|i>\n");
   fprintf(stderr, "   'g': program should generate init conds\n");
   fprintf(stderr, "   'i': program should get init conds from stdin\n");
    
}  /* Usage */


/*---------------------------------------------------------------------
 * Function:  Get_args
 * Purpose:   Get command line args
 * In args:
 *    argc:            number of command line args
 *    argv:            command line args
 * Out args:
 *    n_p:             pointer to n, the number of particles
 *    n_steps_p:       pointer to n_steps, the number of timesteps
 *    delta_t_p:       pointer to delta_t, the size of each timestep
 *    output_freq_p:   pointer to output_freq, which is the number of
 *                     timesteps between steps whose output is printed
 *    g_i_p:           pointer to char which is 'g' if the init conds
 *                     should be generated by the program and 'i' if
 *                     they should be read from stdin
 */
void Get_args(int argc, char* argv[], int* n_p, int* n_steps_p, 
      double* delta_t_p, int* output_freq_p, char* g_i_p) {
   if (my_rank == 0) {
      if (argc != 6) {
         Usage(argv[0]);
         *n_p = *n_steps_p = *output_freq_p = 0;
         *delta_t_p = 0.0;
         *g_i_p = 'g';
      } else {
         *n_p = strtol(argv[1], NULL, 10);
         *n_steps_p = strtol(argv[2], NULL, 10);
         *delta_t_p = strtod(argv[3], NULL);
         *output_freq_p = strtol(argv[4], NULL, 10);
         *g_i_p = argv[5][0];
      }
   }
   MPI_Bcast(n_p, 1, MPI_INT, 0, comm);
   MPI_Bcast(n_steps_p, 1, MPI_INT, 0, comm);
   MPI_Bcast(delta_t_p, 1, MPI_DOUBLE, 0, comm);
   MPI_Bcast(output_freq_p, 1, MPI_INT, 0, comm);
   MPI_Bcast(g_i_p, 1, MPI_CHAR, 0, comm);

   if (*n_p <= 0 || *n_steps_p < 0 || *delta_t_p <= 0) {
      if (my_rank == 0 && argc > 6) Usage(argv[0]);
      MPI_Finalize();
      exit(0);
   }
   if (*g_i_p != 'g' && *g_i_p != 'i') {
      if (my_rank == 0) Usage(argv[0]);
      MPI_Finalize();
      exit(0);
   }
#  ifdef DEBUG
   if (my_rank == 0) {
      printf("n = %d\n", *n_p);
      printf("n_steps = %d\n", *n_steps_p);
      printf("delta_t = %e\n", *delta_t_p);
      printf("output_freq = %d\n", *output_freq_p);
      printf("g_i = %c\n", *g_i_p);
   }
#  endif
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

   MPI_Type_vector(loc_n, 1, comm_sz, vect_mpi_t, &temp_mpi_t);
   MPI_Type_get_extent(vect_mpi_t, &lb, &extent);
   MPI_Type_create_resized(temp_mpi_t, lb, extent, &cyclic_mpi_t);
   MPI_Type_commit(&cyclic_mpi_t);

}  /* Build_cyclic_mpi_type */


/*---------------------------------------------------------------------
 * Function:   Get_init_cond
 * Purpose:    Read in initial conditions:  mass, position and velocity
 *             for each particle
 * In args:  
 *    n:       total number of particles
 *    loc_n:   number of particles assigned to this process
 * Out args:
 *    masses:  global array of the masses of the particles
 *    loc_pos: local array of the positions of the particles assigned
 *             to this process
 *    loc_vel: local array of velocities assigned to this process.
 *
 * Global var:
 *    pos:     Scratch.  Used by process 0 for global positions
 *    vel:     Scratch.  Used by process 0 for global velocities
 */
void Get_init_cond(double masses[], vect_t loc_pos[],
     vect_t loc_vel[], int n, int loc_n) {
   int part;

   if (my_rank == 0) {
      printf("For each particle, enter (in order):\n");
      printf("   its mass, its x-coord, its y-coord, ");
      printf("its x-velocity, its y-velocity\n");
      for (part = 0; part < n; part++) {
         scanf("%lf", &masses[part]);
         scanf("%lf", &pos[part][X]);
         scanf("%lf", &pos[part][Y]);
         scanf("%lf", &vel[part][X]);
         scanf("%lf", &vel[part][Y]);
      }
   }
   MPI_Bcast(masses, n, MPI_DOUBLE, 0, comm);
   MPI_Scatter(pos, 1, cyclic_mpi_t, 
         loc_pos, loc_n, vect_mpi_t, 0, comm);
   MPI_Scatter(vel, 1, cyclic_mpi_t, 
         loc_vel, loc_n, vect_mpi_t, 0, comm);
}  /* Get_init_cond */


/*---------------------------------------------------------------------
 * Function:  Gen_init_cond
 * Purpose:   Generate initial conditions:  mass, position and velocity
 *            for each particle
 * In args:  
 *    n:       total number of particles
 *    loc_n:   number of particles assigned to this process
 * Out args:
 *    masses:  global array of the masses of the particles
 *    pos:     global array of positions
 *    loc_pos: local array of the positions of the particles assigned
 *             to this process
 *    loc_vel: local array of velocities assigned to this process.
 * Global vars:
 *    pos:     Scratch.  Used by process 0 for global positions
 *    vel:     Scratch.  Used by process 0 for global velocities
 *
 * Note:      The initial conditions place all particles at
 *            equal intervals on the nonnegative x-axis with 
 *            identical masses, and identical initial speeds
 *            parallel to the y-axis.  However, some of the
 *            velocities are in the positive y-direction and
 *            some are negative.
 */
void Gen_init_cond(double masses[], vect_t loc_pos[], 
      vect_t loc_vel[], int n, int loc_n) {
   int part;
   double mass = 5.0e24;
   double gap = 1.0e5;
   double speed = 3.0e4;

   if (my_rank == 0) {
//    srandom(1);
      for (part = 0; part < n; part++) {
         masses[part] = mass;
         pos[part][X] = part*gap;
         pos[part][Y] = 0.0;
         vel[part][X] = 0.0;
//       if (random()/((double) RAND_MAX) >= 0.5)
         if (part % 2 == 0)
            vel[part][Y] = speed;
         else
            vel[part][Y] = -speed;
      }
   }

   MPI_Bcast(masses, n, MPI_DOUBLE, 0, comm);
   MPI_Scatter(pos, 1, cyclic_mpi_t, 
         loc_pos, loc_n, vect_mpi_t, 0, comm);
   MPI_Scatter(vel, 1, cyclic_mpi_t, 
         loc_vel, loc_n, vect_mpi_t, 0, comm);
}  /* Gen_init_cond */


/*---------------------------------------------------------------------
 * Function:   Output_state
 * Purpose:    Print the current state of the system
 * In args:
 *    time:    current time
 *    masses:  global array of particle masses
 *    loc_pos: local array of particle positions
 *    loc_vel: local array of my particle velocities
 *    n:       total number of particles
 *    loc_n:   number of my particles
 * Global vars:
 *    pos:     Scratch.  Used by proc 0 for global positions
 *    vel:     Scratch.  Used by proc 0 for global velocities
 */
void Output_state(double time, double masses[], vect_t loc_pos[],
      vect_t loc_vel[], int n, int loc_n) {
   int part;

   MPI_Gather(loc_pos, loc_n, vect_mpi_t, pos, 1, cyclic_mpi_t, 
         0, comm);
   MPI_Gather(loc_vel, loc_n, vect_mpi_t, vel, 1, cyclic_mpi_t, 
         0, comm);
   if (my_rank == 0) {
      printf("%.2f\n", time);
      for (part = 0; part < n; part++) {
//       printf("%.3f ", masses[part]);
         printf("%3d %10.3e ", part, pos[part][X]);
         printf("  %10.3e ", pos[part][Y]);
         printf("  %10.3e ", vel[part][X]);
         printf("  %10.3e\n", vel[part][Y]);
      }
      printf("\n");
   }
}  /* Output_state */


/*---------------------------------------------------------------------
 * Function:       Compute_forces
 * Purpose:        Compute the total force on each local particle.
 *                 Exploit the symmetry (force on particle i due to 
 *                 particle k) = -(force on particle k due to particle i) 
 * In args:   
 *    masses:      global array of particle masses (dimension n)
 *    loc_pos:     local array of positions of my particles (dim loc_n)
 *    n:           total number of particles
 *    loc_n:       number of my particles
 * Scratch:
 *    tmp_data:    Stores received positions (subscripts 0 - loc_n-1)
 *                 and forces computed thus far on particles corresp
 *                 onding to received positions (subscripts 
 *                 loc_n - 2*loc_n-1).  (dimension 2*loc_n)
 * Out arg:
 *    loc_forces:  array of total forces acting on my particles
 */
void Compute_forces(double masses[], vect_t tmp_data[], 
      vect_t loc_forces[], vect_t loc_pos[], int n, int loc_n) {
   int src, dest;  /* Source and dest processes for particle pos */
   int i, other_proc, loc_part;
   MPI_Status status;

   src = (my_rank + 1) % comm_sz;
   dest = (my_rank - 1 + comm_sz) % comm_sz;
   memcpy(tmp_data, loc_pos, loc_n*sizeof(vect_t));
   memset(tmp_data + loc_n, 0, loc_n*sizeof(vect_t));
   memset(loc_forces, 0, loc_n*sizeof(vect_t));

   /* First compute the forces resulting from my particles' interactions 
    * with themselves */
   Compute_proc_forces(masses, tmp_data, loc_forces, loc_pos, loc_n, 
         my_rank, loc_n, my_rank, n, comm_sz);
   /* Now compute forces resulting from my particles' interactions with
    * other processes' particles */
   for (i = 1; i < comm_sz; i++) {
      other_proc = (my_rank + i) % comm_sz;
      MPI_Sendrecv_replace(tmp_data, 2*loc_n, vect_mpi_t, dest, 0, src, 0,
            comm, &status);
      Compute_proc_forces(masses, tmp_data, loc_forces, loc_pos, loc_n, 
            my_rank, loc_n, other_proc, n, comm_sz);
   }
   MPI_Sendrecv_replace(tmp_data, 2*loc_n, vect_mpi_t, dest, 0, src, 0,
         comm, &status);
   for (loc_part = 0; loc_part < loc_n; loc_part++) {
      loc_forces[loc_part][X] += tmp_data[loc_n+loc_part][X];
      loc_forces[loc_part][Y] += tmp_data[loc_n+loc_part][Y];
   }

}  /* Compute_forces */


/*---------------------------------------------------------------------
 * Function:       Compute_proc_forces
 * Purpose:        Compute the forces on particles owned by process
 *                 rk1 due to interaction with particles owned by
 *                 procss rk2.  Exploit the symmetry (force on particle 
 *                 i due to particle k) = -(force on particle k due 
 *                 to particle i) 
 * In args:   
 *    masses:      global array of particle masses (dim n)
 *    pos1:        local array of particle positions (dim loc_n1)
 *    loc_n1:      number of my particles in pos1
 *    rk1:         process owning particles in pos1
 *    loc_n2:      number of particles contributed by second process
 *    rk2:         process owning contributed particles 
 *    n:           total number of particles
 *    p:           number of processes in communicator containing
 *                 processes rk1 and rk2
 * In/out args:
 *    tmp_data:    positions of rk2 particles (in only, loc_n2 positions)
 *                 followed by forces computed thus far corresp to
 *                    rk2 particles (in and out, loc_n2 positions)
 *    loc_forces:  forces computed thus far on my particles (loc_n1)
 */
void Compute_proc_forces(double masses[], vect_t tmp_data[], 
      vect_t loc_forces[], vect_t pos1[], int loc_n1, int rk1, 
      int loc_n2, int rk2, int n, int p) {
   int loc_part1, loc_part2;
   int gbl_part1, gbl_part2;

   for (gbl_part1 = rk1, loc_part1 = 0;
        loc_part1 < loc_n1; 
        loc_part1++, gbl_part1 += p) {
      for(gbl_part2 = First_index(gbl_part1, rk1, rk2, p),
          loc_part2 = Global_to_local(gbl_part2, rk2, p); 
          loc_part2 < loc_n2; 
          loc_part2++, gbl_part2 += p) {
#        ifdef DEBUG
         printf("Proc %d > Current total force on part %d = (%.3e, %.3e)\n",
               my_rank, gbl_part1, loc_forces[loc_part1][X], 
               loc_forces[loc_part1][Y]);
         printf("Proc %d > Current total force on part %d = (%.3e, %.3e)\n",
               my_rank, gbl_part2, 
               tmp_data[loc_n2+loc_part2][X], 
               tmp_data[loc_n2+loc_part2][Y]);
#        endif
         Compute_force_pair(masses[gbl_part1], masses[gbl_part2], 
               pos1[loc_part1], tmp_data[loc_part2],
               loc_forces[loc_part1], tmp_data[loc_n2+loc_part2]);
#        ifdef DEBUG
         printf("Proc %d > Current total force on part %d = (%.3e, %.3e)\n",
               my_rank, gbl_part1, loc_forces[loc_part1][X], 
               loc_forces[loc_part1][Y]);
         printf("Proc %d > Current total force on part %d = (%.3e, %.3e)\n",
               my_rank, gbl_part2, 
               tmp_data[loc_n2+loc_part2][X], 
               tmp_data[loc_n2+loc_part2][Y]);
#        endif
      } /* for gbl_part2 */
   } /* for gbl_part1 */
}  /* Compute_proc_forces */

/*---------------------------------------------------------------------
 * Function:    Local_to_global
 * Purpose:     Convert a local particle index to a global particle
 *              index
 * In args: 
 *    loc_part:  local particle index
 *    proc_rk:   process rank
 *    loc_n:     number of particles assigned to the process
 *    n:         total number of particles
 *    proc_count:  number of processes in the communicator
 * Ret val:
 *    global particle index
 *
 * Notes:
 * 1.  This version assumes a cyclic distribution of the particles
 * 2.  It also assumes loc_n = n/proc_count, and n is evenly divisible
 *     by proc_count
 */
int Local_to_global(int loc_part, int proc_rk, int proc_count) {
   return loc_part*proc_count + proc_rk;
}  /*  Local_to_global */

/*---------------------------------------------------------------------
 * Function:    Global_to_local
 * Purpose:     Convert a global particle index to a global permuted
 *              index
 * In args:
 *    gbl_part:    The global particle index
 *    proc_rk:     The rank of the owning process
 *    proc_count:  The number of processes
 *    
 * Notes:
 * 1.  This version assumes a cyclic distribution of the particles
 * 2.  It also assumes loc_n = n/proc_count, and n is evenly divisible
 *     by proc_count
 */
int Global_to_local(int gbl_part, int proc_rk, int proc_count) {
   return (gbl_part - proc_rk)/proc_count;
}  /* Global_to_local */


/*---------------------------------------------------------------------
 * Function:           First_index
 * Purpose:            Given a global index glb1 assigned to process
 *                     rk1, find the next higher global index assigned
 *                     to process rk2
 * In args:
 *    gbl1:            global particle index of particle assigned to
 *                     process rk1
 *    rk1:             rank of process owning gbl1
 *    rk2:             rank of process owning particle with computed index
 *    proc_count:      number of processes
 * Return val:         next higher global particle index of particle assigned
 *                     to process rk2
 * Note:               If there is no particle assigned to rk2 with index
 *                     greater than rk1, the function will return a value
 *                     larger than n, the total number of particles.
 */
int First_index(int gbl1, int rk1, int rk2, int proc_count) {
   if (rk1 < rk2)
      return gbl1 + (rk2 - rk1);
   else 
      return gbl1 + (rk2 - rk1) + proc_count;
}  /* First_index */


/*---------------------------------------------------------------------
 * Function:           Compute_force_pair
 * Purpose:            Compute the force resulting from the interaction of
 *                     of two particles.  Exploit the fact that f_kq = -f_qk
 * In args:
 *    m1, m2:          Masses of the two particles
 *    pos1, pos2:      Positions of the two particles
 * In/out args:
 *    force1, force2:  The total forces on the two particles as thus far
 *                     computed 
 */
void Compute_force_pair(double m1, double m2, vect_t pos1, vect_t pos2,
      vect_t force1, vect_t force2) {
   double mg; 
   vect_t f_part_k;
   double len, len_3, fact;

   f_part_k[X] = pos1[X] - pos2[X];
   f_part_k[Y] = pos1[Y] - pos2[Y];
   len = sqrt(f_part_k[X]*f_part_k[X] + f_part_k[Y]*f_part_k[Y]);
   len_3 = len*len*len;
   mg = -G*m1*m2;
   fact = mg/len_3;
   f_part_k[X] *= fact;
   f_part_k[Y] *= fact;
   
   /* Add force in to total forces */
   force1[X] += f_part_k[X];
   force1[Y] += f_part_k[Y];
   force2[X] -= f_part_k[X];
   force2[Y] -= f_part_k[Y];
}  /* Compute_force_pair */

/*---------------------------------------------------------------------
 * Function:  Update_part
 * Purpose:   Update the velocity and position for particle loc_part
 * In args:
 *    loc_part:    local index of the particle we're updating
 *    masses:      global array of particle masses
 *    loc_forces:  local array of total forces
 *    n:           total number of particles
 *    loc_n:       number of particles assigned to this process
 *    delta_t:     step size
 *
 * In/out args:
 *    loc_pos:     local array of positions
 *    loc_vel:     local array of velocities
 *
 * Note:  This version uses Euler's method to update both the velocity
 *    and the position.
 */
void Update_part(int loc_part, double masses[], vect_t loc_forces[], 
      vect_t loc_pos[], vect_t loc_vel[], int n, int loc_n, 
      double delta_t) {
   int part;
   double fact;

   part = my_rank*loc_n + loc_part;
   fact = delta_t/masses[part];
#  ifdef DEBUG
   printf("Proc %d > Before update of %d:\n", my_rank, part);
   printf("   Position  = (%.3e, %.3e)\n", 
         loc_pos[loc_part][X], loc_pos[loc_part][Y]);
   printf("   Velocity  = (%.3e, %.3e)\n", 
         loc_vel[loc_part][X], loc_vel[loc_part][Y]);
   printf("   Net force = (%.3e, %.3e)\n", 
         loc_forces[loc_part][X], loc_forces[loc_part][Y]);
#  endif
   loc_pos[loc_part][X] += delta_t * loc_vel[loc_part][X];
   loc_pos[loc_part][Y] += delta_t * loc_vel[loc_part][Y];
   loc_vel[loc_part][X] += fact * loc_forces[loc_part][X];
   loc_vel[loc_part][Y] += fact * loc_forces[loc_part][Y];
#  ifdef DEBUG
   printf("Proc %d > Position of %d = (%.3e, %.3e), Velocity = (%.3e,%.3e)\n",
         my_rank, part, loc_pos[loc_part][X], loc_pos[loc_part][Y],
               loc_vel[loc_part][X], loc_vel[loc_part][Y]);
#  endif
}  /* Update_part */
