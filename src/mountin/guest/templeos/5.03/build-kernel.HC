Option(0, 0);

"MOUNTIN: TempleOS kernel compile starting\n";
Option(OPTf_RAW_AOT,ON);
Option(OPTf_NATIVE_BIN_SIGNATURE,ON);
I64 mountin_kernel_errors=Cmp("/Kernel/Kernel");
Option(OPTf_RAW_AOT,OFF);
Option(OPTf_NATIVE_BIN_SIGNATURE,OFF);
"MOUNTIN: TempleOS kernel compile returned %d\n",mountin_kernel_errors;
if (mountin_kernel_errors)
  throw('Kernel');
Move("/Kernel/Kernel.BIN.Z", BOOT_DIR_KERNEL_BIN_C);
if (!FileFind(BOOT_DIR_KERNEL_BIN_C))
  throw('Kernel');
"MOUNTIN: TempleOS kernel built\n";
