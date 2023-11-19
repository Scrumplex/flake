{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.vr = {
    enable = mkEnableOption "vr role";

    enableHighPrioKernelPatch = mkEnableOption "kernel patch to allow high priority graphics for all clients";
  };
}
