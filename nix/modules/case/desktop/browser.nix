{
  flake.modules.homeManager."desktop" = {
    programs.chromium.enable = true;

    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };

    wayland.windowManager.niri.settings._children = [
      {
        window-rule = {
          _children = [
            {
              match._props = {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              };
            }
          ];
          open-floating = true;
        };
      }
    ];
  };
}
