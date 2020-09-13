/* File:     prog4.6_pth_ll_cond_rwl.c
 *
 * Purpose:  Implement a multi-threaded sorted linked list of 
 *           ints with ops insert, print, member, delete, free list.  
 *           This is a modified version of pth_ll_rwl.c.  It uses 
 *           hand-written read-write locks.  
 * 
 * Compile:  gcc -g -Wall -o prog4.6_pth_ll_cond_rwl prog4.6_pth_ll_cond_rwl.c 
 *              my_rand.c -lpthread
 *              needs timer.h and my_rand.h
 * Usage:    ./prog4.6_pth_ll_cond_rwl <thread_count>
 * Input:    total number of keys inserted by main thread
 *           total number of ops of each type carried out by each
 *              thread.
 * Output:   Elapsed time to carry out the ops
 *
 * Notes:
 *    1.  Repeated values are not allowed in the list
 *    2.  -DLST_DEBUG compile flag to get debug output for list ops
 *    3.  Uses condition variables and mutex for read-write lock instead of 
 *	  the Unix 98 Standard implementation of read-write locks.
 *    4.  The random function in stdlib is not threadsafe.  So this program
 *        uses a simple linear congruential generator.
 *    5.  -DOUTPUT flag to gcc will show list before and after
 *        threads have worked on it.
 *    6.  -DRWL will print the number of readers, writers, and
 *        the number of threads waiting before a call to a list function.
 *    7.  Default behavior favors readers:  if there are readers waiting
 *        when an Insert or Delete is completed, they are given preference.
 *        To give writers preference, define WRITERS
 *    8.  The performance of the program when writers are given preference
 *        depends on the percent of the ops that are searches vs. the 
 *        percent that are inserts and deletes.  On one of our systems
 *        with an initial list of 1000 elements in the range 0-99 and
 *        100,000 ops, when 90% are searches and the remainder are divided
 *        equally between inserts and deletes, giving readers preference makes
 *        the program run about 2.5% faster.  With the same parameters
 *        except 50% of the ops are searches, giving writers preference
 *        makes the program about 5.5% faster.
 *
 * IPP:   Programming Assignment 4.6
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "my_rand.h"
#include "timer.h"

/* Random ints are less than MAX_KEY */
//const int MAX_KEY = 100000000;
const int MAX_KEY = 100;


/* Struct for list nodes */
struct list_node_s {
   int    data;
   struct list_node_s* next;
};

/* Shared variables */
struct      list_node_s* head = NULL;  
int         thread_count;
int         total_ops;
double      insert_percent;
double      search_percent;
double      delete_percent;

//pthread_rwlock_t    rwlock;
pthread_mutex_t     count_mutex;
pthread_mutex_t	    rwl_mutex;
pthread_cond_t	    read_cond;
pthread_cond_t	    write_cond;
int volatile        t_write = 0; 
int volatile        t_read = 0;
int volatile        t_write_wait = 0;
int volatile        t_read_wait = 0;

int member_count = 0, insert_count = 0, delete_count = 0;

/* Setup and cleanup */
void        Usage(char* prog_name);
void        Get_input(int* inserts_in_main_p);

/* Thread functions */
void*       Thread_work(void* rank);
int         Thread_member(long my_rank, int val);
int         Thread_insert(long my_rank, int val);
int         Thread_delete(long my_rank, int val);

/* List operations */
int         Insert(int value);
void        Print(void);
int         Member(int value);
int         Delete(int value);
void        Free_list(void);
int         Is_empty(void);

