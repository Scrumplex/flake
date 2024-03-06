{
  config,
  lib,
  lib',
  ...
}: {
  hm.services.mako = with config.hm.theme.colors; {
    enable = true;
    font = "Monocraft 10";
    borderRadius = 12;
    borderSize = 2;
    backgroundColor = "#${base}";
    textColor = "#${text}";
    borderColor = "#${blue}";
    progressColor = "over #${surface0}";
    extraConfig = ''
      [urgency=critical]
      layer=overlay
      anchor=top-center
      border-color=#${maroon}

      [mode=dnd]
      invisible=1
    '';
  };
  hm.wayland.windowManager.sway.config.keybindings = lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+Backspace" "${lib.getExe' config.hm.services.mako.package "makoctl"} dismiss";
}
