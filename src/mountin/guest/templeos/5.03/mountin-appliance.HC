#include "/Temple9P"

extern U0 RedSeaInit(CDrv *drive);
extern Bool RedSeaValidate(U8 drive_letter);

Bool MountinMountRawRedSea()
{
  CBlkDev *device=BlkDevNextFreeSlot('C',BDT_ATA);
  CDrv *drive;

  device->base0=0x1F0;
  device->base1=0x3F4;
  device->unit=0;
  if (!BlkDevAdd(device,,TRUE,FALSE))
    return FALSE;

  drive=Let2Drv('C');
  RedSeaInit(drive);
  return RedSeaValidate(Drv2Let(drive));
}

try {
  if (!MountinMountRawRedSea())
    throw('Disk',TRUE);
  OutU8(0xE9,'R');
  OutU8(0xE9,'E');
  OutU8(0xE9,'A');
  OutU8(0xE9,'D');
  OutU8(0xE9,'Y');
  Temple9P("C:/",0x3F8);
} catch {
  Fs->catch_except=TRUE;
  OutU8(0xE9,'F');
  OutU8(0xE9,'A');
  OutU8(0xE9,'I');
  OutU8(0xE9,'L');
}

while (TRUE)
  Yield;
