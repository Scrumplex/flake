{config, ...}: {
  flake.aspects."desktop"._."pipewire".nixos = {
    security.rtkit.enable = true;
    users.users.${config.flake.meta.username}.extraGroups = ["rtkit"];
  };
}
