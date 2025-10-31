{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.telegram-desktop
    ];
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    xdg.autostart.entries = [
      "${pkgs.telegram-desktop}/share/applications/org.telegram.desktop.desktop"
    ];
  };
}
