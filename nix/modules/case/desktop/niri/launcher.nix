{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    wayland.windowManager.niri.settings.binds."Mod+D" = {
      _props.hotkey-overlay-title = "Open launcher";
      spawn = [(lib.getExe config.programs.noctalia.package) "msg" "panel-open" "launcher"];
    };
  };
}
