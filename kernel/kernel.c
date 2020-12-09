#include <bga.h>
#include <kernel.h>
#include <io.h>
#include <lfbvideo.h>
#include <multiboot.h>
#include <serial.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <terminal.h>

// Perform some preloading stuff
void kernel_init(uint32_t magic, uint32_t address)
//void kernel_init(multiboot_info_t *mbi, uint32_t magic)
{
  (void) magic;
  multiboot_info_t *mbi;

  // Set MBI to the address of the Multiboot information structure.
  mbi = (multiboot_info_t *) address;

	lfb_clear(mbi);
  //putpixel(0xFD000000, 300, 300, 0x00ffffff);

  init_serial();
  serial_print("Testing Serial Output");

	// Clear the screen
	/*clear_screen();

	// Make sure we're booted by a multiboot loader
	if(magic != MULTIBOOT_BOOTLOADER_MAGIC)
	{
		printk("Not booted with a multiboot-compliant bootloader!");
		hlt();
	}

	// Parse Multiboot structure
	multiboot_parse(mbi);

	// Load kernel_main
	kernel_main();*/
}

/*void kernel_main(void)
{
	printk("Booted into kernel mode..\n");

	// Wait a bit
	for(volatile int32_t i = 0; i < 10000000; ++i) { }

	printk("Testing delay...\n");

	// Initialize the bochs video adapter interface
	bga_init();
}*/
