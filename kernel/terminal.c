#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <terminal.h>

uint8_t make_color(enum vga_color fg, enum vga_color bg)
{
	return (uint8_t)(fg | bg << 4);
}

uint16_t make_vgaentry(int8_t c, uint8_t color)
{
	uint16_t c16 = (uint16_t) c;
	uint16_t color16 = color;

	return (uint16_t)(c16 | color16 << 8);
}

void terminal_initialize(void)
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = make_color(LIGHT_GREY, BLUE);
	terminal_buffer = (uint16_t *) 0xB8000;

	for(size_t y = 0; y < VGA_HEIGHT; y++)
	{
		for(size_t x = 0; x < VGA_WIDTH; x++)
		{
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = make_vgaentry(' ', terminal_color);
		}
	}

  printk("Kernel Initialized...\n");
}

void terminal_setcolor(uint8_t color)
{
	terminal_color = color;
}

void terminal_putentryat(int8_t c, uint8_t color, size_t x, size_t y)
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = make_vgaentry(c, color);
}

void terminal_putchar(int8_t c)
{
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
	if(++terminal_column == VGA_WIDTH)
	{
		terminal_column = 0;
		if(++terminal_row == VGA_HEIGHT)
		{
			terminal_row = 0;
		}
	}
}

void terminal_writestring(const int8_t * data)
{
	size_t datalen = strlen(data);
	for(size_t i = 0; i < datalen; i++)
  {
		terminal_putchar(data[i]);
  }
}
