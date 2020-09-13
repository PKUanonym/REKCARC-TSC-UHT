/* File:     frac.h
 * Purpose:  Header file for frac.c, which implement common fractions and 
 *           certain operations on common fractions in which the denominator 
 *           is a power of 2
 *
 * IPP:      Section 6.2.12  (pp. 331 and ff.)
 */
#ifndef _FRAC_H_
#define _FRAC_H_

typedef struct {
   char*    num;            // bit array representing numerator
   unsigned denom;          // base 2 log of denominator
   int      alloc;          // size of bit array
   int      least_sig_bit;  // first nonzero bit
   int      most_sig_bit;   // last nonzero bit
}  frac_struct;
typedef frac_struct* frac_t;

frac_t Alloc_frac(void);
void Free_frac(frac_t frac);
void Add(frac_t frac1, unsigned frac2);
void Left_shift_num(frac_t frac, unsigned b);
void Add_to_num(frac_t frac, unsigned power);
void Reduce(frac_t frac);
void Right_shift_num(frac_t frac, int bits);
void Find_sig_bits(frac_t frac);
int Equals(frac_t frac, unsigned val);
int Equals_bit_array(frac_t frac, unsigned val);
unsigned Convert_num_to_unsigned(frac_t frac);
void Print_frac(frac_t frac, int my_rank, char title[]);

void Debug_print_frac(frac_t frac);
void Assign(frac_t frac, unsigned num, unsigned denom);
#endif
