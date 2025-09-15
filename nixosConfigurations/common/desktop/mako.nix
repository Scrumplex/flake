{
  config,
  lib,
  ...
}: {
  hm = {
    #catppuccin.mako.enable = true;
    services.mako = {
      enable = true;
      settings = {
        font = "Monocraft 10";
        border-radius = "12";
        border-size = "2";
        "mode=dnd".invisible = 1;
      };
    };
    programs.niri.settings.binds."Mod+Backspace".action = config.hm.lib.niri.actions.spawn [(lib.getExe' config.hm.services.mako.package "makoctl") "dismiss"];
  };
}
