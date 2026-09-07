#define MOUNTIN_UART_BASE 0x3F8
#define MOUNTIN_UART_DATA 0
#define MOUNTIN_UART_IER  1
#define MOUNTIN_UART_FCR  2
#define MOUNTIN_UART_LCR  3
#define MOUNTIN_UART_MCR  4
#define MOUNTIN_UART_LSR  5

extern U0 RedSeaInit(CDrv *drive);
extern Bool RedSeaValidate(U8 drive_letter);

U0 MountinUARTInit()
{
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_IER,0);
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_LCR,0x80);
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_DATA,1);
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_IER,0);
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_LCR,3);
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_FCR,0xC7);
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_MCR,0x0B);
}

U0 MountinUARTPut(U8 value)
{
  while (!(InU8(MOUNTIN_UART_BASE+MOUNTIN_UART_LSR)&0x20))
    Yield;
  OutU8(MOUNTIN_UART_BASE+MOUNTIN_UART_DATA,value);
}

U8 MountinUARTGet()
{
  while (!(InU8(MOUNTIN_UART_BASE+MOUNTIN_UART_LSR)&1))
    Yield;
  return InU8(MOUNTIN_UART_BASE+MOUNTIN_UART_DATA);
}

U0 MountinUARTPutS(U8 *text)
{
  while (*text)
    MountinUARTPut(*text++);
}

Bool MountinMountRawRedSea()
{
  CBlkDev *device=BlkDevNextFreeSlot('C',BDT_ATA);
  CDrv *drive;

  device->base0=0x1F0;
  device->base1=0x3F6;
  device->unit=0;
  if (!BlkDevAdd(device,,TRUE,FALSE))
    return FALSE;

  drive=Let2Drv('C');
  RedSeaInit(drive);
  return RedSeaValidate(Drv2Let(drive));
}

Bool MountinCheckFixture()
{
  U8 *contents;
  Bool result;

  if (!MountinMountRawRedSea())
    return FALSE;
  contents=FileRead("C:/hello.txt");
  result=contents && !StrCmp(contents,"Hello, world!\n");
  Free(contents);
  return result;
}

U0 MountinSerialProof()
{
  U8 challenge[8];
  I64 index;

  challenge[0]=0x00;
  challenge[1]=0x01;
  challenge[2]=0x7F;
  challenge[3]=0x80;
  challenge[4]=0xFE;
  challenge[5]=0xFF;
  challenge[6]=0x55;
  challenge[7]=0xAA;

  MountinUARTPutS("MOUNTIN: SERIAL READY\n");
  for (index=0;index<sizeof(challenge);index++)
    if (MountinUARTGet()!=challenge[index]) {
      MountinUARTPutS("MOUNTIN: SERIAL FAILED\n");
      return;
    }
  for (index=0;index<sizeof(challenge);index++)
    MountinUARTPut(challenge[index]^0xA5);
  MountinUARTPutS("MOUNTIN: SERIAL COMPLETE\n");
}

MountinUARTInit;
try {
  if (MountinCheckFixture()) {
    MountinUARTPutS("MOUNTIN: REDSEA COMPLETE\n");
    MountinSerialProof;
  } else
    MountinUARTPutS("MOUNTIN: REDSEA FAILED\n");
} catch {
  Fs->catch_except=TRUE;
  MountinUARTPutS("MOUNTIN: REDSEA FAILED\n");
}

while (TRUE)
  Yield;
