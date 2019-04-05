#ifndef __LIBS_STDLIB_H__
#define __LIBS_STDLIB_H__

/* the largest number rand will return */
#define RAND_MAX    2147483647UL

/* libs/rand.c */
int rand(void);
void srand(unsigned int seed);

#endif /* !__LIBS_RAND_H__ */

