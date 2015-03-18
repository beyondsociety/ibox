# You will need a cross-compiler thats targeted for elf to compile and link the source code
TARGET_ARCH  = $(HOME)/opt/cross/bin

CC           = clang
#CC          = $(TARGET_ARCH)/i686-elf-gcc 

CFLAGS       = -m32 -O2 -ffreestanding -std=gnu99 $(WARNINGS) $(INCLUDES)

LD           = $(TARGET_ARCH)/i686-elf-ld 
LDFLAGS      = -Map info.map -nostdlib -T linker.ld

ASM          = nasm  
ASMFLAGS     = -f elf

INCLUDES     = -I ./include

WARNINGS     = -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
               -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
               -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
               -Wuninitialized -Wstrict-prototypes -Wconversion



