{config, ...}: {
  flake.modules.nixos.desktop = {
    programs.adb.enable = true;

    users.users.${config.flake.meta.username}.extraGroups = ["adbusers"];
  };
}
