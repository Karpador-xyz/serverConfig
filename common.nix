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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIBy1b6An4WzmHWnsUS1OfF/6lYc8bAzEjuFzQ+zFLEMi1Yyr117+7gus8fHvC7bg85R77vB32JbriRClafxmqLXRrAI9LLKWeUoSi28R6SVMiO3R3bGTTyIRpUFqTYa0aNycqfQiUbQVC1IbxeFPc+z3RSaZelKbPQd1EVh0JvcZ2vNwW3ohyj6sAE8utmGvWn6zGRdKAiITswaK+KScpMiZVBDi18A0T5lHbc1yJGsEW6InT+DKvXc4fWe5J56O9+asqztxgx0tXWxeP2+LuryV43LlHlsZ/Iv/YtMbbYI8d9OJh8LByKabr0BCAFd6YS55EZbiRngVJefqjqetD5p7M1fX7kz+MefospLtle2iwu8wj+IXvxkw0c9DGz22iMqCxUSdMKzUvNk6tii2vDYHW8lyT7gGPm1YebQ/TxOlJJr8tHR9YIISWEW7JilBVeUVjI+UzaC4rWTAciUI1P0cM+va7OGY/KLZoK1GQ+89L78TLazHFNkEr3TCe5Jc= sylvie@godemiche"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4He6HobF5y8+viL1Fz9wWT+1Y3ptgZ6tpVQ+L3c9dq sylvie@tzuyu"
    ];
  };

  # we also want ssh everywhere
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "without-password";
    PasswordAuthentication = false;
  };

  # and tailscale
  services.tailscale.enable = true;
  systemd.services.tailscaled = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

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
