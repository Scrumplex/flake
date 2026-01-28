{
  flake.modules.nixos."machine-galileo" = {
    hardware.facter = {
      reportPath = ./facter.json;
      detected.dhcp.enable = false;
    };

    networking.useDHCP = false;
  };
}
