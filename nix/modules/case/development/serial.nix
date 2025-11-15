{config, ...}: {
  flake.modules.nixos.development = {
    users.users.${config.flake.meta.username}.extraGroups = [
      "dialout"
    ];
  };
}
