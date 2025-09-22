{ ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
    ./services
    ./system
  ];

  age.secrets = {
    vaultwarden.file = ../secrets/vaultwarden.age;
    gts.file = ../secrets/gts.age;
    nextcloud = {
      file = ../secrets/nextcloud.age;
      owner = "nextcloud";
      group = "nextcloud";
      mode = "770";
    };
    mautrix-discord = {
      file = ../secrets/mautrix-discord.age;
      owner = "mautrix-discord";
      group = "mautrix-discord";
    };
  };

  networking.hostName = "kcloud-nix";
  networking.hostId = "5e8dcf56";

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # ipv6
  networking.interfaces.enp3s0.ipv6.addresses = [{
    address = "2a0a:4cc0:1:1176::1";
    prefixLength = 64;
  }];
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp3s0";
  };

  system.stateVersion = "23.11";
}
