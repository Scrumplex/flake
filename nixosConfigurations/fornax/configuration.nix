{
  fpConfig,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/boot
    ../common/home.nix

    ./disks.nix

    fpConfig.flake.modules.nixos.steam-deck

    inputs.nixos-facter-modules.nixosModules.facter
  ];

  facter.reportPath = ./facter.json;

  # TODO
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  environment.systemPackages = with pkgs; [
    dolphin-emu
    ryubing
  ];

  system.stateVersion = "24.11";
}
