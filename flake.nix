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
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    screenshot-bash = {
      url = "git+https://codeberg.org/Scrumplex/screenshot-bash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig.extra-substituters = [
    "https://prismlauncher.cachix.org"
    "https://pre-commit-hooks.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
    "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
  ];

  outputs = { self, nixpkgs, flake-utils, nixos-hardware, pre-commit-hooks
    , home-manager, prismlauncher, screenshot-bash, ... }:

    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = { nixfmt.enable = true; };
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = with pkgs; [ nixfmt ];
        };
      }) // (let
        system = "x86_64-linux";
        scrumpkgs = final: import ./pkgs;
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays =
            [ prismlauncher.overlay screenshot-bash.overlay scrumpkgs ];
        };

        mkHost = { hostName, system, pkgs, modules }: {
          ${hostName} = nixpkgs.lib.nixosSystem {
            inherit system;
            inherit pkgs;

            modules = [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
              }
              ./hosts/common
              ./hosts/${hostName}
              ({ lib, ... }: { networking.hostName = lib.mkDefault hostName; })
            ] ++ modules;
          };
        };
      in {
        nixosConfigurations = (mkHost {
          inherit system;
          inherit pkgs;

          hostName = "andromeda";

          modules = [
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc-ssd

            ./homes/scrumplex
          ];
          #}) // (mkHost {
          #  inherit system;
          #  inherit pkgs;

          #  hostName = "dyson";

          #  modules = [
          #    nixos-hardware.nixosModules.framework-12th-gen-intel

          #    ./homes/scrumplex
          #  ];
        });
      });
}
