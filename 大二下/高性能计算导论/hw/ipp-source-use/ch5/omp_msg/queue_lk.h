/* File:     queue_lk.h
 * Purpose:  Header file for queue_lk.c, which implements a queue with 
 *           OpenMP locks
 */
#ifndef _QUEUE_LK_H_
#define _QUEUE_LK_H_
#include <omp.h>

struct queue_node_s {
   int src;
   int mesg;
   struct queue_node_s* next_p;
};

struct queue_s{
   omp_lock_t lock;
   int enqueued;
   int dequeued;
   struct queue_node_s* front_p;
   struct queue_node_s* tail_p;
};

struct queue_s* Allocate_queue(void);
void Free_queue(struct queue_s* q_p);
void Print_queue(struct queue_s* q_p);
void Enqueue(struct queue_s* q_p, int src, int mesg);
int Dequeue(struct queue_s* q_p, int* src_p, int* mesg_p);
int Search(struct queue_s* q_p, int mesg, int* src_p);

#endif
