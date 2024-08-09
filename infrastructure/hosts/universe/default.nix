{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (inputs) agenix nixpkgs srvos;
in {
  flake = {
    nixosConfigurations.universe = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          srvos.nixosModules.server
          srvos.nixosModules.mixins-systemd-boot
          agenix.nixosModules.age
          ./configuration.nix
        ]
        ++ attrValues self.nixosModules;
      specialArgs = {inherit inputs;};
    };
    nixosHosts.universe = "scrumplex.net";
  };
}
