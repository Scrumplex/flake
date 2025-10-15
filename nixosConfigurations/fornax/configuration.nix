{
  fpConfig,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/boot
    ../common/fish.nix
    ../common/neovim.nix
    ../common/home.nix

    ./disks.nix

    fpConfig.flake.modules.nixos.laptop

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
    ryubing
  ];

  system.stateVersion = "24.11";
}
