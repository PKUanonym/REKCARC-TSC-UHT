ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif
CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = BootLoader.o

export	CROSS_COMPILE

# ********************
# Rules of Compilation
# ********************

all: BootLoader.om BootLoader.bin BootLoader.asm

%.o: %.S
	$(CC) -mips32 $< -o $@
BootLoader.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@
BootLoader.bin: BootLoader.om
	$(OBJCOPY) -O binary $<  $@
BootLoader.asm: BootLoader.om
	$(OBJDUMP) -D $< > $@
clean:
	rm -f *.o *.om *.bin *.data *.mif *.asm
