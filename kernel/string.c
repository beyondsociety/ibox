/* String stuff */
#include <stdarg.h>
#include <string.h>

/* Convert an integer into a string */
/*int8_t *itoa(int32_t n, int8_t *s, int32_t base)
{
  int32_t j, i = 0;
  int32_t temp[20];
  int32_t digit;

  do
  {
    j = n;
    n /= base; // Divide number by base
    n *= base; // Multiply number by base to isolate the digit
    digit = j - n;

    // Change the numerical digit to printable ASCII value
    if(digit <= 9)
    {
      temp[i] = digit + '0';
    }

    else
    {
      temp[i] = digit - 0x0A + 'A';
    }

    n /= base; // Divide number by base again to get to the next digit
    i++;
  }

  while(n != 0);
  temp[i] = '\0'; // Add the terminator

  // Reserve the string
  j = strlen(temp) - 1;

  for(i = 0; i < strlen(temp); i++)
  {
    s[i] = temp[j];
    j--; // Decrement j while incrementing i
  }

  s[i] = '\0'; // Terminate the string 
} */

/* Convert n to characters in s */
void itoa(int32_t n, int8_t s[])
{
	int i, sign;

  if ((sign = n) < 0)  /* Record sign */
  {
    n = -n;           /* Make n positive */
    i = 0;
  }

	do
	{                          /* Generate digits in reverse order */
    s[i++] = n % 10 + '0';   /* Get next digit */
  }

	while ((n /= 10) > 0);     /* Delete it */
	if (sign < 0)
      s[i++] = '-';
    s[i] = '\0';
    reverse(s);
}

/* Reverse string s in place */
void reverse(int8_t s[])
{
	unsigned int i, j;
  char c;

  for (i = 0, j = strlen(s)-1; i<j; i++, j--)
	{
    c = s[i];
    s[i] = s[j];
    s[j] = c;
  }
}

/* Returns length of a string */
size_t strlen(const int8_t *str)
{
  size_t len = 0;
  while(*str != '\0')
  {
    str++;
    len++;
  }

  return len;
}

/* Compares first number of characters of two strings */
int32_t strncmp(const int8_t *s1, const int8_t *s2, size_t n)
{
  size_t i = 1;

  for(; *s1 == *s2 && i <= n; s1++, s2++, i++)
  if(i == n)
  {
    return 0; /* Equal */
  }

  return *s1 - *s2;
}

/* Compares two strings */
int32_t strcmp(const int8_t *s1, const int8_t *s2)
{
  for(; *s1 == *s2; s1++, s2++)
  if(*s1 == '\0')
  {
    return 0;         /* Equal */
  }

  return *s1 - *s2;
}

/* Adds source to destination */
int8_t *strcat(int8_t *dest, const int8_t *src)
{
  for(; *dest != '\0'; dest++); /* Go through destination until we reach a NULL */
  while(*src != '\0')
  {
    *(dest++) = *(src++);
    *dest = '\0';
  }

  return dest;
}

/* Adds number of characters of source to destination */
int8_t *strncat(int8_t *dest, const int8_t *src, size_t n)
{
  for(; *dest != '\0'; dest++); /* Go through destination until we reach a NULL */
  while(*src != '\0' && n-- > 0)
  {
    *(dest++) = *(src++);
    *dest = '\0';
  }

  return dest;
}

/* Copies source to destination */
int8_t *strcpy(int8_t *dest, const int8_t *src)
{
  const char *s = src;
  char *d = dest;

  while(*s != '\0')
  {
    *(d++) = *(s++);
  }

  return dest;
}

/* Copies number of bytes from source to destination */
void *memcpy(void *str1, const void *str2, size_t num)
{
  char *to = (char*) str1, *from = (char*) str2;
  while(num-- > 0)
  {
    *(to++) = *(from++);
  }

  return str1;
}

/* Fills the first number of bytes of string with the constant byte c */
void *memset(void *str, UNUSED int8_t val, size_t num)
{
  size_t *temp = (size_t *) str;
  for(; num != 0; num--) *temp++ = num;
  return str;
}
