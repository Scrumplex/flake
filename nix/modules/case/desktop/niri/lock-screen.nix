{lib, ...}: {
  flake.modules.nixos."desktop" = {
    security.pam.services.noctalia = {};
  };

  flake.modules.homeManager."desktop" = {config, ...}: {
    home.sessionVariables."NOCTALIA_PAM_SERVICE" = "noctalia";

    programs.noctalia-shell.settings = {
      idle.lockTimeout = 300;
      general = {
        allowPasswordWithFprintd = true;
        autoStartAuth = true;
        compactLockScreen = false;
        enableLockScreenCountdown = true;
        enableLockScreenMediaControls = true;
        lockOnSuspend = true;
        lockScreenAnimations = true;
        lockScreenBlur = 0;
        lockScreenCountdownDuration = 10000;
        lockScreenMonitors = [];
        lockScreenTint = 0;
        passwordChars = false;
        showHibernateOnLockScreen = false;
        showSessionButtonsOnLockScreen = true;
      };
    };

    programs.niri.settings.binds = {
      "Mod+Ctrl+Q" = {
        hotkey-overlay.title = "Lock Session";
        action = config.lib.niri.actions.spawn [(lib.getExe config.programs.noctalia-shell.package) "ipc" "call" "lockScreen" "lock"];
      };
    };
  };
}
