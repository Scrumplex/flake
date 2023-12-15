{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.flake.deploy = mkOption {
    type = with types;
      attrsOf (submodule {
        freeformType = attrs;
      });
    default = {};
  };
}
