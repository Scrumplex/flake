{config, ...}: {
  age.secrets."cache-priv-key.pem".file = ../../secrets/andromeda/cache-key.age;

  services.harmonia = {
    enable = true;
    signKeyPath = config.age.secrets."cache-priv-key.pem".path;
    settings.bind = "0.0.0.0:5000";
  };

  networking.firewall.allowedTCPPorts = [5000];
}
