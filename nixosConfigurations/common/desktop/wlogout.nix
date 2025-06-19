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
      swaymsg = getExe' config.hm.wayland.windowManager.sway.package "swaymsg";
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
        action = "${swaymsg} exit";
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

  hm.wayland.windowManager.sway.config.keybindings = lib'.sway.mkExec "${config.hm.wayland.windowManager.sway.config.modifier}+Shift+E" (lib.getExe config.hm.programs.wlogout.package);
}
