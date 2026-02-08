{lib, ...}: {
  flake.modules.nixos."base" = {config, ...}: let
    cfg = config.nixpkgs;
  in {
    options.nixpkgs.allowedUnfreePackageNames = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };

    config = lib.mkIf (cfg.allowedUnfreePackageNames != []) {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem pkg.pname cfg.allowedUnfreePackageNames;
    };
  };
}
