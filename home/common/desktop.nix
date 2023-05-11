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
      name = "Fira Sans";
      size = 11;
    };
  };

  # Stop apps from generating fontconfig caches and breaking reproducibility
  systemd.user.tmpfiles.rules = [
    "R %C/fontconfig - - - - -"
  ];

  theme.gtk = true;

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

  home.packages = with pkgs; [
    qt5ct
    qt6ct

    xdg-user-dirs
    xdg-utils
  ];
}
