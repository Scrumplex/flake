{
  inputs,
  lib,
  ...
}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };
in {
  flake.modules.nixos."desktop" = {pkgs, ...}: {
    nixpkgs = {
      allowedUnfreePackageNames = ["discord" "discord-development" "discord-ptb" "discord-canary"];
      # Allow openssl for about two weeks. Hoping that Discord pushed the promised update removing openssl
      config.permittedInsecurePackages = lib.mkIf (inputs.nixpkgs.lastModified < 1778765071) [
        "openssl-1.1.1w"
      ];
    };

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
      signal-desktop
    ];
  };

  flake.modules.homeManager."desktop" = {pkgs, ...}: {
    xdg.autostart.entries = [
      "${pkgs.discord-canary}/share/applications/discord-canary.desktop"
      "${pkgs.signal-desktop}/share/applications/signal.desktop"
      "${pkgs.element-desktop}/share/applications/element-desktop.desktop"
    ];
  };
}
