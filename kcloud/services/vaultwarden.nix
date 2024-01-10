{ config, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      # basics
      DOMAIN = "https://vault.karpador.xyz";
      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = false;
      # networking
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      # websocket
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_ADDRESS = "127.0.0.1";
      WEBSOCKET_PORT = 3012;
      # email config
      SMTP_HOST = "mail.karpador.xyz";
      SMTP_FROM = "vault@karpador.xyz";
      SMTP_FROM_NAME = "Karpador Vault";
      SMTP_PORT = 587;
      SMTP_SECURITY = "starttls";
      SMTP_USERNAME = "vault@karpador.xyz";
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };
  fileSystems."/var/lib/bitwarden_rs" = {
    device = "zroot/DATA/vaultwarden";
    fsType = "zfs";
  };
  services.nginx.virtualHosts."vault.karpador.xyz" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = with config.services.vaultwarden.config; {
      proxyPass = "http://${ROCKET_ADDRESS}:${toString ROCKET_PORT}";
    };
    locations."/notifications/hub" = with config.services.vaultwarden.config; {
      proxyPass = "http://${WEBSOCKET_ADDRESS}:${toString WEBSOCKET_PORT}";
      proxyWebsockets = true;
    };
  };
}
