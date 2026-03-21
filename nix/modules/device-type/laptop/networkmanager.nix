{config, ...}: {
  flake.modules.nixos.laptop = {
    networking.networkmanager.enable = true;

    services.avahi.enable = true;

    users.users.${config.flake.meta.username}.extraGroups = ["networkmanager"];
  };
}
