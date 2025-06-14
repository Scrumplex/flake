{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    evince
    file-roller
    flatpak-builder
    nautilus
    nextcloud-client

    qpwgraph
    virt-manager
    bottles

    element-desktop
    quasselClient
    signal-desktop-bin

    inkscape-with-extensions
    gimp
    krita
    tenacity
    libreoffice-fresh
    livecaptions
    orca-slicer

    AusweisApp2

    wl-clipboard
    pulsemixer

    xdg-user-dirs
    xdg-utils
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.partition-manager.enable = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
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
      package = pkgs.gnome-themes-extra;
    };

    # Stop apps from generating fontconfig caches and breaking reproducibility
    systemd.user.tmpfiles.rules = [
      "R %C/fontconfig - - - - -"
    ];
  };
}
