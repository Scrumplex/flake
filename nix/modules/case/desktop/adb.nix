{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = [pkgs.android-tools];

    users.users.${config.flake.meta.username}.extraGroups = ["adbusers"];
  };
}
