{
  lib,
  pkgs,
  ...
}: let
  python = pkgs.python3.withPackages (ps: with ps; [dbus-next i3ipc psutil tenacity xlib]);

  assign-cgroups = pkgs.fetchurl {
    url = "https://github.com/alebastr/sway-systemd/raw/v0.4.0/src/assign-cgroups.py";
    hash = "sha256-Wkpm6CXXiPDj7QGl8BetQ1oppVALLTp8NeAnYRL6Rww=";
  };
in {
  hm.wayland.windowManager.sway.config.startup = [
    {command = "${lib.getExe python} ${assign-cgroups}";}
  ];
}
