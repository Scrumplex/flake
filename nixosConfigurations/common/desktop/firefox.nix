{...}: {
  hm = {
    programs.firefox.enable = true;

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };

    wayland.windowManager.hyprland.settings.windowrulev2 = [
      "float, class:^firefox$, title:^Picture-in-Picture$"
      "pin, class:^firefox$, title:^Picture-in-Picture$"
    ];
  };
}
