{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "universe";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "scrumplex.net";
          extraFlags = ["--verbose" "--print-build-logs" "--use-substitutes"];
        })

        ../common
        ../common/netcup.nix
        ../common/nginx.nix
        ../common/pkgs
        ../common/podman.nix
        ../common/regional.nix
        ../common/server.nix
        ../common/upgrade.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
