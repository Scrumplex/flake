{config, ...}: let
  swayConf = config.wayland.windowManager.sway.config;
  mod = swayConf.modifier;
in {
  services.clipman.enable = true;

  wayland.windowManager.sway.config.keybindings."${mod}+v" = let
    clipman = "${config.services.clipman.package}/bin/clipman";
    fuzzel = "${config.programs.fuzzel.package}/bin/fuzzel";
  in "exec ${clipman} pick --tool=CUSTOM --tool-args='${fuzzel} --dmenu'";
}
