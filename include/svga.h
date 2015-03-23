#ifndef SVGA_H
#define SVGA_H

#include <stdbool.h>
#include <stdint.h>

#define SVGA_DEFAULT_MODE 0x117

// RRRRR GGGGGG BBBBB
#define SVGA_24TO16BPP(x) ((x & 0xF80000) >> 8) | ((x & 0xFC00) >> 5) | ((x & 0xF8) >> 3)

#define CHAR_HEIGHT 16
#define CHAR_WIDTH 8

// Pointers to fonts
static uint8_t UNUSED *font_reg, UNUSED *font_bold;

// Video mode info
static uint16_t UNUSED width, UNUSED height, UNUSED depth, UNUSED bytesPerLine;
//static uint32_t video_base, video_size;

// Cursor location (in text cells)
static uint16_t UNUSED col, UNUSED row;

// Set by escape sequences
static uint8_t UNUSED fg_colour, UNUSED bg_colour;

// Used to parse escape codes
static bool UNUSED next_char_is_escape_seq, UNUSED is_bold;

// Colour code -> 16bpp
/*static uint32_t fb_console_col_map[16] = 
{
	0x000000, 0x0000AA, 0x00AA00, 0x00AAAA,
	0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA,

	0x555555, 0x5555FF, 0x55FF55, 0x55FFFF,
	0xFF5555, 0xFF55FF, 0xFFFF55, 0xFFFFFF
};*/

typedef struct svga_mode_info 
{
	uint16_t attributes;
	uint8_t windowA, windowB;
	uint16_t granularity;
	uint16_t windowSize;
	uint16_t segmentA, segmentB;
	uint32_t winFuncPtr; 				        // ptr to INT 0x10 Function 0x4F05
	uint16_t pitch; 					// bytes per scan line

	uint16_t screen_width, screen_height; 			// resolution
	uint8_t wChar, yChar, planes, bpp, banks; 		// number of banks
	uint8_t memoryModel, bankSize, imagePages;
	uint8_t reserved0;

	// color masks
	uint8_t readMask, redPosition;
	uint8_t greenMask, greenPosition;
	uint8_t blueMask, bluePosition;
	uint8_t reservedMask, reservedPosition;
	uint8_t directColorAttributes;

	uint32_t physbase; 					//pointer to LFB in LFB modes
	uint32_t offScreenMemOff;
	uint16_t offScreenMemSize;
	uint8_t reserved1[206];
} __attribute__((packed)) svga_mode_info_t;

void svga_change_mode(uint16_t);
svga_mode_info_t *svga_mode_get_info(uint16_t);
uint32_t svga_map_fb(uint32_t, uint32_t);

int32_t console_init_fb(void);
void fb_console_set_font(void *reg, void *bold);

#endif
