{ config, lib, unstable, ... }:
{
  services.gotosocial = {
    enable = true;
    package = unstable.gotosocial;
    settings = {
      # basics
      host = "karp.lol";
      bind-address = "127.0.0.1";
      port = 8090;
      advanced-rate-limit-requests = 0;
      trusted-proxies = "127.0.0.1";
      letsencrypt-enabled = false;
      accounts-registration-open = false;
      # storage
      storage-backend = "s3";
      storage-s3-endpoint = "s3.eu-central-003.backblazeb2.com";
      storage-s3-bucket = "karp-lol-masto";
      # email
      smtp-host = "mail.karpador.xyz";
      smtp-port = 587;
      smtp-username = "gts@karpador.xyz";
      smtp-from = "gts@karpador.xyz";
      # media
      media-remote-cache-days = 15;
      media-emoji-local-max-size = 102400;
      media-emoji-remote-max-size = 409600;
    };
    environmentFile = config.age.secrets.gts.path;
    setupPostgresqlDB = true;
  };
  services.nginx.virtualHosts."karp.lol" = lib.mkIf config.services.gotosocial.enable {
    forceSSL = true;
    enableACME = true;
    locations."/" = let cfg = config.services.gotosocial.settings; in {
      proxyWebsockets = true;
      proxyPass = "http://${cfg.bind-address}:${toString cfg.port}";
    };
  };
}
