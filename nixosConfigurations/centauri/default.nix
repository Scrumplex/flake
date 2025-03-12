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
          targetHost = "root@centauri.lan";
          extraFlags = ["--verbose" "--print-build-logs"];
        })
        ../common
        ../common/nix.nix
        ../common/openssh.nix
        ../common/server.nix
        ../common/utils.nix

        ./configuration.nix
        ./disks.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
