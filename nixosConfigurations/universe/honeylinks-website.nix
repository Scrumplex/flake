{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  services.nginx.virtualHosts."honeyarcus.art" = lib.mkMerge [
    config.common.nginx.vHost
    config.common.nginx.sslVHost
    {
      # TODO: use overlay once Nixpkgs Node.js tooling works again
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
