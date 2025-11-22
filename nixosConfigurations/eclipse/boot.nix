{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  hardware.enableRedistributableFirmware = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    binfmt.emulatedSystems = ["aarch64-linux"];

    loader.systemd-boot.enable = true;
    loader.systemd-boot.edk2-uefi-shell.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  powerManagement = {
    cpuFreqGovernor = "ondemand";
    powertop.enable = true;
    powerUpCommands = let
      hdparm = getExe pkgs.hdparm;
      sleep = toString 60;
    in ''
      ${hdparm} -S ${sleep} /dev/disk/by-id/ata-WDC_WD20EFZX-68AWUN0_WD-WX32DC0HKLT1
      ${hdparm} -S ${sleep} /dev/disk/by-id/ata-WDC_WD20EFZX-68AWUN0_WD-WX32DC08D8PA
      ${hdparm} -S ${sleep} /dev/disk/by-id/ata-WDC_WD20EFZX-68AWUN0_WD-WX32DC0HK3TR
      ${hdparm} -S ${sleep} /dev/disk/by-id/ata-WDC_WD20EFZX-68AWUN0_WD-WX32DC06YKVX
    '';
  };
}
