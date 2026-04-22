{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge;
  commonVHostFor = pkg: {
    root = pkg;
    locations = {
      "~* \.html$".extraConfig = ''
        expires 1h;
      '';
      "~* \.(css|js|svg|png|eot|woff2?)$".extraConfig = ''
        expires max;
      '';
    };
    extraConfig = ''
      add_header Onion-Location http://oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion$request_uri;
    '';
  };
in {
  age.secrets."scrumplex-hs_ed25519_secret_key".file = ../../secrets/universe/scrumplex-hs_ed25519_secret_key.age;

  nixpkgs.overlays = [inputs.scrumplex-website.overlays.default inputs.scrumplex-website-ng.overlays.default];

  services.nginx.virtualHosts = {
    "beta.scrumplex.net" = mkMerge [
      config.common.nginx.vHost
      (commonVHostFor pkgs.scrumplex-website-ng)
    ];
    "scrumplex.net" = mkMerge [
      config.common.nginx.vHost
      (commonVHostFor pkgs.scrumplex-website)
    ];
    "oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion" = mkMerge [
      config.common.nginx.vHost
      (commonVHostFor pkgs.scrumplex-website)
    ];
  };

  services.traefik.dynamic.files."scrumplex-net".settings.http.routers = {
    scrumplex-net-onion = {
      entryPoints = ["websecure"];
      service = "nginx";
      rule = "Host(`oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion`)";
    };
    beta-scrumplex-net = {
      entryPoints = ["websecure"];
      service = "nginx";
      rule = "Host(`beta.scrumplex.net`)";
    };
    scrumplex-net = {
      entryPoints = ["websecure"];
      service = "nginx";
      rule = "Host(`scrumplex.net`)";
    };
  };

  services.tor = {
    enable = true;
    relay.onionServices."scrumplex" = {
      map = [
        {
          port = 80;
          target = {
            addr = "localhost";
            port = 80;
          };
        }
      ];
      secretKey = config.age.secrets."scrumplex-hs_ed25519_secret_key".path;
    };
  };
}
