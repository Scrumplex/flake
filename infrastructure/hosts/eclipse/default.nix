{
  inputs,
  self,
  ...
}: let
  inherit (inputs) agenix arion deploy-rs nixpkgs nixos-hardware srvos;
in {
  flake = {
    nixosConfigurations.eclipse = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../../modules/oci-image-external.nix
        srvos.nixosModules.server
        srvos.nixosModules.mixins-systemd-boot
        agenix.nixosModules.age
        arion.nixosModules.arion
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
    deploy.nodes.eclipse = {
      hostname = "eclipse.lan";
      sshUser = "root";
      sshOpts = ["-p" "22701"];
      fastConnection = true;
      profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.eclipse;
    };
  };
}
