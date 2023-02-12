{ pkgs, ... }:

{
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        desiredgov = "performance";
        softrealtime = "on";
        renice = 10;
        ioprio = 1;
        inhibit_screensaver = 0;
      };
      custom = {
        start = ''${pkgs.libnotify}/bin/notify-send "GameMode started"'';
        stop = ''${pkgs.libnotify}/bin/notify-send "GameMode ended"'';
      };
    };
  };

}
