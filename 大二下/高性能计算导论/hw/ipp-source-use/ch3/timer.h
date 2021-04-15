/* File:     timer.h
 *
 * Purpose:  Define a macro that returns the number of seconds that 
 *           have elapsed since some point in the past.  The timer
 *           should return times with microsecond accuracy.
 *
 * Note:     The argument passed to the GET_TIME macro should be
 *           a double, *not* a pointer to a double.
 *
 * Example:  
 *    #include "timer.h"
 *    . . .
 *    double start, finish, elapsed;
 *    . . .
 *    GET_TIME(start);
 *    . . .
 *    Code to be timed
 *    . . .
 *    GET_TIME(finish);
 *    elapsed = finish - start;
 *    printf("The code to be timed took %e seconds\n", elapsed);
 *
 * IPP:  Section 3.6.1 (p. 121) and Section 6.1.2 (pp. 273 and ff.)
 */
#ifndef _TIMER_H_
#define _TIMER_H_

#include <sys/time.h>

/* The argument now should be a double (not a pointer to a double) */
#define GET_TIME(now) { \
   struct timeval t; \
   gettimeofday(&t, NULL); \
   now = t.tv_sec + t.tv_usec/1000000.0; \
}

#endif
