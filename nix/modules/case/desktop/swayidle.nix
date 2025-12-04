{lib, ...}: {
  flake.modules.homeManager."desktop" = {
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkEnableOption mkIf mkOption;
    cfg = config.services.swayidle;

    loginctl = lib.getExe' pkgs.systemd "loginctl";
    niri = lib.getExe config.programs.niri.package;
  in {
    options.services.swayidle.lockSession = mkEnableOption "locking session on idle" // mkOption {default = true;};

    config = {
      services.swayidle = {
        enable = true;
        extraArgs = ["-d"];

        events = {
          after-resume = "${niri} msg action power-on-monitors";
          before-sleep = mkIf cfg.lockSession "${loginctl} lock-session";
        };

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
