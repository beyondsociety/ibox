/* Print stuff */
#include <kernel.h>
#include <io.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

/* Video memory address */
uint8_t *video_memory = (uint8_t *) 0xb8000;

/* Screen coordinates */
int32_t screen_x, screen_y;

/* Clears the screen */
void clear_screen(void)
{
  uint32_t i = 0;

  /* Fill the screen with background color */
  while(i < (80 * 25 * 2))
  {
    video_memory[i++] = ' ';  /* 0x20 */
    video_memory[i++] = 0x1F;
  }

  /* Set the cursor to the upper-left corner of the screen */
  gotoxy(0, 0);
}

/* Moves the cursor */
void gotoxy(int32_t x, int32_t y)
{
  uint16_t position = (uint16_t)(y * 80 + x);

  outportb(0x3d4, 0x0f);
  outportb(0x3d5, (uint8_t)(position & 0xff));

  outportb(0x3d4, 0x0e);
  outportb(0x3d5, (uint8_t)((position >> 8) & 0xff));

  /* Update coordinates */
  screen_x = x;
  screen_y = y;
}

/* Outputs a character on the screen */
int32_t putchar(int32_t c)
{
  uint32_t video_index = 0;

  switch(c)
  {
    /* New line */
    case '\n':
    case '\r':
      screen_x = 0;
      screen_y++;
        break;

    /* Backspace */
    case '\b':
      if(screen_x == 0)
      {
        screen_y--;
        screen_x = 79;
      }

      else
	    {
        screen_x--;

        /* Overwrite last character */
        video_index = (uint32_t)((screen_y * 80) + screen_x);
        video_index <<= 1;

        video_memory[video_index] = ' ';
        video_memory[video_index + 1] = 0x1F; /* White text on blue background */

        gotoxy(screen_x, screen_y);
        break;
	    }

      break;

      /* Tabulator */
      case '\t':
        screen_x += 8;
        break;

      /* It's an ordinary character */
      default:
        video_index = (uint32_t)((screen_y * 80) + screen_x);
        video_index <<= 1; /* Multiply by 2 */

        video_memory[video_index] = (uint8_t) c; /* Put c into video memory */
        video_memory[video_index + 1] = 0x1F; /* White text on blue background */

        /* Update coordinates */
        screen_x++;
        break;
  }

  /* Check if line is full */
  if (screen_x > 79)
  {
    screen_x = 0;
    screen_y++;
  }

  /* Check if we are at the bottom of the screen */
  if (screen_y > 24)
  {
    /* Copy all lines one up */
    memcpy(video_memory, (void *) (0xb8000 + (80 * 2)), 24 * 80 * 2);

    /* Clear the last line */
    memset((void *) (0xb8000 + (24 * 80 * 2)), 0x00, 80);
    screen_y = 24;
  }

  /* Now update the cursor */
  gotoxy(screen_x, screen_y);

  /* For the moment, putch() always returns 1 which means everything is fine */
  return 0;
}

/* Frontend for putchar() */
int32_t putc(int32_t c, UNUSED FILE *stream)
{
  int32_t i;
  i = putchar(c);
  return i;
}
  
/*int my_printf(const char *format, ...)*/
/*{*/
/*    va_list args;*/
/*    va_start(args, format);*/
/**/
/*    int i = 0;*/
/*    while(format[i])*/
/*    {*/
/*        if(format[i] == '%')*/
/*        {*/
/*            i++;*/
/**/
/*            switch(format[i])*/
/*            {*/
/*                case 'd':*/
/*                {*/
/*                    int x = va_arg(args, int);*/
/*                    //printf("%d", x);*/
/*                    break;*/
/*                }*/
/**/
/*                case 'f':*/
/*                {*/
/*                    double x = va_arg(args, double);*/
/*                    //printf("%f", x);*/
/*                    break;*/
/*                }*/
/**/
/*                case 'c':*/
/*                {*/
/*                    int x = va_arg(args, int);*/
/*                    //printf("%c", x);*/
/*                    break;*/
/*                }*/
/**/
/*                case 's':*/
/*                {*/
/*                    char *x = va_arg(args, char*);*/
/*                    //printf("%s", x);*/
/*                    break;*/
/*                }*/
/**/
/*                case 'x':*/
/*                case 'X':*/
/*                {*/
/*                    int x = va_arg(args, int);*/
/*                    //printf("%x", x);*/
/*                    break;*/
/*                }*/
/**/
/*                case 'p':*/
/*                {*/
/*                    void *x = va_arg(args, void*);*/
/*                    //printf("%p", x);*/
/*                    break;*/
/*                }*/
/**/
/*                case '%':*/
/*                    putchar('%');*/
/*                    break;*/
/**/
/*                default:*/
/*                    putchar(format[i]);*/
/*                    break;*/
/*            }*/
/*        }*/
/**/
/*        else*/
/*        {*/
/*            putchar(format[i]);*/
/*        }*/
/**/
/*        i++;*/
/*    }*/
/**/
/*    va_end(args);*/
/*    return 0;*/
/*}*/

/* Prints a message to the screen */
int32_t printk(const int8_t *fmt, ...)
{
  va_list args;
  int rv;

  va_start(args, fmt);
  rv = vprintf(fmt, args);
  va_end(args);
  return rv;
}

int32_t vprintf(const int8_t *fmt, va_list args)
{
  return do_printf(fmt, args, vprintf_help, NULL);
}

int32_t vprintf_help(signed c, UNUSED void *ptr)
{
  putchar(c);
  return 0;
}
