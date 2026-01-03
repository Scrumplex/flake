{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.vr = {
    config,
    pkgs,
    ...
  }: {
    boot.extraModulePackages = lib.mkIf (builtins.any (gpu: builtins.elem "amdgpu" gpu.drivers) config.hardware.facter.detected.graphics.amd.enable) [
      (pkgs.callPackage ./_derivation.nix {
        inherit (config.boot.kernelPackages) kernel;
        patches = [
          inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch
        ];
      })
    ];
  };
}
