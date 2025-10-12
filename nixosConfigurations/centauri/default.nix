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
        ../common/server.nix

        ./configuration.nix
        ./disks.nix
        ./lan.nix
        ./wifi.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
