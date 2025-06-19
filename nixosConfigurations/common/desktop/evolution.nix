{pkgs, ...}: {
  programs.evolution.enable = true;

  hm.xdg.autostart.entries = [
    "${pkgs.evolution}/share/applications/org.gnome.Evolution.desktop"
  ];
}
