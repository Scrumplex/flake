{
  inputs,
  self,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (inputs) agenix nixpkgs nixos-hardware srvos;
in {
  flake.nixosConfigurations.eclipse = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {
          _module.args.deploy = {
            targetHost = "eclipse.lan";
            extraFlags = ["--verbose" "--print-build-logs"];
          };
        }
        srvos.nixosModules.server
        srvos.nixosModules.mixins-systemd-boot
        agenix.nixosModules.age
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
    specialArgs = {inherit inputs;};
  };
}
