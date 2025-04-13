{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkAliasOptionModule;

  inherit (inputs) catppuccin home-manager nix-index-database scrumpkgs;

  username = "scrumplex";
in {
  imports = [
    (mkAliasOptionModule ["hm"] ["home-manager" "users" username])
    (mkAliasOptionModule ["primaryUser"] ["users" "users" username])

    home-manager.nixosModules.home-manager
  ];

  config = {
    age.secrets."passwd".file = ../../secrets/common/passwd.age;

    primaryUser = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."passwd".path;
      # TODO: roles!
      extraGroups =
        ["wheel" "audio" "video" "input" "dialout"]
        ++ optional config.networking.networkmanager.enable "networkmanager"
        ++ optional config.programs.adb.enable "adbusers"
        ++ optional config.virtualisation.libvirtd.enable "libvirtd"
        ++ optional config.virtualisation.podman.enable "podman";
    };
    nix.settings.trusted-users = [username];

    hm = {
      home.homeDirectory = config.users.users."${username}".home;
      home.username = username;

      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";

      home.stateVersion = config.system.stateVersion;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules =
        attrValues scrumpkgs.hmModules
        ++ [
          catppuccin.homeModules.catppuccin
          nix-index-database.hmModules.nix-index
        ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