/*-----------------------------------------------------------------*/
int main(int argc, char* argv[]) {
   long i; 
   int key, success, attempts;
   pthread_t* thread_handles;
   int inserts_in_main;
   unsigned seed = 1;
   double start, finish;

   if (argc != 2) Usage(argv[0]);
   thread_count = strtol(argv[1],NULL,10);

   Get_input(&inserts_in_main);

   /* Try to insert inserts_in_main keys, but give up after */
   /* 2*inserts_in_main attempts.                           */
   i = attempts = 0;
   while ( i < inserts_in_main && attempts < 2*inserts_in_main ) {
      key = my_rand(&seed) % MAX_KEY;
      success = Insert(key);
      attempts++;
      if (success) i++;
   }
   printf("Inserted %ld keys in empty list\n", i);

#  ifdef OUTPUT
   printf("Before starting threads, list = \n");
   Print();
   printf("\n");
#  endif

   thread_handles = malloc(thread_count*sizeof(pthread_t));
   pthread_mutex_init(&count_mutex, NULL);
// pthread_rwlock_init(&rwlock, NULL);
   pthread_mutex_init(&rwl_mutex, NULL);
   pthread_cond_init(&read_cond, NULL);
   pthread_cond_init(&write_cond, NULL);

   GET_TIME(start);
   for (i = 0; i < thread_count; i++)
      pthread_create(&thread_handles[i], NULL, Thread_work, (void*) i);

   for (i = 0; i < thread_count; i++)
      pthread_join(thread_handles[i], NULL);
   GET_TIME(finish);

   printf("Elapsed time = %e seconds\n", finish - start);
   printf("Total ops = %d\n", total_ops);
   printf("member ops = %d\n", member_count);
   printf("insert ops = %d\n", insert_count);
   printf("delete ops = %d\n", delete_count);

#  ifdef OUTPUT
   printf("After threads terminate, list = \n");
   Print();
   printf("\n");
#  endif

   Free_list();
   pthread_mutex_destroy(&rwl_mutex);
   pthread_cond_destroy(&read_cond);
   pthread_cond_destroy(&write_cond);
// pthread_rwlock_destroy(&rwlock);
   pthread_mutex_destroy(&count_mutex);
   free(thread_handles);

   return 0;
}  /* main */


/*-----------------------------------------------------------------*/
void Usage(char* prog_name) {
   fprintf(stderr, "usage: %s <thread_count>\n", prog_name);
   exit(0);
}  /* Usage */

/*-----------------------------------------------------------------*/
void Get_input(int* inserts_in_main_p) {

   printf("How many keys should be inserted in the main thread?\n");
   scanf("%d", inserts_in_main_p);
   printf("How many ops total should be executed?\n");
   scanf("%d", &total_ops);
   printf("Percent of ops that should be searches? (between 0 and 1)\n");
   scanf("%lf", &search_percent);
   printf("Percent of ops that should be inserts? (between 0 and 1)\n");
   scanf("%lf", &insert_percent);
   delete_percent = 1.0 - (search_percent + insert_percent);
}  /* Get_input */

/*-----------------------------------------------------------------*/
/* Insert value in correct numerical location into list */
/* If value is not in list, return 1, else return 0 */
int Insert(int value) {
   struct list_node_s* curr = head;
   struct list_node_s* pred = NULL;
   struct list_node_s* temp;
   int rv = 1;
   
   while (curr != NULL && curr->data < value) {
      pred = curr;
      curr = curr->next;
   }

   if (curr == NULL || curr->data > value) {
      temp = malloc(sizeof(struct list_node_s));
      temp->data = value;
      temp->next = curr;
      if (pred == NULL)
         head = temp;
      else
         pred->next = temp;
   } else { /* value in list */
      rv = 0;
   }

   return rv;
}  /* Insert */

/*-----------------------------------------------------------------*/
void Print(void) {
   struct list_node_s* temp;

   printf("list = ");

   temp = head;
   while (temp != (struct list_node_s*) NULL) {
      printf("%d ", temp->data);
      temp = temp->next;
   }
   printf("\n");
}  /* Print */


