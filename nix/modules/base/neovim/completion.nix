{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;
      settings.keymap.preset = "super-tab";
    };
  };
}
