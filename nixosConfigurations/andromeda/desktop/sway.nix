{...}: {
  hm.wayland.windowManager.sway.config = {
    input."13652:62728:pulsar_X2_V2" = {
      accel_profile = "adaptive";
      pointer_accel = "-1.0";
    };

    output = {
      "LG Electronics LG ULTRAGEAR 104MANJ7FL47" = {
        mode = "2560x1440@144Hz";
        position = "0,0";
        adaptive_sync = "on";
      };
      "Samsung Electric Company S24E650 H4ZJ803253" = {
        mode = "1920x1080@60Hz";
        position = "2560,0";
      };
    };
  };
}
