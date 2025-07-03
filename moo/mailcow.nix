{ ... }:
{
  fileSystems."/opt/mailcow-dockerized" = {
    device = "zroot/data/mailcow/repo";
    fsType = "zfs";
  };

  # TODO implement backup timer
  fileSystems."/opt/backups" = {
    device = "zroot/data/mailcow/backups";
    fsType = "zfs";
  };
}
