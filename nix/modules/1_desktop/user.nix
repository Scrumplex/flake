{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.desktop = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    users.users.${config.flake.meta.username} = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$JbosTEvX3uH6.mFV/Sz071$6vVkITFq4INQFdf51.guqaD68JWp6ZcVNGVfPqqIzL/";

      extraGroups = [
        "wheel"
        "audio"
        "video"
        "input"
        "dialout"
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

  flake.modules.homeManager.desktop = {osConfig, ...}: {
    home.stateVersion = osConfig.system.stateVersion;
  };
}
