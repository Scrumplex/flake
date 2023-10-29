{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.roles.pipewire = {
    enable = mkEnableOption "pipewire role";
  };
}
