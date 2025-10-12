{config, ...}: {
  flake.modules.nixos.desktop = {
    security.rtkit.enable = true;
    users.users.${config.flake.meta.username}.extraGroups = ["rtkit"];
  };
}
