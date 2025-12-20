{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      folding.enable = false;
      settings.indent.enable = true;
    };
  };
}
