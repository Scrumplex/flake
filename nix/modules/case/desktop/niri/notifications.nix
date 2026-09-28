{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    wayland.windowManager.niri.settings = {
      debug.honor-xdg-activation-with-invalid-serial = true;
      binds = {
        "Mod+Backspace".spawn = [(lib.getExe config.programs.noctalia.package) "msg" "notification-clear-active"];
        "Mod+Shift+Backspace".spawn = [(lib.getExe config.programs.noctalia.package) "msg" "notification-dnd-toggle"];
      };
    };
  };
}
