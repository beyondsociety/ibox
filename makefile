include ./rules32.mk
#include ./rules64.mk

SRCDIRS   = src
INCDIRS   = include 

HEADERS   = $(foreach DIR, $(INCDIRS), $(wildcard $(DIR)/*.h))
SOURCES   = $(foreach DIR, $(SRCDIRS), $(wildcard $(DIR)/*.s $(DIR)/*.c))
OBJECTS   = $(foreach OBJECT, $(patsubst %.s, %.o, $(patsubst %.c, %.o, $(patsubst %.cpp, %.o, $(SOURCES)))), $(OBJECT))

TARGET    = kernel.elf
ISO       = boot.iso

all : $(ISO)

$(ISO) : $(TARGET)	
	cp $(TARGET) ~/Desktop/ibox/iso/boot/
	mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
	-boot-info-table -input-charset utf8 -quiet -o boot.iso iso 
	
$(TARGET) : $(OBJECTS)  
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

%.o : %.c
	$(CC) $(CFLAGS) $< -o $@ 

%.o : %.s
	$(AS) $< -o $@  

qemu : 
	qemu-system-x86_64 -vga std -cdrom $(ISO)

bochs : 
	bochs -f .bochsrc -q

clean :
	rm -f $(TARGET)
	rm -f $(ISO)
	rm -f $(OBJECTS)
	rm -f bochsout.txt
	rm -f info.map
	
.PHONY : clean qemu bochs
