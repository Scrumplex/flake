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
    primaryUser = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$.xFZ6PXXwF2ntgjscIIiE/$ck86smefjyF1RPhwaYRYf2rWRgpercSVeTBDnMggsr9";
      # TODO: roles!
      extraGroups =
        ["wheel" "audio" "video" "input" "dialout"]
        ++ optional config.networking.networkmanager.enable "networkmanager"
        ++ optional config.programs.adb.enable "adbusers"
        ++ optional config.programs.wireshark.enable "wireshark"
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
          catppuccin.homeManagerModules.catppuccin
          nix-index-database.hmModules.nix-index
        ];
      extraSpecialArgs = {
        inherit inputs;
        lib' = scrumpkgs.lib;
      };
    };
  };
}
