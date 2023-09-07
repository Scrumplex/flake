{inputs, ...}: let
  username = "scrumplex";

  inherit (inputs) agenix home-manager lanzaboote nixpkgs nixpkgs-wayland prismlauncher scrumpkgs;

  inherit (nixpkgs.lib) attrValues;

  mkHost = {
    hostName,
    system,
    modules,
    overlays ? [nixpkgs-wayland.overlay prismlauncher.overlays.default scrumpkgs.overlays.default],
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
              sharedModules = attrValues scrumpkgs.hmModules;
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

          ../host/common
          ../host/${hostName}
          (import ../home username)
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
  flake.nixosConfigurations =
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
}
