{
  config,
  lib,
  pkgs,
  ...
}: let
  updateScript = pkgs.callPackage ./hetzner-ddns.nix {};
in {
  age.secrets."hetzner-ddns.env".file = ../../secrets/eclipse/hetzner-ddns.env.age;

  systemd.services."hetzner-ddns" = {
    description = "Hetzner dynamic DNS updater";
    serviceConfig = {
      ExecStart = lib.getExe updateScript;
      EnvironmentFile = [config.age.secrets."hetzner-ddns.env".path];
    };
  };
  systemd.timers."hetzner-ddns".timerConfig = {
    OnCalendar = "*:0/2";
  };
}
