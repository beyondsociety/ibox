#include <io.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

/* Video memory address */
// implicit conversion loses integer precision: 'int32_t' (aka 'int') to 'int8_t' (aka 'char') [-Werror, -Wconversion]
int32_t *video_memory = (int32_t *) 0xb8000; // Todo: figure out what type it needs to be for video memory, for now 'int32_t' 

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
          video_memory[i++] = 0x17;
     }
     
     /* Set the cursor to the upper-left corner of the screen */
     gotoxy(0, 0);
}

/* Moves the cursor */
void gotoxy(int32_t x, int32_t y)
{
     int32_t position = (y * 80) + x;

     outportb(0x3d4, 0x0f);
     outportb(0x3d5, (uint8_t) (position & 0xff));

     outportb(0x3d4, 0x0e);
     outportb(0x3d5, (uint8_t) ((position >> 8) & 0xff));

     /* Update coordinates */
     screen_x = x;
     screen_y = y;
}

/* Outputs a character on the screen */
int32_t putchar(int32_t c)
{
     int32_t video_index = 0;
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
                    screen_x--;

                    /* Overwrite last character */
                    video_index = ((screen_y * 80) + screen_x);
                    video_index <<= 1;
                    
                    video_memory[video_index] = ' ';
                    video_memory[video_index + 1] = 0x17; /* White text on blue background */

                    gotoxy(screen_x, screen_y);
                    break;
           
          /* Tabulator */
          case '\t':
               screen_x += 8;
               break;
           
          /* It's an ordinary character */
          default:
               video_index = ((screen_y * 80) + screen_x);
               video_index <<= 1; /* Multiply by 2 */

               video_memory[video_index] = c; /* Put c into video memory */
               video_memory[video_index + 1] = 0x17; /* White text on blue background */

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
     return 1;
}

/* Frontend for putchar() */
int32_t putc(int32_t c, UNUSED FILE *stream)
{
     int32_t i;
     i = putchar(c);
     return i;
}

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
