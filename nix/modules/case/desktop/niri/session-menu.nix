{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    programs.niri.settings.binds."Mod+Shift+E".action = config.lib.niri.actions.spawn [(lib.getExe config.programs.noctalia.package) "msg" "panel-open" "session"];
  };
}
