{ pkgs, ... }:
let
  kodi = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
    vfs-sftp
  ]);
in {
  imports = [
    ./disko.nix
    ./hardware.nix
    ../common.nix
  ];

  users.users.kodi.isNormalUser = true;
  services.cage.user = "kodi";
  services.cage.program = "${kodi}/bin/kodi-standalone";
  services.cage.enable = true;

  networking.hostName = "boop";
  networking.hostId = "8425e349";

  system.stateVersion = "25.05";
}
