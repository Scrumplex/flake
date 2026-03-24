{
  flake.modules.homeManager.desktop = {
    xdg = {
      autostart.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
      };
      portal.xdgOpenUsePortal = true;
    };
  };
}
