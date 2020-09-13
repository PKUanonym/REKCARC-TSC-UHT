/* File:	ex5.1_omp_macro.c
 * Purpose:	print out value of the _OPENMP macro if it's defined
 *
 * Compile:	gcc -g -Wall -fopenmp -o ex5.1_omp_macro ex5.1_omp_macro.c
 * Run:		./ex5.1_omp_macro
 *
 * Input:	None
 * Output:	Value of _OPENMP macro if it's defined, otherwise a message 
 *              stating that it's not defined
 *
 * IPP:         Exercise 5.1
 */

#include <stdio.h>
#include <stdlib.h>

/* Include omp.h when macro is defined */
#ifdef _OPENMP
#  include <omp.h>
#endif

void Usage(char prog_name[]);

int main(int argc, char* argv[]) {
#  ifdef _OPENMP
   printf("_OPENMP = %d\n", _OPENMP);
#  else
   printf("_OPENMP isn't defined\n");
#  endif
   
   return 0;
}  /* main */
