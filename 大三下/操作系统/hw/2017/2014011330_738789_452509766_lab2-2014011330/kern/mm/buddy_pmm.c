#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_pmm.h>

/* Buddy physical memory manager.
 * Challenge for Lab2: 2014011330
 */
// Should not be more than 32.
#define BUDDY_MAX_DEPTH 30
static unsigned int* buddy_longest;
static unsigned int buddy_max_pages;
static struct Page* buddy_allocatable_base;

#define IS_POWER_OF_2(x) (((x) & ((x) - 1)) == 0)
#define LEFT_LEAF(index) ((index) * 2 + 1)
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) ( ((index) + 1) / 2 - 1)
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static unsigned int
buddy_find_first_zero(unsigned int bit_array) {
    unsigned pos = 0;
    while (bit_array >>= 1) ++ pos;
    return pos;
}

static struct Page*
buddy_node_index_to_page(unsigned int index, unsigned int node_size) {
	return buddy_allocatable_base + ((index + 1) * node_size - buddy_max_pages);
}

static void
buddy_init(void) {
	// do nothing.
}

static void
buddy_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	// Calculate maximum manageable memory zone
	unsigned int max_pages = 1;
	for (unsigned int i = 1; i < BUDDY_MAX_DEPTH; ++ i) {
		// Should consider the page for storing 'longest' array.
		if (max_pages + max_pages / 512 >= n) {
			max_pages /= 2;
			break;
		}
		max_pages *= 2;
	}
	unsigned int longest_array_pages = max_pages / 512 + 1;
	cprintf("BUDDY: Maximum manageable pages = %d, pages for storing longest = %d\n",
			max_pages, longest_array_pages);
	buddy_longest = (unsigned int*)KADDR(page2pa(base));
	buddy_max_pages = max_pages;

	unsigned int node_size = max_pages * 2;
	for (unsigned int i = 0; i < 2 * max_pages - 1; ++ i) {
		if (IS_POWER_OF_2(i + 1)) node_size /= 2;
		buddy_longest[i] = node_size;
	}

	for (int i = 0; i < longest_array_pages; ++ i) {
		struct Page *p = base + i;
		SetPageReserved(p);
	}

	struct Page *p = base + longest_array_pages;
	buddy_allocatable_base = p;
	for (; p != base + n; p ++) {
		assert(PageReserved(p));
		ClearPageReserved(p);
		SetPageProperty(p);
		set_page_ref(p, 0);
	}
}

static size_t
buddy_fix_size(size_t before) {
	unsigned int ffz = buddy_find_first_zero(before) + 1;
	return (1 << ffz);
}

static struct Page *
buddy_alloc_pages(size_t n) {
	assert(n > 0);
	if (!IS_POWER_OF_2(n)) {
		n = buddy_fix_size(n);
	}
	if (n > buddy_longest[0]) {
		return NULL;
	}

	// Find the top node for allocation.
	// Starting from root
	unsigned int index = 0;
	// The size of current node
	unsigned int node_size;

	// go from the root and find the most suitable position
	for (node_size = buddy_max_pages; node_size != n; node_size /= 2) {
		if (buddy_longest[LEFT_LEAF(index)] >= n) {
			index = LEFT_LEAF(index);
		} else {
			index = RIGHT_LEAF(index);
		}
	}

	// Allocate all pages under this node.
	buddy_longest[index] = 0;
	struct Page* new_page = buddy_node_index_to_page(index, node_size);
	for (struct Page* p = new_page; p != (new_page + node_size); ++ p) {
		// Set new allocated page ref = 0;
		set_page_ref(p, 0);
		// Set property = not free.
		ClearPageProperty(p);
	}

	// Update parent longest value because this node is used.
	while (index) {
		index = PARENT(index);
		buddy_longest[index] =
				MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
	}
	return new_page;
}

static void
buddy_free_pages(struct Page *base, size_t n) {
	assert(n > 0);
	// Find the base-correponded node and its size;
	unsigned int index = (unsigned int)(base - buddy_allocatable_base) + buddy_max_pages - 1;
	unsigned int node_size = 1;

	// Starting from the leaf and find the first (lowest) node has longest = 0;
	while (buddy_longest[index] != 0) {
		node_size *= 2;
		// cannot find the corresponding node for the base.
		assert(index != 0);
		index = PARENT(index);
	}

	// NOTICE: Be careful when releasing memory if the following line is commented.
	// assert(node_size == n);

	// Free the pages.
	struct Page *p = base;
	for (; p != base + n; p ++) {
	    assert(!PageReserved(p) && !PageProperty(p));
	    SetPageProperty(p);
	    set_page_ref(p, 0);
	}

	// Update longest.
	buddy_longest[index] = node_size;
	while (index != 0) {
		// Starting from this node, try to merge all the way to parent.
		// The condition for merging is (left_child + right_child = node_size)
		index = PARENT(index);
		node_size *= 2;
		unsigned int left_longest = buddy_longest[LEFT_LEAF(index)];
		unsigned int right_longest = buddy_longest[RIGHT_LEAF(index)];

		if (left_longest + right_longest == node_size) {
			buddy_longest[index] = node_size;
		} else {
			// update because the child is updated.
			buddy_longest[index] = MAX(left_longest, right_longest);
		}
	}
}

static size_t
buddy_nr_free_pages(void) {
    return buddy_longest[0];
}

static void
buddy_check(void) {
	int all_pages = nr_free_pages();
	struct Page* p0, *p1, *p2, *p3, *p4;
	assert(alloc_pages(all_pages + 1) == NULL);

	p0 = alloc_pages(1);
	assert(p0 != NULL);
	p1 = alloc_pages(2);
	assert(p1 == p0 + 2);
	assert(!PageReserved(p0) && !PageReserved(p1));
	assert(!PageProperty(p0) && !PageProperty(p1));

	p2 = alloc_pages(1);
	assert(p2 == p0 + 1);

	p3 = alloc_pages(2);
	assert(p3 == p0 + 4);
	assert(!PageProperty(p3) && !PageProperty(p3 + 1) && PageProperty(p3 + 2));

	free_pages(p1, 2);
	assert(PageProperty(p1) && PageProperty(p1 + 1));
	assert(p1->ref == 0);

	free_pages(p0, 1);
	free_pages(p2, 1);

	p4 = alloc_pages(2);
	assert(p4 == p0);
	free_pages(p4, 2);
	assert((*(p4 + 1)).ref == 0);

	assert(nr_free_pages() == all_pages / 2);

	free_pages(p3, 2);

	p1 = alloc_pages(33);
	free_pages(p1, 64);
}

const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};

