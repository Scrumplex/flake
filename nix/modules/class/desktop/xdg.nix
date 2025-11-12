{
  flake.modules.homeManager.desktop = {
    xdg = {
      enable = true;
      autostart.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
}
