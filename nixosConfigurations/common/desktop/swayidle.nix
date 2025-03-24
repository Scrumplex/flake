{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.profile.swayidle;

  swaymsg = "${config.hm.wayland.windowManager.sway.package}/bin/swaymsg";
  loginctl = lib.getExe' pkgs.systemd "loginctl";
in {
  options.profile.swayidle.lockSession = mkEnableOption "locking session on idle" // mkOption {default = true;};

  config = {
    hm.services.swayidle = {
      enable = true;
      extraArgs = ["-d"];
      events =
        lib.optionals cfg.lockSession [
          {
            event = "before-sleep";
            command = "${loginctl} lock-session";
          }
        ]
        ++ [
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
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
    hm.systemd.user.services."swayidle" = {
      Unit.After = ["graphical-session.target"];
      Service.Slice = ["background-graphical.target"];
    };
  };
}
