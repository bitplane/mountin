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
Copy("/MountinKernelConfig.HC", "/Kernel/KCfg.HC");
Del("/0000Boot/0000Kernel.BIN.C");
Del("/Compiler/Compiler.BIN");
"MOUNTIN: TempleOS source staged\n";

Option(OPTf_WARN_PAREN, ON);
Option(OPTf_WARN_DUP_TYPES, ON);
DirMk("/Tmp");
DirMk("/Home");

Option(OPTf_TEMPLEOS_BIN_SIGNATURE,ON);
if (Cmp("/MountinBuildCompiler.HC", "Compiler",
      "/Compiler/Compiler", ':'))
  throw('Compiler');
if (!FileFind("/Compiler/Compiler.BIN"))
  throw('Compiler');
"MOUNTIN: TempleOS compiler built\n";
