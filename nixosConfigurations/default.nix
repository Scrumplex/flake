{inputs, ...}: let
  inherit (inputs) agenix lanzaboote nixos-hardware nixpkgs nixpkgs-wayland prismlauncher scrumpkgs wlx-overlay-x;

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

            networking.hostName = hostName;

            system.role.desktop = true;
            system.role.home = true;
            system.role.gaming = true;
          }

          agenix.nixosModules.age
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
  flake.nixosConfigurations =
    (mkHost {
      system = "x86_64-linux";
      hostName = "andromeda";
      modules = [
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
      ];
    })
    // (mkHost {
      system = "x86_64-linux";
      hostName = "dyson";
      modules = [nixos-hardware.nixosModules.framework-12th-gen-intel];
    });
}
