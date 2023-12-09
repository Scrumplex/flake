{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.profile.vr;
in {
  options.profile.vr.enableHighPrioKernelPatch = mkEnableOption "kernel patch to allow high priority graphics for all clients";

  config = {
    boot.kernelPatches = mkIf cfg.enableHighPrioKernelPatch [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone];

    services.monado.enable = true;
  };
}
