{ ... }:
{
  fileSystems."/opt/mailcow-dockerized" = {
    device = "zroot/data/mailcow/repo";
    fsType = "zfs";
  };
}
