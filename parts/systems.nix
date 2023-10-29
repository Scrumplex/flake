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

          (import ../roles "nixos")
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
      work = let
        system = "aarch64-darwin";
      in
        nix-darwin.lib.darwinSystem {
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

              system.configurationRevision = self.rev or self.dirtyRev or null;
              nixpkgs.hostPlatform = system;
            }

            (import ../roles "darwin")
            ../host/T00179100c
          ];

          inherit inputs;
        };
    };
  };
}
