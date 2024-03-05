{
  config,
  lib,
  pkgs,
  ...
}: {
  hm = {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "Monocraft:size=13";
          terminal = "${pkgs.kitty}/bin/kitty";
        };
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

    wayland.windowManager.hyprland.settings.bind = [
      "$mod, D, exec, ${lib.getExe config.hm.programs.fuzzel.package}"
    ];
  };
}
