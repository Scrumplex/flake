{
  config,
  lib,
  ...
}: let
  inherit (builtins) hasAttr;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkAliasOptionModule mkDefault mkIf mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  cfg = config.roles.base;

  isNixOS = hasAttr "nixos" config.system;
in {
  options.roles.base = {
    username = mkOption {
      type = with types; str;
      example = "dave";
      description = ''
        Username of the primary user on this system.
      '';
    };

    enableAdmin = mkEnableOption "admin permissions for the primary user" // {default = true;};
  };

  imports = [
    (mkAliasOptionModule ["hm"] ["home-manager" "users" cfg.username])
    (mkAliasOptionModule ["roles" "base" "user"] ["users" "users" cfg.username])
  ];

  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.username != null;
          message = "base role username has to be set";
        }
      ];

      nix.settings.trusted-users = optional cfg.enableAdmin cfg.username;

      hm = {
        home.username = cfg.username;

        programs.home-manager.enable = true;

        home.stateVersion = mkDefault config.system.stateVersion;
      };
    }
    (mkIf isNixOS {
      roles.base.user.isNormalUser = true;

      roles.base.user.extraGroups = optional cfg.enableAdmin "wheel";

      hm = {
        home.homeDirectory = config.users.users."${cfg.username}".home;

        systemd.user.startServices = "sd-switch";
      };
    })
  ];
}
