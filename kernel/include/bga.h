#ifndef INCLUDE_BGA_H
#define INCLUDE_BGA_H

/* Headers */
#include <stdint.h>

/* BGA VBE Flags */
#define VBE_DISPI_IOPORT_INDEX      0x01CE
#define VBE_DISPI_IOPORT_DATA       0x01CF

#define VBE_DISPI_INDEX_ID          0x00
#define VBE_DISPI_INDEX_XRES        0x01
#define VBE_DISPI_INDEX_YRES        0x02
#define VBE_DISPI_INDEX_BPP         0x03 
#define VBE_DISPI_INDEX_ENABLE      0x04
#define VBE_DISPI_INDEX_BANK        0x05
#define VBE_DISPI_INDEX_VIRT_WIDTH  0x06
#define VBE_DISPI_INDEX_VIRT_HEIGHT 0x07
#define VBE_DISPI_INDEX_X_OFFSET    0x08
#define VBE_DISPI_INDEX_Y_OFFSET    0x09

#define VBE_DISPI_DISABLED          0x00
#define VBE_DISPI_ENABLED           0x01
#define VBE_DISPI_GETCAPS           0x02
#define VBE_DISPI_8BIT_DAC          0x20
#define VBE_DISPI_LFB_ENABLED       0x40
#define VBE_DISPI_NOCLEARMEM        0x80

/* Bochs BGA Version */
#define VBE_DISPI_ID5               0xB0C5 

/* Different Bit Per Pixels */
#define VBE_DISPI_BPP_4             0x04
#define VBE_DISPI_BPP_8             0x08
#define VBE_DISPI_BPP_15            0x0F
#define VBE_DISPI_BPP_16            0x10
#define VBE_DISPI_BPP_24            0x18
#define VBE_DISPI_BPP_32            0x20 

/* VBE Resolution */
#define VBE_WIDTH  1024
#define VBE_HEIGHT 768

/* For BGA Set Video-mode function */
#define true 1
#define false 0

/* BGA Functions */
uint16_t GetResX(void);
uint16_t GetResY(void);
uint64_t GetLFBAddr(void);
uint32_t BgaIsAvailable(void);
uint16_t BgaReadRegister(uint16_t IndexValue);

void Disable(void);
void bga_init(void);
void BgaSetBank(uint16_t BankNumber);
void BgaWriteRegister(uint16_t IndexValue, uint16_t DataValue);
void BgaSetVideoMode(uint16_t Width, uint16_t Height, uint16_t BitDepth, int32_t UseLinearFrameBuffer, int32_t ClearVideoMemory);

#endif
