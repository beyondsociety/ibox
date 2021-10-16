#include <lfbvideo.h>
#include <stddef.h>
#include <stdint.h>

/*void lfb_clear(multiboot_info_t * mbi)
{
  //volatile uint32_t * fb = (uint32_t)((uint32_t) mbi->framebuffer_address);
  uint32_t * fb = (uint32_t *) mbi->framebuffer_address;
  uint32_t cell;

  for(cell = 0; cell < mbi->framebuffer_width * mbi->framebuffer_height; cell++)
  fb[cell] = 0x00000080;
}

void clear(unsigned color)
{
	UNUSED int x, y;
	for(unsigned y = 0; y < mbi->framebuffer_height; ++y)
	{
    for(unsigned x = 0; x < mbi->framebuffer_width; ++x)
		{
	    putpixel1(x, y, color);
		}
	}
}

void putpixel1(int x, int y, int color)
{
  uint32_t * pixel = (uint32_t *) mbi->framebuffer_address;
  // Not sure first param = x or second param = x?
  unsigned where = mbi->framebuffer_width + x * mbi->framebuffer_height + y;
  pixel[where] = color;
}*/

// Only valid for 800x600x32bpp
void putpixel(unsigned char * screen, int x, int y, int color)
{
    unsigned where = x * 4 + y * 3200;
    screen[where] = color & 255;              // BLUE
    screen[where + 1] = (color >> 8) & 255;   // GREEN
    screen[where + 2] = (color >> 16) & 255;  // RED
}
