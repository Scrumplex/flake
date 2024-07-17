{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;

  cfg = config.profile.amdgpu;

  amdgpu-kernel-module = pkgs.callPackage ./derivation.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  options.profile.amdgpu.patches = mkOption {
    type = with types; listOf path;
  };

  config = mkIf (cfg.patches != []) {
    boot.extraModulePackages = [
      (amdgpu-kernel-module.overrideAttrs (prev: {
        patches = (prev.patches or []) ++ [];
      }))
    ];
  };
}
