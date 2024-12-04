{
  inputs,
  pkgs,
  ...
}: let
  qt5ctThemePath = "${inputs.catppuccin-qt5ct}/themes/catppuccin-mocha-blue.conf";
in {
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.systemPackages = with pkgs; [
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
  ];

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  hm.xdg.configFile = {
    "qt5ct/qt5ct.conf".source = pkgs.substituteAll {
      src = ./qt5ct.conf;
      themePath = qt5ctThemePath;
    };
    "qt6ct/qt6ct.conf".source = pkgs.substituteAll {
      src = ./qt6ct.conf;
      themePath = qt5ctThemePath;
    };
  };
}
