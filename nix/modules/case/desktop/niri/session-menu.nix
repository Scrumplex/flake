{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    programs.noctalia-shell.settings.sessionMenu = {
      countdownDuration = 3000;
      enableCountdown = true;
      largeButtonsLayout = "grid";
      largeButtonsStyle = true;
      position = "center";
      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "l";
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "p";
        }
        {
          action = "hibernate";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "h";
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "r";
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "e";
        }
        {
          action = "shutdown";
          command = "systemctl poweroff";
          countdownEnabled = true;
          enabled = true;
          keybind = "s";
        }
      ];
      showHeader = true;
      showKeybinds = true;
    };

    programs.niri.settings.binds."Mod+Shift+E".action = config.lib.niri.actions.spawn [(lib.getExe config.programs.noctalia-shell.package) "ipc" "call" "sessionMenu" "toggle"];
  };
}
