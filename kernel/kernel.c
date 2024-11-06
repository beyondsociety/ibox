#include <bga.h>
#include <kernel.h>
#include <io.h>
#include <lfbvideo.h>
#include <multiboot2.h>
#include <serial.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
//#include <terminal.h>

/* Perform some preloading stuff */
//void kernel_init(multiboot_info_t *mbi, unsigned long magic)
void kernel_init(uint64_t address)
//void kernel_init(unsigned long magic, unsigned long address)
{
  //multiboot_info_t *mbi;
  //unsigned long address;

  /* Set MBI to the address of the Multiboot information structure. */
  //mbi = (multiboot_info_t *) address;

  //multiboot_info_t *mbi = (multiboot_info_t *) address;
  //struct multiboot_tag *tag = (struct multiboot_tag *)(address + 8);

	/* Clear the screen */
	clear_screen();

  /* To fix issue of mulitboot structure being overriden in 64-bit mode
   * If booting 32-bit mode, continue check of multiboot */
  #if __i386__

    uint32_t magic = 0;

    /* Make sure we're booted by a multiboot loader */
    //if((magic != MULTIBOOT_BOOTLOADER_MAGIC) && (magic != MULTIBOOT2_BOOTLOADER_MAGIC))
	  if(magic != MULTIBOOT2_BOOTLOADER_MAGIC)
    { 
      serial_printk("Invalid magic number: %X\n", (unsigned) magic);
      serial_printk("  no multiboot-compliant bootloader found, halting...");

      printk("Invalid magic number: 0x%x\n", (unsigned) magic);
      printk("  no multiboot-compliant bootloader found, halting...");
      hlt();  /* Halt the Cpu */
    }
    else
    {
      serial_printk("Magic number: %X\n", (uint32_t) magic);
      serial_printk("Address number: %X\n", (uint32_t) address);

      printk("Magic number: 0x%x\n", (uint32_t) magic);
      printk("Address number: 0x%x\n", (uint32_t) address);
    }

  /* If booting in 64-bit mode, continue booting without checking multiboot */
  #elif __x86_64__
    printk("Checking of multiboot disabled for 64-bit mode");
  #endif

  /* Parse Multiboot structurea */
  /*if(magic == MULTIBOOT_BOOTLOADER_MAGIC)
  {
    multiboot_parse(mbi);
  }
  else if(magic == MULTIBOOT2_BOOTLOADER_MAGIC)
  {
    multiboot2_parse(address);
  } */

  multiboot2_parse(address);

  /* Load kernel_main */
  //kernel_main();
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
