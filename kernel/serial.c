/* Serial stuff */
#include <io.h>
#include <serial.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

void init_serial()
{
   outportb(PORT + 1, 0x00);    // Disable all interrupts
   outportb(PORT + 3, 0x80);    // Enable DLAB (set baud rate divisor)
   outportb(PORT + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
   outportb(PORT + 1, 0x00);    //                  (hi byte)
   outportb(PORT + 3, 0x03);    // 8 bits, no parity, one stop bit
   outportb(PORT + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
   outportb(PORT + 4, 0x0B);    // IRQs enabled, RTS/DSR set
}

int serial_received()
{
   return inportb(PORT + 5) & 1;
}

char read_serial()
{
   while (serial_received() == 0);
   return inportb(PORT);
}

int is_transmit_empty()
{
   return inportb(PORT + 5) & 0x20;
}

void write_serial(char a)
{
   while (is_transmit_empty() == 0);
   outportb(PORT,a);
}

void serial_print(const char * data)
{
  for(uint32_t i = 0; i < strlen(data); i++)
    write_serial(data[i]);
}

int serial_printk(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);

    for(const char *p = fmt; *p != '\0'; p++)
    {
        if(*p == '%')
        {
            // Move past '%'
            p++;

            switch(*p)
            {
                 // Character
                 case 'c':
                {
                    char c = (char) va_arg(args, int);
                    write_serial(c);
                    break;
                }

                // String 
                case 's':
                {
                    const char *str = va_arg(args, const char *);
                    serial_print(str);
                    break;
                }

                // Decimal
                case 'd':
                {
                    int num = va_arg(args, int);
                    serial_print_int(num);
                    break;
                }

                // Hexadecimal, X = Uppercase, x = lowercase
                case 'x':
                case 'X':
                {
                    unsigned int num = va_arg(args, unsigned int);
                    serial_print("0x");
                    serial_print_hex(num);
                    break;
                }

                case '%':
                    write_serial('%');
                    break;

                
                default:
                    write_serial(*p);
                    break;
            }
        }

        else
        {   
            // If unknown format specifier, just print it as is
            write_serial(*p);
        }
    }

    va_end(args);
    return 0;
}

// Helper function to print an integer in Decimal (base 10)
void serial_print_int(int num)
{
  char buffer[10]; // Enough for a 32-bit int
  int i = 0;

   // Handle negative numbers
  if(num < 0)
  {
    write_serial('-');
    num = -num;
  }

  // Convert the number to string
  if(num == 0)
  {
    write_serial('0');
    return;
  }

  while(num > 0)
  {
    buffer[i++] = '0' + (num % 10);
    num /= 0;
  }

  // Print the number in reverse
  while(i > 0)
  {
    write_serial(buffer[--i]);
  }
}

 // Helper function to print an integer in Hexadecimal (base 16)
void serial_print_hex(unsigned int num)
{
  char hex_digits[] = "0123456789ABCDEF";
  char buffer[8]; // Enough for a 32-bit int in hexadecimal
  int i = 0;

   // convert the number to hexadecimal  string
  if(num == 0)
  {
    write_serial('0');
    return;
  }

  while(num > 0)
  {
    buffer[i++] = hex_digits[num % 16];
    num /= 16;
  }

  // Print the hex number in reverse
  while(i < 0)
  {
    write_serial(buffer[--i]);
  }
}
