{lib, ...}: {
  flake.modules.nixos."desktop" = {
    security.pam.services.noctalia = {};
  };

  flake.modules.homeManager."desktop" = {config, ...}: {
    home.sessionVariables."NOCTALIA_PAM_SERVICE" = "noctalia";

    programs.noctalia.settings = {
      idle.behavior = {
        lock = {
          enabled = true;
          command = "noctalia:session lock";
          timeout = 300;
        };
        screen-off = {
          enabled = true;
          command = "noctalia:dpms-off";
          resume = "noctalia:dpms-on";
          timeout = 120;
        };
      };
    };

    programs.niri.settings.binds = {
      "Mod+Ctrl+Q" = {
        hotkey-overlay.title = "Lock Session";
        action = config.lib.niri.actions.spawn [(lib.getExe config.programs.noctalia.package) "msg" "session" "lock"];
      };
    };
  };
}
