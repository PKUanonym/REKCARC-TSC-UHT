ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif
CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = SimpleOS.o

export	CROSS_COMPILE

# ********************
# Rules of Compilation
# ********************

all: SimpleOS.om SimpleOS.bin SimpleOS.asm Image.bin

%.o: %.S
	$(CC) -mips32 $< -o $@
SimpleOS.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@
SimpleOS.bin: SimpleOS.om
	$(OBJCOPY) -O binary $<  $@
SimpleOS.asm: SimpleOS.om
	$(OBJDUMP) -D $< > $@
Image.bin: SimpleOS.bin
	./BinMerge.exe -f $< -o $@
clean:
	rm -f *.o *.om SimpleOS.bin *.data *.mif *.asm
