{config, ...}: {
  age.secrets."quassel-cert.pem" = {
    file = ../../secrets/eclipse/quassel-cert.pem.age;
    owner = "quassel"; # Use module cfg.user once it has a default value
  };

  services.quassel = {
    enable = true;
    interfaces = ["0.0.0.0" "::"];
    certificateFile = config.age.secrets."quassel-cert.pem".path;
  };

  networking.firewall.allowedTCPPorts = [config.services.quassel.portNumber];
}
