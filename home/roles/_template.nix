{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles._template;
in {
  options.roles._template = {
    enable = mkEnableOption "_template role";
  };

  config = mkIf cfg.enable {};
}
