{config, ...}: {
  flake.modules.nixos.laptop = {
    networking.networkmanager.enable = true;

    services.avahi.enable = true;

    users.users.${config.flake.meta.username}.extraGroups = ["networkmanager"];
  };

  flake.modules.homeManager.laptop = {
    xsession.preferStatusNotifierItems = true; # needed for network-manager-applet
    services.network-manager-applet.enable = true;
  };
}
