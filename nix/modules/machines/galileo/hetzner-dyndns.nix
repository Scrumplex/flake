{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    services.hetzner-dyndns = {
      enable = true;
      zone = "sefa.cloud";
      record = "arson";
      ipv6 = {
        enable = true;
        interface = "wlan0";
      };
      environmentFile = config.age.secrets."hetzner-api-token.env".path;
    };
  };
}
