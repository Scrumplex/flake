{
  flake.modules.nixos.desktop.networking.firewall = {
    allowedTCPPorts = [22000];
    allowedUDPPorts = [21027 22000];
  };

  flake.modules.homeManager.desktop.services.syncthing.enable = true;
}
