{
  flake.modules.nixos."machine-universe" = {config, ...}: let
    otlpEndpoint = "[::1]:${toString config.alloc.tcpPorts.blocks.alloy-external-receiver.start}";
  in {
    age.secrets."alloy-htaccess" = {
      file = ./alloy-htaccess.age;
      owner = "traefik";
      inherit (config.services.traefik) group;
    };

    alloc.tcpPorts.blocks.alloy-external-receiver.length = 1;

    environment.etc."alloy/external-receiver.alloy".text = ''
      otelcol.receiver.otlp "external_receiver" {
        http {
          endpoint = "${otlpEndpoint}"
        }

        output {
          logs    = [otelcol.processor.batch.lgtm.input]
          metrics = [otelcol.processor.interval.lgtm.input]
          traces  = [otelcol.processor.batch.lgtm.input]
        }
      }
    '';

    services.traefik.dynamic.files."lgtm".settings.http = {
      middlewares.alloy-auth.basicAuth = {
        usersFile = config.age.secrets."alloy-htaccess".path;
        realm = "alloy";
      };
      routers.alloy = {
        entryPoints = ["websecure"];
        middlewares = ["alloy-auth"];
        service = "alloy";
        rule = "Host(`otlp.scrumplex.net`)";
      };
      services.alloy.loadBalancer.servers = [{url = otlpEndpoint;}];
    };
  };
}
