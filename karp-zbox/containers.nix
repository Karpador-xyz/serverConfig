{ config, ... }:
{
  virtualisation.oci-containers.containers = {
    godfishbot = {
      image = "docker.io/follpvosten/godfishbot-ng:latest";
      environmentFiles = [ config.age.secrets.godfish.path ];
    };
    uwu = {
      image = "docker.io/follpvosten/uwu-bot:latest";
      environment = { RUST_LOG = "info"; };
      environmentFiles = [ config.age.secrets.uwu.path ];
    };
    ytdl = {
      image = "docker.io/follpvosten/ytdl-tg-bot:latest";
      environmentFiles = [ config.age.secrets.ytdl.path ];
    };
  };
}
