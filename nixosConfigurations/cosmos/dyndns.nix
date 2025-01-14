{
  config,
  inputs,
  ...
}: {
  imports = [inputs.self.nixosModules.hetzner-dyndns];

  age.secrets."hetzner-ddns.env".file = ../../secrets/cosmos/hetzner-ddns.env.age;

  services.hetzner-dyndns = {
    enable = true;
    environmentFile = config.age.secrets."hetzner-ddns.env".path;
  };
}
