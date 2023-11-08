{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.vr = {
    enable = mkEnableOption "vr role";
  };
}
