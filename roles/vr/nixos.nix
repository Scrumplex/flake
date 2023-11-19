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
    boot.kernelPatches = mkIf cfg.enableHighPrioKernelPatch [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone];

    services.monado.enable = true;
  };
}
