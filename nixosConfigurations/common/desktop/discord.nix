{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord-canary
    webcord
    vesktop
  ];

  hm.xdg.autostart.entries = [
    "${pkgs.discord-canary}/share/applications/discord-canary.desktop"
  ];
}
