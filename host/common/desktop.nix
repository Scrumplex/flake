{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.system.role.desktop {
    programs.sway.enable = true;
    security.pam.services.gtklock = {};

    fonts = {
      packages = with pkgs; [
        noto-fonts-cjk-sans
        fira
        monocraft
        fira-code
        roboto
      ];

      enableDefaultPackages = true;

      fontDir = {
        enable = true;
        decompressFonts = true;
      };

      fontconfig = {
        cache32Bit = true;
        defaultFonts = {
          sansSerif = ["Fira Sans"];
          monospace = ["Fira Code"];
        };
      };

      symbols = {
        enable = true;
        fonts = [
          "Fira Code"
          "Fira Code,Fira Code Light"
          "Fira Code,Fira Code Medium"
          "Fira Code,Fira Code Retina"
          "Fira Code,Fira Code SemiBold"
          "Monocraft"
        ];
      };
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    environment.systemPackages = with pkgs; [
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
    ];
  };
}
