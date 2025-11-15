{
  flake.modules.nixos.desktop = {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
  };
}
