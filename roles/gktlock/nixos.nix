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

  cfg = config.roles.gtklock;
in {
  config = mkIf cfg.enable {
    security.pam.services.gtklock = {};

    environment.systemPackages = with pkgs; [gtklock];

    roles.sway.config.keybindings = mkExec "${config.roles.sway.config.modifier}+Ctrl+q" "${getExe pkgs.gtklock} -d";
  };
}
