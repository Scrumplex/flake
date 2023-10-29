{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule mkIf;

  cfg = config.roles.gaming;
in {
  imports = [
    (mkAliasOptionModule ["roles" "gaming" "defaultGovernor"] ["powerManagement" "cpuFreqGovernor"])
    (mkAliasOptionModule ["roles" "gaming" "boostGovernor"] ["programs" "gamemode" "settings" "general" "desiredgov"])
  ];

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    programs.gamemode = lib.mkIf cfg.withGamemode {
      enable = true;
      settings = {
        general = {
          defaultgov = cfg.defaultGovernor;
          softrealtime = "on";
          renice = 10;
          ioprio = 1;
          inhibit_screensaver = 0;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          stop = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
