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

    # disable errexit - we want to allow the next two commands to fail
    set +e
    if ./update.sh --check; then
      ./update.sh -f
      RET=$?
      # if the script returns 2, the script has been replaced
      # and needs to be run again
      if [ $RET -eq 2 ]; then
        # re-enable errexit for this
        set -e
        ./update.sh -f
      elif [ $RET -ne 0 ]; then
        # forward error code
        exit $RET
      fi
    fi
  '';
}
