# 4/1/15 - the different CFLAGS/LDFLAGS/LIBS seems like a hack, need to create a build script for this

# You will need a cross-compiler thats targeted for elf to compile and link the source code
<<<<<<< HEAD
TARGET_LOCATION  = $(HOME)/opt/cross64/bin
TARGET_ARCH      = x86_64-elf

CC               = clang
#CC              = $(TARGET_LOCATION)/$(TARGET_ARCH)-gcc

# CFLAGS for Clang
#CFLAGS          = -m64 -O2 -ffreestanding -std=gnu99 -mcmodel=large -mno-red-zone -mno-mmx -mno-sse \
#                  -mno-sse2 -mno-sse3 -mno-3dnow $(WARNINGS) $(INCLUDES)
               
# CFLAGS for Cross-compiled Gcc
#CFLAGS          = -O2 -ffreestanding -std=gnu99 -mcmodel=large -mno-red-zone -mno-mmx -mno-sse \
#		   -mno-sse2 -mno-sse3 -mno-3dnow $(WARNINGS) $(INCLUDES) 

# LDFLAGS for Clang
LDFLAGS          = -zmax-page-size=0x1000 -Wl,-Map,info. map -nostdlib -Wl,-T,linker.ld $(LIBS)

# LDFLAGS for Cross-compiled Gcc
#LDFLAGS         = -z max-page-size=0x1000 -Map info.map -nostdlib -T linker.ld $(LIBS) 

ASM              = $(TARGET_LOCATION)/$(TARGET_ARCH)-as  
INCLUDES         = $(foreach INCDIR, $(INCDIRS), -I./$(INCDIR)) 

# LIBS for Clang
LIBS             = -Wl,-L,libgcc

# LIBS for Cross-compiled Gcc
#LIBS            = -lgcc

WARNINGS         = -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
                   -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
                   -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
                   -Wuninitialized -Wstrict-prototypes -Wconversion 
=======
TARGET_LOCATION = $(HOME)/opt/cross64/bin 
TARGET_ARCH  	 = x86_64-elf 

CC              = clang
#CC             = $(TARGET_LOCATION)/$(TARGET_ARCH)-gcc

#CFLAGS         = -m64 -O2 -ffreestanding -std=gnu99 -nostdlib -mno-red-zone -Wl,-Map,info.map \
#                 -mcmodel=large -mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow \
#                 -z max-page-size=0x1000 -Wl,-T,linker.ld -lgcc $(WARNINGS) $(INCLUDES)
               
CFLAGS          = -m64 -O2 -ffreestanding -std=gnu99 -mno-red-zone $(WARNINGS) $(INCLUDES) 

LD              = $(TARGET_LOCATION)/$(TARGET_ARCH)-ld 
LDFLAGS         = -z max-page-size=0x1000 -Map info.map -nostdlib -T linker.ld 

ASM             = nasm  
ASMFLAGS        = elf64

INCLUDES        = -I ./include

WARNINGS        = -Wall -Wextra -Werror -pedantic -Wshadow -Wpointer-arith -Wcast-align \
                  -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
                  -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
                  -Wuninitialized -Wstrict-prototypes -Wno-conversion 
>>>>>>> d512186d7ded4668bd471da12eb952300562b8c6



