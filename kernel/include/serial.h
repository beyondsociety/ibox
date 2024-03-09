#ifndef INCLUDE_SERIAL_H
#define INCLUDE_SERIAL_H

/* Defines */
#define PORT 0x3f8   // COM1

/* Functions */
void init_serial();
int serial_received();
char read_serial();
int is_transmit_empty();
void write_serial(char a);
void serial_print(const char * data);

#endif
