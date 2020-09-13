/* File:     prog3.7_mpi_ping_pong.c
 *
 * Purpose:  Determine message-passing times using ping pong.
 *
 * Compile:  mpicc -g -Wall -O3 -o prog3.7_mpi_ping_pong ping_pong
 *                                 prog3.7_mpi_ping_pong ping_pong.c
 * Run:      mpiexec -n 2 ./prog3.7_mpi_ping_pong
 *
 * Input:    none
 * Output:   Average message times for a range of message sizes.
 *
 * Notes:
 * 1. Prints *average* time per message.  So ping pong times are
 *    divided by 2
 * 2. Includes ``warmup'' iters in case system does on the fly
 *    configuration.
 * 3. If CLOCK is defined, the program uses the C library clock
 *    function instead of MPI_Wtime() to take the times.
 * 4. On our system for messages >= 16K bytes the times 
 *    returned by clock() are very close to those returned by 
 *    MPI_Wtime().  For smaller messages the clock function doesn't
 *    have sufficient resolution to return reliable times.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h> /* for memcpy */
#include <time.h>
#include "mpi.h"

/* Use these parameters for generating times
 */
#ifndef DEBUG
#define WARMUP_ITERS 10
#define RES_TEST_ITERS 10
#define PING_PONG_ITERS 1000
#define MIN_MESG_SIZE 0
#define MAX_MESG_SIZE 131072
#define INCREMENT 1024
#define TEST_COUNT 1
#endif

/* Use these parameters to be sure the program is correct
 */
#ifdef DEBUG
#define WARMUP_ITERS 1
#define RES_TEST_ITERS 1
#define PING_PONG_ITERS 1
#define MIN_MESG_SIZE 2
#define MAX_MESG_SIZE 4
#define INCREMENT 2
#define TEST_COUNT 1
#endif

const double clocks_per_sec = (double) CLOCKS_PER_SEC;

void print_buffer(char mesg[], int mesg_size, int my_rank);
double ping_pong(char mesg[], int mesg_size, int iters, MPI_Comm comm, 
               int p, int my_rank);
int next_size(int current_size);

/*-------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   int test, mesg_size, i;
   double elapsed;
   double times[TEST_COUNT];
   char message[MAX_MESG_SIZE];
   char c = 'B';
   MPI_Comm  comm;
   int p;
   int my_rank;

   MPI_Init(&argc, &argv);
   comm = MPI_COMM_WORLD;
   MPI_Comm_size(comm, &p);
   MPI_Comm_rank(comm, &my_rank);
   if (p != 2) {
      if (my_rank == 0)
         fprintf(stderr, "Use two processes\n");
      MPI_Finalize();
      return 0;
   }

   if (my_rank == 0)
      c = 'A';
   for (i = 0; i < MAX_MESG_SIZE; i++)
      message[i] = c;

   /* Warmup */
   elapsed = ping_pong(message, MAX_MESG_SIZE, WARMUP_ITERS, comm, 
                       p, my_rank);

   /* Resolution */
   elapsed = ping_pong(message, 0, RES_TEST_ITERS, comm, p, my_rank);
   if (my_rank == 0)
#     ifndef CLOCK
      fprintf(stderr, "Min ping_pong = %8.5e, Clock tick = %8.5e\n",
              elapsed/(2*RES_TEST_ITERS), MPI_Wtick());
#     else
      fprintf(stderr, "Min ping_pong = %8.5e, Clock tick = %8.5e\n",
              elapsed/(2*RES_TEST_ITERS), 1.0/clocks_per_sec);
#     endif

   for (mesg_size = MIN_MESG_SIZE; mesg_size <= MAX_MESG_SIZE; 
        mesg_size = next_size(mesg_size)) {
      for (test = 0; test < TEST_COUNT; test++) {
         times[test] = ping_pong(message, mesg_size, PING_PONG_ITERS, 
                                 comm, p, my_rank);
      }  /* for test */

      if (my_rank == 0) {
         for (test = 0; test < TEST_COUNT; test++)
            printf("%d %8.5e\n", mesg_size, 
                   times[test]/(2*PING_PONG_ITERS));
      }
   } /* for mesg_size */

   MPI_Finalize();
   return 0;
}  /* main */


/*-------------------------------------------------------------------*/
double ping_pong(char mesg[], int mesg_size, int iters, MPI_Comm comm, 
               int p, int my_rank) {
   int i;
   MPI_Status status;
   double start;

   if (my_rank == 0) {
#     ifndef CLOCK
      start = MPI_Wtime();
#     else
      start = clock()/clocks_per_sec;
#     endif
      for (i = 0; i < iters; i++) {
         MPI_Send(mesg, mesg_size, MPI_CHAR, 1, 0, comm);
         MPI_Recv(mesg, mesg_size, MPI_CHAR, 1, 0, comm, &status);
      }
#     ifndef CLOCK
      return MPI_Wtime() - start;
#     else
      return clock()/clocks_per_sec - start;
#     endif
   } else if (my_rank == 1) {
      for (i = 0; i < iters; i++) {
         MPI_Recv(mesg, mesg_size, MPI_CHAR, 0, 0, comm, &status);
#        ifdef DEBUG
         print_buffer(mesg, mesg_size, 1);
#        endif
         MPI_Send(mesg, mesg_size, MPI_CHAR, 0, 0, comm);
      }
   }
   return 0.0;
}  /* ping_pong */


/*-------------------------------------------------------------------*/
void print_buffer(char mesg[], int mesg_size, int my_rank) {
   char temp[MAX_MESG_SIZE + 1];

   memcpy(temp, mesg, mesg_size);
   temp[mesg_size] = '\0';
   printf("Process %d > %s\n", my_rank, temp);
   fflush(stdout);
}  /* print_buffer */


/*-------------------------------------------------------------------*/
int next_size(int current_size) {
/* return current_size + INCREMENT; */

   if (current_size == 0)
      return 1;
   else
      return 2*current_size;

}  /* next_size */
