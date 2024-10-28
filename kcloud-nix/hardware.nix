{ config, modulesPath, lib, ... }:
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
    # use latest kernel supported by zfs
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    # https://www.reddit.com/r/zfs/comments/1826lgs/psa_its_not_block_cloning_its_a_data_corruption/
    # https://github.com/openzfs/zfs/issues/15526#issuecomment-1823737998
    kernelParams = [ "zfs.zfs_dmu_offset_next_sync=0" ];
  };

  # TODO include the zroot/DATA dataset, maybe encrypted?
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
