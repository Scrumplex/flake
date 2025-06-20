{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord-canary
    element-desktop
    quasselClient
    signal-desktop-bin
    tdesktop
    vesktop
    webcord
  ];

  hm.xdg.autostart.entries = [
    "${pkgs.discord-canary}/share/applications/discord-canary.desktop"
    "${pkgs.signal-desktop-bin}/share/applications/signal.desktop"
    "${pkgs.tdesktop}/share/applications/org.telegram.desktop.desktop"
    "${pkgs.element-desktop}/share/applications/element-desktop.desktop"
  ];
}
