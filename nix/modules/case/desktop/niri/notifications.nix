{lib, ...}: {
  flake.modules.homeManager."desktop" = {config, ...}: {
    programs.noctalia-shell.settings.notifications = {
      enabled = true;
      location = "top_right";
      enableMarkdown = true;
      backgroundOpacity = 0.9;
      sounds.enabled = true;
    };

    programs.niri.settings = {
      debug.honor-xdg-activation-with-invalid-serial = true;
      binds = with config.lib.niri.actions; {
        "Mod+Backspace".action = spawn [(lib.getExe config.programs.noctalia-shell.package) "ipc" "call" "notifications" "dismissAll"];
        "Mod+Shift+Backspace".action = spawn [(lib.getExe config.programs.noctalia-shell.package) "ipc" "call" "notifications" "toggleDND"];
      };
    };
  };
}
