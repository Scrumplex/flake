{config, ...}: let
  fpConfig = config;
in {
  flake.modules.nixos."desktop" = {config, ...}: {
    networking.firewall.allowedTCPPorts = [config.home-manager.users.${fpConfig.flake.meta.username}.services.wayvnc.settings.port];
  };

  flake.modules.homeManager."desktop" = {
    services.wayvnc = {
      enable = true;
      settings = {
        address = "0.0.0.0";
        port = 5900;
      };
    };
  };
}
