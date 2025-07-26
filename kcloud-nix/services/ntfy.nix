{ config, ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.karp.lol";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
      attachment-cache-dir = "";
      auth-default-access = "deny-all";
    };
  };
  fileSystems."/var/lib/private/ntfy-sh" = {
    device = "zroot/DATA/ntfy";
    fsType = "zfs";
  };
  services.nginx.virtualHosts."ntfy.karp.lol" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyWebsockets = true;
      proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
    };
  };

  services.mollysocket = {
    enable = true;
    settings.allowed_endpoints = [config.services.ntfy-sh.settings.base-url];
    environmentFile = config.age.secrets.molly.path;
  };
  services.nginx.virtualHosts."molly.karp.lol" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = with config.services.mollysocket.settings;
        "http://${host}:${toString port}";
    };
  };
}
