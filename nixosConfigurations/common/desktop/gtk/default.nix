{pkgs, ...}: {
  hm.gtk = {
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
}
