{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Berlin";
  i18n.defaultLocale = "en_IE.UTF-8";
  console.keyMap = "us";
}
