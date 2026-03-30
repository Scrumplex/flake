{lib, ...}: {
  flake.modules.homeManager.desktop = {pkgs, ...}: let
    primary = pkgs.fetchurl {
      name = "primary-wallpaper.jpg";
      url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
      hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
    };
    wallpapers = pkgs.linkFarm "wallpapers" {
      "primary.jpg" = primary;
    };
  in {
    programs.noctalia-shell.settings.wallpaper = {
      enabled = true;
      overviewEnabled = true;
      directory = wallpapers;
    };

    programs.niri.settings.layer-rules = [
      {
        matches = [{namespace = "^noctalia-overview*";}];
        place-within-backdrop = true;
      }
    ];
  };
}
