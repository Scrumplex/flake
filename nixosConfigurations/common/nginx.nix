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
        listen = [
          {
            addr = "127.0.0.1";
            port = 8993;
          }
        ];
      };
    };
  };

  config = {
    services.nginx = {
      enable = true;
      enableReload = true;

      additionalModules = with pkgs.nginxModules; [
        brotli
      ];

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;

      appendHttpConfig = ''
        server_names_hash_bucket_size 128;
      '';
    };
  };
}
