{...}: {
  hm.wayland.windowManager.sway.config = {
    input = {
      "13652:62728:pulsar_X2_V2" = {
        accel_profile = "adaptive";
        pointer_accel = "-1.0";
      };
      "13652:62727:pulsar_X2_V2" = {
        accel_profile = "adaptive";
        pointer_accel = "-1.0";
      };
      "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
        natural_scroll = "enabled";
        tap = "enabled";
        tap_button_map = "lrm";
      };
    };

    output = {
      "BOE 0x095F Unknown" = {
        mode = "2256x1504@59.999Hz";
        position = "0,0";
        scale = "1.25";
      };
    };
  };
}
