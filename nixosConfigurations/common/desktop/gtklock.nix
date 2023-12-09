{
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib'.scrumplex.sway) mkExec;

  swayCfg = config.hm.wayland.windowManager.sway.config;
in {
  security.pam.services.gtklock = {};

  environment.systemPackages = with pkgs; [gtklock];

  hm.wayland.windowManager.sway.config.keybindings = mkExec "${swayCfg.modifier}+Ctrl+q" "${getExe pkgs.gtklock} -d";
}
