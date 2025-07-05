{ ... }:
{
  services.sanoid = {
    enable = true;
    datasets."zroot/data" = {
      autosnap = true;
      autoprune = true;
      recursive = true;
      # zroot/data is not gonna have anything on it
      processChildrenOnly = true;

      # snapshots to keep
      hourly = 23;
      daily = 7;
      weekly = 0;
      monthly = 0;
    };
    datasets."zroot/data/mailcow/backups" = {
      hourly = 2;
      daily = 1;
    };
  };
}
