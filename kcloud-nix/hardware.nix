{ modulesPath, lib, ... }:
{
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [
      "xhci_pci" "virtio_pci" "virtio_scsi" "ahci" "usbhid" "sr_mod"
    ];

    # allow zfs to find vda2
    zfs.devNodes = "/dev";

    kernelParams = [ "zfs.zfs_arc_max=67108864" ];
  };

  fileSystems = {
    "/" = {
      device = "zroot/nixos";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/nixos/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "zroot/nixos/home";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E9CA-A5EC";
      fsType = "vfat";
    };
  };
  swapDevices = [{device="/dev/disk/by-uuid/5674f712-780d-421f-9607-40588a3f289a";}];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
