{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
    ../common.nix
  ];

  networking.hostName = "bakapa";
  networking.hostId = "a9584e08";

  system.stateVersion = "24.05";
}