{config, ...}: let
  inherit (builtins) readFile;
in {
  age.secrets."ca_intermediate.key" = {
    file = ../../secrets/eclipse/ca_intermediate.key.age;
    owner = "step-ca";
    group = "step-ca";
  };
  age.secrets."ca_intermediate.pass" = {
    file = ../../secrets/eclipse/ca_intermediate.pass.age;
    owner = "step-ca";
    group = "step-ca";
  };

  # step certificate create --profile root-ca "Home CA" root_ca.crt root_ca.key
  # step certificate create --profile intermediate-ca --ca ./root_ca.crt --ca-key ./root_ca.key "Home Intermediate CA 1" intermediate_ca.crt intermediate_ca.key
  services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 9443;
    intermediatePasswordFile = config.age.secrets."ca_intermediate.pass".path;
    settings = {
      dnsNames = ["sefa.cloud" "localhost" "127.0.0.1" "10.10.10.12"];
      root = ../../extra/ca_root.crt;
      crt = ../../extra/ca_intermediate.crt;
      key = config.age.secrets."ca_intermediate.key".path;
      db = {
        type = "badger";
        dataSource = "/var/lib/step-ca/db";
      };
      authority = {
        claims = {
          minTLSCertDuration = "168h"; # 7d
          maxTLSCertDuration = "4320h"; # 180d
          defaultTLSCertDuration = "2160h"; # 90d
        };
        provisioners = [
          {
            type = "ACME";
            name = "acme";
          }
        ];
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.step-ca = {
      entryPoints = ["localsecure"];
      service = "step-ca";
      rule = "Host(`tls.sefa.cloud`)";
    };
    services.step-ca.loadBalancer.servers = [{url = "https://localhost:${toString config.services.step-ca.port}";}];
  };

  security.pki.certificates = [
    (readFile config.services.step-ca.settings.root)
  ];
}
