{
  description = "scrumplex.net Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arion = {
      url = "github:hercules-ci/arion";
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
    nixos-hardware,
    agenix,
    arion,
    pre-commit-hooks,
  }:
    {
      colmena = {
        meta.name = "scrumplex.net";
        meta.description = "scrumplex.net Network";
        meta.nixpkgs = {inherit (nixpkgs) lib;};
        meta.nodeNixpkgs = {
          spacehub = nixpkgs.legacyPackages.x86_64-linux;
          duckhub = nixpkgs.legacyPackages.x86_64-linux;
          cosmos = nixpkgs.legacyPackages.aarch64-linux;
          eclipse = nixpkgs.legacyPackages.x86_64-linux;
        };

        defaults.imports = [./modules/oci-image-external.nix agenix.nixosModules.age arion.nixosModules.arion];

        spacehub = {
          deployment.targetHost = "scrumplex.net";
          deployment.targetPort = 22701;

          age.secrets.id_borgbase.file = secrets/spacehub/id_borgbase.age;
          age.secrets."wireguard.key".file = secrets/spacehub/wireguard.key.age;
          age.secrets."hetzner.key".file = secrets/spacehub/hetzner.key.age;
          age.secrets."tor-service.env".file = secrets/spacehub/tor-service.env.age;
          age.secrets."scrumplex-x-service.env".file = secrets/spacehub/scrumplex-x-service.env.age;

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

        cosmos = {
          deployment.targetHost = "cosmos.lan";
          deployment.targetPort = 22701;
          deployment.buildOnTarget = true;

          age.secrets.id_borgbase.file = secrets/cosmos/id_borgbase.age;
          age.secrets."wireguard.key".file = secrets/cosmos/wireguard.key.age;
          age.secrets."hetzner.key".file = secrets/cosmos/hetzner.key.age;

          imports = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./hosts/cosmos
          ];
        };

        eclipse = {
          deployment.targetHost = "eclipse.lan";
          deployment.targetPort = 22701;

          age.secrets."ca_intermediate.key" = {
            file = secrets/eclipse/ca_intermediate.key.age;
            owner = "step-ca";
            group = "step-ca";
          };
          age.secrets."ca_intermediate.pass" = {
            file = secrets/eclipse/ca_intermediate.pass.age;
            owner = "step-ca";
            group = "step-ca";
          };
          age.secrets.id_borgbase.file = secrets/eclipse/id_borgbase.age;

          imports = [
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/eclipse
          ];
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
