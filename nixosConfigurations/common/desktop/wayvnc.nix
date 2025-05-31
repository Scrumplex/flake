{config, ...}: {
  networking.firewall.allowedTCPPorts = [config.hm.services.wayvnc.settings.port];

  hm.services.wayvnc = {
    enable = true;
    settings = {
      address = "0.0.0.0";
      port = 5900;
    };
  };
}
