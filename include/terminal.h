#ifndef _TERMINAL_H_
#define _TERMINAL_H_

#include <stddef.h>
#include <stdint.h>

/* Hardware text mode color constants. */
enum vga_color
{
	BLACK = 0,
	BLUE = 1,
	GREEN = 2,
	CYAN = 3,
	RED = 4,
	MAGENTA = 5,
	BROWN = 6,
	LIGHT_GREY = 7,
	DARK_GREY = 8,
	LIGHT_BLUE = 9,
	LIGHT_GREEN = 10,
	LIGHT_CYAN = 11,
	LIGHT_RED = 12,
	LIGHT_MAGENTA = 13,
	LIGHT_BROWN = 14,
	WHITE = 15,
};

/* Definitions */
static const size_t VGA_WIDTH  = 80;
static const size_t VGA_HEIGHT = 25;
 
size_t terminal_row;
size_t terminal_column;

uint8_t terminal_color;
uint16_t *terminal_buffer;

/* Functions */
uint8_t make_color(enum vga_color fg, enum vga_color bg);
uint16_t make_vgaentry(int8_t c, int16_t color);

void terminal_initialize(void);
void terminal_setcolor(uint8_t color);

void terminal_putentryat(int8_t c, uint8_t color, size_t x, size_t y);
void terminal_putchar(int8_t c);
void terminal_writestring(const int8_t *data);

#endif