/*-----------------------------------------------------------------*/
int  Member(int value) {
   struct list_node_s* temp;

   temp = head;
   while (temp != NULL && temp->data < value)
      temp = temp->next;

   if (temp == NULL || temp->data > value) {
#     ifdef LST_DEBUG
      printf("%d is not in the list\n", value);
#     endif
      return 0;
   } else {
#     ifdef LST_DEBUG
      printf("%d is in the list\n", value);
#     endif
      return 1;
   }
}  /* Member */

/*-----------------------------------------------------------------*/
/* Deletes value from list */
/* If value is in list, return 1, else return 0 */
int Delete(int value) {
   struct list_node_s* curr = head;
   struct list_node_s* pred = NULL;
   int rv = 1;

   /* Find value */
   while (curr != NULL && curr->data < value) {
      pred = curr;
      curr = curr->next;
   }
   
   if (curr != NULL && curr->data == value) {
      if (pred == NULL) { /* first element in list */
         head = curr->next;
#        ifdef LST_DEBUG
         printf("Freeing %d\n", value);
#        endif
         free(curr);
      } else { 
         pred->next = curr->next;
#        ifdef LST_DEBUG
         printf("Freeing %d\n", value);
#        endif
         free(curr);
      }
   } else { /* Not in list */
      rv = 0;
   }

   return rv;
}  /* Delete */

/*-----------------------------------------------------------------*/
void Free_list(void) {
   struct list_node_s* current;
   struct list_node_s* following;

   if (Is_empty()) return;
   current = head; 
   following = current->next;
   while (following != NULL) {
#     ifdef LST_DEBUG
      printf("Freeing %d\n", current->data);
#     endif
      free(current);
      current = following;
      following = current->next;
   }
#  ifdef LST_DEBUG
   printf("Freeing %d\n", current->data);
#  endif
   free(current);
}  /* Free_list */

/*-----------------------------------------------------------------*/
int  Is_empty(void) {
   if (head == NULL)
      return 1;
   else
      return 0;
}  /* Is_empty */

/*-----------------------------------------------------------------*/
void* Thread_work(void* rank) {
   long my_rank = (long) rank;
   int i, val;
   double which_op;
   unsigned seed = my_rank + 1;
   int my_member_count = 0, my_insert_count = 0, my_delete_count = 0;
   int ops_per_thread = total_ops/thread_count;

   for (i = 0; i < ops_per_thread; i++) {
      which_op = my_drand(&seed);
      val = my_rand(&seed) % MAX_KEY;
      if (which_op < search_percent) {
         Thread_member(my_rank, val);
         my_member_count++;
      } else if (which_op < search_percent + insert_percent) {
         Thread_insert(my_rank, val);
         my_insert_count++;
      } else { /* delete */
         Thread_delete(my_rank, val);
         my_delete_count++;
      }
   }  /* for */

   pthread_mutex_lock(&count_mutex);
   member_count += my_member_count;
   insert_count += my_insert_count;
   delete_count += my_delete_count;
   pthread_mutex_unlock(&count_mutex);

   return NULL;
}  /* Thread_work */

/*-----------------------------------------------------------------*/
int Thread_member(long my_rank, int val) {
   int rv;

// pthread_rwlock_rdlock(&rwlock);

   /* Wait until there are no writers */
   pthread_mutex_lock(&rwl_mutex);
   while(t_write > 0) {
      t_read_wait++;
      while(pthread_cond_wait(&read_cond, &rwl_mutex) != 0);
      t_read_wait--;
   }
   t_read++;
#  ifdef RWL
   printf("Th %ld > Before Mem: rd = %d, wr = %d, rd_wt = %d, wr_wait = %d\n", 
         my_rank, t_read, t_write, t_read_wait, t_write_wait);
#  endif
   pthread_mutex_unlock(&rwl_mutex);

   /* Now search */
   rv = Member(val);

   /* Update count of readers */
   pthread_mutex_lock(&rwl_mutex);
   t_read--;
#  ifdef RWL
   printf("Th %ld > After Mem:  rd = %d, wr = %d, rd_wt = %d, wr_wait = %d\n", 
         my_rank, t_read, t_write, t_read_wait, t_write_wait);
#  endif
   if (t_read == 0 && t_write_wait > 0) pthread_cond_signal(&write_cond);
   pthread_mutex_unlock(&rwl_mutex);
// pthread_rwlock_unlock(&rwlock);

   return rv;
}  /* Thread_member */


