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
    wayland.windowManager.niri.settings._children = [
      {
        window-rule = {
          _children = [
            {
              match._props = {
                app-id = "org.telegram.desktop";
                is-urgent = false;
              };
            }
            {exclude._props.at-startup = false;}
          ];
          open-on-workspace = "messages";
          open-focused = false;
        };
      }
    ];
  };
}
