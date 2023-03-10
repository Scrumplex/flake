{
  lib,
  config,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = [
    ./autostart.nix
    ./beets.nix
    ./desktop.nix
    ./dev.nix
    ./fish.nix
    ./kitty.nix
    ./mpd.nix
    ./neovim.nix
    ./pipewire
    ./ranger.nix
    ./screenshot-bash.nix
    ./sway
  ];

  home.packages = with pkgs; [
    file
    tree
    unzip
    psmisc
    ripgrep
    libqalculate
    flatpak-builder
    distrobox
    imv
    okular
    virt-manager
    fluxcd

    slack
    tdesktop
    signal-desktop
    element-desktop
    prismlauncher
    ark
    evolution
    inkscape
    gimp
    krita
    libreoffice
    portfolio
    gnome.nautilus
    dolphin
    AusweisApp2

    qpwgraph

    steam
    steam-run
  ];

  theme = {
    enable = true;
    palette = "mocha";
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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-gstreamer
      obs-vaapi
    ];
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  xsession.preferStatusNotifierItems = true; # needed for network-manager-applet
  services.network-manager-applet.enable =
    lib.mkDefault nixosConfig.networking.networkmanager.enable;

  programs.k9s.enable = true;
  xdg.configFile."k9s/skin.yml".source = let
    theme = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "k9s";
      rev = "322598e19a4270298b08dc2765f74795e23a1615";
      sha256 = "GrRCOwCgM8BFhY8TzO3/WDTUnGtqkhvlDWE//ox2GxI=";
    };
  in "${theme}/dist/mocha.yml";

  programs.htop = {
    enable = true;
    settings =
      {
        ".tree_view_always_by_pid" = 1;
      }
      // (with config.lib.htop;
        leftMeters [
          (bar "LeftCPUs2")
          (bar "Memory")
          (bar "Swap")
        ])
      // (with config.lib.htop;
        rightMeters [
          (bar "RightCPUs2")
          (text "Tasks")
          (text "LoadAverage")
          (text "Uptime")
        ]);
  };
}
