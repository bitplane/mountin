Option(0, 0);
"MOUNTIN: bootstrap ready\n";

Copy("/MountinKernelConfig.HC", "/Kernel/KCfg.HC");
Del("/0000Boot/0000Kernel.BIN.C");
Del("/Compiler/Compiler.BIN");
"MOUNTIN: TempleOS source staged\n";

Option(OPTf_WARN_PAREN, ON);
Option(OPTf_WARN_DUP_TYPES, ON);
DirMk("/Tmp");
DirMk("/Home");

I64 mountin_compiler_opts=0;
Bts(&mountin_compiler_opts,OPTf_TEMPLEOS_BIN_SIGNATURE);
if (Cmp("/MountinBuildCompiler.HC", "Compiler",
      "/Compiler/Compiler", ':',mountin_compiler_opts))
  throw('Compiler');
if (!FileFind("/Compiler/Compiler.BIN"))
  throw('Compiler');
"MOUNTIN: TempleOS compiler built\n";
