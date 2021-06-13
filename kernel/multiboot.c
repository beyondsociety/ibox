#include <io.h>
#include <multiboot.h>
#include <multiboot2.h>
#include <stdint.h>
#include <stdio.h>

void multiboot_parse(multiboot_info_t *mbi)
{
  printk("Parsing Multiboot Info...\n\n");

  // Print out the flags
  printk("Flags = 0x%X\n", (uint32_t) mbi->flags);

  // Are mem_* valid?
  if(CHECK_FLAG (mbi->flags, 0))
    printk("Memory-lower = %uKB, Memory-upper = %uKB\n",
      (uint32_t) mbi->memory_lower, (uint32_t) mbi->memory_upper);

  // Is boot_device valid?
  if(CHECK_FLAG (mbi->flags, 1))
    printk("Boot-device  = 0x%x\n", (uint32_t) mbi->boot_device);

  // Are mods_* valid?
  if(CHECK_FLAG (mbi->flags, 3))
  {
    multiboot_module_t *module;
    uint32_t i;

    printk("modules-count = %d, modules-address = 0x%x\n",
      (uint32_t)mbi->module_count, (int32_t)mbi->module_address);

      for(i = 0, module = (multiboot_module_t *) mbi->module_address;
		  i < mbi->module_count; i++, module++)

        printk(" module-start = 0x%x, module-end = 0x%x, command-line = %s\n",
          (uint32_t)module->module_start, (uint32_t)module->module_end, (int8_t)module->cmdline);
  }

  // Bits 4 and 5 are mutually exclusive!
  if(CHECK_FLAG(mbi->flags, 4) && CHECK_FLAG(mbi->flags, 5))
  {
    printk("Both bits 4 and 5 are set.\n");
    return;
  }

  // Is the section header table of ELF valid?
  if(CHECK_FLAG (mbi->flags, 5))
  {
    multiboot_elf_section_header_table_t *multiboot_elf_section = &(mbi->u.elf_section);
    printk("Multiboot-elf Section: number = %u, size = 0x%x," " address = 0x%x, shndx = 0x%x\n",
      (uint32_t) multiboot_elf_section->number, (uint32_t) multiboot_elf_section->size,
      (uint32_t) multiboot_elf_section->address, (uint32_t) multiboot_elf_section->shndx);
  }

  // Are mmap_* valid?
  if(CHECK_FLAG (mbi->flags, 6))
  {
    multiboot_map_t *mmap;

    printk("Memory-map Address = 0x%x, Memory-map Length = 0x%x\n",
      (uint32_t) mbi->mmap_address, (uint32_t) mbi->mmap_length);

    for(mmap = (multiboot_map_t *) mbi->mmap_address;
      (uint64_t) mmap < mbi->mmap_address + mbi->mmap_length;
        mmap = (multiboot_map_t *) ((uint64_t) mmap + mmap->size + sizeof(mmap->size)))
          printk("Size = 0x%x, Base Address = 0x%x%x," " Length = 0x%x%x, Type = 0x%x\n",
          	(uint32_t)mmap->size, (uint32_t)mmap->base_address_high, (uint32_t)mmap->base_address_low,
                (uint32_t)mmap->length_high, (uint32_t)mmap->length_low, (uint32_t)mmap->type);
  }

  //if(mbi->flags & MULTIBOOT_INFO_FRAMEBUFFER_INFO)
  if(CHECK_FLAG (mbi->flags, 12))
  {
    printk("Framebuffer address: 0x%X, ", (uint32_t) mbi->framebuffer_address);
    printk("Type: %u\n", mbi->framebuffer_type);
    printk("Width: %u, ", mbi->framebuffer_width);
    printk("Height: %u\n", mbi->framebuffer_height);
    printk("Bpp: %u, ", mbi->framebuffer_bpp);
    printk("Pitch: %u\n", mbi->framebuffer_pitch);
  }
}

void multiboot2_parse()
//void multiboot2_parse(multiboot_tag_t *tag)
{
  //struct multiboot_tag *tag;
  //unsigned size;
  //uint32_t address;

  //multiboot_uint32_t address;
  //tag = (multiboot_tag_t *) address;

  //printk("Parsing Multiboot2 Info...\n");
  /*if(address & 7)
  {
    printk("Unaligned mbi: 0x%x\n", address);
    return;
  }*/

  //size = *(unsigned *) address;
  //printk("Announced mbi size 0x%x\n", size);

  /*for(tag = (struct multiboot_tag *) (address + 8);
    tag->type != MULTIBOOT_TAG_TYPE_END;
      tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7)))
  {
    printk("Tag 0x%x, Size 0x%x\n", tag->type, tag->size);
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

// Prints the memory map as reported by grub, map = memory map pointer, size = size of map
void print_memory_map(uint32_t *map, uint32_t size)
{
  uint32_t *p = map;
  uint32_t index = 0;

  printk(" MemoryMap as reported by grub (<at = 0x%x, size = %d>)\n", map, size);
  for(index = 0; index < size / 24; index++, p += 6)
  {
    printk("<address_low = 0x%x, address_high = 0x%x ,length_low = %x, length_high = %x,"\
      " type = %d>\n", * (p + 1), * (p + 2), * (p + 3), * (p + 4), * (p + 5));
  }
}
