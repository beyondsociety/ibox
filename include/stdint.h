#ifndef _STDINT_H
#define _STDINT_H

/*************************************************************************
 * stdint.h - Standard C++ integral types 
 *************************************************************************/

/* 7.18.1.1  Exact width integer types */
typedef char                 int8_t;
typedef unsigned char        uint8_t;

typedef short                int16_t;
typedef unsigned short       uint16_t;

typedef int                  int32_t;
typedef unsigned int         uint32_t;

/* 32 bit on IPL32 systems*/
//typedef long                 int64_t;
//typedef unsigned long        uint64_t;

/* 64 bit on IPL64 systems */
typedef long                 int64_t;
typedef unsigned long        uint64_t;

//typedef long long            int64_t;
//typedef unsigned long long   uint64_t;

/* 7.18.1.4  Integer types capable of holding object pointers */
typedef int intptr_t;
typedef uint64_t uintptr_t;

/* Standard size_t type */
//typedef unsigned size_t;

#define NULL (void *) 0
//typedef int bool;

/************************************************************************
 * END stdint.h 
 ************************************************************************/
#endif
