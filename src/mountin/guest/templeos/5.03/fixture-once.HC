U8 *contents;

OutU8(0xE9,'S');
Fmt('C',TRUE,FALSE,FSt_REDSEA);
OutU8(0xE9,'F');
CopyTree("T:/MountinFixtureData","C:/");
OutU8(0xE9,'C');
contents=FileRead("C:/hello.txt");
if (!contents || StrCmp(contents,"Hello, world!\n"))
  throw('Test',TRUE);
Free(contents);
OutU8(0xE9,'D');
OutU8(0xE9,'O');
OutU8(0xE9,'N');
OutU8(0xE9,'E');
while (TRUE)
  Yield;
