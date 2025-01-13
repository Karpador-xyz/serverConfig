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
      log-level = "warn";
      # storage
      storage-backend = "s3";
      storage-s3-endpoint = "b5c1.fra1.idrivee2-95.com";
      storage-s3-bucket = "karplol-gotosocial";
      # email
      smtp-host = "mail.karpador.xyz";
      smtp-port = 587;
      smtp-username = "gts@karpador.xyz";
      smtp-from = "gts@karpador.xyz";
      # media
      media-remote-cache-days = 2;
      media-cleanup-every = "8h";
      media-emoji-local-max-size = 102400;
      media-emoji-remote-max-size = 1024 * 1024;
      media-description-min-chars = 64;
      http-client.timeout = "30s";
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
