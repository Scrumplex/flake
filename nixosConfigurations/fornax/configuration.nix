{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/boot
    ../common/home.nix
    ../common/nix.nix
    ../common/openssh.nix
    ../common/utils.nix

    ./disks.nix

    inputs.nixos-facter-modules.nixosModules.facter
    inputs.jovian.nixosModules.jovian
  ];

  facter.reportPath = ./facter.json;

  # TODO
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  jovian.devices.steamdeck.enable = true;
  jovian.steam.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.user = "scrumplex";
  jovian.decky-loader.enable = true;

  system.stateVersion = "24.11";
}
