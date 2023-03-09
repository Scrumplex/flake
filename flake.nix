{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-serve-ng = {
      url = "github:aristanetworks/nix-serve-ng";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    screenshot-bash = {
      url = "git+https://codeberg.org/Scrumplex/screenshot-bash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixos-hardware,
    pre-commit-hooks,
    home-manager,
    agenix,
    lanzaboote,
    nix-serve-ng,
    prismlauncher,
    screenshot-bash,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
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
        packages = with pkgs; [alejandra agenix.packages.${system}.agenix];
      };
    })
    // (let
      system = "x86_64-linux";
      scrumpkgs = import ./pkgs;
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [nix-serve-ng.overlays.default prismlauncher.overlay screenshot-bash.overlays.default scrumpkgs];
      };
      scrumModules = import ./modules;

      username = "scrumplex";

      mkHost = {
        hostName,
        system,
        pkgs,
        modules,
      }: {
        ${hostName} = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;

          modules =
            [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.sharedModules = scrumModules;
              }
              agenix.nixosModules.age
              lanzaboote.nixosModules.lanzaboote
              ./host/common
              ./host/${hostName}
              ({lib, ...}: {networking.hostName = lib.mkDefault hostName;})

              (import ./home username)
            ]
            ++ modules;
        };
      };
    in {
      nixosConfigurations =
        (mkHost {
          inherit system;
          inherit pkgs;

          hostName = "andromeda";

          modules = [
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        })
        // (mkHost {
          inherit system;
          inherit pkgs;

          hostName = "dyson";

          modules = [nixos-hardware.nixosModules.framework-12th-gen-intel];
        });
    });
}
