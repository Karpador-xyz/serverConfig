{ lib, modulesPath, ... }:
{
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    loader.grub = {
      enable = true;
      zfsSupport = true;
    };

    zfs.devNodes = "/dev/disk/by-partlabel";

    initrd.availableKernelModules = [
      "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"
    ];

    kernelParams = [
      "zfs.zfs_arc_max=67108864"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
