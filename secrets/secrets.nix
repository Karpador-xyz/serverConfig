let
  consts = import ../const.nix;
  inherit (consts.sshKeys.sylvie) godemiche tzuyu;
  local-keys = [ godemiche tzuyu ];

  inherit (consts.hostKeys) kcloud-nix karp-zbox bakapa moo;
  kcloud-keys = local-keys ++ [ kcloud-nix ];
  zbox-keys = local-keys ++ [ karp-zbox ];
  bakapa-keys = local-keys ++ [ bakapa ];
  moo-keys = local-keys ++ [ moo ];
in {
  # main service keys for kcloud
  "vaultwarden.age".publicKeys = kcloud-keys;
  "gts.age".publicKeys = kcloud-keys;
  "nextcloud.age".publicKeys = kcloud-keys;

  # telegram bots running on the little zbox
  "godfish.age".publicKeys = zbox-keys;
  "uwu.age".publicKeys = zbox-keys;
  "ytdl.age".publicKeys = zbox-keys;
  # wifi networks the zbox connects to
  "wifi.age".publicKeys = zbox-keys;

  # restic backup credentials
  "restic-pw.age".publicKeys = moo-keys;
  "restic-b2.age".publicKeys = moo-keys;

  # backup access keys
  "kbackup-bakapa-privkey.age".publicKeys = bakapa-keys;
  "kbackup-zbox-privkey.age".publicKeys = zbox-keys;
}
