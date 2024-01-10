{ config, lib, modulesPath, ... }:
{
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    loader.grub = {
      enable = true;
      zfsSupport = true;
      device = "/dev/sda";
    };

    initrd.availableKernelModules = [
      "uhci_hcd" "ehci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];

    # use latest kernel supported by zfs
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    # https://www.reddit.com/r/zfs/comments/1826lgs/psa_its_not_block_cloning_its_a_data_corruption/
    # https://github.com/openzfs/zfs/issues/15526#issuecomment-1823737998
    kernelParams = [ "zfs.zfs_dmu_offset_next_sync=0" ];
  };

  fileSystems = {
    "/" = {
      device = "zroot/nixos";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/88c4af2b-0ebe-4689-88b1-3c26b46e7e8a";
      fsType = "ext4";
    };
  };
  swapDevices = [{device="/dev/disk/by-uuid/857bb005-c64e-4988-add0-7ba314acae22";}];

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.ens32.useDHCP = lib.mkDefault true;
  networking.interfaces.wls33.useDHCP = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
