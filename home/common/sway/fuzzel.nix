{
  config,
  pkgs,
  ...
}: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "Monocraft:size=13";
        terminal = "${pkgs.kitty}/bin/kitty";
      };
      colors = with config.theme.colors; {
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

  wayland.windowManager.sway.config.menu = "${config.programs.fuzzel.package}/bin/fuzzel";

  programs.password-store.package =
    pkgs.pass-wayland.override {dmenu-wayland = pkgs.fuzzel-dmenu-shim;};
}
