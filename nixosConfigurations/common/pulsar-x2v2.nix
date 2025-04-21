{
  services.udev.extraRules = ''
    # Disable wake up from Pulsar X2V2
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f507", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f508", ATTR{power/wakeup}="disabled"
  '';

  hm.wayland.windowManager.sway.config.input = {
    "13652:62728:pulsar_X2_V2" = {
      accel_profile = "adaptive";
      pointer_accel = "-1.0";
    };
    "13652:62727:pulsar_X2_V2" = {
      accel_profile = "adaptive";
      pointer_accel = "-1.0";
    };
  };
}
