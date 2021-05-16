#ifndef INCLUDE_STDIO_H
#define INCLUDE_STDIO_H

#include <kernel.h>
#include <stdarg.h>
#include <stdint.h>

// Typedefs 
typedef struct _FILE FILE;
typedef int32_t (*fnptr_t)(signed c, void *ptr);

// Functions
int32_t putc(int32_t, UNUSED FILE *stream);
int32_t putchar(int32_t c);
int32_t printk(const int8_t *fmt, ...);

void clear_screen(void);
void gotoxy(int32_t x, int32_t y);
int do_printf(const int8_t *fmt, va_list args, fnptr_t fn, void *ptr);

int32_t vprintf(const int8_t *fmt, va_list args);
int32_t vprintf_help(signed c, void *ptr);

#endif
