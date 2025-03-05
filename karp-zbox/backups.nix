{ config, pkgs, consts, ... }:
{
  # we need...
  # 1. user to pull backups.
  users.users.kbackup = {
    isSystemUser = true;
    group = "kbackup";
    packages = [ pkgs.sanoid ];
  };
  users.groups.kbackup = {};
  # 2. zfs permissions.
  # user has to have `zfs allow` on the backups datasets somehow.
  # 3. ssh key. injected private key using agenix.
  age.secrets.kbackup-privkey = {
    file = ../secrets/kbackup-zbox-privkey.age;
    mode = "400";
    owner = "kbackup";
    group = "kbackup";
  };
  # 4. ssh remote host pubkey. should be pre-accepted if possible.
  programs.ssh.knownHosts = {
    kcloud-nix = {
      extraHostNames = [ "karp.lol" "152.53.16.62" ];
      publicKey = consts.hostKeys.kcloud-nix;
    };
  };
  
  # finally, need a systemd oneshot unit that actually pulls snapshots using
  # all of the ingredients listed above, and a timer to start it periodically.
  # bonus points if I can do it without a home dir.
  systemd.services.kbackup-pull = {
    enable = true;
    description = "pull backups from hosts";
    path = [ pkgs.coreutils pkgs.sanoid ];
    script = ''
      set -e -o pipefail

      syncoid \
        --no-privilege-elevation \
        --sshkey=${config.age.secrets.kbackup-privkey.path} \
        --no-sync-snap \
        --recursive \
        --skip-parent \
        --delete-target-snapshots \
        kbackup@karp.lol:zroot/DATA \
        zroot/bckp/kcloud-nix/DATA
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "kbackup";
    };
    startAt = "*-*-* *:15:00";
  };
}
