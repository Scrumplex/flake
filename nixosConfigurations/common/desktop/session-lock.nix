{
  config,
  lib,
  lib',
  pkgs,
  ...
}: {
  security.pam.services.waylock = {};

  environment.systemPackages = with pkgs; [waylock];

  hm.wayland.windowManager.hyprland.settings.bind = [
    "$mod CTRL, Q, exec, ${lib.getExe pkgs.waylock} -fork-on-lock"
  ];
  hm.wayland.windowManager.sway.config.keybindings = lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+Ctrl+q" "${lib.getExe pkgs.waylock} -fork-on-lock";
}
