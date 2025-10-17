{ config, unstable, ... }:
{
  services.jellyfin = {
    enable = true;
    package = unstable.jellyfin;
    openFirewall = true;
  };
  # TODO move to zroot
  fileSystems."${config.services.jellyfin.dataDir}" = {
    device = "zdata/jellyfin";
    fsType = "zfs";
  };
}
