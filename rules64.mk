# You will need a cross-compiler thats targeted for elf to compile and link the source code
TARGET_ARCH  = $(HOME)/opt/cross64/bin

CC           = clang
#CC          = $(TARGET_ARCH)/x86_64-elf-gcc

#CFLAGS      = -m64 -O2 -ffreestanding -std=gnu99 -nostdlib -mno-red-zone -Wl,-Map,info.map \
#              -mcmodel=large -mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow \
#              -z max-page-size=0x1000 -T linker.ld -lgcc $(WARNINGS) $(INCLUDES)
               
CFLAGS       = -m64 -O2 -ffreestanding -std=gnu99 -mno-red-zone $(WARNINGS) $(INCLUDES) 

LD           = $(TARGET_ARCH)/x86_64-elf-ld 
LDFLAGS     = -z max-page-size=0x1000 -Map info.map -nostdlib -T linker.ld 

ASM          = nasm  
ASMFLAGS    = elf64

INCLUDES     = -I ./include

WARNINGS    = -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
              -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
              -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
              -Wuninitialized -Wstrict-prototypes -Wno-conversion 



