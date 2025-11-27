{
  flake.modules.nixos.development.programs.nixvim = {
    plugins.lsp = {
      enable = true;
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
          "<leader>e" = "open_float";
          "<leader>q" = "setloclist";
        };
        lspBuf = {
          "gD" = "declaration";
          "gd" = "definition";
          "gi" = "implementation";
          "gr" = "references";
          "K" = "hover";
          "<C-k>" = "signature_help";
          "<leader>wa" = "add_workspace_folder";
          "<leader>wr" = "remove_workspace_folder";
          "<leader>D" = "type_definition";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          #"<leader>f" = "formatting"; ?
        };
      };

      servers = {
        astro.enable = true;
        bashls.enable = false;
        clangd.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        harper_ls.enable = true;
        helm_ls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        nixd.enable = true;
        pylsp.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installRustc = false;
          installCargo = false;
        };
        tailwindcss.enable = true;
        terraformls.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
      };
    };
  };
}
