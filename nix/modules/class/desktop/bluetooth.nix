{
  flake.modules.nixos.desktop = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    boot.extraModprobeConfig = ''
      # Fix Nintendo Switch Pro Controller disconnects
      options bluetooth disable_ertm=1
    '';
  };

  flake.modules.homeManager.desktop.services.blueman-applet.enable = true;
}
