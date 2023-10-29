{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.bluetooth = {
    enable = mkEnableOption "bluetooth role";
  };
}
