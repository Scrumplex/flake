{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
  inherit (lib.modules) mkAliasOptionModule;

  cfg = config.roles.base;
in {
  imports = [
    (mkAliasOptionModule ["roles" "base" "user"] ["users" "users" cfg.username])
  ];
  config = {
    roles.base.user.isNormalUser = true;

    roles.base.user.extraGroups = optional cfg.enableAdmin "wheel";

    hm = {
      home.homeDirectory = config.users.users."${cfg.username}".home;

      systemd.user.startServices = "sd-switch";

      home.stateVersion = config.system.stateVersion;
    };
  };
}