/*-----------------------------------------------------------------*/
int Thread_insert(long my_rank, int val) {
   int rv;

// pthread_rwlock_wrlock(&rwlock);

   /* Wait until there are no readers or writers */
   pthread_mutex_lock(&rwl_mutex);
   while(t_write > 0 || t_read > 0) {
      t_write_wait++;
      while(pthread_cond_wait(&write_cond, &rwl_mutex) != 0);
      t_write_wait--;
   }
   t_write++;
#  ifdef RWL
   printf("Th %ld > Before Ins: rd = %d, wr = %d, rd_wt = %d, wr_wait = %d\n", 
         my_rank, t_read, t_write, t_read_wait, t_write_wait);
#  endif
   pthread_mutex_unlock(&rwl_mutex);

   /* Now insert */
   Insert(val);

   /* Update count of writers.  Release one or more waiting threads. */
   pthread_mutex_lock(&rwl_mutex);
   t_write--;
#  ifdef RWL
   printf("Th %ld > After Ins:  rd = %d, wr = %d, rd_wt = %d, wr_wait = %d\n", 
         my_rank, t_read, t_write, t_read_wait, t_write_wait);
#  endif
#  ifndef WRITERS
   if (t_read_wait > 0) 
      pthread_cond_broadcast(&read_cond);
   else if (t_write_wait > 0)
      pthread_cond_signal(&write_cond);
#  else
   if (t_write_wait > 0) 
      pthread_cond_signal(&write_cond);
   else if (t_read_wait > 0)
      pthread_cond_broadcast(&read_cond);
#  endif
   pthread_mutex_unlock(&rwl_mutex);
// pthread_rwlock_unlock(&rwlock);

   return rv;
}  /* Thread_insert */


/*-----------------------------------------------------------------*/
int Thread_delete(long my_rank, int val) {
   int rv;

// pthread_rwlock_wrlock(&rwlock);

   /* Wait until there are no readers or writers */
   pthread_mutex_lock(&rwl_mutex);
   while(t_write > 0 || t_read > 0) {
      t_write_wait++;
      while(pthread_cond_wait(&write_cond, &rwl_mutex) != 0);
      t_write_wait--;
   }
   t_write++;
#  ifdef RWL
   printf("Th %ld > Before Del: rd = %d, wr = %d, rd_wt = %d, wr_wait = %d\n", 
         my_rank, t_read, t_write, t_read_wait, t_write_wait);
#  endif
   pthread_mutex_unlock(&rwl_mutex);

   /* Now delete */
   Delete(val);
   
   /* Update count of writers, release one or more waiting threads */
   pthread_mutex_lock(&rwl_mutex);
   t_write--;
#  ifdef RWL
   printf("Th %ld > After Del:  rd = %d, wr = %d, rd_wt = %d, wr_wait = %d\n", 
         my_rank, t_read, t_write, t_read_wait, t_write_wait);
#  endif
#  ifndef WRITERS
   if (t_read_wait > 0) 
      pthread_cond_broadcast(&read_cond);
   else if (t_write_wait > 0)
      pthread_cond_signal(&write_cond);
#  else
   if (t_write_wait > 0) 
      pthread_cond_signal(&write_cond);
   else if (t_read_wait > 0)
      pthread_cond_broadcast(&read_cond);
#  endif
   pthread_mutex_unlock(&rwl_mutex);
// pthread_rwlock_unlock(&rwlock);

   return rv;
}  /* Thread_delete */
