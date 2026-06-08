{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    programs.niri.settings.binds."Mod+D" = {
      hotkey-overlay.title = "Open launcher";
      action = config.lib.niri.actions.spawn [(lib.getExe config.programs.noctalia.package) "msg" "panel-open" "launcher"];
    };
  };
}
