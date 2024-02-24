{inputs, ...}: {
  _module.args.lib' = {
    mkHost = {
      hostName,
      system,
      modules,
    }: {
      "${hostName}" = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            {networking = {inherit hostName;};}
          ]
          ++ modules;

        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
