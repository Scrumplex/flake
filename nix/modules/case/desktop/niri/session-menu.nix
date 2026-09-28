{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    wayland.windowManager.niri.settings.binds."Mod+Shift+E".spawn = [(lib.getExe config.programs.noctalia.package) "msg" "panel-open" "session"];
  };
}
