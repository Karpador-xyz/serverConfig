{ lib, modulesPath, ... }:
{
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    zfs.devNodes = "/dev/disk/by-partlabel";

    initrd.availableKernelModules = [
      "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"
    ];

    kernelParams = [
      "zfs.zfs_arc_max=67108864"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.bluetooth.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
