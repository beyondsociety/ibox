OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386:i386)
ENTRY(start)

KERNEL_LMA = 1M;
SECTIONS
{
	/* Load kernel at 1MB */
	. = KERNEL_LMA;

	/*.boot :*/
  /*{*/
  	/* Ensure the multiboot header is at the beginning */
  	/*KEEP(*(.multiboot))*/

		/* Ensure the multiboot2 header is at the beginning */
  	/*KEEP(*(.multiboot2))*/
  /*}*/

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
