{ config, ... }:
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
    wifi.file = ../secrets/wifi.age;
  };

  networking.hostName = "karp-zbox";
  networking.hostId = "abc1239e";

  networking.wireless = {
    enable = true;
    environmentFile = config.age.secrets.wifi.path;
    networks = {
      "LordOfThePings" = {
        psk = "@LOTP_PSK@";
        priority = 1;
      };
      "A1-D707D3".psk = "@A1_PSK@";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  system.stateVersion = "23.11";
}
