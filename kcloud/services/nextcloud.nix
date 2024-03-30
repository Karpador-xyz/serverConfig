{ pkgs, config, ... }:
{
  # TODO long way until this one's complete
  services.nextcloud = {
    enable = false;
    package = pkgs.nextcloud28;
    hostName = "cloud.karpador.xyz";
    https = true;
    database.createLocally = true;
    configureRedis = true;
    caching.redis = true;
    config = {
      dbtype = "pgsql";
      dbtableprefix = "oc_";
      defaultPhoneRegion = "AT";
      overwriteProtocol = "https";
    };
    extraOptions = {
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
  };
}
