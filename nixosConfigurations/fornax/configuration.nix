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

  jovian = {
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
    };
    steam = {
      enable = true;
      autoStart = true;
      user = "scrumplex";
    };
    decky-loader.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dolphin-emu
    ryujinx
    torzu
  ];

  system.stateVersion = "24.11";
}
