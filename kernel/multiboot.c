#include <io.h>
#include <multiboot.h>
#include <stdint.h>
#include <stdio.h>

void multiboot_parse(multiboot_info_t *mbi)
{
  printk("Parsing Multiboot Info...\n\n");

  if(mbi->flags & MULTIBOOT_INFO_FRAMEBUFFER_INFO)
  //if(CHECK_FLAG (mbi->flags, 12))
  {
    printk("Framebuffer \n");
    printk("  Address: 0x%X\n", (uint32_t) mbi->framebuffer_address);
    printk("  Type: %u\n", mbi->framebuffer_type);
    printk("  Width: %u\n", mbi->framebuffer_width);
    printk("  Height: %u\n", mbi->framebuffer_height);
    printk("  Bpp: %u\n", mbi->framebuffer_bpp);
    printk("  Pitch: %u\n", mbi->framebuffer_pitch);
  }

  /* Print out the flags. */
  //printk("Flags = 0x%X\n", (uint32_t) mbi->flags);

  /* Are mem_* valid? */
  //if(CHECK_FLAG (mbi->flags, 0))
  //  printk("Memory-lower = %uKB, Memory-upper = %uKB\n",
  //    (uint32_t) mbi->memory_lower, (uint32_t) mbi->memory_upper);

  /* Is boot_device valid? */
  //if(CHECK_FLAG (mbi->flags, 1))
  //  printk("Boot-device  = 0x%x\n", (uint32_t) mbi->boot_device);

  /* Are mods_* valid? */
  //if(CHECK_FLAG (mbi->flags, 3))
  //{
  //  multiboot_module_t *module;
  //  uint32_t i;

  //  printk("modules-count = %d, modules-address = 0x%x\n",
  //    (uint32_t)mbi->module_count, (int32_t)mbi->module_address);

  //    for(i = 0, module = (multiboot_module_t *) mbi->module_address;
	//	  i < mbi->module_count; i++, module++)

  //      printk(" module-start = 0x%x, module-end = 0x%x, command-line = %s\n",
  //        (uint32_t)module->module_start, (uint32_t)module->module_end, (int8_t)module->cmdline);
  //}

  /* Bits 4 and 5 are mutually exclusive! */
  //if(CHECK_FLAG(mbi->flags, 4) && CHECK_FLAG(mbi->flags, 5))
  //{
  //  printk("Both bits 4 and 5 are set.\n");
  //  return;
  //}

  /* Is the section header table of ELF valid? */
  //if(CHECK_FLAG (mbi->flags, 5))
  //{
  //  multiboot_elf_section_header_table_t *multiboot_elf_section = &(mbi->u.elf_section);
  //  printk("Multiboot-elf Section: number = %u, size = 0x%x," " address = 0x%x, shndx = 0x%x\n\n",
  //    (uint32_t) multiboot_elf_section->number, (uint32_t) multiboot_elf_section->size,
  //    (uint32_t) multiboot_elf_section->address, (uint32_t) multiboot_elf_section->shndx);
  //}

  /* Are mmap_* valid? */
  //if(CHECK_FLAG (mbi->flags, 6))
  //{
  //  multiboot_map_t *mmap;

  //  printk("Memory-map Address = 0x%x, Memory-map Length = 0x%x\n",
  //    (uint32_t) mbi->mmap_address, (uint32_t) mbi->mmap_length);

  //  for(mmap = (multiboot_map_t *) mbi->mmap_address;
  //    (uint64_t) mmap < mbi->mmap_address + mbi->mmap_length;
  //      mmap = (multiboot_map_t *) ((uint64_t) mmap + mmap->size + sizeof(mmap->size)))
  //        printk("Size = 0x%x, Base Address = 0x%x%x," " Length = 0x%x%x, Type = 0x%x\n",
  //        	(uint32_t)mmap->size, (uint32_t)mmap->base_address_high, (uint32_t)mmap->base_address_low,
  //              (uint32_t)mmap->length_high, (uint32_t)mmap->length_low, (uint32_t)mmap->type);
  //}
}

/* Prints the memory map as reported by grub, map = memory map pointer, size = size of map */
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
