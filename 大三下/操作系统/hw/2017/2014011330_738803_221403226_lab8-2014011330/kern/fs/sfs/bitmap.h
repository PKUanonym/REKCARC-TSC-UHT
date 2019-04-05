#ifndef __KERN_FS_SFS_BITMAP_H__
#define __KERN_FS_SFS_BITMAP_H__

#include <defs.h>


/*
 * Fixed-size array of bits. (Intended for storage management.)
 *
 * Functions:
 *     bitmap_create  - allocate a new bitmap object.
 *                      Returns NULL on error.
 *     bitmap_getdata - return pointer to raw bit data (for I/O).
 *     bitmap_alloc   - locate a cleared bit, set it, and return its index.
 *     bitmap_mark    - set a clear bit by its index.
 *     bitmap_unmark  - clear a set bit by its index.
 *     bitmap_isset   - return whether a particular bit is set or not.
 *     bitmap_destroy - destroy bitmap.
 */


struct bitmap;

struct bitmap *bitmap_create(uint32_t nbits);                     // allocate a new bitmap object.
int bitmap_alloc(struct bitmap *bitmap, uint32_t *index_store);   // locate a cleared bit, set it, and return its index.
bool bitmap_test(struct bitmap *bitmap, uint32_t index);          // return whether a particular bit is set or not.
void bitmap_free(struct bitmap *bitmap, uint32_t index);          // according index, set related bit to 1
void bitmap_destroy(struct bitmap *bitmap);                       // free memory contains bitmap
void *bitmap_getdata(struct bitmap *bitmap, size_t *len_store);   // return pointer to raw bit data (for I/O)

#endif /* !__KERN_FS_SFS_BITMAP_H__ */

