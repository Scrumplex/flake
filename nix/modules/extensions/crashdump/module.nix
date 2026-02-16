{inputs, ...}: let
  modulePath = "misc/crashdump.nix";
in {
  flake.modules.nixos.ext-crashdump = {
    disabledModules = [modulePath];
    imports = ["${inputs.nixpkgs-fork-crashdump}/nixos/modules/${modulePath}"];

    nixpkgs.overlays = [
      (final: prev: {
        makedumpfile = final.callPackage "${inputs.nixpkgs-fork-crashdump}/pkgs/by-name/ma/makedumpfile/package.nix" {};
      })
    ];
  };
}
