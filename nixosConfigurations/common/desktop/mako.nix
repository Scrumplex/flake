{
  config,
  lib,
  lib',
  ...
}: {
  hm.catppuccin.mako.enable = true;
  hm.services.mako = {
    enable = true;
    font = "Monocraft 10";
    borderRadius = 12;
    borderSize = 2;
    extraConfig = ''
      [urgency=critical]
      layer=overlay
      anchor=top-center

      [mode=dnd]
      invisible=1
    '';
  };
  hm.wayland.windowManager.sway.config.keybindings = lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+Backspace" "${lib.getExe' config.hm.services.mako.package "makoctl"} dismiss";
}
