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
Del("/0000Boot/0000Kernel.BIN.C");
Del("/Compiler/Compiler.BIN");
"MOUNTIN: TempleOS source staged\n";

#include "/Kernel/KernelA.HH"
#include "/Compiler/CompilerA.HH"
#include "/Kernel/KernelB.HH"
#include "/Kernel/KernelC.HH"
#include "/Compiler/CompilerB.HH"
"MOUNTIN: TempleOS headers loaded\n";

Option(OPTf_WARN_PAREN, ON);
Option(OPTf_WARN_DUP_TYPES, ON);
HashTablePurge(adam_task->hash_table);

#include "/Adam/MakeAdam"
"MOUNTIN: Adam built\n";

DocTermNew;
WinVert(2, 10);
DirMk("/Tmp");
DirMk("/Home");

#include "/Adam/Opt/Boot/MakeBoot"
#include "/Misc/DoDistro"
