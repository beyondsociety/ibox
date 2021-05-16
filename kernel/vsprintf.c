#include <stdio.h>
//#include <stdarg.h>
#include <string.h>
#include <stdint.h>

/* Flags used in processing format string */
#define	PR_LJ 0x01 /* Left justify */
#define	PR_CA 0x02 /* Use A-F instead of a-f for hex */
#define	PR_SG 0x04 /* Signed numeric conversion (%d vs. %u) */
#define	PR_32 0x08 /* Long (32-bit) numeric conversion */
#define	PR_16 0x10 /* Short (16-bit) numeric conversion */
#define	PR_WS 0x20 /* PR_SG set and num was < 0 */
#define	PR_LZ 0x40 /* Pad left with '0' instead of ' ' */
#define	PR_FP 0x80 /* Pointers are far */

/* Largest number handled is 2^32-1, lowest radix handled is 8.
 * 2^32-1 in base 8 has 11 digits (add 5 for trailing NUL and for slop) */
#define	PR_BUFLEN 16

int do_printf(const int8_t *fmt, va_list args, fnptr_t fn, void *ptr)
{
  unsigned flags, actual_wd, count, given_wd;
  int8_t *where, buffer[PR_BUFLEN];
  uint8_t state, radix;
  int64_t number;

  state = flags = count = given_wd = 0;

  /* Begin scanning format specifier list */
  for(; *fmt; fmt++)
  {
    switch(state)
    {
      /* STATE 0: AWAITING % */
      case 0:
        if(*fmt != '%') /* Not %... */
        {
          fn(*fmt, &ptr); /* Just echo it */
            count++;
          break;
        }

	      /* Found %, get next char and advance state to check if next char is a flag */
        state++;
          fmt++;
        // break;

      /* STATE 1: AWAITING FLAGS (%-0) */
      case 1:
        if(*fmt == '%') /* %% */
        {
          fn(*fmt, &ptr);
            count++;
              state = flags = given_wd = 0;
            break;
        }

	      if(*fmt == '-')
        {
          if(flags & PR_LJ) /* %-- is illegal */
            state = flags = given_wd = 0;
			    else
            flags |= PR_LJ;
              break;
        }

          /* Not a flag char: advance state to check if it's field width */
          state++;

          /* Check now for '%0...' */
          if(*fmt == '0')
          {
            flags |= PR_LZ;
              fmt++;
          }

            // break;

        /* STATE 2: AWAITING (NUMERIC) FIELD WIDTH */
        case 2:
          if(*fmt >= '0' && *fmt <= '9')
            {
              given_wd = 10 * given_wd + (uint32_t)(*fmt - '0');
                break;
            }

            /* Not field width: advance state to check if it's a modifier */
            state++;
              // break;

        /* STATE 3: AWAITING MODIFIER CHARS (FNlh) */
        case 3:
          if(*fmt == 'F')
          {
            flags |= PR_FP;
              break;
          }

          if(*fmt == 'N')
		      {
	          break;
          }

          if(*fmt == 'l')
          {
	          flags |= PR_32;
              break;
          }

          if(*fmt == 'h')
          {
	          flags |= PR_16;
	            break;
          }

          /* Not modifier: advance state to check if it's a conversion char */
          state++;
            // break;

        /* STATE 4: AWAITING CONVERSION CHARS (Xxpndiuocs) */
        case 4:
          where = buffer + PR_BUFLEN - 1;
            *where = '\0';

          switch(*fmt)
          {
            case 'X':
              flags |= PR_CA;
                // break;

            /* xxx - Far pointers (%Fp, %Fn) not yet supported */
            case 'x':
            case 'p':
            case 'n':
              radix = 16;
                goto DO_NUM;
            case 'd':
            case 'i':
              flags |= PR_SG;
                break;
            case 'u':
              radix = 10;
                goto DO_NUM;
            case 'o':
              radix = 8;

/* Load the value to be printed. l = long = 32 bits */
DO_NUM:
  if(flags & PR_32)
    number = (int64_t) va_arg(args, uint64_t);

    /* H = short = 16 bits (signed or unsigned) */
    else if(flags & PR_16)
    {
      if(flags & PR_SG)
        number = (int32_t) va_arg(args, int32_t);
      else
        number = (int32_t) va_arg(args, int32_t);
    }

    /* No h nor l: sizeof(int) bits (signed or unsigned) */
    else
    {
      if(flags & PR_SG)
        number = va_arg(args, int32_t);
      else
        number = va_arg(args, int64_t);
    }

    /* Take care of sign */
    if(flags & PR_SG)
    {
      if(number < 0)
      {
        flags |= PR_WS;
          number = -number;
      }
    }

    /* Convert binary to octal / decimal / hex ASCII
     * OK, I found my mistake. The math here is _always_ unsigned */
    do
    {
      uint64_t temp;
        temp = (uint64_t) number % radix;
          where--;

        if(temp < 10)
          *where = (int8_t)(temp + '0');
			  else if(flags & PR_CA)
          *where = (int8_t)(temp - 10 + 'A');
			  else
          *where = (int8_t)(temp - 10 + 'a');
            number = (int64_t) number / radix;
    }

    while(number != 0);
      goto EMIT;

    case 'c':
      /* Disallow pad-left-with-zeroes for %c */
      flags &= (uint32_t)(~PR_LZ);
        where--;
          *where = (int8_t)va_arg(args, int32_t);
            actual_wd = 1;
          goto EMIT2;

      case 's':
        /* Disallow pad-left-with-zeroes for %s */
        flags &= (uint32_t)(~PR_LZ);
          where = va_arg(args, int8_t *);

EMIT:
  actual_wd = strlen(where);
  if(flags & PR_WS)
  {
    actual_wd++;
  }

  /* If we pad left with ZEROES, do the sign now */
  if((flags & (PR_WS | PR_LZ)) == (PR_WS | PR_LZ))
  {
    fn('-', &ptr);
      count++;
  }

/* Pad on left with spaces or zeroes (for right justify) */
EMIT2:
  if((flags & PR_LJ) == 0)
  {
    while(given_wd > actual_wd)
    {
      fn(flags & PR_LZ ?
      '0' : ' ', &ptr);

      count++;
        given_wd--;
    }
  }

  /* If we pad left with SPACES, do the sign now */
  if((flags & (PR_WS | PR_LZ)) == PR_WS)
  {
    fn('-', &ptr);
      count++;
  }

  /* Emit string/char/converted number */
  while(*where != '\0')
  {
    fn(*where++, &ptr);
      count++;
  }

  /* Pad on right with spaces (for left justify) */
  if(given_wd < actual_wd)
    given_wd = 0;
  else given_wd -= actual_wd;

  for(; given_wd; given_wd--)
  {
    fn(' ', &ptr);
      count++;
  }
    break;

    default:
      break;
      }
        default:
          state = flags = given_wd = 0;
        break;
      }
  }
  return (int32_t) count;
}
