{
  config,
  lib,
  pkgs,
  ...
}: {
  options.common.nginx = {
    vHost = lib.mkOption {
      type = lib.types.anything;
      default = {
        quic = true;
        http3_hq = true;
      };
    };
    sslVHost = lib.mkOption {
      type = lib.types.anything;
      default = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
        '';
      };
    };
  };

  config = {
    services.nginx = {
      enable = true;
      enableReload = true;
      enableQuicBPF = true;

      package = pkgs.nginxQuic;

      additionalModules = with pkgs.nginxModules; [
        brotli
      ];

      statusPage = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      appendHttpConfig = ''
        server_names_hash_bucket_size 128;
      '';
    };

    networking.firewall = {
      allowedUDPPorts = [80 443];
      allowedTCPPorts = [80 443];
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "contact@scrumplex.net";
      };
    };

    services.prometheus = {
      exporters.nginx.enable = true;
      scrapeConfigs = [
        {
          job_name = "nginx";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.nginx.port}"];
            }
          ];
        }
      ];
    };
  };
}
