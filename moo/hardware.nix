{ lib, modulesPath, ... }:
{
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [
      "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk"
    ];

    # allow zfs to find vda2
    zfs.devNodes = "/dev";

    kernelParams = [ "zfs.zfs_arc_max=67108864" ];
  };

  fileSystems = {
    "/" = {
      device = "zroot/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
    };
    "/var/log" = {
      device = "zroot/log";
      fsType = "zfs";
    };
    "/home" = {
      device = "zroot/home";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/7AC3-9C8F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };
  swapDevices = [{device="/dev/disk/by-uuid/e5f06071-c179-45e9-860b-45419b949ad7";}];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
