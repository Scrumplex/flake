{inputs, ...}: let
  modulePath = "services/web-servers/traefik.nix";
in {
  flake.modules.nixos.ext-traefik = {
    disabledModules = [modulePath];
    imports = ["${inputs.nixpkgs-fork-traefik}/nixos/modules/${modulePath}"];
  };
}
