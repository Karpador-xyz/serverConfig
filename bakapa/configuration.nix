{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
    ../common.nix
    ./backups.nix
  ];

  networking.hostName = "bakapa";
  networking.hostId = "a9584e08";

  system.stateVersion = "25.05";
}
