{
  config,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.prismlauncher.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    dolphin-emu
    prismlauncher
    r2modman

    protontricks
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      (proton-ge-bin.overrideAttrs (finalAttrs: _: {
        version = "GE-Proton9-1-rtsp5";
        src = pkgs.fetchzip {
          url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${finalAttrs.version}/${finalAttrs.version}.tar.gz";
          hash = "sha256-14cmc1Yi5Ysd2q6AB6M2jWVBiv94/7uE1J/dGixfP0s=";
        };
      }))
    ];
  };

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

  hardware.xpadneo.enable = true;

  hm.programs.mangohud = {
    enable = true;
    enableSessionWide = true;

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
