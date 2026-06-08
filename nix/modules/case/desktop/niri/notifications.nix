{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    programs.niri.settings = {
      debug.honor-xdg-activation-with-invalid-serial = true;
      binds = with config.lib.niri.actions; {
        "Mod+Backspace".action = spawn [(lib.getExe config.programs.noctalia.package) "msg" "notification-clear-active"];
        "Mod+Shift+Backspace".action = spawn [(lib.getExe config.programs.noctalia.package) "msg" "notification-dnd-toggle"];
      };
    };
  };
}
