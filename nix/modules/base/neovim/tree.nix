{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      settings.close_if_last_window = true;
    };
    keymaps = [
      {
        key = "<leader>t";
        action = "<cmd>Neotree reveal<CR>";
        mode = "n";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];
  };
}
