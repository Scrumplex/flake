{config, ...}: {
  hm.catppuccin = {
    inherit (config.catppuccin) flavor accent;
  };
  users.mutableUsers = false;

  networking.firewall = {
    allowedTCPPorts = [
      22000 # syncthing
      25565 # minecraft
    ];
    allowedUDPPorts = [
      21027 # syncthing
      22000 # syncthing
      24727 # AusweisApp2
      25565 # minecraft
    ];
  };

  services.udisks2.enable = true;
}
