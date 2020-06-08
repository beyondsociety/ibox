#include <bga.h>
#include <io.h>
#include <stdio.h>
#include <stdint.h>

void bga_init(void)
{
  printk("\nInitializing Bochs Graphics Adapter..\n");

  /* Wait a bit */
  for(volatile int32_t i = 0; i < 10000000; i++) { }

  if(VBE_DISPI_INDEX_ID > VBE_DISPI_ID5)
  {
    printk("You are using an outdated version of the Bochs VGA Bios or are not using a VM with BGA."
    " Please download the latest version of Bochs, or the latest Bochs VGA Bios.\n");
    return;
  }

  else
  {
     printk("Bochs Graphics Adaptor detected, Video mode: %d x %d", VBE_WIDTH, VBE_HEIGHT);
  }

  /* Wait a bit */
  for(volatile int32_t i = 0; i < 10000000; ++i) { }

  /* Set Bochs Video mode */
  BgaSetVideoMode(1024, 768, 32, false, true);
}

void BgaWriteRegister(uint16_t IndexValue, uint16_t DataValue)
{
  outportw(VBE_DISPI_IOPORT_INDEX, IndexValue);
  outportw(VBE_DISPI_IOPORT_DATA, DataValue);
}

uint16_t BgaReadRegister(uint16_t IndexValue)
{
  outportw(VBE_DISPI_IOPORT_INDEX, IndexValue);
  return inportw(VBE_DISPI_IOPORT_DATA);
}

uint32_t BgaIsAvailable(void)
{
  return (BgaReadRegister(VBE_DISPI_INDEX_ID) == VBE_DISPI_ID5);
}

void BgaSetVideoMode(uint16_t Width, uint16_t Height, uint16_t BitDepth, int32_t UseLinearFrameBuffer, int32_t ClearVideoMemory)
{
  BgaWriteRegister(VBE_DISPI_INDEX_ENABLE, VBE_DISPI_DISABLED);
  BgaWriteRegister(VBE_DISPI_INDEX_XRES, Width);
  BgaWriteRegister(VBE_DISPI_INDEX_YRES, Height);
  BgaWriteRegister(VBE_DISPI_INDEX_BPP, BitDepth);

  BgaWriteRegister(VBE_DISPI_INDEX_ENABLE, VBE_DISPI_ENABLED |
    (UseLinearFrameBuffer ? VBE_DISPI_LFB_ENABLED : 0) |
    (ClearVideoMemory ? 0 : VBE_DISPI_NOCLEARMEM));
}

void BgaSetBank(uint16_t BankNumber)
{
  BgaWriteRegister(VBE_DISPI_INDEX_BANK, BankNumber);
}

uint16_t GetResX(void)
{
  return BgaReadRegister(VBE_DISPI_INDEX_XRES);
}

uint16_t GetResY(void)
{
  return BgaReadRegister(VBE_DISPI_INDEX_YRES);
}

void Disable(void)
{
  BgaWriteRegister(VBE_DISPI_INDEX_ENABLE, VBE_DISPI_DISABLED);
}

/*uint64_t LFBAddr = 0;
uint64_t GetLFBAddr(void)
{
  return LFBAddr;
}*/
