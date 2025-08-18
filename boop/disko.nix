{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-INTENSO_SSD_1642505003004776";
    content = {
      type = "gpt";
      partitions = {
        mbr = {
          size = "1M";
          type = "EF02";
        };
        esp-mirror = {
          size = "1G";
          type = "EF00";
          content = {
            type = "mdraid";
            name = "esp";
          };
        };
        swap-stripe = {
          size = "16G";
          content = {
            type = "mdraid";
            name = "swap";
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
  disko.devices.mdadm = {
    esp = {
      type = "mdadm";
      level = 0;
      metadata = "1.0";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = [ "umask=0077" ];
      };
    };
    swap = {
      type = "mdadm";
      level = 0;
      content.type = "swap";
    };
  };
  disko.devices.zpool.zroot = {
    type = "zpool";
    rootFsOptions = {
      mountpoint = "none";
      canmount = "off";
      compression = "zstd-6";
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
  boot.swraid.mdadmConf = ''
    MAILADDR sylvie@karpador.xyz
  '';
}
