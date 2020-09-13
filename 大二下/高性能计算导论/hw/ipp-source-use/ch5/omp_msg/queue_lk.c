/* File:     queue_lk.c
 * Purpose:  Implement a queue with locks using a linked list and OpenMP.
 *           Operations are Enqueue, Dequeue, Print, Search, and Free.
 *           To be used with omp_msglk.c
 *
 * Compile:  gcc -g -Wall -DUSE_MAIN -fopenmp -o queue_lk queue_lk.c
 * Usage:    ./queue_lk
 *
 * Input:    Operations (first letter of op name) and, when necessary, keys
 * Output:   Prompts for input and results of operations
 *
 * IPP:      Section 5.8.9 (pp. 248 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "queue_lk.h"


#ifdef USE_MAIN
int main(void) {
   char op;
   int  src, mesg, not_empty;
   struct queue_s* q_p = Allocate_queue();

   printf("Op? (e, d, p, s, f, q)\n");
   scanf(" %c", &op);
   while (op != 'q' && op != 'Q') {
      switch (op) {
         case 'e':
         case 'E':
            printf("Src? Mesg?\n");
            scanf("%d%d", &src, &mesg);
            omp_set_lock(&q_p->lock);
            Enqueue(q_p, src, mesg);
            omp_unset_lock(&q_p->lock);
            break;
         case 'd':
         case 'D':
            omp_set_lock(&q_p->lock);
            not_empty = Dequeue(q_p, &src, &mesg);
            omp_unset_lock(&q_p->lock);
            if (not_empty)
               printf("Dequeued src = %d, mesg = %d\n", src, mesg);
            else 
               printf("Queue is empty\n");
            break;
         case 's':
         case 'S':
            printf("Mesg?\n");
            scanf("%d", &mesg);
            if (Search(q_p, mesg, &src))
               printf("Found %d from %d\n", mesg, src);
            else
               printf("Didn't find %d\n", mesg);
            break;
         case 'p':
         case 'P':
            Print_queue(q_p);
            break;
         case 'f':
         case 'F':
            omp_set_lock(&q_p->lock);
            Free_queue(q_p);
            omp_unset_lock(&q_p->lock);
            break;
         default:
            printf("%c isn't a valid command\n", op);
            printf("Please try again\n");
      }  /* switch */
      printf("Op? (e, d, p, s, f, q)\n");
      scanf(" %c", &op);
   }  /* while */

   Free_queue(q_p);
   omp_destroy_lock(&q_p->lock);
   free(q_p);
   return 0;
}  /* main */
#endif

struct queue_s* Allocate_queue() {
   struct queue_s* q_p = malloc(sizeof(struct queue_s));
   q_p->enqueued = q_p->dequeued = 0;
   q_p->front_p = NULL;
   q_p->tail_p = NULL;
   omp_init_lock(&q_p->lock);
   return q_p;
}  /* Allocate_queue */

/* Frees nodes in queue:  leaves queue struct allocated and lock
 * initialized */
void Free_queue(struct queue_s* q_p) {
   struct queue_node_s* curr_p = q_p->front_p;
   struct queue_node_s* temp_p;

   while(curr_p != NULL) {
      temp_p = curr_p;
      curr_p = curr_p->next_p;
      free(temp_p);
   }
   q_p->enqueued = q_p->dequeued = 0;
   q_p->front_p = q_p->tail_p = NULL;
}   /* Free_queue */

void Print_queue(struct queue_s* q_p) {
   struct queue_node_s* curr_p = q_p->front_p;

   printf("queue = \n");
   while(curr_p != NULL) {
      printf("   src = %d, mesg = %d\n", curr_p->src, curr_p->mesg);
      curr_p = curr_p->next_p;
   }
   printf("enqueued = %d, dequeued = %d\n", q_p->enqueued, q_p->dequeued);
   printf("\n");
}  /*  Print_Queue */

void Enqueue(struct queue_s* q_p, int src, int mesg) {
   struct queue_node_s* n_p = malloc(sizeof(struct queue_node_s));
   n_p->src = src;
   n_p->mesg = mesg;
   n_p->next_p = NULL;
   if (q_p->tail_p == NULL) { /* Empty Queue */
      q_p->front_p = n_p;
      q_p->tail_p = n_p;
   } else {
      q_p->tail_p->next_p = n_p;
      q_p->tail_p = n_p;
   }
   q_p->enqueued++;
}  /* Enqueue */

int Dequeue(struct queue_s* q_p, int* src_p, int* mesg_p) {
   struct queue_node_s* temp_p;

   if (q_p->front_p == NULL) return 0;
   *src_p = q_p->front_p->src;
   *mesg_p = q_p->front_p->mesg;
   temp_p = q_p->front_p;
   if (q_p->front_p == q_p->tail_p)  /* One node in list */
      q_p->front_p = q_p->tail_p = NULL;
   else
      q_p->front_p = temp_p->next_p;
   free(temp_p);
   q_p->dequeued++;
   return 1;
}  /* Dequeue */

int Search(struct queue_s* q_p, int mesg, int* src_p) {
   struct queue_node_s* curr_p = q_p->front_p;

   while (curr_p != NULL)
      if (curr_p->mesg == mesg) {
         *src_p = curr_p->src;
         return 1;
      } else {
         curr_p = curr_p->next_p;
      }
   return 0;

}  /* Search */
