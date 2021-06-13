/* multiboot.h - Multiboot header file. */
/* Copyright (C) 1999,2003,2007,2008,2009  Free Software Foundation, Inc.
   *
   *  Permission is hereby granted, free of charge, to any person obtaining a copy
   *  of this software and associated documentation files (the "Software"), to
   *  deal in the Software without restriction, including without limitation the
   *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
   *  sell copies of the Software, and to permit persons to whom the Software is
   *  furnished to do so, subject to the following conditions:
   *
   *  The above copyright notice and this permission notice shall be included in
   *  all copies or substantial portions of the Software.
   *
   *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL ANY
   *  DEVELOPER OR DISTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
   *  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#ifndef MULTIBOOT_HEADER
#define MULTIBOOT_HEADER 1

#define MULTIBOOT_SEARCH                       8192       // How many bytes from the start of the file we search for the header
#define MULTIBOOT_HEADER_ALIGN                 4
#define MULTIBOOT_HEADER_MAGIC                 0x1BADB002 // The magic field should contain this
#define MULTIBOOT_BOOTLOADER_MAGIC             0x2BADB002 // This should be in %eax

#define MULTIBOOT_UNSUPPORTED                  0x0000fffc // The bits in the required part of flags field we don't support
#define MULTIBOOT_MODULE_ALIGN                 0x00001000 // Alignment of multiboot modules
#define MULTIBOOT_INFO_ALIGN                   0x00000004 // Alignment of the multiboot info structure
#define MULTIBOOT_PAGE_ALIGN                   0x00000001 // Align all boot modules on i386 page (4KB) boundaries
#define MULTIBOOT_MEMORY_INFO                  0x00000002 // Pass memory information to OS
#define MULTIBOOT_VIDEO_MODE                   0x00000004 // Pass video information to OS
#define MULTIBOOT_AOUT_KLUDGE                  0x00010000 // This flag indicates the use of the address fields in the header

// Multiboot flags for the multiboot info structure
#define MULTIBOOT_INFO_MEMORY                  0x00000001 // Is there basic lower/upper memory information?
#define MULTIBOOT_INFO_BOOTDEV                 0x00000002 // Is there a boot device set?
#define MULTIBOOT_INFO_CMDLINE                 0x00000004 // Is the command-line defined?
#define MULTIBOOT_INFO_MODS                    0x00000008 // Are there modules to do something with?
#define MULTIBOOT_INFO_AOUT_SYMS               0x00000010 // Is there a symbol table loaded?
#define MULTIBOOT_INFO_ELF_SHDR                0x00000020 // Is there an ELF section header table?
#define MULTIBOOT_INFO_MEM_MAP                 0x00000040 // Is there a full memory map?
#define MULTIBOOT_INFO_DRIVE_INFO              0x00000080 // Is there drive info?
#define MULTIBOOT_INFO_CONFIG_TABLE            0x00000100 // Is there a config table?
#define MULTIBOOT_INFO_BOOT_LOADER_NAME        0x00000200 // Is there a boot loader name?
#define MULTIBOOT_INFO_APM_TABLE               0x00000400 // Is there a APM table?
#define MULTIBOOT_INFO_VIDEO_INFO              0x00000800 // Is there video information?
#define MULTIBOOT_INFO_FRAMEBUFFER_INFO        0x00001000 // Is there video information?

#include <stdint.h>
//#ifndef ASM_FILE
  //typedef unsigned char           uint8_t;
  //typedef unsigned short          uint16_t;
  //typedef unsigned int            uint32_t;
  //typedef unsigned long long      uint64_t;

typedef struct multiboot_header
{
  uint32_t magic;                 // Must be MULTIBOOT_MAGIC
  uint32_t flags;                 // Feature flags
  uint32_t checksum;              // The above fields plus this one must equal 0 mod 2^32

  uint32_t header_address;        // These are only valid if MULTIBOOT_AOUT_KLUDGE is set
  uint32_t load_address;
  uint32_t load_end_address;
  uint32_t bss_end_address;
  uint32_t entry_address;

  uint32_t mode_type;             // These are only valid if MULTIBOOT_VIDEO_MODE is set
  uint32_t width;
  uint32_t height;
  uint32_t depth;
} multiboot_header_t;

typedef struct multiboot_aout_symbol_table
{
  uint32_t tabsize;
  uint32_t strsize;
  uint32_t address;
  uint32_t reserved;
} multiboot_aout_symbol_table_t;

typedef struct multiboot_elf_section_header_table
{
  uint32_t number;
  uint32_t size;
  uint32_t address;
  uint32_t shndx;
} multiboot_elf_section_header_table_t;

typedef struct multiboot_info
{
  uint32_t flags;              // Multiboot info version number

  uint32_t memory_lower;       // Available memory from BIOS
  uint32_t memory_upper;

  uint32_t boot_device;        // "root" partition
  uint32_t cmdline;            // Kernel command line

  uint32_t module_count;       // Boot-Module list
  uint32_t module_address;

  union
  {
    multiboot_aout_symbol_table_t aout_symbol;
    multiboot_elf_section_header_table_t elf_section;
  } u;

  uint32_t mmap_length;        // Memory Mapping buffer
  uint32_t mmap_address;

  uint32_t drives_length;      // Drive Info buffer
  uint32_t drives_address;

  uint32_t config_table;       // ROM configuration table
  uint32_t boot_loader_name;   // Boot Loader Name
  uint32_t apm_table;          // APM table

  uint32_t vbe_control_info;   // Vbe video information
  uint32_t vbe_mode_info;
  uint16_t vbe_mode;
  uint16_t vbe_interface_segment;
  uint16_t vbe_interface_offset;
  uint16_t vbe_interface_length;

  uint64_t framebuffer_address;
  uint32_t framebuffer_pitch;
  uint32_t framebuffer_width;
  uint32_t framebuffer_height;
  uint8_t framebuffer_bpp;

  #define MULTIBOOT_FRAMEBUFFER_TYPE_INDEXED    0
  #define MULTIBOOT_FRAMEBUFFER_TYPE_RGB        1
  #define MULTIBOOT_FRAMEBUFFER_TYPE_EGA_TEXT   2

  uint8_t framebuffer_type;

  union
  {
    struct
    {
      uint32_t framebuffer_palette_address;
      uint16_t framebuffer_palette_number_colors;
    };

    struct
    {
      uint8_t framebuffer_red_field_position;
      uint8_t framebuffer_red_mask_size;
      uint8_t framebuffer_green_field_position;
      uint8_t framebuffer_green_mask_size;
      uint8_t framebuffer_blue_field_position;
      uint8_t framebuffer_blue_mask_size;
    };
  };
} multiboot_info_t;

typedef struct multiboot_color
{
  uint8_t red;
  uint8_t green;
  uint8_t blue;
} multiboot_color_t;

#define MULTIBOOT_MEMORY_AVAILABLE              1
#define MULTIBOOT_MEMORY_RESERVED               2
#define MULTIBOOT_MEMORY_ACPI_RECLAIMABLE       3
#define MULTIBOOT_MEMORY_NVS                    4
#define MULTIBOOT_MEMORY_BADRAM                 5

typedef struct multiboot_map
{
  uint32_t size;
  //uint64_t address;
  uint32_t base_address_low;
  uint32_t base_address_high;
  //uint64_t length;
  uint32_t length_low;
  uint32_t length_high;
  uint32_t type;
  //uint32_t acpi_3_0;
} multiboot_map_t;

typedef struct multiboot_module_list
{
  uint32_t module_start; // The memory used goes from bytes 'mod_start' to 'mod_end-1' inclusive
  uint32_t module_end;

  uint32_t cmdline;     // Module command line
  uint32_t padding;     // Padding to take it to 16 bytes (must be zero)
} multiboot_module_t;

//---------------------------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------------------------
void multiboot_parse(multiboot_info_t *mbi); // Multiboot function
void print_memory_map(uint32_t *map, uint32_t size); // Prints the memory map as reported by grub, map = memory map pointer, size = size of map

//#endif // ASM_FILE
#endif // MULTIBOOT_HEADER
