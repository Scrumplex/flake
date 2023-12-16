{
  inputs,
  self,
  ...
}: let
  inherit (inputs) agenix arion deploy-rs nixpkgs nixos-hardware srvos;
in {
  flake = {
    nixosConfigurations.cosmos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ../../modules/oci-image-external.nix
        srvos.nixosModules.server
        agenix.nixosModules.age
        arion.nixosModules.arion
        nixos-hardware.nixosModules.raspberry-pi-4
        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
    deploy.nodes.cosmos = {
      hostname = "cosmos.lan";
      sshUser = "root";
      sshOpts = ["-p" "22701"];
      fastConnection = true;
      profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cosmos;
    };
  };
}
