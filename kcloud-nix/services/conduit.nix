{ config, lib, unstable, ... }:
let
  address = "127.0.0.1";
  port = 6167;
  localAddress = "http://${address}:${toString port}";
  domain = "karp.lol";
  mxDomain = "mx.${domain}";
  mxAddress = "https://${mxDomain}";
in {

  services.matrix-continuwuity = {
    enable = true;
    package = unstable.matrix-continuwuity;
    settings.global = {
      server_name = domain;
      address = [address];
      port = [port];
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
      CONTINUWUITY_LOG = "info";
    };
  };
  fileSystems."/var/lib/private/continuwuity" = {
    device = "zroot/DATA/continuwuity";
    fsType = "zfs";
  };
  fileSystems."/var/lib/private/continuwuity/media" = {
    device = "zroot/DATA/continuwuity/media";
    fsType = "zfs";
  };
  # enable this once we migrate gotosocial over; GtS runs on karp.lol, which
  # means also moving the .well-known entries here
  services.nginx.virtualHosts."${domain}" = lib.mkIf config.services.gotosocial.enable {
    locations = let
      common = ''types {} default_type "application/json; charset=utf-8";'';
      serverJson = builtins.toJSON {
        "m.server" = "${mxDomain}:443";
      };
      clientJson = builtins.toJSON {
        "m.homeserver" = {
          base_url = mxAddress;
        };
        "org.matrix.msc3575.proxy" = {
          url = mxAddress;
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
  services.nginx.virtualHosts."${mxDomain}" = lib.mkIf config.services.matrix-continuwuity.enable {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = localAddress;
      proxyWebsockets = true;
    };
    extraConfig = ''
      client_max_body_size 24M;
    '';
  };

  services.mautrix-discord = {
    enable = true;
    package = unstable.mautrix-discord;
    serviceDependencies = [ "continuwuity.service" ];
    settings = {
      homeserver = {
        inherit domain;
        address = localAddress;
      };

      appservice = {
        as_token = "$AS_TOKEN";
        hs_token = "$HS_TOKEN";
        database = {
          type = "sqlite3-fk-wal";
          uri = "file:/var/lib/mautrix-discord/mautrix-discord.db?_txlock=immediate";
          max_open_conns = 20;
          max_idle_conns = 2;
          max_conn_idle_time = null;
          max_conn_lifetime = null;
        };
      };

      bridge = {
        permissions = {
          "*" = "relay";
          "@sylvie:${domain}" = "admin";
        };
        federate_rooms = false;
        mute_channels_on_create = true;
      };
    };
    environmentFile = config.age.secrets.mautrix-discord.path;
  };
  fileSystems."${config.services.mautrix-discord.dataDir}" = {
    device = "zroot/DATA/mautrix-discord";
    fsType = "zfs";
  };
}
