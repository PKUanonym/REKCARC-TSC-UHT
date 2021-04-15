/* File:     
 *     ex4.2_pth_mat_vect.c
 *
 * Purpose:  
 *     Computes a parallel matrix-vector product. The matrix
 *     is physically distributed by block rows.  The vector x is
 *     logically distributed by blocks.  The vector y is 
 *     physically distributed by blocks. This is a modified
 *     version of pth_mat_vec.c.
 *
 * Input:
 *     m, n: order of matrix
 *     x, A: the vector and the matrix to be multiplied
 *
 * Output:
 *     y: the product vector
 *
 * Compile:  
 *     gcc -g -Wall -o ex4.2_pth_mat_vect ex4.2_pth_mat_vect.c -lpthread
 * Usage:
 *     pth_mat_vect <thread_count>
 *
 * Notes:  
 *     1.  Storage for A, x, y is dynamically allocated.
 *     2.  Number of threads (thread_count) should evenly divide both 
 *         m and n.  The program doesn't check for this.
 *     3.  We use a 1-dimensional array for A and compute subscripts
 *         using the formula A[i][j] = A[i*n + j]
 *     4.  The vector x is globally shared.  A and y are distributed
 *         among the the threads.
 *
 * IPP:    Exercise 4.2 (p. 200)
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include "timer.h"

/* Global variables */
int     thread_count;
int     m, n;
double* x;

/* Semaphores */
sem_t* sem_a;
sem_t* sem_y;

/* Mutexs */
pthread_mutex_t bar_mutex, max_mutex;
pthread_cond_t bar_cond;
int bar_count = 0;
double elapsed = 0;

/* Serial functions */
void Usage(char* prog_name);
void Read_matrix(char* prompt, double A[], int m, int n);
void Read_vector(char* prompt, double x[], int n);
void Print_matrix(char* title, double A[], int m, int n);
void Print_vector(char* title, double y[], double m);
void Semaphores_wait(sem_t* sem, long rank);
void Semaphores_post(sem_t* sem, long rank);
void My_barrier(void);

/* Parallel function */
void *Pth_mat_vect(void* rank);

/*------------------------------------------------------------------*/
int main(int argc, char* argv[]) {
    long       thread;
    pthread_t* thread_handles;
    int tmp1, tmp2;
    
    if (argc != 2) Usage(argv[0]);
    thread_count = strtol(argv[1], NULL, 10);
    /* Allocate arrays of semaphores to schedule input */
    sem_a = malloc(thread_count*sizeof(sem_t));
    sem_y = malloc(thread_count*sizeof(sem_t));
    
    /* Initialize semaphores */
    for(thread = 0; thread < thread_count; thread++) {
        if(thread == 0) {
            tmp1 = sem_init(&sem_a[thread], 0, 1);
            tmp2 = sem_init(&sem_y[thread], 0, 0);
        }
        else {
            tmp1 = sem_init(&sem_a[thread], 0, 0);
            tmp2 = sem_init(&sem_y[thread], 0, 0);
        }
        if(tmp1 == -1 || tmp2 == -1) {
            fprintf(stderr, "sem_init failed for thread %ld\n", thread);
            free(sem_a);
            free(sem_y);
            exit(-1);
        }
    }

    /* Allocate array for threads handles*/
    thread_handles = malloc(thread_count*sizeof(pthread_t));
    
    /* Initialize the mutexes */
    pthread_mutex_init(&bar_mutex, NULL);
    pthread_mutex_init(&max_mutex, NULL);
    pthread_cond_init(&bar_cond, NULL);
    
    printf("Enter m and n\n");
    scanf("%d%d", &m, &n);

    x = malloc(n*sizeof(double));

    Read_vector("Enter the vector x", x, n);
    
    printf("Enter the matrix\n");
    
    /* Start threads */
    for (thread = 0; thread < thread_count; thread++)
        pthread_create(&thread_handles[thread], NULL,
            Pth_mat_vect, (void*) thread);
    /* Wait for threads to complete */
    for (thread = 0; thread < thread_count; thread++)
        pthread_join(thread_handles[thread], NULL);

    printf("Elapsed time = %e\n", elapsed);

    for(thread = 0; thread < thread_count; thread++) {
        sem_destroy(&sem_a[thread]);
        sem_destroy(&sem_y[thread]);
    }

    pthread_mutex_destroy(&bar_mutex);
    pthread_mutex_destroy(&max_mutex);
    pthread_cond_destroy(&bar_cond);
    
    free(thread_handles);
    free(sem_a);
    free(sem_y);
    free(x);

   return 0;
}  /* main */


/*------------------------------------------------------------------
 * Function:  Usage
 * Purpose:   print a message showing what the command line should
 *            be, and terminate
 * In arg :   prog_name
 */
void Usage (char* prog_name) {
   fprintf(stderr, "usage: %s <thread_count>\n", prog_name);
   exit(0);
}  /* Usage */

