{
  lib,
  pkgs,
  ...
}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };
in {
  nixpkgs.allowedUnfreePackageNames = ["discord" "discord-development" "discord-ptb" "discord-canary"];

  nixpkgs.overlays = lib.mkAfter [
    (_: prev: {
      discord = mkDiscordOverride prev.discord;
      discord-canary = mkDiscordOverride prev.discord-canary;
      discord-development = mkDiscordOverride prev.discord-canary;
      discord-ptb = mkDiscordOverride prev.discord-ptb;
    })
  ];

  environment.systemPackages = with pkgs; [
    discord-canary
    element-desktop
    signal-desktop-bin
  ];

  hm.xdg.autostart.entries = [
    "${pkgs.discord-canary}/share/applications/discord-canary.desktop"
    "${pkgs.signal-desktop-bin}/share/applications/signal.desktop"
    "${pkgs.element-desktop}/share/applications/element-desktop.desktop"
  ];
}
