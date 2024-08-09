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
      Type = "oneshot";
      ExecStart = lib.getExe updateScript;
      EnvironmentFile = [config.age.secrets."hetzner-ddns.env".path];

      DynamicUser = true;
      NoNewPrivileges = true;
      ProtectSystem = "full";
      ProtectHome = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
    };
  };
  systemd.timers."hetzner-ddns" = {
    timerConfig = {
      OnCalendar = "*:0/5";
      RandomizedDelaySec = "1m";
    };
    wantedBy = ["multi-user.target"];
  };
}
