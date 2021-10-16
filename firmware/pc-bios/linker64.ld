OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(start)

KERNEL_LMA = 1M;
SECTIONS
{
	/* Load kernel at 1MB */
	. = KERNEL_LMA;

	.multiboot :
  {
	 	/* Ensure the multiboot header is at the beginning */
  	KEEP(*(.multiboot))
  }

	.multiboot2 :
  {
		/* Ensure the multiboot2 header is at the beginning */
  	KEEP(*(.multiboot2))
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
		*(.rodata*)
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

  /DISCARD/ : { *(.note.gnu.build-id) }
  /DISCARD/ : { *(.interp) }

}
