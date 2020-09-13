/* File:     frac.c
 * Purpose:  
 *    Suppose a, b, k and n are nonnegative integers.  We want to 
 *    implement the following operations on fractions having
 *    the form a/2^k:
 *
 *              a/2^k + 1/2^n
 *              1/2^n / 2
 *              Reduce a/2^k to lowest terms
 *              Determine whether a/2^k == b
 *              Assign a value to a/2^k, 1/2^n
 *              Print a/2^k and 1/2^n
 *
 * Representation:  
 *    Fractions having the form 1/2^n are represented by n -- the
 *       base 2 log of the denominator.
 *    Fractions having the form a/2^k are represented by a pair:
 *       a bit array represents a, and k represents the denominator.
 *       The bit array is little endian:
 *
 *          a = array[0] + 2*array[1] + 4*array[2] + . . .
 *
 *    b, k, n are ordinary ints
 *
 * Implementation:
 *    Halving 1/2^n simply adds 1 to n.  
 *    To reduce a/2^k, count the number of consecutive 0 bits in a
 *       to the left of the radix point.  If this is b, take the
 *       minimum m of b and k.  Right shift a m bits and replace
 *       k by k-m.
 *    To test a/2^k == b, reduce a/2^k to lowest terms. 
 *       If k != 0 return false.
 *       If k == 0, convert a to an ordinary int and compare
 *          the resulting int and b
 *    The only value that's assigned directly to a/2^k is 0,
 *       which is given during initialization.
 *    To print a/2^k, check whether a > largest unsigned int.
 *       If so, print XX for numerator.  If not, use standard
 *       algorithm to convert bit string to int.  Denominators
 *       are just printed as 2^k.
 *    To add:
 *          if (k > n)
 *             numerator = a + 2^(k-n)
 *             denominator = k
 *             Reduce
 *          if (k == n)
 *             numerator = a + 1
 *             denominator = k
 *             Reduce
 *          if (k < n)
 *             numerator = a*2^(n-k) + 1
 *                       = Left_shift(a, n-k) + 1
 *             denominator = n
 *
 *
 * Compile:  mpicc -g -Wall -c frac.c
 *
 * Compile with driver:  mpicc -g -Wall -DUSE_DRIVER -o frac frac.c
 * Run with driver:  mpiexec -n 1 ./frac
 * 
 * Notes:
 * 1.  There is no check for underflow:  if we get a denominator that's
 *     as big as 2^(2^32-1) we deserve to crash.
 * 2.  We do check for overflow of the numerator.  If there is a carry
 *     beyond the most significant bit of a, we call realloc
 *
 * IPP:  Section 6.2.12 (pp. 331 and ff.)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#include "frac.h"

static const int INIT_ALLOC = 1024;  // to start 1024 bits in numerator 



/*---------------------------------------------------------------------
 * Function:  Alloc_frac
 * Purpose:   Allocate and initialize storage for a/2^k, a = k = 0
 */
frac_t Alloc_frac(void) {
   int i;

   frac_t new_frac = malloc(sizeof(frac_struct));
   new_frac->num = malloc(INIT_ALLOC*sizeof(char));
   for (i = 0; i < INIT_ALLOC; i++) 
      new_frac->num[i] = 0;
   new_frac->denom = 0;
   new_frac->alloc = INIT_ALLOC;
   new_frac->least_sig_bit = 0;
   new_frac->most_sig_bit = -1;

   return new_frac;
}  /* Alloc_frac */


/*---------------------------------------------------------------------
 * Function:  Free_frac
 * Purpose:   Free storage taken bya frac_t
 */
void Free_frac(frac_t frac) {
   free(frac->num);
   free(frac);
}  /* Free_frac */

/*---------------------------------------------------------------------
 * Function:    Add
 * Purpose:     Add two fractions
 * In args:     frac2
 * In/out arg:  frac1 += frac2
 */
void Add(frac_t frac1, unsigned frac2) {
   if (frac1->denom >= frac2) {
      Add_to_num(frac1, frac1->denom - frac2);
   } else {
      Left_shift_num(frac1, frac2 - frac1->denom);
      Add_to_num(frac1, 0);
      frac1->denom = frac2;
   }
   Reduce(frac1);
}  /* Add */

/*---------------------------------------------------------------------
 * Function:  Left_shift
 * Purpose:   Left_shift frac by b bits
 */
