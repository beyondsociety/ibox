#ifndef INCLUDE_KERNEL_H
#define INCLUDE_KERNEL_H

#include <multiboot.h>
<<<<<<< HEAD
=======
#include <multiboot2.h>
#include <stdint.h>
>>>>>>> parent of 0773030... Fixed conflicts with code for merge.

// Defines
#define UNUSED __attribute__((unused))

<<<<<<< HEAD
multiboot_info_t *sys_multiboot_info;

/* Functions */
//void kernel_init(multiboot_info_t *mbi, uint32_t address);
void kernel_init(uint32_t magic, uint32_t address);
=======
// Check if the bit BIT in FLAGS is set.
#define CHECK_FLAG(flags,bit) ((flags) & (1 << (bit)))

// Functions
//void kernel_init(struct multiboot_tag *tag, uint32_t magic);
void kernel_init(multiboot_info_t *mbi, uint32_t magic);
//void kernel_init(uint32_t magic, uint32_t address);
void kernel_main(void);
>>>>>>> parent of 0773030... Fixed conflicts with code for merge.

#endif
