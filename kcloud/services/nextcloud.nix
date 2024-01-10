{ pkgs, ... }:
{
  # TODO long way until this one's complete
  services.nextcloud = {
    enable = false;
    package = pkgs.nextcloud28;
    hostName = "cloud.karpador.xyz";
    https = true;
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
    };
  };
}
