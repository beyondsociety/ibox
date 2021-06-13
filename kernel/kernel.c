#include <bga.h>
#include <kernel.h>
#include <io.h>
#include <lfbvideo.h>
#include <multiboot.h>
#include <multiboot2.h>
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
  //(void) magic;
  multiboot_info_t *mbi;
  //struct multiboot_tag *tag;

  // Set MBI to the address of the Multiboot information structure.
  mbi = (multiboot_info_t *) address;
  //tag = (struct multiboot_tag *) address;

  struct multiboot_tag *tag = (struct multiboot_tag *)(address + 8);
  //unsigned size;

	// Clear the screen
	clear_screen();

	// Make sure we're booted by a multiboot loader
	if((magic != MULTIBOOT_BOOTLOADER_MAGIC) && (magic != MULTIBOOT2_BOOTLOADER_MAGIC))
	{
    printk("Invalid magic number: 0x%x\n", (unsigned) magic);
    printk("  no multiboot-compliant bootloader found, halting...");
    hlt();  // return
  }

  if(address & 7)
  {
    printk("Unaligned mbi: 0x%x\n", address);
    return;
  }

	// Parse Multiboot structure
	if(magic == MULTIBOOT_BOOTLOADER_MAGIC)
  {
    multiboot_parse(mbi);
  }

  /*if(magic == MULTIBOOT2_BOOTLOADER_MAGIC)
  {
    multiboot2_parse();
    //multiboot2_parse(tag);
  }*/

  //size = *(unsigned *) address;
  //printk("Announced mbi size 0x%x\n", size);

  for(tag = (struct multiboot_tag *)(address + 8);
    tag->type != MULTIBOOT_TAG_TYPE_END;
      tag = (struct multiboot_tag *)((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7)))
  {
    //printk("Tag 0x%x, Size 0x%x\n", tag->type, tag->size);
    switch (tag->type)
    {
      case MULTIBOOT_TAG_TYPE_CMDLINE:
        printk("Command line = %s\n",
          ((struct multiboot_tag_string *) tag)->string);
        break;

      case MULTIBOOT_TAG_TYPE_BOOT_LOADER_NAME:
        printk("Bootloader name = %s\n",
          ((struct multiboot_tag_string *) tag)->string);
        break;

      case MULTIBOOT_TAG_TYPE_BOOTDEV:
        printk("Boot device 0x%x, %u, %u\n",
          ((struct multiboot_tag_bootdev *) tag)->biosdev,
          ((struct multiboot_tag_bootdev *) tag)->slice,
          ((struct multiboot_tag_bootdev *) tag)->part);
        break;

      case MULTIBOOT_TAG_TYPE_MODULE:
        printk("Module at 0x%x-0x%x. Command line %s\n",
          ((struct multiboot_tag_module *) tag)->module_start,
          ((struct multiboot_tag_module *) tag)->module_end,
          ((struct multiboot_tag_module *) tag)->cmdline);
        break;

      case MULTIBOOT_TAG_TYPE_BASIC_MEMINFO:
        printk("\nMem_lower = %uKB, Mem_upper = %uKB\n",
          ((struct multiboot_tag_basic_meminfo *) tag)->memory_lower,
          ((struct multiboot_tag_basic_meminfo *) tag)->memory_upper);
        break;

      case MULTIBOOT_TAG_TYPE_MMAP:
      {
        multiboot_memory_map_t *mmap;
        printk("\nMmap\n");

        for(mmap = ((struct multiboot_tag_mmap *) tag)->entries;
          (multiboot_uint8_t *) mmap < (multiboot_uint8_t *) tag + tag->size;
            mmap = (multiboot_memory_map_t *) ((unsigned long) mmap + ((struct multiboot_tag_mmap *) tag)->entry_size))
              printk(" Base_address = 0x%x%x,"
                    " Length = 0x%x%x, Type = 0x%x\n",
                    (unsigned) (mmap->address >> 32),
                    (unsigned) (mmap->address & 0xffffffff),
                    (unsigned) (mmap->length >> 32),
                    (unsigned) (mmap->length & 0xffffffff),
                    (unsigned) mmap->type);
      }
      break;

      case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
      {
        multiboot_uint32_t color;
        unsigned i;

        struct multiboot_tag_framebuffer *tagfb = (struct multiboot_tag_framebuffer *) tag;
        void *fb = (void *) (unsigned long) tagfb->common.framebuffer_address;

          printk("\nFramebuffer address: 0x%X, ", (uint32_t) tagfb->common.framebuffer_address);
          printk("Type: %u\n", tagfb->common.framebuffer_type);
          printk(" Width: %u, ", tagfb->common.framebuffer_width);
          printk("Height: %u\n", tagfb->common.framebuffer_height);
          printk(" Bpp: %u, ", tagfb->common.framebuffer_bpp);
          printk("Pitch: %u", tagfb->common.framebuffer_pitch);

          switch (tagfb->common.framebuffer_type)
          {
            case MULTIBOOT_FRAMEBUFFER_TYPE_INDEXED:
            {
              unsigned best_distance, distance;
              struct multiboot_color *palette;

              palette = tagfb->framebuffer_palette;

              color = 0;
              best_distance = 4 * 256 * 256;

              for(i = 0; i < tagfb->framebuffer_palette_number_colors; i++)
              {
                distance = (0xff - palette[i].blue)
                  * (0xff - palette[i].blue)
                  + palette[i].red * palette[i].red
                  + palette[i].green * palette[i].green;

                if(distance < best_distance)
                {
                  color = i;
                  best_distance = distance;
                }
              }
            }
            break;

            case MULTIBOOT_FRAMEBUFFER_TYPE_RGB:
              color = ((1 << tagfb->framebuffer_blue_mask_size) - 1)
                << tagfb->framebuffer_blue_field_position;
            break;

            case MULTIBOOT_FRAMEBUFFER_TYPE_EGA_TEXT:
              color = '\\' | 0x0100;
            break;

            default:
              color = 0xffffffff;
            break;
          }

          /*for(i = 0; i < tagfb->common.framebuffer_width && i < tagfb->common.framebuffer_height; i++)
          {
            switch(tagfb->common.framebuffer_bpp)
            {
              case 8:
              {
                multiboot_uint8_t *pixel = fb + tagfb->common.framebuffer_pitch * i + i;
                *pixel = color;
              }
              break;

              case 15:
              case 16:
              {
                multiboot_uint16_t *pixel = fb + tagfb->common.framebuffer_pitch * i + 2 * i;
                *pixel = color;
              }
              break;

              case 24:
              {
                multiboot_uint32_t *pixel = fb + tagfb->common.framebuffer_pitch * i + 3 * i;
                *pixel = (color & 0xffffff) | (*pixel & 0xff000000);
              }
              break;

              case 32:
              {
                multiboot_uint32_t *pixel = fb + tagfb->common.framebuffer_pitch * i + 4 * i;
                *pixel = color;
              }
              break;
            }
          }
          break;*/
      }
  }

  //tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7));
  //printk ("Total mbi size 0x%x\n", (unsigned) tag - address);
}

	// Load kernel_main
	//kernel_main();

  /*unsigned size;
  //multiboot_uint32_t address;
  //tag = (multiboot_tag_t *) address;

  printk("Parsing Multiboot2 Info...\n");
  if(address & 7)
  {
    printk("Unaligned mbi: 0x%x\n", address);
    return;
  }

  size = *(unsigned *) address;
  //printk("Announced mbi size 0x%x\n", size);

  for(tag = (multiboot_tag_t *) (address + 8);
    tag->type != MULTIBOOT_TAG_TYPE_END;
      tag = (multiboot_tag_t *) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7)))
  {
    //printk("Tag 0x%x, Size 0x%x\n", tag->type, tag->size);
    switch (tag->type)
    {
      case MULTIBOOT_TAG_TYPE_CMDLINE:
        //printk("Command line = %s\n",
          //((struct multiboot_tag_string *) tag)->string);
        break;

      case MULTIBOOT_TAG_TYPE_BOOT_LOADER_NAME:
        printk(" Bootloader name = %s\n",
          ((struct multiboot_tag_string *) tag)->string);
        break;

      case MULTIBOOT_TAG_TYPE_BOOTDEV:
        printk(" Boot device 0x%x, %u, %u\n",
          ((struct multiboot_tag_bootdev *) tag)->biosdev,
          ((struct multiboot_tag_bootdev *) tag)->slice,
          ((struct multiboot_tag_bootdev *) tag)->part);
        break;

      case MULTIBOOT_TAG_TYPE_MODULE:
        printk("Module at 0x%x-0x%x. Command line %s\n",
          ((struct multiboot_tag_module *) tag)->module_start,
          ((struct multiboot_tag_module *) tag)->module_end,
          ((struct multiboot_tag_module *) tag)->cmdline);
        break;

      case MULTIBOOT_TAG_TYPE_BASIC_MEMINFO:
        printk("\nMem_lower = %uKB, Mem_upper = %uKB\n",
          ((struct multiboot_tag_basic_meminfo *) tag)->memory_lower,
          ((struct multiboot_tag_basic_meminfo *) tag)->memory_upper);
        break;

      case MULTIBOOT_TAG_TYPE_MMAP:
        {
          multiboot_memory_map_t *mmap;
          printk("\nMmap\n");

          for(mmap = ((struct multiboot_tag_mmap *) tag)->entries;
            (multiboot_uint8_t *) mmap < (multiboot_uint8_t *) tag + tag->size;
              mmap = (multiboot_memory_map_t *) ((unsigned long) mmap + ((struct multiboot_tag_mmap *) tag)->entry_size))
                printk(" Base_address = 0x%x%x,"
                      " Length = 0x%x%x, Type = 0x%x\n",
                      (unsigned) (mmap->address >> 32),
                      (unsigned) (mmap->address & 0xffffffff),
                      (unsigned) (mmap->length >> 32),
                      (unsigned) (mmap->length & 0xffffffff),
                      (unsigned) mmap->type);
        }
      break;

      case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
        {
          multiboot_uint32_t color;
          unsigned i;
            struct multiboot_tag_framebuffer *tagfb = (struct multiboot_tag_framebuffer *) tag;
            void *fb = (void *) (unsigned long) tagfb->common.framebuffer_address;

            printk("\nFramebuffer address: 0x%X, ", (uint32_t) tagfb->common.framebuffer_address);
            printk("Type: %u\n", tagfb->common.framebuffer_type);
            printk(" Width: %u, ", tagfb->common.framebuffer_width);
            printk("Height: %u\n", tagfb->common.framebuffer_height);
            printk(" Bpp: %u, ", tagfb->common.framebuffer_bpp);
            printk("Pitch: %u\n\n", tagfb->common.framebuffer_pitch);

            switch (tagfb->common.framebuffer_type)
              {
              case MULTIBOOT_FRAMEBUFFER_TYPE_INDEXED:
                {
                  unsigned best_distance, distance;
                  struct multiboot_color *palette;

                  palette = tagfb->framebuffer_palette;

                  color = 0;
                  best_distance = 4 * 256 * 256;

                  for(i = 0; i < tagfb->framebuffer_palette_number_colors; i++)
                  {
                    distance = (0xff - palette[i].blue)
                        * (0xff - palette[i].blue)
                        + palette[i].red * palette[i].red
                        + palette[i].green * palette[i].green;
                      if(distance < best_distance)
                        {
                          color = i;
                          best_distance = distance;
                        }
                    }
                }
                break;

              case MULTIBOOT_FRAMEBUFFER_TYPE_RGB:
                color = ((1 << tagfb->framebuffer_blue_mask_size) - 1)
                  << tagfb->framebuffer_blue_field_position;
                break;

              case MULTIBOOT_FRAMEBUFFER_TYPE_EGA_TEXT:
                color = '\\' | 0x0100;
                break;

              default:
                color = 0xffffffff;
                break;
              }

            for(i = 0; i < tagfb->common.framebuffer_width
                   && i < tagfb->common.framebuffer_height; i++)
              {
                switch(tagfb->common.framebuffer_bpp)
                  {
                  case 8:
                    {
                      multiboot_uint8_t *pixel = fb
                        + tagfb->common.framebuffer_pitch * i + i;
                      *pixel = color;
                    }
                    break;
                  case 15:
                  case 16:
                    {
                      multiboot_uint16_t *pixel
                        = fb + tagfb->common.framebuffer_pitch * i + 2 * i;
                      *pixel = color;
                    }
                    break;
                  case 24:
                    {
                      multiboot_uint32_t *pixel
                        = fb + tagfb->common.framebuffer_pitch * i + 3 * i;
                      *pixel = (color & 0xffffff) | (*pixel & 0xff000000);
                    }
                    break;

                  case 32:
                    {
                      multiboot_uint32_t *pixel
                        = fb + tagfb->common.framebuffer_pitch * i + 4 * i;
                      *pixel = color;
                    }
                    break;
                  }
              }
            break;
          }
        }
  }*/

  //tag = (multiboot_tag_t *) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7));
  //printk ("Total mbi size 0x%x\n", (unsigned) tag - address);
}

void kernel_main(void)
{
	printk("Booted into kernel mode..\n");

	// Wait a bit
	for(volatile int32_t i = 0; i < 10000000; ++i) { }

	printk("Testing delay...\n");

	// Initialize the bochs video adapter interface
	//bga_init();
}
