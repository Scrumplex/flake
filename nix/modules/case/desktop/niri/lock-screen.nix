{lib, ...}: {
  flake.modules.nixos."desktop" = {
    security.pam.services.noctalia = {};
  };

  flake.modules.homeManager."desktop" = {config, ...}: {
    home.sessionVariables."NOCTALIA_PAM_SERVICE" = "noctalia";

    programs.noctalia.settings = {
      idle.pre_action_fade_seconds = 0;
      idle.behavior = {
        lock-and-suspend = {
          action = "lock_and_suspend";
          enabled = true;
          timeout = 300;
        };
        screen-off = {
          enabled = true;
          action = "screen_off";
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
