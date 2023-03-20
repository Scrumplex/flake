{
  config,
  lib,
  ...
}: {
  services.blueman.enable = lib.mkDefault config.hardware.bluetooth.enable;

  boot.extraModprobeConfig = ''
    # Fix Nintendo Switch Pro Controller disconnects
    options bluetooth disable_ertm=1
  '';
}
