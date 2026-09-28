{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.niri.settings = {
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      binds = {
        "Print".screenshot = {};
        "Shift+Print".screenshot-window = {};
        "Mod+Print".screenshot-screen = {};
      };
    };
  };
}
