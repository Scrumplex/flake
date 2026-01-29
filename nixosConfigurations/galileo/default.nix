{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "galileo";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "root@galileo.sefa.cloud";
          extraFlags = ["--verbose" "--print-build-logs"];
        })

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
