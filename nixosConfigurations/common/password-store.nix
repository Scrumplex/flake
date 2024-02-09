{
  config,
  lib,
  ...
}: {
  hm.programs.password-store.enable = true;

  hm.wayland.windowManager.hyprland.settings.bind = [
    "$mod, P, exec, ${lib.getExe' config.hm.programs.password-store.package "passmenu"}"
  ];
}
