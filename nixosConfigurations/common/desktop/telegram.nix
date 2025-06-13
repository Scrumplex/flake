{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.tdesktop
  ];

  hm.xdg.autostart.entries = [
    "${pkgs.tdesktop}/share/applications/org.telegram.desktop.desktop"
  ];
}
