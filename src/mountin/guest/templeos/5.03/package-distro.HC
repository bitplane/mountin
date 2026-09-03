Option(0, 0);

#include "/Src/MakeISOFile.HC"

DelTree("/Distro");
Del("T:/Tmp/MyDistro.ISO.C");
DirMk("/Distro");
Copy("/*", "/Distro");
Del("/Distro/" KERNEL_BIN_C);
CopyTree(BOOT_DIR, "/Distro" BOOT_DIR);
CopyTree("/Home", "/Distro/Home");
CopyTree("/Adam", "/Distro/Adam");
CopyTree("/Apps", "/Distro/Apps");
CopyTree("/Compiler", "/Distro/Compiler");
CopyTree("/Demo", "/Distro/Demo");
CopyTree("/Doc", "/Distro/Doc");
CopyTree("/Kernel", "/Distro/Kernel");
CopyTree("/Misc", "/Distro/Misc");
CopyTree("/Downloads", "/Distro/Downloads");
DirMk("/Distro/Tmp");
DirMk("/Distro/Tmp/ScrnShots");

I64 mountin_redsea_blocks = RedSeaISO("T:/Tmp/MyDistro.ISO.C", "/Distro",
  "/Distro" BOOT_DIR_KERNEL_BIN_C);
"MOUNTIN: RedSea data blocks %d\n", mountin_redsea_blocks;
