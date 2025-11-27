{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      folding = false;
      settings.indent.enable = true;
    };
  };
}
