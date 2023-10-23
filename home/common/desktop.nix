{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
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

  # Stop apps from generating fontconfig caches and breaking reproducibility
  systemd.user.tmpfiles.rules = [
    "R %C/fontconfig - - - - -"
  ];

  home.packages = with pkgs; [
    xdg-user-dirs
    xdg-utils
  ];

  systemd.user.services."lxqt-policykit-agent" = {
    Unit.Description = "LXQt PolicyKit Agent";
    Service.ExecStart = getExe pkgs.lxqt.lxqt-policykit;
    Install.WantedBy = ["graphical-session.target"];
  };
}
