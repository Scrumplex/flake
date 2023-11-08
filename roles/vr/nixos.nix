{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.roles.vr;
in {
  config = mkIf cfg.enable {
    boot.kernelPatches = [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone];

    services.monado.enable = true;
  };
}
