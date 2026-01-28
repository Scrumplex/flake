{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.base = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    users.mutableUsers = false;

    users.users.${config.flake.meta.username} = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$JbosTEvX3uH6.mFV/Sz071$6vVkITFq4INQFdf51.guqaD68JWp6ZcVNGVfPqqIzL/";

      extraGroups = [
        "wheel"
      ];
    };

    nix.settings.trusted-users = [config.flake.meta.username];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.flake.meta.username} = {osConfig, ...}: {
        home = {
          username = config.flake.meta.username;
          homeDirectory = osConfig.users.users.${config.flake.meta.username}.home;
        };
      };
    };
  };

  flake.modules.homeManager.base = {osConfig, ...}: {
    home.stateVersion = osConfig.system.stateVersion;
  };
}
