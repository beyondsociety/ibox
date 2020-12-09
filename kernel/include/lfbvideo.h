#ifndef INCLUDE_LFBVIDEO_H
#define INCLUDE_LFBVIDEO_H

#include <lfbvideo.h>
#include <multiboot.h>

// Defines
multiboot_info_t * mbi;

// Functions
void lfb_clear(multiboot_info_t * mbi);
void clear(unsigned color);

void putpixel1(int x, int y, int color);

// Only valid for 800x600x32bpp
void putpixel(unsigned char * screen, int x, int y, int color);

#endif
