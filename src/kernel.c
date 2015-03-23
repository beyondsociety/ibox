#include <bga.h>
#include <kernel.h>
#include <io.h>
#include <multiboot.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <svga.h>
#include <terminal.h>

/* Perform some preloading stuff */
void kernel_init(multiboot_info_t *mbi, uint32_t magic) 
{	  	
	/* Clear the screen */
	clear_screen();

      	/* Make sure we're booted by a multiboot loader */
      	if(magic != MULTIBOOT_BOOTLOADER_MAGIC) 
      	{
      	     printk("Not booted with a multiboot-compliant bootloader!");
      	     hlt();
      	}
        
        /* Parse Multiboot */
     	multiboot_parse(mbi);

      	kernel_main();
}

void kernel_main(void) 
{
       printk("Booted into 32-bit mode...");       
 
       /* Check if we're in a VBE mode that's 32bpp or 16bpp and set up FB console */
       svga_mode_info_t *vbe_info = (svga_mode_info_t *) sys_multiboot_info->vbe_mode_info;

       if(vbe_info->bpp == 32 || vbe_info->bpp == 16) 
       {
              console_init_fb(); 
       }
}



