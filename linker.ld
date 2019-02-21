OUTPUT_FORMAT(elf32-i386) 
OUTPUT_ARCH(i386) 
ENTRY(start)

SECTIONS
{
	/* Load kernel at 1MB */
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
	}
}

