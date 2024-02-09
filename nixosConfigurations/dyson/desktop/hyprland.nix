{...}: {
  imports = [./poweralertd.nix ./swayidle.nix];

  hm.wayland.windowManager.hyprland.settings = {
    "device:hp,-inc-hyperx-pulsefire-haste-2".sensitivity = -1.0;
    "monitor" = [
      "desc:BOE 0x095F Unknown,2256x1504@59.999Hz,0x0,1.25"
    ];
  };
}
