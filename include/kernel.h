#ifndef INCLUDE_KERNEL_H
#define INCLUDE_KERNEL_H

#include <multiboot.h>

/* Defines */
#define UNUSED __attribute__((unused))

multiboot_info_t *sys_multiboot_info;

/* Functions */
void kernel_init(UNUSED multiboot_info_t *mbi, uint32_t magic);
void kernel_main(void);

#endif
