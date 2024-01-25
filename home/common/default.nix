{
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = [
    ./autostart.nix
    ./desktop.nix
    ./dev.nix
    ./ranger.nix
    ./screenshot-bash.nix
    ./sway
  ];

  home.packages = with pkgs; [
    flatpak-builder
    kubectl
  ];

  theme = {
    enable = true;
    palette = "mocha";
  };

  programs.chromium.enable = true;

  services.syncthing.enable = true;

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

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
