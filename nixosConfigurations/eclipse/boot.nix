{pkgs, ...}: {
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
  };

  systemd.services."hdd-powersave" = {
    description = "Apply powersave options to HDDs";
    after = ["local-fs.target"];
    wantedBy = ["local-fs.target"];

    path = [pkgs.hdparm];
    script = ''
      for serial in WX32DC0HKLT1 WX32DC08D8PA WX32DC0HK3TR WX32DC06YKVX; do
        hdparm -S 60 /dev/disk/by-id/ata-WDC_WD20EFZX-68AWUN0_WD-"$serial"
      done
    '';

    serviceConfig.Type = "oneshot";
  };
}
