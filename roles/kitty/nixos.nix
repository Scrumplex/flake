{
  config,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  cfg = config.roles.kitty;
in {
  config = mkIf cfg.enable {
    roles.sway.config.terminal = getExe cfg.package;
  };
}
