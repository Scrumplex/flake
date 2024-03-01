{
  lib,
  pkgs,
  ...
}: {
  security.pam.services.waylock = {};

  environment.systemPackages = with pkgs; [waylock];

  hm.wayland.windowManager.hyprland.settings.bind = [
    "$mod CTRL, Q, exec, ${lib.getExe pkgs.waylock} -fork-on-lock"
  ];
}
