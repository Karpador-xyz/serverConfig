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
    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "fd00:dead:beef:c0::/80";
      experimental = true;
      ip6tables = true;
    };
  };

  # TODO: is there a way to link the normal generated config file there?
  environment.etc."docker/daemon.json".source = let 
    mkConfig = (pkgs.formats.json {}).generate "daemon.json";
    daemonSettings = config.virtualisation.docker.daemon.settings;
  in mkConfig daemonSettings;
}
