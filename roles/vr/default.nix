{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.vr;
in {
  options.roles.vr = {
    enable = mkEnableOption "vr role";
  };

  config = mkIf cfg.enable {
    boot.kernelPatches = [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone];

    services.monado.enable = true;
  };
}
