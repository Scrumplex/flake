{...}: {
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    useDHCP = false;
    interfaces.ens3 = {useDHCP = true;};
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";
}
