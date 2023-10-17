{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
in {
  imports = [
    ./boot.nix
    ./bluetooth.nix
    ./desktop.nix
    ./fish.nix
    ./misc.nix
    ./nix.nix
    ./nvd.nix
    ./pipewire.nix
    ./pkgs
    ./regional.nix
    ./utils.nix
  ];

  options.system.role = {
    home = mkEnableOption "headless machine role";
    desktop = mkEnableOption "headless machine role";
    gaming = mkEnableOption "headless machine role";
  };

  config.assertions = [
    {
      assertion = config.system.role.gaming -> config.system.role.desktop;
      message = "The gaming role is only supported on systems with the desktop role";
    }
  ];
}
