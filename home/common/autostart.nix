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
      pkg = pkgs.tdesktop;
      desktopFile = "org.telegram.desktop.desktop";
    }
    {
      pkg = pkgs.signal-desktop-bin;
      desktopFile = "signal-desktop.desktop";
    }
    {
      pkg = pkgs.element-desktop;
      desktopFile = "element-desktop.desktop";
    }
    {
      pkg = pkgs.evolution;
      desktopFile = "org.gnome.Evolution.desktop";
    }
  ];
in
  mkMerge (map mapAutostart autostarts)
