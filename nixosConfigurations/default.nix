{inputs, ...}: let
  inherit (inputs) agenix lanzaboote nixos-hardware nixpkgs nixpkgs-xr prismlauncher scrumpkgs;

  inherit (nixpkgs.lib) attrValues;

  mkHost = {
    hostName,
    system,
    modules,
    overlays ? [
      prismlauncher.overlays.default
      scrumpkgs.overlays.default
    ],
  }: {
    ${hostName} = nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          {
            nixpkgs = {inherit overlays;};

            networking.hostName = hostName;
          }

          agenix.nixosModules.age
          lanzaboote.nixosModules.lanzaboote

          nixpkgs-xr.nixosModules.nixpkgs-xr
          {nixpkgs.xr.enableUnstripped = true;}

          ./common
          ./${hostName}
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
