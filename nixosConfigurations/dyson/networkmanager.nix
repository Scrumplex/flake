{...}: {
  networking.networkmanager.enable = true;

  hm = {
    xsession.preferStatusNotifierItems = true; # needed for network-manager-applet
    services.network-manager-applet.enable = true;
  };
}
