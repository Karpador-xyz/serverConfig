{ ... }:
{
  disko.devices.disk.main = {
    imageSize = "4G";
    type = "disk";
    device = "/dev/vda";
    content = {
      type = "gpt";
      partitions = {
        MBR = {
          type = "EF02"; # for grub MBR
          size = "4M";
          priority = 1; # Needs to be first partition
        };
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        swap = {
          size = "2G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
        zroot = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "zroot";
          };
        };
      };
    };
  };
  disko.devices.zpool.zroot = {
    type = "zpool";
    rootFsOptions = {
      mountpoint = "none";
      canmount = "off";
      compression = "zstd-7";
      relatime = "on";
      # https://openzfs.github.io/openzfs-docs/man/master/7/zfsprops.7.html#xattr
      xattr = "sa";
      primarycache = "none";
    };
    options.ashift = "12";

    datasets = let fs = mountpoint: {
      type = "zfs_fs";
      options.mountpoint = "legacy";
      inherit mountpoint;
    }; in {
      # root fs - no impermanence for now
      "root" = fs "/";
      # nix store
      "nix" = fs "/nix";
      # logs
      "log" = fs "/var/log";
      # for home folder
      "home" = fs "/home";
    };
  };
}
