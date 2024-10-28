{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    content = {
      type = "gpt";
      partitions.MBR = {
        type = "EF02"; # for grub MBR
        size = "1M";
        priority = 1; # Needs to be first partition
      };
      partitions.boot = {
        size = "1G";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
        priority = 2;
        hybrid.mbrBootableFlag = true;
      };
      partitions.zroot = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
    };
  };
  disko.devices.zpool.zroot = {
    type = "zpool";
    rootFsOptions = {
      mountpoint = "none";
      canmount = "off";
      compression = "zstd-10";
      relatime = "on";
      # https://openzfs.github.io/openzfs-docs/man/master/7/zfsprops.7.html#xattr
      xattr = "sa";
    };
    options.ashift = "12";

    datasets = let fs = mountpoint: {
      type = "zfs_fs";
      options.mountpoint = "legacy";
      inherit mountpoint;
    }; in {
      # root fs - no impermanence for now
      "nixos" = fs "/";
      # nix store
      "nix" = fs "/nix";
      # for home folder
      "home" = fs "/home";
    };
  };
}
