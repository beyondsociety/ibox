OUTPUT_FORMAT(elf64-x86-64)
/*OUTPUT_ARCH(i386:x86_64)*/
ENTRY(start)

SECTIONS
{
	/* Load kernel at 1MB */
	. = 1M;

	/* Multiboot1 Header */
	/*.multiboot :*/
	/*{*/
	/*	*(.multiboot)*/
	/*}*/

	/* Multiboot2 Header */
	/*.multiboot2 :*/
	/*{*/
	/*	*(.multiboot2)*/
	/*}*/

	/* Text section */
	.text :
	{
		*(.multiboot)
		*(.multiboot2)
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
