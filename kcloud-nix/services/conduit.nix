{ config, lib, unstable, ... }:
{
  services.matrix-conduit = {
    enable = true;
    package = unstable.conduwuit;
    settings.global = {
      server_name = "karp.lol";
      database_backend = "rocksdb";
      address = "127.0.0.1";
      port = 6167;
      trusted_servers = ["matrix.org"];
      allow_registration = false;
      allow_encryption = true;
      allow_federation = true;
      new_user_displayname_suffix = "";
      # disable all presence
      allow_local_presence = false;
      allow_incoming_presence = false;
      allow_outgoing_presence = false;
      # and read receipts
      allow_incoming_read_receipts = false;
      allow_outgoing_read_receipts = false;
      # and typing indicators
      allow_incoming_typing = false;
      allow_outgoing_typing = false;
    };
    extraEnvironment = {
      CONDUIT_LOG = "info";
    };
  };
  fileSystems."/var/lib/private/matrix-conduit" = {
    device = "zroot/DATA/conduit";
    fsType = "zfs";
  };
  # enable this once we migrate gotosocial over; GtS runs on karp.lol, which
  # means also moving the .well-known entries here
  services.nginx.virtualHosts."karp.lol" = lib.mkIf config.services.gotosocial.enable {
    locations = let
      common = ''types {} default_type "application/json; charset=utf-8";'';
      serverJson = builtins.toJSON {
        "m.server" = "mx.karp.lol:443";
      };
      clientJson = builtins.toJSON {
        "m.homeserver" = {
          base_url = "https://mx.karp.lol";
        };
        "org.matrix.msc3575.proxy" = {
          url = "https://mx.karp.lol";
        };
      };
    in {
      "= /.well-known/matrix/server" = {
        return = ''200 '${serverJson}' '';
        extraConfig = common;
      };
      "= /.well-known/matrix/client" = {
        return = ''200 '${clientJson}' '';
        extraConfig = ''
          ${common}
          add_header "Access-Control-Allow-Origin" *;
        '';
      };
    };
  };
  services.nginx.virtualHosts."mx.karp.lol" = lib.mkIf config.services.matrix-conduit.enable {
    forceSSL = true;
    enableACME = true;
    locations."/" = let cfg = config.services.matrix-conduit.settings.global; in {
      proxyPass = "http://${cfg.address}:${toString cfg.port}";
      proxyWebsockets = true;
    };
    extraConfig = ''
      client_max_body_size 24M;
    '';
  };
}
