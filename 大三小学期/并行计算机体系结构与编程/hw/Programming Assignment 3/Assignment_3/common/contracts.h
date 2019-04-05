/* Debugging with contracts; simulating cc0 -d
 * Enable with gcc -DDEBUG ...
 *
 * 15-122 Principles of Imperative Computation
 * Frank Pfenning
 */

#include <assert.h>

/* Unlike typical header files, "contracts.h" may be
 * included multiple times, with and without DEBUG defined.
 * For this to succeed we first undefine the macros in
 * question in order to avoid a redefinition warning.
 */

#undef ASSERT
#undef REQUIRES
#undef ENSURES

#ifdef DEBUG

#define ASSERT(COND) assert(COND)
#define REQUIRES(COND) assert(COND)
#define ENSURES(COND) assert(COND)

#else

#define ASSERT(COND) ((void)0)
#define REQUIRES(COND) ((void)0)
#define ENSURES(COND) ((void)0)

#endif
