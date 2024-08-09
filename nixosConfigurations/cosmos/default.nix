{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (inputs) agenix nixpkgs nixos-hardware srvos;
in {
  flake.nixosConfigurations.cosmos = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      [
        {
          _module.args.deploy = {
            targetHost = "cosmos.lan";
            extraFlags = ["--verbose" "--print-build-logs"];
          };
        }
        srvos.nixosModules.server
        agenix.nixosModules.age
        nixos-hardware.nixosModules.raspberry-pi-4
        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
    specialArgs = {inherit inputs;};
  };
}
