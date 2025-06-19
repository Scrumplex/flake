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

  hm = {
    xdg = {
      enable = true;
      autostart.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
  };
}
