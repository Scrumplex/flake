{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (inputs) agenix nixpkgs nixos-hardware srvos;
in {
  flake = {
    nixosConfigurations.cosmos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules =
        [
          srvos.nixosModules.server
          agenix.nixosModules.age
          nixos-hardware.nixosModules.raspberry-pi-4
          ./configuration.nix
        ]
        ++ attrValues self.nixosModules;
      specialArgs = {inherit inputs;};
    };
    nixosHosts.cosmos = "cosmos.lan";
  };
}
