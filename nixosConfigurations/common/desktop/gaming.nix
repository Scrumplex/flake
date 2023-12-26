{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # dolphinEmu
    prismlauncher
    r2modman
    yuzu-early-access

    protontricks
  ];

  programs.steam.enable = true;

  programs.gamemode = {
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

  hm.programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = "150,60,0";
      vsync = 1;
      cpu_stats = true;
      cpu_temp = true;
      gpu_stats = true;
      gpu_temp = true;
      vulkan_driver = true;
      fps = true;
      frametime = true;
      frame_timing = true;
      enableSessionWide = true;
      font_size = 24;
      position = "top-left";
      engine_version = true;
      wine = true;
      no_display = true;
      background_alpha = "0.5";
      toggle_hud = "Shift_R+F12";
      toggle_fps_limit = "Shift_R+F1";
    };
  };
}
