{
  fpConfig,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/boot
    ../common/home.nix

    ./disks.nix

    fpConfig.flake.modules.nixos.steam-deck
    fpConfig.flake.modules.nixos.ext-crashdump
  ];

  hardware.facter = {
    reportPath = ./facter.json;
    detected.dhcp.enable = false;
  };

  # TODO
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  services.desktopManager.plasma6.enable = true;
  jovian.steam.desktopSession = "plasma";

  environment.systemPackages = with pkgs; [
    dolphin-emu
    ryubing
  ];

  system.stateVersion = "24.11";
}
