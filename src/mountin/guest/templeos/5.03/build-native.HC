Option(0, 0);

#include "/Adam/Opt/Boot/BootDVDIns"
"MOUNTIN: DVD boot tools loaded\n";

U8 *MountinFunAddress(CHash *symbol)
{
  if (!symbol)
    return NULL;
  if (symbol->type & HTT_FUN)
    return symbol(CHashFun *)->exe_addr;
  if (symbol->type & HTT_EXPORT_SYS_SYM)
    return symbol(CHashExport *)->val;
  return NULL;
}

CHash *mountin_old_cmp_symbol = HashFind("Cmp", Fs->hash_table,
      HTT_FUN | HTT_EXPORT_SYS_SYM);
U8 *mountin_old_cmp = MountinFunAddress(mountin_old_cmp_symbol);
if (!mountin_old_cmp)
  throw('Compiler');

if (!Load("/Compiler/Compiler", LDF_SILENT))
  throw('Compiler');

CHash *mountin_native_cmp_symbol = HashFind("Cmp", Fs->hash_table,
      HTT_FUN | HTT_EXPORT_SYS_SYM);
U8 *mountin_native_cmp_address = MountinFunAddress(mountin_native_cmp_symbol);
if (!mountin_native_cmp_address ||
      mountin_native_cmp_address == mountin_old_cmp)
  throw('Compiler');

I64 (*mountin_native_cmp)(U8 *, U8 *, U8 *, I64) =
      mountin_native_cmp_address;
"MOUNTIN: TempleOS compiler loaded\n";

#include "/MountinBuildKernel.HC"
#include "/MountinPackageDistro.HC"
