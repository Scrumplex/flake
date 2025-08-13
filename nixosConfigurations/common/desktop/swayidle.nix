{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.profile.swayidle;

  loginctl = lib.getExe' pkgs.systemd "loginctl";
  niri = lib.getExe config.programs.niri.package;
in {
  options.profile.swayidle.lockSession = mkEnableOption "locking session on idle" // mkOption {default = true;};

  config = {
    hm = {
      services.swayidle = {
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
              command = "${niri} msg action power-on-monitors";
            }
          ];
        timeouts = [
          {
            timeout = 120;
            command = "${niri} msg action power-off-monitors";
            resumeCommand = "${niri} msg action power-on-monitors";
          }
          {
            timeout = 600;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
  };
}
