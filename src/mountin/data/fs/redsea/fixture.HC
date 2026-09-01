#include "T:/Src/AiwniosPack.HC"

U0 MountinFixture()
{
  U8 *image = RamDiskImage("T:/MountinFixture");
  I64 image_size = MSize(image);
  FileWrite("T:/basic.redsea", image, image_size);

  CDrv *drive = MountRamDisk(image, image_size);
  U8 path[STR_LEN], *contents;
  StrPrint(path, "%C:/hello.txt", drive->drv_let);
  contents = FileRead(path);

  if (!contents || StrCmp(contents, "Hello, world!\n"))
    throw('Test');

  Free(contents);
  Cd("T:/");
  Unmount(drive->drv_let);
  Free(image);
  "RedSea fixture complete\n";
}

MountinFixture;
Exit;
