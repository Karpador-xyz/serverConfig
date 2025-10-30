{ pkgs, ... }:
let
  kodi = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
    vfs-sftp bluetooth-manager youtube orftvthek keymap joystick
  ]);
  # retroarch = pkgs.retroarch.withCores (
  #   cores: with cores; [
  #     desmume dolphin citra
  #   ]
  # );
in {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./jellyfin.nix
    ./transmission.nix
    ../common.nix
  ];

  age.secrets = {
    transmission.file = ../secrets/transmission.age;
  };

  users.users.kodi.isNormalUser = true;
  services.cage.user = "kodi";
  services.cage.program = "${kodi}/bin/kodi-standalone";
  services.cage.enable = true;

  networking.hostName = "boop";
  networking.hostId = "8425e349";

  users.users.root.packages = with pkgs; [ sanoid mbuffer lzop ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.tailscale.useRoutingFeatures = "server";

  system.stateVersion = "25.05";
}
