/* File:     my_rand.h
 * Purpose:  Header file for my_rand.c, which implements a simple
 *           pseudo-random number generator.
 *
 * IPP:  Not discussed, but needed by the multithreaded linked list programs
 *       discussed in Section 4.9.2-4.9.4 (pp. 183-190).
 */
#ifndef _MY_RAND_H_
#define _MY_RAND_H_

unsigned my_rand(unsigned* a_p);
double my_drand(unsigned* a_p);

#endif
