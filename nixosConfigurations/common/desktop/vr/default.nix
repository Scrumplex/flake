{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.profile.vr;

  amdgpu-kernel-module = pkgs.callPackage ./amdgpu.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  options.profile.vr.enableHighPrioKernelPatch = mkEnableOption "kernel patch to allow high priority graphics for all clients";

  config = {
    boot.extraModulePackages = mkIf cfg.enableHighPrioKernelPatch [
      (amdgpu-kernel-module.overrideAttrs (prev: {
        patches = (prev.patches or []) ++ [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch];
      }))
    ];

    services.monado.enable = true;

    environment.systemPackages = with pkgs; [
      index_camera_passthrough
      opencomposite-helper
      wlx-overlay-s
    ];
  };
}
