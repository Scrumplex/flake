{
  inputs,
  pkgs,
  ...
}: {
  # TODO: use overlay once we are on 24.05
  services.nginx.virtualHosts."honeyarcus.art" = {
    root = inputs.honeylinks-website.packages.${pkgs.system}.honeylinks-website;
    extraConfig = ''
      location ~* \.html$ {
        expires 1h;
      }
      location ~* \.(css|js|svg|png|eot|woff2?)$ {
        expires max;
      }
    '';
  };

  services.traefik.dynamicConfigOptions.http.routers.honeylinks = {
    entryPoints = ["websecure"];
    service = "nginx";
    rule = "Host(`honeyarcus.art`)";
  };
}
