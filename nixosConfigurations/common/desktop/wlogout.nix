{
  config,
  lib,
  lib',
  pkgs,
  ...
}: {
  hm.catppuccin.wlogout.enable = true;
  hm.programs.wlogout = {
    enable = true;
    layout = let
      inherit (lib) getExe';
      systemctl = getExe' pkgs.systemd "systemctl";
      loginctl = getExe' pkgs.systemd "loginctl";
    in [
      {
        label = "shutdown";
        action = "${systemctl} poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "${systemctl} hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "${systemctl} suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "logout";
        action = "${loginctl} terminate-session";
        text = "Logout";
        keybind = "g";
      }
      {
        label = "reboot";
        action = "${systemctl} reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "lock";
        action = "${loginctl} lock-session";
        text = "Lock";
        keybind = "l";
      }
    ];
  };

  hm.programs.niri.settings.binds."Mod+Shift+E".action = config.hm.lib.niri.actions.spawn [(lib.getExe config.hm.programs.wlogout.package)];
}
