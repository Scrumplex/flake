{
  self,
  inputs,
  ...
}: let
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

          ../host/common
          ../host/${hostName}
          (import ../home username)
        ]
        ++ (attrValues self.nixosModules)
        ++ modules;

      specialArgs = {inherit inputs;};
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
