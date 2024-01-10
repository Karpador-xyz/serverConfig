{ ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
    ./containers.nix
  ];

  age.secrets = {
    godfish.file = ../secrets/godfish.age;
    uwu.file = ../secrets/uwu.age;
    ytdl.file = ../secrets/ytdl.age;
  };

  networking.hostName = "karp-zbox";
  networking.hostId = "abc1239e";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  system.stateVersion = "23.11";
}
