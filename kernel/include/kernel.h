#ifndef INCLUDE_KERNEL_H
#define INCLUDE_KERNEL_H

//#include <multiboot.h>
#include <multiboot2.h>
#include <stdint.h>

#if defined(__x86_64__)
/* 64 bit detected */
#endif

#if defined(__i386__)
/* 32 bit x86 detected */
#endif

/* Defines */
#define UNUSED __attribute__((unused))

/* Check if the bit BIT in FLAGS is set. */
#define CHECK_FLAG(flags,bit) ((flags) & (1 << (bit)))

/* Functions */
//void kernel_init(multiboot_info_t *mbi, unsigned long magic);
//void kernel_init(uint32_t magic, uint64_t address);
//void kernel_init(uint32_t magic, uint32_t address);
//void kernel_init(uint64_t address);
void kernel_init(void);
void kernel_main(void);

#endif
