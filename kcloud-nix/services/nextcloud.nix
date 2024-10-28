{ pkgs, config, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "cloud.karpador.xyz";
    https = true;
    appstoreEnable = true;
    database.createLocally = true;
    configureRedis = true;
    caching.redis = true;
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbtableprefix = "oc_";
      adminpassFile = "${pkgs.writeText "apf" "nothing"}";
    };
    settings = {
      overwriteprotocol = "https";
      default_phone_region = "AT";
      maintenance_window_start = 1;
      "upgrade.disable-web" = true;
      updatechecker = false;
      "mail_smtpmode" = "smtp";
      "mail_from_address" = "wolke";
      "mail_domain" = "karpador.xyz";
      "mail_smtpauthtype" = "LOGIN";
      "mail_smtpauth" = 1;
      "mail_smtphost" = "mail.karpador.xyz";
      "mail_smtpport" = "587";
      "mail_smtpname" = "wolke@karpador.xyz";
      "mail_smtpsecure" = "tls";
    };
    secretFile = config.age.secrets.nextcloud.path;
    phpOptions."opcache.interned_strings_buffer" = "9";
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    addSSL = true;
    enableACME = true;
  };
  fileSystems."${config.services.nextcloud.datadir}/data" = {
    fsType = "zfs";
    device = "zroot/DATA/nextcloud";
  };
}
