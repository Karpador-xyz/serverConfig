{ pkgs, config, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "cloud.karpador.xyz";
    https = true;
    appstoreEnable = true;
    database.createLocally = true;
    configureRedis = true;
    caching.redis = true;
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      adminpassFile = "${pkgs.writeText "apf" "nothing"}";
    };
    settings = {
      dbtableprefix = "oc_";
      overwriteprotocol = "https";
      default_phone_region = "AT";
      maintenance_window_start = 1;
      upgrade.disable-web = true;
      updatechecker = false;
      mail_smtpmode = "smtp";
      mail_from_address = "wolke";
      mail_domain = "karpador.xyz";
      mail_smtpauthtype = "LOGIN";
      mail_smtpauth = true;
      mail_smtphost = "mail.karpador.xyz";
      mail_smtpport = 587;
      mail_smtpname = "wolke@karpador.xyz";
      mail_smtpsecure = "ssl";
      preview_max_x = 900;
      preview_max_y = 900;
      preview_max_scale_factor = 1.5;
    };
    secretFile = config.age.secrets.nextcloud.path;
    phpOptions."opcache.interned_strings_buffer" = "10";
  };
  services.nextcloud.autoUpdateApps = {
    enable = true;
    startAt = "04:30:00";
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
