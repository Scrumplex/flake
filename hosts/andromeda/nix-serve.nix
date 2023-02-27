{config, ...}: {
  age.secrets."cache-priv-key.pem" = {
    file = ../../secrets/andromeda/cache-key.age;
    mode = "600";
    owner = "nix-serve";
    group = "nix-serve";
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets."cache-priv-key.pem".path;
    openFirewall = true;
  };
}
