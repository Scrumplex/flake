{...}: {
  hm.wayland.windowManager.sway.config = {
    input."2362:628:PIXA3854:00_093A:0274_Touchpad" = {
      natural_scroll = "enabled";
      tap = "enabled";
      tap_button_map = "lrm";
    };

    output."BOE 0x095F Unknown" = {
      mode = "2256x1504@59.999Hz";
      position = "0,0";
      scale = "1.25";
    };
  };
}
