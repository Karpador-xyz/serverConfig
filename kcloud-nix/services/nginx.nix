{ dtPkgs, ... }:
let
  strudel_html = ''<html style='text-align: center;'>
    <h1>coming soon …</h1>
    <img src='https://images.unsplash.com/photo-1657313938000-23c4322dbe22?q=80&w=640&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' alt='photo of strudel' />
  </html>'';
in {
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
    commonHttpConfig = "access_log off;";

    # NOTE: we'll usually want forceSSL, these are exceptions to that rule.
    virtualHosts."dragontale.de" = {
      addSSL = true;
      enableACME = true;
      serverAliases = ["www.dragontale.de"];
      locations."/".root = dtPkgs.website;
    };
    virtualHosts."owo.karp.lol".locations."/".return = ''200 "what's this?" '';
    virtualHosts."1strudel.com" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        extraConfig = ''types {} default_type "text/html; charset=utf-8";'';
        return = ''200 "${strudel_html}" '';
      };
    };
  };
  services.logrotate.settings.nginx.rotate = 2;
}