/*------------------------------------------------------------------
 * Function:    Read_matrix
 * Purpose:     Read in the matrix
 * In args:     prompt, m, n
 * Out arg:     A
 */
void Read_matrix(char* prompt, double A[], int m, int n) {
   int             i, j;

   printf("%s\n", prompt);
   for (i = 0; i < m; i++) 
      for (j = 0; j < n; j++)
         scanf("%lf", &A[i*n+j]);
}  /* Read_matrix */

/*------------------------------------------------------------------
 * Function:        Read_vector
 * Purpose:         Read in the vector x
 * In arg:          prompt, n
 * Out arg:         x
 */
void Read_vector(char* prompt, double x[], int n) {
   int   i;

   printf("%s\n", prompt);
   for (i = 0; i < n; i++) 
      scanf("%lf", &x[i]);
}  /* Read_vector */

/*------------------------------------------------------------------
 * Function:        Semaphores_wait
 * Purpose:         wait to get a lock
 * In arg:          sem, rank
 */
void Semaphores_wait(sem_t* sem, long rank) {
    if(sem_wait(sem) == -1) {
        fprintf(stderr, "Sem_wait failed for rank %ld\n", rank);
        exit(0);
    }
}  /* Semaphores_wait */

/*------------------------------------------------------------------
 * Function:        Semaphores_post
 * Purpose:         release semaphore lock
 * In arg:          sem, rank
 */
void Semaphores_post(sem_t* sem, long rank) {
    if(sem_post(sem) == -1) {
        fprintf(stderr, "Sem_post failed for rank %ld\n", rank);
        exit(0);
    }
}  /* Semaphores_post */


/*------------------------------------------------------------------
 * Function:       Pth_mat_vect
 * Purpose:        Multiply an mxn matrix by an nx1 column vector
 * In arg:         rank
 * Global in vars: A, x, m, n, thread_count
 * Global out var: y
 */
void *Pth_mat_vect(void* rank) {
    long my_rank = (long) rank;
    int local_i, j;
    int local_m = m/thread_count; 
    
    double* local_A = malloc(local_m*n*sizeof(double));
    double* local_y = malloc(local_m*sizeof(double));
    
    double start, finish, my_elapsed;
    
    /* Serialize input of local_A using semaphores */
    Semaphores_wait(&sem_a[my_rank], my_rank);

    for (local_i = 0; local_i < local_m; local_i++) 
        for (j = 0; j < n; j++)
            scanf("%lf", &local_A[local_i*n+j]);
    
    if(my_rank+1 < thread_count)
        Semaphores_post(&sem_a[my_rank+1], my_rank+1);
    
    /* record timer */
    My_barrier();
    GET_TIME(start);
    for (local_i = 0; local_i < local_m; local_i++) {
        local_y[local_i] = 0.0;
        for (j = 0; j < n; j++)
            local_y[local_i] += local_A[local_i*n + j]*x[j];
    }
    GET_TIME(finish);
    my_elapsed = finish-start;

    pthread_mutex_lock(&max_mutex);
    if (my_elapsed > elapsed) elapsed = my_elapsed;
    pthread_mutex_unlock(&max_mutex);
        
    /* Serialize output of local_y using semaphores */
    if (my_rank + 1 == thread_count)
        Semaphores_post(&sem_y[0], 0);
    
    Semaphores_wait(&sem_y[my_rank], my_rank);
    
    if(my_rank == 0) 
        Print_vector("The product is\n", local_y, local_m);
    else 
        Print_vector("", local_y, local_m);
    fflush(stdout);
    
    if (my_rank+1 < thread_count)
        Semaphores_post(&sem_y[my_rank+1], my_rank+1);
    else 
        printf("\n");

    free(local_A);
    free(local_y);
    
    return NULL;
}  /* Pth_mat_vect */

/*--------------------------------------------------------------*/

void My_barrier(void) {
    pthread_mutex_lock(&bar_mutex);
    bar_count++;
    if (bar_count == thread_count) {
        bar_count = 0;
        pthread_cond_broadcast(&bar_cond);
    } else {
        while (pthread_cond_wait(&bar_cond, &bar_mutex) != 0);
    }
    pthread_mutex_unlock(&bar_mutex);
}  /* My_barrier */

/*------------------------------------------------------------------
 * Function:    Print_matrix
 * Purpose:     Print the matrix
 * In args:     title, A, m, n
 */
void Print_matrix( char* title, double A[], int m, int n) {
   int   i, j;

   printf("%s\n", title);
   for (i = 0; i < m; i++) {
      for (j = 0; j < n; j++)
         printf("%4.1f ", A[i*n + j]);
      printf("\n");
   }
}  /* Print_matrix */


/*------------------------------------------------------------------
 * Function:    Print_vector
 * Purpose:     Print a vector
 * In args:     title, y, m
 */
void Print_vector(char* title, double y[], double m) {
   int   i;

   printf("%s", title);
   for (i = 0; i < m; i++)
      printf("%4.1f ", y[i]);
   //printf("\n");
}  /* Print_vector */
