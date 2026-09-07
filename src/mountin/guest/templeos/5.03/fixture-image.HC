Option(0,0);
#include "/Adam/Opt/Boot/BootDVDIns"
#include "/Src/MakeISOFile.HC"

Copy("/MountinFixtureOnce.HC","/Distro/Once.HC");
CopyTree("/MountinFixtureData","/Distro/MountinFixtureData");
RedSeaISO("T:/Tmp/MountinFixture.ISO.C","/Distro",
  "/Distro" BOOT_DIR_KERNEL_BIN_C);
"MOUNTIN: fixture boot image complete\n";
Exit;
