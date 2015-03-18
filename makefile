# 3/16/15 - Todo: clean up code, added config files for 32/64 bit compile options  
include ./rules32.mk
#include ./rules64.mk

CSOURCES  = $(wildcard src/*.c)
COBJECTS  = $(CSOURCES:%.c=%.o)

ASOURCES  = $(wildcard src/*.s)
AOBJECTS  = $(ASOURCES:%.s=%.o)

KERNEL    = kernel.elf
ISO       = boot.iso

all: $(ISO)

$(ISO): $(KERNEL)	
	cp $(KERNEL) ~/Desktop/ibox/iso/boot/
	grub-mkrescue -o boot.iso iso
	
$(KERNEL): $(ASOURCES) $(AOBJECTS) $(CSOURCES) $(COBJECTS) 
	$(LD) $(LDFLAGS) $(AOBJECTS) $(COBJECTS) -o $@
	#$(CC) $(CFLAGS) -o $@

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) 

%.o: %.s
	$(ASM) $(ASMFLAGS) $< -o $@ 

qemu: 
	qemu-system-x86_32 -vga std -cdrom $(ISO)

bochs: 
	bochs -f .bochsrc -q

clean:
	rm -f $(KERNEL)
	rm -f $(ISO)
	rm -f $(COBJECTS)
	rm -f $(AOBJECTS)
	rm -f bochsout.txt
	rm -f info.map
	
.PHONY: clean qemu bochs