void Left_shift_num(frac_t frac, unsigned b) {
   int new_alloc = frac->alloc, i;

   if (frac->most_sig_bit + b >= new_alloc) {
      new_alloc = 2*frac->alloc;
      while (new_alloc <= frac->most_sig_bit + b)
         new_alloc *= 2;
      frac->num = realloc(frac->num, new_alloc);
      if (frac->num == NULL) {
         fprintf(stderr, "Out of memory in realloc of frac_t, requested %d\n",
               2*frac->alloc);
         MPI_Abort(MPI_COMM_WORLD, -1);
      }
      frac->alloc = new_alloc;
   }

   for (i = frac->most_sig_bit; i >= 0; i--) {
      frac->num[i+b] = frac->num[i];
      frac->num[i] = 0;
   }

   Find_sig_bits(frac);
}  /* Multiply_num */

/*---------------------------------------------------------------------
 * Function:  Add_to_num
 * Purpose:   Add to 2^power to the numerator of frac
 */
void Add_to_num(frac_t frac, unsigned power) {
   int i = power;
   char carry = 1;

   if (power >= frac->alloc) {
      int new_alloc = 2*frac->alloc;
      while (new_alloc <= power)
         new_alloc *= 2;
      frac->num = realloc(frac->num, new_alloc);
      if (frac->num == NULL) {
         fprintf(stderr, "Out of memory in realloc of frac_t, requested %d\n",
               2*frac->alloc);
         MPI_Abort(MPI_COMM_WORLD, -1);
      }
      frac->alloc = new_alloc;
   }

   while (carry && i < frac->alloc) {
      if (frac->num[i] != 0) {
         carry = 1;
         frac->num[i] = 0;
      } else {
         carry = 0;
         frac->num[i] = 1;
      }
      i++;
   }
   if (i == frac->alloc) {
      frac->num = realloc(frac->num, 2*frac->alloc);
      if (frac->num == NULL) {
         fprintf(stderr, "Out of memory in realloc of frac_t, requested %d\n",
               2*frac->alloc);
         MPI_Abort(MPI_COMM_WORLD, -1);
      }
      frac->num[i] = 1;
      frac->alloc = 2*frac->alloc;
   }

   Find_sig_bits(frac);
}  /* Add_to_num */


/*---------------------------------------------------------------------
 * Function:   Reduce
 * Purpose:    Reduce a fraction to lowest terms
 * In/out arg: frac
 */
void Reduce(frac_t frac) {
   int shift;

   if (frac->least_sig_bit > frac->denom)
      shift = frac->denom;
   else 
      shift = frac->least_sig_bit;

   if (shift == 0) return;
   Right_shift_num(frac, shift);
   frac->denom -= shift;
   
}  /* Reduce */


/*---------------------------------------------------------------------
 * Function:   Right_shift_num
 * Purpose:    Shift the numerator to the right, filling vacated locations
 *             with zeroes.
 * Note:       This is clearly an inefficient implementation
 */
void Right_shift_num(frac_t frac, int bits) {
   int i, j;

   for (i = 0; i < bits; i++) 
      frac->num[i] = 0;

   for (i = bits, j = 0; i < frac->alloc; i++, j++) {
      frac->num[j] = frac->num[i];
      frac->num[i] = 0;
   }

   Find_sig_bits(frac);
}  /* Right_shift_num */


/*---------------------------------------------------------------------
 * Function:  Find_sig_bits
 * Purpose:   Find the least and most significant bits in frac
 * Note:      This function is probably unnecessary:  the bits should
 *            probably be found on the basis of the old bits and
 *            knowledge of the calling function
 */
void Find_sig_bits(frac_t frac) {
   int i;

   frac->least_sig_bit = frac->alloc;
   for (i = 0; i < frac->alloc; i++)
      if (frac->num[i] != 0) {
         frac->least_sig_bit = i;
         break;
      }
   // If numerator is zero
   if (frac->least_sig_bit == frac->alloc) {
      frac->least_sig_bit = 0;
      frac->most_sig_bit = -1;
      return;
   }
   for (i = frac->alloc-1; i >= 0; i--)
      if (frac->num[i] != 0) {
         frac->most_sig_bit = i;
         break;
      }
}  /* Find_sig_bits */


/*---------------------------------------------------------------------
 * Function:     Equals
 * Purpose:      Determine whether two fractions are equal
 * In/out args:  frac1, frac2
 * Note:
 * 1.  Instead of cross-multiplying, we reduce both fractions and
 *     check for equality of numerator and denominator:  this may
 *     avoid some overflow issues.
 */
