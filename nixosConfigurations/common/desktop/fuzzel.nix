{
  config,
  lib,
  ...
}: {
  hm = {
    catppuccin.fuzzel = {
      enable = true;
      accent = "peach";
    };
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "Monocraft:size=13";
          terminal = config.hm.wayland.windowManager.sway.config.terminal;
          launch-prefix = "uwsm app --";
        };
        border = {
          width = 2;
          radius = 12;
        };
      };
    };

    wayland.windowManager.sway.config.menu = lib.getExe config.hm.programs.fuzzel.package;
  };
}
