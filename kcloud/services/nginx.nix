{ dtPkgs, ... }:
{
  # basic config for nginx + static sites
  security.acme = {
    acceptTerms = true;
    defaults.email = "wolfi@karapdor.xyz";
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    # NOTE: we'll usually want forceSSL, these are exceptions to that rule.
    virtualHosts."wolfsblume.party" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        return = "200 '&#128151;'";
        extraConfig = "default_type text/html;";
      };
    };
    virtualHosts."dragontale.de" = {
      addSSL = true;
      enableACME = true;
      serverAliases = ["www.dragontale.de"];
      locations."/".root = dtPkgs.website;
    };
  };
}
