#include <io.h>
#include <stdint.h>

uint8_t inportb(uint16_t port)
{
     uint8_t return_value;
     __asm__ volatile("inb %1, %0" : "=a" (return_value) : "Nd" (port));
     return return_value;
}

uint16_t inportw(uint16_t port)
{
     uint16_t return_value;
     __asm__ volatile("inw %1, %0" : "=a" (return_value) : "Nd" (port));
     return return_value;
}

uint32_t inportl(uint16_t port)
{
     uint32_t return_value;
     __asm__ volatile("inl %1, %0" : "=a" (return_value) : "Nd" (port));
     return return_value;
}

void outportb(uint16_t port, uint8_t value)
{
     __asm__ volatile("outb %0, %1" :: "a" (value), "Nd" (port));
}

void outportw(uint16_t port, uint16_t value)
{
     __asm__ volatile("outw %0, %1" :: "a" (value), "Nd" (port));
}

void outportl(uint16_t port, uint32_t value)
{
     __asm__ volatile("outl %0, %1" :: "a" (value), "Nd" (port));
}

/* Enable interrupts */
void sti(void)
{
     __asm__ volatile("sti"); 
}

/* Disable interrupts */
void cli(void)
{
     __asm__ volatile("cli"); 
}

/* Halt the CPU */
void hlt(void)
{
     __asm__ volatile("hlt"); 
}	

void idle(void)
{
     cli(); hlt();
}



