{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    # optimize properly for zfs
    settings = {
      full_page_writes = "off";
      wal_init_zero = "off";
      wal_recycle = "off";
    };
    ensureDatabases = [ "gotosocial" ];
    ensureUsers = [
      {
        name = "gotosocial";
        ensureDBOwnership = true;
      }
    ];
  };
  fileSystems."/var/lib/postgresql" = {
    device = "zroot/DATA/postgres";
    fsType = "zfs";
  };
}
