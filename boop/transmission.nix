{ pkgs, config, ... }:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openRPCPort = true;
    openPeerPorts = true;
    credentialsFile = config.age.secrets.transmission.path;
    settings = {
      rpc-enabled = true;
      rpc-authentication-required = true;
      anti-brute-force-enabled = true;
      cache-size-mb = "1";
      download-dir = "/srv/video/downloads";
    };
  };
  fileSystems."${config.services.transmission.home}" = {
    device = "zroot/data/transmission";
    fsType = "zfs";
  };
}