int Equals(frac_t frac, unsigned val) {
   Reduce(frac);
   if (frac->denom != 0)
      return 0;  // false
   else if (frac->most_sig_bit > sizeof(unsigned))
      return 0;
   else if (Equals_bit_array(frac, val))
      return 1;
   else
      return 0;
}  /* Equals */

/*---------------------------------------------------------------------
 * Function:    Equals_bit_array
 * Purpose:     Determine whether the integer stored in the numerator
 *              of frac equals val
 * Note:        The calling function should determine whether
 *              conversion of bit array to an unsigned will cause
 *              overflow.
 */
int Equals_bit_array(frac_t frac, unsigned val) {
   unsigned ba_val = Convert_num_to_unsigned(frac);
   if (ba_val == val)
      return 1;
   else
      return 0;
}  /*  Equals_bit_array */


/*---------------------------------------------------------------------
 * Function:   Convert_num_to_unsigned
 * Purpose:    Convert the bit array representing the numerator to
 *             an unsigned
 */
unsigned Convert_num_to_unsigned(frac_t frac) {
   int i;
   unsigned ba_val = 0;

   for (i = frac->least_sig_bit; i <= frac->most_sig_bit; i++)
      if (frac->num[i] != 0)
         ba_val += (1 << i);

   return ba_val;
}  /* Convert_num_to_unsigned */


/*---------------------------------------------------------------------
 * Function:   Print_frac
 * Purpose:    Print a fraction to stdout
 * In arg:     frac
 */
void Print_frac(frac_t frac, int my_rank, char title[]) {
   unsigned num;
   if (frac->most_sig_bit >= 8*sizeof(unsigned)) {
      printf("Proc %d > %s (XX, %u) = XX/2^%u\n", my_rank,
            title, frac->denom, frac->denom);
   } else {
      num = Convert_num_to_unsigned(frac);
      printf("Proc %d > %s (%u, %u) = %u/2^%u\n", my_rank,
         title, num, frac->denom, num, frac->denom);
   }
}  /* Print_frac */


/*---------------------------------------------------------------------
 * Function:  Debug_print_frac
 * Purpose:   Print all fields of a frac_t
 */
void Debug_print_frac(frac_t frac) {
   int i;
   char string[1025];
   string[0] = '\0';

   for (i = frac->most_sig_bit; i >= 0; i--)
      sprintf(string + strlen(string), "%d", frac->num[i]);
   printf("num = %s\n", string);
   printf("   denom = %u\n", frac->denom);
   printf("   alloc = %d\n", frac->alloc);
   printf("   least sig bit = %d\n", frac->least_sig_bit);
   printf("   most sig bit = %d\n", frac->most_sig_bit);
   printf("\n");
}  /* Debug_print */


/*---------------------------------------------------------------------
 * Function:  Assign
 * Purpose:   Assign values to the numerator and denominator of a frac_t
 */
void Assign(frac_t frac, unsigned num, unsigned denom) {
   int i = 0;

   memset(frac->num, 0, frac->alloc);
   while (num != 0) {
      frac->num[i] = num % 2;
      num /= 2;
      i++;
   }
   frac->denom = denom;
   Find_sig_bits(frac);
}  /* Assign */ 


#ifdef USE_DRIVER
int main(void) {
   char command;
   frac_t frac;
   unsigned other_frac, test_eq, u1, u2;

   MPI_Init(NULL, NULL);
   frac = Alloc_frac();

   printf("Enter a command (a, r, e, d, s, q)\n");
   scanf(" %c", &command);
   while (command != 'q') {
      switch(command) {
         case 'a':
            printf("Enter log denom of a frac\n");
            scanf("%u", &other_frac);
            Add(frac, other_frac);
            Print_frac(frac, 0, "Sum = ");
            break;
         case 'r':
            Reduce(frac);
            Print_frac(frac, 0, "Reduced frac = ");
            break;
         case 'e':
            printf("Enter an unsigned int\n");
            scanf("%u", &test_eq);
            if (Equals(frac, test_eq))
               printf("They're equal\n");
            else
               printf("They're not equal\n");
            break;
         case 'd':
            Debug_print(frac);
            break;
         case 's':  // Assign
            printf("Enter two unsigned ints\n");
            scanf("%u %u", &u1, &u2);
            Assign(frac, u1, u2);
            Print_frac(frac, 0, "We created = ");
            break;
         default:
            printf("I didn't understand %c\n", command);
            break;
      }  /* switch */
      printf("Enter a command (a, r, e, d, s, q)\n");
      scanf(" %c", &command);
   }  /* while */

   Free_frac(frac);
   MPI_Finalize();

   return 0;
}  /* main */
#endif
