{ ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
    ./services
    ./bots
    ./system
  ];

  age.secrets = {
    vaultwarden.file = ../secrets/vaultwarden.age;
    gts.file = ../secrets/gts.age;
    nextcloud.file = ../secrets/nextcloud.age;
  };

  networking.hostName = "kcloud-nix";
  networking.hostId = "5e8dcf56";

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  system.stateVersion = "23.11";
}
