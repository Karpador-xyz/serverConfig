{ pkgs, ... }:
{
  time.timeZone = "Europe/Vienna";

  # I am very evil
  i18n.defaultLocale = "de_AT.UTF-8";

  environment.systemPackages = with pkgs; [
    vim htop
  ];

  # we want a Sylvie everywhere
  users.users.sylvie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # we also want ssh everywhere
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "without-password";
    PasswordAuthentication = false;
  };

  # and tailscale
  services.tailscale.enable = true;
  systemd.services.tailscaled.after = [ "network-online.target" ];

  # reasonable log config
  services.journald.extraConfig = ''
    SystemMaxUse=2G
    SystemMaxFileSize=16M
    SystemMaxFiles=32
  '';

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    # TODO what does this even do?
    package = pkgs.nixFlakes;
  };
}
