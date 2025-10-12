{
  flake.modules.nixos.base = {
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_IE.UTF-8";
    i18n.supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_IE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    console.keyMap = "us";
  };
}
