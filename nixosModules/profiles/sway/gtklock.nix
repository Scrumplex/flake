{
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib'.scrumplex.sway) mkExec;

  cfg = config.profiles.sway;
  swayCfg = config.hm.wayland.windowManager.sway.config;
in {
  config = mkIf cfg.enable {
    security.pam.services.gtklock = {};
    roles.gpg.pamServices = ["gtklock"];

    environment.systemPackages = with pkgs; [gtklock];

    hm.wayland.windowManager.sway.config.keybindings = mkExec "${swayCfg.modifier}+Ctrl+q" "${getExe pkgs.gtklock} -d";
  };
}
