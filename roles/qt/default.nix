{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;
in {
  options.roles.qt = {
    enable = mkEnableOption "qt role";

    qt5ctThemePath = mkOption {
      type = with types; path;
      default = "";
      description = ''
        Path to qt5ct color theme
      '';
    };
  };
}
