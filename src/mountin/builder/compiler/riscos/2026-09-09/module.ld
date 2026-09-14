SECTIONS
{
  .riscos.module.header Module_LoadAddr :
  {
    KEEP(*(.riscos.module.header))
    KEEP(*("!Header$$code"))
  }
  .riscos.module.legacy :
  {
    KEEP(*("@MODULE_CODE_SECTION@"))
  }
  .text : { *(.text .text.*) }
  .rodata : { *(.rodata .rodata.*) }
  "Lib$$Init" : { *("Lib$$Init") }
  "Stub$$Code" : { *("Stub$$Code") }
  "Stub$$Entries" : { *("Stub$$Entries") }
  "Stub$$Init" : { *("Stub$$Init") }
  "Stub$$InitEnd" : { *("Stub$$InitEnd") }
  "C$$data" : { *("C$$data") }
  "Stub$$Data" : { *("Stub$$Data") }
  "RTSK$$Data" : { *("RTSK$$Data") }
  .data :
  {
    *(.data .data.*)
    *(.bss .bss.* COMMON)
    BYTE(0)
    . = ALIGN(4);
  }
  /DISCARD/ : { *(.comment .ARM.attributes) }
}

Image$$RO$$Base = Module_LoadAddr;
Image$$RO$$Limit = ADDR(C$$data);
Image$$RW$$Base = ADDR(C$$data);
Image$$RW$$Limit = ADDR(.data) + SIZEOF(.data);
Image$$ZI$$Base = Image$$RW$$Limit;
Image$$ZI$$Limit = Image$$RW$$Limit;
PROVIDE(RTSK$$Data$$Base = ADDR(RTSK$$Data));
PROVIDE(RTSK$$Data$$Limit = ADDR(RTSK$$Data) + SIZEOF(RTSK$$Data));
PROVIDE(Stub$$Init$$Base = ADDR(Stub$$Init));
PROVIDE(C$$code$$Base = ADDR(.riscos.module.header));
PROVIDE(C$$code$$Limit = ADDR(.text) + SIZEOF(.text));
PROVIDE(Lib$$Init$$Base = ADDR(Lib$$Init));
PROVIDE(Lib$$Init$$Limit = ADDR(Lib$$Init) + SIZEOF(Lib$$Init));
