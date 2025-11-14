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
    audacity
    libreoffice-fresh
    livecaptions

    ausweisapp

    wl-clipboard
    pulsemixer

    xdg-user-dirs
    xdg-utils
  ];

  # TODO: move somewhere better
  services.dbus.implementation = "broker";

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.partition-manager.enable = true;

  hm = {
    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
  };
}
