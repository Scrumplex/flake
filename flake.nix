{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
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

  nixConfig.extra-substituters = [ "https://prismlauncher.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [
    "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
  ];

  outputs = { nixpkgs, nixos-hardware, home-manager, prismlauncher
    , screenshot-bash, ... }:
    let
      system = "x86_64-linux";
      myPackages = final: import ./pkgs;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ prismlauncher.overlay screenshot-bash.overlay myPackages ];
      };

      mkHost = { hostName, system, pkgs, modules }:
        nixpkgs.lib.nixosSystem {
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
    in {
      nixosConfigurations.andromeda = mkHost {
        inherit system;
        inherit pkgs;

        hostName = "andromeda";

        modules = [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd

          ./homes/scrumplex
        ];
      };
    };
}
