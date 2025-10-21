{ config, unstable, ... }:
{
  services.jellyfin = {
    enable = true;
    package = unstable.jellyfin;
  };
  # TODO move to zroot
  fileSystems."${config.services.jellyfin.dataDir}" = {
    device = "zroot/data/jellyfin";
    fsType = "zfs";
  };
  services.nginx = {
    enable = true;
    virtualHosts."boop".locations."/" = {
      return = "301 https://boop.tail42559.ts.net";
    };
    virtualHosts."boop.tail42559.ts.net" = {
      forceSSL = true;
      sslCertificateKey = "/srv/boop.tail42559.ts.net.key";
      sslCertificate = "/srv/boop.tail42559.ts.net.crt";

      locations = let
        url = "http://127.0.0.1:8096";
      in {
        "/" = {
          recommendedProxySettings = true;
          proxyPass = url;
          extraConfig = "proxy_buffering off;";
        };
        "/socket" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = url;
        };
      };
    };
  };
}
