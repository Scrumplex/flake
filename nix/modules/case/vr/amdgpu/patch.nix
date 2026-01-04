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
    boot.extraModulePackages = lib.mkIf config.hardware.facter.detected.graphics.amd.enable [
      (pkgs.callPackage ./_derivation.nix {
        inherit (config.boot.kernelPackages) kernel;
        patches = [
          inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch
        ];
      })
    ];
  };
}
