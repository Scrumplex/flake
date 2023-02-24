{
  config,
  pkgs,
  ...
}: {
  assertions = [
    {
      assertion = config.powerManagement.cpuFreqGovernor != null;
      message = "No CPU frequency governor set.";
    }
  ];

  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        desiredgov = "performance";
        defaultgov = config.powerManagement.cpuFreqGovernor;
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
}
