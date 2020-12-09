#ifndef INCLUDE_KERNEL_H
#define INCLUDE_KERNEL_H

#include <multiboot.h>

// Defines
#define UNUSED __attribute__((unused))

//multiboot_info_t * sys_multiboot_info;
multiboot_info_t * mbi;

// Functions
//void kernel_init(multiboot_info_t *mbi, uint32_t magic);
void kernel_init(uint32_t magic, uint32_t address);
void kernel_main(void);

#endif
