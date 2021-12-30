.section .data
	#This points to the beginning of the memory
heap_begin:
.long 0
	#This points to one location past the memory we are managing
current_break:
.long 0

	#size of space for memory region header
.equ HEADER_SIZE, 8
	#Location of the "available" flag in the header
.equ HDR_AVAIL_OFFSET, 0
	#Location of the size field in the header

.equ HDR_SIZE_OFFSET, 4
.equ UNAVAILABLE, 0
.equ AVAILABLE, 1
.equ SYS_BRK, 45	#system call number for brk
.equ LINUX_SYSCALL, 0x80

# alloc.s
.section .text

.globl allocate_init
.type allocate_init,@function
allocate_init:
	pushl %ebp
	movl %esp, %ebp

	#If the brk system call is called with 0 in %ebx, it
	#returns the first invalid address
	movl $SYS_BRK, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
	movl %eax, current_break 	#%eax now has the first invalid address
	movl %eax, heap_begin

	movl %ebp, %esp				#exit the function
	popl %ebp
	ret

.globl allocate
.type allocate, @function
.equ ST_MEM_SIZE, 8		#stack position of the memory size to allocate
allocate:
	pushl %ebp
	movl %esp, %ebp
	movl ST_MEM_SIZE(%ebp), %ecx		#%ecx will hold the size
	
	#we are looking for (which is the first and only parameter)
	movl heap_begin, %eax		#%eax will hold the search location
	movl current_break, %ebx	#%ebx will hold the current break

loop_begin:
	cmpl %ebx, %eax		#we iterate through memory regions
	je move_break		#need more memory if these are equal
	
	#grab the size of this memory
	movl HDR_SIZE_OFFSET(%eax), %edx
	cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	je next_location 		#If unavailable, go to the next
	cmpl %edx, %ecx			#If available, check the size
	jle allocate_here 		#big enough, go to allocate_here
	

next_location:
	addl $HEADER_SIZE, %eax
	addl %edx, %eax			#The total size of the memory
	Jmp loop_begin 			#go look at the next location

allocate_here:
	#if we’ve made it here, that means that the region header of the
	#region to allocate is in %eax, mark space as unavailable
	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	addl $HEADER_SIZE, %eax		#move %eax to the usable memory
	
	movl %ebp, %esp
	popl %ebp
	ret

move_break:
	addl $HEADER_SIZE, %ebx		#add space for the headers structure
	addl %ecx, %ebx				#add space to the break for the data

	pushl %eax					#save needed registers
	movl $SYS_BRK, %eax			#reset the break
	int $LINUX_SYSCALL
	popl %eax					#no error check?

	#set this memory as unavailable, since we’re about to give it away
	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl %ecx, HDR_SIZE_OFFSET(%eax) 		#set the size of the memory
	addl $HEADER_SIZE, %eax					#move %eax to the actual start of
											#usable memory.
	movl %ebx, current_break				#save the new break
	
	movl %ebp, %esp
	popl %ebp
	ret

.globl deallocate
.type deallocate,@function
.equ ST_MEMORY_SEG, 4

deallocate:
	movl ST_MEMORY_SEG(%esp), %eax
		#get the pointer to the real beginning of the memory
	subl $HEADER_SIZE, %eax
		#mark it as available
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	ret
