{
  inputs,
  self,
  ...
}: let
  inherit (inputs) agenix arion deploy-rs nixpkgs skinprox;
in {
  flake = {
    nixosConfigurations.universe = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../../modules/oci-image-external.nix
        agenix.nixosModules.age
        arion.nixosModules.arion
        skinprox.nixosModules.skinprox
        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
    deploy.nodes.universe = {
      hostname = "scrumplex.net";
      sshUser = "root";
      sshOpts = ["-p" "22701"];
      profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.universe;
    };
  };
}
