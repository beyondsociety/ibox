#include <kernel.h>
#include <multiboot.h>
#include <stddef.h>
#include <stdint.h>

/* Perform some preloading stuff */
void kernel_init(UNUSED multiboot_info_t *mbi, UNUSED uint32_t magic)
{
  for(;;);
}
