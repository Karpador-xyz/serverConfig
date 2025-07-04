{ config, pkgs, ... }:
let
  repoDir = "/opt/mailcow-dockerized";
  bkpDir = "/opt/backups";
  scriptWrapper = pkgs.writeShellApplication {
    name = "do-backup";
    runtimeInputs = with pkgs; [
      bashNonInteractive docker-client which
    ];
    text = ''
      export MAILCOW_BACKUP_LOCATION=${bkpDir}
      export THREADS=2

      ${repoDir}/helper-scripts/backup_and_restore.sh backup all --delete-days 2
    '';
  };
  scriptPath = "${scriptWrapper}/bin/do-backup";
in {
  fileSystems."${repoDir}" = {
    device = "zroot/data/mailcow/repo";
    fsType = "zfs";
  };
  fileSystems."${bkpDir}" = {
    device = "zroot/data/mailcow/backups";
    fsType = "zfs";
  };

  age.secrets = {
    restic-pw = {
      file = ../secrets/restic-pw.age;
      mode = "400";
    };
    restic-b2 = {
      file = ../secrets/restic-b2.age;
      mode = "400";
    };
  };

  services.restic.backups.mailcow-b2 = {
    # I did my best to put these attributes in an order that makes sense
    user = "root";
    backupPrepareCommand = scriptPath;
    repository = "b2:karp-mail:backups";
    passwordFile = config.age.secrets.restic-pw.path;
    environmentFile = config.age.secrets.restic-b2.path;
    paths = [ bkpDir ];
    pruneOpts = [ "--keep-daily 6" "--keep-weekly 5" "--keep-monthly 4" ];
  };
}
