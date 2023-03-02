{config, ...}: {
  services.mako = with config.theme.colors; {
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
}
