{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.roles.gaming;
in {
  config = mkIf cfg.enable {
    programs.steam.enable = true;

    programs.gamemode = lib.mkIf cfg.withGamemode {
      enable = true;
      settings = {
        general = {
          defaultgov = config.powerManagement.cpuFreqGovernor;
          desiredgov = "performance";
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
