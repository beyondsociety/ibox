OUTPUT_FORMAT(elf32-i386) 
OUTPUT_ARCH(i386)
ENTRY(start)

SECTIONS
{
	/* Load kernel at 1MB */
    	. = 1M;

    	/* Multiboot header and Text section */
	.text :  
    	{
        	kernel_code = .;
                *(.multiboot)
		*(.text)
	}

    	/* Read-only data */
	.rodata :  
	{
	    	kernel_rodata = .;
		*(.rodata)
	}

    	/* Read-write data (initialized) */
	.data :  
	{
	    	kernel_data = .;
		*(.data)
	}
	
   	/* Read-write data (uninitialized) and stack */
	.bss :  
	{
	    	kernel_bss = .;		 
	    	*(COMMON)
		*(.bss)
                *(.bootstrap_stack)
	}

    	kernel_end = .;

	/DISCARD/ :
	{
		*(.comment)		
		*(.eh_frame)
	}
}

