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
    virtualHosts."dragontale.de" = {
      addSSL = true;
      enableACME = true;
      serverAliases = ["www.dragontale.de"];
      locations."/".root = dtPkgs.website;
    };
    virtualHosts."owo.karp.lol".locations."/".return = ''200 "what's this?" '';
  };
}
