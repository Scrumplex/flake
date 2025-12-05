{
  config,
  inputs,
  ...
}: {
  imports = [inputs.self.nixosModules.hetzner-dyndns];

  age.secrets."hetzner-api-token.env".file = ./hetzner-api-token.env.age;

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
}
