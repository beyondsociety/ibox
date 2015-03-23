# You will need a cross-compiler thats targeted for elf to compile and link the source code
#TARGET_ARCH  = $(HOME)/opt/cross/bin

CC           = clang
#CC          = $(TARGET_ARCH)/i686-elf-gcc 

CFLAGS       = -m32 -O2 -ffreestanding -std=gnu11 $(WARNINGS) $(INCLUDES)

#LD          = $(TARGET_ARCH)/i686-elf-ld 
LDFLAGS      = -nostdlib -Wl,-T,linker.ld -Wl,-m,elf_i386 -Wl,-Map,boot.map 

ASM          = yasm  
ASMFLAGS     = -f elf32

INCLUDES     = -I ./include

WARNINGS     = -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
               -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
               -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
               -Wuninitialized -Wstrict-prototypes -Wconversion 



