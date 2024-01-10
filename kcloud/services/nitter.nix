{ config, lib, ... }:
{
  services.nitter = {
    enable = false;
    redisCreateLocally = true;
    server = {
      title = "Karpador nitter";
      hostname = "nitter.karp.lol";
      port = 46572;
    };
  };
  services.nginx.virtualHosts."nitter.karp.lol" = lib.mkIf config.services.nitter.enable {
    forceSSL = true;
    enableACME = true;
    locations."/" = let cfg = config.services.nitter.server; in {
      proxyPass = "http://${cfg.address}:${toString cfg.port}";
    };
  };
}
