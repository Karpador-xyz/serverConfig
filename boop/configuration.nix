{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
    ../common.nix
  ];

  networking.hostName = "boop";
  networking.hostId = "8425e349";

  system.stateVersion = "25.05";
}
