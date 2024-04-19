{
  inputs,
  pkgs,
  ...
}: {
  # TODO: use overlay once we are on 24.05
  services.nginx.virtualHosts."honeyarcus.art" = {
    forceSSL = true;
    enableACME = true;
    quic = true;
    http3_hq = true;
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
}
