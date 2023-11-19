{
  flake.nixosModules = {
    swayProfile = ./profiles/sway/default.nix;
    swayGtklockProfile = ./profiles/sway/gtklock.nix;
  };
}
