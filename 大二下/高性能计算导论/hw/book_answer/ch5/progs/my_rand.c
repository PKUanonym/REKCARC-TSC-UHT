/* File:     my_rand.c
 *
 * Purpose:  implement a linear congruential random number generator
 *
 * my_rand:  generates a random unsigned int in the range 0 - MR_MODULUS
 * my_drand: generates a random double in the range 0 - 1
 *
 * Notes:
 * 1.  The generator is taken from the Wikipedia article "Linear congruential
 *     generator"
 * 2.  This is *not* a very good random number generator.  However, unlike
 *     the C library function random(), it *is* threadsafe:  the "state" of
 *     the generator is returned in the seed_p argument.
 * 3.  The value referred to by seed_p must be nonzero
 * 4.  The main function is just a simple driver.
 */
#include <stdio.h>
#include <stdlib.h>
#include "my_rand.h"

#define MR_MULTIPLIER 279470273 
#define MR_INCREMENT 0
#define MR_MODULUS 4294967291U
#define MR_DIVISOR ((double) 4294967291U)


#ifdef _MAIN_
int main(void) {
   int n, i; 
   unsigned seed = 1, x;
   double y;

   printf("How many random numbers?\n");
   scanf("%d", &n);

   x = my_rand(&seed);
   for (i = 0; i < n; i++) {
      x = my_rand(&x);
      printf("%u\n", x);
   }
   for (i = 0; i < n; i++) {
      y = my_drand(&x);
      printf("%e\n", y);
   }
   return 0;
}
#endif

/* Function:      my_rand
 * In/out arg:    seed_p
 * Return value:  A new pseudo-random unsigned int in the range
 *                0 - MR_MODULUS
 *
 * Notes:  
 * 1.  This is a slightly modified version of the generator in an
 *     old version of the Wikipedia article "Linear congruential 
 *     generator"
 * 2.  The seed_p argument stores the "state" for the next call to
 *     the function.
 * 3.  *seed_p must be nonzero
 * 4.  The value of *seed_p should be set before the first call 
 *     to my_rand, and the value returned from one call should
 *     simply be passed to the next call.
 */
unsigned my_rand(unsigned* seed_p) {
   long long z = *seed_p;
   z *= MR_MULTIPLIER; 
// z += MR_INCREMENT;
   z %= MR_MODULUS;
   *seed_p = z;
   return *seed_p;
}

/* Function:      my_drand
 * In/out arg:    seed_p
 * Return value:  A new pseudo-random double in the range 0 - 1
 *
 * Note:          See my_rand for info about seed_p
 */
double my_drand(unsigned* seed_p) {
   unsigned x = my_rand(seed_p);
   double y = x/MR_DIVISOR;
   return y;
}
