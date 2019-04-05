
# CFLAGS += -DET_DEBUG -DDEBUG

LIB	= ucos.o

OBJS	= os_flag.o os_mbox.o os_mem.o os_mutex.o os_q.o os_sem.o os_task.o os_time.o os_tmr.o os_dbg_r.o os_core.o
all:	$(LIB)

$(LIB):	$(OBJS) $(SOBJS)
	$(LD) -r -o $@ $(OBJS) $(SOBJS)

#########################################################################

.depend:	Makefile $(OBJS:.o=.c)
		$(CC) -M $(CFLAGS) $(OBJS:.o=.c) > $@

sinclude .depend

#########################################################################
