#ifndef INCLUDE_KERNEL_H
#define INCLUDE_KERNEL_H

#include <multiboot.h>
#include <multiboot2.h>

#include <stdint.h>

// Defines
#define UNUSED __attribute__((unused))

// Check if the bit BIT in FLAGS is set.
#define CHECK_FLAG(flags,bit) ((flags) & (1 << (bit)))

//multiboot_info_t * sys_multiboot_info;
//multiboot_info_t * mbi;

// Functions
//void kernel_init(multiboot_info_t *mbi, uint32_t magic);
void kernel_init(uint32_t magic, uint32_t address);
void kernel_main(void);

#endif
