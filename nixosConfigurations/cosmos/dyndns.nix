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
    environmentFile = config.age.secrets."hetzner-api-token.env".path;
  };
}
