{
  config,
  pkgs,
  ...
}: {
  age.secrets."cache-priv-key.pem".file = ../../secrets/andromeda/cache-key.age;

  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = config.age.secrets."cache-priv-key.pem".path;
    openFirewall = true;
  };
}
