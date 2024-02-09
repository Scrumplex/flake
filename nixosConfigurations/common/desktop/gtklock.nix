{
  lib,
  pkgs,
  ...
}: {
  security.pam.services.gtklock = {};

  environment.systemPackages = with pkgs; [gtklock];

  hm.wayland.windowManager.hyprland.settings.bind = [
    "$mod CTRL, Q, exec, ${lib.getExe pkgs.gtklock} -d"
  ];
}
