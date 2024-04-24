{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.honeylinks-website.overlays.default];

  # TODO: use overlay once we are on 24.05
  services.nginx.virtualHosts."honeyarcus.art" = lib.mkMerge [
    config.common.nginx.vHost
    config.common.nginx.sslVHost
    {
      root = pkgs.honeylinks-website;
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
