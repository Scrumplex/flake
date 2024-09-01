{
  config,
  lib,
  pkgs,
  ...
}: {
  hm.services.swayidle = let
    swaymsg = "${config.hm.wayland.windowManager.sway.package}/bin/swaymsg";
    loginctl = lib.getExe' pkgs.systemd "loginctl";
  in {
    enable = true;
    extraArgs = ["-d"];
    events = [
      {
        event = "before-sleep";
        command = "${loginctl} lock-session; ${swaymsg} 'output * power on'";
      }
      {
        event = "after-resume";
        command = "${swaymsg} 'output * power on'";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
    ];
  };
  hm.systemd.user.services."swayidle" = {
    Unit.After = ["graphical-session.target"];
    Service.Slice = ["background-graphical.target"];
  };
}
