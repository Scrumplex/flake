{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.lualine = {
      enable = true;
      settings.ignore_focus = [
        "alpha"
        "neo-tree"
        "Trouble"
      ];
    };
  };
}
