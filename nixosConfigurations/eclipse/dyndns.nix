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
    record = "@";
    # Currently our split reverse-proxy setup doesn't allow for this.
    # Perhaps we should move all internal services into a container so we can assign a completely separate IP address to them?
    #ipv6.enable = true;
    environmentFile = config.age.secrets."hetzner-api-token.env".path;
  };
}
