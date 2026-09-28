{
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
    programs.noctalia.settings.wallpaper = {
      enabled = true;
      transition_on_startup = true;
      directory = wallpapers;
      default.path = "${wallpapers}/primary.jpg";
    };

    wayland.windowManager.niri.settings._children = [
      {
        layer-rule = {
          _children = [
            {match._props.namespace = "^noctalia-overview*";}
          ];
          place-within-backdrop = true;
        };
      }
    ];
  };
}
