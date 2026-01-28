{
  flake.modules.nixos."machine-galileo" = {
    networking = {
      hostName = "galileo";
      domain = "lan";
    };
  };
}
