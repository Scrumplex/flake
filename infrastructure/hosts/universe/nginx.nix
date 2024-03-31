{pkgs, ...}: {
  services.nginx = {
    enable = true;
    enableReload = true;

    additionalModules = with pkgs.nginxModules; [
      brotli
      zstd
    ];

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;

    defaultListen = [
      {
        addr = "127.0.0.1";
        port = 81;
      }
    ];
  };

  services.traefik.dynamicConfigOptions.http.services.nginx.loadBalancer.servers = [{url = "http://localhost:81";}];
}
