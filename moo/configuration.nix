{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
    ./docker.nix
    ./mailcow.nix
  ];

  networking.hostName = "moo";
  networking.hostId = "7e35a6d4";

  networking.interfaces.ens3.ipv6.addresses = [{
    address = "2a03:4000:6:1be::1";
    prefixLength = 64;
  }];
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "ens3";
  };

  users.users.root.packages = [ pkgs.gitMinimal pkgs.openssl ];

  system.stateVersion = "25.05";
}
