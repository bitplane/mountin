// Non-interactive equivalent of TempleOS's standard DVD configuration.

#define CFG_MEM_INIT        0
#define CFG_HEAP_INIT       1
#define CFG_VAR_INIT        2
#define CFG_STAFF_MODE      3
#define CFG_HOME_DIR        4
#define CFG_NO_MP           5
#define CFG_TEXT_MODE       6
#define CFG_DONT_PROBE      7
#define CFG_MOUNT_IDE_AUTO  8
#define CFG_DBG_DISTRO      9
#define CFG_OPTIONS_NUM    10

class CKCfg
{
  U8 *dsk_cache_size_exp;
  CDoc *add_dev;
  U8 *dbg_distro_file,*dbg_distro_start;
  U8 *home_dir;
  Bool opts[CFG_OPTIONS_NUM];
  U8 mem_init_val,heap_init_val,var_init_val,
    boot_drv_let,mount_ide_auto_hd_let,mount_ide_auto_cd_let;
};

CKCfg *KCfgNew()
{
  CKCfg *c=CAlloc(sizeof(CKCfg));
  c->boot_drv_let='T';
  c->home_dir=StrNew("::/Home");
  c->dsk_cache_size_exp=StrNew("Scale2Mem(2048,0x40000)");
  return c;
}

U0 KCfgDel(CKCfg *c)
{
  Free(c->dbg_distro_file);
  Free(c->home_dir);
  Free(c->dsk_cache_size_exp);
  Free(c);
}
