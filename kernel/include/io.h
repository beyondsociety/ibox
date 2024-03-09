/* Port I/O stuff */
#ifndef _IO_H
#define _IO_H

#include <stdint.h>

/* Get a byte from the selected port */
uint8_t inportb(uint16_t port);
uint16_t inportw(uint16_t port);
uint32_t inportl(uint16_t port);

/* Send the selected byte to the selected port */
void outportb(uint16_t port, uint8_t value);
void outportw(uint16_t port, uint16_t value);
void outportl(uint16_t port, uint32_t value);

/* Enable Interrupts */
void sti(void);

/* Disable Interrupts */
void cli(void);

/* Halt the CPU */
void hlt(void);

/* Idle the CPU */
void idle(void);

#endif

