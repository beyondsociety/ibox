#include <kernel.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <svga.h>

/* Changes video modes */
void svga_change_mode(UNUSED uint16_t mode) 
{
	printk("Changing SVGA mode not supported (mode = 0x%X)\n", mode);
}

/* Returns a pointer to the info struct about a certain SVGA mode. */
svga_mode_info_t *svga_mode_get_info(UNUSED uint16_t mode) 
{
	return (svga_mode_info_t *) sys_multiboot_info->vbe_mode_info;
}

int32_t console_init_fb()
{
    	svga_mode_info_t *svga_mode_info = svga_mode_get_info(SVGA_DEFAULT_MODE);
	//video_base = svga_map_fb(svga_mode_info->physbase, svga_mode_info->pitch * svga_mode_info->screen_height);

	bytesPerLine = svga_mode_info->pitch;
	width = svga_mode_info->screen_width;
	height = svga_mode_info->screen_height;
	depth = svga_mode_info->bpp / 8;

	//fb_console_set_font(&ter_i16n_raw, &ter_i16b_raw);

	/* Clear screen */
       	memset((void *) video_base, (int8_t) bytesPerLine * (int8_t) height, 00);
 
	is_bold = false;
	next_char_is_escape_seq = false;
	fg_colour = 0x0F;
	bg_colour = 0x00;

	col = row = 0;
        return 0;
}

void fb_console_set_font(void *reg, void *bold) 
{
	if(reg) font_reg = reg;
	if(bold) font_bold = bold;
}

/*uint32_t svga_map_fb(uint32_t real_addr, uint32_t fb_length) 
{
	int i = 0;
	uint32_t fb_addr;

	// Align framebuffer length to page boundaries 
	fb_length += 0x1000;
	fb_length &= 0x0FFFF000;

	// Map enough framebuffer 
	for(i = 0xD0000000; i < 0xD0000000 + fb_length; i += 0x1000) 
	{
		page_t *page = paging_get_page(i, true, kernel_directory);

	    fb_addr = (i & 0x0FFFF000) + real_addr;

	    page->present = 1;
	    page->rw = 1;
	    page->user = 1;
	    page->frame = fb_addr >> 12;
	}

	// Convert the kernel directory addresses to physical if needed 
	for(i = 0x340; i < 0x340 + (fb_length / 0x400000); i++) 
	{
		uint32_t physAddr = kernel_directory->tablesPhysical[i];

		if((physAddr & 0xC0000000) == 0xC0000000) 
		{
			physAddr &= 0x0FFFFFFF; // get rid of high nybble 

			kernel_directory->tablesPhysical[i] = physAddr;
		}
	}

	return 0xD0000000;
}*/
