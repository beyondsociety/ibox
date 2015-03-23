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
	mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
	-boot-info-table -input-charset utf8 -quiet -o boot.iso iso 
	
$(KERNEL): $(AOBJECTS) $(COBJECTS)  
	$(CC) $(LDFLAGS) $(AOBJECTS) $(COBJECTS) -o $@

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) 

%.o: %.s
	$(ASM) $< -o $@ $(ASMFLAGS) 

qemu: 
	qemu-system-x86_64 -vga std -cdrom $(ISO)

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
