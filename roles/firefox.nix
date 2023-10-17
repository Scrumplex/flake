{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.roles.firefox;
in {
  options.roles.firefox = {
    enable = mkEnableOption "firefox role";
  };

  config.hm = mkIf cfg.enable {
    programs.firefox.enable = true;

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };

    programs.browserpass.enable = mkDefault config.hm.programs.password-store.enable;
    programs.browserpass.browsers = ["firefox"];
  };
}
