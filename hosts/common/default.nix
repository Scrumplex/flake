{ config, ... }:

{
  imports = [
    ./boot.nix
    ./fish.nix
    ./gaming.nix
    ./misc.nix
    ./nix.nix
    ./pipewire.nix
    ./sway.nix
  ];

  home-manager.extraSpecialArgs = { systemConfig = config; };
}
