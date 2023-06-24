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
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraCss = builtins.readFile ./gtk-3.0.css;
    gtk4.extraCss = builtins.readFile ./gtk-4.0.css;
  };

  # Stop apps from generating fontconfig caches and breaking reproducibility
  systemd.user.tmpfiles.rules = [
    "R %C/fontconfig - - - - -"
  ];

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

  home.packages = with pkgs; [
    qt5ct
    qt6ct

    xdg-user-dirs
    xdg-utils
  ];
}
