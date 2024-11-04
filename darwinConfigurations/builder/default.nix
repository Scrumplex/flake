{inputs, ...}: {
  flake.darwinConfigurations = {
    builder = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        ./configuration.nix
      ];

      specialArgs = {
        inherit inputs;
      };
    };
  };
}
