{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    programs.niri.settings = {
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      binds = {
        "Print".action = inputs.niri.lib.kdl.magic-leaf "screenshot";
        "Shift+Print".action = inputs.niri.lib.kdl.magic-leaf "screenshot-window";
        "Mod+Print".action = inputs.niri.lib.kdl.magic-leaf "screenshot-screen";
      };
    };
  };
}
