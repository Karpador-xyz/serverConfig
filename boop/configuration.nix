{ pkgs, ... }:
let
  # kodi = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
  #   vfs-sftp bluetooth-manager youtube orftvthek keymap
  # ]);
  retroarch = pkgs.retroarch.withCores (
    cores: with cores; [
      desmume dolphin citra
    ]
  );
in {
  imports = [
    ./disko.nix
    ./hardware.nix
    ../common.nix
  ];

  users.users.kodi.isNormalUser = true;
  services.cage.user = "kodi";
  services.cage.program = "${retroarch}/bin/retroarch";
  services.cage.enable = true;

  systemd.services."cage-tty1".serviceConfig.Restart = "on-failure";

  networking.hostName = "boop";
  networking.hostId = "8425e349";

  system.stateVersion = "25.05";
}
