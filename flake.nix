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
      inputs.flake-utils.follows = "flake-utils";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
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
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [nix-serve-ng.overlays.default prismlauncher.overlays.default screenshot-bash.overlays.default self.overlays.default];
      };

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

                home-manager.sharedModules = pkgs.lib.attrValues self.hmModules;
              }
              agenix.nixosModules.age
              lanzaboote.nixosModules.lanzaboote
              ./host/common
              ./host/${hostName}
              ({lib, ...}: {networking.hostName = lib.mkDefault hostName;})

              (import ./home username)
            ]
            ++ (pkgs.lib.attrValues self.nixosModules)
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
    })
    // {
      hmModules = {
        beets = import ./modules/hm/beets.nix;
        catppuccin = import ./modules/hm/catppuccin.nix;
        fish-theme = import ./modules/hm/fish-theme.nix;
        fuzzel = import ./modules/hm/fuzzel.nix;
        jellyfin-mpv-shim = import ./modules/hm/jellyfin-mpv-shim.nix;
        pipewire = import ./modules/hm/pipewire.nix;
      };
      nixosModules = {
        flatpak-icons-workaround = import ./modules/nixos/flatpak-icons-workaround.nix;
      };
      overlays.default = import ./pkgs;
    };
}
