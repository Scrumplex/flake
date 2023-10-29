{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.v4l2loopback = {
    enable = mkEnableOption "v4l2loopback role";
  };
}
