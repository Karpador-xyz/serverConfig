{ config, pkgs, ... }:
{
  fileSystems."/var/lib/docker" = {
    device = "zroot/docker";
    fsType = "zfs";
  };
  fileSystems."/var/lib/docker/volumes" = {
    device = "zroot/data/docker-volumes";
    fsType = "zfs";
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };

  # TODO: is there a way to link the normal generated config file there?
  environment.etc."docker/daemon.json".source = let 
    mkConfig = (pkgs.formats.json {}).generate "daemon.json";
    daemonSettings = config.virtualisation.docker.daemon.settings;
  in mkConfig daemonSettings;
}
