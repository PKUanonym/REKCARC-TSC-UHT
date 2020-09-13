/* File:     queue.h
 * Purpose:  Header file for queue.c which implements a queue of messages
 *           or pairs of ints (source + contents) as a linked list.
 */
#ifndef _QUEUE_H_
#define _QUEUE_H_

struct queue_node_s {
   int src;
   int mesg;
   struct queue_node_s* next_p;
};

struct queue_s{
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
