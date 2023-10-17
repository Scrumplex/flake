{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  cfg = config.roles.base;
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

  config = {
    assertions = [
      {
        assertion = cfg.username != null;
        message = "base role username has to be set";
      }
    ];

    roles.base.user.isNormalUser = true;

    roles.base.user.extraGroups = optional cfg.enableAdmin "wheel";
    nix.settings.trusted-users = optional cfg.enableAdmin cfg.username;

    hm = {
      home.username = cfg.username;
      home.homeDirectory = config.users.users."${cfg.username}".home;

      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";

      home.stateVersion = config.system.stateVersion;
    };
  };
}
