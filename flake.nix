{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-serve-ng = {
      url = "github:aristanetworks/nix-serve-ng";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    screenshot-bash = {
      url = "git+https://codeberg.org/Scrumplex/screenshot-bash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake =
        {
          hmModules = {
            catppuccin = import ./modules/hm/catppuccin.nix;
            fish-theme = import ./modules/hm/fish-theme.nix;
            jellyfin-mpv-shim = import ./modules/hm/jellyfin-mpv-shim.nix;
            pipewire = import ./modules/hm/pipewire.nix;
          };
          nixosModules = {
            flatpak-icons-workaround = import ./modules/nixos/flatpak-icons-workaround.nix;
          };
          overlays.default = import ./pkgs;
        }
        // (let
          username = "scrumplex";

          inherit (inputs) agenix home-manager lanzaboote nix-serve-ng nixpkgs prismlauncher screenshot-bash;

          inherit (nixpkgs.lib) attrValues;

          mkHost = {
            hostName,
            system,
            modules,
            overlays ? [nix-serve-ng.overlays.default prismlauncher.overlays.default screenshot-bash.overlays.default] ++ [self.overlays.default],
          }: {
            ${hostName} = nixpkgs.lib.nixosSystem {
              inherit system;

              modules =
                [
                  {
                    nixpkgs = {
                      config.allowUnfree = true;

                      inherit overlays;
                    };

                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      sharedModules = attrValues self.hmModules;
                    };
                    networking.hostName = hostName;
                  }

                  agenix.nixosModules.age
                  home-manager.nixosModules.home-manager
                  lanzaboote.nixosModules.lanzaboote

                  ./host/common
                  ./host/${hostName}
                  (import ./home username)
                ]
                ++ (attrValues self.nixosModules)
                ++ modules;

              specialArgs = {inherit inputs;};
            };
          };
        in {
          nixosConfigurations =
            (mkHost {
              system = "x86_64-linux";
              hostName = "andromeda";
              modules = with inputs; [
                nixos-hardware.nixosModules.common-cpu-amd-pstate
                nixos-hardware.nixosModules.common-gpu-amd
                nixos-hardware.nixosModules.common-pc-ssd
              ];
            })
            // (mkHost {
              system = "x86_64-linux";
              hostName = "dyson";
              modules = [inputs.nixos-hardware.nixosModules.framework-12th-gen-intel];
            });
        });

      imports = [
        inputs.pre-commit-hooks.flakeModule
      ];

      perSystem = {
        config,
        inputs',
        pkgs,
        ...
      }: {
        pre-commit.settings.hooks.alejandra.enable = true;
        devShells.default = pkgs.mkShell {
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';

          packages = [pkgs.alejandra inputs'.agenix.packages.agenix];
        };
      };

      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
