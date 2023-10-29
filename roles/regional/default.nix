{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.regional = {
    enable = mkEnableOption "regional role";
  };
}
