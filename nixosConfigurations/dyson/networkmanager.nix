{config, ...}: {
  assertions = [
    {
      assertion = !config.networking.nftables.enable;
      message = "Wireguard isn't configured with networking.nftables.enable enabled";
    }
  ];

  networking.networkmanager.enable = true;

  hm = {
    xsession.preferStatusNotifierItems = true; # needed for network-manager-applet
    services.network-manager-applet.enable = true;
  };

  networking.firewall = {
    trustedInterfaces = ["wg-home"];
    checkReversePath = false;
  };
}
