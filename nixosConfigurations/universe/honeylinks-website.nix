{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  services.nginx.virtualHosts."honeyarcus.art" = lib.mkMerge [
    config.common.nginx.vHost
    {
      # TODO: use overlay once Nixpkgs Node.js tooling works again
      root = inputs.honeylinks-website.packages.${pkgs.stdenv.hostPlatform.system}.honeylinks-website;
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

  services.traefik.dynamic.files."honeyarcus-art".settings.http.routers.honeyarcus-art = {
    entryPoints = ["websecure"];
    service = "nginx";
    rule = "Host(`honeyarcus.art`)";
  };
}
