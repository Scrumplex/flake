{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "fornax";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "root@fornax.lan";
          extraFlags = ["--verbose" "--print-build-logs"];
        })
        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
