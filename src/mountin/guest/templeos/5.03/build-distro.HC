Option(0, 0);
"MOUNTIN: bootstrap ready\n";

DelTree("/0000Boot");
DelTree("/Adam");
DelTree("/Apps");
DelTree("/Compiler");
DelTree("/Demo");
DelTree("/Doc");
DelTree("/Downloads");
DelTree("/Kernel");
DelTree("/Misc");
CopyTree("U:/0000Boot", "/0000Boot");
CopyTree("U:/Adam", "/Adam");
CopyTree("U:/Apps", "/Apps");
CopyTree("U:/Compiler", "/Compiler");
CopyTree("U:/Demo", "/Demo");
CopyTree("U:/Doc", "/Doc");
CopyTree("U:/Downloads", "/Downloads");
CopyTree("U:/Kernel", "/Kernel");
CopyTree("U:/Misc", "/Misc");
I64 mountin_kernel_header_size;
U8 *mountin_kernel_header = FileRead("/Kernel/KernelA.HH",
      &mountin_kernel_header_size);
U8 *mountin_compatible_header = MStrPrint(
      "%s\nextern I64 AIWNIOS_SetJmp(I64 *);\nextern U0 EndCatch();\n",
      mountin_kernel_header);
FileWrite("/Kernel/KernelA.HH", mountin_compatible_header,
      StrLen(mountin_compatible_header));
Free(mountin_compatible_header);
Free(mountin_kernel_header);
Del("/0000Boot/0000Kernel.BIN.C");
Del("/Compiler/Compiler.BIN");
"MOUNTIN: TempleOS source staged\n";

Option(OPTf_WARN_PAREN, ON);
Option(OPTf_WARN_DUP_TYPES, ON);
DirMk("/Tmp");
DirMk("/Home");

#include "/Adam/Opt/Boot/BootDVDIns"
"MOUNTIN: DVD boot tools loaded\n";

#include "/MountinBuildKernel.HC"

if (Cmp("/Compiler/Compiler", "Compiler",, ':'))
  throw('Compiler');
if (!FileFind("/Compiler/Compiler.BIN"))
  throw('Compiler');
"MOUNTIN: TempleOS compiler built\n";

#include "/MountinPackageDistro.HC"
