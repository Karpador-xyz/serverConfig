{ pkgs, config, ... }:
{
  # postgres itself
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    # optimize properly for zfs
    settings = {
      full_page_writes = "off";
      wal_init_zero = "off";
      wal_recycle = "off";
    };
    ensureDatabases = [ "gotosocial" "nextcloud" ];
    ensureUsers = [
      {
        name = "gotosocial";
        ensureDBOwnership = true;
      }
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };
  fileSystems."/var/lib/postgresql" = {
    device = "zroot/DATA/postgres";
    fsType = "zfs";
  };

  # postgres backups
  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    compression = "none";
    startAt = "*-*-* *:50:00";
  };
  fileSystems."${config.services.postgresqlBackup.location}" = {
    device = "zroot/DATA/pgbackup";
    fsType = "zfs";
  };
}
