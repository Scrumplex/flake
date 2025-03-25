{inputs, ...}: {
  home-manager.sharedModules = [inputs.self.homeModules.wayvnc];

  networking.firewall.allowedTCPPorts = [5900];

  hm.services.wayvnc = {
    enable = true;
    settings.address = "0.0.0.0";
  };
}
