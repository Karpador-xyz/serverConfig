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
    moo = {
      extraHostNames = [
        "mail.karpador.xyz" "5.45.102.194" "2a03:4000:6:1be::1" "100.117.129.88"
      ];
      publicKey = consts.hostKeys.moo;
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

      # common options
      # we are using `zfs allow` to delegate the required permissions
      OPTIONS="--no-privilege-elevation"
      # use the ssh key provided by the secrets
      OPTIONS="--sshkey=${config.age.secrets.kbackup-privkey.path} $OPTIONS"
      # no sync snap - we are using sanoid on the source hosts
      OPTIONS="--no-sync-snap $OPTIONS"
      # the root source datasets are always gonna be empty
      OPTIONS="--recursive --skip-parent $OPTIONS"
      # don't keep old snapshots around
      OPTIONS="--delete-target-snapshots $OPTIONS"

      # SPECIFIC TO THIS HOST:
      # force deletion of datasets in case there are no common snapshots
      # this will be necessary at times because of the snapshot policy
      # on the pgbackup dataset and because karp-zbox isn't reliably up
      OPTIONS="--force-delete $OPTIONS";

      # the everything host
      echo syncing kcloud-nix...
      syncoid $OPTIONS \
        kbackup@kcloud-nix:zroot/DATA \
        zroot/bckp/kcloud-nix/DATA

      # the mail server
      echo syncing moo...
      syncoid $OPTIONS \
        kbackup@moo:zroot/data \
        zroot/bckp/moo/data
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "kbackup";
    };
    startAt = "*-*-* *:15:00";
  };
}
