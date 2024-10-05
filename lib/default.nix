{inputs, ...}: {
  _module.args.lib' = {
    mkHost = {
      hostName,
      modules,
    }: {
      "${hostName}" = inputs.nixpkgs.lib.nixosSystem {
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
    mkDeploy = {
      targetHost,
      extraFlags,
    }: {
      _module.args.deploy = {
        inherit targetHost extraFlags;
      };
    };
  };
}
