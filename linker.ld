OUTPUT_FORMAT(elf32-i386) 
OUTPUT_ARCH(i386)
ENTRY(start)

SECTIONS
{
	/* Load kernel at 1MB */
    	. = 1M;

        /* Multiboot header */
        .multiboot :
	{
		*(.multiboot)
	}

    	/* Text section */
	.text BLOCK(4k) : ALIGN(4k) 
    	{
        	kernel_code = .;
		*(.text)
	}

    	/* Read-only data */
	.rodata BLOCK(4k) : ALIGN(4k) 
	{
	    	kernel_rodata = .;
		*(.rodata)
	}

    	/* Read-write data (initialized) */
	.data BLOCK(4k) : ALIGN(4k) 
	{
	    	kernel_data = .;
		*(.data)
	}
	
   	/* Read-write data (uninitialized) and stack */
	.bss BLOCK(4k) : ALIGN(4k) 
	{
	    	kernel_bss = .;		 
	    	*(COMMON)
		*(.bss)
	}

    	kernel_end = .;

	/DISCARD/ :
	{
		*(.comment)		
		*(.eh_frame)
	}
}

