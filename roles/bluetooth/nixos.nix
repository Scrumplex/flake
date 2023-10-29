{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.roles.bluetooth;
in {
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    hm.services.blueman-applet.enable = true;

    boot.extraModprobeConfig = ''
      # Fix Nintendo Switch Pro Controller disconnects
      options bluetooth disable_ertm=1
    '';
  };
}
