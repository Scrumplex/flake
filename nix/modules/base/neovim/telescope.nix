{
  flake.modules.nixos.base.programs.nixvim = {
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>b" = "buffers";
        "<leader> " = "resume";
        "<leader>f" = "git_files";
        "<leader>g" = "live_grep";
      };
    };
  };
}
