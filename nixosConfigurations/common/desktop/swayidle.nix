{
  config,
  lib,
  pkgs,
  ...
}: {
  hm.services.swayidle = let
    swaymsg = "${config.hm.wayland.windowManager.sway.package}/bin/swaymsg";
    waylock = "${lib.getExe pkgs.waylock} -fork-on-lock";
  in {
    enable = true;
    extraArgs = ["-d"];
    events = [
      {
        event = "before-sleep";
        command = "${waylock}; ${swaymsg} 'output * power on'";
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
}
