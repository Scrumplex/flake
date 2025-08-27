{
  config,
  lib,
  ...
}: {
  hm = {
    catppuccin.fuzzel = {
      enable = true;
      accent = "peach";
    };
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "Monocraft:size=13";
        };
        border = {
          width = 2;
          radius = 12;
        };
      };
    };

    programs.niri.settings.binds."Mod+D" = {
      hotkey-overlay.title = "Open launcher";
      action = config.hm.lib.niri.actions.spawn [(lib.getExe config.hm.programs.fuzzel.package)];
    };
  };
}
