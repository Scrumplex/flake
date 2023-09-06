{
  config,
  lib,
  ...
}: {
  services.blueman.enable = lib.mkDefault (config.system.role.desktop && config.hardware.bluetooth.enable);

  boot.extraModprobeConfig = ''
    # Fix Nintendo Switch Pro Controller disconnects
    options bluetooth disable_ertm=1
  '';
}
