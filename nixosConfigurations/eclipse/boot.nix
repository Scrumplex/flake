{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  hardware.mcelog.enable = true;
  hardware.enableRedistributableFirmware = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    binfmt.emulatedSystems = ["aarch64-linux"];

    loader.systemd-boot.enable = true;
    loader.systemd-boot.edk2-uefi-shell.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd = {
      extraUtilsCommands = ''
        # Put thin-provisioning-tools into extra-utils and patch lvm accordingly.
        # NOTE: this works only because thin-provisioning-tools string, including
        # version, is longer than extra-utils string. The difference is zeroed. If
        # it would be vice versa there is a chance it would not work because the
        # stuff after the full path to the tool would be overwritten. Although there
        # seem to be some other, documentation, string just behind the full path
        # name which might not be that important... Anyways, not spending time
        # to figure out how to avoid the patching in case it is not possible doing
        # the proper way.
        for BIN in ${pkgs.thin-provisioning-tools}/bin/*; do
          copy_bin_and_libs $BIN
          SRC="(?<all>/[a-zA-Z0-9/]+/[0-9a-z]{32}-[0-9a-z-.]+(?<exe>/bin/$(basename $BIN)))"
          REP="\"$out\" . \$+{exe} . \"\\x0\" x (length(\$+{all}) - length(\"$out\" . \$+{exe}))"
          PRP="s,$SRC,$REP,ge"
          ${pkgs.perl}/bin/perl -p -i -e "$PRP" $out/bin/lvm
        done
      '';
      extraUtilsCommandsTest = ''
        # The thin-provisioning-tools use pdata_tools binary as a link target of
        # supported utils so it is enough to check only one, the others should
        # "just" work...
        $out/bin/pdata_tools cache_check -V
      '';
      availableKernelModules = ["dm_persistent_data" "dm_bio_prison" "dm_bufio" "crc32c_generic" "dm_cache_smq"];
      kernelModules = [
        "dm-raid"
        "dm-cache"
      ];
    };
  };
  powerManagement = {
    cpuFreqGovernor = "powersave";
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
