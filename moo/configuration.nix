{ ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  networking.hostName = "moo";
  networking.hostId = "7e35a6d4";

  system.stateVersion = "25.05";
}
