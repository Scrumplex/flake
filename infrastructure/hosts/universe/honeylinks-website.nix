{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # TODO: use overlay once we are on 24.05
  services.nginx.virtualHosts."honeyarcus.art" = lib.mkMerge [
    config.common.nginx.vHost
    config.common.nginx.sslVHost
    {
      root = inputs.honeylinks-website.packages.${pkgs.system}.honeylinks-website;
      locations = {
        "~* \.html$".extraConfig = ''
          expires 1h;
        '';
        "~* \.(css|js|svg|png|eot|woff2?)$".extraConfig = ''
          expires max;
        '';
      };
    }
  ];
}
