{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) optional;

  cfg = config.roles.base;
in {
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
