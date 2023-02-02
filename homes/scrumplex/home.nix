{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./core.nix
    ./fish.nix
    ./mpd.nix
    ./sway.nix
    ./kitty.nix
    ./borg.nix
    ./screenshot-bash.nix
  ];

  home.packages = [
    pkgs.htop
    pkgs.file
    pkgs.tree

    pkgs.discord
    pkgs.slack
    pkgs.tdesktop
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.obs-studio
    pkgs.prismlauncher
    pkgs.ark
    pkgs.evolution
    pkgs.inkscape
    pkgs.gimp
    pkgs.krita

    pkgs.qpwgraph

    pkgs.mangohud
    pkgs.steam
    pkgs.steam-run
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      hwdec-codecs = "vaapi";
      profile = "gpu-hq";
      video-sync = "display-resample";
      volume = 50;
    };
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.browserpass.enable = true;

  services.syncthing.enable = true;
  programs.mangohud = {
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