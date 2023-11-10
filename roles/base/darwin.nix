{inputs, ...}: let
  inherit (inputs) home-manager;
in {
  imports = [
    home-manager.darwinModules.home-manager
  ];
}
