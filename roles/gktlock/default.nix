{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.gtklock = {
    enable = mkEnableOption "gtklock role";
  };
}
