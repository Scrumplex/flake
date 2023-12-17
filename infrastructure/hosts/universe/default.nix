{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (inputs) agenix arion deploy-rs nixpkgs skinprox srvos;
in {
  flake = {
    nixosConfigurations.universe = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          srvos.nixosModules.server
          srvos.nixosModules.mixins-systemd-boot
          agenix.nixosModules.age
          arion.nixosModules.arion
          skinprox.nixosModules.skinprox
          ./configuration.nix
        ]
        ++ attrValues self.nixosModules;
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
