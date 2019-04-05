#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_clock.h>
#include <list.h>

/*
 * Prerequisites for Extended clock algorithm: The bits in PTE will be automatically set by CPU.
 *
 * (1) The pra_list is the clock list: When there are page faults, we should check this list circularly.
 */


list_entry_t clock_list_head;
list_entry_t* current_clock_pointer;

/*
 * (2) _clock_init_mm: Build list.
 * The sm_priv is used for circular clock pointer
 */
static int
_clock_init_mm(struct mm_struct *mm)
{     
     list_init(&clock_list_head);
     mm->sm_priv = &clock_list_head;
     current_clock_pointer = &clock_list_head;
     return 0;
}
/*
 * (3)_clock_map_swappable: Just add the Page to the clock circle.
 * CPU will automatically update PTE based on memory access.
 */
static int
_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    list_add_before(current_clock_pointer, entry);
    // current_clock_pointer = entry;
    return 0;
}

/*
 *  (4)_clock_swap_out_victim:
 *
 *  	Check the list circularly, get the pte of each Page and modify them,
 *  Loop until find a page whose bits are both 0. Then return the page.
 */
static int
_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
     list_entry_t *head = (list_entry_t*) mm->sm_priv;
     assert(head->next != head);
     pte_t* current_pte = NULL;
     struct Page* current_page = NULL;
     if (current_clock_pointer == head) {
    	 current_clock_pointer = current_clock_pointer->next;
     }
     while (1) {
    	 // Get current pointer's PTE.
    	 // If it is 00, then swap, else change and move next.
    	 current_page = le2page(current_clock_pointer, pra_page_link);
		 current_pte = get_pte(mm->pgdir, current_page->pra_vaddr, 0);
		 assert(current_pte != NULL);
		 int accessed = (((*current_pte) & PTE_A) != 0);
		 int dirty = (((*current_pte) & PTE_D) != 0);
		 cprintf("A = %d, D = %d, %08x, %08x\n", accessed, dirty, current_pte, *(current_pte));
		 if (!accessed && !dirty) {
			 break;
		 }
		 // Modify bits.
		 (*current_pte) = (*current_pte) & (~PTE_A);
		 if (accessed + dirty == 1) {
			 // all should be zero
			 (*current_pte) = (*current_pte) & (~PTE_D);
		 }
    	 // Go to next list (remember to skip the head)
    	 do {
			 current_clock_pointer = current_clock_pointer->next;
		 }
    	 while (current_clock_pointer == head);
     }
     *ptr_page = current_page;
     current_clock_pointer = current_clock_pointer->next;
     list_del(current_clock_pointer->prev);
     return 0;
}

static void
mark_read(int page_id) {
	uintptr_t la = (page_id << 12);
	pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
	assert(pt_entry != NULL);
	(*pt_entry) = (*pt_entry) | (PTE_A);
}

static void
mark_write(int page_id) {
	uintptr_t la = (page_id << 12);
	pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
	assert(pt_entry != NULL);
	(*pt_entry) = (*pt_entry) | (PTE_A);
	(*pt_entry) = (*pt_entry) | (PTE_D);
}

static int
_clock_check_swap(void) {
	// Clear all A/D bytes in Page a, b, c, d, e
	for (int i = 1; i < 6; ++ i) {
		uintptr_t la = (i << 12);
		pte_t* pt_entry = get_pte(boot_pgdir, la, 0);
		assert(pt_entry != NULL);
		(*pt_entry) = (*pt_entry) & (~PTE_A);
		(*pt_entry) = (*pt_entry) & (~PTE_D);
	}
	unsigned char temp;

	cprintf("read Virt Page c in clock_check_swap\n");
    temp += *(unsigned char *)0x3000;
    mark_read(3);
    assert(pgfault_num==4);

    cprintf("write Virt Page a in clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    mark_write(1);
    assert(pgfault_num==4);

    cprintf("read Virt Page d in fifo_check_swap\n");
    temp += *(unsigned char *)0x4000;
    mark_read(4);
    assert(pgfault_num==4);

    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    mark_write(2);
    assert(pgfault_num==4);

    cprintf("read Virt Page e in fifo_check_swap\n");
    temp += *(unsigned char *)0x5000;
    mark_read(5);
    assert(pgfault_num==5);

    cprintf("read Virt Page b in fifo_check_swap\n");
    temp += *(unsigned char *)0x2000;
    mark_read(2);
    assert(pgfault_num==5);

    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    mark_write(1);
    assert(pgfault_num==5);

    cprintf("read Virt Page b in fifo_check_swap\n");
    temp += *(unsigned char *)0x2000;
    mark_read(2);
    assert(pgfault_num==5);

    cprintf("read Virt Page c in fifo_check_swap\n");
    temp += *(unsigned char *)0x3000;
    mark_read(3);
    assert(pgfault_num==6);

    cprintf("read Virt Page d in fifo_check_swap\n");
    temp += *(unsigned char *)0x4000;
    mark_read(4);
    assert(pgfault_num==7);

    return 0;
}


static int
_clock_init(void)
{
    return 0;
}

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_clock =
{
     .name            = "extended clock swap manager",
     .init            = &_clock_init,
     .init_mm         = &_clock_init_mm,
     .tick_event      = &_clock_tick_event,
     .map_swappable   = &_clock_map_swappable,
     .set_unswappable = &_clock_set_unswappable,
     .swap_out_victim = &_clock_swap_out_victim,
     .check_swap      = &_clock_check_swap,
};
