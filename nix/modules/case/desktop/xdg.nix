{
  flake.modules.homeManager.desktop = {
    xdg = {
      autostart.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      portal.xdgOpenUsePortal = true;
    };
  };
}
