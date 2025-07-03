{ ... }:
{
  # TODO implement backup timer
  fileSystems."/opt/backups" = {
    device = "zroot/data/mailcow/backups";
    fsType = "zfs";
  };
}
