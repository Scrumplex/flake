{pkgs, ...}: {
  services.nginx = {
    enable = true;
    enableReload = true;
    enableQuicBPF = true;

    package = pkgs.nginxQuic;

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
  };

  networking.firewall = {
    allowedUDPPorts = [
      80
      443
    ];
    allowedTCPPorts = [
      80
      443
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "contact@scrumplex.net";
    };
  };
}
