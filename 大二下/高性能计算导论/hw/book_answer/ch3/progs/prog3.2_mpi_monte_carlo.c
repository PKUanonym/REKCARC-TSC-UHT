/*
 * File:     prog3.2_mpi_monte_carlo.c
 *
 * Purpose:  Estimate pi using a monte carlo method
 *  
 * Compile:  mpicc -g -Wall -o prog3.2_mpi_monte_carlo 
 *                 prog3.2_mpi_monte_carlo.c
 * Run:      mpiexec -n <comm_sz> ./prog3.2_mpi_monte_carlo
 *
 * Input:    Number of "dart tosses"
 * Output:   Estimate of pi.  If DEBUG flag is set, results of processes'
 *           tosses.
 *
 * Author:   Jinyoung Choi
 *
 * IPP:      Programming Assignment 3.2
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void Get_input(long long int* number_of_tosses, int my_rank, 
      MPI_Comm comm);
long long int Monte_carlo(long long number_of_tosses, 
      int my_rank);

/*-------------------------------------------------------------------*/
int main(void) {
   long long int number_of_tosses;
   long long int local_number_of_tosses;
   long long int number_in_circle;
   long long int local_number_in_circle;
   
   double pi_estimate;
   int my_rank, comm_sz;
   MPI_Comm comm;
   
   MPI_Init(NULL, NULL);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &comm_sz);
   MPI_Comm_rank(comm, &my_rank);
   
   Get_input(&number_of_tosses, my_rank, comm);
   local_number_of_tosses = number_of_tosses/comm_sz;

#  ifdef DEBUG
   printf("Proc %d > number of tosses = %lld, local number = %lld\n",
         my_rank, number_of_tosses, local_number_of_tosses);
#  endif

   local_number_in_circle = Monte_carlo(local_number_of_tosses, my_rank);
   
   MPI_Reduce(&local_number_in_circle, &number_in_circle, 1, 
         MPI_LONG_LONG, MPI_SUM, 0, comm);
   
   if ( my_rank == 0 ){
      pi_estimate = 4*number_in_circle/((double)number_of_tosses);
      printf("pi estimate = %f\n", pi_estimate);
   }
   
   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
void Get_input(
      long long int* number_of_tosses  /* out */,
      int my_rank                      /* in  */, 
      MPI_Comm comm                    /* in  */) {
      
   if (my_rank == 0 ) {
      printf("Enter the total number of tosses\n");
      scanf("%lld", number_of_tosses);
   }
   
   MPI_Bcast(number_of_tosses, 1, MPI_LONG_LONG, 0, comm);
}  /* Get_input */


/*-------------------------------------------------------------------*/
long long int Monte_carlo(long long local_number_of_tosses, int my_rank) {
   long long int i;
   double x,y;
   double distance_squared;
   long long int number_in_circle = 0;
      
   srandom(my_rank+1);
   for ( i=0 ; i< local_number_of_tosses ; i++) {
      x =  2*random()/((double)RAND_MAX) - 1.0;
      y =  2*random()/((double)RAND_MAX) - 1.0;
      
      distance_squared = x*x + y*y;
#     ifdef DEBUG
      printf("Proc %d > x = %f, y = %f, dist squared = %f\n",
            my_rank, x, y, distance_squared);
#     endif
      if (distance_squared <= 1) {
         number_in_circle++;
      }
   }
   
   return number_in_circle;
}  /* Monte_carlo */

