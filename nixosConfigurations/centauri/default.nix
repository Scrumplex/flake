{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "centauri";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "centauri.sefa.cloud";
          extraFlags = ["--verbose" "--print-build-logs"];
        })
        ../common
        ../common/nix.nix
        ../common/openssh.nix
        ../common/server.nix
        ../common/upgrade.nix
        ../common/utils.nix

        ./configuration.nix
        ./disks.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
