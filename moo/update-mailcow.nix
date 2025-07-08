nixpkgs: let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
in pkgs.writeShellApplication {
  name = "activate";
  runtimeInputs = with pkgs; [
    coreutils gnused bashNonInteractive docker-client which curl
    gitMinimal iptables
  ];
  text = ''
    cd /opt/mailcow-dockerized

    if ./update.sh --check; then
      ./update.sh -f
      # if the script returns 2, the script has been replaced
      # and needs to be run again
      [ $? -eq 2 ] && ./update.sh -f
    fi
  '';
}
