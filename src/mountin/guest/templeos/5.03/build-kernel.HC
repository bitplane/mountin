Option(0, 0);

"MOUNTIN: TempleOS kernel compile starting\n";
I64 mountin_kernel_errors=(*mountin_native_cmp)("/Kernel/Kernel",
      NULL, NULL, 0);
"MOUNTIN: TempleOS kernel compile returned %d\n",mountin_kernel_errors;
if (mountin_kernel_errors)
  throw('Kernel');
Move("/Kernel/Kernel.BIN.Z", BOOT_DIR_KERNEL_BIN_C);
if (!FileFind(BOOT_DIR_KERNEL_BIN_C))
  throw('Kernel');
"MOUNTIN: TempleOS kernel built\n";
