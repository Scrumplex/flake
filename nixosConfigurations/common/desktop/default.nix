{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    blender
    evince
    gnome.file-roller
    gnome.nautilus

    qpwgraph
    virt-manager

    discord-canary
    webcord
    vesktop
    cinny-desktop
    element-desktop
    quasselClient
    signal-desktop
    tdesktop

    inkscape-with-extensions
    gimp-with-plugins
    krita
    tenacity
    libreoffice-fresh
    #livecaptions

    portfolio
    AusweisApp2

    xdg-user-dirs
    xdg-utils
  ];
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

  services.gvfs.enable = true;

  hm = {
    xsession.preferStatusNotifierItems = true;

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

    # Stop apps from generating fontconfig caches and breaking reproducibility
    systemd.user.tmpfiles.rules = [
      "R %C/fontconfig - - - - -"
    ];
  };
}
