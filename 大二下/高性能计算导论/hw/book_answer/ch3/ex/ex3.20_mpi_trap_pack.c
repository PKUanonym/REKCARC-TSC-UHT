/* File:     ex3.20_mpi_trap_pack.c
 * Purpose:  Use MPI to implement a parallel version of the trapezoidal 
 *           rule.  This version uses collective communications 
 *           to distribute the input data and compute the global
 *           sum.  It also uses MPI_Pack to store the input data in a 
 *           single buffer before broadcast, and MPI_Unpack to extract 
 *           the data from the broadcast buffer.
 *
 * Input:    The endpoints of the interval of integration and the number
 *           of trapezoids
 * Output:   Estimate of the integral from a to b of f(x)
 *           using the trapezoidal rule and n trapezoids.
 *
 * Compile:  mpicc -g -Wall -o mpi_trap4 mpi_trap4.c
 * Run:      mpiexec -n <number of processes> ./mpi_trap4
 *
 * Algorithm:
 *    1.  Each process calculates "its" interval of
 *        integration.
 *    2.  Each process estimates the integral of f(x)
 *        over its interval using the trapezoidal rule.
 *    3a. Each process != 0 sends its integral to 0.
 *    3b. Process 0 sums the calculations received from
 *        the individual processes and prints the result.
 *
 * Note:  f(x) is all hardwired.
 *
 * IPP:   Exercise 3.20
 */
#include <stdio.h>

/* We'll be using MPI routines, definitions, etc. */
#include <mpi.h>

/* Get the input values */
void Get_input(int my_rank, double* a_p, double* b_p, int* n_p);

/* Calculate local integral  */
double Trap(double left_endpt, double right_endpt, int trap_count, 
   double base_len);    

/* Function we're integrating */
double f(double x); 

const int PACK_BUF_SZ = 1000;

int main(void) {
   int my_rank, comm_sz, n, local_n;   
   double a, b, h, local_a, local_b;
   double local_int, total_int;

   /* Let the system do what it needs to start up MPI */
   MPI_Init(NULL, NULL);

   /* Get my process rank */
   MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

   /* Find out how many processes are being used */
   MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);

   Get_input(my_rank, &a, &b, &n);

   h = (b-a)/n;          /* h is the same for all processes */
   local_n = n/comm_sz;  /* So is the number of trapezoids  */

   /* Length of each process' interval of
    * integration = local_n*h.  So my interval
    * starts at: */
   local_a = a + my_rank*local_n*h;
   local_b = local_a + local_n*h;
   local_int = Trap(local_a, local_b, local_n, h);

   /* Add up the integrals calculated by each process */
   MPI_Reduce(&local_int, &total_int, 1, MPI_DOUBLE, MPI_SUM, 0,
         MPI_COMM_WORLD);

   /* Print the result */
   if (my_rank == 0) {
      printf("With n = %d trapezoids, our estimate\n", n);
      printf("of the integral from %f to %f = %.15e\n",
          a, b, total_int);
   }

   /* Shut down MPI */
   MPI_Finalize();

   return 0;
} /*  main  */

/*------------------------------------------------------------------
 * Function:     Get_input
 * Purpose:      Get the user input:  the left and right endpoints
 *               and the number of trapezoids
 * Input args:   my_rank:  process rank in MPI_COMM_WORLD
 *               comm_sz:  number of processes in MPI_COMM_WORLD
 * Output args:  a_p:  pointer to left endpoint               
 *               b_p:  pointer to right endpoint               
 *               n_p:  pointer to number of trapezoids
 */
void Get_input(
      int      my_rank  /* in  */, 
      double*  a_p      /* out */, 
      double*  b_p      /* out */,
      int*     n_p      /* out */) {

   char pack_buf[PACK_BUF_SZ];
   int position = 0;

   if (my_rank == 0) {
      printf("Enter a, b, and n\n");
      scanf("%lf %lf %d", a_p, b_p, n_p);
      MPI_Pack(a_p, 1, MPI_DOUBLE, pack_buf, PACK_BUF_SZ, &position, 
            MPI_COMM_WORLD);
      MPI_Pack(b_p, 1, MPI_DOUBLE, pack_buf, PACK_BUF_SZ, &position, 
            MPI_COMM_WORLD);
      MPI_Pack(n_p, 1, MPI_INT, pack_buf, PACK_BUF_SZ, &position, 
            MPI_COMM_WORLD);
   } 

   MPI_Bcast(pack_buf, PACK_BUF_SZ, MPI_PACKED, 0, MPI_COMM_WORLD);

   if (my_rank > 0) {
      MPI_Unpack(pack_buf, PACK_BUF_SZ, &position, a_p, 1, MPI_DOUBLE,
            MPI_COMM_WORLD);
      MPI_Unpack(pack_buf, PACK_BUF_SZ, &position, b_p, 1, MPI_DOUBLE,
            MPI_COMM_WORLD);
      MPI_Unpack(pack_buf, PACK_BUF_SZ, &position, n_p, 1, MPI_INT,
            MPI_COMM_WORLD);
   }

#  ifdef DEBUG
   printf("Proc %d > a = %.2f, b = %.2f, n = %d\n", my_rank, 
         *a_p, *b_p, *n_p);
#  endif
}  /* Get_input */

/*------------------------------------------------------------------
 * Function:     Trap
 * Purpose:      Serial function for estimating a definite integral 
 *               using the trapezoidal rule
 * Input args:   left_endpt
 *               right_endpt
 *               trap_count 
 *               base_len
 * Return val:   Trapezoidal rule estimate of integral from
 *               left_endpt to right_endpt using trap_count
 *               trapezoids
 */
double Trap(
      double left_endpt  /* in */, 
      double right_endpt /* in */, 
      int    trap_count  /* in */, 
      double base_len    /* in */) {
   double estimate, x; 
   int i;

   estimate = (f(left_endpt) + f(right_endpt))/2.0;
   for (i = 1; i <= trap_count-1; i++) {
      x = left_endpt + i*base_len;
      estimate += f(x);
   }
   estimate = estimate*base_len;

   return estimate;
} /*  Trap  */


/*------------------------------------------------------------------
 * Function:    f
 * Purpose:     Compute value of function to be integrated
 * Input args:  x
 */
double f(double x /* in */) {
   return x*x;
} /* f */
