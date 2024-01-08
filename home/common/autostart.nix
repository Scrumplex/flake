{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkMerge;

  mapAutostart = {
    pkg,
    desktopFile,
  }: {
    xdg.configFile."autostart/${desktopFile}".source = "${pkg}/share/applications/${desktopFile}";
  };

  autostarts = [
    {
      pkg = pkgs.discord-canary;
      desktopFile = "discord-canary.desktop";
    }
    {
      pkg = pkgs.tdesktop;
      desktopFile = "org.telegram.desktop.desktop";
    }
    {
      pkg = pkgs.signal-desktop;
      desktopFile = "signal-desktop.desktop";
    }
    {
      pkg = pkgs.cinny-desktop;
      desktopFile = "cinny.desktop";
    }
    {
      pkg = pkgs.evolution;
      desktopFile = "org.gnome.Evolution.desktop";
    }
  ];
in
  mkMerge (map mapAutostart autostarts)
