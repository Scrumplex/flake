{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nix-darwin scrumpkgs;
in {
  flake.darwinConfigurations = {
    T00179100c = nix-darwin.lib.darwinSystem {
      modules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nixpkgs.hostPlatform = "aarch64-darwin";
        }

        ./T00179100c
      ];

      specialArgs = {
        inherit inputs;
        lib' = scrumpkgs.lib;
      };
    };
  };
}
