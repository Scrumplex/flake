{
  config,
  lib,
  ...
}: {
  hm = {
    programs.fuzzel = {
      enable = true;

      settings = {
        main.font = "Monocraft:size=13";
        colors = with config.hm.theme.colors; {
          background = "${surface0}ff";
          text = "${text}ff";
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
