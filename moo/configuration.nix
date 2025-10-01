{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
    ./docker.nix
    ./mailcow.nix
    ./backups.nix
  ];

  networking.hostName = "moo";
  networking.hostId = "7e35a6d4";
  networking.firewall.allowedTCPPorts = [
    # HTTP(S)
    80 443
    # E-Mail
    25 465 587 143 993 110 995
  ];

  networking.interfaces.ens3.ipv6.addresses = [{
    address = "2a03:4000:6:1be::1";
    prefixLength = 64;
  }];
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "ens3";
  };

  users.users.root.packages = with pkgs; [ gitMinimal openssl jq ];

  system.stateVersion = "25.05";
}
