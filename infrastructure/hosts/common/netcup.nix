{
  config,
  lib,
  ...
}: {
  options.netcup.bootMode = lib.mkOption {
    type = lib.types.enum ["uefi" "legacy"];
    default = "legacy";
  };

  config = lib.mkMerge [
    {
      networking = {
        useDHCP = false;
        interfaces.ens3.useDHCP = true;
      };

      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "de";
    }

    (lib.mkIf (config.netcup.bootMode == "uefi") {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    })

    (lib.mkIf (config.netcup.bootMode == "legacy") {
      boot.loader.grub = {
        enable = true;
        device = "/dev/sda";
      };
    })
  ];
}
