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

    alloc.tcpPorts.blocks.prometheus-nginx-exporter.length = 1;

    services.prometheus.exporters.nginx = {
      enable = true;
      port = config.alloc.tcpPorts.blocks.prometheus-nginx-exporter.start;
    };

    services.alloy.scrape = [
      {
        targets = ["localhost:${toString config.services.prometheus.exporters.nginx.port}"];
      }
    ];
  };
}
