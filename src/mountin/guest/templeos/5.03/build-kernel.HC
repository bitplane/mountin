Option(0, 0);
Option(OPTf_RAW_AOT,ON);
Option(OPTf_TEMPLEOS_BIN_SIGNATURE,ON);

"MOUNTIN: TempleOS kernel compile starting\n";
I64 mountin_kernel_errors=Cmp("/MountinKernelSource.HC","Kernel",
      "/Kernel/Kernel",':');
"MOUNTIN: TempleOS kernel compile returned %d\n",mountin_kernel_errors;
if (mountin_kernel_errors)
  throw('Kernel');
Move("/Kernel/Kernel.BIN.Z", BOOT_DIR_KERNEL_BIN_C);
if (!FileFind(BOOT_DIR_KERNEL_BIN_C))
  throw('Kernel');
"MOUNTIN: TempleOS kernel built\n";
