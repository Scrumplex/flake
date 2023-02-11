{ config, pkgs, ... }:

{
  imports = [ ./boot.nix ./fish.nix ./misc.nix ./nix.nix ];
}
