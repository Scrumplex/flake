{
  description = "scrumplex.net Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    agenix,
    pre-commit-hooks,
  }:
    {
      colmena = {
        meta.name = "scrumplex.net";
        meta.description = "scrumplex.net Network";
        meta.nixpkgs = import nixpkgs {system = "x86_64-linux";};

        defaults.imports = ["${agenix}/modules/age.nix"];

        spacehub = {
          deployment.targetHost = "scrumplex.net";
          deployment.targetPort = 22701;

          age.secrets.id_borgbase.file = secrets/spacehub/id_borgbase.age;
          age.secrets."wireguard.key".file = secrets/spacehub/wireguard.key.age;
          age.secrets."hetzner.key".file = secrets/spacehub/hetzner.key.age;

          imports = [./hosts/spacehub];
        };

        duckhub = {
          deployment.targetHost = "duckhub.io";
          deployment.targetPort = 22701;

          age.secrets.id_borgbase.file = secrets/duckhub/id_borgbase.age;
          age.secrets."wireguard.key".file = secrets/duckhub/wireguard.key.age;
          age.secrets."hetzner.key".file = secrets/duckhub/hetzner.key.age;

          imports = [./hosts/duckhub];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {alejandra.enable = true;};
        };
      };
      devShells.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = [pkgs.colmena pkgs.alejandra agenix.packages.${system}.agenix];
      };
    });
}
