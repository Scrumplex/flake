{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  cfg = config.roles.qt;
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

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    environment.systemPackages = with pkgs; [
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
    ];

    hm.xdg.configFile = {
      "qt5ct/qt5ct.conf".source = pkgs.substituteAll {
        src = ./qt5ct.conf;
        themePath = cfg.qt5ctThemePath;
      };
      "qt6ct/qt6ct.conf".source = pkgs.substituteAll {
        src = ./qt6ct.conf;
        themePath = cfg.qt5ctThemePath;
      };
    };
  };
}
