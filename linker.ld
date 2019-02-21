OUTPUT_FORMAT(elf32-i386) 
<<<<<<< HEAD
OUTPUT_ARCH(i386) 
=======
OUTPUT_ARCH(i386)
>>>>>>> 318e2ce31b05692bd1567d580bf24fcf587b11db
ENTRY(start)

SECTIONS
{
	/* Load kernel at 1MB */
<<<<<<< HEAD
	. = 1M;

	/* Multiboot Header */
	.multiboot :
	{
		*(.multiboot)
	}
		
	/* Text section */
	.text :     
	{    
		*(.text)
	}
         
	/* Read-only data */
	.rodata :    
	{
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data :  
	{ 
		*(.data)
	}
	
	/* Read-write data (uninitialized) and stack */
	.bss : 
	{		 
		*(COMMON)
		*(.bss)
	}
	
	.note.gnu.build-id :
	{
		*(.note.gnu.build-id)
=======
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
>>>>>>> 318e2ce31b05692bd1567d580bf24fcf587b11db
	}
}

