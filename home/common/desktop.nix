{pkgs, ...}: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.gnome-themes-extra;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita";
    };
    font = {
      package = pkgs.fira;
      name = "Fira Sans Regular";
      size = 11;
    };
  };

  theme.gtk = true;

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

  home.packages = with pkgs; [
    xdg-user-dirs
    xdg-utils

    qt5ct
    qt6ct
  ];
}
