let
  consts = import ../const.nix;
  inherit (consts.sshKeys.sylvie) godemiche tzuyu;
  local-keys = [ godemiche tzuyu ];

  inherit (consts.hostKeys) kcloud-nix karp-zbox bakapa;
  kcloud-keys = local-keys ++ [ kcloud-nix ];
  zbox-keys = local-keys ++ [ karp-zbox ];
  bakapa-keys = local-keys ++ [ bakapa ];
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

  # bakapa
  "kbackup-bakapa-privkey.age".publicKeys = bakapa-keys;
}
