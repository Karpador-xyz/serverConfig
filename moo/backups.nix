{ pkgs, consts, ... }:
{
  # user used by the pull backup host for login.
  users.groups.kbackup = {};
  users.users.kbackup = {
    isSystemUser = true;
    group = "kbackup";
    shell = pkgs.bash;
    packages = with pkgs; [ mbuffer lzop ];
    openssh.authorizedKeys.keys = builtins.attrValues consts.sshKeys.kbackup;
  };
  # automated zfs snapshots
  services.sanoid = {
    enable = true;
    datasets."zroot/data" = {
      autosnap = true;
      autoprune = true;
      recursive = true;
      # zroot/data is not gonna have anything on it
      processChildrenOnly = true;

      # snapshots to keep
      hourly = 23;
      daily = 7;
      weekly = 0;
      monthly = 0;
    };
    datasets."zroot/data/mailcow/backups" = {
      hourly = 2;
      daily = 1;
    };
  };
}
