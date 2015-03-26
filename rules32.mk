# You will need a cross-compiler thats targeted for elf to compile and link the source code
TARGET_LOCATION = $(HOME)/opt/cross/bin
TARGET_ARCH  	= i686-elf

CC        	= clang
#CC       	= $(TARGET_LOCATION)/$(TARGET_ARCH)-gcc 		

CFLAGS 		= -m32 -c -O2 -ffreestanding -std=gnu99 $(WARNINGS) $(foreach INCDIR, $(INCDIRS), -I./$(INCDIR)) 
#CFLAGS    	= -c -O2 -ffreestanding -std=gnu99 $(WARNINGS) $(INCLUDES)

LDFLAGS   	= -nostdlib -Wl,-T,linker.ld -Wl,-m,elf_i386 -Wl,-Map,info.map  # For clang
#LDFLAGS  	= -nostdlib -Wl,-Map,info.map					# For cross-comiled gcc

AS        	= $(TARGET_LOCATION)/$(TARGET_ARCH)-as 

INCLUDES        = $(foreach INCDIR, $(INCDIRS), -I./$(INCDIR)) 

WARNINGS  	= -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
               	  -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
                  -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
                  -Wuninitialized -Wstrict-prototypes -Wno-conversion 


