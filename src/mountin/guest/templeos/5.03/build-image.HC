Option(0, 0);

#include "/Adam/Opt/Boot/BootDVDIns"
"MOUNTIN: DVD boot tools loaded\n";
Option(OPTf_TEMPLEOS_BIN_SIGNATURE,ON);

#include "/MountinBuildKernel.HC"
#include "/MountinPackageDistro.HC"
