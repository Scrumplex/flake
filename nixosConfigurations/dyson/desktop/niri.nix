{...}: {
  hm.wayland.windowManager.niri.settings = {
    input.touchpad = {
      tap = {};
      natural-scroll = {};
    };

    _children = [
      {
        output = {
          _args = ["eDP-1"];
          scale = 1.25;
        };
      }
    ];
  };
}
