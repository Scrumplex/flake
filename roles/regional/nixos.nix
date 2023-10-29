{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.roles.regional;
in {
  config = mkIf cfg.enable {
    time.timeZone = mkDefault "Europe/Berlin";
    i18n.defaultLocale = "en_IE.UTF-8";
    i18n.supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_IE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    console.keyMap = "us";
  };
}
