{pkgs, ...}: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/conf.d/10-nerd-font-symbols.conf" = {
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <alias>
          <family>Fira Code</family>
          <prefer><family>Symbols Nerd Font</family></prefer>
        </alias>
        <alias>
          <family>Fira Code,Fira Code Medium</family>
          <prefer><family>Symbols Nerd Font</family></prefer>
        </alias>
        <alias>
          <family>Fira Code,Fira Code SemiBold</family>
          <prefer><family>Symbols Nerd Font</family></prefer>
        </alias>
        <alias>
          <family>Fira Code,Fira Code Light</family>
          <prefer><family>Symbols Nerd Font</family></prefer>
        </alias>
        <alias>
          <family>Fira Code,Fira Code Retina</family>
          <prefer><family>Symbols Nerd Font</family></prefer>
        </alias>
        <alias>
          <family>Monocraft</family>
          <prefer><family>Symbols Nerd Font</family></prefer>
        </alias>
      </fontconfig>
    '';
    onChange = "${pkgs.fontconfig}/bin/fc-cache -f";
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
    theme.name = "Catppuccin-Mocha-Standard-Teal-Dark";
  };

  # TODO: Kvantum maybe?
  # TODO: Qt 6!
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "gtk2";
  };

  home.packages = with pkgs; [
    pkgs.xdg-user-dirs
    pkgs.xdg-utils

    pkgs.fira
    pkgs.monocraft
    pkgs.fira-code
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})

    (pkgs.catppuccin-gtk.override {
      accents = ["teal"];
      variant = "mocha";
    })
  ];
}
