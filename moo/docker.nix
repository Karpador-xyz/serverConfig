{ ... }:
{
  fileSystems."/var/lib/docker" = {
    device = "zroot/docker";
    fsType = "zfs";
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };
}
