{config, ...}: {
  services.hetzner-dyndns = {
    enable = true;
    zone = "sefa.cloud";
    record = "@";
    ipv6 = {
      enable = true;
      interface = "enp7s0";
    };
    environmentFile = config.age.secrets."hetzner-api-token.env".path;
  };
}
