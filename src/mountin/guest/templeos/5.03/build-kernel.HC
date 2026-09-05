"MOUNTIN: TempleOS kernel compile starting\n";
I64 mountin_kernel_opts=0;
Bts(&mountin_kernel_opts,OPTf_RAW_AOT);
Bts(&mountin_kernel_opts,OPTf_TEMPLEOS_BIN_SIGNATURE);
Bts(&mountin_kernel_opts,OPTf_X86_SSE_RUNTIME);
I64 mountin_kernel_errors=Cmp("/MountinKernelSource.HC","Kernel",
      "/Kernel/Kernel",':',mountin_kernel_opts);
"MOUNTIN: TempleOS kernel compile returned %d\n",mountin_kernel_errors;
if (mountin_kernel_errors)
  throw('Kernel');
Move("/Kernel/Kernel.BIN.Z", BOOT_DIR_KERNEL_BIN_C);
if (!FileFind(BOOT_DIR_KERNEL_BIN_C))
  throw('Kernel');
"MOUNTIN: TempleOS kernel built\n";
