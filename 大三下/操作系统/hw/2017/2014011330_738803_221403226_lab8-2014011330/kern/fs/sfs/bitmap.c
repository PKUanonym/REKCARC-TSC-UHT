#include <defs.h>
#include <string.h>
#include <bitmap.h>
#include <kmalloc.h>
#include <error.h>
#include <assert.h>

#define WORD_TYPE           uint32_t
#define WORD_BITS           (sizeof(WORD_TYPE) * CHAR_BIT)

struct bitmap {
    uint32_t nbits;
    uint32_t nwords;
    WORD_TYPE *map;
};

// bitmap_create - allocate a new bitmap object.
struct bitmap *
bitmap_create(uint32_t nbits) {
    static_assert(WORD_BITS != 0);
    assert(nbits != 0 && nbits + WORD_BITS > nbits);

    struct bitmap *bitmap;
    if ((bitmap = kmalloc(sizeof(struct bitmap))) == NULL) {
        return NULL;
    }

    uint32_t nwords = ROUNDUP_DIV(nbits, WORD_BITS);
    WORD_TYPE *map;
    if ((map = kmalloc(sizeof(WORD_TYPE) * nwords)) == NULL) {
        kfree(bitmap);
        return NULL;
    }

    bitmap->nbits = nbits, bitmap->nwords = nwords;
    bitmap->map = memset(map, 0xFF, sizeof(WORD_TYPE) * nwords);

    /* mark any leftover bits at the end in use(0) */
    if (nbits != nwords * WORD_BITS) {
        uint32_t ix = nwords - 1, overbits = nbits - ix * WORD_BITS;

        assert(nbits / WORD_BITS == ix);
        assert(overbits > 0 && overbits < WORD_BITS);

        for (; overbits < WORD_BITS; overbits ++) {
            bitmap->map[ix] ^= (1 << overbits);
        }
    }
    return bitmap;
}

// bitmap_alloc - locate a cleared bit, set it, and return its index.
int
bitmap_alloc(struct bitmap *bitmap, uint32_t *index_store) {
    WORD_TYPE *map = bitmap->map;
    uint32_t ix, offset, nwords = bitmap->nwords;
    for (ix = 0; ix < nwords; ix ++) {
        if (map[ix] != 0) {
            for (offset = 0; offset < WORD_BITS; offset ++) {
                WORD_TYPE mask = (1 << offset);
                if (map[ix] & mask) {
                    map[ix] ^= mask;
                    *index_store = ix * WORD_BITS + offset;
                    return 0;
                }
            }
            assert(0);
        }
    }
    return -E_NO_MEM;
}

// bitmap_translate - according index, get the related word and mask
static void
bitmap_translate(struct bitmap *bitmap, uint32_t index, WORD_TYPE **word, WORD_TYPE *mask) {
    assert(index < bitmap->nbits);
    uint32_t ix = index / WORD_BITS, offset = index % WORD_BITS;
    *word = bitmap->map + ix;
    *mask = (1 << offset);
}

// bitmap_test - according index, get the related value (0 OR 1) in the bitmap
bool
bitmap_test(struct bitmap *bitmap, uint32_t index) {
    WORD_TYPE *word, mask;
    bitmap_translate(bitmap, index, &word, &mask);
    return (*word & mask);
}

// bitmap_free - according index, set related bit to 1
void
bitmap_free(struct bitmap *bitmap, uint32_t index) {
    WORD_TYPE *word, mask;
    bitmap_translate(bitmap, index, &word, &mask);
    assert(!(*word & mask));
    *word |= mask;
}

// bitmap_destroy - free memory contains bitmap
void
bitmap_destroy(struct bitmap *bitmap) {
    kfree(bitmap->map);
    kfree(bitmap);
}

// bitmap_getdata - return bitmap->map, return the length of bits to len_store
void *
bitmap_getdata(struct bitmap *bitmap, size_t *len_store) {
    if (len_store != NULL) {
        *len_store = sizeof(WORD_TYPE) * bitmap->nwords;
    }
    return bitmap->map;
}

