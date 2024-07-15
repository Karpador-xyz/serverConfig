{ pkgs, ... }:
{
  # user used by the pull backup host for login.
  users.groups.kbackup = {};
  users.users.kbackup = {
    isSystemUser = true;
    group = "kbackup";
    shell = pkgs.bash;
    packages = with pkgs; [ mbuffer lzop ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAPIaMz/QdIAbYSY9U556Igg7ZmPKDuZx7smqvdfMdD x@y"
      # TODO: remove after migration is done
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC3yLSclgZ6eMfpe4CPhb/YX7/HxN1/0Icy4gf9noMmx wolfie@kcloud"
    ];
  };
  # regular zfs snapshot config
  services.sanoid = {
    enable = true;
    datasets."zroot/DATA" = {
      autosnap = true;
      autoprune = true;
      recursive = true;
      # zroot/DATA is not gonna have anything on it
      processChildrenOnly = true;

      # snapshots to keep
      hourly = 23;
      daily = 7;
      weekly = 2;
      monthly = 1;
    };
    # we'll transfer stuff like pg dumps here
    # TODO: remove after migration is done
    datasets."zroot/DATA/old".autosnap = false;
  };
}
