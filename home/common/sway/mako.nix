{...}: {
  programs.mako = {
    enable = true;
    font = "Monocraft 10";
    borderRadius = 12;
    borderSize = 2;
    backgroundColor = "#1e1e2e"; # base
    textColor = "#cdd6f4"; # text
    borderColor = "#89b4fa"; # blue
    progressColor = "over #313244"; # surface0
    extraConfig = ''
      [urgency=critical]
      layer=overlay
      anchor=top-center
      # maroon
      border-color=#eba0ac

      [mode=dnd]
      invisible=1
    '';
  };
}
