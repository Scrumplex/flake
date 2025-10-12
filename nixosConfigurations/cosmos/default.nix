{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "cosmos";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "root@cosmos.lan";
          extraFlags = ["--verbose" "--print-build-logs"];
        })

        ../common
        ../common/pkgs
        ../common/regional.nix
        ../common/remote-build-provider.nix
        ../common/server.nix
        ../common/traefik.nix
        ../common/upgrade.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
