{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "eclipse";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "eclipse.sefa.cloud";
          extraFlags = ["--verbose" "--print-build-logs" "--use-substitutes"];
        })

        ../common/server.nix
        ../common/upgrade.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
