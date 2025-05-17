{
  config,
  lib,
  lib',
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
    wayland.windowManager.sway.config.keybindings = lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+Backspace" "${lib.getExe' config.hm.services.mako.package "makoctl"} dismiss";
  };
}
