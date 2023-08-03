{
  inputs,
  pkgs,
  ...
}: {
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
    gtk3.extraCss = builtins.readFile ./adwaita.css;
    gtk4.extraCss = builtins.readFile ./adwaita.css;
  };

  xdg.configFile = {
    "qt5ct/qt5ct.conf".source = pkgs.substituteAll {
      src = ./qt5ct.conf;
      themePath = "${inputs.catppuccin-qt5ct}/themes/Catppuccin-Mocha.conf";
    };
    "qt6ct/qt6ct.conf".source = pkgs.substituteAll {
      src = ./qt6ct.conf;
      themePath = "${inputs.catppuccin-qt5ct}/themes/Catppuccin-Mocha.conf";
    };
  };

  # Stop apps from generating fontconfig caches and breaking reproducibility
  systemd.user.tmpfiles.rules = [
    "R %C/fontconfig - - - - -"
  ];

  home.packages = with pkgs; [
    xdg-user-dirs
    xdg-utils
  ];
}
