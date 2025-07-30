{ config, ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
    ./backups.nix
    ./containers.nix
    ./jmusicbot.nix
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
    secretsFile = config.age.secrets.wifi.path;
    networks = {
      "A1-D707D3" = {
        pskRaw = "ext:A1_PSK";
        priority = 1;
      };
      "LordOfThePings" = {
        pskRaw = "ext:LOTP_PSK";
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  system.stateVersion = "23.11";
}
