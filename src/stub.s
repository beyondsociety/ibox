# Multiboot Header 
.set MULTIBOOT_PAGE_ALIGN,      1 << 0   # Align loaded modules on page boundaries
.set MULTIBOOT_MEMORY_INFO,     1 << 1   # Provide memory map
.set MULTIBOOT_VIDEO,           1 << 2   # Video Information

.set MULTIBOOT_HEADER_MAGIC,    0x1badb002  # 'magic number' lets bootloader find the header
.set MULTIBOOT_HEADER_FLAGS,    MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO # Multiboot flags  
.set MULTIBOOT_HEADER_CHECKSUM, - (MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS) # Multiboot Checksum 

.section .multiboot
.align 4
  .long MULTIBOOT_HEADER_MAGIC
  .long MULTIBOOT_HEADER_FLAGS
  .long MULTIBOOT_HEADER_CHECKSUM
  .long 0, 0, 0, 0, 0                # Aout kluge info - header_addr, load_addr, load_end_addr, bss_end_addr, entry_addr 
  .long 1                            # 0 = linear graphics mode, 1 = EGA-standard text mode
  .long 1024, 768, 32                # Width, Height, Depth

.section .text
.global start
.type start, @function
start:                        
    movl $stack_top, %esp

    pushl %eax
    pushl %ebx 
         
    .extern sys_multiboot_info
    movl $sys_multiboot_info, %ebx

    .extern kernel_init
    call kernel_init
    
    cli
    hlt
    
.hang:
    jmp .hang
    
# Set the size of the _start symbol to the current location '.' minus its start.
# This is useful when debugging or when you implement call tracing.
.size start, . - start

.section .bootstrap_stack, "aw", @nobits	# .BSS section 
.align 4
stack_bottom:
  .skip 16384 # 16 KB 					
stack_top:
