{
  config,
  pkgs,
  ...
}: {
  programs.dconf.enable = true;
  services.accounts-daemon.enable = true;
  services.gnome.at-spi2-core.enable = true;
  services.gnome.tracker-miners.enable = true;
  services.gnome.tracker.enable = true;
  services.gvfs.enable = true;

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  hm = {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.gnome-themes-extra;
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
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = config.hm.gtk.theme.name;
        color-scheme = "prefer-dark";
        font-name = "${config.hm.gtk.font.name} ${toString config.hm.gtk.font.size}";
      };
    };
  };
}
