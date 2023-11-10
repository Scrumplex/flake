{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nix-darwin;
in {
  flake.darwinConfigurations = {
    T00179100c = nix-darwin.lib.darwinSystem {
      modules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nixpkgs.hostPlatform = "aarch64-darwin";
        }

        (import ../roles "darwin")
        ../host/T00179100c
      ];

      inherit inputs;
    };
  };
}
