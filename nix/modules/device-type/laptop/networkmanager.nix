{
  flake.modules.nixos.laptop = {
    networking.networkmanager.enable = true;

    services.avahi.enable = true;
  };

  flake.modules.homeManager.laptop = {
    xsession.preferStatusNotifierItems = true; # needed for network-manager-applet
    services.network-manager-applet.enable = true;
  };
}
