{lib, ...}: {
  flake.modules.homeManager."desktop" = {
    config,
    pkgs,
    ...
  }: {
    programs.noctalia-shell.settings.appLauncher = {
      density = "default";
      iconMode = "native";
      position = "center";
      terminalCommand = lib.getExe pkgs.termapp;
    };

    programs.niri.settings.binds."Mod+D" = {
      hotkey-overlay.title = "Open launcher";
      action = config.lib.niri.actions.spawn [(lib.getExe config.programs.noctalia-shell.package) "ipc" "call" "launcher" "toggle"];
    };
  };
}
