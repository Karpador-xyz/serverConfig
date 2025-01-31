{ config, ... }:
{
  services.owncast = {
    enable = true;
    openFirewall = true;
  };
  services.nginx.virtualHosts."live.karp.lol" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyWebsockets = true;
      proxyPass = with config.services.owncast;
        "http://${listen}:${toString port}";
    };
  };
  fileSystems."${config.services.owncast.dataDir}" = {
    device = "zroot/DATA/owncast";
    fsType = "zfs";
  };
}
