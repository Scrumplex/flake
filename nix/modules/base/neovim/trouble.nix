{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.trouble.enable = true;

    keymaps = [
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        mode = "n";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];
  };
}
