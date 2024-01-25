{...}: {
  imports = [./poweralertd.nix ./swayidle.nix];

  hm.wayland.windowManager.sway.config.output = {
    "BOE 0x095F Unknown" = {
      mode = "2256x1504@59.999Hz";
      position = "0,0";
      scale = "1.25";
    };
  };
}
