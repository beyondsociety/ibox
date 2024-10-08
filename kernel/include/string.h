#ifndef INCLUDE_STRING_H
#define INCLUDE_STRING_H

#include <stddef.h>
#include <stdint.h>

#define UNUSED __attribute__((unused))

int8_t *itoa(int32_t, int8_t *, int32_t);
//void itoa(char *buf, int base, int d);
//void itoa(int n, char[]);

//void reverse(int8_t *);
void reverse(char s[]);

size_t strlen(const int8_t *str);
int32_t strcmp(const int8_t *, const int8_t *);
int32_t strncmp(const int8_t *, const int8_t *, size_t);

int8_t *strcat(int8_t *, const int8_t *);
int8_t *strncat(int8_t *, const int8_t *, size_t);
int8_t *strcpy(int8_t *, const int8_t *);

void *memcpy(void *, const void *, size_t num);
void *memset(void *str, UNUSED int8_t val, size_t num);

#endif
