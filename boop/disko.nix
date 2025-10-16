{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-INTENSO_SSD_1642505003004776";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "4G"; # trust me on this lol
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        swap = {
          size = "16G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
        zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "zroot";
          };
        };
      };
    };
  };
  disko.devices.disk.root-mirror = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-CT480E100SSD8_2502EAC8AB08";
    content = {
      type = "gpt";
      partitions.zfs = {
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
    mode.topology = {
      type = "topology";
      vdev = [{
        mode = "mirror";
        members = ["main" "root-mirror"];
      }];
    };
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
