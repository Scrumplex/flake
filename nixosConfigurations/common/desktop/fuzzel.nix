{
  config,
  lib,
  ...
}: {
  hm = {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "Monocraft:size=13";
          terminal = config.hm.wayland.windowManager.sway.config.terminal;
          launch-prefix = "uwsm app --";
        };
        colors = with config.hm.theme.colors; {
          background = "${surface0}ff";
          text = "${text}ff";
          prompt = "${text}ff";
          input = "${text}ff";
          match = "${blue}ff";
          selection = "${peach}ff";
          selection-text = "${base}ff";
          border = "${peach}ff";
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
