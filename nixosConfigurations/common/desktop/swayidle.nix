{
  config,
  lib,
  pkgs,
  ...
}: {
  hm.services.swayidle = let
    hyprctl = lib.getExe' config.hm.wayland.windowManager.hyprland.finalPackage "hyprctl";
    gtklock = "${lib.getExe pkgs.gtklock} -d";
  in {
    enable = true;
    extraArgs = ["-d"];
    events = [
      {
        event = "before-sleep";
        command = "${gtklock}; ${hyprctl} dispatch dpms off";
      }
      {
        event = "after-resume";
        command = "${hyprctl} dispatch dpms on";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }
    ];
  };
}
