{
  description = "scrumplex.net Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, agenix }:
    {
      colmena = {
        meta.name = "scrumplex.net";
        meta.description = "scrumplex.net Network";
        meta.nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };

        defaults.imports = [ "${agenix}/modules/age.nix" ];

        spacehub = {
          deployment.targetHost = "scrumplex.net";
          deployment.targetPort = 22701;

          age.secrets.id_borgbase.file = secrets/spacehub/id_borgbase.age;
          age.secrets."wireguard.key".file = secrets/spacehub/wireguard.key.age;
          age.secrets."hetzner.key".file = secrets/spacehub/hetzner.key.age;

          imports = [ ./hosts/spacehub ];
        };

        duckhub = {
          deployment.targetHost = "duckhub.io";
          deployment.targetPort = 22701;

          age.secrets.id_borgbase.file = secrets/duckhub/id_borgbase.age;
          age.secrets."wireguard.key".file = secrets/duckhub/wireguard.key.age;
          age.secrets."hetzner.key".file = secrets/duckhub/hetzner.key.age;

          imports = [ ./hosts/duckhub ];
        };
      };
    }
    //
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.colmena
            agenix.defaultPackage.${system}
          ];
        };
        packages.default = pkgs.colmena;
      });
}
