OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386:i386)
ENTRY(start)

KERNEL_LMA = 1M;

/* Define the program headers we want so the bootloader gives us the right */
/* MMU permissions; this also allows us to exert more control over the linking */
/* process. */
/*PHDRS
{
  multiboot PT_LOAD FLAGS(6);
  text PT_LOAD FLAGS(5);
  data PT_LOAD FLAGS(6);
  bss PT_LOAD FLAGS(6);
}*/

SECTIONS
{
	/* Load kernel at 1MB */
	. = KERNEL_LMA;

	/* .multiboot2 :
   * { */
		/* Ensure the multiboot2 header is at the beginning */
  	/* *KEEP(*(.multiboot2)) */
  /* } */

  /* First put the multiboot header, as it is required to be put very early
	 * in the image or the bootloader won't recognize the file format.
	 * Next we'll put the .text section. */	
  .multiboot BLOCK(4K) : ALIGN(4K) 
	{
		*(.multiboot) 
	} 

  .text BLOCK(4K) : ALIGN(4K) 
  {
    *(.text)
  } 

  /* Read-only data. */
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	} 

	/* Read-write data (initialized) */
	.data BLOCK(4K) : ALIGN(4K) 
	{
		*(.data)
	} 

  /* Read-write data (uninitialized) and stack */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	} 

	/* The compiler may produce other sections, by default it will put them in
	   a segment with the same name. Simply add stuff here as needed. */
  /* /DISCARD/ : { *(.note.gnu.build-id) }
  /DISCARD/ : { *(.interp) } */

}
