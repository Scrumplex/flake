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
    programs.niri.settings.window-rules = [
      {
        matches = [
          {
            app-id = "org.telegram.desktop";
            is-urgent = false;
          }
        ];
        excludes = [
          {at-startup = false;}
        ];
        open-on-workspace = "messages";
        open-focused = false;
      }
    ];
  };
}
