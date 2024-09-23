{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "universe";
    system = "x86_64-linux";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "scrumplex.net";
          extraFlags = ["--verbose" "--print-build-logs" "--use-substitutes"];
        })

        ../common
        ../common/netcup.nix
        ../common/nginx.nix
        ../common/nix.nix
        ../common/nix-index.nix
        ../common/nullmailer.nix
        ../common/postgres.nix
        ../common/server.nix
        ../common/upgrade.nix
        ../common/utils.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
