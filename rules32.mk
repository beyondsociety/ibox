# 4/1/15 - the different CFLAGS/LDFLAGS/LIBS seems like a hack, need to create a build script for this

# You will need a cross-compiler thats targeted for elf to compile and link the source code
TARGET_LOCATION    	= $(HOME)/opt/cross/bin
TARGET_ARCH  	= i686-elf

CC        	= clang
#CC       	= $(TARGET_LOCATION)/$(TARGET_ARCH)-gcc 		

# CFLAGS For Clang
CFLAGS             	= -m32 -c -O2 -ffreestanding -std=gnu99 $(WARNINGS) $(INCLUDES) 

# CFLAGS for cross-compiled Gcc
#CFLAGS    	= -c -O2 -ffreestanding -std=gnu99 $(WARNINGS) $(INCLUDES)      

# LDFLAGS for Clang
LDFLAGS   	= -nostdlib -Wl,-T,linker.ld -Wl,-m,elf_i386 -Wl,-Map,info.map $(LIBS)

# LDFLAGS for Cross-compiled Gcc
#LDFLAGS  	= -nostdlib -Wl,-Map,info.map $(LIBS)				

AS        	= $(TARGET_LOCATION)/$(TARGET_ARCH)-as 
INCLUDES           	= $(foreach INCDIR, $(INCDIRS), -I./$(INCDIR)) 

#LIBS for Clang
LIBS               	= -Wl,-L,libgcc

# LIBS for Cross-compiled Gcc
#LIBS              	= -lgcc

WARNINGS  	= -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
                       -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
                       -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
                       -Wuninitialized -Wstrict-prototypes -Wconversion


