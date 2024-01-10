{ pkgs, ... }:
{
  time.timeZone = "Europe/Vienna";

  # I am very evil
  i18n.defaultLocale = "de_AT.UTF-8";

  environment.systemPackages = with pkgs; [
    vim htop
  ];

  users.users.sylvie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "without-password";
    PasswordAuthentication = false;
  };

  services.tailscale.enable = true;
  systemd.services.tailscaled.after = [ "network-online.target" ];

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
