#include <bga.h>
#include <kernel.h>
#include <io.h>
#include <lfbvideo.h>
#include <multiboot.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <terminal.h>

/* Perform some preloading stuff */
//void kernel_init(multiboot_info_t *mbi, uint32_t magic)
void kernel_init(uint32_t magic, uint32_t address)
{
  multiboot_info_t *mbi;

  /* Set MBI to the address of the Multiboot information structure. */
  mbi = (multiboot_info_t *) address;

	/* Clear the screen */
	clear_screen();

	/* Make sure we're booted by a multiboot loader */
	if(magic != MULTIBOOT_BOOTLOADER_MAGIC)
	{
    printk("Invalid magic number: 0x%x\n", (unsigned) magic);
    printk("  no multiboot-compliant bootloader found, halting...");
    hlt();  /* Return */
  }
  else
  {
    printk("magic number: 0x%x\n", (uint32_t) magic);
    printk("address number: 0x%x\n", (uint32_t) address);
	}

	/* Parse Multiboot structure */
	multiboot_parse(mbi);

	/* Load kernel_main */
  kernel_main();
}

void kernel_main(void)
{
	printk("\nBooted into kernel mode..\n");

	/* Wait a bit */
	for(volatile int32_t i = 0; i < 10000000; ++i) { }

	printk("Testing delay...\n");

	/* Initialize the bochs video adapter interface */
	//bga_init();
}
