{
  services.udev.extraRules = ''
    # Disable wake up from Pulsar X2V2
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f507", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f508", ATTR{power/wakeup}="disabled"
  '';

  hm.programs.niri.settings.input.mouse = {
    accel-profile = "adaptive";
    accel-speed = -1.;
  };
}
