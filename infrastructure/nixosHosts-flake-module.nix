{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.flake.nixosHosts = mkOption {
    type = with types; attrsOf str;
    default = {};
  };
}
