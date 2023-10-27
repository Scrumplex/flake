{
  inputs,
  self,
  ...
}: let
  inherit (inputs) agenix catppuccin home-manager lanzaboote nixpkgs nixpkgs-wayland nix-darwin nix-index-database prismlauncher scrumpkgs wlx-overlay-x;

  inherit (nixpkgs.lib) attrValues;

  mkHost = {
    hostName,
    system,
    modules,
    overlays ? [nixpkgs-wayland.overlay prismlauncher.overlays.default wlx-overlay-x.overlays.default scrumpkgs.overlays.default],
  }: {
    ${hostName} = nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          {
            nixpkgs = {inherit overlays;};

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules =
                attrValues scrumpkgs.hmModules
                ++ [
                  catppuccin.homeManagerModules.catppuccin
                  nix-index-database.hmModules.nix-index
                ];
              extraSpecialArgs = {
                inherit inputs;
                lib' = scrumpkgs.lib;
              };
            };
            networking.hostName = hostName;

            system.role.desktop = true;
            system.role.home = true;
            system.role.gaming = true;
          }

          agenix.nixosModules.age
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote

          ../roles
          ../host/common
          ../host/${hostName}
          ../home
        ]
        ++ (attrValues scrumpkgs.nixosModules)
        ++ modules;

      specialArgs = {
        inherit inputs;
        lib' = scrumpkgs.lib;
      };
    };
  };
in {
  flake = {
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
    darwinConfigurations = {
      work = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules =
                attrValues scrumpkgs.hmModules
                ++ [
                  catppuccin.homeManagerModules.catppuccin
                  nix-index-database.hmModules.nix-index
                ];
              extraSpecialArgs = {
                inherit inputs;
                lib' = scrumpkgs.lib;
              };
            };
            # Auto upgrade nix package and the daemon service.
            services.nix-daemon.enable = true;
            # nix.package = pkgs.nix;

            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

            # Create /etc/zshrc that loads the nix-darwin environment.
            programs.zsh.enable = true; # default shell on catalina
            # programs.fish.enable = true;
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 4;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";
          }
        ];
      };
    };
  };
}
