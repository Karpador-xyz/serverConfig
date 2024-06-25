{ unstable, ... }:
{
  services.jmusicbot = {
    enable = true;
    stateDir = "/var/lib/jmusicbot";
    package = unstable.jmusicbot;
  };
}
