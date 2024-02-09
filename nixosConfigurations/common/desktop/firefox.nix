{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  hm = {
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

    wayland.windowManager.hyprland.settings.windowrulev2 = [
      "float, class:^firefox$, title:^Picture-in-Picture$"
      "pin, class:^firefox$, title:^Picture-in-Picture$"
    ];
  };
}
