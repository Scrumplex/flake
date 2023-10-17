{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.bluetooth;
in {
  options.roles.bluetooth = {
    enable = mkEnableOption "bluetooth role";
  };

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
